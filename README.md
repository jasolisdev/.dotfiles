<div align="center">
    <h1>.dotfiles</h1>
    <p>There's no place like <b><code>~</code></b> !</p>
    <p>
    <img src=".images/dotfiles.png">
    <br><br>
    </p>
</div>

### Table of Contents

-   [Screenshots](#screenshots)
-   [Introduction](#introduction)

### Screenshots
## Latest Screenshots
![i3-gaps WM](.images/home.png)
![i3-gaps WM](.images/unixporn.png)
![i3-gaps WM](.images/startpage.png)
![i3-gaps WM](.images/spotify.png)

### Introduction

To clone this repository and it's submodules use:
```bash
git clone --recurse-submodules https://github.com/jasolisdev/.dotfiles.git
```

This repository contains my personal configuration files (also known as
_dotfiles_). The package lists can be found in `~/.pkglist/`. To install all
official packages, use `cat .pkglist/pacman | pacman -S -` and to install all
aur packages use `cat .pkglist/aur | yay -S -`, for convenience `cat
.pkglist/aur-pacman | yay -S -` to install both official and aur packages (must
have yay installed).

In the following sections I'll explain how this dotfiles repository was set up,
how to use it and how to restore them, for example on a new device.
