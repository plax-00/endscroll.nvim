endscroll.nvim
==============
A simple plugin to make Neovim naturally scroll through the end of files. Uses the `scrolloff` option to continue scrolling as if there were more lines below the last line.

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

### Setup
Add the following line to your Neovim config

Lua:
```
require('endscroll').setup {}
```
Vimscript:
```
lua require('endscroll').setup {}
```
