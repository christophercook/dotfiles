# Description

This repository stores environment configuration for my personal Linux and macOS devices.

## Usage

Clone the repository.

```sh
git clone https://github.com/christophercook/dotfiles.git
cd dotfiles
```

There are separate scripts for configuring Bash and installing packages so that they
can be done independantly depending on needs. The provisioning script currently
supports only the APT package manager but homebrew and macOS support will be added
when convenient.

To setup Bash configuration and the prompt:

```sh
./setup.sh
```

To install packages and change configuration to my preferences after the above:

```sh
./provision.sh
```
