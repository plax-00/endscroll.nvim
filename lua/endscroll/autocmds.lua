local api = vim.api
local fn = vim.fn

local function save_window_view()
    vim.w.endscroll_window_view = fn.winsaveview()
end

local function load_window_view()
    if vim.w.endscroll_window_view then
        fn.winrestview(vim.w.endscroll_window_view)
    end
end

api.nvim_create_augroup('EndscrollRestoreWinView', { clear = true })
api.nvim_create_autocmd('WinLeave', {
    group = 'EndscrollRestoreWinView',
    pattern = '*',
    callback = save_window_view,
})
api.nvim_create_autocmd('WinEnter', {
    group = 'EndscrollRestoreWinView',
    pattern = '*',
    callback = load_window_view,
})
