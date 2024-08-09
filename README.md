<a id="readme-top"></a>

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/K1NASEA/dotfiles"><h1>🧙<h1></a>

  <h3 align="center">Dotfiles</h3>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#dependencies">Dependencies</a></li>
        <li><a href="#platforms">Platforms</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->

## About The Project

![Dotfiles Screen Shot][product-screenshot]

This is my personal Dotfiles.

### Dependencies

- [![zsh][zsh-logo]][zsh-url]
- [![bash][bash-logo]][bash-url]
- [![homebrew][homebrew-logo]][homebrew-url]
- [![sheldon][sheldon-logo]][sheldon-url]
- [![starship][starship-logo]][starship-url]
- [![Neovim][neovim-logo]][neovim-url]

### Platforms

- [![Linux][linux-logo]][linux-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->

## Getting Started

Run install.sh as shown below.

### Installation

```sh
curl -sL https://raw.githubusercontent.com/K1NASEA/dotfiles/main/install.sh | bash
```

### Other usages

- Uninstall

  ```sh
  ./install.sh | bash -s -- uninstall
  ```

- Backup dotfiles

  ```sh
  ./install.sh | bash -s -- backup
  ```

- Setup symlinks

  ```sh
  ./install.sh | bash -s -- link
  ```

- Setup Homebrew

  ```sh
  ./install.sh | bash -s -- homebrew
  ```

- Setup Shell

  ```sh
  ./install.sh | bash -s -- shell
  ```

- Setup git

  ```sh
  ./install.sh | bash -s -- git
  ```

- Setup Japanese localization

  ```sh
  ./install.sh | bash -s -- japanese
  ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->

## Contact

[K1NASEA](https://github.com/K1NASEA)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[product-screenshot]: images/screenshot.png
[homebrew-logo]: https://img.shields.io/badge/homebrew-grey?style=flat&logo=homebrew
[homebrew-url]: https://brew.sh/
[zsh-logo]: https://img.shields.io/badge/zsh-grey?style=flat&logo=zsh
[zsh-url]: https://www.zsh.org/
[bash-logo]: https://img.shields.io/badge/bash-grey?style=flat&logo=gnubash
[bash-url]: https://www.gnu.org/software/bash/
[sheldon-logo]: https://img.shields.io/badge/sheldon-grey?style=flat&logo=shell
[sheldon-url]: https://github.com/rossmacarthur/sheldon
[starship-logo]: https://img.shields.io/badge/starship-grey?style=flat&logo=starship
[starship-url]: https://starship.rs/
[neovim-logo]: https://img.shields.io/badge/Neovim-grey?style=flat&logo=neovim
[neovim-url]: https://neovim.io/
[Linux-logo]: https://img.shields.io/badge/Linux-grey?style=for-the-badge&logo=linux
[linux-url]: https://kernel.org/
