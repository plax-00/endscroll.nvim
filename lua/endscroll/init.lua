local M = {}
local defaults = require('endscroll.config').defaults
local scroll = require('endscroll.scroll')

local down_keys = {
    normal = vim.tbl_map(vim.keycode, {
        'j',
        '<Down>',
        '<CR>',
        '<C-n>',
        '<C-j>',
        'o',
    }),
    insert = vim.tbl_map(vim.keycode, {
        '<Down>',
        '<CR>',
    }),
}

---@param opts? endscroll.Config
M.setup = function(opts)
    local global = vim.g.endscroll or {}
    opts = opts or {}

    if global.initialized == true then
        return
    end

    global.config = vim.tbl_deep_extend('force', defaults, opts)

    vim.on_key(function(key)
        local keys = vim.fn.mode() == 'n'
            and down_keys.normal
            or down_keys.insert

        if vim.list_contains(keys, key) then
            scroll(false)
        elseif key == vim.keycode('<C-d>') then
            scroll(true)
        end
    end)

    require('endscroll.autocmds')

    global.initialized = true
    vim.g.endscroll = global
end


return M
