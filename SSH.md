# SSH Key Management Guide

## Generating a Simple SSH Key Pair

SSH (Secure Shell) keys provide a secure way to authenticate with remote servers without using passwords. Here's how to generate a basic SSH key pair:

1. Open your terminal
2. Run the following command:
   ```bash
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```
3. When prompted for a file location, press Enter to accept the default location (`~/.ssh/id_ed25519`)
4. You'll be asked to enter a passphrase (optional but recommended for security)
5. Two files will be generated:
   - `id_ed25519`: Your private key (keep this secure and never share it)
   - `id_ed25519.pub`: Your public key (can be shared with servers)
6. Add your key to the SSH agent:
   ```bash
   eval "$(ssh-agent -s)"
   ssh-add ~/.ssh/id_ed25519
   ```
7. Copy your public key to share with services like GitHub:
   ```bash
   cat ~/.ssh/id_ed25519.pub | pbcopy  # On macOS
   # OR
   cat ~/.ssh/id_ed25519.pub | clip  # On linux (aliased command, see ./.config/fish/config.fish)
   # OR
   cat ~/.ssh/id_ed25519.pub  # Copy the output manually
   ```

## Isolating Work and Personal SSH Keys

When you need to manage multiple SSH keys (e.g., for work and personal accounts), follow these steps:

1. Generate separate keys with descriptive names:
   ```bash
   # Personal key
   ssh-keygen -t ed25519 -C "personal_email@example.com" -f ~/.ssh/personal_key

   # Work key
   ssh-keygen -t ed25519 -C "work_email@example.com" -f ~/.ssh/work_key
   ```

2. Create or edit your SSH config file:
   ```bash
   touch ~/.ssh/config
   chmod 600 ~/.ssh/config  # Set proper permissions
   ```

3. Configure your SSH config file to use different keys for different hosts:
   ```
   # Personal GitHub account
   Host personal-github 
       HostName github.com
       User git
       IdentityFile ~/.ssh/personal_key
       IdentitiesOnly yes

   # Work GitHub account
   Host work-github
       HostName github.com
       User git
       IdentityFile ~/.ssh/work_key
       IdentitiesOnly yes
   ```

4. When cloning repositories, use the appropriate host alias:
   ```bash
   # For personal repositories
   git clone personal-github:username/repo.git

   # For work repositories
   git clone work-github:company/repo.git
   ```

5. Add both keys to your SSH agent:
   ```bash
   ssh-add ~/.ssh/personal_key
   ssh-add ~/.ssh/work_key
   ```

## Setting Up SSH Host Aliases

SSH host aliases allow you to create shortcuts for connecting to frequently used servers and customize connection settings.

### Benefits of SSH Host Aliases:

1. **Simplified connections**: Use short, memorable names instead of typing full hostnames
2. **Automatic username selection**: No need to specify the username each time
3. **Port forwarding configuration**: Set up local or remote port forwarding automatically
4. **Key management**: Specify which key to use for each host
5. **Connection options**: Set custom options like timeout values or compression

### Setting Up Host Aliases:

1. Edit your SSH config file:
   ```bash
   nano ~/.ssh/config
   ```

2. Set proper permissions for your SSH config file:
   ```bash
   chmod 600 ~/.ssh/config
   ```
   
   > **Important**: The `chmod 600` command restricts file permissions to read and write for the owner only. This is crucial for SSH security as it prevents other users on the system from reading your SSH configuration, which may contain sensitive information like hostnames, usernames, and paths to private keys. SSH will refuse to use config files with lax permissions.

3. Add host configurations with the following format:
   ```
   Host alias-name
       HostName actual-hostname-or-ip
       User username
       Port port-number
       IdentityFile ~/.ssh/specific_key
       # Other options as needed
   ```

4. Example configurations:
   ```
   # Development server
   Host dev
       HostName dev-server.example.com
       User developer
       Port 22
       IdentityFile ~/.ssh/work_key

   # Production server with non-standard port
   Host prod
       HostName 203.0.113.10
       User admin
       Port 2222
       IdentityFile ~/.ssh/work_key

   # Jump host configuration
   Host jump-host
       HostName jump.example.com
       User jumpuser
       ForwardAgent yes

   # Host behind a jump host
   Host internal
       HostName 10.0.0.5
       User internaluser
       ProxyJump jump-host
   ```

5. Connect using the aliases:
   ```bash
   ssh dev
   ssh prod
   ssh internal
   ```

### Advanced SSH Config Options:

- `ForwardAgent yes`: Forward your SSH keys to the remote server
- `ProxyJump host`: Connect through a jump host
- `ServerAliveInterval 60`: Send a keep-alive packet every 60 seconds
- `Compression yes`: Enable compression for slow connections
- `AddKeysToAgent yes`: Automatically add keys to the SSH agent

By properly configuring your SSH setup with multiple keys and host aliases, you can maintain separation between work and personal environments while simplifying your workflow.

## Authorizing SSH Keys on Remote Servers

After generating your SSH key pair, you need to authorize your public key on remote servers to enable passwordless authentication:

### Manual Authorization

1. Copy your public key to the clipboard:
   ```bash
   cat ~/.ssh/id_ed25519.pub | clip  # On Linux with clip alias
   # OR
   cat ~/.ssh/id_ed25519.pub  # Copy the output manually
   ```

2. Connect to the remote server with password authentication:
   ```bash
   ssh username@remote-server
   ```

3. Create the `.ssh` directory if it doesn't exist:
   ```bash
   mkdir -p ~/.ssh
   chmod 700 ~/.ssh
   ```

4. Add your public key to the authorized_keys file:
   ```bash
   echo "YOUR_PUBLIC_KEY_HERE" >> ~/.ssh/authorized_keys
   chmod 600 ~/.ssh/authorized_keys
   ```

### Using ssh-copy-id (Easier Method)

The `ssh-copy-id` utility automates the process of copying and installing your public key:

```bash
ssh-copy-id -i ~/.ssh/id_ed25519 username@remote-server
```

This command:
- Connects to the remote server using password authentication
- Creates the `.ssh` directory if needed
- Adds your public key to `~/.ssh/authorized_keys`
- Sets the correct permissions

### For Multiple Keys

When authorizing multiple keys (e.g., work and personal):

```bash
# For personal key
ssh-copy-id -i ~/.ssh/personal_key username@remote-server

# For work key
ssh-copy-id -i ~/.ssh/work_key username@remote-server
```

### Verifying Authorization

To verify your key is properly authorized:

```bash
ssh -i ~/.ssh/id_ed25519 username@remote-server
# OR using your SSH config alias
ssh server-alias
```

You should connect without being prompted for a password.

### Security Best Practices

1. **Restrict permissions** on the remote server:
   ```bash
   chmod 700 ~/.ssh
   chmod 600 ~/.ssh/authorized_keys
   ```

2. **Consider disabling password authentication** on the server by editing `/etc/ssh/sshd_config`:
   ```
   PasswordAuthentication no
   ChallengeResponseAuthentication no
   ```
   Then restart the SSH service:
   ```bash
   sudo systemctl restart sshd
   ```

3. **Use different keys** for different servers or purposes to limit the impact of a compromised key.

### Auto loading SSH keys and agent on repo level

Create a new file `~/dotlocal/.gitconfig` with the following content:

```
[user]
	name = username_work
	email = email_work
	signingKey = "~/.ssh/work_key.pub"

[includeif "gitdir:~/personal/dotfiles"]
	path = "~/keys/.gitconfig_personal"

[includeif "gitdir:~/personal/worktree"]
	path = "~/keys/.gitconfig_personal"

[includeif "gitdir:~/personal/scribble.nvim"]
	path = "~/keys/.gitconfig_personal"

[gpg]
	program = /opt/homebrew/bin/gpg
[filter "lfs"]
	clean = git-lfs clean -- %f
	smudge = git-lfs smudge -- %f
	process = git-lfs filter-process
	required = true

```

and create `~/dotlocal/.gitconfig_personal` with the following content:

```
[user]
	name = username_personal
	email = email_personal
	signingKey = "~/.ssh/personal_key.pub"
```
