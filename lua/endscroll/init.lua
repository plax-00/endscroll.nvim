local M = {}

M.setup = function(opts)
    local default_opts = {
        scroll_at_end = true,
        disabled_filetypes = {},
    }

    if opts == nil then
        opts = default_opts
    else
        for key, value in pairs(default_opts) do
            if opts[key] == nil then
                opts[key] = value
            end
        end
    end

    vim.g.endscroll_opts = opts

    local scroll = require('endscroll.scroll')
    vim.keymap.set({ 'n', 'v' }, 'j', scroll, { silent = true })
    require('endscroll.autocmds')
end


return M
