local M = {}

M.setup = function(opts)
    local default_opts = {
        scroll_at_end = true,
        disabled_filetypes = {},
    }

    for key, value in pairs(default_opts) do
        if opts[key] == nil then
            opts[key] = value
        end
    end

    vim.g.endscroll_opts = opts

    -- reset necessary keymaps
    vim.keymap.set({ 'n', 'v' }, '<Down>', '<Down>')
    vim.keymap.set({ 'n', 'v' }, '<C-e>', '<C-e>')

    local scroll = require('endscroll.scroll')
    vim.keymap.set({ 'n', 'v' }, 'j', scroll, { silent = true })
end


return M
