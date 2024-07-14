local line = vim.fn.line
local opts = require('endscroll.config').opts

local function get_text_height(start_line, end_line)
    return vim.api.nvim_win_text_height(0, { start_row = start_line - 1, end_row = end_line - 1 }).all - 1
end

local function scroll()
    local count = vim.v.count1

    -- check for disabled filetype
    if vim.tbl_contains(opts.disabled_filetypes, vim.o.filetype) then
        vim.cmd.normal { count .. 'j', bang = true }
        return
    end

    local scrolloff = vim.o.scrolloff
    local last_line = line('$')
    local current_line = line('.')

    local lines_to_end = get_text_height(current_line, last_line)
    local target_line = current_line + count
    local endscroll_start = current_line + lines_to_end - scrolloff

    vim.cmd.normal { count .. 'j', bang = true  }

    if target_line > endscroll_start then
        local lines_above = get_text_height(line('w0'), line('.'))
        local max_scroll = lines_above - scrolloff
        if not opts.scroll_at_end then
            max_scroll = lines_above - (vim.fn.winheight(0) - scrolloff - 1)
        end

        if count > max_scroll then count = max_scroll end
        if count < 1 then return end

        vim.cmd.normal { count .. vim.keycode('<C-e>'), bang = true }
    end
end

return scroll
