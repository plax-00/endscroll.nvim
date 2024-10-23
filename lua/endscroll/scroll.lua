local line = vim.fn.line
local opts = require('endscroll.config').opts

local function get_text_height(start_line, end_line)
    return vim.api.nvim_win_text_height(0, { start_row = start_line - 1, end_row = end_line - 1 }).all - 1
end

local function scroll(key)
    local count = vim.v.count1

    -- check for disabled filetype
    if vim.tbl_contains(opts.disabled_filetypes, vim.o.filetype) then
        vim.cmd.normal { count .. vim.keycode(key), bang = true }
        return
    end

    local scrolloff = vim.o.scrolloff
    local last_line = line('$')
    local current_line = line('.')
    local lines_to_end = get_text_height(current_line, last_line)

    local ctrl_d = key == '<C-d>'
    local pre_lines_above
    if ctrl_d then
        if count == 1 then
            count = vim.o.scroll
        end
        pre_lines_above = get_text_height(line('w0'), current_line)
    end

    vim.cmd.normal { count .. 'j', bang = true  }

    if count > lines_to_end - scrolloff or ctrl_d then
        local lines_above = get_text_height(line('w0'), line('.'))
        local max_lines_above = vim.fn.winheight(0) - scrolloff - 1

        if current_line ~= last_line and lines_above <= max_lines_above then return end

        local max_scroll = lines_above - scrolloff
        if not opts.scroll_at_end then
            max_scroll = lines_above - max_lines_above
        end
        if ctrl_d then
            max_scroll = lines_above - pre_lines_above
        end

        if count > max_scroll then count = max_scroll end
        if count < 1 then return end

        vim.cmd.normal { count .. vim.keycode('<C-e>'), bang = true }
    end
end

return scroll
