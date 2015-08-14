# vimrc

My vim configuration.

My config strives to be:

- Organized
- Cross-platform
- Backwards-compatible

These scripts should work on any machine. However, plugins and configuration
that require functionality introduced in a newer patch level or in Neovim will
be disabled. In addition, any plugins that require external commands that are
not present will also be disabled.

Most configuration is handled in `vimrc`. All plugin configuration is handled
by [vim-plug](https://github.com/junegunn/vim-plug.git) in `plugins.vim`.

## Installation

Ensure that `$XDG_CONFIG_HOME`, `XDG_DATA_HOME`, and `XDG_CACHE_HOME` are set to
their defaults (or directories of your choosing). I use sh syntax here, but
setting the variables manually in Windows should work as well.

```sh
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/.cache
```

Clone the repository to `$XDG_CONFIG_HOME`.

```sh
git clone https://github.com/euclio/vimrc ${XDG_CONFIG_HOME}/vim
```

Set the proper initialization variables.

```sh
export VIMINIT='let $MYVIMRC=$XDG_CONFIG_HOME . "/vim/vimrc" | source $MYVIMRC'
export GVIMINIT='let $MYGVIMRC=$XDG_CONFIG_HOME . "/vim/gvimrc" | source $MYGVIMRC'
```

Upon starting vim, all plugins should be installed automatically, provided
`wget` or `curl` is installed.
