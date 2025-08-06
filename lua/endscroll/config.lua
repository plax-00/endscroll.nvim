local M = {}

---@class endscroll.Config
---@field scroll_at_end? boolean
---@field disabled_filetypes? string[]
---@field down_keys? { normal?: string[], insert?: string[] }

---@type endscroll.Config
M.defaults = {
    scroll_at_end = true,
    disabled_filetypes = {
        'dashboard',
        'lazy',
        'noice',
        'NvimTree',
        'neo-tree',
    },
}

return M
