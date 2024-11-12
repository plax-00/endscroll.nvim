vim.api.nvim_create_augroup('EndscrollRestoreWinView', { clear = true })

vim.api.nvim_create_autocmd('BufLeave', {
    group = 'EndscrollRestoreWinView',
    pattern = '*',
    callback = function()
        local views = vim.b.endscroll_window_views or {}
        local winnr = vim.fn.winnr()
        views[winnr] = vim.fn.winsaveview()
        vim.b.endscroll_window_views = views
    end
})

vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
    group = 'EndscrollRestoreWinView',
    pattern = '*',
    callback = function()
        local views = vim.b.endscroll_window_views or {}
        local winnr = vim.fn.winnr()
        local winview = views[winnr]
        if winview then
            vim.fn.winrestview(winview)
        end
    end
})
