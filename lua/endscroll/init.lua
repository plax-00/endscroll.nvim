local M = {}

M.setup = function(opts)
    if opts == nil or (type(opts) == 'table' and #opts == 0) then
        -- default options
        opts = {
            scroll_at_end = true,
        }
    end

    vim.g.endscroll_opts = opts

    local scroll = require('endscroll.scroll')
    vim.keymap.set({ 'n', 'v' }, 'j', scroll, { silent = true })
end


return M
