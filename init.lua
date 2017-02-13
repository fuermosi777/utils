function chrome_switch_to(ppl)
    return function()
        hs.application.launchOrFocus("Google Chrome")
        local chrome = hs.appfinder.appFromName("Google Chrome")
        local str_menu_item
        if ppl == "Incognito" then
            print(ppl)
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

--- open different Chrome users
hs.hotkey.bind({"alt"}, "1", chrome_switch_to("Hao"))
-- hs.hotkey.bind({"alt"}, "2", chrome_switch_to("Work"))
hs.hotkey.bind({"alt"}, "`", chrome_switch_to("Incognito"))

--- quick open applications
hs.hotkey.bind({"alt"}, "E", open("Finder"))
hs.hotkey.bind({"alt"}, "W", open("WeChat"))
hs.hotkey.bind({"alt"}, "S", open("Sublime Text"))
hs.hotkey.bind({"alt"}, "C", open("Google Chrome"))
hs.hotkey.bind({"alt"}, "T", open("iTerm"))
hs.hotkey.bind({"alt"}, "X", open("Xcode"))

--- sleep
hs.hotkey.bind({"control", "alt", "command"}, "DELETE", sleep)
