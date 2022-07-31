endscroll.nvim
==============
A simple plugin to make Neovim naturally scroll through the end of files. Uses the value of `scrolloff` to continue scrolling as if there were more lines below the last line.

![Example](https://i.imgur.com/vzkoJAA.gif)

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
#### Quick start
Add the following line to your Neovim config

Lua:
```
require('endscroll').setup {}
```
Vimscript:
```
lua require('endscroll').setup {}
```
#### Settings
These are the default settings. Any changes can be made in the call to `setup`.
```lua
-- default settings
require('endscroll').setup {
  scroll_at_end = true,     -- pressing j on the last line keeps scrolling the screen
  disabled_filetypes = {}   -- list of filetypes for which this extension will be disabled
}
```
