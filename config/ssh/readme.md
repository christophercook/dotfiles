# SSH Configuration

## Defaults

A config file is provided with common defaults.

## Notes About XDG Support

Enabling support for XDG dirs with SSH seems to be possible using a combination of aliases and configuration but until support is more native this approach seems too risky or high maintenance to bother with.

### Example

shell profile

```sh
    if [ -s "${XDG_CONFIG_HOME}/ssh/config" ]; then
        alias ssh="ssh -F ${XDG_CONFIG_HOME}/ssh/config"
    fi
```

ssh config

```properties
    Host github.com
        Hostname github.com
        IdentityFile /home/user/.config/ssh/id_rsa

    Host *
        UserKnownHostsFile /home/user/.config/ssh/known_hosts
```
