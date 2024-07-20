local M = {}
local config = require('endscroll.config')

M.setup = function(opts)
    config.opts = vim.tbl_deep_extend('force', config.defaults, opts)

    local scroll = require('endscroll.scroll')
    vim.keymap.set({ 'n', 'v' }, 'j',     function() scroll('j')     end, { silent = true })
    vim.keymap.set({ 'n', 'v' }, '<C-d>', function() scroll('<C-d>') end, { silent = true })

    require('endscroll.autocmds')
end

return M
