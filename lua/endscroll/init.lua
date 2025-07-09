local M = {}
local config = require('endscroll.config')

M.setup = function(opts)
    opts = opts or {}
    config.opts = vim.tbl_deep_extend('force', config.defaults, opts)

    local scroll = require('endscroll.scroll')
    vim.on_key(function(key)
        if key == 'j' or key == vim.keycode('<Down>') then
            scroll('j')
        elseif key == vim.keycode('<C-d>') then
            scroll('<C-d>')
        end
    end)

    require('endscroll.autocmds')
end

return M
