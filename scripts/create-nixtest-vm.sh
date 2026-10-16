#!/usr/bin/env bash
#
# create-nixtest-vm.sh
#
# Build a NixOS disk image from this repo's flake and boot it as a Lima VM
# named "nixtest", destroying any prior instance of the same name first.
#
# This is meant for fast iteration on a Nix-based dev environment: the VM's
# entire configuration (users, packages, services, ssh, etc.) is defined by
# the flake's `nixosConfigurations.<NIXOS_CONFIG>` output, so "provisioning"
# is just building that config into an image and starting it. There is no
# separate cloud-init/shell provisioning script to keep in sync.
#
# Prerequisites this expects from the repo's NixOS host config
# (e.g. hosts/nixtest/default.nix), since Lima needs a way to inject its SSH
# key and metadata on first boot:
#   - services.cloud-init.enable = true;
#   - services.cloud-init.network.enable = true;
#   - The NoCloud datasource must be usable (this is cloud-init's default).
#   - openssh.enable = true; with PasswordAuthentication off is recommended.
#   - A user account matching $LIMA_SSH_USER (default: your local $USER)
#     with a wheel/sudo NOPASSWD entry, since Lima manages the guest over SSH.
#
# Usage:
#   scripts/create-nixtest-vm.sh
#
# Environment overrides:
#   NIXOS_CONFIG   - nixosConfigurations attribute name (default: nixtest)
#   IMAGE_VARIANT  - system.build.images.<variant> to build (default: qcow-efi)
#   VM_NAME        - Lima instance name (default: nixtest)
#   VM_CPUS        - vCPUs for the VM (default: 4)
#   VM_MEMORY      - memory for the VM (default: 8GiB)
#   VM_DISK        - disk size for the VM (default: 60GiB)

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

NIXOS_CONFIG="${NIXOS_CONFIG:-nixtest}"
IMAGE_VARIANT="${IMAGE_VARIANT:-qcow-efi}"
VM_NAME="${VM_NAME:-nixtest}"
VM_CPUS="${VM_CPUS:-4}"
VM_MEMORY="${VM_MEMORY:-8GiB}"
VM_DISK="${VM_DISK:-60GiB}"
LIMA_SSH_USER="${LIMA_SSH_USER:-$USER}"

for cmd in nix limactl; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "error: required command '$cmd' not found in PATH" >&2
    exit 1
  fi
done

case "$(uname -m)" in
  arm64|aarch64) GUEST_ARCH="aarch64" ;;
  x86_64|amd64)  GUEST_ARCH="x86_64" ;;
  *)
    echo "error: unsupported host architecture $(uname -m)" >&2
    exit 1
    ;;
esac

WORK_DIR="$(mktemp -d /tmp/nixtest-lima.XXXXXX)"
trap 'rm -rf "$WORK_DIR"' EXIT

echo "==> Building NixOS image '${IMAGE_VARIANT}' from ${REPO_DIR}#${NIXOS_CONFIG}"
IMAGE_LINK="${WORK_DIR}/image"
nix build \
  --print-build-logs \
  -o "$IMAGE_LINK" \
  "${REPO_DIR}#nixosConfigurations.${NIXOS_CONFIG}.config.system.build.images.${IMAGE_VARIANT}"

IMAGE_PATH="$(find -L "$IMAGE_LINK" -maxdepth 1 -type f -name '*.qcow2' -print -quit)"
if [[ -z "$IMAGE_PATH" ]]; then
  echo "error: no .qcow2 file found in build output ${IMAGE_LINK}" >&2
  exit 1
fi
echo "==> Built image: ${IMAGE_PATH}"

LIMA_YAML="${WORK_DIR}/nixtest.yaml"
cat > "$LIMA_YAML" <<EOF
vmType: "qemu"
arch: "${GUEST_ARCH}"
images:
  - location: "${IMAGE_PATH}"
    arch: "${GUEST_ARCH}"
cpus: ${VM_CPUS}
memory: "${VM_MEMORY}"
disk: "${VM_DISK}"
mounts:
  - location: "${REPO_DIR}"
    writable: true
mountType: "virtiofs"
ssh:
  loadDotSSHPubKeys: true
user:
  name: "${LIMA_SSH_USER}"
containerd:
  system: false
  user: false
EOF

if limactl list --quiet 2>/dev/null | grep -qx "$VM_NAME"; then
  echo "==> Deleting existing Lima instance '${VM_NAME}'"
  limactl stop --force "$VM_NAME" >/dev/null 2>&1 || true
  limactl delete --force "$VM_NAME"
fi

echo "==> Starting Lima instance '${VM_NAME}'"
limactl start --name="$VM_NAME" --tty=false "$LIMA_YAML"

echo "==> Done. Connect with: limactl shell ${VM_NAME}"
