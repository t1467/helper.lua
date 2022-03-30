script_name("UNKNOWN")
script_version("1.2.6")
require 'lib.moonloader'
require 'sampfuncs'
require 'vkeys'
local memory = require 'memory'
local encoding = require 'encoding'
local inicfg = require 'inicfg'
local imgui = require('imgui')
encoding.default = 'CP1251'
u8 = encoding.UTF8
local mainIni = inicfg.load({
    settings = {
        activate_cmd_c = "helper",
		removeLogo_state_c = false,
		ctime_state_c = false,
		skipZZ_state_c = false,
		fastReport_state_c = false,
		carkey_state_c = false,
		autopin_state_c = false,
		autopin_pin_c = "",
		moneySeparate_state_c = false,
		chatCalc_state_c = false,
		getGuns_state_c = false,
		antiDrugs_state_c = false,
		resendVr_state_c = false,
		antiCarSkill_state_c = false,
		noBike_state_c = false,
		launcherEmul_state_c = false,
		launcherEmul_veh_c = 579,
		fishEye_state_c = false,
		fastFill_state_c = false,
		fastMoney_state_c = false,
		autoAltAndShift_state_c = false,
		autoSport_state_c = false,
	},
	afktools = {
		antiafk_state_c = false,
		autologin_state_c = false,
		autologin_pass_c = "",
		autoEat_state_c = false,
		autoEat_disableAnim_c = false,
		autoReconnect_state_c = false,
		autoReconnect_delay_c = 15,
		autoHeal_state_c = false,
		autoRoulette_state_c = false,
		autoRoulette_delay_c = 1800,
	},
	removeTrash = {
        state_c = false,
        clearChatAfterConnect_c = false,
		bonus_status_c = false,
		events_status_c = false,
		help_status_c = false,
		ad_status_c = false,
		player_status_c = false,
		trash_status_c = false,
		phone_status_c = false,
		space_status_c = false,
        bus_status_c = false,
        inkasator_status_c = false,
		zoloto_status_c = false,
		sobes_status_c = false,
        prison_status_c = false,
		offDesc_state_c = false,
		offFam_state_c = false,
	},
	setTime = {
		state_c = false,
		localTime_state_c = false,
		time_c = 12,
		weather_c = 1,
	},
	police = {
		taser_state_c = false,
		rpGuns_state_c = false,
		megafon_state_c = false,
		autoMiranda_state_c = false,
		autoRP_state_c = false,
		requireSu_state_c = false,
	}
},"unknown.ini")
cursorActive = false
playerLock = false
main_window = false
settings_window = true
afk_window = false
removeTrash_window = false
setTime_window = false
police_window = false
function closeAllWindow()
	settings_window = false
	afk_window = false
	removeTrash_window = false
	setTime_window = false
	police_window = false
end
function imgui.OnDrawFrame()
	if main_window then
		local resX, resY = getScreenResolution()
		imgui.SetNextWindowPos(imgui.ImVec2(resX / 2 - 940 / 2, resY / 2 - 490 / 2), imgui.Cond.Always)
		imgui.SetNextWindowSize(imgui.ImVec2(940, 505), imgui.Cond.Always)
		imgui.Begin('Choose Window', main_window, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoMove)
		imgui.BeginChild("Panel", imgui.ImVec2(276, 490), true, imgui.WindowFlags.NoScrollbar)
        imgui.Text(u8(thisScript().name))
		imgui.Text(u8"version "..thisScript().version)
		for i = 1, 2 do imgui.Text(u8"") end
		if imgui.Button(u8"Основные настройки", imgui.ImVec2(-1,20)) then closeAllWindow() settings_window = true end
		if imgui.Button(u8"Настройки для АФК", imgui.ImVec2(-1,20)) then closeAllWindow() afk_window = true end
		if imgui.Button(u8"Удаление мусора", imgui.ImVec2(-1,20)) then closeAllWindow() removeTrash_window = true end
		if imgui.Button(u8"Время и погода", imgui.ImVec2(-1,20)) then closeAllWindow() setTime_window = true end
		imgui.Text(u8"")
		if imgui.CollapsingHeader(u8"Организации") then
			if imgui.Button(u8"Полиция", imgui.ImVec2(-1,20)) then closeAllWindow() police_window = true end
		end
		imgui.EndChild()
		imgui.SameLine(290)
		imgui.BeginChild("Menu", imgui.ImVec2(644, 490), true, imgui.WindowFlags.NoScrollbar)
		if settings_window then
			imgui.Text(u8"Команда активации")
			imgui.InputText("", activate_cmd)
			imgui.Checkbox(u8"Удаление логотипа сервера", removeLogo_state)
			imgui.Checkbox(u8"Время на экране", ctime_state)
			imgui.Checkbox(u8"Скрыть диалог зеленой зоны", skipZZ_state)
			imgui.Checkbox(u8"Быстрый репорт", fastReport_state)
			imgui.Checkbox(u8"Авто ключи в автомобиле", carkey_state)
			imgui.Checkbox(u8"Авто-ввод пин-кода", autopin_state)
			if autopin_state.v then imgui.InputText(u8"Пин-код", autopin_pin, imgui.InputTextFlags.Password) end
			imgui.Checkbox(u8"Разделение денежных сумм", moneySeparate_state)
			imgui.Checkbox(u8"Калькулятор в чате", chatCalc_state)
			imgui.Checkbox(u8"Оружие по команде", getGuns_state)
            if getGuns_state.v then imgui.Text(u8"/de /m4 /sh /ri /ak /uzi") end
			imgui.Checkbox(u8"Анти-ломка", antiDrugs_state)
			imgui.Checkbox(u8"Фикс отправки сообщений в ВИП чат", resendVr_state)
			imgui.Checkbox(u8"Блокировать падение карскилла", antiCarSkill_state)
			imgui.Checkbox(u8"Не падать с мото", noBike_state)
			imgui.Checkbox(u8"Эмулятор лаунчера", launcherEmul_state)
			if launcherEmul_state.v then imgui.InputInt(u8"Авто вместо лаунчерных", launcherEmul_veh) end
			imgui.Checkbox(u8"Рыбий глаз", fishEye_state)
			imgui.Checkbox(u8"Быстрая заправка на АЗС", fastFill_state)
			imgui.Checkbox(u8"Ускорение анимации денег", fastMoney_state)
			imgui.Checkbox(u8"Авто-нажатие Alt/Shift", autoAltAndShift_state)
			imgui.Checkbox(u8"Авто спорт-режим в авто", autoSport_state)
		end
		if afk_window then
			imgui.Checkbox(u8"Работа в свернутом режиме", antiafk_state)
			imgui.Checkbox(u8"Автологин", autologin_state)
			if autologin_state.v then imgui.InputText(u8"Введите пароль", autologin_pass, imgui.InputTextFlags.Password) end
			imgui.Checkbox(u8"Авто-открытие сундуков с рулеткой", autoRoulette_state)
			if autoRoulette_state.v then imgui.InputInt(u8"Открытие каждые", autoRoulette_delay, 1, 100)
			imgui.Text(u8"Следующее открытие через "..(autoRoulette_timer)..u8" секунд") end
			imgui.Checkbox(u8"Авто-еда (Мешок -> Дом -> Оленина)", autoEat_state)
			if autoEat_state.v then imgui.Checkbox(u8"Отключение анимации авто-еды", autoEat_disableAnim) end
			imgui.Checkbox(u8"Авто-хил (Пиво)", autoHeal_state)
			imgui.Checkbox(u8"Авто-реконнект", autoReconnect_state)
			if autoReconnect_state.v then imgui.InputInt(u8"Задержка реконнекта", autoReconnect_delay, 1, 100) end
		end
		if removeTrash_window then
			imgui.Checkbox(u8"Удаление семей над головами", offFam_state)
            imgui.Checkbox(u8"Удаление описаний персонажей", offDesc_state)
			imgui.Checkbox(u8"Удаление мусора из чата", removeTrash_enable)
            if removeTrash_enable.v then
				imgui.Checkbox(u8"Пустой чат после подключения", removeTrash_clearChatAfterConnect)
				imgui.Checkbox(u8"Бонусы Аризоны", removeTrash_bonus_status)
				imgui.Checkbox(u8"Мероприятия", removeTrash_events_status)
				imgui.Checkbox(u8"Подсказки", removeTrash_help_status)
				imgui.Checkbox(u8"Реклама", removeTrash_ad_status)
				imgui.Checkbox(u8"События игроков", removeTrash_player_status)
				imgui.Checkbox(u8"Откровенный мусор", removeTrash_trash_status)
				imgui.Checkbox(u8"Телефон", removeTrash_phone_status)
				imgui.Checkbox(u8"Пустые строки", removeTrash_space_status)
				imgui.Checkbox(u8"Автобусные остановки", removeTrash_bus_status)
				imgui.Checkbox(u8"Инкасаторы", removeTrash_inkasator_status)
				imgui.Checkbox(u8"Золотые адм сообщения", removeTrash_zoloto_status)
				imgui.Checkbox(u8"Собеседования", removeTrash_sobes_status)
				imgui.Checkbox(u8"Вышел при побеге", removeTrash_prison_status)
			end
		end
		if setTime_window then
			imgui.Checkbox(u8"Включить", setTime_state)
			if setTime_state.v then
				imgui.Checkbox(u8"Синхронизация с локальным временем", setTime_localTime_state)
				imgui.InputInt(u8"Время", setTime_time, 1, 100)
				imgui.InputInt(u8"Погода", setTime_weather, 1, 100)
			end
		end
		if police_window then
			imgui.Checkbox(u8"Поиск преступников в зоне стрима", nearWanted_state)
			imgui.Checkbox(u8"Авто-отыгровка команд", autoRP_state)
			imgui.Checkbox(u8"Запрос розыска для 1-4 ранг", requireSu_state)
			imgui.Checkbox(u8"Авто-отыгровка оружия", rpGuns_state)
			imgui.Checkbox(u8"Зачитать права /rights", autoMiranda_state)
			imgui.Checkbox(u8"Тазер на X", taser_state)
			imgui.Checkbox(u8"Кричать в мегафон на M", megafon_state)
		end
		imgui.EndChild()
		imgui.End()
	end
	if chatCalc_window and sampIsChatInputActive() then
        local input = sampGetInputInfoPtr()
        local input = getStructElement(input, 0x8, 4)
        local windowPosX = getStructElement(input, 0x8, 4)
        local windowPosY = getStructElement(input, 0xC, 4)
        imgui.SetNextWindowPos(imgui.ImVec2(windowPosX, windowPosY + 30 + 15), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowSize(imgui.ImVec2(chatCalc_result:len()*10, 30))
        imgui.GetStyle().Colors[imgui.Col.WindowBg] = imgui.ImVec4(0, 0, 0, 1.00)
        imgui.Begin('Solve', window, imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove)
        imgui.Text(u8(chatCalc_result))
        imgui.End()
        theme()
	end
	if nearWanted_state.v then
        local x, y = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(x / 2 - 150, y / 2 - 160), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowSize(imgui.ImVec2(300,150))
        imgui.GetStyle().Colors[imgui.Col.WindowBg] = imgui.ImVec4(0, 0, 0, 0.60)
        imgui.Begin('Wanted in stream', window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize+ imgui.WindowFlags.NoScrollbar)
        for i = 1, #nearWanted_list do
            local id = nearWanted_list[i]:match("%d+")
            local b, p = sampGetCharHandleBySampPlayerId(id)
            if b then
                local tx, ty, tz = getCharCoordinates(p)
                local mx, my, mz = getCharCoordinates(PLAYER_PED)
                local dist = ((tx - mx) * 2 + (ty - my) * 2)/2
                dist = math.floor(dist)
                if dist < 0 then dist = dist * -1 end
                imgui.Text(u8(nearWanted_list[i]))
                imgui.SameLine(180)
                imgui.Text(u8(dist).." m")
                imgui.SameLine(240)
                if imgui.Button(u8"Pursuit") then
                    sampSendChat("/pursuit "..id)
				end
			end
		end
        imgui.End()
        theme()
	end
end
function theme()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2
    style.WindowPadding = imgui.ImVec2(8, 8)
    style.WindowRounding = 6
    style.ChildWindowRounding = 5
    style.FramePadding = imgui.ImVec2(5, 3)
    style.FrameRounding = 3.0
    style.ItemSpacing = imgui.ImVec2(5, 4)
    style.ItemInnerSpacing = imgui.ImVec2(4, 4)
    style.IndentSpacing = 21
    style.ScrollbarSize = 10.0
    style.ScrollbarRounding = 13
    style.GrabMinSize = 8
    style.GrabRounding = 1
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
    colors[clr.Text]                   = ImVec4(0.95, 0.96, 0.98, 1.00);
    colors[clr.TextDisabled]           = ImVec4(0.29, 0.29, 0.29, 1.00);
    colors[clr.WindowBg]               = ImVec4(0.14, 0.14, 0.14, 0.00);
    colors[clr.ChildWindowBg]          = ImVec4(0.12, 0.12, 0.12, 1.00);
    colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94);
    colors[clr.Border]                 = ImVec4(0.14, 0.14, 0.14, 1.00);
    colors[clr.BorderShadow]           = ImVec4(1.00, 1.00, 1.00, 0.10);
    colors[clr.FrameBg]                = ImVec4(0.22, 0.22, 0.22, 1.00);
    colors[clr.FrameBgHovered]         = ImVec4(0.18, 0.18, 0.18, 1.00);
    colors[clr.FrameBgActive]          = ImVec4(0.09, 0.12, 0.14, 1.00);
    colors[clr.TitleBg]                = ImVec4(0.14, 0.14, 0.14, 0.81);
    colors[clr.TitleBgActive]          = ImVec4(0.14, 0.14, 0.14, 1.00);
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51);
    colors[clr.MenuBarBg]              = ImVec4(0.20, 0.20, 0.20, 1.00);
    colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.39);
    colors[clr.ScrollbarGrab]          = ImVec4(0.36, 0.36, 0.36, 1.00);
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.18, 0.22, 0.25, 1.00);
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.24, 0.24, 0.24, 1.00);
    colors[clr.ComboBg]                = ImVec4(0.24, 0.24, 0.24, 1.00);
    colors[clr.CheckMark]              = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.SliderGrab]             = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.SliderGrabActive]       = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.Button]                 = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.ButtonHovered]          = ImVec4(1.00, 0.39, 0.39, 1.00);
    colors[clr.ButtonActive]           = ImVec4(1.00, 0.21, 0.21, 1.00);
    colors[clr.Header]                 = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.HeaderHovered]          = ImVec4(1.00, 0.39, 0.39, 1.00);
    colors[clr.HeaderActive]           = ImVec4(1.00, 0.21, 0.21, 1.00);
    colors[clr.ResizeGrip]             = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.ResizeGripHovered]      = ImVec4(1.00, 0.39, 0.39, 1.00);
    colors[clr.ResizeGripActive]       = ImVec4(1.00, 0.19, 0.19, 1.00);
    colors[clr.CloseButton]            = ImVec4(0.40, 0.39, 0.38, 0.16);
    colors[clr.CloseButtonHovered]     = ImVec4(0.40, 0.39, 0.38, 0.39);
    colors[clr.CloseButtonActive]      = ImVec4(0.40, 0.39, 0.38, 1.00);
    colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00);
    colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00);
    colors[clr.PlotHistogram]          = ImVec4(1.00, 0.21, 0.21, 1.00);
    colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.18, 0.18, 1.00);
    colors[clr.TextSelectedBg]         = ImVec4(1.00, 0.32, 0.32, 1.00);
    colors[clr.ModalWindowDarkening]   = ImVec4(0.26, 0.26, 0.26, 0.60);
end
theme()
function main()
	repeat wait(0) until isSampAvailable()
	lua_thread.create(function()
        while true do wait(10000)
            autoupdate("https://raw.githubusercontent.com/t1467/helper.lua/main/update.json", '['..string.upper(thisScript().name)..']: ', "")
		end
	end)
	lua_thread.create(activate)
	lua_thread.create(antiafk)
	lua_thread.create(autologin)
	lua_thread.create(cursor)
	lua_thread.create(autoEat)
	lua_thread.create(removeLogo)
	lua_thread.create(ctime)
	lua_thread.create(removeTrash)
	lua_thread.create(skipZZ)
	lua_thread.create(autoReconnect)
	lua_thread.create(fastReport)
	lua_thread.create(carkey)
	lua_thread.create(autopin)
	lua_thread.create(chatFix)
	lua_thread.create(fixCrosshair)
	lua_thread.create(clearChat)
	lua_thread.create(fAndSpaceFix)
	lua_thread.create(bufferCleaner)
	lua_thread.create(altEnter)
	lua_thread.create(showTextDraws)
	lua_thread.create(fakeAfk)
	lua_thread.create(moneySeparate)
	lua_thread.create(chatCalc)
	lua_thread.create(getGuns)
	lua_thread.create(antiDrugs)
	lua_thread.create(resendVr)
	lua_thread.create(antiCarSkill)
	lua_thread.create(gQuest)
	lua_thread.create(noBike)
	lua_thread.create(autoHeal)
	lua_thread.create(launcherEmul)
	lua_thread.create(fishEye)
	lua_thread.create(offDesc)
	lua_thread.create(offFam)
	lua_thread.create(fastFill)
	lua_thread.create(autoRoulette)
	lua_thread.create(setTime)
	lua_thread.create(taser)
	lua_thread.create(rpGuns)
	lua_thread.create(megafon)
	lua_thread.create(autoMiranda)
	lua_thread.create(autoRP)
	lua_thread.create(requireSu)
	lua_thread.create(nearWanted)
	lua_thread.create(fixInv)
	lua_thread.create(fastMoney)
	lua_thread.create(autoAltAndShift)
	lua_thread.create(autoSport)
	imgui.Process = true
	while true do wait(0)
        imgui.ShowCursor = cursorActive
        imgui.LockPlayer = playerLock
        save()
	end
end
function onWindowMessage(msg, wparam, lparam)
	if wparam == 0x1B and (main_window or cursorActive) then
		main_window = false
		consumeWindowMessage(true, false)
		lua_thread.create(function()
			wait(5)
			cursorActive = false
			playerLock = false
		end)
	end
end
function activate()
	activate_cmd = imgui.ImBuffer(mainIni.settings.activate_cmd_c, 256)
    addEventHandler("onSendRpc", function(id,bs)
		if id == 50 then
			local lenght = raknetBitStreamReadInt32(bs)
			local text = tostring(raknetBitStreamReadString(bs,lenght))
			if text == ("/"..tostring(activate_cmd.v)) then
                main_window = true
                cursorActive = true
                playerLock = true
                return false
			end
		end
	end)
end
function antiafk()
    antiafk_state = imgui.ImBool(mainIni.afktools.antiafk_state_c)
    local arr = {}
    function memset(addr)
        for i = 1, #arr do
            memory.write(addr + i - 1, arr[i], 1, true)
		end
	end
    while true do wait(0)
        if antiafk_state.v then
            memory.write(0x747FB6, 0x1, 1, true)
            memory.write(0x74805A, 0x1, 1, true)
            memory.fill(0x74542B, 0x90, 8, true)
            memory.fill(0x53EA88, 0x90, 6, true)
            else
            memory.write(0x747FB6, 0x0, 1, true)
            memory.write(0x74805A, 0x0, 1, true)
            arr = { 0x50, 0x51, 0xFF, 0x15, 0x00, 0x83, 0x85, 0x00 }
            memset(0x74542B)
            arr = { 0x0F, 0x84, 0x7B, 0x01, 0x00, 0x00 }
            memset(0x53EA88)
		end
	end
end
function autologin()
	autologin_state = imgui.ImBool(mainIni.afktools.autologin_state_c)
	autologin_pass = imgui.ImBuffer(tostring(mainIni.afktools.autologin_pass_c), 256)
	addEventHandler("onReceiveRpc", function(id, bs)
		if id == 61 and autologin_state.v then
			local id = raknetBitStreamReadInt16(bs)
			local style = raknetBitStreamReadInt8(bs)
			local title_lenght = raknetBitStreamReadInt8(bs)
			local title = raknetBitStreamReadString(bs,title_lenght)
			if tostring(title):match("[{]BFBBBA[}]Авторизация") and tostring(style) == "3" then
				sampSendDialogResponse(id,1,1,autologin_pass.v)
				return false
			end
		end
	end)
end
function cursor()
    while true do wait(0)
        if isKeyJustPressed(0x4C) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() and not isSampfuncsConsoleActive() then
			cursorActive = true
		end
	end
end
function autoEat()
    local eat = false
    autoEat_state = imgui.ImBool(mainIni.afktools.autoEat_state_c)
    autoEat_disableAnim = imgui.ImBool(mainIni.afktools.autoEat_disableAnim_c)
    addEventHandler("onReceiveRpc", function(id, bs)
        if id == 73 and autoEat_state.v then
            local style = raknetBitStreamReadInt32(bs)
            local time = raknetBitStreamReadInt32(bs)
            local ml = raknetBitStreamReadInt32(bs)
            local m = tostring(raknetBitStreamReadString(bs,ml))
            if m:find('You are hungry!') or m:find('You are very hungry!') then
                eat = true
                lua_thread.create(function()
                    wait(5000)
                    eat = false
				end)
                sampSendChat("/meatbag")
			end
		end
        if id == 86 and autoEat_state.v and autoEat_disableAnim.v and eat then
			local id = raknetBitStreamReadInt16(bs)
			local animlibl = raknetBitStreamReadInt8(bs)
			local animlib = raknetBitStreamReadString(bs,animlibl)
			local animnamel = raknetBitStreamReadInt8(bs)
			local animname = raknetBitStreamReadString(bs,animnamel)
			if tostring(animname) == "EAT_Burger" then
				return false
			end
		end
        if id == 61 and autoEat_state.v and eat then
			local id = raknetBitStreamReadInt16(bs)
			local style = raknetBitStreamReadInt8(bs)
			local tl = raknetBitStreamReadInt8(bs)
			local t = raknetBitStreamReadString(bs,tl)
			local b1l = raknetBitStreamReadInt8(bs)
			local b1 = raknetBitStreamReadString(bs,b1l)
			local b2l = raknetBitStreamReadInt8(bs)
			local b2 = raknetBitStreamReadString(bs,b2l)
			local text = raknetBitStreamDecodeString(bs,4096)
			if tostring(text):match("[{]42B02C[}][-][{]FFFFFF[}] [{](.+)[{](.+)[{]FFFFFF[}] дом") or tostring(text):match("[{]42B02C[}][-][{]FFFFFF[}] Меню дома") then
                sampSendDialogResponse(id,1,1,"")
                return false
			end
            if tostring(text):match("[{]42B02C[}][-][{]FFFFFF[}] Холодильник") then
                sampSendDialogResponse(id,1,2,"")
                return false
			end
            if tostring(text):match("Комплексный Обед") then
                sampSendDialogResponse(id,1,6,"")
                return false
			end
		end
        if id == 93 and autoEat_state.v and eat then
            color = raknetBitStreamReadInt32(bs)
            count = raknetBitStreamReadInt32(bs)
            text = tostring(raknetBitStreamReadString(bs, count))
            if text:match("(.)Ошибка(.) [{]FFFFFF[}]Вы не у своего дома") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/jmeat")
				end)
                return false
			end
            if text:match("(.)Ошибка(.) [{]FFFFFF[}]Вы не живете ни (.+) из домов") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/jmeat")
				end)
                return false
			end
            if text:match("В доме недостаточно продуктов[,] купить их можно в закусочной[!]") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/jmeat")
				end)
                return false
			end
            if text:match("У тебя нет жареного мяса оленины[!]") then
                autoEat_state.v = false
                sampAddChatMessage("{c41e3a}[Helper]: {ffffff}У вас закончилась оленина, авто-еда отключена",-1)
				eat = false
                return false
			end
            if text:match("(.)Ошибка(.) [{]FFFFFF[}]Вам отключили электроэнергию[!] Оплатите коммуналку[!]") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/jmeat")
				end)
                return false
			end
            if text:match("(.)Ошибка(.) [{]FFFFFF[}]Вы не в своём доме[!]") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/jmeat")
				end)
                return false
			end
            if text:match("(.)Ошибка(.) [{]FFFFFF[}]У вас нет мешка с мясом[!]") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/hmenu")
				end)
                return false
			end
		end
	end)
	while true do wait(0) end
end
function removeLogo()
    removeLogo_state = imgui.ImBool(mainIni.settings.removeLogo_state_c)
    while true do wait(0)
        if removeLogo_state.v then
            for i = 510, 530 do
                if sampTextdrawIsExists(i) then sampTextdrawDelete(i) end
			end
		end
	end
end
function ctime()
    ctime_state = imgui.ImBool(mainIni.settings.ctime_state_c)
    while true do
        wait(0)
		if sampIsLocalPlayerSpawned() and ctime_state.v then
            timer = os.time()
            sampTextdrawCreate(222, os.date("%H:%M", timer), 554, 25)
            sampTextdrawSetLetterSizeAndColor(222, 0.5, 2, -1)
            sampTextdrawSetOutlineColor(222, 2, 0xFF000000)
            sampTextdrawSetAlign(222, 0)
            sampTextdrawSetStyle(222, 3)
            wait(0)
            else
            if sampTextdrawIsExists(222) then sampTextdrawDelete(222) end
		end
	end
end
function skipZZ()
	skipZZ_state = imgui.ImBool(mainIni.settings.skipZZ_state_c)
	addEventHandler("onReceiveRpc",function(id, bs)
		if id == 61 and skipZZ_state.v then
			local id = raknetBitStreamReadInt16(bs)
			local style = raknetBitStreamReadInt8(bs)
			local tl = raknetBitStreamReadInt8(bs)
			local t = raknetBitStreamReadString(bs,tl)
			local b1l = raknetBitStreamReadInt8(bs)
			local b1 = raknetBitStreamReadString(bs,b1l)
			local b2l = raknetBitStreamReadInt8(bs)
			local b2 = raknetBitStreamReadString(bs,b2l)
			local text = raknetBitStreamDecodeString(bs,4096)
			if tostring(text):match("В этом месте запрещено") and tostring(text):match("драться[/]стрелять") then
				return false
			end
		end
		if id == 86 and skipZZ_state.v then
			local id = raknetBitStreamReadInt16(bs)
			local animlibl = raknetBitStreamReadInt8(bs)
			local animlib = raknetBitStreamReadString(bs,animlibl)
			local animnamel = raknetBitStreamReadInt8(bs)
			local animname = raknetBitStreamReadString(bs,animnamel)
			if tostring(animname) == "plyr_shkhead" then
				return false
			end
		end
	end)
end
function removeTrash()
    removeTrash_enable = imgui.ImBool(mainIni.removeTrash.state_c)
    removeTrash_clearChatAfterConnect = imgui.ImBool(mainIni.removeTrash.clearChatAfterConnect_c)
    removeTrash_bonus_status = imgui.ImBool(mainIni.removeTrash.bonus_status_c)
    removeTrash_events_status = imgui.ImBool(mainIni.removeTrash.events_status_c)
    removeTrash_help_status = imgui.ImBool(mainIni.removeTrash.help_status_c)
    removeTrash_ad_status = imgui.ImBool(mainIni.removeTrash.ad_status_c)
    removeTrash_player_status = imgui.ImBool(mainIni.removeTrash.player_status_c)
    removeTrash_trash_status = imgui.ImBool(mainIni.removeTrash.trash_status_c)
    removeTrash_phone_status = imgui.ImBool(mainIni.removeTrash.phone_status_c)
    removeTrash_space_status = imgui.ImBool(mainIni.removeTrash.space_status_c)
    removeTrash_bus_status = imgui.ImBool(mainIni.removeTrash.bus_status_c)
    removeTrash_inkasator_status = imgui.ImBool(mainIni.removeTrash.inkasator_status_c)
    removeTrash_zoloto_status = imgui.ImBool(mainIni.removeTrash.zoloto_status_c)
    removeTrash_sobes_status = imgui.ImBool(mainIni.removeTrash.sobes_status_c)
    removeTrash_prison_status = imgui.ImBool(mainIni.removeTrash.prison_status_c)
    removeTrash_events = {
        "(.)PUBG(.) Внимание[!] Через 15 минут в 19[:]05 начнется матч по игре PUBG(.) Призы за ТОП[-]3[:] [{]FFD700[}]2000[,] 1500[,] 500 AZ Coins[{]ffffff[}](.)",
        "(.)DM[-]арена(.) [{]FFFFFF[}]Условия турнира[:] за каждое убийство [{]33AA33[}](.+)%d+[,]%d+[{]ffffff[}] и смерть [{]ae433d[}](.+)%d+[,]%d+[{]ffffff[}]",
        "(.)DM[-]арена(.) [{]FFFFFF[}]Внимание[!] Через %d+ минут стартует турнир[,] принять могут все желающие(.) [(] [/]gps [-] Разное [-] DM арена [)]",
        "(.)Автомобильный аукцион(.) Через %d+ минут в %d+[:]%d+ стартует аукцион автомобилей[!] [(] [/]gps [-] Автосалоны [-] Автомобильный аукцион [)]",
        "(.)Горячая Звезда(.) Мероприятие завершилось без определения победителя[,] так как в момент завершения горячая звезда находилась на земле[!]",
        "(.)Подсказка(.) [{]FF6347[}]Мероприятие[:] (.)Собиратели(.)[,] начнется в [{]FFFFFF[}]20(.)15[!][{]FF6347[}] Используйте[:] [/]findcollectors",
        "(.+)[{]FFFFFF[}]Уважаемые жители[,] арендатор концертного зала[:] (.+)[_](.+)(.)%d+(.) проводит мероприятие(.) Присоединяйтесь[!] [(]GPS [-] Развлечения[)](.)",
        "(.)PUBG(.) [{]ffffff[}]Внимание[!] Турнир был завершен[,] список ТОП[-]3 победителей[:]",
        "%d(.) [{]FFFFFF[}](.+)[_](.+) заработал [{]ae433d[}]%d+ AZ Coins",
        "(.)Автомобильный аукцион(.) Внимание[!] На пляже Santa Maria проводится автомобильный аукцион[!] [(] [/]gps [-] Автосалоны [-] Автомобильный аукцион [)]",
        "(.)PUBG(.) Регистрация уже доступна[!] [(] [/]gps [-] Мероприятия [-] PUBG [)]",
        "(.)PUBG(.) Внимание[!] Через %d+ минуту в %d+[:]%d+ начнется матч по игре PUBG[.] Призы за ТОП[-]3[:] [{]FFD700[}]2000[,] 1500[,] 500 AZ Coins[{]ffffff[}](.)",
        "(.)Мероприятие(.) [{]ffffff[}]Телепорт на мероприятие закрыт[,] время вышло(.)",
        "(.)Информация(.) Самолёты с гумманитарной помощью сбросили %d+ подарков по всей карте штата[,] найдите и заберите ценный подарок[!]",
        "(.)Внимание(.) Началась регистрация на мероприятие (.)Воздушный Бой(.) [|] [/]gps (.+) День Защитника (.+) Регистрация на мероприятия",
        "(.)Внимание(.) Началась регистрация на мероприятие (.)Звёздные заезды(.) [|] [/]gps (.+) День Защитника (.+) Регистрация на мероприятия",
        "Битва за контроль грузового корабля начнется через %d+ минут[!] Используйте [/]govess",
        "Внимание[!] Уже через %d+ минут начинается распродажа одежды в секонд[-]хенде [№]2[!]",
		"Внимание[!] Уже через 5 минут начинается распродажа одежды в (.+)",
        "(.)DM[-]арена(.) [{]FFFFFF[}]Внимание[!] Начался турнир для всех желающих(.) [(] [/]gps [-] Разное [-] DM арена [)]",
        "(.)PUBG(.) Внимание[!] Через %d+ минут в %d+[:]%d+ начнется матч по игре PUBG(.) Призы за ТОП[-]3[:] [{]FFD700[}]2000[,] 1500[,] 500 AZ Coins[{]ffffff[}](.)",
        "(.)DM[-]арена(.) [{]FFFFFF[}]Условия турнира[:] за каждое убийство [{]33AA33[}][+](.)%d+[{]ffffff[}] и смерть [{]ae433d[}][-](.)%d+[{]ffffff[}]",
        "(.)Конные скачки(.) [{]FFFFFF[}]Внимание[!] Через %d+ минут откроется приём ставок(.) [(] [/]gps [-] Разное [)]",
        "(.)Автомобильный аукцион(.) Внимание[!] Начался аукцион автомобилей[!] [(] [/]gps [-] Автосалоны [-] Автомобильный аукцион [)]",
	}
    removeTrash_help = {
        "Не снимайте наушники[,] пока не закончите тренировку[,] иначе вы можете попасть в больницу[!]",
        "(.)Информация(.) [{]FFFFFF[}]Вы можете заправить полный бак [-] нажав на стоимость топлива",
        "(.)Информация(.) [{]FFFFFF[}]Используйте курсор чтобы выбрать тип топлива и его кол[-]во",
        "Возьмите материалы и начните сборку заново(.)",
        "(.)Ошибка(.) [{]FFFFFF[}]Отнесите материалы к остальным материалам(.)",
        "(.)Информация(.) [{]FFFFFF[}]Узнать цвета можно на форуме forum(.)arizona[-]rp(.)com",
        "(.)Информация(.) [{]FFFFFF[}]Подойдите к машине и переодически жмите левую клавишу мышки [,] для того чтобы ее покрасить[!]",
        "[{]DFCFCF[}](.)Подсказка(.) [{]DC4747[}]Чтобы включить радио используйте кнопку [{]DFCFCF[}]R",
        "(.)Подсказка(.)[{]FFFFFF[}] Используйте [/]phone [-] menu[,] чтобы найти членов организаций(.)",
        "(.)Подсказка(.) [{]ffffff[}]Чтобы клиент был засчитан в квест[/]достижения[,] в зарплату в PayDay[,] нужно проезжать с ним более длинные расстояния(.)",
        "(.+)[{]FFFFFF[}] [-] У вас недостаточно денег(.) Вы можете пополнить свой баланс (.)[/]donate(.)",
        "[{]DFCFCF[}](.)Подсказка(.) [{]DC4747[}]Вы можете задать вопрос в нашу техническую поддержку [/]report",
        "[{]DFCFCF[}](.)Подсказка(.) [{]DC4747[}]Советуем получить паспорт[,] а затем отправиться на ферму или завод для заработка денег на права(.)",
        "[{]DFCFCF[}](.)Подсказка(.)[{]8F1E1E[}] У вас не привязан e[-]mail адрес(.) Привяжите его дабы подтвердить ваш аккаунт [/]mm [-] Настройки [-] e[-]mail(.)",
        "[{]DFCFCF[}](.+)[{]DC4747[}] Пока вы малоимущий [{]DFCFCF[}][(]до 4[-]го уровня[)][{]DC4747[}][,] на улице вы можете попрошайничать деньги(.)",
        "(.)Информация(.)[{]FFFFFF[}] Хотдог для вас бесплатный[!] Осталось %d+ талонов на бесплатный хотдог",
        "[{]DC4747[}]Используйте команду [{]DFCFCF[}][/]beg[{]DC4747[}][,] чтобы поставить табличку и банку для денег[!]",
        "(.)Подсказка(.) С помощью телефона можно заказать такси(.) Среднее время ожидания [-] 2 минуты[!]",
        "[{]DFCFCF[}](.)Подсказка(.) [{]DC4747[}]Ваш текущий навык вождения[:] [{]DFCFCF[}](.)%d+[/]%d+(.)[{]DC4747[}]  Информация[:] [/]carskill",
        "[{]DFCFCF[}](.)Подсказка(.) [{]DC4747[}]В транспорте может присутствует радио[{]DFCFCF[}] (.)[/]radio(.)",
        "[{]DFCFCF[}](.)Подсказка(.) [{]DC4747[}]Для управления поворотниками используйте клавиши[:] [{]DFCFCF[}][(]Q[/]E[)]",
        "[{]DFCFCF[}](.)Подсказка(.) [{]DC4747[}]Чтобы завести двигатель введите [{]DFCFCF[}][/]engine[{]DC4747[}] или нажмите [{]DFCFCF[}]N",
        "Используйте клавишу (.)Y(.) для того, чтобы показать курсор управления или (.)ESC(.) [-] скрыть",
        "Устроиться на работу можно в центре занятости(.)",
        "Вы подобрали мусор[,] отнесите его в машину [(]ALT сзади авто[)]",
        "(.)Подсказка(.) Теперь вы будете получать зарплату вдвое больше [(]если будете работать вместе[)]",
        "(.)Подсказка(.) Чтобы разорвать партнерство[,] введите [/]roadpartner",
        "(.)Подсказка(.) Откройте карту ремонта дорог(.+)roadmap[)] и узнайте где требуется ремонт",
        "[{]73B461[}]Поступил вызов[,] чтобы принять введите [/]gopolice",
		"(.)Подсказка(.) Игроки владеющие 4[-]я домами могут бесплатно раз в день получать (.)2 Ларца Олигарха(.) в банке и его отделениях(.)",
        "Чтобы закрыть рулетку[,] используйте[:] [{]FFFFFF[}][']ESC[']",
        "(.)Подсказка(.) [{]FFFFFF[}]Добыча на земле[,] беги хватай[!]",
        "(.)В(.) Шлагбаум закроется через %d+ секунд",
		"(.)Подсказка(.) Чтобы собрать урожай[,] дождитесь созревания урожая",
		"(.)Подсказка(.) После того как урожай созреет[,] подойдите к грядке нажмите (.)ALT(.)[!]",
	}
    removeTrash_ad = {
        "[-] Наш сайт[:] arizona[-]rp(.)com [(]Личный кабинет[/]Донат[)]",
        "[-] Пригласи друга и получи бонус в размере (.)300 000[!]",
        "[-] Основные команды сервера[:] [/]menu [/]help [/]gps [/]settings",
        "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~",
        "В нашем магазине ты можешь приобрести нужное количество игровых денег и потратить",
        "их на желаемый тобой [{]FFFFFF[}]бизнес[,] дом[,] аксессуар[{]6495ED[}] или на покупку каких[-]нибудь безделушек(.)",
        "[-] Игроки со статусом [{]FFFFFF[}]VIP[{]6495ED[}] имеют больше возможностей[,] подробнее [/]help (.)Преимущества VIP(.)",
        "[-] Игроки со статусом [{]FFFFFF[}]VIP[{]6495ED[}] имеют большие возможности[,] подробнее [/]help (.)Преимущества VIP(.)",
        "[-] В магазине также можно приобрести редкие [{]FFFFFF[}]автомобили[,] аксессуары[,] воздушные шары[{]6495ED[}] и",
        "[-] В магазине так[-]же можно приобрести редкие [{]FFFFFF[}]автомобили[,] аксессуары[,] воздушные шары[{]6495ED[}][,]",
        "предметы[,] которые выделят тебя из толпы[!] Наш сайт[:] [{]FFFFFF[}]arizona[-]rp(.)com",
	}
    removeTrash_player = {
        "(.)Информация(.)[{]FFFFFF[}] Игрок (.+)[_](.+) приобрел Titan VIP(.)",
        "(.)Информация(.) (.+)[_](.+) при сборе урожая на ферме словил грядку для собственного выращивания льна(.)",
        "(.)Информация(.)[{]FFFFFF[}] Игрок (.+)[_](.+) приобрел PREMIUM VIP(.)",
        "(.+) Игрок [{]FF6347[}](.+)[_](.+)[(]%d+[)][{]FFFFFF[}] купил улучшение [{]FF6347[}](.)Бизнесмен(.)[{]FFFFFF[}][,] теперь он может владеть 5[-]ю бизнесами(.)",
        "(.+) Игрок [{]FF6347[}](.+)[_](.+)[(]%d+[)][{]FFFFFF[}] купил улучшение [{]FF6347[}](.)Больше недвижимости(.)[{]FFFFFF[}][,] теперь он может владеть 4 домами(.)",
        "(.+)[_](.+) испытал удачу при открытии (.+) и выиграл(.+)",
        "(.)Информация(.) (.+)[_](.+) при сборе урожая на ферме словил (.+)",
	}
    removeTrash_trash = {
        "(.+)[_](.+)(.)%d+(.) очень громко кашлянул",
        "Чтобы закрыть донат меню[,] используйте[:] [{]FFFFFF[}](.)ESC(.)",
        " Двигатель успешно завелся [|] [-]  ",
        "(.)Информация(.) [{]FFFFFF[}]Спасибо за ваш отзыв[!]",
        "Если за вами необходимо срочно проследить[,] администрация сделает это вне очереди[!]",
        "Рекомендуем кушать в закусочных[,] там намного дешевле[!]",
        "Вы немного перекусили(.) Посмотреть состояние голода можно [{]FFFFFF[}][/]satiety",
        "[{]DFCFCF[}](.)Подсказка(.) [{]DC4747[}]На сервере есть инвентарь[,] используйте клавишу Y для работы с ним[.]",
        "[{]DFCFCF[}](.)Подсказка(.) [{]DC4747[}]Вы можете задать вопрос в нашу техническую поддержку [/]report[.]",
        "Вы успешно приготовили %d жареный кусок мяса оленины[!] Чтобы покушать[,] используйте[:] [/]eat или [/]jmeat",
        "Игрок подтвердил сделку[!]",
        "Вы подтвердили сделку[!]",
        "(.)Ошибка(.) [{]FFFFFF[}]Подождите немного(.)(.)(.)",
        "Вы взяли (.+) Посмотреть состояние голода можно [{]FFFFFF[}][/]satiety",
        "(.)Подсказка(.) С помощью телефона можно заказать такси(.) Среднее время ожидания [-] 2 минуты[!]",
        "Обратите внимание что имея улучшение халявщик вы будете платить в 2 раза меньше[!]",
		"Отредактировал сотрудник СМИ (.) (.+) (.) [:] (.+)(.)(%d+)(.)",
	}
    removeTrash_phone = {
        "[[]Подсказка[]] [{]FFFFFF[}]Номера телефонов государственных служб[:]",
        "[{]FFFFFF[}]1[.][{]6495ED[}] 111 [-] [{]FFFFFF[}]Проверить баланс телефона",
        "[{]FFFFFF[}]2[.][{]6495ED[}] 060 [-] [{]FFFFFF[}]Служба точного времени",
        "[{]FFFFFF[}]3[.][{]6495ED[}] 911 [-] [{]FFFFFF[}]Полицейский участок",
        "[{]FFFFFF[}]4[.][{]6495ED[}] 912 [-] [{]FFFFFF[}]Скорая помощь",
        "[{]FFFFFF[}]5[.][{]6495ED[}] 913 [-] [{]FFFFFF[}]Такси",
        "[{]FFFFFF[}]6[.][{]6495ED[}] 914 [-] [{]FFFFFF[}]Механик",
        "[{]FFFFFF[}]7[.][{]6495ED[}] 8828 [-] [{]FFFFFF[}]Справочная центрального банка",
        "[{]FFFFFF[}]8[.][{]6495ED[}] 997 [-] [{]FFFFFF[}]Служба по вопросам жилой недвижимости [(]узнать владельца дома[)]",
	}
    removeTrash_bonus = {
        "[{]BFBBBA[}]Акции на Arizona Role Play",
	}
    removeTrash_bus = {
        "Автобус по маршруту [(](.+)[)] отъезжает через %d+ секунд(.)",
	}
    removeTrash_inkas = {
        "В городе (.+) начал работу новый инкассатор[!]",
        "Убив его[,] вы сможете получить деньги[!]"
	}
    addEventHandler("onReceiveRpc", function(id, bs)
        if id == 93 and removeTrash_enable.v then
            color = raknetBitStreamReadInt32(bs)
            count = raknetBitStreamReadInt32(bs)
            text = tostring(raknetBitStreamReadString(bs, count))
            if removeTrash_space_status.v then
                if text == " " then return false end
			end
            if removeTrash_events_status.v then
                for i = 1, #removeTrash_events do
                    if text:match(removeTrash_events[i]) then return false end
				end
			end
            if removeTrash_help_status.v then
                for i = 1, #removeTrash_help do
                    if text:match(removeTrash_help[i]) then return false end
				end
			end
            if removeTrash_ad_status.v then
                for i = 1, #removeTrash_ad do
                    if text:match(removeTrash_ad[i]) then return false end
				end
			end
            if removeTrash_player_status.v then
                for i = 1, #removeTrash_player do
                    if text:match(removeTrash_player[i]) then return false end
				end
			end
            if removeTrash_trash_status.v then
                for i = 1, #removeTrash_trash do
                    if text:match(removeTrash_trash[i]) then return false end
				end
			end
            if removeTrash_phone_status.v then
                for i = 1, #removeTrash_phone do
                    if text:match(removeTrash_phone[i]) then return false end
				end
			end
            if removeTrash_bus_status.v then
                for i = 1, #removeTrash_bus do
                    if text:match(removeTrash_bus[i]) then return false end
				end
			end
            if removeTrash_inkasator_status.v then
                for i = 1, #removeTrash_inkas do
                    if text:match(removeTrash_inkas[i]) then return false end
				end
			end
            if removeTrash_zoloto_status.v then
                if tostring(color) == "-2686721" then return false end
			end
            if removeTrash_sobes_status.v then
                if tostring(color) == "73381119" then return false end
			end
            if removeTrash_prison_status.v then
                if tostring(text):match("Игрок (.+) вышел при попытке избежать ареста и был наказан[!]") then return false end
			end
		end
        if id == 61 and removeTrash_bonus_status.v then
            local id = raknetBitStreamReadInt16(bs)
            local style = raknetBitStreamReadInt8(bs)
            local tl = raknetBitStreamReadInt8(bs)
            local t = tostring(raknetBitStreamReadString(bs,tl))
            for i = 1, #removeTrash_bonus do
                if t:match(removeTrash_bonus[i]) then return false end
			end
		end
	end)
	while true do wait(0)
		if removeTrash_clearChatAfterConnect.v and removeTrash_enable.v then
			local chatstring = sampGetChatString(99)
			if chatstring:match("Connected to [{]B9C9BF[}](.+)") then
				for i = 1, 20, 1 do
					sampAddChatMessage(" ",-1)
				end
			end
		end
	end
end
function autoReconnect()
    autoReconnect_state = imgui.ImBool(mainIni.afktools.autoReconnect_state_c)
    autoReconnect_delay = imgui.ImInt(mainIni.afktools.autoReconnect_delay_c)
    while true do wait(0)
        local chatstring = sampGetChatString(99)
        if chatstring == "Server closed the connection." or chatstring == "You are banned from this server." or chatstring == "Wrong server password." and autoReconnect_state.v then
	        sampDisconnectWithReason(false)
            wait(autoReconnect_delay.v * 1000)
            sampSetGamestate(1)
		end
	end
end
function fastReport()
    fastReport_state = imgui.ImBool(mainIni.settings.fastReport_state_c)
	local report = ""
    local run = false
	addEventHandler("onSendRpc", function(id,bs)
		if id == 50 and fastReport_state.v then
			local lenght = raknetBitStreamReadInt32(bs)
			local text = tostring(raknetBitStreamReadString(bs,lenght))
			if text:match("[/]report%s") or text == "/report" then
                local str = text:sub(9, text:len())
                if str:len() > 5 then
                    report = tostring(str)
                    run = true
                    lua_thread.create(function()
                        wait(5000)
                        run = false
					end)
                    elseif str:len() == 0 then
                    sampAddChatMessage("{c41e3a}[Helper]: {ffffff}Используйте /report [текст]",-1)
                    return false
                    else
                    sampAddChatMessage("{c41e3a}[Helper]: {ffffff}Сообщение должно быть больше 6 символов",-1)
                    return false
				end
			end
		end
	end)
	addEventHandler("onReceiveRpc", function(id,bs)
		if id == 61 and fastReport_state.v then
			local id = raknetBitStreamReadInt16(bs)
			local style = raknetBitStreamReadInt8(bs)
			local tl = raknetBitStreamReadInt8(bs)
			local t = raknetBitStreamReadString(bs,tl)
			local b1l = raknetBitStreamReadInt8(bs)
			local b1 = raknetBitStreamReadString(bs,b1l)
			local b2l = raknetBitStreamReadInt8(bs)
			local b2 = raknetBitStreamReadString(bs,b2l)
			local text = raknetBitStreamDecodeString(bs,4096)
			if tostring(text):match("[{]ffffff[]}]Вы собираетесь написать сообщение Администрации") and run then
				if report:len() > 5 then
					sampSendDialogResponse(id,1,1,report)
                    report = ""
					run = false
                    return false
				end
			end
		end
	end)
	while true do wait(0) end
end
function carkey()
    carkey_state = imgui.ImBool(mainIni.settings.carkey_state_c)
    local run = false
    addEventHandler("onReceiveRpc", function(id, bs)
        if id == 93 and carkey_state.v then
            color = raknetBitStreamReadInt32(bs)
            count = raknetBitStreamReadInt32(bs)
            text = tostring(raknetBitStreamReadString(bs, count))
            if tostring(text):match("Необходимо вставить ключи в зажигание(.) Используйте[:] (.)[/]key(.)") then
                lua_thread.create(function()
                    wait(300)
                    sampSendChat("/key")
                    wait(250)
                    setVirtualKeyDown(0x4E, true)
                    wait(250)
                    setVirtualKeyDown(0x4E, false)
				end)
                return false
			end
            if text:match("заглушил[(]а[)] двигатель") then
                local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                local nick = sampGetPlayerNickname(id)
                if text:match(tostring(nick)) and _ and tostring(nick):len() > 0 then
                    lua_thread.create(function()
                        wait(300)
                        sampSendChat("/key")
                        run = true
                        wait(3000)
                        run = false
					end)
				end
			end
            if text:match("вытащил[(]а[)] ключи из замка зажигания") and run then
                run = false
			end
            if text:match("Вы не в своем авто") and run then
                run = false
                return false
			end
		end
	end)
	while true do wait(0) end
end
function autopin()
    autopin_state = imgui.ImBool(mainIni.settings.autopin_state_c)
    autopin_pin = imgui.ImBuffer(tostring(mainIni.settings.autopin_pin_c), 200)
    addEventHandler("onReceiveRpc",function(id, bs)
		if id == 61 and autopin_state.v then
			local id = raknetBitStreamReadInt16(bs)
			local style = raknetBitStreamReadInt8(bs)
			local tl = raknetBitStreamReadInt8(bs)
			local t = raknetBitStreamReadString(bs,tl)
			local b1l = raknetBitStreamReadInt8(bs)
			local b1 = raknetBitStreamReadString(bs,b1l)
			local b2l = raknetBitStreamReadInt8(bs)
			local b2 = raknetBitStreamReadString(bs,b2l)
			local text = raknetBitStreamDecodeString(bs,4096)
			if tostring(text):match("[{]929290[}]Вы должны подтвердить свой PIN(.)код к") then
                sampSendDialogResponse(id,1,1,autopin_pin.v)
                return false
			end
            if tostring(text):match("PIN[-]код принят") then
                sampSendDialogResponse(id,1,1,"")
                sampAddChatMessage("{c41e3a}[Helper]: {ffffff}PIN-код принят",-1)
                lua_thread.create(function()
                    wait(250)
                    setVirtualKeyDown(0x4E, true)
                    wait(250)
                    setVirtualKeyDown(0x4E, false)
				end)
                return false
			end
		end
	end)
	while true do wait(0) end
end
function chatFix()
    while true do wait(0)
		if isKeyJustPressed(0x54 --[[VK_T]]) and not sampIsDialogActive() and not sampIsScoreboardOpen() and not isSampfuncsConsoleActive() then
			sampSetChatInputEnabled(true)
		end
	end
end
function fixCrosshair()
    memory.write(0x058E280, 0xEB, 1, true)
end
function clearChat()
    addEventHandler("onSendRpc", function(id,bs)
		if id == 50 then
			local lenght = raknetBitStreamReadInt32(bs)
			local text = tostring(raknetBitStreamReadString(bs,lenght))
			if text == ("/cc") then
                for i = 0, 100, 1 do
                    sampAddChatMessage("",-1)
				end
                return false
			end
		end
	end)
end
function fAndSpaceFix()
    while true do wait(0)
		if isCharInAnyCar(PLAYER_PED) and isCharPlayingAnim(PLAYER_PED, "CAR_FALLOUT_LHS") then
			local X, Y, Z = getOffsetFromCharInWorldCoords(PLAYER_PED, 0, 0, 2.5)
			warpCharFromCarToCoord(PLAYER_PED, X, Y, Z) 
		end
	end
end
function bufferCleaner()
    while true do wait(5000)
        if memory.read(0x8E4CB4, 4, true) > 419430400 then
			local huy = callFunction(0x53C500, 2, 2, true, true)
            local huy1 = callFunction(0x53C810, 1, 1, true)
            local huy2 = callFunction(0x40CF80, 0, 0)
            local huy3 = callFunction(0x4090A0, 0, 0)
            local huy4 = callFunction(0x5A18B0, 0, 0)
            local huy5 = callFunction(0x707770, 0, 0)
            local pX, pY, pZ = getCharCoordinates(PLAYER_PED)
            requestCollision(pX, pY)
            loadScene(pX, pY, pZ)
		end
	end
end
function altEnter()
    addEventHandler("onWindowMessage", function (msg, wparam, lparam)
        if msg == 261 and wparam == 13 then consumeWindowMessage(true, true) end
	end)
end
function showTextDraws()
    local state = false
    local font = renderCreateFont("Arial", 8, 5)
    addEventHandler("onSendRpc", function(id,bs)
		if id == 50 then
			local lenght = raknetBitStreamReadInt32(bs)
			local text = tostring(raknetBitStreamReadString(bs,lenght))
			if text == ("/showtd") then
                state = not state
                return false
			end
		end
	end)
    while true do wait(0)
        if state then
            for a = 0, 2304	do
                if sampTextdrawIsExists(a) then
                    local x, y = sampTextdrawGetPos(a)
                    local x1, y1 = convertGameScreenCoordsToWindowScreenCoords(x, y)
                    renderFontDrawText(font, a, x1, y1, 0xFFBEBEBE)
				end
			end
		end
	end
end
function fakeAfk()
    local state = false
    addEventHandler("onSendRpc", function(id,bs)
		if id == 50 then
			local lenght = raknetBitStreamReadInt32(bs)
			local text = tostring(raknetBitStreamReadString(bs,lenght))
			if text == ("/fakeafk") then
                state = not state
                if state then
                    lua_thread.create(function()
                        local x, y, z = getCharCoordinates(PLAYER_PED)
                        repeat wait(0) until not state
                        setCharCoordinates(PLAYER_PED,x,y,z - 1)
					end)
				end
                return false
			end
		end
	end)
    addEventHandler("onSendPacket", function()
        if state then return false end
	end)
    while true do
        wait(0)
		if state then
            sampTextdrawCreate(223, "YOU AFK", 320, 400)
            sampTextdrawSetLetterSizeAndColor(223, 0.4, 2, -1)
            sampTextdrawSetOutlineColor(223, 2, 0xFF000000)
            sampTextdrawSetAlign(223, 1)
            sampTextdrawSetStyle(223, 3)
            wait(0)
            else
            if sampTextdrawIsExists(223) then sampTextdrawDelete(223) end
		end
	end
end
function moneySeparate()
    moneySeparate_state = imgui.ImBool(mainIni.settings.moneySeparate_state_c)
    function comma_value(n)
        local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
        return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
	end
    function separator(text)
        if text:find("$") then
            for S in string.gmatch(text, "%$%d+") do
                local replace = comma_value(S)
                text = string.gsub(text, S, replace)
			end
            for S in string.gmatch(text, "%d+%$") do
                S = string.sub(S, 0, #S-1)
                local replace = comma_value(S)
                text = string.gsub(text, S, replace)
			end
		end
        return text
	end
    addEventHandler("onReceiveRpc",function(id, bs)
		if id == 61 and moneySeparate_state.v then
			local did = raknetBitStreamReadInt16(bs)
			local style = raknetBitStreamReadInt8(bs)
			local tl = raknetBitStreamReadInt8(bs)
			local t = raknetBitStreamReadString(bs,tl)
			local b1l = raknetBitStreamReadInt8(bs)
			local b1 = raknetBitStreamReadString(bs,b1l)
			local b2l = raknetBitStreamReadInt8(bs)
			local b2 = raknetBitStreamReadString(bs,b2l)
			local text = raknetBitStreamDecodeString(bs,4096)
            text = separator(text)
		    t = separator(t)
            raknetDeleteBitStream(bs)
            bs = raknetNewBitStream()
            raknetBitStreamWriteInt16(bs,tonumber(did))
            raknetBitStreamWriteInt8(bs,tonumber(style))
            raknetBitStreamWriteInt8(bs,tonumber(tl))
            raknetBitStreamWriteString(bs,tostring(t))
            raknetBitStreamWriteInt8(bs,tonumber(b1l))
            raknetBitStreamWriteString(bs,tostring(b1))
            raknetBitStreamWriteInt8(bs,tonumber(b2l))
            raknetBitStreamWriteString(bs,tostring(b2))
            raknetBitStreamEncodeString(bs,tostring(text))
            return true, id, bs
		end
	end)
end
function chatCalc()
    chatCalc_state = imgui.ImBool(mainIni.settings.chatCalc_state_c)
    chatCalc_window = false
    chatCalc_result = ""
    while true do wait(0)
        if chatCalc_state.v then
            local text = sampGetChatInputText()
            if text:find('%d+') and text:find('[-+/*^%%]') and not text:find('%a+') and text ~= nil then
                ok, number = pcall(load('return '..text))
                chatCalc_result = 'Результат: '..number
			end
            if text == '' then
                ok = false
			end
            chatCalc_window = ok
            else
            chatCalc_window = false
		end
	end
end
function getGuns()
    getGuns_state = imgui.ImBool(mainIni.settings.getGuns_state_c)
    local ammo_fill = false
    local deagle = false
    local m4 = false
    local rifle = false
    local ak = false
    local shotgun = false
    getGuns_ammo = 0
    local _ = false
    addEventHandler("onSendRpc", function(id,bs)
		if id == 50 and getGuns_state.v then
			local lenght = raknetBitStreamReadInt32(bs)
			local text = tostring(raknetBitStreamReadString(bs,lenght))
            if text:match("[/]m4%s") or text == "/m4" then
                getGuns_ammo = text:sub(5,text:len())
                if getGuns_ammo ~= 0 and tonumber(getGuns_ammo) and (tonumber(getGuns_ammo) < 501) then
                    _ = true
                    m4 = true
                    ammo_fill = true
                    sampSendChat("/invent")
                    lua_thread.create(function()
                        wait(1000)
                        if m4 == true then
                            ammo_fill = false
                            m4 = false
                            _ = false
                            sampAddChatMessage("{c41e3a}[Helper]: {ffffff}Оружие не найдено",-1)
                            wait(100)
                            sampSendClickTextdraw(65535)
						end
					end)
					else sampAddChatMessage("{c41e3a}[Helper]: {ffffff}Введите от 1 до 500 патронов",-1)
				end
                return false
			end
            if text:match("[/]ri%s") or text == "/ri" then
                getGuns_ammo = text:sub(5,text:len())
                if getGuns_ammo ~= 0 and tonumber(getGuns_ammo) and (tonumber(getGuns_ammo) < 501) then
                    _ = true
                    rifle = true
                    ammo_fill = true
                    sampSendChat("/invent")
                    lua_thread.create(function()
                        wait(1000)
                        if rifle == true then
                            ammo_fill = false
                            rifle = false
                            _ = false
                            sampAddChatMessage("{c41e3a}[Helper]: {ffffff}Оружие не найдено",-1)
                            wait(100)
                            sampSendClickTextdraw(65535)
						end
					end)
					else sampAddChatMessage("{c41e3a}[Helper]: {ffffff}Введите от 1 до 500 патронов",-1)
				end
                return false
			end
            if text:match("[/]de%s") or text == "/de" then
                getGuns_ammo = text:sub(5,text:len())
                if getGuns_ammo ~= 0 and tonumber(getGuns_ammo) and (tonumber(getGuns_ammo) < 501) then
                    _ = true
                    deagle = true
                    ammo_fill = true
                    sampSendChat("/invent")
                    lua_thread.create(function()
                        wait(1000)
                        if deagle == true then
                            ammo_fill = false
                            deagle = false
                            _ = false
                            sampAddChatMessage("{c41e3a}[Helper]: {ffffff}Оружие не найдено",-1)
                            wait(100)
                            sampSendClickTextdraw(65535)
						end
					end)
					else sampAddChatMessage("{c41e3a}[Helper]: {ffffff}Введите от 1 до 500 патронов",-1)
				end
                return false
			end
            if text:match("[/]sh%s") or text == "/sh" then
                getGuns_ammo = text:sub(5,text:len())
                if getGuns_ammo ~= 0 and tonumber(getGuns_ammo) and (tonumber(getGuns_ammo) < 501) then
                    _ = true
                    shotgun = true
                    ammo_fill = true
                    sampSendChat("/invent")
                    lua_thread.create(function()
                        wait(1000)
                        if shotgun == true then
                            ammo_fill = false
                            shotgun = false
                            _ = false
                            sampAddChatMessage("{c41e3a}[Helper]: {ffffff}Оружие не найдено",-1)
                            wait(100)
                            sampSendClickTextdraw(65535)
						end
					end)
					else sampAddChatMessage("{c41e3a}[Helper]: {ffffff}Введите от 1 до 500 патронов",-1)
				end
                return false
			end
            if text:match("[/]ak%s") or text == "/ak" then
                getGuns_ammo = text:sub(5,text:len())
                if getGuns_ammo ~= 0 and tonumber(getGuns_ammo) and (tonumber(getGuns_ammo) < 501) then
                    _ = true
                    ak = true
                    ammo_fill = true
                    sampSendChat("/invent")
                    lua_thread.create(function()
                        wait(1000)
                        if ak == true then
                            ammo_fill = false
                            ak = false
                            _ = false
                            sampAddChatMessage("{c41e3a}[Helper]: {ffffff}Оружие не найдено",-1)
                            wait(100)
                            sampSendClickTextdraw(65535)
						end
					end)
					else sampAddChatMessage("{c41e3a}[Helper]: {ffffff}Введите от 1 до 500 патронов",-1)
				end
                return false
			end
		end
	end)
    addEventHandler("onReceiveRpc", function(id, bs)
        if id == 61 and getGuns_state.v then
			local did = raknetBitStreamReadInt16(bs)
			local style = raknetBitStreamReadInt8(bs)
			local tl = raknetBitStreamReadInt8(bs)
			local t = raknetBitStreamReadString(bs,tl)
			local b1l = raknetBitStreamReadInt8(bs)
			local b1 = raknetBitStreamReadString(bs,b1l)
			local b2l = raknetBitStreamReadInt8(bs)
			local b2 = raknetBitStreamReadString(bs,b2l)
			local text = raknetBitStreamDecodeString(bs,4096)
            if text:match("[{]FFFFFF[}]Введите количество[,] которое хотите использовать") and ammo_fill then
                lua_thread.create(function()
					wait(50)
					sampSendDialogResponse(did,1,0,getGuns_ammo)
				end)
                ammo_fill = false
                return false
			end
		end
        if id == 93 and getGuns_state.v then
            color = raknetBitStreamReadInt32(bs)
            textl = raknetBitStreamReadInt32(bs)
            text = raknetBitStreamReadString(bs, textl)
            if tostring(text):match("(.)Ошибка(.) [{]FFFFFF[}]У вас в наличии только %d+ шт") and ammo_fill then
                lua_thread.create(function()
                    wait(10)
                    ammo_fill = false
                    sampCloseCurrentDialogWithButton(0)
				end)
			end
		end
        if id == 134 and getGuns_state.v then
            local tid = raknetBitStreamReadInt16(bs)
            local flags = raknetBitStreamReadInt8(bs)
            local letterW = raknetBitStreamReadFloat(bs)
            local letterH = raknetBitStreamReadFloat(bs)
            local letterColor = raknetBitStreamReadInt32(bs)
            local lineW = raknetBitStreamReadFloat(bs)
            local lineH = raknetBitStreamReadFloat(bs)
            local boxColor = raknetBitStreamReadInt32(bs)
            local shadow = raknetBitStreamReadInt8(bs)
            local outline = raknetBitStreamReadInt8(bs)
            local backgroundColor = raknetBitStreamReadInt32(bs)
            local style = raknetBitStreamReadInt8(bs)
            local selectable = raknetBitStreamReadInt8(bs)
            local X = raknetBitStreamReadFloat(bs)
            local Y = raknetBitStreamReadFloat(bs)
            local model = raknetBitStreamReadInt16(bs)
            local rotX = raknetBitStreamReadFloat(bs)
            local rotY = raknetBitStreamReadFloat(bs)
            local rotZ = raknetBitStreamReadFloat(bs)
            local zoom = raknetBitStreamReadFloat(bs)
            local color1 = raknetBitStreamReadInt16(bs)
            local color2 = raknetBitStreamReadInt16(bs)
            local textLen = raknetBitStreamReadInt16(bs)
            local text = raknetBitStreamReadString(bs, textLen)
            if model == 356 and m4 then
                lua_thread.create(function()
                    wait(100)
                    sampSendClickTextdraw(tid)
				end)
                m4 = false
			end
            if model == 355 and ak then
                lua_thread.create(function()
                    wait(100)
                    sampSendClickTextdraw(tid)
				end)
                ak = false
			end
            if model == 349 and shotgun then
                lua_thread.create(function()
                    wait(100)
                    sampSendClickTextdraw(tid)
				end)
                shotgun = false
			end
            if model == 357 and rifle then
                lua_thread.create(function()
                    wait(100)
                    sampSendClickTextdraw(tid)
				end)
                rifle = false
			end
            if model == 348 and deagle then
                lua_thread.create(function()
                    wait(100)
                    sampSendClickTextdraw(tid)
				end)
                deagle = false
			end
            if tid == 2302 and _ then
                lua_thread.create(function()
                    wait(100)
                    sampSendClickTextdraw(tid)
                    wait(100)
                    sampSendClickTextdraw(65535)
				end)
                _ = false
			end
		end
	end)
    while true do wait(0) end
end
function antiDrugs()
    antiDrugs_state = imgui.ImBool(mainIni.settings.antiDrugs_state_c)
    addEventHandler("onReceiveRpc", function(id, bs)
        if id == 93 and antiDrugs_state.v then
            color = raknetBitStreamReadInt32(bs)
            textl = raknetBitStreamReadInt32(bs)
            text = raknetBitStreamReadString(bs, textl)
            if tostring(text):match("У вас началась сильная ломка") or tostring(text):match("Вашему персонажу нужно принять") then
                return false
			end
		end
        if id == 35 then
            return false
		end
	end)
    while true do wait(0) end
end
function resendVr()
    resendVr_state = imgui.ImBool(mainIni.settings.resendVr_state_c)
    local font = renderCreateFont("Arial", 10, 9)
    local finished, try, message = false, 1, ""
    addEventHandler("onSendRpc", function(id,bs)
        if id == 50 and resendVr_state.v then
			local lenght = raknetBitStreamReadInt32(bs)
			local text = tostring(raknetBitStreamReadString(bs,lenght))
			if text:match("^/vr (.+)") then
                finished = false
                try = 1
                message = text:sub(5, text:len())
                lua_thread.create(function()
                    lua_thread.create(function()
                        wait(3000)
                        if try == 1 then
                            finished = true
						end
					end)
                    while not finished do
                        if sampGetGamestate() ~= 3 then
                            finished = true; break
						end
                        if not sampIsChatInputActive() then
                            local rotate = math.sin(os.clock() * 3) * 90 + 90
                            local el = getStructElement(sampGetInputInfoPtr(), 0x8, 4)
                            local X, Y = getStructElement(el, 0x8, 4), getStructElement(el, 0xC, 4)
                            renderDrawPolygon(X + 10, Y + (renderGetFontDrawHeight(font) / 2), 20, 20, 3, rotate, 0xFFFFFFFF)
                            renderDrawPolygon(X + 10, Y + (renderGetFontDrawHeight(font) / 2), 20, 20, 3, -1 * rotate, 0xFF0090FF)
                            renderFontDrawText(font, message, X + 25, Y, -1)
                            renderFontDrawText(font, string.format(" [x%s]", try), X + 25 + renderGetFontDrawTextLength(font, message), Y, 0x40FFFFFF)
						end
                        wait(0)
					end
				end)
			end
		end
	end)
    addEventHandler("onReceiveRpc", function(id, bs)
        if id == 93 and resendVr_state.v then
            color = raknetBitStreamReadInt32(bs)
            textl = raknetBitStreamReadInt32(bs)
            text = raknetBitStreamReadString(bs, textl)
            if not finished then
                if text:find("^%[Ошибка%].*После последнего сообщения в этом чате нужно подождать") then
                    lua_thread.create(function()
                        wait(1000)
                        sampSendChat("/vr " .. message)
                        try = try + 1	
					end)
                    return false
				end
                local id = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
                if text:match("%[%u+%] {%x+}[A-z0-9_]+%[" .. id .. "%]:") then
                    finished = true
				end
			end
            if text:find("^Вы заглушены") or text:find("Для возможности повторной отправки сообщения в этот чат") then
                finished = true
			end
		end
	end)
end
function antiCarSkill()
    antiCarSkill_state = imgui.ImBool(mainIni.settings.antiCarSkill_state_c)
    addEventHandler("onSendRpc", function(id, bs)
        if id == 106 and antiCarSkill_state.v then return false end
	end)
    while true do wait(0) end
end
function gQuest()
    local _ = false
    addEventHandler("onSendRpc", function(id,bs)
		if id == 50 then
			local lenght = raknetBitStreamReadInt32(bs)
			local text = tostring(raknetBitStreamReadString(bs,lenght))
			if text == ("/gquest") then
                _ = true
                lua_thread.create(function()
                    wait(2000)
                    _ = false
                    sampSendClickTextdraw(65535)
				end)
                sampSendChat("/invent")
                return false
			end
		end
	end)
    addEventHandler("onReceiveRpc", function(id, bs)
        if id == 134 then
            local tid = raknetBitStreamReadInt16(bs)
            local flags = raknetBitStreamReadInt8(bs)
            local letterW = raknetBitStreamReadFloat(bs)
            local letterH = raknetBitStreamReadFloat(bs)
            local letterColor = raknetBitStreamReadInt32(bs)
            local lineW = raknetBitStreamReadFloat(bs)
            local lineH = raknetBitStreamReadFloat(bs)
            local boxColor = raknetBitStreamReadInt32(bs)
            local shadow = raknetBitStreamReadInt8(bs)
            local outline = raknetBitStreamReadInt8(bs)
            local backgroundColor = raknetBitStreamReadInt32(bs)
            local style = raknetBitStreamReadInt8(bs)
            local selectable = raknetBitStreamReadInt8(bs)
            local X = raknetBitStreamReadFloat(bs)
            local Y = raknetBitStreamReadFloat(bs)
            local model = raknetBitStreamReadInt16(bs)
            local rotX = raknetBitStreamReadFloat(bs)
            local rotY = raknetBitStreamReadFloat(bs)
            local rotZ = raknetBitStreamReadFloat(bs)
            local zoom = raknetBitStreamReadFloat(bs)
            local color1 = raknetBitStreamReadInt16(bs)
            local color2 = raknetBitStreamReadInt16(bs)
            local textLen = raknetBitStreamReadInt16(bs)
            local text = raknetBitStreamReadString(bs, textLen)
            if tid == 2101 and _ then
                lua_thread.create(function()
                    wait(50)
                    sampSendClickTextdraw(tid)
                    wait(50)
                    sampSendClickTextdraw(65535)
				end)
                _ = false
			end
		end
	end)
    while true do wait(0) end
end
function noBike()
    noBike_state = imgui.ImBool(mainIni.settings.noBike_state_c)
    while true do wait(0)
        if noBike_state.v then
            if isCharOnAnyBike(PLAYER_PED) then
                if not isCarInWater(storeCarCharIsInNoSave(PLAYER_PED)) then
                    setCharCanBeKnockedOffBike(PLAYER_PED, true)
                    else
                    setCharCanBeKnockedOffBike(PLAYER_PED, false)
				end
			end
            else
            setCharCanBeKnockedOffBike(PLAYER_PED, false)
		end
	end
end
function autoHeal()
    autoHeal_state = imgui.ImBool(mainIni.afktools.autoHeal_state_c)
    addEventHandler("onReceiveRpc", function(id,bs)
        if id == 88 and autoHeal_state.v then
            local aid = raknetBitStreamReadInt8(bs)
            if aid == 20 then
                return false
			end
		end
	end)
    while true do wait(5000)
        if autoHeal_state.v then
            if getCharHealth(PLAYER_PED) < 100 then
                sampSendChat("/beer")
			end
		end
	end
end
function launcherEmul()
	launcherEmul_veh = imgui.ImInt(mainIni.settings.launcherEmul_veh_c)
    launcherEmul_state = imgui.ImBool(mainIni.settings.launcherEmul_state_c)
    addEventHandler("onSendRpc", function(id, bs)
        if id == 25 and launcherEmul_state.v then
            local iver = raknetBitStreamReadInt32(bs)
            local mod = raknetBitStreamReadInt8(bs)
            local nicklen = raknetBitStreamReadInt8(bs)
            local nick = raknetBitStreamReadString(bs,nicklen)
            local ccr = raknetBitStreamReadInt32(bs)
            local authkeylen = raknetBitStreamReadInt8(bs)
            local authkey = raknetBitStreamReadString(bs,authkeylen)
            raknetDeleteBitStream(bs)
            bs = raknetNewBitStream()
            raknetBitStreamWriteInt32(bs, iver)
            raknetBitStreamWriteInt8(bs, mod)
            raknetBitStreamWriteInt8(bs, nicklen)
            raknetBitStreamWriteString(bs, nick)
            raknetBitStreamWriteInt32(bs, ccr)
            raknetBitStreamWriteInt8(bs, authkeylen)
            raknetBitStreamWriteString(bs, authkey)
            raknetBitStreamWriteInt8(bs, 10)
            raknetBitStreamWriteString(bs, "Arizona PC")
            return true, 25, bs
		end
	end)
    addEventHandler("onReceiveRpc", function(id, bs)
        if id == 164 and launcherEmul_state.v then
            local vid = raknetBitStreamReadInt16(bs)
            local model = raknetBitStreamReadInt32(bs)
            local x = raknetBitStreamReadFloat(bs)
            local y = raknetBitStreamReadFloat(bs)
            local z = raknetBitStreamReadFloat(bs)
            local angle = raknetBitStreamReadFloat(bs)
            local color1 = raknetBitStreamReadInt8(bs)
            local color2 = raknetBitStreamReadInt8(bs)
            local health = raknetBitStreamReadFloat(bs)
            local int = raknetBitStreamReadInt8(bs)
            local doorDamage = raknetBitStreamReadInt32(bs)
            local panelDamage = raknetBitStreamReadInt32(bs)
            local lightDamage = raknetBitStreamReadInt32(bs)
            local tireDamage = raknetBitStreamReadInt32(bs)
            local siren = raknetBitStreamReadInt8(bs)
            local modslot0 = raknetBitStreamReadInt8(bs)
            local modslot1 = raknetBitStreamReadInt8(bs)
            local modslot2 = raknetBitStreamReadInt8(bs)
            local modslot3 = raknetBitStreamReadInt8(bs)
            local modslot4 = raknetBitStreamReadInt8(bs)
            local modslot5 = raknetBitStreamReadInt8(bs)
            local modslot6 = raknetBitStreamReadInt8(bs)
            local modslot7 = raknetBitStreamReadInt8(bs)
            local modslot8 = raknetBitStreamReadInt8(bs)
            local modslot9 = raknetBitStreamReadInt8(bs)
            local modslot10 = raknetBitStreamReadInt8(bs)
            local modslot11 = raknetBitStreamReadInt8(bs)
            local modslot12 = raknetBitStreamReadInt8(bs)
            local modslot13 = raknetBitStreamReadInt8(bs)
            local paintJob = raknetBitStreamReadInt8(bs)
            local bodyColor1 = raknetBitStreamReadInt32(bs)
            local bodyColor2 = raknetBitStreamReadInt32(bs)
            if model > 610 or model < 400 then
                raknetDeleteBitStream(bs)
                bs = raknetNewBitStream()
                raknetBitStreamWriteInt16(bs,vid)
                raknetBitStreamWriteInt32(bs,launcherEmul_veh.v)
                raknetBitStreamWriteFloat(bs,x)
                raknetBitStreamWriteFloat(bs,y)
                raknetBitStreamWriteFloat(bs,z)
                raknetBitStreamWriteFloat(bs,angle)
                raknetBitStreamWriteInt8(bs,color1)
                raknetBitStreamWriteInt8(bs, olor2)
                raknetBitStreamWriteFloat(bs,health)
                raknetBitStreamWriteInt8(bs,int)
                raknetBitStreamWriteInt32(bs,doorDamage)
                raknetBitStreamWriteInt32(bs,panelDamage)
                raknetBitStreamWriteInt32(bs,lightDamage)
                raknetBitStreamWriteInt32(bs,tireDamage)
                raknetBitStreamWriteInt8(bs,siren)
                raknetBitStreamWriteInt8(bs,modslot0)
                raknetBitStreamWriteInt8(bs,modslot1)
                raknetBitStreamWriteInt8(bs,modslot2)
                raknetBitStreamWriteInt8(bs,modslot3)
                raknetBitStreamWriteInt8(bs,modslot4)
                raknetBitStreamWriteInt8(bs,modslot5)
                raknetBitStreamWriteInt8(bs,modslot6)
                raknetBitStreamWriteInt8(bs,modslot7)
                raknetBitStreamWriteInt8(bs,modslot8)
                raknetBitStreamWriteInt8(bs,modslot9)
                raknetBitStreamWriteInt8(bs,modslot10)
                raknetBitStreamWriteInt8(bs,modslot11)
                raknetBitStreamWriteInt8(bs,modslot12)
                raknetBitStreamWriteInt8(bs,modslot13)
                raknetBitStreamWriteInt8(bs,paintJob)
                raknetBitStreamWriteInt32(bs,bodyColor1)
                raknetBitStreamWriteInt32(bs,bodyColor2)
                return true, 164, bs
			end
		end
	end)
    while true do wait(0)
		if launcherEmul_veh.v > 610 then launcherEmul_veh.v = 400 end
		if launcherEmul_veh.v < 400 then launcherEmul_veh.v = 610 end
	end
end
function fishEye()
    fishEye_state = imgui.ImBool(mainIni.settings.fishEye_state_c)
    local locked = false
    while true do wait(0)
		if fishEye_state.v then
			if isCurrentCharWeapon(PLAYER_PED, 34) and isKeyDown(2) then
				if not locked then 
					cameraSetLerpFov(70.0, 70.0, 1000, 1)
					locked = true
				end
                else
				cameraSetLerpFov(101.0, 101.0, 1000, 1)
				locked = false
			end
		end
	end
end
function offDesc()
    offDesc_state = imgui.ImBool(mainIni.removeTrash.offDesc_state_c)
    addEventHandler("onReceiveRpc", function(id, bs)
        if id == 36 and offDesc_state.v then
            local labelId = raknetBitStreamReadInt16(bs)
            local labelColor = raknetBitStreamReadInt32(bs)
            local X = raknetBitStreamReadFloat(bs)
            local Y = raknetBitStreamReadFloat(bs)
            local Z = raknetBitStreamReadFloat(bs)
            local dist = raknetBitStreamReadFloat(bs)
            local b = raknetBitStreamReadInt8(bs)
            local playerId = raknetBitStreamReadInt16(bs)
            local vehId = raknetBitStreamReadInt16(bs)
            local text = tostring(raknetBitStreamDecodeString(bs,4096))
            if playerId < 1001 and labelColor == -858993409 then
                return false
			end
		end
	end)
    while true do wait(0) end
end
function offFam()
    offFam_state = imgui.ImBool(mainIni.removeTrash.offFam_state_c)
    addEventHandler("onReceiveRpc", function(id, bs)
        if id == 36 and offFam_state.v then
            local labelId = raknetBitStreamReadInt16(bs)
            local labelColor = raknetBitStreamReadInt32(bs)
            local X = raknetBitStreamReadFloat(bs)
            local Y = raknetBitStreamReadFloat(bs)
            local Z = raknetBitStreamReadFloat(bs)
            local dist = raknetBitStreamReadFloat(bs)
            local b = raknetBitStreamReadInt8(bs)
            local playerId = raknetBitStreamReadInt16(bs)
            local vehId = raknetBitStreamReadInt16(bs)
            local text = tostring(raknetBitStreamDecodeString(bs,4096))
            if playerId < 1001 and labelColor == 8421631 then
                return false
			end
		end
	end)
    while true do wait(0) end
end
function fastFill()
    fastFill_state = imgui.ImBool(mainIni.settings.fastFill_state_c)
    addEventHandler("onReceiveRpc", function(id,bs)
        if id == 134 and fastFill_state.v then
            local tid = raknetBitStreamReadInt16(bs)
            local flags = raknetBitStreamReadInt8(bs)
            local letterW = raknetBitStreamReadFloat(bs)
            local letterH = raknetBitStreamReadFloat(bs)
            local letterColor = raknetBitStreamReadInt32(bs)
            local lineW = raknetBitStreamReadFloat(bs)
            local lineH = raknetBitStreamReadFloat(bs)
            local boxColor = raknetBitStreamReadInt32(bs)
            local shadow = raknetBitStreamReadInt8(bs)
            local outline = raknetBitStreamReadInt8(bs)
            local backgroundColor = raknetBitStreamReadInt32(bs)
            local style = raknetBitStreamReadInt8(bs)
            local selectable = raknetBitStreamReadInt8(bs)
            local X = raknetBitStreamReadFloat(bs)
            local Y = raknetBitStreamReadFloat(bs)
            local model = raknetBitStreamReadInt16(bs)
            local rotX = raknetBitStreamReadFloat(bs)
            local rotY = raknetBitStreamReadFloat(bs)
            local rotZ = raknetBitStreamReadFloat(bs)
            local zoom = raknetBitStreamReadFloat(bs)
            local color1 = raknetBitStreamReadInt16(bs)
            local color2 = raknetBitStreamReadInt16(bs)
            local textLen = raknetBitStreamReadInt16(bs)
            local text = raknetBitStreamReadString(bs, textLen)
            if (tid == 2106 or tid == 2110) and text == "$0" then
                lua_thread.create(function()
                    wait(100)
                    sampSendClickTextdraw(tid)
                    wait(200)
                    sampSendClickTextdraw(144)
                    wait(200)
                    sampSendClickTextdraw(130)
                    wait(200)
                    sampSendClickTextdraw(144)
                    wait(200)
                    sampSendClickTextdraw(130)
                    wait(200)
                    sampSendClickTextdraw(144)
                    wait(200)
                    sampSendClickTextdraw(130)
                    wait(200)
                    sampSendClickTextdraw(144)
                    wait(100)
                    sampSendClickTextdraw(130)
				end)
			end
		end
	end)
    while true do wait(0) end
end
function autoRoulette()
	autoRoulette_state = imgui.ImBool(mainIni.afktools.autoRoulette_state_c)
	autoRoulette_delay = imgui.ImInt(mainIni.afktools.autoRoulette_delay_c)
	autoRoulette_timer = 0
	local case1 = ""
	local case2 = ""
	local case3 = ""
	local case4 = ""
	addEventHandler("onReceiveRpc", function(id,bs)
		if id == 134 and autoRoulette_state.v then
            local tid = raknetBitStreamReadInt16(bs)
            local flags = raknetBitStreamReadInt8(bs)
            local letterW = raknetBitStreamReadFloat(bs)
            local letterH = raknetBitStreamReadFloat(bs)
            local letterColor = raknetBitStreamReadInt32(bs)
            local lineW = raknetBitStreamReadFloat(bs)
            local lineH = raknetBitStreamReadFloat(bs)
            local boxColor = raknetBitStreamReadInt32(bs)
            local shadow = raknetBitStreamReadInt8(bs)
            local outline = raknetBitStreamReadInt8(bs)
            local backgroundColor = raknetBitStreamReadInt32(bs)
            local style = raknetBitStreamReadInt8(bs)
            local selectable = raknetBitStreamReadInt8(bs)
            local X = raknetBitStreamReadFloat(bs)
            local Y = raknetBitStreamReadFloat(bs)
            local model = raknetBitStreamReadInt16(bs)
            local rotX = raknetBitStreamReadFloat(bs)
            local rotY = raknetBitStreamReadFloat(bs)
            local rotZ = raknetBitStreamReadFloat(bs)
            local zoom = raknetBitStreamReadFloat(bs)
            local color1 = raknetBitStreamReadInt16(bs)
            local color2 = raknetBitStreamReadInt16(bs)
            local textLen = raknetBitStreamReadInt16(bs)
            local text = raknetBitStreamReadString(bs, textLen)
			if model == 19918 then case1 = tid end
			if model == 19613 then case2 = tid end
			if model == 1353 then case3 = tid end
			if model == 1733 then case4 = tid end
		end
		if id == 93 and autoRoulette_state.v then
            color = raknetBitStreamReadInt32(bs)
            textl = raknetBitStreamReadInt32(bs)
            text = raknetBitStreamReadString(bs, textl)
            if tostring(text):match("%[Ошибка%] %{FFFFFF%}Время после прошлого использования ещё не прошло%!") then
                return false
			end
		end
	end)
	while true do wait(0)
		if autoRoulette_state.v then
			lua_thread.create(function()
				sampSendChat("/invent")
				wait(500)
				if case1 ~= "" then sampSendClickTextdraw(case1) end
				if case1 ~= "" then wait(300) end
				if case1 ~= "" then sampSendClickTextdraw(2302) end
				if case1 ~= "" then wait(300) case1 = "" end
				if case2 ~= "" then sampSendClickTextdraw(case2) end
				if case2 ~= "" then wait(300) end
				if case2 ~= "" then sampSendClickTextdraw(2302) end
				if case2 ~= "" then wait(300) case2 = "" end
				if case3 ~= "" then sampSendClickTextdraw(case3) end
				if case3 ~= "" then wait(300) end
				if case3 ~= "" then sampSendClickTextdraw(2302) end
				if case3 ~= "" then wait(300) case3 = "" end
				if case4 ~= "" then sampSendClickTextdraw(case4) end
				if case4 ~= "" then wait(300) end
				if case4 ~= "" then sampSendClickTextdraw(2302) end
				if case4 ~= "" then wait(300) case4 = "" end
				sampCloseCurrentDialogWithButton(1)
				sampSendClickTextdraw(65535)
			end)
			autoRoulette_timer = autoRoulette_delay.v
			for i = 0, autoRoulette_delay.v do
				wait(1000)
				autoRoulette_timer = autoRoulette_timer - 1
				if not autoRoulette_state.v then break end
			end
		end
	end
end
function setTime()
    setTime_state = imgui.ImBool(mainIni.setTime.state_c)
    setTime_localTime_state = imgui.ImBool(mainIni.setTime.localTime_state_c)
    setTime_time = imgui.ImInt(mainIni.setTime.time_c)
    setTime_weather = imgui.ImInt(mainIni.setTime.weather_c)
    addEventHandler("onReceiveRpc", function(id, bs)
        if id == 94 and setTime_state.v then
            return false
		end
        if id == 152 and setTime_state.v then
            return false
		end
	end)
    while true do wait(0)
        local timer = os.time()
        if setTime_state.v then
            if setTime_time.v > 23 then setTime_time.v = 0 end
            if setTime_time.v < 0 then setTime_time.v = 23 end
            if setTime_localTime_state.v then
				local h = os.date("%H", timer)
                setTimeOfDay(h,0)
				else
                setTimeOfDay(setTime_time.v,0)
			end
            forceWeatherNow(setTime_weather.v)
		end
	end
end
function taser()
    taser_state = imgui.ImBool(mainIni.police.taser_state_c)
    while true do wait(0)
        if isKeyJustPressed(0x58) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() and not isSampfuncsConsoleActive() and taser_state.v then
			sampSendChat("/taser")
		end
	end
end
function rpGuns()
    rpGuns_state = imgui.ImBool(mainIni.police.rpGuns_state_c)
    local lastWeapon = 0
    addEventHandler("onSendRpc", function(id,bs)
        if id == 115 and rpGuns_state.v then
            local tod = raknetBitStreamReadBool(bs)
            local pid = raknetBitStreamReadInt16(bs)
            local damage = raknetBitStreamReadFloat(bs)
            local wep = raknetBitStreamReadInt32(bs)
            local bodypart = raknetBitStreamReadInt32(bs)
            if wep == 3 and not tod and lastWeapon ~= 3 then
                lua_thread.create(function()
					lastWeapon = 3
                    wait(100)
                    sampSendChat("/me достал резиновую дубинку и оглушил нарушителя")
				end)
			end
            if tostring(wep) ~= lastWeapon and not tod then
                lastWeapon = wep
			end
		end
	end)
    while true do wait(0)
        if rpGuns_state.v then
            if isCurrentCharWeapon(PLAYER_PED,0) then lastWeapon = 0 end
            if memory.getint8(getCharPointer(PLAYER_PED) + 0x528, false) == 19 then
                if not isCurrentCharWeapon(PLAYER_PED,0) then
                    if lastWeapon ~= 23 and isCurrentCharWeapon(PLAYER_PED,23) then sampSendChat("/me вытащил электрошокер с разгрузочного пояса, снял предохранитель") lastWeapon = 23 end
                    if lastWeapon ~= 24 and isCurrentCharWeapon(PLAYER_PED,24) then sampSendChat("/me вытащил Glock-21 из холдера, снял с предохранителя") lastWeapon = 24 end
                    if lastWeapon ~= 25 and isCurrentCharWeapon(PLAYER_PED,25) then sampSendChat("/me снял нелетальный дробовик со спины, снял с предохранителя") lastWeapon = 25 end
                    if lastWeapon ~= 29 and isCurrentCharWeapon(PLAYER_PED,29) then sampSendChat("/me отцепил MP-5 с разгрузки, снял с предохранителя") lastWeapon = 29 end
                    if lastWeapon ~= 31 and isCurrentCharWeapon(PLAYER_PED,31) then sampSendChat("/me перехватил винтовку AR-15, висящую на плече, снял с предохранителя") lastWeapon = 31 end
                    if lastWeapon ~= 34 and isCurrentCharWeapon(PLAYER_PED,34) then sampSendChat("/me достал из кейса винтовку M110, снял с предохранителя") lastWeapon = 34 end
				end
			end
		end
	end
end
function megafon()
    megafon_state = imgui.ImBool(mainIni.police.megafon_state_c)
    while true do wait(0)
        if isKeyJustPressed(0x4D) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() and not isSampfuncsConsoleActive() and megafon_state.v then
            local bool, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
            local nickname = sampGetPlayerNickname(id)
            nickname = nickname:gsub("_", " ")
			sampSendChat("/m Говорит сотрудник полиции "..nickname..", немедленно остановитесь!")
		end
	end
end
function autoMiranda()
    autoMiranda_state = imgui.ImBool(mainIni.police.autoMiranda_state_c)
    addEventHandler("onSendRpc", function(id,bs)
		if id == 50 and autoMiranda_state.v then
			local lenght = raknetBitStreamReadInt32(bs)
			local text = tostring(raknetBitStreamReadString(bs,lenght))
            if text == "/rights" then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("Вы имеете право хранить молчание.")
                    wait(1000)
                    sampSendChat("Всё, что вы скажете, может и будет использовано против вас в суде. Ваш адвокат может")
                    wait(1000)
                    sampSendChat("присутствовать при допросе. Если вы не можете оплатить услуги адвоката, он будет")
                    wait(1000)
                    sampSendChat("предоставлен вам государством.")
                    wait(1000)
                    sampSendChat("Вы понимаете свои права?")
				end)
                return false
			end
		end
	end)
    while true do wait(0) end
end
function autoRP()
    autoRP_state = imgui.ImBool(mainIni.police.autoRP_state_c)
    addEventHandler("onSendRpc", function(id,bs)
		if id == 50 and autoRP_state.v then
			local lenght = raknetBitStreamReadInt32(bs)
			local text = tostring(raknetBitStreamReadString(bs,lenght))
            if text:match ("^[/]frisk%s") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/me надел перчатки и произвел обыск нарушителя")
				end)
			end
            if text:match ("^[/]cuff%s") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/me снял наручники с пояса и надел их на нарушителя")
				end)
			end
            if text:match ("^[/]uncuff%s") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/me растягнул нарушителя и убрал наручники")
				end)
			end
            if text:match ("^[/]unmask%s") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/me стащил маску с нарушителя")
				end)
			end
            if text:match ("^[/]pull%s") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/me выбил окно автомобиля и силой вытащил нарушителя из него")
				end)
			end
            if text:match ("^[/]incar%s") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/me открыл дверь патрульного автомобиля и затащил в него нарушителя")
				end)
			end
            if text:match ("^[/]ticket%s") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/me достал пустые тикеты, заполнил штраф и передал его нарушителю")
				end)
			end
            if text:match ("^[/]arrest") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/do Из департамента вышли офицеры и забрали нарушителя")
				end)
			end
            if text:match ("^[/]gotome%s") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/me скрутил руки подозреваемому и потащил его за собой")
				end)
			end
            if text:match ("^[/]ungotome%s") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/me отпустил подозреваемого")
				end)
			end
			if text:match ("^[/]clear%s") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/me зашел в базу данных полиции штата и снял все обвинения")
				end)
			end
            if text:match ("^[/]su%s") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/me передал приметы нарушителя по рации")
				end)
			end
		end
	end)
    while true do wait(0) end
end
function requireSu()
    requireSu_state = imgui.ImBool(mainIni.police.requireSu_state_c)
    local p_id = ""
    local k = ""
    local p = ""
    addEventHandler("onSendRpc", function(id,bs)
		if id == 50 and requireSu_state.v then
			local lenght = raknetBitStreamReadInt32(bs)
			local text = tostring(raknetBitStreamReadString(bs,lenght))
            if text:match("[/]su%s") then
                local t = stringSplit(text, " ")
                p_id = t[2]
                k = t[3]
                p = t[4]
			end
		end
	end)
    addEventHandler("onReceiveRpc", function(id, bs)
        if id == 93 and requireSu_state.v then
            color = raknetBitStreamReadInt32(bs)
            textl = raknetBitStreamReadInt32(bs)
            text = raknetBitStreamReadString(bs, textl)
            if tostring(text):match("(.)Ошибка(.) [{]FFFFFF[}]Подавать в розыск доступно с 5 ранга[!]") then
                if id ~= "" and k ~= "" and p ~= "" then
                    lua_thread.create(function()
                        wait(2000)
                        sampSendChat("/r Запрашиваю розыск на "..p_id.." жетон..")
                        wait(1100)
                        sampSendChat("/r "..k.." уровень розыска..")
                        wait(1100)
                        sampSendChat("/r ..С причиной "..p)
                        p_id = ""
                        k = ""
                        p = ""
					end)
				end
			end
		end
	end)
    while true do wait(0) end
end
function nearWanted()
    local _ = false
	nearWanted_window = false
    local list = {}
    nearWanted_list = {}
    nearWanted_state = imgui.ImBool(false)
    addEventHandler("onReceiveRpc",function(id, bs)
        if id == 93 and nearWanted_state.v then
            color = raknetBitStreamReadInt32(bs)
            textl = raknetBitStreamReadInt32(bs)
            text = raknetBitStreamReadString(bs, textl)
            if tostring(text):match("(.)Ошибка(.) [{]FFFFFF[}]Игроков с таким уровнем розыска нету[!]") and _ then
                return false
			end
            if tostring(text):match("был[(]а[)] объявлен[(]a[)] в розыск[!]") then
                lua_thread.create(function()
                    local nickname = text:match("[}]%w+[_]%w+[(]")
					nickname = nickname:sub(2, nickname:len() - 1)
					local id = text:match("[}]%d+[{]")
					id = id:sub(2, id:len() - 1)
					local w = nickname.." ["..id.."]"
                    table.insert(nearWanted_list, w)
				end)
			end
		end
		if id == 61 and nearWanted_state.v and _ then
			local did = raknetBitStreamReadInt16(bs)
			local style = raknetBitStreamReadInt8(bs)
			local tl = raknetBitStreamReadInt8(bs)
			local t = raknetBitStreamReadString(bs,tl)
			local b1l = raknetBitStreamReadInt8(bs)
			local b1 = raknetBitStreamReadString(bs,b1l)
			local b2l = raknetBitStreamReadInt8(bs)
			local b2 = raknetBitStreamReadString(bs,b2l)
			local text = raknetBitStreamDecodeString(bs,4096)
            if text:match("Ник") and text:match("[{]58F865[}]Уровень розыска[{]FFFFFF[}]") then
                local t = stringSplit(text, "\n")
                for i = 2, #t do
					local nickname = t[i]:match("[}]%w+[_]%w+[(]")
					nickname = nickname:sub(2, nickname:len() - 1)
					local id = t[i]:match("[}]%d+[{]")
					id = id:sub(2, id:len() - 1)
					local w = nickname.." ["..id.."]"
                    table.insert(list, w)
				end
                return false
			end
		end
	end)
	if nearWanted_state.v then
		list = {}
		_ = true
		if nearWanted_state.v then sampSendChat("/wanted 1") end
		if nearWanted_state.v then wait(1000) end
		if nearWanted_state.v then sampSendChat("/wanted 2") end
		if nearWanted_state.v then wait(1000) end
		if nearWanted_state.v then sampSendChat("/wanted 3") end
		if nearWanted_state.v then wait(1000) end
		if nearWanted_state.v then sampSendChat("/wanted 4") end
		if nearWanted_state.v then wait(1000) end
		if nearWanted_state.v then sampSendChat("/wanted 5") end
		if nearWanted_state.v then wait(1000) end
		if nearWanted_state.v then sampSendChat("/wanted 6") end
		if nearWanted_state.v then wait(1000) end
		_ = false
		nearWanted_list = {}
		for i = 1, #list do
			table.insert(nearWanted_list, list[i])
		end
		for i = 0, 120, 1 do
			wait(1000)
			if not nearWanted_state.v then break end
		end
	end
end
function fixInv()
	local fix = false
	addEventHandler("onSendRpc", function(id,bs)
		if id == 50 then
			local lenght = raknetBitStreamReadInt32(bs)
			local text = tostring(raknetBitStreamReadString(bs,lenght))
			if text == ("/fix") then
                lua_thread.create(function()
					wait(0)
					fix = true
					sampSendChat("/donate")
					wait(3000)
					fix = false
				end)
                return false
			end
		end
	end)
	addEventHandler("onReceiveRpc", function(id,bs)
		if id == 61 and fix then
			local d_id = raknetBitStreamReadInt16(bs)
			local style = raknetBitStreamReadInt8(bs)
			local tl = raknetBitStreamReadInt8(bs)
			local t = raknetBitStreamReadString(bs,tl)
			local b1l = raknetBitStreamReadInt8(bs)
			local b1 = raknetBitStreamReadString(bs,b1l)
			local b2l = raknetBitStreamReadInt8(bs)
			local b2 = raknetBitStreamReadString(bs,b2l)
			local text = raknetBitStreamDecodeString(bs,4096)
			if t == "{BFBBBA}Платные услуги" then
				sampSendDialogResponse(dialogId, 0, 0, "")
				return false
			end
		end
	end)
	while true do wait(0) end
end
function fastMoney()
	fastMoney_state = imgui.ImBool(mainIni.settings.fastMoney_state_c)
	while true do wait(0)
		if fastMoney_state.v then
			memory.write(5707667, 138, 1, false)
			else
			memory.write(5707667, 139, 1, false)
		end
	end
end
function autoAltAndShift()
	autoAltAndShift_state = imgui.ImBool(mainIni.settings.autoAltAndShift_state_c)
	addEventHandler("onReceiveRpc", function(id,bs)
		if id == 134 and autoAltAndShift_state.v then
            local tid = raknetBitStreamReadInt16(bs)
            local flags = raknetBitStreamReadInt8(bs)
            local letterW = raknetBitStreamReadFloat(bs)
            local letterH = raknetBitStreamReadFloat(bs)
            local letterColor = raknetBitStreamReadInt32(bs)
            local lineW = raknetBitStreamReadFloat(bs)
            local lineH = raknetBitStreamReadFloat(bs)
            local boxColor = raknetBitStreamReadInt32(bs)
            local shadow = raknetBitStreamReadInt8(bs)
            local outline = raknetBitStreamReadInt8(bs)
            local backgroundColor = raknetBitStreamReadInt32(bs)
            local style = raknetBitStreamReadInt8(bs)
            local selectable = raknetBitStreamReadInt8(bs)
            local X = raknetBitStreamReadFloat(bs)
            local Y = raknetBitStreamReadFloat(bs)
            local model = raknetBitStreamReadInt16(bs)
            local rotX = raknetBitStreamReadFloat(bs)
            local rotY = raknetBitStreamReadFloat(bs)
            local rotZ = raknetBitStreamReadFloat(bs)
            local zoom = raknetBitStreamReadFloat(bs)
            local color1 = raknetBitStreamReadInt16(bs)
            local color2 = raknetBitStreamReadInt16(bs)
            local textLen = raknetBitStreamReadInt16(bs)
            local text = raknetBitStreamReadString(bs, textLen)
			if text == "PRESS ~r~SHIFT" then
				lua_thread.create(function()
                    wait(50)
                    setVirtualKeyDown(0x10, true)
                    wait(50)
                    setVirtualKeyDown(0x10, false)
				end)
			end
			if text == "PRESS ~r~ALT" then
				lua_thread.create(function()
                    wait(50)
                    setVirtualKeyDown(0x12, true)
                    wait(50)
                    setVirtualKeyDown(0x12, false)
				end)
			end
		end
	end)
	while true do wait(0) end
end
function autoSport()
	autoSport_state = imgui.ImBool(mainIni.settings.autoSport_state_c)
	local blockMessage = false
	addEventHandler("onReceiveRpc", function(id,bs)
		if id == 73 and autoSport_state.v then
			dStyle = raknetBitStreamReadInt32(bs)
			dTime = raknetBitStreamReadInt32(bs)
			dMessageLength = raknetBitStreamReadInt32(bs)
			dMessage = raknetBitStreamReadString(bs,dMessageLength)
			if dMessage == "~n~~n~~n~~n~~n~~n~~n~~n~~w~Style: ~g~Comfort!" then
				lua_thread.create(function()
					sampSendChat("/style")
					blockMessage = true
					wait(1000)
					blockMessage = false
				end)
			end
		end
		if id == 93 and autoSport_state.v and blockMessage then
            color = raknetBitStreamReadInt32(bs)
            textl = raknetBitStreamReadInt32(bs)
            text = raknetBitStreamReadString(bs, textl)
            if tostring(text):match("%[Ошибка%] {FFFFFF}Изменить стиль езды можно только если у вас установлены технические модификации или на полицейских авто!") then
                return false
			end
		end
	end)
	while true do wait(0) end
end
function save()
	local newData = {
		settings = {
			activate_cmd_c = activate_cmd.v,
			removeLogo_state_c = removeLogo_state.v,
			ctime_state_c = ctime_state.v,
			skipZZ_state_c = skipZZ_state.v,
			fastReport_state_c = fastReport_state.v,
			carkey_state_c = carkey_state.v,
			autopin_state_c = autopin_state.v,
			autopin_pin_c = autopin_pin.v,
			moneySeparate_state_c = moneySeparate_state.v,
			chatCalc_state_c = chatCalc_state.v,
			getGuns_state_c = getGuns_state.v,
			antiDrugs_state_c = antiDrugs_state.v,
			resendVr_state_c = resendVr_state.v,
			antiCarSkill_state_c = antiCarSkill_state.v,
			noBike_state_c = noBike_state.v,
			launcherEmul_state_c = launcherEmul_state.v,
			launcherEmul_veh_c = launcherEmul_veh.v,
			fishEye_state_c = fishEye_state.v,
			fastFill_state_c = fastFill_state.v,
			fastMoney_state_c = fastMoney_state.v,
			autoAltAndShift_state_c = autoAltAndShift_state.v,
			autoSport_state_c = autoSport_state.v,
		},
		afktools = {
			antiafk_state_c = antiafk_state.v,
			autologin_state_c = autologin_state.v,
			autologin_pass_c = autologin_pass.v,
			autoEat_state_c = autoEat_state.v,
			autoEat_disableAnim_c = autoEat_disableAnim.v,
			autoReconnect_state_c = autoReconnect_state.v,
			autoReconnect_delay_c = autoReconnect_delay.v,
			autoHeal_state_c = autoHeal_state.v,
			autoRoulette_state_c = autoRoulette_state.v,
			autoRoulette_delay_c = autoRoulette_delay.v,
		},
		removeTrash = {
            state_c = removeTrash_enable.v,
			clearChatAfterConnect_c = removeTrash_clearChatAfterConnect.v,
			bonus_status_c = removeTrash_bonus_status.v,
			events_status_c = removeTrash_events_status.v,
			help_status_c = removeTrash_help_status.v,
			ad_status_c = removeTrash_ad_status.v,
			player_status_c = removeTrash_player_status.v,
			trash_status_c = removeTrash_trash_status.v,
			phone_status_c = removeTrash_phone_status.v,
			space_status_c = removeTrash_space_status.v,
            bus_status_c = removeTrash_bus_status.v,
            inkasator_status_c = removeTrash_inkasator_status.v,
			zoloto_status_c = removeTrash_zoloto_status.v,
			sobes_status_c = removeTrash_sobes_status.v,
            prison_status_c = removeTrash_prison_status.v,
			offDesc_state_c = offDesc_state.v,
			offFam_state_c = offFam_state.v,
		},
		setTime = {
			state_c = setTime_state.v,
			localTime_state_c = setTime_localTime_state.v,
			time_c = setTime_time.v,
			weather_c = setTime_weather.v,
		},
		police = {
			taser_state_c = taser_state.v,
			rpGuns_state_c = rpGuns_state.v,
			megafon_state_c = megafon_state.v,
			autoMiranda_state_c = autoMiranda_state.v,
			autoRP_state_c = autoRP_state.v,
			requireSu_state_c = requireSu_state.v,
		}
	}
	inicfg.save(newData,"unknown.ini")
end
function stringSplit(str, pattern)
    if pattern == nil then
        pattern = "%s"
	end
    local t = {}
    for inputstr in string.gmatch(str, "([^"..pattern.."]+)") do
        table.insert(t, inputstr)
	end
    return t
end
function onScriptTerminate(script, quit)
    if script == thisScript() then
        thisScript():reload()
	end
end
function autoupdate(json_url, prefix, url)
    local dlstatus = require('moonloader').download_status
    local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
    if doesFileExist(json) then os.remove(json) end
    downloadUrlToFile(json_url, json,
        function(id, status, p1, p2)
            if status == dlstatus.STATUSEX_ENDDOWNLOAD then
                if doesFileExist(json) then
                    local f = io.open(json, 'r')
                    if f then
                        local info = decodeJson(f:read('*a'))
                        updatelink = info.updateurl
                        updateversion = info.latest
                        f:close()
                        os.remove(json)
                        if updateversion ~= thisScript().version then
                            lua_thread.create(function(prefix)
                                local dlstatus = require('moonloader').download_status
                                local color = -1
                                wait(250)
                                downloadUrlToFile(updatelink, thisScript().path,
                                    function(id3, status1, p13, p23)
                                        if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                                            elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                                            sampAddChatMessage("{c41e3a}[Helper]: {ffffff}Обновление прошло успешно на версию "..updateversion,-1)
                                            goupdatestatus = true
                                            lua_thread.create(function() wait(500) thisScript():reload() end)
										end
                                        if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                                            if goupdatestatus == nil then
                                                update = false
											end
										end
									end
								)
							end, prefix
                            )
                            else
                            update = false
						end
					end
                    else
                    update = false
				end
			end
		end
	)
    while update ~= false do wait(100) end
	end			