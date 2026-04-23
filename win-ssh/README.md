# Using Windows OpenSSH Agent in WSL

This guide explains how to make WSL use the **Windows OpenSSH executables** and agent.  
The solution relies on symlinks to Windows binaries and a system‑wide profile script that adjusts `PATH`.

1. **Copy the script to your WSL system**  
   Copy the [`install-win-ssh.sh`](./install-win-ssh.sh) file to your WSL environment.  
   Make it executable:
   ```bash
   chmod +x install-win-ssh.sh
   ```

2. **Run the script with sudo**  
   The script requires elevated privileges to create `/usr/local/win-ssh` and write to `/etc/profile.d/`.  
   Execute:
   ```bash
   sudo ./install-win-ssh.sh
   ```

   This will:
   - Create `/usr/local/win-ssh` inside WSL.
   - Symlink Windows OpenSSH executables (`ssh.exe`, `ssh-add.exe`, etc.) into that directory without the `.exe` suffix.
   - Create `/etc/profile.d/wsl-ssh.sh` to prepend `/usr/local/win-ssh` to `PATH`.

3. **Restart your shell**  
   After installation, open a new WSL shell or re‑source your profile:
   ```bash
   source /etc/profile
   ```

4. **Verify the setup**  
   Confirm that WSL is now using Windows OpenSSH:
   ```bash
   which ssh
   ssh -V
   ssh-add -l
   ```
   You should see the Windows OpenSSH version and any identities loaded in the Windows `ssh-agent`.
