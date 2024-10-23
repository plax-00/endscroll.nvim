endscroll.nvim
==============
A simple plugin to make Neovim naturally scroll through the end of files. Uses the value of `scrolloff` to continue scrolling as if there were more lines below the last line.

https://github.com/user-attachments/assets/6a02bbec-c688-4cd0-904a-8e928f7383ba

Getting started
---------------
### Install

Using [lazy.nvim](https://github.com/folke/lazy.nvim):
```lua
{
  'plax-00/endscroll.nvim',
  opts = {},
}
```
Using [vim-plug](https://github.com/junegunn/vim-plug):
```vim
Plug 'plax-00/endscroll.nvim'
lua require('endscroll').setup {}
```

### Settings
These are the default settings. Any changes can be made in the call to `setup`.
```lua
-- default settings
require('endscroll').setup {
    scroll_at_end = true,     -- pressing j on the last line keeps scrolling the screen
    disabled_filetypes = {    -- list of filetypes for which this extension will be disabled
        'dashboard',
        'lazy',
        'noice',
        'NvimTree',
        'neo-tree',
    },
}
```
