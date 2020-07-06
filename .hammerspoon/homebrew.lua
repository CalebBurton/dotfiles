-- Homebrew menubar
Homebrew = {
    menu = {},
    formulas = {},
    casks    = {},
    disabled = false,
    notified = false,
}

function Homebrew:loadOutdatedFormulas()
    Homebrew.formulas = {}
    local check_formulas = hs.task.new(
        '/usr/local/bin/brew',
        function(exitCode, outdated_formulas_str, stdErr)
            if ((exitCode ~= 0) or (stdErr ~= '')) then
                hs.notify.show('Homebrew', '', 'Error updating homebrew formulas. See console for details.')
                print('Error updating homebrew formulas. Exit code ' .. exitCode)
                print('StdErr:\n\t' .. stdErr)
            else
                -- print('Outdated formulas:\n' .. outdated_formulas_str)
                -- hs.notify.show('Homebrew', '', 'Updated formulas available')
                for formula in string.gmatch(outdated_formulas_str or '', "%S+") do
                    table.insert(Homebrew.formulas, formula)
                end
            end
        end,
        {'outdated', '--quiet'}
    ):start()
end

function Homebrew:loadOutdatedCasks()
    Homebrew.casks = {}
    local check_casks = hs.task.new(
        '/usr/local/bin/brew',
        function(exitCode, outdated_casks_str, stdErr)
            if ((exitCode ~= 0) or (stdErr ~= '')) then
                hs.notify.show('Homebrew', '', 'Error updating homebrew casks. See console for details.')
                print('Error updating homebrew casks. Exit code ' .. exitCode)
                print('StdErr:\n\t' .. stdErr)
            else
                -- print('Outdated casks:\n' .. outdated_casks_str)
                -- hs.notify.show('Homebrew', '', 'Updated casks available')
                for cask in string.gmatch(outdated_casks_str or '', "%S+") do
                    table.insert(Homebrew.casks, cask)
                end
            end
        end,
        {'cask', 'outdated', '--quiet'}
    ):start()
end

function Homebrew:getMenu()
    Homebrew.menu = {
        title='Homebrew',
        disabled=true,
        menu={
            title='Updating...',
            disabled=true
        }
    }

    local menu = {
        {
            title=('Upgrade ' .. #Homebrew.formulas .. ' formulas'),
            fn=function()
                self.disabled = true;
                hs.task.new(
                    '/usr/local/bin/brew', -- executable
                    function() -- callback
                        print('Formula upgrade complete')
                        Homebrew:loadOutdatedFormulas()
                    end,
                    function(task, stdOut, stdErr) -- stream callback
                        -- if stdOut ~= '' then print('StdOut:\n' .. stdOut) end
                        if stdErr ~= '' then print('!!!! Formula Upgrade StdErr:\n' .. stdErr) end
                        return true
                    end,
                    {'upgrade'} -- arguments
                ):start()
            end,
            disabled=(next(Homebrew.formulas) == nil),
            menu={}
        },
        {
            title=('Upgrade ' .. #Homebrew.casks .. ' casks'),
            fn=function()
                self.disabled = true;
                hs.task.new(
                    '/usr/local/bin/brew', -- executable
                    function() -- callback
                        print('Cask upgrade complete')
                        Homebrew:loadOutdatedCasks()
                    end,
                    function(task, stdOut, stdErr) -- stream callback
                        -- if stdOut ~= '' then print('StdOut:\n' .. stdOut) end
                        if stdErr ~= '' then print('!!!! Cask Upgrade StdErr:\n' .. stdErr) end
                        return true
                    end,
                    {'cask', 'upgrade', '--greedy'} -- arguments
                ):start()
            end,
            disabled=(next(Homebrew.casks) == nil),
            menu={}
        },
        {title='-'},
    }

    ----------------------
    -- Create the submenus
    ----------------------
    local submenu_for_formulas = menu[1].menu
    local submenu_for_casks = menu[2].menu

    for _, formula in ipairs(Homebrew.formulas) do
        table.insert(
            submenu_for_formulas,
            {
                title=formula,
                fn=function()
                    self.disabled = true;
                    hs.task.new(
                        '/usr/local/bin/brew',
                        function()
                            hs.notify.show('Homebrew', '', 'Upgrade complete for: '..formula)
                            Homebrew:loadOutdatedFormulas()
                        end,
                        {'upgrade', formula}
                    ):start()
                end,
                disabled=self.disabled
            }
        )
    end

    for _, cask in ipairs(Homebrew.casks) do
        table.insert(
            submenu_for_casks,
            {
                title=cask,
                fn=function()
                    self.disabled = true;
                    hs.task.new(
                        '/usr/local/bin/brew',
                        function()
                            hs.notify.show('Homebrew', '', 'Upgrade complete for: '..cask)
                            Homebrew:loadOutdatedCasks()
                        end,
                        {'cask', 'upgrade', cask}
                    ):start()
                end,
                disabled=self.disabled
            }
        )
    end

    local has_any_updates = ((#Homebrew.formulas + #Homebrew.casks) == 0)
    Homebrew.menu = {
        title='Homebrew',
        disabled=has_any_updates,
        menu=menu,
    }
    return Homebrew.menu
end

function Homebrew:update()
    print('Updating Homebrew')
    hs.task.new(
        '/usr/local/bin/brew',
        function()
            Homebrew:loadOutdatedFormulas()
            Homebrew:loadOutdatedCasks()
        end,
        {'update'}
    ):start()
end

hb_update = function()
    Homebrew:update()
end

local icon = [[
. . . . . . . . . . . . .
. 1 # 2 . . . . . 5 # 6 .
. D # # . . . . . # # # .
. # # # . . . . . # # # .
. # # # . . . . . # # # .
. # # 3 # # # # # 4 # # .
. # # # # # # # # # # # .
. # # A # # # # # 9 # # .
. # # # . . . . . # # # .
. # # # . . . . . # # # .
. # # # . . . . . # # # .
. C # B . . . . . 8 # 7 .
. . . . . . . . . . . . .
]]

if Homebrew then
    -- Homebrew.menubar:setTooltip('Homebrew')
    -- Homebrew.menubar:setIcon('ASCII:' .. icon)
    -- Homebrew.menubar:setMenu(function() return Homebrew:getMenu() end)
    -- Homebrew.menubar:removeFromMenuBar()
    Homebrew:update(); hs.timer.doEvery(3600, function() Homebrew:update() end)
end
