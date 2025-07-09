---@module 'mini.test'

local INPUT_LINES = 100
local CHILD_PROC_LINES = 40
local CHILD_PROC_COLS = 80

local eq = MiniTest.expect.equality

local child = MiniTest.new_child_neovim()
local T = MiniTest.new_set({
    hooks = {
        pre_case = function()
            -- Restart child process with custom 'init.lua' script
            child.restart({
                '--cmd', 'set lines=' .. CHILD_PROC_LINES .. ' columns=' .. CHILD_PROC_COLS,
                '-u', 'tests/scripts/minimal_init.lua',
                'tests/input.txt'
            })
        end,
        -- Stop once all test cases are finished
        post_once = child.stop,
    },
})

local function get_filler_lines()
    return child.fn.winheight(0) - child.api.nvim_win_text_height(0, { start_row = child.fn.line('w0') }).all - 1
end

T.cursor_down = function()
    eq(child.fn.line('$'), INPUT_LINES)
    eq(child.fn.line('w$'), CHILD_PROC_LINES - 2)
    eq(child.fn.line('.'), 1)
    child.type_keys('j')
    eq(child.fn.line('.'), 2)
    child.type_keys('jj')
    eq(child.fn.line('.'), 4)
end

T.single_scroll_to_end = function()
    repeat
        child.type_keys('j')
    until child.fn.line('.') == INPUT_LINES
    eq(get_filler_lines(), child.o.scrolloff)
end

T.single_scroll_past_end = function()
    repeat
        child.type_keys('j')
    until child.fn.line('.') == INPUT_LINES
    for _ = 1, 3 do
        child.type_keys('j')
    end
    eq(get_filler_lines(), child.o.scrolloff + 3)
end

T.count_scroll_to_end = function()
    child.type_keys(INPUT_LINES - 1 .. 'j')
    eq(get_filler_lines(), child.o.scrolloff)
    child.type_keys('j')
    eq(get_filler_lines(), child.o.scrolloff + 1)
end

T.count_scroll_past_end = function()
    child.type_keys(INPUT_LINES + 1 .. 'j')
    eq(get_filler_lines(), child.o.scrolloff + 2)
end

T.very_large_count = function()
    child.type_keys('500j')
    eq(child.fn.winline(), child.o.scrolloff + 1)
end

T.ctrl_d = function()
    child.type_keys('<C-d>')
    eq(child.fn.line('.'), child.o.scrolloff + child.o.scroll + 1)
    eq(child.fn.winline(), child.o.scrolloff + 1)
    child.type_keys('4j')
    eq(child.fn.winline(), child.o.scrolloff + 5)
    child.type_keys('<C-d>')
    eq(child.fn.winline(), child.o.scrolloff + 5)
    repeat
        child.type_keys('<C-d>')
    until child.fn.line('.') == INPUT_LINES
    eq(child.fn.winline(), child.o.scrolloff + 5)
    child.type_keys('<C-u>')
    child.type_keys('<C-u>')
    eq(child.fn.winline(), child.o.scrolloff + 5)
    child.type_keys('<C-d>')
    eq(child.fn.winline(), child.o.scrolloff + 5)
end

T.winview = function()
    child.type_keys(INPUT_LINES - 1 .. 'j')
    eq(get_filler_lines(), child.o.scrolloff)
    child.cmd('edit tests/test_endscroll.lua')
    child.cmd('edit tests/input.txt')
    eq(get_filler_lines(), child.o.scrolloff)
end

return T
