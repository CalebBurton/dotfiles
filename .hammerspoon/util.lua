utilMenu = hs.menubar.new()

local caffeinatedIcon = [[
1 . . . . . . . . . . . 3
. # # . . . . . . . # # .
. # # # # . . . # # # # .
. . # # # # 2 # # # # . .
. . # # # # # # # # # . .
. . . # # # # # # # . . .
. . . 8 # # # # # 4 . . .
. . . # # # # # # # . . .
. . # # # # # # # # # . .
. . # # # # 6 # # # # . .
. # # # # . . . # # # # .
. # # . . . . . . . # # .
7 . . . . . . . . . . . 5
]]

local sleepyIcon = [[
. 1 . . . . . . . . . 3 .
C . # . . . . . . . # . 4
. # . # # . . . # # . # .
. . # . . 1 2 3 . . # . .
. . # . . . . . . . # . .
. . . C . . . . . 4 . . .
. . . B . . . . . 5 . . .
. . . A . . . . . 6 . . .
. . # . . . . . . . # . .
. . # . . 9 8 7 . . # . .
. # . # # . . . # # . # .
A . # . . . . . . . # . 6
. 9 . . . . . . . . . 7 .
]]

utilMenu:setIcon('ASCII:' .. sleepyIcon)

local menu = nil

local reloadMenu = function() utilMenu:setMenu(menu) end

menu = {
  {
    title = "Mono audio",
    checked = false,
    fn = function(modifiers, menuItem)
      local script = [[
        tell application "System Preferences"
          reveal anchor "Hearing" of pane id "com.apple.preference.universalaccess"
        end tell

        tell application "System Events"
          tell application process "System Preferences"
            set frontmost to true
            tell group 1 of window "Accessibility"
              activate
              repeat until checkbox "Play stereo audio as mono" exists
                delay 0.05
              end repeat
              set monoStereoCheckbox to checkbox "Play stereo audio as mono"
              tell monoStereoCheckbox
                if (%s its value as boolean) then click monoStereoCheckbox
              end tell
            end tell
          end tell
        end tell

        tell application "System Preferences" to quit
      ]]

      local toggle = ""
      if not menuItem.checked then
        toggle = "not"
      end
      script = string.format(script, toggle)
      hs.osascript.applescript(script)

      menuItem.checked = not menuItem.checked
      reloadMenu()
    end
  },
  {
    title = "Caffeinate",
    checked = false,
    fn = function(modifiers, menuItem)
      local enabled = hs.caffeinate.toggle('displayIdle')
      if enabled then
        print('Caffeinate on')
        utilMenu:setIcon('ASCII:' .. caffeinatedIcon)
      else
        print('Caffeinate off')
        utilMenu:setIcon('ASCII:' .. sleepyIcon)
      end

      menuItem.checked = enabled
      reloadMenu()
    end
  },
  {
    title = "-" -- separator
  },
  {
    title = "Rescue windows",
    fn = rescue
  },
  {
    title = "-" -- separator
  },
  -- {
  --   title = "Layout: Home",
  --   fn = function()
  --     local ide, layout = layoutHome()
  --     local name = ide or 'Terminal'
  --     local description = 'Home (' .. name .. ')'
  --     applyLayout(description, layout)
  --   end
  -- },
  -- {
  --   title = "Layout: Dorm",
  --   fn = function()
  --     applyLayout("Dorm", layoutDorm)
  --   end
  -- },
  -- {
  --   title = "Layout: Lab",
  --   fn = function()
  --     local ide, layout = layoutLab()
  --     local name = ide or 'Terminal'
  --     local description = 'Lab (' .. name .. ')'
  --     applyLayout(description, layout)
  --   end
  -- },
  -- {
  --   title = "Layout: Laptop",
  --   fn = function()
  --     applyLayout("Laptop", layoutLaptop)
  --   end
  -- },
}

reloadMenu()
