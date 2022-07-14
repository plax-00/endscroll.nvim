local M = {}

local function dict_len(dict)
    -- because lua has no built in way to do this
    local len = 0
    for _, _ in pairs(dict) do
        len = len + 1
    end
    return len
end

M.setup = function(opts)
    if opts == nil or (type(opts) == 'table' and dict_len(opts) == 0) then
        -- default options
        opts = {
            scroll_at_end = true,
        }
    end
    vim.g.endscroll_opts = opts

    -- reset necessary keymaps
    vim.keymap.set({ 'n', 'v' }, '<Down>', '<Down>')
    vim.keymap.set({ 'n', 'v' }, '<C-e>', '<C-e>')

    local scroll = require('endscroll.scroll')
    vim.keymap.set({ 'n', 'v' }, 'j', scroll, { silent = true })
end


return M
