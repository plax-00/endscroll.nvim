local api = vim.api
local fn = vim.fn

local function save_window_view()
    vim.b.window_view = fn.winsaveview()
end

local function load_window_view()
    if vim.b.window_view then
        fn.winrestview(vim.b.window_view)
    end
end

api.nvim_create_augroup('EndscrollRestoreWinView', { clear = true })
api.nvim_create_autocmd('BufLeave', {
    group = 'EndscrollRestoreWinView',
    pattern = '*',
    callback = save_window_view,
})
api.nvim_create_autocmd('BufEnter', {
    group = 'EndscrollRestoreWinView',
    pattern = '*',
    callback = load_window_view,
})
