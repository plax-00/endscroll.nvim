endscroll.nvim
==============
A simple plugin to make Neovim naturally scroll through the end of files.

Getting started
---------------
### Install

Using [vim-plug](https://github.com/junegunn/vim-plug):
```
Plug 'plax-00/endscroll.nvim'
```
Using [packer](https://github.com/wbthomason/packer.nvim):
```
use 'plax-00/endscroll.nvim'
```

### Quick start
Add the following line to your Neovim config

Lua:
```
require('endscroll').setup {}
```
Vimscript:
```
lua require('endscroll').setup {}
```

### Note
This plugin will overwrite key mappings for `<Down>` and `<C-e>` and reset them to the default.
