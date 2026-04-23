#!/bin/bash
# install-win-ssh.sh
# Automates symlinks to Windows OpenSSH and profile.d drop-in

set -e

TARGET_DIR="/usr/local/win-ssh"
PROFILE_SCRIPT="/etc/profile.d/wsl-ssh.sh"
WIN_SSH="/mnt/c/Windows/System32/OpenSSH"

echo "Creating target directory: $TARGET_DIR"
sudo mkdir -p "$TARGET_DIR"

echo "Linking Windows OpenSSH executables..."
for exe in ssh ssh-add ssh-agent scp sftp ssh-keygen ssh-keyscan; do
  sudo ln -sf "$WIN_SSH/${exe}.exe" "$TARGET_DIR/$exe"
done

echo "Creating profile.d script: $PROFILE_SCRIPT"
sudo tee "$PROFILE_SCRIPT" > /dev/null <<EOF
# Prepend Windows OpenSSH shims to PATH
export PATH=$TARGET_DIR:\$PATH
EOF

echo "Done. Restart your shell to apply changes."

