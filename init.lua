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

hs.hotkey.bind({"alt"}, "1", chrome_switch_to("Hao"))
hs.hotkey.bind({"alt"}, "2", chrome_switch_to("Work"))
hs.hotkey.bind({"alt"}, "`", chrome_switch_to("Incognito"))