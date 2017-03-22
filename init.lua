function chrome_switch_to(ppl)
    return function()
        hs.application.launchOrFocus("Google Chrome")
        local chrome = hs.appfinder.appFromName("Google Chrome")
        local str_menu_item
        if ppl == "Incognito" then
            str_menu_item = {"File", "New Incognito Window"}
        else
            str_menu_item = {"People", ppl}
        end
        local menu_item = chrome:findMenuItem(str_menu_item)
        if (menu_item) then
            chrome:selectMenuItem(str_menu_item)
        end
    end
end

function open(name)
    return function()
        hs.application.launchOrFocus(name)
    end
end

function sleep()
    hs.caffeinate.systemSleep()
end

local rc = 0
function move_right()
    if rc == 0 then
        hs.window.focusedWindow():moveToUnit(hs.layout.right50)
        rc = rc + 1
    elseif rc == 1 then
        hs.window.focusedWindow():moveToUnit(hs.layout.right70)
        rc = rc + 1
    else
        hs.window.focusedWindow():moveToUnit(hs.layout.right30)
        rc = 0
    end
end

local lc = 0
function move_left()
    if lc == 0 then
        hs.window.focusedWindow():moveToUnit(hs.layout.left50)
        lc = lc + 1
    elseif lc == 1 then
        hs.window.focusedWindow():moveToUnit(hs.layout.left70)
        lc = lc + 1
    else
        hs.window.focusedWindow():moveToUnit(hs.layout.left30)
        lc = 0
    end
end

--- open different Chrome users
hs.hotkey.bind({"alt"}, "1", chrome_switch_to("Hao"))
hs.hotkey.bind({"alt"}, "2", chrome_switch_to("Yahoo!"))
hs.hotkey.bind({"alt"}, "`", chrome_switch_to("Incognito"))

--- quick open applications
hs.hotkey.bind({"alt"}, "E", open("Finder"))
hs.hotkey.bind({"alt"}, "W", open("WeChat"))
hs.hotkey.bind({"alt"}, "C", open("Google Chrome"))
hs.hotkey.bind({"alt"}, "T", open("iTerm"))
hs.hotkey.bind({"alt"}, "X", open("Xcode"))
hs.hotkey.bind({"alt"}, "S", open("Sublime Text"))
hs.hotkey.bind({"alt"}, "A", open("WebStorm"))
hs.hotkey.bind({"alt"}, "V", open("Visual Studio Code"))

--- sleep
hs.hotkey.bind({"control", "alt", "command"}, "DELETE", sleep)

--- window
hs.window.animationDuration = 0
hs.hotkey.bind({"ctrl", "cmd"}, "Right", move_right)
hs.hotkey.bind({"ctrl", "cmd"}, "Left", move_left)
