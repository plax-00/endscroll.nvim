-- Add current directory to 'runtimepath' to be able to use 'lua' files
vim.opt.rtp:append(vim.fn.getcwd())
vim.opt.rtp:append(vim.fn.getcwd() .. '/tests/deps/mini.test')

-- Set up 'mini.test' only when calling headless Neovim (like with `make test`)
if #vim.api.nvim_list_uis() == 0 then
  require('mini.test').setup()
  require('endscroll').setup()
end

vim.o.scrolloff = 12
