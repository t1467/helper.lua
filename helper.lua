script_name("UNKNOWN")
script_version("1.7.10")
require 'lib.moonloader'
require 'sampfuncs'
require 'events'
require 'ffi'
local vkeys = require 'vkeys'
local rkeys = require 'rkeys'
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
		moneySeparate_state_c = false,
		cruise_state_c = false,
		sbiv_state_c = false,
		notepad_text_c = "",
		autolock_state_c = false,
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
	autoPiar = {
		delay_c = 300,
		text_c = "",
		vr_c = false,
		ad_c = false,
		ad_vip_c = false,
		j_c = false,
		org_c = false,
		selected_org = 0,
	},
	police = {
		taser_state_c = false,
		rpGuns_state_c = false,
		megafon_state_c = false,
		autoMiranda_state_c = false,
		autoRP_state_c = false,
		requireSu_state_c = false,
	},
	insurance = {
		catch_state_c = false,
		NY_state_c = false,
		fill_state_c = false,
		anim_state_c = false,
	},
	medic = {
		
	},
},"unknown.ini")
cursorActive = false
playerLock = false
main_window = false
settings_window = true
afk_window = false
removeTrash_window = false
setTime_window = false
police_window = false
autoPiar_window = false
insurance_window = false
medic_window = false
function closeAllWindow()
	settings_window = false
	afk_window = false
	removeTrash_window = false
	setTime_window = false
	police_window = false
	autoPiar_window = false
	insurance_window = false
	medic_window = false
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
		if imgui.Button(u8"Авто пиар", imgui.ImVec2(-1,20)) then closeAllWindow() autoPiar_window = true end
		imgui.Text(u8"")
		if imgui.CollapsingHeader(u8"Организации") then
			if imgui.Button(u8">> Для собеседований <<", imgui.ImVec2(-1,20)) then sobes_state.v = not sobes_state.v end
			if imgui.Button(u8"Полиция", imgui.ImVec2(-1,20)) then closeAllWindow() police_window = true end
			if imgui.Button(u8"Страховая", imgui.ImVec2(-1,20)) then closeAllWindow() insurance_window = true end
			if  0 == 2 then
				if imgui.Button(u8"Медицинский центр", imgui.ImVec2(-1,20)) then closeAllWindow() medic_window = true end
			else
				local r, g, b, a = imgui.ImColor(imgui.GetStyle().Colors[imgui.Col.Button]):GetFloat4()
				imgui.PushStyleColor(imgui.Col.Button, imgui.ImVec4(r, g, b, a/2) )
				imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.ButtonActive, imgui.ImVec4(r, g, b, a/2))
				imgui.PushStyleColor(imgui.Col.Text, imgui.GetStyle().Colors[imgui.Col.TextDisabled])
				imgui.Button(u8"Медицинский центр", imgui.ImVec2(-1,20))
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
				imgui.PopStyleColor()
			end
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
			imgui.Checkbox(u8"Калькулятор в чате", chatCalc_state)
			imgui.Checkbox(u8"Оружие по команде", getGuns_state)
            if getGuns_state.v then imgui.Text(u8"/de /m4 /sh /ri /ak /uzi") end
			imgui.Checkbox(u8"Анти-ломка", antiDrugs_state)
			imgui.Checkbox(u8"Разделение денег запятыми", moneySeparate_state)
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
			imgui.Checkbox(u8"Круиз контроль на (=)", cruise_state)
			imgui.Checkbox(u8"Сбив на Q", sbiv_state)
			imgui.Checkbox(u8"Авто-лок для транспорта", autolock_state)
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
				if imgui.InputInt(u8"Время", setTime_time, 1, 100) then setTime_localTime_state.v = false end
				imgui.InputInt(u8"Погода", setTime_weather, 1, 100)
			end
		end
		if autoPiar_window then
			imgui.Checkbox(u8"Включить", autoPiar_state)
			if autoPiar_state.v then imgui.Text(u8"До следующего пиара "..u8(autoPiar_timer)..u8" секунд") end
			if imgui.InputText(u8"Текст", autoPiar_text) then autoPiar_state.v = false end
			if imgui.InputInt(u8"Задержка", autoPiar_delay) then autoPiar_state.v = false end
			imgui.Checkbox(u8"Пиар в вип-чат", autoPiar_vr)
			imgui.Checkbox(u8"Пиар в объявления", autoPiar_ad)
			if autoPiar_ad.v then imgui.SameLine(150) imgui.Checkbox(u8"Вип-объявления", autoPiar_ad_vip) end
			imgui.Checkbox(u8"Пиар в рабочий чат", autoPiar_j)
			imgui.Checkbox(u8"Пиар в чат организации", autoPiar_org)
			if autoPiar_org.v then imgui.Combo(u8'Организация', autoPiar_selected_org, {u8"Нелегал", u8"Гос"}, 2) end
		end
		if police_window then
			imgui.Checkbox(u8"Поиск преступников в зоне стрима", nearWanted_state)
			imgui.Checkbox(u8"Траффик-стоп хелпер", traffic_stop_state)
			imgui.Checkbox(u8"Патруль хелпер", patrol_state)
			imgui.Checkbox(u8"Авто-отыгровка команд", autoRP_state)
			imgui.Checkbox(u8"Запрос розыска для 1-4 ранг", requireSu_state)
			imgui.Checkbox(u8"Авто-отыгровка оружия", rpGuns_state)
			imgui.Checkbox(u8"Зачитать права /rights", autoMiranda_state)
			imgui.Checkbox(u8"Тазер на X", taser_state)
			imgui.Checkbox(u8"Кричать в мегафон на M", megafon_state)
		end
		if insurance_window then
			imgui.Checkbox(u8"Ловец заявлений", insuranceCatch_state)
			imgui.Checkbox(u8"Авто N/Y", insuranceNY_state)
			imgui.Checkbox(u8"Авто заполнение", insuranceFill_state)
			imgui.Checkbox(u8"Отключение анимации документов", insuranceRemoveAnim_state)
		end
		if medic_window then
			imgui.Text(u8"В разработке")
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
        imgui.SetNextWindowPos(imgui.ImVec2(x / 2 - 150, y - 160), imgui.Cond.FirstUseEver)
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
	if sobes_state.v then
        local x, y = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(x / 2 - 100, y - 185), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowSize(imgui.ImVec2(200,175))
        imgui.GetStyle().Colors[imgui.Col.WindowBg] = imgui.ImVec4(0, 0, 0, 1.00)
        imgui.Begin(u8'Собеседование', window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
		if imgui.Button(u8"Приветствие", imgui.ImVec2(-1,20)) then sobes_gofunc(1) end
		if imgui.Button(u8"Расскажите о себе", imgui.ImVec2(-1,20)) then sobes_gofunc(2) end
		if imgui.Button(u8"Почему выбрали нас", imgui.ImVec2(-1,20)) then sobes_gofunc(7) end
		if imgui.Button(u8"Документы", imgui.ImVec2(-1,20)) then sobes_gofunc(3) end
		if imgui.Button(u8"Посмотреть документы", imgui.ImVec2(-1,20)) then sobes_gofunc(4) end
		if imgui.Button(u8"Приняты", imgui.ImVec2(90,20)) then sobes_gofunc(5) end
		imgui.SameLine(100)
		if imgui.Button(u8"Отказ", imgui.ImVec2(90,20)) then sobes_gofunc(6) end
        imgui.End()
        theme()
	end
	if traffic_stop_state.v then
        local x, y = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(x / 2 - 100, y - 205), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowSize(imgui.ImVec2(200,195))
        imgui.GetStyle().Colors[imgui.Col.WindowBg] = imgui.ImVec4(0, 0, 0, 1.00)
        imgui.Begin(u8'Траффик стоп', window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
		if imgui.Button(u8"Прикаснуться к фаре", imgui.ImVec2(-1,20)) then traffic_stop_gofunc(1) end
		if imgui.Button(u8"Приветствие", imgui.ImVec2(-1,20)) then traffic_stop_gofunc(2) end
		if imgui.Button(u8"Изучить документы", imgui.ImVec2(-1,20)) then traffic_stop_gofunc(3) end
		imgui.Text(u8"")
		if imgui.Button(u8"Все хорошо", imgui.ImVec2(-1,20)) then traffic_stop_gofunc(4) end
		if imgui.Button(u8"Штраф", imgui.ImVec2(-1,20)) then traffic_stop_gofunc(5) end
		if imgui.Button(u8"Попросить выйти из авто", imgui.ImVec2(-1,20)) then traffic_stop_gofunc(6) end
        imgui.End()
        theme()
	end
	if patrol_state.v then
        local xс, yс = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(xс / 2 - 125, yс - 210), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowSize(imgui.ImVec2(250,200))
        imgui.GetStyle().Colors[imgui.Col.WindowBg] = imgui.ImVec4(0, 0, 0, 1.00)
        imgui.Begin(u8'Патруль', window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
		imgui.Combo(u8'Маркировка', patrol_selected, {"LINCOLN", "ADAM", "MARY", "AIR", "EDWARD"}, 5)
		if imgui.Button(u8"Выехал в патруль", imgui.ImVec2(-1,20)) then patrol_gofunc(1) end
		if imgui.Button(u8"Продолжаю патруль", imgui.ImVec2(-1,20)) then patrol_gofunc(2) end
		if imgui.Button(u8"10-55", imgui.ImVec2(-1,20)) then patrol_gofunc(3) end
		if imgui.Button(u8"10-66", imgui.ImVec2(-1,20)) then patrol_gofunc(4) end
		if imgui.Button(u8"Перестрелка", imgui.ImVec2(-1,20)) then patrol_gofunc(5) end
		if imgui.Button(u8"Погоня", imgui.ImVec2(-1,20)) then patrol_gofunc(6) end
        imgui.End()
        theme()
	end
	if notepad_window then
        local xс, yс = getScreenResolution()
        imgui.SetNextWindowPos(imgui.ImVec2(xс / 2 - 350, yс / 2 - 200), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowSize(imgui.ImVec2(700,400))
        imgui.GetStyle().Colors[imgui.Col.WindowBg] = imgui.ImVec4(0, 0, 0, 1.00)
        imgui.Begin(u8'Блокнот', window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoMove)
		imgui.InputTextMultiline(u8"##sdfg", notepad_text, imgui.ImVec2(685,365))
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
	lua_thread.create(moneySeparate)
	lua_thread.create(sobes)
	lua_thread.create(traffic_stop)
	lua_thread.create(patrol)
	lua_thread.create(autoPiar)
	lua_thread.create(insuranceCatch)
	lua_thread.create(insuranceNY)
	lua_thread.create(insuranceFill)
	lua_thread.create(insuranceRemoveAnim)
	lua_thread.create(cruise)
	lua_thread.create(sbiv)
	lua_thread.create(notepad)
	lua_thread.create(autolock)
	lua_thread.create(function()
		repeat wait(0) until sampIsLocalPlayerSpawned()
		sampAddChatMessage("{c41e3a}[Unknown]: {ffffff}Хелпер запущен, активация: {c41e3a}/"..activate_cmd.v,-1)
	end)
	imgui.Process = true
	while true do wait(0)
        imgui.ShowCursor = cursorActive
        imgui.LockPlayer = playerLock
		pcall(function() save() end)
	end
end
function onWindowMessage(msg, wparam, lparam)
	if wparam == 0x1B and (main_window or cursorActive or notepad_window) then
		main_window = false
		notepad_window = false
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
			local text = raknetBitStreamReadString(bs,lenght)
			if text == ("/"..activate_cmd.v) then
                main_window = true
                cursorActive = true
                playerLock = true
                return false
			end
		end
	end)
	while true do wait(0) end
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
			if title:match("{BFBBBA}Авторизация") and tonumber(style) == 3 then
				sampSendDialogResponse(id,1,1,autologin_pass.v)
				return false
			end
		end
	end)
	while true do wait(0) end
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
            local textlenght = raknetBitStreamReadInt32(bs)
			local text = raknetBitStreamReadString(bs,textlenght)
            if text:match('You are hungry%!') or text:match('You are very hungry%!') then
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
			if animname == "EAT_Burger" then
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
			if text:match("{42B02C}%-{FFFFFF} {A5EC67}Открыть{FFFFFF} дом") or text:match("{42B02C}%-{FFFFFF} {EC6767}Закрыть{FFFFFF} дом") then
                sampSendDialogResponse(id,1,1,"")
                return false
			end
            if text:match("{42B02C}%-{FFFFFF} Холодильник") then
                sampSendDialogResponse(id,1,2,"")
                return false
			end
            if text:match("Комплексный Обед") then
                sampSendDialogResponse(id,1,6,"")
                return false
			end
			if text:match("{42B02C}%-{FFFFFF} Продать дом игроку") or text:match("{42B02C}%-{FFFFFF} Предметы недвижимости") then
				lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/jmeat")
				end)
                return false
			end
		end
        if id == 93 and autoEat_state.v and eat then
            color = raknetBitStreamReadInt32(bs)
            count = raknetBitStreamReadInt32(bs)
			text = raknetBitStreamReadString(bs, count)
            if text:match("%[Ошибка%] {FFFFFF}Вы не у своего дома") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/jmeat")
				end)
                return false
			end
            if text:match("%[Ошибка%] {FFFFFF}Вы не живете ни .+ из домов") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/jmeat")
				end)
                return false
			end
            if text:match("В доме недостаточно продуктов, купить их можно в закусочной%!") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/jmeat")
				end)
				eat = false
				return false
			end
            if text:match("У тебя нет жареного мяса оленины%!") then
                autoEat_state.v = false
                sampAddChatMessage("{c41e3a}[Unknown]: {ffffff}У вас закончилась оленина, авто-еда отключена",-1)
				eat = false
                return false
			end
            if text:match("%[Ошибка%] {FFFFFF}Вам отключили электроэнергию%! Оплатите коммуналку%!") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/jmeat")
				end)
                return false
			end
            if text:match("%[Ошибка%] {FFFFFF}Вы не в своём доме%!") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/jmeat")
				end)
                return false
			end
            if text:match("%[Ошибка%] {FFFFFF}У вас нет мешка с мясом%!") then
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
	addEventHandler("onReceiveRpc", function(id,bs)
		if id == 134 and removeLogo_state.v then
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
			for i = 510, 530 do
				if tid == i then return false end
			end
		end
	end)
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
			if text:match("В этом месте запрещено") and text:match("драться/стрелять") then
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
	while true do wait(0) end
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
        "%[PUBG%] Внимание%! Через 15 минут в 19:05 начнется матч по игре PUBG. Призы за ТОП%-3: {FFD700}2000, 1500, 500 AZ Coins{ffffff}.",
        "%[DM%-арена%] {FFFFFF}Условия турнира: за каждое убийство {33AA33}.+%d+,%d+{ffffff} и смерть {ae433d}.+%d+,%d+{ffffff}",
        "%[DM%-арена%] {FFFFFF}Внимание! Через %d+ минут стартует турнир, принять могут все желающие. %( /gps %- Разное %- DM арена %)",
        "%[Автомобильный аукцион%] Через %d+ минут в %d+:%d+ стартует аукцион автомобилей%! %( /gps %- Автосалоны %- Автомобильный аукцион %)",
        "%[Горячая Звезда%] Мероприятие завершилось без определения победителя, так как в момент завершения горячая звезда находилась на земле%!",
        "%[Подсказка%] {FF6347}Мероприятие: .Собиратели., начнется в {FFFFFF}20.15%!{FF6347} Используйте: /findcollectors",
        ".+{FFFFFF}Уважаемые жители, арендатор концертного зала: .+%[%d+%] проводит мероприятие. Присоединяйтесь%! %(GPS %- Развлечения%).",
        "%[PUBG%] {ffffff}Внимание%! Турнир был завершен, список ТОП%-3 победителей:",
        "%d. {FFFFFF}.+ заработал {ae433d}%d+ AZ Coins",
        "%[Автомобильный аукцион%] Внимание%! На пляже Santa Maria проводится автомобильный аукцион%! %( /gps %- Автосалоны %- Автомобильный аукцион %)",
        "%[PUBG%] Регистрация уже доступна%! %( /gps %- Мероприятия %- PUBG %)",
        "%[PUBG%] Внимание%! Через %d+ минуту в %d+:%d+ начнется матч по игре PUBG. Призы за ТОП%-3: {FFD700}2000, 1500, 500 AZ Coins{ffffff}.",
        "%[Мероприятие%] {ffffff}Телепорт на мероприятие закрыт, время вышло.",
        "%[Информация%] Самолёты с гумманитарной помощью сбросили %d+ подарков по всей карте штата, найдите и заберите ценный подарок%!",
        "%[Внимание%] Началась регистрация на мероприятие .Воздушный Бой. | /gps .+ День Защитника .+ Регистрация на мероприятия",
        "%[Внимание%] Началась регистрация на мероприятие .Звёздные заезды. | /gps .+ День Защитника .+ Регистрация на мероприятия",
        "Битва за контроль грузового корабля начнется через %d+ минут%! Используйте /govess",
        "Внимание%! Уже через %d+ минут начинается распродажа одежды в секонд%-хенде №%d+%!",
		"Внимание%! Уже через 5 минут начинается распродажа одежды в .+",
        "%[DM%-арена%] {FFFFFF}Внимание%! Начался турнир для всех желающих. %( /gps %- Разное %- DM арена %)",
        "%[PUBG%] Внимание%! Через %d+ минут в %d+:%d+ начнется матч по игре PUBG. Призы за ТОП%-3: {FFD700}2000, 1500, 500 AZ Coins{ffffff}.",
        "%[DM%-арена%] {FFFFFF}Условия турнира: за каждое убийство {33AA33}%+.%d+{ffffff} и смерть {ae433d}%-.%d+{ffffff}",
        "%[Конные скачки%] {FFFFFF}Внимание! Через %d+ минут откроется приём ставок. %( /gps %- Разное %)",
        "%[Автомобильный аукцион%] Внимание%! Начался аукцион автомобилей%! %( /gps %- Автосалоны %- Автомобильный аукцион %)",
		"Мероприятие .Зловещий дворец. завершено%!",
	}
    removeTrash_help = {
        "Не снимайте наушники, пока не закончите тренировку, иначе вы можете попасть в больницу%!",
        "%[Информация%] {FFFFFF}Вы можете заправить полный бак %- нажав на стоимость топлива",
        "%[Информация%] {FFFFFF}Используйте курсор чтобы выбрать тип топлива и его кол%-во",
        "Возьмите материалы и начните сборку заново.",
        "%[Ошибка%] {FFFFFF}Отнесите материалы к остальным материалам.",
        "%[Информация%] {FFFFFF}Узнать цвета можно на форуме forum.arizona%-rp.com",
        "%[Информация%] {FFFFFF}Подойдите к машине и переодически жмите левую клавишу мышки.+для того чтобы ее покрасить%!",
        "{DFCFCF}%[Подсказка%] {DC4747}Чтобы включить радио используйте кнопку {DFCFCF}R",
        "%[Подсказка%]{FFFFFF} Используйте /phone %- menu, чтобы найти членов организаций.",
        "%[Подсказка%] {ffffff}Чтобы клиент был засчитан в квест/достижения, в зарплату в PayDay, нужно проезжать с ним более длинные расстояния.",
        ".+{FFFFFF} %- У вас недостаточно денег. Вы можете пополнить свой баланс ./donate.",
        "{DFCFCF}%[Подсказка%] {DC4747}Вы можете задать вопрос в нашу техническую поддержку /report",
        "{DFCFCF}%[Подсказка%] {DC4747}Советуем получить паспорт, а затем отправиться на ферму или завод для заработка денег на права.",
        "{DFCFCF}%[Подсказка%]{8F1E1E} У вас не привязан e%-mail адрес. Привяжите его дабы подтвердить ваш аккаунт /mm %- Настройки %- e%-mail.",
        "{DFCFCF}.+{DC4747} Пока вы малоимущий {DFCFCF}%(до 4%-го уровня%){DC4747}, на улице вы можете попрошайничать деньги.",
        "%[Информация%]{FFFFFF} Хотдог для вас бесплатный%! Осталось %d+ талонов на бесплатный хотдог",
        "{DC4747}Используйте команду {DFCFCF}/beg{DC4747}, чтобы поставить табличку и банку для денег%!",
        "%[Подсказка%] С помощью телефона можно заказать такси. Среднее время ожидания %- 2 минуты%!",
        "{DFCFCF}%[Подсказка%] {DC4747}Ваш текущий навык вождения: {DFCFCF}.%d+/%d+.{DC4747}  Информация: /carskill",
        "{DFCFCF}%[Подсказка%] {DC4747}В транспорте может присутствует радио{DFCFCF} ./radio.",
        "{DFCFCF}%[Подсказка%] {DC4747}Для управления поворотниками используйте клавиши: {DFCFCF}%(Q/E%)",
        "{DFCFCF}%[Подсказка%] {DC4747}Чтобы завести двигатель введите {DFCFCF}/engine{DC4747} или нажмите {DFCFCF}N",
        "Используйте клавишу .Y. для того, чтобы показать курсор управления или .ESC. %- скрыть",
        "Устроиться на работу можно в центре занятости.",
        "Вы подобрали мусор, отнесите его в машину %(ALT сзади авто%)",
        "%[Подсказка%] Теперь вы будете получать зарплату вдвое больше %(если будете работать вместе%)",
        "%[Подсказка%] Чтобы разорвать партнерство, введите /roadpartner",
        "%[Подсказка%] Откройте карту ремонта дорог.+roadmap%) и узнайте где требуется ремонт",
        "{73B461}Поступил вызов, чтобы принять введите /gopolice",
		"%[Подсказка%] Игроки владеющие 4%-я домами могут бесплатно раз в день получать .2 Ларца Олигарха. в банке и его отделениях.",
        "Чтобы закрыть рулетку, используйте: {FFFFFF}'ESC'",
        "%[Подсказка%] {FFFFFF}Добыча на земле, беги хватай%!",
        ".В. Шлагбаум закроется через %d+ секунд",
		"%[Подсказка%] Чтобы собрать урожай, дождитесь созревания урожая",
		"%[Подсказка%] После того как урожай созреет, подойдите к грядке нажмите .ALT.%!",
		"%[Информация%] {FFFFFF}Состояние масла вашего авто крайне плохое%!",
		"%[Информация%] Автомобиль работает с перебоями, скорость снижена, машина может сломаться%!",
		"Необходимо заехать на станцию тех. обслуживания%! %(%(Используйте /gps важные места %- станция тех. обслуживания%)%)",
		"%[Подсказка%] Чтобы подавать объявление из любого места, купите улучшение персонажа: /mm > Действия персонажа > Улучшения > Планшет",
		"Чтобы узнать на каком этапе находится рассмотрение и понять что нужно делать %- {ffffff}используйте команду /insurhelp",
		"%[Подсказка%] {ffffff}Вам необходимо отправиться в кабинет .+ и заполнить некоторые документы",
		"%[Подсказка%] {ffffff}Вам необходимо отправиться в кабинет .+ и заполнить еще один документ",
		"%[Подсказка%] {ffffff}Вам необходимо отправиться в кабинет .+ и заполнить последний документ",
	}
    removeTrash_ad = {
        "%- Наш сайт: arizona%-rp.com %(Личный кабинет/Донат%)",
        "%- Пригласи друга и получи бонус в размере .300 000%!",
        "%- Основные команды сервера: /menu /help /gps /settings",
        "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~",
        "В нашем магазине ты можешь приобрести нужное количество игровых денег и потратить",
        "их на желаемый тобой {FFFFFF}бизнес, дом, аксессуар{6495ED} или на покупку каких%-нибудь безделушек.",
        "%- Игроки со статусом {FFFFFF}VIP{6495ED} имеют больше возможностей, подробнее /help .Преимущества VIP.",
        "%- Игроки со статусом {FFFFFF}VIP{6495ED} имеют большие возможности, подробнее /help .Преимущества VIP.",
        "%- В магазине также можно приобрести редкие {FFFFFF}автомобили, аксессуары, воздушные шары{6495ED} и",
        "%- В магазине так%-же можно приобрести редкие {FFFFFF}автомобили, аксессуары, воздушные шары%{6495ED},",
        "предметы, которые выделят тебя из толпы%! Наш сайт: {FFFFFF}arizona%-rp.com",
	}
    removeTrash_player = {
        "%[Информация%]{FFFFFF} Игрок .+ приобрел Titan VIP.",
        "%[Информация%] .+ при сборе урожая на ферме словил грядку для собственного выращивания льна.",
        "%[Информация%]{FFFFFF} Игрок .+ приобрел PREMIUM VIP.",
        ".+ Игрок {FF6347}.+%(%d+%){FFFFFF} купил улучшение {FF6347}.Бизнесмен.{FFFFFF}, теперь он может владеть 5%-ю бизнесами.",
        ".+ Игрок {FF6347}.+%(%d+%){FFFFFF} купил улучшение {FF6347}.Больше недвижимости.{FFFFFF}, теперь он может владеть 4 домами.",
        ".+ испытал удачу при открытии .+ и выиграл.+",
        "%[Информация%] .+ при сборе урожая на ферме словил .+",
		"Открыв СУНДУК с подарками, игрок .+ получил .+",
	}
    removeTrash_trash = {
        "Чтобы закрыть донат меню, используйте: {FFFFFF}.ESC.",
        "Двигатель успешно завелся | %-  ",
        "%[Информация%] {FFFFFF}Спасибо за ваш отзыв%!",
        "Если за вами необходимо срочно проследить, администрация сделает это вне очереди%!",
        "Рекомендуем кушать в закусочных, там намного дешевле%!",
        "Вы немного перекусили. Посмотреть состояние голода можно {FFFFFF}/satiety",
        "{DFCFCF}%[Подсказка%] {DC4747}На сервере есть инвентарь, используйте клавишу Y для работы с ним.",
        "{DFCFCF}%[Подсказка%] {DC4747}Вы можете задать вопрос в нашу техническую поддержку /report.",
        "Вы успешно приготовили %d жареный кусок мяса оленины%! Чтобы покушать, используйте: /eat или /jmeat",
        "Игрок подтвердил сделку%!",
        "Вы подтвердили сделку%!",
        "%[Ошибка%] {FFFFFF}Подождите немного.+",
        "Вы взяли .+ Посмотреть состояние голода можно {FFFFFF}/satiety",
        "%[Подсказка%] С помощью телефона можно заказать такси. Среднее время ожидания %- 2 минуты%!",
        "Обратите внимание что имея улучшение халявщик вы будете платить в 2 раза меньше%!",
		"Отредактировал сотрудник СМИ %[ .+ %] : .+%[%d+%]",
		"С вас взяли .+ Постарайтесь не нарушать в дальнейшем",
	}
    removeTrash_phone = {
        "%[Подсказка%] {FFFFFF}Номера телефонов государственных служб:",
        "{FFFFFF}1.{6495ED} 111 %- {FFFFFF}Проверить баланс телефона",
        "{FFFFFF}2.{6495ED} 060 %- {FFFFFF}Служба точного времени",
        "{FFFFFF}3.{6495ED} 911 %- {FFFFFF}Полицейский участок",
        "{FFFFFF}4.{6495ED} 912 %- {FFFFFF}Скорая помощь",
        "{FFFFFF}5.{6495ED} 913 %- {FFFFFF}Такси",
        "{FFFFFF}6.{6495ED} 914 %- {FFFFFF}Механик",
        "{FFFFFF}7.{6495ED} 8828 %- {FFFFFF}Справочная центрального банка",
        "{FFFFFF}8.{6495ED} 997 %- {FFFFFF}Служба по вопросам жилой недвижимости %(узнать владельца дома%)",
	}
    removeTrash_bonus = {
        "{BFBBBA}Акции на Arizona Role Play",
	}
    removeTrash_bus = {
        "Автобус по маршруту %(.+%) отъезжает через %d+ секунд.",
	}
    removeTrash_inkas = {
        "В городе .+ начал работу новый инкассатор%!",
        "Убив его, вы сможете получить деньги%!"
	}
    addEventHandler("onReceiveRpc", function(id, bs)
        if id == 93 and removeTrash_enable.v then
            color = raknetBitStreamReadInt32(bs)
            count = raknetBitStreamReadInt32(bs)
			text = raknetBitStreamReadString(bs, count)
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
                if text:match("Игрок .+ вышел при попытке избежать ареста и был наказан%!") then return false end
			end
		end
        if id == 61 and removeTrash_bonus_status.v then
            local id = raknetBitStreamReadInt16(bs)
            local style = raknetBitStreamReadInt8(bs)
            local tl = raknetBitStreamReadInt8(bs)
			local t = raknetBitStreamReadString(bs,tl)
            for i = 1, #removeTrash_bonus do
                if t:match(removeTrash_bonus[i]) then return false end
			end
		end
	end)
	while true do wait(0)
		if removeTrash_clearChatAfterConnect.v and removeTrash_enable.v then
			local chatstring = sampGetChatString(99)
			if chatstring:match("Connected to {B9C9BF}.+") then
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
	addEventHandler("onSendRpc", function(id,bs)
		if id == 50 then
			local lenght = raknetBitStreamReadInt32(bs)
			local text = raknetBitStreamReadString(bs,lenght)
			if text == ("/rec") then
                sampDisconnectWithReason(true)
				sampSetGamestate(1)
                return false
			end
		end
	end)
    while true do wait(0)
        local chatstring = sampGetChatString(99)
        if chatstring == "Server closed the connection." or chatstring == "You are banned from this server." or chatstring == "Use /quit to exit or press ESC and select Quit Game" or chatstring == "Wrong server password." and autoReconnect_state.v then
	        sampDisconnectWithReason(true)
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
			if text:match("/report%s") or text == "/report" then
                local str = text:sub(9, text:len())
                if str ~= null then
					if str:len() > 5 then
						report = str
						run = true
						lua_thread.create(function()
							wait(5000)
							run = false
						end)
						elseif str:len() == 0 then
						sampAddChatMessage("{c41e3a}[Unknown]: {ffffff}Используйте /report [текст]",-1)
						return false
						else
						sampAddChatMessage("{c41e3a}[Unknown]: {ffffff}Сообщение должно быть больше 6 символов",-1)
						return false
					end
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
			if tostring(text):match("{ffffff}Вы собираетесь написать сообщение Администрации") and run then
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
            if tostring(text):match("Необходимо вставить ключи в зажигание. Используйте: ./key.") then
                lua_thread.create(function()
                    sampSendChat("/key")
					run = true
					wait(1000)
					run = false
				end)
                return false
			end
            if text:match("заглушил%(а%) двигатель") then
                local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
                if _ then
					local nick = sampGetPlayerNickname(id)
					if text:match(tostring(nick)) and tostring(nick):len() > 0 then
						lua_thread.create(function()
							wait(0)
							sampSendChat("/key")
							run = true
							wait(1000)
							run = false
						end)
					end
				end
			end
            if text:match("вытащил%(а%) ключи из замка зажигания") and run then
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
			if text:match("{929290}Вы должны подтвердить свой PIN.+код") then
                sampSendDialogResponse(id,1,1,autopin_pin.v)
                return false
			end
            if text:match("PIN%-код принят") then
                sampSendDialogResponse(id,1,1,"")
                sampAddChatMessage("{c41e3a}[Unknown]: {ffffff}PIN-код принят",-1)
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
		if isKeyJustPressed(0x54) and not sampIsDialogActive() and not sampIsScoreboardOpen() and not isSampfuncsConsoleActive() then
			sampSetChatInputEnabled(true)
		end
	end
end
function fixCrosshair()
    while true do wait(0)
		memory.write(0x058E280, 0xEB, 1, true)
	end
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
	while true do wait(0) end
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
	while true do wait(0) end
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
                            sampAddChatMessage("{c41e3a}[Unknown]: {ffffff}Оружие не найдено",-1)
                            wait(100)
                            sampSendClickTextdraw(65535)
						end
					end)
					else sampAddChatMessage("{c41e3a}[Unknown]: {ffffff}Введите от 1 до 500 патронов",-1)
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
                            sampAddChatMessage("{c41e3a}[Unknown]: {ffffff}Оружие не найдено",-1)
                            wait(100)
                            sampSendClickTextdraw(65535)
						end
					end)
					else sampAddChatMessage("{c41e3a}[Unknown]: {ffffff}Введите от 1 до 500 патронов",-1)
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
                            sampAddChatMessage("{c41e3a}[Unknown]: {ffffff}Оружие не найдено",-1)
                            wait(100)
                            sampSendClickTextdraw(65535)
						end
					end)
					else sampAddChatMessage("{c41e3a}[Unknown]: {ffffff}Введите от 1 до 500 патронов",-1)
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
                            sampAddChatMessage("{c41e3a}[Unknown]: {ffffff}Оружие не найдено",-1)
                            wait(100)
                            sampSendClickTextdraw(65535)
						end
					end)
					else sampAddChatMessage("{c41e3a}[Unknown]: {ffffff}Введите от 1 до 500 патронов",-1)
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
                            sampAddChatMessage("{c41e3a}[Unknown]: {ffffff}Оружие не найдено",-1)
                            wait(100)
                            sampSendClickTextdraw(65535)
						end
					end)
					else sampAddChatMessage("{c41e3a}[Unknown]: {ffffff}Введите от 1 до 500 патронов",-1)
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
            if text:match("{FFFFFF}Введите количество, которое хотите использовать") and ammo_fill then
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
            if tostring(text):match("%[Ошибка%] {FFFFFF}У вас в наличии только %d+ шт") and ammo_fill then
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
            local color = raknetBitStreamReadInt32(bs)
            local textl = raknetBitStreamReadInt32(bs)
            local text = raknetBitStreamReadString(bs, textl)
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
                local _, pid = sampGetPlayerIdByCharHandle(PLAYER_PED)
                if _ then
					if text:match("%[%u+%] {%x+}[A-z0-9_]+%[" .. pid .. "%]:") then
						finished = true
					end
				end
			end
            if text:find("^Вы заглушены") or text:find("Для возможности повторной отправки сообщения в этот чат") then
                finished = true
			end
		end
	end)
	while true do wait(0) end
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
			if text == ("/gquest") and not isCharInAnyCar(PLAYER_PED) then
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
			local text = raknetBitStreamDecodeString(bs,4096)
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
            local text = raknetBitStreamDecodeString(bs,4096)
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
			local timer = autoRoulette_delay.v
			lua_thread.create(function()
				sampSendChat("/invent")
				wait(500)
				if case1 ~= "" then sampSendClickTextdraw(case1) end
				if case1 ~= "" then wait(300) end
				if case1 ~= "" then sampSendClickTextdraw(2302) end
				if case1 ~= "" then wait(300) case1 = "" end
				sampCloseCurrentDialogWithButton(1)
				if case2 ~= "" then sampSendClickTextdraw(case2) end
				if case2 ~= "" then wait(300) end
				if case2 ~= "" then sampSendClickTextdraw(2302) end
				if case2 ~= "" then wait(300) case2 = "" end
				sampCloseCurrentDialogWithButton(1)
				if case3 ~= "" then sampSendClickTextdraw(case3) end
				if case3 ~= "" then wait(300) end
				if case3 ~= "" then sampSendClickTextdraw(2302) end
				if case3 ~= "" then wait(300) case3 = "" end
				sampCloseCurrentDialogWithButton(1)
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
				if timer ~= autoRoulette_delay.v then break end
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
            if bool then
				local nickname = sampGetPlayerNickname(id)
				nickname = nickname:gsub("_", " ")
				sampSendChat("/m Говорит сотрудник полиции "..nickname..", немедленно остановитесь!")
			end
		end
	end
end
function autoMiranda()
    autoMiranda_state = imgui.ImBool(mainIni.police.autoMiranda_state_c)
    addEventHandler("onSendRpc", function(id,bs)
		if id == 50 and autoMiranda_state.v then
			local lenght = raknetBitStreamReadInt32(bs)
			local text = raknetBitStreamReadString(bs,lenght)
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
            if text:match ("^/frisk%s") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/me надел перчатки и произвел обыск нарушителя")
				end)
			end
            if text:match ("^/cuff%s") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/me снял наручники с пояса и надел их на нарушителя")
				end)
			end
            if text:match ("^/uncuff%s") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/me растягнул нарушителя и убрал наручники")
				end)
			end
            if text:match ("^/unmask%s") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/me стащил маску с нарушителя")
				end)
			end
            if text:match ("^/pull%s") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/me выбил окно автомобиля и силой вытащил нарушителя из него")
				end)
			end
            if text:match ("^/incar%s") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/me открыл дверь патрульного автомобиля и затащил в него нарушителя")
				end)
			end
            if text:match ("^/ticket%s") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/me достал пустые тикеты, заполнил штраф и передал его нарушителю")
				end)
			end
            if text:match ("^/arrest") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/do Из департамента вышли офицеры и забрали нарушителя")
				end)
			end
            if text:match ("^/gotome%s") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/me скрутил руки подозреваемому и потащил его за собой")
				end)
			end
            if text:match ("^/ungotome%s") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/me отпустил подозреваемого")
				end)
			end
			if text:match ("^/clear%s") then
                lua_thread.create(function()
                    wait(1000)
                    sampSendChat("/me зашел в базу данных полиции штата и снял все обвинения")
				end)
			end
            if text:match ("^/su%s") then
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
            if text:match("%[Ошибка%] {FFFFFF}Подавать в розыск доступно с 5 ранга%!") then
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
            if text:match("%[Ошибка%] {FFFFFF}Игроков с таким уровнем розыска нету%!") and _ then
                return false
			end
            if text:match("Внимание%! {FFFFFF}.+%[%d+%] был%(а%) объявлен%(a%) в розыск%!") then
                local nickname, pid = text:match("Внимание%! {FFFFFF}(.+)%[(%d+)%] был%(а%) объявлен%(a%) в розыск%!")
				local add = true
				for i = 1, #nearWanted_list do
					if nearWanted_list[i]:match(nickname) then add = false end
				end
				if add then table.insert(nearWanted_list, nickname.." ["..pid.."]") end
			end
			if text:match("Внимание%! {FFFFFF}.+%[%d+%]{FF6347} был%(а%) объявлен%(a%) в розыск%!") then
				local nickname, pid = text:match("{FFFFFF}(.+)%[(.+)%]{FF6347} был%(а%) объявлен%(a%) в розыск%! Причина:")
				local add = true
				for i = 1, #nearWanted_list do
					if nearWanted_list[i]:match(nickname) then add = false end
				end
				if add then table.insert(nearWanted_list, nickname.." ["..pid.."]") end
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
            if text:match("Ник") and text:match("{58F865}Уровень розыска{FFFFFF}") then
                local t = stringSplit(text, "\n")
                for i = 2, #t do
					local nickname, pid = t[i]:match("{FFFFFF}(.+)%({21FF11}(%d+){FFFFFF}%)")
					table.insert(list, nickname.." ["..pid.."]")
				end
                return false
			end
		end
	end)
	while true do wait(0)
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
				wait(0)
				if not nearWanted_state.v then break end
				if nearWanted_state.v then wait(1000) end
			end
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
				sampSendDialogResponse(d_id, 0, 0, "")
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
            if tostring(text):match("%[Ошибка%] {FFFFFF}Изменить стиль езды можно только если у вас установлены технические модификации или на полицейских авто%!") then
                return false
			end
		end
	end)
	while true do wait(0) end
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
			raknetEmulRpcReceiveBitStream(61,bs)
			raknetDeleteBitStream(bs)
            return false
		end
		if id == 36 and moneySeparate_state.v then
            local labelId = raknetBitStreamReadInt16(bs)
            local labelColor = raknetBitStreamReadInt32(bs)
            local X = raknetBitStreamReadFloat(bs)
            local Y = raknetBitStreamReadFloat(bs)
            local Z = raknetBitStreamReadFloat(bs)
            local dist = raknetBitStreamReadFloat(bs)
            local b = raknetBitStreamReadInt8(bs)
            local playerId = raknetBitStreamReadInt16(bs)
            local vehId = raknetBitStreamReadInt16(bs)
            local text = raknetBitStreamDecodeString(bs,4096)
            text = separator(text)
			raknetDeleteBitStream(bs)
            bs = raknetNewBitStream()
			raknetBitStreamWriteInt16(bs,labelId)
			raknetBitStreamWriteInt32(bs,labelColor)
			raknetBitStreamWriteFloat(bs,X)
			raknetBitStreamWriteFloat(bs,Y)
			raknetBitStreamWriteFloat(bs,Z)
			raknetBitStreamWriteFloat(bs,dist)
			raknetBitStreamWriteInt8(bs,b)
			raknetBitStreamWriteInt16(bs,playerId)
			raknetBitStreamWriteInt16(bs,vehId)
			raknetBitStreamEncodeString(bs,text)
			raknetEmulRpcReceiveBitStream(36,bs)
			raknetDeleteBitStream(bs)
			return false
		end
		if id == 93 and moneySeparate_state.v then
            local color = raknetBitStreamReadInt32(bs)
            local textlenght = raknetBitStreamReadInt32(bs)
            local text = raknetBitStreamReadString(bs, textl)
            text = separator(text)
			raknetDeleteBitStream(bs)
            bs = raknetNewBitStream()
			raknetBitStreamWriteInt32(bs,color)
			raknetBitStreamWriteInt32(bs,text:len())
			raknetBitStreamWriteString(bs,text)
			raknetEmulRpcReceiveBitStream(93,bs)
			raknetDeleteBitStream(bs)
			return false
		end
	end)
    while true do wait(0) end
end
function sobes()
	sobes_state = imgui.ImBool(false)
	function sobes_gofunc(arg)
		if arg == 1 then
			sampSendChat("Здравствуйте, вы пришли на собеседование?")
			elseif arg == 2 then
			sampSendChat("Отлично, расскажите немного о себе.")
			elseif arg == 3 then
			lua_thread.create(function()
				sampSendChat("Предъявите ваши документы: паспорт, медкарту и лицензии.")
				wait(1000)
				local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
				if _ then sampSendChat("/b /showpass "..id..", /showmc "..id..", /showlic "..id) end
			end)
			elseif arg == 4 then
			sampSendChat("/me внимательно изучил все предоставленные документы")
			elseif arg == 5 then
			lua_thread.create(function()
				sampSendChat("Отлично, вы приняты. Вот ваши ключи от шкафчика")
				sampSetChatInputEnabled(true)
				sampSetChatInputText("/invite ")
				wait(1000)
				sampSendChat("/me передал ключи от шкафчика")
			end)
			elseif arg == 6 then
			sampSendChat("Извините, но вы нам не подходите")
			elseif arg == 7 then
			sampSendChat("Почему выбрали именно нашу организацию?")
		end
	end
	while true do wait(0) end
end
function traffic_stop()
	traffic_stop_state = imgui.ImBool(false)
	function traffic_stop_gofunc(arg)
		if arg == 1 then
			sampSendChat("/me подошел к авто, прикосунлся к задней фаре, пошел дальше")
			elseif arg == 2 then
			lua_thread.create(function()
				local _, pid = sampGetPlayerIdByCharHandle(PLAYER_PED)
				if _ then
					local nickname = sampGetPlayerNickname(pid)
					nickname = nickname:gsub("_", " ")
					sampSendChat("Здравствуйте, я сотрудник полиции "..nickname..".")
					sampSetChatInputEnabled(true)
					sampSetChatInputText("/showbadge ")
					wait(1000)
					sampSendChat("Предъявите пожалуйста ваши документы.")
				end
			end)
			elseif arg == 3 then
			sampSendChat("/me внимательно изучил все документы и передал их обратно")
			elseif arg == 4 then
			sampSendChat("Все в порядке, не смею вас больше задерживать.")
			elseif arg == 5 then
			sampSetChatInputEnabled(true)
			sampSetChatInputText("Мне придется выписать вам штраф за ")
			elseif arg == 6 then
			sampSendChat("Отлично, не могли бы вы выйти из авто?")
		end
	end
	while true do wait(0) end
end
function patrol()
	patrol_state = imgui.ImBool(false)
	patrol_marker = imgui.ImBuffer(256)
	patrol_selected = imgui.ImInt(0)
	function patrol_gofunc(arg)
		if arg == 1 then
			local _, pid = sampGetPlayerIdByCharHandle(PLAYER_PED)
			if _ then
				sampSendChat("/r Выехал в патруль как "..patrol_marker.v.."-"..pid..", код 4, доступен")
			else sampAddChatMessage("{c41e3a}[Unknown]: {ffffff}Ошибка",-1) end
			elseif arg == 2 then
			local _, pid = sampGetPlayerIdByCharHandle(PLAYER_PED)
			local x, y, z = getCharCoordinates(PLAYER_PED)
			local nameZone = calculateZone(x, y, z)
			if _ then
				sampSendChat("/r "..patrol_marker.v.."-"..pid.." | Продолжаю патрулирование, район: "..nameZone..", код 4, доступен")
			else sampAddChatMessage("{c41e3a}[Unknown]: {ffffff}Ошибка",-1) end
			elseif arg == 3 then
			local _, pid = sampGetPlayerIdByCharHandle(PLAYER_PED)
			local x, y, z = getCharCoordinates(PLAYER_PED)
			local nameZone = calculateZone(x, y, z)
			if _ then
				sampSendChat("/r "..patrol_marker.v.."-"..pid.." | Провожу траффик-стоп, район: "..nameZone..", код 4, недоступен")
			else sampAddChatMessage("{c41e3a}[Unknown]: {ffffff}Ошибка",-1) end
			elseif arg == 4 then
			local _, pid = sampGetPlayerIdByCharHandle(PLAYER_PED)
			local x, y, z = getCharCoordinates(PLAYER_PED)
			local nameZone = calculateZone(x, y, z)
			if _ then
				lua_thread.create(function()
					sampSendChat("/r "..patrol_marker.v.."-"..pid.." | Провожу траффик-стоп, район: "..nameZone..", код 4, недоступен")
					wait(1000)
					sampSendChat("/r "..patrol_marker.v.."-"..pid.." | Запрашиваю свободные юниты, район: "..nameZone..", код 2")
					wait(1000)
					sampSendChat("/bk 10-20")
				end)
			else sampAddChatMessage("{c41e3a}[Unknown]: {ffffff}Ошибка",-1) end
			elseif arg == 5 then
			local _, pid = sampGetPlayerIdByCharHandle(PLAYER_PED)
			local x, y, z = getCharCoordinates(PLAYER_PED)
			local nameZone = calculateZone(x, y, z)
			if _ then
				lua_thread.create(function()
					sampSendChat("/r "..patrol_marker.v.."-"..pid.." | Нахожусь в перестрелке, район: "..nameZone..", код 3, недоступен")
					wait(1000)
					sampSendChat("/bk 10-20")
				end)
			else sampAddChatMessage("{c41e3a}[Unknown]: {ffffff}Ошибка",-1) end
			elseif arg == 6 then
			local _, pid = sampGetPlayerIdByCharHandle(PLAYER_PED)
			local x, y, z = getCharCoordinates(PLAYER_PED)
			local nameZone = calculateZone(x, y, z)
			if _ then
				lua_thread.create(function()
					sampSendChat("/r "..patrol_marker.v.."-"..pid.." | Начинаю погоню, нужна помощь, район: "..nameZone..", код 3, недоступен")
					wait(1000)
					sampSendChat("/rb /pursuit "..pid)
				end)
			else sampAddChatMessage("{c41e3a}[Unknown]: {ffffff}Ошибка",-1) end
		end
	end
	while true do wait(0)
		if patrol_selected.v == 0 then patrol_marker.v = "L" end
		if patrol_selected.v == 1 then patrol_marker.v = "A" end
		if patrol_selected.v == 2 then patrol_marker.v = "M" end
		if patrol_selected.v == 3 then patrol_marker.v = "AIR" end
		if patrol_selected.v == 4 then patrol_marker.v = "E" end
	end
end
function calculateZone(x, y, z)
    local streets = {
        {"Загородный клуб «Ависпа»", -2667.810, -302.135, -28.831, -2646.400, -262.320, 71.169},
        {"Международный аэропорт Истер-Бэй", -1315.420, -405.388, 15.406, -1264.400, -209.543, 25.406},
        {"Загородный клуб «Ависпа»", -2550.040, -355.493, 0.000, -2470.040, -318.493, 39.700},
        {"Международный аэропорт Истер-Бэй", -1490.330, -209.543, 15.406, -1264.400, -148.388, 25.406},
        {"Гарсия", -2395.140, -222.589, -5.3, -2354.090, -204.792, 200.000},
        {"Шейди-Кэбин", -1632.830, -2263.440, -3.0, -1601.330, -2231.790, 200.000},
        {"Восточный Лос-Сантос", 2381.680, -1494.030, -89.084, 2421.030, -1454.350, 110.916},
        {"Грузовое депо Лас-Вентураса", 1236.630, 1163.410, -89.084, 1277.050, 1203.280, 110.916},
        {"Пересечение Блэкфилд", 1277.050, 1044.690, -89.084, 1315.350, 1087.630, 110.916},
        {"Загородный клуб «Ависпа»", -2470.040, -355.493, 0.000, -2270.040, -318.493, 46.100},
        {"Темпл", 1252.330, -926.999, -89.084, 1357.000, -910.170, 110.916},
        {"Станция «Юнити»", 1692.620, -1971.800, -20.492, 1812.620, -1932.800, 79.508},
        {"Грузовое депо Лас-Вентураса", 1315.350, 1044.690, -89.084, 1375.600, 1087.630, 110.916},
        {"Лос-Флорес", 2581.730, -1454.350, -89.084, 2632.830, -1393.420, 110.916},
        {"Казино «Морская звезда»", 2437.390, 1858.100, -39.084, 2495.090, 1970.850, 60.916},
        {"Химзавод Истер-Бэй", -1132.820, -787.391, 0.000, -956.476, -768.027, 200.000},
        {"Деловой район", 1370.850, -1170.870, -89.084, 1463.900, -1130.850, 110.916},
        {"Восточная Эспаланда", -1620.300, 1176.520, -4.5, -1580.010, 1274.260, 200.000},
        {"Станция «Маркет»", 787.461, -1410.930, -34.126, 866.009, -1310.210, 65.874},
        {"Станция «Линден»", 2811.250, 1229.590, -39.594, 2861.250, 1407.590, 60.406},
        {"Пересечение Монтгомери", 1582.440, 347.457, 0.000, 1664.620, 401.750, 200.000},
        {"Мост «Фредерик»", 2759.250, 296.501, 0.000, 2774.250, 594.757, 200.000},
        {"Станция «Йеллоу-Белл»", 1377.480, 2600.430, -21.926, 1492.450, 2687.360, 78.074},
        {"Деловой район", 1507.510, -1385.210, 110.916, 1582.550, -1325.310, 335.916},
        {"Джефферсон", 2185.330, -1210.740, -89.084, 2281.450, -1154.590, 110.916},
        {"Малхолланд", 1318.130, -910.170, -89.084, 1357.000, -768.027, 110.916},
        {"Загородный клуб «Ависпа»", -2361.510, -417.199, 0.000, -2270.040, -355.493, 200.000},
        {"Джефферсон", 1996.910, -1449.670, -89.084, 2056.860, -1350.720, 110.916},
        {"Западаная автострада Джулиус", 1236.630, 2142.860, -89.084, 1297.470, 2243.230, 110.916},
        {"Джефферсон", 2124.660, -1494.030, -89.084, 2266.210, -1449.670, 110.916},
        {"Северная автострада Джулиус", 1848.400, 2478.490, -89.084, 1938.800, 2553.490, 110.916},
        {"Родео", 422.680, -1570.200, -89.084, 466.223, -1406.050, 110.916},
        {"Станция «Крэнберри»", -2007.830, 56.306, 0.000, -1922.000, 224.782, 100.000},
        {"Деловой район", 1391.050, -1026.330, -89.084, 1463.900, -926.999, 110.916},
        {"Западный Рэдсэндс", 1704.590, 2243.230, -89.084, 1777.390, 2342.830, 110.916},
        {"Маленькая Мексика", 1758.900, -1722.260, -89.084, 1812.620, -1577.590, 110.916},
        {"Пересечение Блэкфилд", 1375.600, 823.228, -89.084, 1457.390, 919.447, 110.916},
        {"Международный аэропорт Лос-Сантос", 1974.630, -2394.330, -39.084, 2089.000, -2256.590, 60.916},
        {"Бекон-Хилл", -399.633, -1075.520, -1.489, -319.033, -977.516, 198.511},
        {"Родео", 334.503, -1501.950, -89.084, 422.680, -1406.050, 110.916},
        {"Ричман", 225.165, -1369.620, -89.084, 334.503, -1292.070, 110.916},
        {"Деловой район", 1724.760, -1250.900, -89.084, 1812.620, -1150.870, 110.916},
        {"Стрип", 2027.400, 1703.230, -89.084, 2137.400, 1783.230, 110.916},
        {"Деловой район", 1378.330, -1130.850, -89.084, 1463.900, -1026.330, 110.916},
        {"Пересечение Блэкфилд", 1197.390, 1044.690, -89.084, 1277.050, 1163.390, 110.916},
        {"Конференц Центр", 1073.220, -1842.270, -89.084, 1323.900, -1804.210, 110.916},
        {"Монтгомери", 1451.400, 347.457, -6.1, 1582.440, 420.802, 200.000},
        {"Долина Фостер", -2270.040, -430.276, -1.2, -2178.690, -324.114, 200.000},
        {"Часовня Блэкфилд", 1325.600, 596.349, -89.084, 1375.600, 795.010, 110.916},
        {"Международный аэропорт Лос-Сантос", 2051.630, -2597.260, -39.084, 2152.450, -2394.330, 60.916},
        {"Малхолланд", 1096.470, -910.170, -89.084, 1169.130, -768.027, 110.916},
        {"Поле для гольфа «Йеллоу-Белл»", 1457.460, 2723.230, -89.084, 1534.560, 2863.230, 110.916},
        {"Стрип", 2027.400, 1783.230, -89.084, 2162.390, 1863.230, 110.916},
        {"Джефферсон", 2056.860, -1210.740, -89.084, 2185.330, -1126.320, 110.916},
        {"Малхолланд", 952.604, -937.184, -89.084, 1096.470, -860.619, 110.916},
        {"Альдеа-Мальвада", -1372.140, 2498.520, 0.000, -1277.590, 2615.350, 200.000},
        {"Лас-Колинас", 2126.860, -1126.320, -89.084, 2185.330, -934.489, 110.916},
        {"Лас-Колинас", 1994.330, -1100.820, -89.084, 2056.860, -920.815, 110.916},
        {"Ричман", 647.557, -954.662, -89.084, 768.694, -860.619, 110.916},
        {"Грузовое депо Лас-Вентураса", 1277.050, 1087.630, -89.084, 1375.600, 1203.280, 110.916},
        {"Северная автострада Джулиус", 1377.390, 2433.230, -89.084, 1534.560, 2507.230, 110.916},
        {"Уиллоуфилд", 2201.820, -2095.000, -89.084, 2324.000, -1989.900, 110.916},
        {"Северная автострада Джулиус", 1704.590, 2342.830, -89.084, 1848.400, 2433.230, 110.916},
        {"Темпл", 1252.330, -1130.850, -89.084, 1378.330, -1026.330, 110.916},
        {"Маленькая Мексика", 1701.900, -1842.270, -89.084, 1812.620, -1722.260, 110.916},
        {"Квинс", -2411.220, 373.539, 0.000, -2253.540, 458.411, 200.000},
        {"Аэропорт Лас-Вентурас", 1515.810, 1586.400, -12.500, 1729.950, 1714.560, 87.500},
        {"Ричман", 225.165, -1292.070, -89.084, 466.223, -1235.070, 110.916},
        {"Темпл", 1252.330, -1026.330, -89.084, 1391.050, -926.999, 110.916},
        {"Восточный Лос-Сантос", 2266.260, -1494.030, -89.084, 2381.680, -1372.040, 110.916},
        {"Восточная автострада Джулиус", 2623.180, 943.235, -89.084, 2749.900, 1055.960, 110.916},
        {"Уиллоуфилд", 2541.700, -1941.400, -89.084, 2703.580, -1852.870, 110.916},
        {"Лас-Колинас", 2056.860, -1126.320, -89.084, 2126.860, -920.815, 110.916},
        {"Восточная автострада Джулиус", 2625.160, 2202.760, -89.084, 2685.160, 2442.550, 110.916},
        {"Родео", 225.165, -1501.950, -89.084, 334.503, -1369.620, 110.916},
        {"Лас-Брухас", -365.167, 2123.010, -3.0, -208.570, 2217.680, 200.000},
        {"Восточная автострада Джулиус", 2536.430, 2442.550, -89.084, 2685.160, 2542.550, 110.916},
        {"Родео", 334.503, -1406.050, -89.084, 466.223, -1292.070, 110.916},
        {"Вайнвуд", 647.557, -1227.280, -89.084, 787.461, -1118.280, 110.916},
        {"Родео", 422.680, -1684.650, -89.084, 558.099, -1570.200, 110.916},
        {"Северная автострада Джулиус", 2498.210, 2542.550, -89.084, 2685.160, 2626.550, 110.916},
        {"Деловой район", 1724.760, -1430.870, -89.084, 1812.620, -1250.900, 110.916},
        {"Родео", 225.165, -1684.650, -89.084, 312.803, -1501.950, 110.916},
        {"Джефферсон", 2056.860, -1449.670, -89.084, 2266.210, -1372.040, 110.916},
        {"Хэмптон-Барнс", 603.035, 264.312, 0.000, 761.994, 366.572, 200.000},
        {"Темпл", 1096.470, -1130.840, -89.084, 1252.330, -1026.330, 110.916},
        {"Мост «Кинкейд»", -1087.930, 855.370, -89.084, -961.950, 986.281, 110.916},
        {"Пляж «Верона»", 1046.150, -1722.260, -89.084, 1161.520, -1577.590, 110.916},
        {"Коммерческий район", 1323.900, -1722.260, -89.084, 1440.900, -1577.590, 110.916},
        {"Малхолланд", 1357.000, -926.999, -89.084, 1463.900, -768.027, 110.916},
        {"Родео", 466.223, -1570.200, -89.084, 558.099, -1385.070, 110.916},
        {"Малхолланд", 911.802, -860.619, -89.084, 1096.470, -768.027, 110.916},
        {"Малхолланд", 768.694, -954.662, -89.084, 952.604, -860.619, 110.916},
        {"Южная автострада Джулиус", 2377.390, 788.894, -89.084, 2537.390, 897.901, 110.916},
        {"Айдлвуд", 1812.620, -1852.870, -89.084, 1971.660, -1742.310, 110.916},
        {"Океанские доки", 2089.000, -2394.330, -89.084, 2201.820, -2235.840, 110.916},
        {"Коммерческий район", 1370.850, -1577.590, -89.084, 1463.900, -1384.950, 110.916},
        {"Северная автострада Джулиус", 2121.400, 2508.230, -89.084, 2237.400, 2663.170, 110.916},
        {"Темпл", 1096.470, -1026.330, -89.084, 1252.330, -910.170, 110.916},
        {"Глен Парк", 1812.620, -1449.670, -89.084, 1996.910, -1350.720, 110.916},
        {"Международный аэропорт Истер-Бэй", -1242.980, -50.096, 0.000, -1213.910, 578.396, 200.000},
        {"Мост «Мартин»", -222.179, 293.324, 0.000, -122.126, 476.465, 200.000},
        {"Стрип", 2106.700, 1863.230, -89.084, 2162.390, 2202.760, 110.916},
        {"Уиллоуфилд", 2541.700, -2059.230, -89.084, 2703.580, -1941.400, 110.916},
        {"Марина", 807.922, -1577.590, -89.084, 926.922, -1416.250, 110.916},
        {"Аэропорт Лас-Вентурас", 1457.370, 1143.210, -89.084, 1777.400, 1203.280, 110.916},
        {"Айдлвуд", 1812.620, -1742.310, -89.084, 1951.660, -1602.310, 110.916},
        {"Восточная Эспаланда", -1580.010, 1025.980, -6.1, -1499.890, 1274.260, 200.000},
        {"Деловой район", 1370.850, -1384.950, -89.084, 1463.900, -1170.870, 110.916},
        {"Мост «Мако»", 1664.620, 401.750, 0.000, 1785.140, 567.203, 200.000},
        {"Родео", 312.803, -1684.650, -89.084, 422.680, -1501.950, 110.916},
        {"Площадь «Першинг»", 1440.900, -1722.260, -89.084, 1583.500, -1577.590, 110.916},
        {"Малхолланд", 687.802, -860.619, -89.084, 911.802, -768.027, 110.916},
        {"Мост «Гант»", -2741.070, 1490.470, -6.1, -2616.400, 1659.680, 200.000},
        {"Лас-Колинас", 2185.330, -1154.590, -89.084, 2281.450, -934.489, 110.916},
        {"Малхолланд", 1169.130, -910.170, -89.084, 1318.130, -768.027, 110.916},
        {"Северная автострада Джулиус", 1938.800, 2508.230, -89.084, 2121.400, 2624.230, 110.916},
        {"Коммерческий район", 1667.960, -1577.590, -89.084, 1812.620, -1430.870, 110.916},
        {"Родео", 72.648, -1544.170, -89.084, 225.165, -1404.970, 110.916},
        {"Рока-Эскаланте", 2536.430, 2202.760, -89.084, 2625.160, 2442.550, 110.916},
        {"Родео", 72.648, -1684.650, -89.084, 225.165, -1544.170, 110.916},
        {"Маркет", 952.663, -1310.210, -89.084, 1072.660, -1130.850, 110.916},
        {"Лас-Колинас", 2632.740, -1135.040, -89.084, 2747.740, -945.035, 110.916},
        {"Малхолланд", 861.085, -674.885, -89.084, 1156.550, -600.896, 110.916},
        {"Кингс", -2253.540, 373.539, -9.1, -1993.280, 458.411, 200.000},
        {"Восточный Рэдсэндс", 1848.400, 2342.830, -89.084, 2011.940, 2478.490, 110.916},
        {"Деловой район", -1580.010, 744.267, -6.1, -1499.890, 1025.980, 200.000},
        {"Конференц Центр", 1046.150, -1804.210, -89.084, 1323.900, -1722.260, 110.916},
        {"Ричман", 647.557, -1118.280, -89.084, 787.461, -954.662, 110.916},
        {"Оушен-Флэтс", -2994.490, 277.411, -9.1, -2867.850, 458.411, 200.000},
        {"Колледж Грингласс", 964.391, 930.890, -89.084, 1166.530, 1044.690, 110.916},
        {"Глен Парк", 1812.620, -1100.820, -89.084, 1994.330, -973.380, 110.916},
        {"Грузовое депо Лас-Вентураса", 1375.600, 919.447, -89.084, 1457.370, 1203.280, 110.916},
        {"Регьюлар-Том", -405.770, 1712.860, -3.0, -276.719, 1892.750, 200.000},
        {"Пляж «Верона»", 1161.520, -1722.260, -89.084, 1323.900, -1577.590, 110.916},
        {"Восточный Лос-Сантос", 2281.450, -1372.040, -89.084, 2381.680, -1135.040, 110.916},
        {"Дворец Калигулы", 2137.400, 1703.230, -89.084, 2437.390, 1783.230, 110.916},
        {"Айдлвуд", 1951.660, -1742.310, -89.084, 2124.660, -1602.310, 110.916},
        {"Пилигрим", 2624.400, 1383.230, -89.084, 2685.160, 1783.230, 110.916},
        {"Айдлвуд", 2124.660, -1742.310, -89.084, 2222.560, -1494.030, 110.916},
        {"Квинс", -2533.040, 458.411, 0.000, -2329.310, 578.396, 200.000},
        {"Деловой район", -1871.720, 1176.420, -4.5, -1620.300, 1274.260, 200.000},
        {"Коммерческий район", 1583.500, -1722.260, -89.084, 1758.900, -1577.590, 110.916},
        {"Восточный Лос-Сантос", 2381.680, -1454.350, -89.084, 2462.130, -1135.040, 110.916},
        {"Марина", 647.712, -1577.590, -89.084, 807.922, -1416.250, 110.916},
        {"Ричман", 72.648, -1404.970, -89.084, 225.165, -1235.070, 110.916},
        {"Вайнвуд", 647.712, -1416.250, -89.084, 787.461, -1227.280, 110.916},
        {"Восточный Лос-Сантос", 2222.560, -1628.530, -89.084, 2421.030, -1494.030, 110.916},
        {"Родео", 558.099, -1684.650, -89.084, 647.522, -1384.930, 110.916},
        {"Истерский Тоннель", -1709.710, -833.034, -1.5, -1446.010, -730.118, 200.000},
        {"Родео", 466.223, -1385.070, -89.084, 647.522, -1235.070, 110.916},
        {"Восточный Рэдсэндс", 1817.390, 2202.760, -89.084, 2011.940, 2342.830, 110.916},
        {"Казино «Карман клоуна»", 2162.390, 1783.230, -89.084, 2437.390, 1883.230, 110.916},
        {"Айдлвуд", 1971.660, -1852.870, -89.084, 2222.560, -1742.310, 110.916},
        {"Пересечение Монтгомери", 1546.650, 208.164, 0.000, 1745.830, 347.457, 200.000},
        {"Уиллоуфилд", 2089.000, -2235.840, -89.084, 2201.820, -1989.900, 110.916},
        {"Темпл", 952.663, -1130.840, -89.084, 1096.470, -937.184, 110.916},
        {"Прикл-Пайн", 1848.400, 2553.490, -89.084, 1938.800, 2863.230, 110.916},
        {"Международный аэропорт Лос-Сантос", 1400.970, -2669.260, -39.084, 2189.820, -2597.260, 60.916},
        {"Мост «Гарвер»", -1213.910, 950.022, -89.084, -1087.930, 1178.930, 110.916},
        {"Мост «Гарвер»", -1339.890, 828.129, -89.084, -1213.910, 1057.040, 110.916},
        {"Мост «Кинкейд»", -1339.890, 599.218, -89.084, -1213.910, 828.129, 110.916},
        {"Мост «Кинкейд»", -1213.910, 721.111, -89.084, -1087.930, 950.022, 110.916},
        {"Пляж «Верона»", 930.221, -2006.780, -89.084, 1073.220, -1804.210, 110.916},
        {"Обсерватория «Зелёный утёс»", 1073.220, -2006.780, -89.084, 1249.620, -1842.270, 110.916},
        {"Вайнвуд", 787.461, -1130.840, -89.084, 952.604, -954.662, 110.916},
        {"Вайнвуд", 787.461, -1310.210, -89.084, 952.663, -1130.840, 110.916},
        {"Коммерческий район", 1463.900, -1577.590, -89.084, 1667.960, -1430.870, 110.916},
        {"Маркет", 787.461, -1416.250, -89.084, 1072.660, -1310.210, 110.916},
        {"Западный Рокшор", 2377.390, 596.349, -89.084, 2537.390, 788.894, 110.916},
        {"Северная автострада Джулиус", 2237.400, 2542.550, -89.084, 2498.210, 2663.170, 110.916},
        {"Восточный пляж", 2632.830, -1668.130, -89.084, 2747.740, -1393.420, 110.916},
        {"Мост «Фаллоу»", 434.341, 366.572, 0.000, 603.035, 555.680, 200.000},
        {"Уиллоуфилд", 2089.000, -1989.900, -89.084, 2324.000, -1852.870, 110.916},
        {"Чайнатаун", -2274.170, 578.396, -7.6, -2078.670, 744.170, 200.000},
        {"Эль-Кастильо-дель-Дьябло", -208.570, 2337.180, 0.000, 8.430, 2487.180, 200.000},
        {"Океанские доки", 2324.000, -2145.100, -89.084, 2703.580, -2059.230, 110.916},
        {"Химзавод Истер-Бэй", -1132.820, -768.027, 0.000, -956.476, -578.118, 200.000},
        {"Казино «Визаж»", 1817.390, 1703.230, -89.084, 2027.400, 1863.230, 110.916},
        {"Оушен-Флэтс", -2994.490, -430.276, -1.2, -2831.890, -222.589, 200.000},
        {"Ричман", 321.356, -860.619, -89.084, 687.802, -768.027, 110.916},
        {"Нефтяной комплекс «Зеленый оазис»", 176.581, 1305.450, -3.0, 338.658, 1520.720, 200.000},
        {"Ричман", 321.356, -768.027, -89.084, 700.794, -674.885, 110.916},
        {"Казино «Морская звезда»", 2162.390, 1883.230, -89.084, 2437.390, 2012.180, 110.916},
        {"Восточный пляж", 2747.740, -1668.130, -89.084, 2959.350, -1498.620, 110.916},
        {"Джефферсон", 2056.860, -1372.040, -89.084, 2281.450, -1210.740, 110.916},
        {"Деловой район", 1463.900, -1290.870, -89.084, 1724.760, -1150.870, 110.916},
        {"Деловой район", 1463.900, -1430.870, -89.084, 1724.760, -1290.870, 110.916},
        {"Мост «Гарвер»", -1499.890, 696.442, -179.615, -1339.890, 925.353, 20.385},
        {"Южная автострада Джулиус", 1457.390, 823.228, -89.084, 2377.390, 863.229, 110.916},
        {"Восточный Лос-Сантос", 2421.030, -1628.530, -89.084, 2632.830, -1454.350, 110.916},
        {"Колледж «Грингласс»", 964.391, 1044.690, -89.084, 1197.390, 1203.220, 110.916},
        {"Лас-Колинас", 2747.740, -1120.040, -89.084, 2959.350, -945.035, 110.916},
        {"Малхолланд", 737.573, -768.027, -89.084, 1142.290, -674.885, 110.916},
        {"Океанские доки", 2201.820, -2730.880, -89.084, 2324.000, -2418.330, 110.916},
        {"Восточный Лос-Сантос", 2462.130, -1454.350, -89.084, 2581.730, -1135.040, 110.916},
        {"Гантон", 2222.560, -1722.330, -89.084, 2632.830, -1628.530, 110.916},
        {"Загородный клуб «Ависпа»", -2831.890, -430.276, -6.1, -2646.400, -222.589, 200.000},
        {"Уиллоуфилд", 1970.620, -2179.250, -89.084, 2089.000, -1852.870, 110.916},
        {"Северная Эспланада", -1982.320, 1274.260, -4.5, -1524.240, 1358.900, 200.000},
        {"Казино «Хай-Роллер»", 1817.390, 1283.230, -89.084, 2027.390, 1469.230, 110.916},
        {"Океанские доки", 2201.820, -2418.330, -89.084, 2324.000, -2095.000, 110.916},
        {"Мотель «Последний цент»", 1823.080, 596.349, -89.084, 1997.220, 823.228, 110.916},
        {"Бэйсайнд-Марина", -2353.170, 2275.790, 0.000, -2153.170, 2475.790, 200.000},
        {"Кингс", -2329.310, 458.411, -7.6, -1993.280, 578.396, 200.000},
        {"Эль-Корона", 1692.620, -2179.250, -89.084, 1812.620, -1842.270, 110.916},
        {"Часовня Блэкфилд", 1375.600, 596.349, -89.084, 1558.090, 823.228, 110.916},
        {"«Розовый лебедь»", 1817.390, 1083.230, -89.084, 2027.390, 1283.230, 110.916},
        {"Западаная автострада Джулиус", 1197.390, 1163.390, -89.084, 1236.630, 2243.230, 110.916},
        {"Лос-Флорес", 2581.730, -1393.420, -89.084, 2747.740, -1135.040, 110.916},
        {"Казино «Визаж»", 1817.390, 1863.230, -89.084, 2106.700, 2011.830, 110.916},
        {"Прикл-Пайн", 1938.800, 2624.230, -89.084, 2121.400, 2861.550, 110.916},
        {"Пляж «Верона»", 851.449, -1804.210, -89.084, 1046.150, -1577.590, 110.916},
        {"Пересечение Робада", -1119.010, 1178.930, -89.084, -862.025, 1351.450, 110.916},
        {"Линден-Сайд", 2749.900, 943.235, -89.084, 2923.390, 1198.990, 110.916},
        {"Океанские доки", 2703.580, -2302.330, -89.084, 2959.350, -2126.900, 110.916},
        {"Уиллоуфилд", 2324.000, -2059.230, -89.084, 2541.700, -1852.870, 110.916},
        {"Кингс", -2411.220, 265.243, -9.1, -1993.280, 373.539, 200.000},
        {"Коммерческий район", 1323.900, -1842.270, -89.084, 1701.900, -1722.260, 110.916},
        {"Малхолланд", 1269.130, -768.027, -89.084, 1414.070, -452.425, 110.916},
        {"Марина", 647.712, -1804.210, -89.084, 851.449, -1577.590, 110.916},
        {"Бэттери-Пойнт", -2741.070, 1268.410, -4.5, -2533.040, 1490.470, 200.000},
        {"Казино «4 Дракона»", 1817.390, 863.232, -89.084, 2027.390, 1083.230, 110.916},
        {"Блэкфилд", 964.391, 1203.220, -89.084, 1197.390, 1403.220, 110.916},
        {"Северная автострада Джулиус", 1534.560, 2433.230, -89.084, 1848.400, 2583.230, 110.916},
        {"Поле для гольфа «Йеллоу-Белл»", 1117.400, 2723.230, -89.084, 1457.460, 2863.230, 110.916},
        {"Айдлвуд", 1812.620, -1602.310, -89.084, 2124.660, -1449.670, 110.916},
        {"Западный Рэдсэндс", 1297.470, 2142.860, -89.084, 1777.390, 2243.230, 110.916},
        {"Доэрти", -2270.040, -324.114, -1.2, -1794.920, -222.589, 200.000},
        {"Ферма Хиллтоп", 967.383, -450.390, -3.0, 1176.780, -217.900, 200.000},
        {"Лас-Барранкас", -926.130, 1398.730, -3.0, -719.234, 1634.690, 200.000},
        {"Казино «Пираты в мужских штанах»", 1817.390, 1469.230, -89.084, 2027.400, 1703.230, 110.916},
        {"Сити Холл", -2867.850, 277.411, -9.1, -2593.440, 458.411, 200.000},
        {"Загородный клуб «Ависпа»", -2646.400, -355.493, 0.000, -2270.040, -222.589, 200.000},
        {"Стрип", 2027.400, 863.229, -89.084, 2087.390, 1703.230, 110.916},
        {"Хашбери", -2593.440, -222.589, -1.0, -2411.220, 54.722, 200.000},
        {"Международный аэропорт Лос-Сантос", 1852.000, -2394.330, -89.084, 2089.000, -2179.250, 110.916},
        {"Уайтвуд-Истейтс", 1098.310, 1726.220, -89.084, 1197.390, 2243.230, 110.916},
        {"Водохранилище Шермана", -789.737, 1659.680, -89.084, -599.505, 1929.410, 110.916},
        {"Эль-Корона", 1812.620, -2179.250, -89.084, 1970.620, -1852.870, 110.916},
        {"Деловой район", -1700.010, 744.267, -6.1, -1580.010, 1176.520, 200.000},
        {"Долина Фостер", -2178.690, -1250.970, 0.000, -1794.920, -1115.580, 200.000},
        {"Лас-Паясадас", -354.332, 2580.360, 2.0, -133.625, 2816.820, 200.000},
        {"Долина Окультадо", -936.668, 2611.440, 2.0, -715.961, 2847.900, 200.000},
        {"Пересечение Блэкфилд", 1166.530, 795.010, -89.084, 1375.600, 1044.690, 110.916},
        {"Гантон", 2222.560, -1852.870, -89.084, 2632.830, -1722.330, 110.916},
        {"Международный аэропорт Истер-Бэй", -1213.910, -730.118, 0.000, -1132.820, -50.096, 200.000},
        {"Восточный Рэдсэндс", 1817.390, 2011.830, -89.084, 2106.700, 2202.760, 110.916},
        {"Восточная Эспаланда", -1499.890, 578.396, -79.615, -1339.890, 1274.260, 20.385},
        {"Дворец Калигулы", 2087.390, 1543.230, -89.084, 2437.390, 1703.230, 110.916},
        {"Казино «Рояль»", 2087.390, 1383.230, -89.084, 2437.390, 1543.230, 110.916},
        {"Ричман", 72.648, -1235.070, -89.084, 321.356, -1008.150, 110.916},
        {"Казино «Морская звезда»", 2437.390, 1783.230, -89.084, 2685.160, 2012.180, 110.916},
        {"Малхолланд", 1281.130, -452.425, -89.084, 1641.130, -290.913, 110.916},
        {"Деловой район", -1982.320, 744.170, -6.1, -1871.720, 1274.260, 200.000},
        {"Ханки-Панки-Пойнт", 2576.920, 62.158, 0.000, 2759.250, 385.503, 200.000},
        {"Военный склад топлива К.А.С.С.", 2498.210, 2626.550, -89.084, 2749.900, 2861.550, 110.916},
        {"Автострада «Гарри-Голд»", 1777.390, 863.232, -89.084, 1817.390, 2342.830, 110.916},
        {"Тоннель Бэйсайд", -2290.190, 2548.290, -89.084, -1950.190, 2723.290, 110.916},
        {"Океанские доки", 2324.000, -2302.330, -89.084, 2703.580, -2145.100, 110.916},
        {"Ричман", 321.356, -1044.070, -89.084, 647.557, -860.619, 110.916},
        {"Промсклад имени Рэндольфа", 1558.090, 596.349, -89.084, 1823.080, 823.235, 110.916},
        {"Восточный пляж", 2632.830, -1852.870, -89.084, 2959.350, -1668.130, 110.916},
        {"Флинт-Уотер", -314.426, -753.874, -89.084, -106.339, -463.073, 110.916},
        {"Блуберри", 19.607, -404.136, 3.8, 349.607, -220.137, 200.000},
        {"Станция «Линден»", 2749.900, 1198.990, -89.084, 2923.390, 1548.990, 110.916},
        {"Глен Парк", 1812.620, -1350.720, -89.084, 2056.860, -1100.820, 110.916},
        {"Деловой район", -1993.280, 265.243, -9.1, -1794.920, 578.396, 200.000},
        {"Западный Рэдсэндс", 1377.390, 2243.230, -89.084, 1704.590, 2433.230, 110.916},
        {"Ричман", 321.356, -1235.070, -89.084, 647.522, -1044.070, 110.916},
        {"Мост «Гант»", -2741.450, 1659.680, -6.1, -2616.400, 2175.150, 200.000},
        {"Бар «Probe Inn»", -90.218, 1286.850, -3.0, 153.859, 1554.120, 200.000},
        {"Пересечение Флинт", -187.700, -1596.760, -89.084, 17.063, -1276.600, 110.916},
        {"Лас-Колинас", 2281.450, -1135.040, -89.084, 2632.740, -945.035, 110.916},
        {"Собелл-Рейл-Ярдс", 2749.900, 1548.990, -89.084, 2923.390, 1937.250, 110.916},
        {"Изумрудный остров", 2011.940, 2202.760, -89.084, 2237.400, 2508.230, 110.916},
        {"Эль-Кастильо-дель-Дьябло", -208.570, 2123.010, -7.6, 114.033, 2337.180, 200.000},
        {"Санта-Флора", -2741.070, 458.411, -7.6, -2533.040, 793.411, 200.000},
        {"Плайя-дель-Севиль", 2703.580, -2126.900, -89.084, 2959.350, -1852.870, 110.916},
        {"Маркет", 926.922, -1577.590, -89.084, 1370.850, -1416.250, 110.916},
        {"Квинс", -2593.440, 54.722, 0.000, -2411.220, 458.411, 200.000},
        {"Пересечение Пилсон", 1098.390, 2243.230, -89.084, 1377.390, 2507.230, 110.916},
        {"Спинибед", 2121.400, 2663.170, -89.084, 2498.210, 2861.550, 110.916},
        {"Пилигрим", 2437.390, 1383.230, -89.084, 2624.400, 1783.230, 110.916},
        {"Блэкфилд", 964.391, 1403.220, -89.084, 1197.390, 1726.220, 110.916},
        {"«Большое ухо»", -410.020, 1403.340, -3.0, -137.969, 1681.230, 200.000},
        {"Диллимор", 580.794, -674.885, -9.5, 861.085, -404.790, 200.000},
        {"Эль-Кебрадос", -1645.230, 2498.520, 0.000, -1372.140, 2777.850, 200.000},
        {"Северная Эспланада", -2533.040, 1358.900, -4.5, -1996.660, 1501.210, 200.000},
        {"Международный аэропорт Истер-Бэй", -1499.890, -50.096, -1.0, -1242.980, 249.904, 200.000},
        {"Рыбацкая лагуна", 1916.990, -233.323, -100.000, 2131.720, 13.800, 200.000},
        {"Малхолланд", 1414.070, -768.027, -89.084, 1667.610, -452.425, 110.916},
        {"Восточный пляж", 2747.740, -1498.620, -89.084, 2959.350, -1120.040, 110.916},
        {"Сан-Андреас Саунд", 2450.390, 385.503, -100.000, 2759.250, 562.349, 200.000},
        {"Тенистые ручьи", -2030.120, -2174.890, -6.1, -1820.640, -1771.660, 200.000},
        {"Маркет", 1072.660, -1416.250, -89.084, 1370.850, -1130.850, 110.916},
        {"Западный Рокшор", 1997.220, 596.349, -89.084, 2377.390, 823.228, 110.916},
        {"Прикл-Пайн", 1534.560, 2583.230, -89.084, 1848.400, 2863.230, 110.916},
        {"«Бухта Пасхи»", -1794.920, -50.096, -1.04, -1499.890, 249.904, 200.000},
        {"Лифи-Холлоу", -1166.970, -1856.030, 0.000, -815.624, -1602.070, 200.000},
        {"Грузовое депо Лас-Вентураса", 1457.390, 863.229, -89.084, 1777.400, 1143.210, 110.916},
        {"Прикл-Пайн", 1117.400, 2507.230, -89.084, 1534.560, 2723.230, 110.916},
        {"Блуберри", 104.534, -220.137, 2.3, 349.607, 152.236, 200.000},
        {"Эль-Кастильо-дель-Дьябло", -464.515, 2217.680, 0.000, -208.570, 2580.360, 200.000},
        {"Деловой район", -2078.670, 578.396, -7.6, -1499.890, 744.267, 200.000},
        {"Восточный Рокшор", 2537.390, 676.549, -89.084, 2902.350, 943.235, 110.916},
        {"Залив Сан-Фиерро", -2616.400, 1501.210, -3.0, -1996.660, 1659.680, 200.000},
        {"Парадизо", -2741.070, 793.411, -6.1, -2533.040, 1268.410, 200.000},
        {"Казино «Носок верблюда»", 2087.390, 1203.230, -89.084, 2640.400, 1383.230, 110.916},
        {"Олд-Вентурас-Стрип", 2162.390, 2012.180, -89.084, 2685.160, 2202.760, 110.916},
        {"Джанипер-Хилл", -2533.040, 578.396, -7.6, -2274.170, 968.369, 200.000},
        {"Джанипер-Холлоу", -2533.040, 968.369, -6.1, -2274.170, 1358.900, 200.000},
        {"Рока-Эскаланте", 2237.400, 2202.760, -89.084, 2536.430, 2542.550, 110.916},
        {"Восточная автострада Джулиус", 2685.160, 1055.960, -89.084, 2749.900, 2626.550, 110.916},
        {"Пляж «Верона»", 647.712, -2173.290, -89.084, 930.221, -1804.210, 110.916},
        {"Долина Фостер", -2178.690, -599.884, -1.2, -1794.920, -324.114, 200.000},
        {"Арко-дель-Оэсте", -901.129, 2221.860, 0.000, -592.090, 2571.970, 200.000},
        {"«Упавшее дерево»", -792.254, -698.555, -5.3, -452.404, -380.043, 200.000},
        {"Ферма", -1209.670, -1317.100, 114.981, -908.161, -787.391, 251.981},
        {"Дамба Шермана", -968.772, 1929.410, -3.0, -481.126, 2155.260, 200.000},
        {"Северная Эспланада", -1996.660, 1358.900, -4.5, -1524.240, 1592.510, 200.000},
        {"Финансовый район", -1871.720, 744.170, -6.1, -1701.300, 1176.420, 300.000},
        {"Гарсия", -2411.220, -222.589, -1.14, -2173.040, 265.243, 200.000},
        {"Монтгомери", 1119.510, 119.526, -3.0, 1451.400, 493.323, 200.000},
        {"Крик", 2749.900, 1937.250, -89.084, 2921.620, 2669.790, 110.916},
        {"Международный аэропорт Лос-Сантос", 1249.620, -2394.330, -89.084, 1852.000, -2179.250, 110.916},
        {"Пляж «Санта-Мария»", 72.648, -2173.290, -89.084, 342.648, -1684.650, 110.916},
        {"Пересечение Малхолланд", 1463.900, -1150.870, -89.084, 1812.620, -768.027, 110.916},
        {"Эйнджел-Пайн", -2324.940, -2584.290, -6.1, -1964.220, -2212.110, 200.000},
        {"Вёрдант-Медоус", 37.032, 2337.180, -3.0, 435.988, 2677.900, 200.000},
        {"Октан-Спрингс", 338.658, 1228.510, 0.000, 664.308, 1655.050, 200.000},
        {"Казино Кам-э-Лот", 2087.390, 943.235, -89.084, 2623.180, 1203.230, 110.916},
        {"Западный Рэдсэндс", 1236.630, 1883.110, -89.084, 1777.390, 2142.860, 110.916},
        {"Пляж «Санта-Мария»", 342.648, -2173.290, -89.084, 647.712, -1684.650, 110.916},
        {"Обсерватория «Зелёный утёс", 1249.620, -2179.250, -89.084, 1692.620, -1842.270, 110.916},
        {"Аэропорт Лас-Вентурас", 1236.630, 1203.280, -89.084, 1457.370, 1883.110, 110.916},
        {"Округ Флинт", -594.191, -1648.550, 0.000, -187.700, -1276.600, 200.000},
        {"Обсерватория «Зелёный утёс", 930.221, -2488.420, -89.084, 1249.620, -2006.780, 110.916},
        {"Паломино Крик", 2160.220, -149.004, 0.000, 2576.920, 228.322, 200.000},
        {"Океанские доки", 2373.770, -2697.090, -89.084, 2809.220, -2330.460, 110.916},
        {"Международный аэропорт Истер-Бэй", -1213.910, -50.096, -4.5, -947.980, 578.396, 200.000},
        {"Уайтвуд-Истейтс", 883.308, 1726.220, -89.084, 1098.310, 2507.230, 110.916},
        {"Калтон-Хайтс", -2274.170, 744.170, -6.1, -1982.320, 1358.900, 200.000},
        {"«Бухта Пасхи»", -1794.920, 249.904, -9.1, -1242.980, 578.396, 200.000},
        {"Залив Лос-Сантос", -321.744, -2224.430, -89.084, 44.615, -1724.430, 110.916},
        {"Доэрти", -2173.040, -222.589, -1.0, -1794.920, 265.243, 200.000},
        {"Гора Чилиад", -2178.690, -2189.910, -47.917, -2030.120, -1771.660, 576.083},
        {"Форт-Карсон", -376.233, 826.326, -3.0, 123.717, 1220.440, 200.000},
        {"Долина Фостер", -2178.690, -1115.580, 0.000, -1794.920, -599.884, 200.000},
        {"Оушен-Флэтс", -2994.490, -222.589, -1.0, -2593.440, 277.411, 200.000},
        {"Ферн-Ридж", 508.189, -139.259, 0.000, 1306.660, 119.526, 200.000},
        {"Бэйсайд", -2741.070, 2175.150, 0.000, -2353.170, 2722.790, 200.000},
        {"Аэропорт Лас-Вентурас", 1457.370, 1203.280, -89.084, 1777.390, 1883.110, 110.916},
        {"Поместье Блуберри", -319.676, -220.137, 0.000, 104.534, 293.324, 200.000},
        {"Пэлисейдс", -2994.490, 458.411, -6.1, -2741.070, 1339.610, 200.000},
        {"Норт-Рок", 2285.370, -768.027, 0.000, 2770.590, -269.740, 200.000},
        {"Карьер «Хантер»", 337.244, 710.840, -115.239, 860.554, 1031.710, 203.761},
        {"Международный аэропорт Лос-Сантос", 1382.730, -2730.880, -89.084, 2201.820, -2394.330, 110.916},
        {"Миссионер-Хилл", -2994.490, -811.276, 0.000, -2178.690, -430.276, 200.000},
        {"Залив Сан-Фиерро", -2616.400, 1659.680, -3.0, -1996.660, 2175.150, 200.000},
        {"Запретная Зона", -91.586, 1655.050, -50.000, 421.234, 2123.010, 250.000},
        {"Гора «Чилиад»", -2997.470, -1115.580, -47.917, -2178.690, -971.913, 576.083},
        {"Гора «Чилиад»", -2178.690, -1771.660, -47.917, -1936.120, -1250.970, 576.083},
        {"Международный аэропорт Истер-Бэй", -1794.920, -730.118, -3.0, -1213.910, -50.096, 200.000},
        {"Паноптикум", -947.980, -304.320, -1.1, -319.676, 327.071, 200.000},
        {"Тенистые ручьи", -1820.640, -2643.680, -8.0, -1226.780, -1771.660, 200.000},
        {"Бэк-о-Бейонд", -1166.970, -2641.190, 0.000, -321.744, -1856.030, 200.000},
        {"Гора «Чилиад»", -2994.490, -2189.910, -47.917, -2178.690, -1115.580, 576.083},
        {"Тьерра Робада", -1213.910, 596.349, -242.990, -480.539, 1659.680, 900.000},
        {"Округ Флинт", -1213.910, -2892.970, -242.990, 44.615, -768.027, 900.000},
        {"Уэтстоун", -2997.470, -2892.970, -242.990, -1213.910, -1115.580, 900.000},
        {"Пустынный округ", -480.539, 596.349, -242.990, 869.461, 2993.870, 900.000},
        {"Тьерра Робада", -2997.470, 1659.680, -242.990, -480.539, 2993.870, 900.000},
        {"Сан Фиерро", -2997.470, -1115.580, -242.990, -1213.910, 1659.680, 900.000},
        {"Лас Вентурас", 869.461, 596.349, -242.990, 2997.060, 2993.870, 900.000},
        {"Туманный округ", -1213.910, -768.027, -242.990, 2997.060, 596.349, 900.000},
        {"Лос Сантос", 44.615, -2892.970, -242.990, 2997.060, -768.027, 900.000}
	}
    for i, v in ipairs(streets) do
        if (x >= v[2]) and (y >= v[3]) and (z >= v[4]) and (x <= v[5]) and (y <= v[6]) and (z <= v[7]) then
            return v[1]
		end
	end
    return 'Пригород'
end
function autoPiar()
	autoPiar_state = imgui.ImBool(false)
	autoPiar_delay = imgui.ImInt(mainIni.autoPiar.delay_c)
	autoPiar_text = imgui.ImBuffer(tostring(mainIni.autoPiar.text_c), 1024)
	autoPiar_vr = imgui.ImBool(mainIni.autoPiar.vr_c)
	autoPiar_ad = imgui.ImBool(mainIni.autoPiar.ad_c)
	autoPiar_ad_vip = imgui.ImBool(mainIni.autoPiar.ad_vip_c)
	autoPiar_j = imgui.ImBool(mainIni.autoPiar.j_c)
	autoPiar_org = imgui.ImBool(mainIni.autoPiar.org_c)
	autoPiar_selected_org = imgui.ImInt(mainIni.autoPiar.selected_org)
	autoPiar_timer = 0
	local _ = false
	addEventHandler("onReceiveRpc", function(id,bs)
		if id == 61 and _ and autoPiar_ad.v then
			local did = raknetBitStreamReadInt16(bs)
			local style = raknetBitStreamReadInt8(bs)
			local tl = raknetBitStreamReadInt8(bs)
			local t = raknetBitStreamReadString(bs,tl)
			local b1l = raknetBitStreamReadInt8(bs)
			local b1 = raknetBitStreamReadString(bs,b1l)
			local b2l = raknetBitStreamReadInt8(bs)
			local b2 = raknetBitStreamReadString(bs,b2l)
			local text = raknetBitStreamDecodeString(bs,4096)
			if t:match("{BFBBBA}Подача объявления | Подтверждение") then
				sampSendDialogResponse(did, 1, 1, "")
				return false
			end
			if style == 5 and t:match("{BFBBBA}Подача объявления") then
				if autoPiar_ad_vip.v then sampSendDialogResponse(did, 1, 1, "")
				else sampSendDialogResponse(did, 1, 0, "") end
				return false
			end
		end
	end)
	while true do wait(0)
		if autoPiar_state.v then
			lua_thread.create(function()
				local text = u8:decode(autoPiar_text.v)
				_ = true
				if autoPiar_vr.v and autoPiar_state.v then
					if text ~= "" then
						sampSendChat("/vr "..text)
						wait(3000)
						else
						sampAddChatMessage("{c41e3a}[Unknown]: {ffffff}Вы не ввели текст пиара", -1)
						autoPiar_state.v = false
					end
				end
				if autoPiar_ad.v and autoPiar_state.v then
					if text ~= "" then
						if text:len() > 19 then
							sampSendChat("/ad "..text)
							wait(3000)
							else
							sampAddChatMessage("{c41e3a}[Unknown]: {ffffff}Текст пиара для ad должен быть от 20 символов")
						end
						else
						sampAddChatMessage("{c41e3a}[Unknown]: {ffffff}Вы не ввели текст пиара", -1)
						autoPiar_state.v = false
					end
				end
				if autoPiar_j.v and autoPiar_state.v then
					if text ~= "" then
						sampSendChat("/j "..text)
						wait(3000)
						else
						sampAddChatMessage("{c41e3a}[Unknown]: {ffffff}Вы не ввели текст пиара", -1)
						autoPiar_state.v = false
					end
				end
				if autoPiar_org.v and autoPiar_state.v then
					if text ~= "" then
						if autoPiar_selected_org.v == 0 then
							sampSendChat("/fb "..text)
							else
							sampSendChat("/rb "..text)
						end
						wait(3000)
						else
						sampAddChatMessage("{c41e3a}[Unknown]: {ffffff}Вы не ввели текст пиара", -1)
						autoPiar_state.v = false
					end
				end
				sampCloseCurrentDialogWithButton(1)
				_ = false
			end)
			autoPiar_timer = autoPiar_delay.v
			for i = 0, autoPiar_delay.v do
				wait(1000)
				autoPiar_timer = autoPiar_timer - 1
				if not autoPiar_state.v then break end
			end
		end
	end
end
function insuranceCatch()
	insuranceCatch_state = imgui.ImBool(mainIni.insurance.catch_state_c)
	local finded = false
	addEventHandler("onReceiveRpc", function(id, bs)
        if id == 93 and insuranceCatch_state.v then
            color = raknetBitStreamReadInt32(bs)
            textl = raknetBitStreamReadInt32(bs)
            text = raknetBitStreamReadString(bs, textl)
			if text:match("Вы приняли заявление .+ на рассмотрение") then
				lua_thread.create(function()
					wait(100)
					sampAddChatMessage("{c41e3a}[Unknown]: {ffffff}Вы взяли заявление",-1)
				end)
			end
            if text:match(".+ подал заявление на страхование имущества, номер заявления:") then
				local inArea = isCharInArea3d(PLAYER_PED, 1522.6199, 1614.5894, 8.5453, 1519.6072, 1617.7963, 12.2203, false)
				if inArea then
					finded = true
					lua_thread.create(function()
						wait(3000)
						finded = false
					end)
					local health = getCharHealth(PLAYER_PED)
					local armour = getCharArmour(PLAYER_PED)
					local wep = getCurrentCharWeapon(PLAYER_PED)
					bs = raknetNewBitStream()
					raknetBitStreamWriteInt8(bs,207)
					raknetBitStreamWriteInt16(bs,0)
					raknetBitStreamWriteInt16(bs,0)
					raknetBitStreamWriteInt16(bs,1024)
					raknetBitStreamWriteFloat(bs,1520.5830)
					raknetBitStreamWriteFloat(bs,1616.3347)
					raknetBitStreamWriteFloat(bs,10.8703)
					raknetBitStreamWriteFloat(bs,0)
					raknetBitStreamWriteFloat(bs,0)
					raknetBitStreamWriteFloat(bs,0)
					raknetBitStreamWriteFloat(bs,0)
					raknetBitStreamWriteInt8(bs,health)
					raknetBitStreamWriteInt8(bs,armour)
					raknetBitStreamWriteInt8(bs,wep)
					raknetBitStreamWriteInt8(bs,0)
					raknetBitStreamWriteFloat(bs,0)
					raknetBitStreamWriteFloat(bs,0)
					raknetBitStreamWriteFloat(bs,0)
					raknetBitStreamWriteFloat(bs,0)
					raknetBitStreamWriteFloat(bs,0)
					raknetBitStreamWriteFloat(bs,0)
					raknetBitStreamWriteInt16(bs,0)
					raknetBitStreamWriteInt16(bs,1189)
					raknetBitStreamWriteInt16(bs,32772)
					raknetSendBitStream(bs)
					raknetDeleteBitStream(bs)
				else
					lua_thread.create(function()
						wait(100)
						sampAddChatMessage("{c41e3a}[Unknown]: {ffffff}Вы слишком далеко от принятия заявлений",-1)
					end)
				end
			end
		end
		if id == 61 and insuranceCatch_state.v and finded then
			local did = raknetBitStreamReadInt16(bs)
			local style = raknetBitStreamReadInt8(bs)
			local tl = raknetBitStreamReadInt8(bs)
			local t = raknetBitStreamReadString(bs,tl)
			local b1l = raknetBitStreamReadInt8(bs)
			local b1 = raknetBitStreamReadString(bs,b1l)
			local b2l = raknetBitStreamReadInt8(bs)
			local b2 = raknetBitStreamReadString(bs,b2l)
			local text = raknetBitStreamDecodeString(bs,4096)
            if t == "{BFBBBA}Заявки на страхование (1/1)" then
				text = stringSplit(text, "\n")
				for i = 2, #text do
					if not text[i]:match("{cccccc}| в работе: .+") then sampSendDialogResponse(did, 1, i-2, "") break end
				end
				return false
			end
			if t:match("{BFBBBA}Заявление") and text:match("{ffffff}Заявление {ffff00}.+{ffffff}от {ffff00}.+") then
				sampSendDialogResponse(did, 1, 0, "")
				finded = false
				return false
			end
		end
	end)
	while true do wait(0) end
end
function insuranceNY()
	insuranceNY_state = imgui.ImBool(mainIni.insurance.NY_state_c)
	while true do wait(50)
		if sampTextdrawIsExists(2062) and insuranceNY_state.v then
			local inArea2 = isCharInArea3d(PLAYER_PED, 1524.0441, 1613.4524, 9.2203, 1526.7075, 1616.5979, 11.6203, false)
			local inArea1 = isCharInArea3d(PLAYER_PED, 1516.5701, 1613.4512, 9.1453, 1518.8618, 1616.6068, 11.2453, false)
			if inArea1 or inArea2 then
				if sampTextdrawGetString(2062) == "Press_Y" then
					local health = getCharHealth(PLAYER_PED)
					local armour = getCharArmour(PLAYER_PED)
					local wep = getCurrentCharWeapon(PLAYER_PED)
					local x, y, z = getCharCoordinates(PLAYER_PED)
					bs = raknetNewBitStream()
					raknetBitStreamWriteInt8(bs,207)
					raknetBitStreamWriteInt16(bs,0)
					raknetBitStreamWriteInt16(bs,0)
					raknetBitStreamWriteInt16(bs,0)
					raknetBitStreamWriteFloat(bs,x)
					raknetBitStreamWriteFloat(bs,y)
					raknetBitStreamWriteFloat(bs,z)
					raknetBitStreamWriteFloat(bs,0)
					raknetBitStreamWriteFloat(bs,0)
					raknetBitStreamWriteFloat(bs,0)
					raknetBitStreamWriteFloat(bs,0)
					raknetBitStreamWriteInt8(bs,health)
					raknetBitStreamWriteInt8(bs,armour)
					raknetBitStreamWriteInt8(bs,wep + 64)
					raknetBitStreamWriteInt8(bs,0)
					raknetBitStreamWriteFloat(bs,0)
					raknetBitStreamWriteFloat(bs,0)
					raknetBitStreamWriteFloat(bs,0)
					raknetBitStreamWriteFloat(bs,0)
					raknetBitStreamWriteFloat(bs,0)
					raknetBitStreamWriteFloat(bs,0)
					raknetBitStreamWriteInt16(bs,0)
					raknetBitStreamWriteInt16(bs,1189)
					raknetBitStreamWriteInt16(bs,32772)
					raknetSendBitStream(bs)
					raknetDeleteBitStream(bs)
					lua_thread.create(function()
						wait(200)
						sampSendClickTextdraw(65535)
					end)
				end
				if sampTextdrawGetString(2062) == "Press_N" then
					local health = getCharHealth(PLAYER_PED)
					local armour = getCharArmour(PLAYER_PED)
					local wep = getCurrentCharWeapon(PLAYER_PED)
					local x, y, z = getCharCoordinates(PLAYER_PED)
					bs = raknetNewBitStream()
					raknetBitStreamWriteInt8(bs,207)
					raknetBitStreamWriteInt16(bs,0)
					raknetBitStreamWriteInt16(bs,0)
					raknetBitStreamWriteInt16(bs,0)
					raknetBitStreamWriteFloat(bs,x)
					raknetBitStreamWriteFloat(bs,y)
					raknetBitStreamWriteFloat(bs,z)
					raknetBitStreamWriteFloat(bs,0)
					raknetBitStreamWriteFloat(bs,0)
					raknetBitStreamWriteFloat(bs,0)
					raknetBitStreamWriteFloat(bs,0)
					raknetBitStreamWriteInt8(bs,health)
					raknetBitStreamWriteInt8(bs,armour)
					raknetBitStreamWriteInt8(bs,wep + 128)
					raknetBitStreamWriteInt8(bs,0)
					raknetBitStreamWriteFloat(bs,0)
					raknetBitStreamWriteFloat(bs,0)
					raknetBitStreamWriteFloat(bs,0)
					raknetBitStreamWriteFloat(bs,0)
					raknetBitStreamWriteFloat(bs,0)
					raknetBitStreamWriteFloat(bs,0)
					raknetBitStreamWriteInt16(bs,0)
					raknetBitStreamWriteInt16(bs,1189)
					raknetBitStreamWriteInt16(bs,32772)
					raknetSendBitStream(bs)
					raknetDeleteBitStream(bs)
					lua_thread.create(function()
						wait(200)
						sampSendClickTextdraw(65535)
					end)
				end
			end
		end
	end
end
function insuranceFill()
	insuranceFill_state = imgui.ImBool(mainIni.insurance.fill_state_c)
	local st = false
	addEventHandler("onReceiveRpc", function(id,bs)
		if id == 134 and insuranceFill_state.v then
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
			if text == "ARZ_INSURANCE_COMPANY" then
				lua_thread.create(function()
					sampSendClickTextdraw(242)
					repeat wait(100) until st
					st = false
					sampSendClickTextdraw(243)
					repeat wait(100) until st
					st = false
					sampSendClickTextdraw(244)
					repeat wait(100) until st
					st = false
					sampSendClickTextdraw(245)
				end)
				lua_thread.create(function()
					wait(3000)
					st = false
				end)
			end
		end
		if id == 61 and insuranceFill_state.v then
			local id = raknetBitStreamReadInt16(bs)
			local style = raknetBitStreamReadInt8(bs)
			local tl = raknetBitStreamReadInt8(bs)
			local t = raknetBitStreamReadString(bs,tl)
			local b1l = raknetBitStreamReadInt8(bs)
			local b1 = raknetBitStreamReadString(bs,b1l)
			local b2l = raknetBitStreamReadInt8(bs)
			local b2 = raknetBitStreamReadString(bs,b2l)
			local text = raknetBitStreamDecodeString(bs,4096)
			if t == "{BFBBBA}Заполнение документа" then
				local request = text:match("{ffff00}(.+)")
				sampSendDialogResponse(id, 1, 0, request)
				st = true
				return false
			end
		end
	end)
	while true do wait(0) end
end
function insuranceRemoveAnim()
	insuranceRemoveAnim_state = imgui.ImBool(mainIni.insurance.anim_state_c)
	addEventHandler("onReceiveRpc", function(id,bs)
		if id == 86 and insuranceRemoveAnim_state.v then
			local id = raknetBitStreamReadInt16(bs)
			local animlibl = raknetBitStreamReadInt8(bs)
			local animlib = raknetBitStreamReadString(bs,animlibl)
			local animnamel = raknetBitStreamReadInt8(bs)
			local animname = raknetBitStreamReadString(bs,animnamel)
			if animname == "WASH_UP" then return false end
		end
	end)
	while true do wait(0) end
end
function cruise()
	cruise_state = imgui.ImBool(mainIni.settings.cruise_state_c)
	local active = false
	local speed = 0
	lua_thread.create(function()
		while true do wait(0)
			if active then
				sampTextdrawCreate(226, "~r~CRUISE", 10, 430)
				sampTextdrawSetLetterSizeAndColor(223, 0.2, 1, -1)
				sampTextdrawSetOutlineColor(226, 1, 0xFF000000)
				sampTextdrawSetAlign(226, 1)
				sampTextdrawSetStyle(226, 1)
				wait(0)
			else
				if sampTextdrawIsExists(226) then sampTextdrawDelete(226) end
			end
		end
	end)
	while true do wait(0)
		if isCharInAnyCar(PLAYER_PED) and cruise_state.v then
			local engine = isCarEngineOn(storeCarCharIsInNoSave(PLAYER_PED))
			if wasKeyPressed(0xBB) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() and not isSampfuncsConsoleActive() then
				speed = getCarSpeed(storeCarCharIsInNoSave(PLAYER_PED))
				active = not active
			end
			if active and engine then
				setGameKeyState(16, 255)
				if getCarSpeed(storeCarCharIsInNoSave(PLAYER_PED)) > speed then
					setCarForwardSpeed(storeCarCharIsInNoSave(PLAYER_PED), speed)
				end
			end
			if wasKeyPressed(0x57) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() and not isSampfuncsConsoleActive() then
				active = false
			end
			if wasKeyPressed(0x53) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() and not isSampfuncsConsoleActive() then
				active = false
			end
        else
			active = false
		end
	end
end
function sbiv()
	sbiv_state = imgui.ImBool(mainIni.settings.sbiv_state_c)
	while true do wait(0)
		if isKeyJustPressed(0x51) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() and not isSampfuncsConsoleActive() and sbiv_state.v and not isCharInAnyCar(PLAYER_PED) then
			local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
			if _ then
				bs = raknetNewBitStream()
				raknetBitStreamWriteInt16(bs,id)
				raknetEmulRpcReceiveBitStream(87, bs)
				raknetDeleteBitStream(bs)
			end
		end
	end
end
function notepad()
	notepad_window = false
	notepad_text = imgui.ImBuffer(tostring(decodeJson(mainIni.settings.notepad_text_c)), 256)
	addEventHandler("onSendRpc", function(id,bs)
		if id == 50 then
			local lenght = raknetBitStreamReadInt32(bs)
			local text = raknetBitStreamReadString(bs,lenght)
			if text == ("/notepad") then
                notepad_window = true
                cursorActive = true
                playerLock = true
                return false
			end
		end
	end)
	while true do wait(0) end
end
function autolock()
	autolock_state = imgui.ImBool(mainIni.settings.autolock_state_c)
	local go = false
	function getClosestCarId()
		local minDist = 9999
		local closestId = -1
		local x, y, z = getCharCoordinates(PLAYER_PED)
		for i = 0, 1800 do
			local streamed, pedID = sampGetCarHandleBySampVehicleId(i)
			if streamed then
				local xi, yi, zi = getCarCoordinates(pedID)
				local dist = math.sqrt( (xi - x) ^ 2 + (yi - y) ^ 2 + (zi - z) ^ 2 )
				if dist < minDist then
					minDist = dist
					closestId = i
				end
			end
		end
		return closestId, minDist
	end
	while true do wait(0)
		local carId, dist = getClosestCarId()
		local _, vehicle = sampGetCarHandleBySampVehicleId(carId)
		if _ then
			local bd = getCarDoorLockStatus(vehicle)
			if isKeyJustPressed(0x46) and not sampIsChatInputActive() and not sampIsDialogActive() and not sampIsScoreboardOpen() and not isSampfuncsConsoleActive() and autolock_state.v and not isCharInAnyCar(PLAYER_PED) and dist < 4 and bd == 2 then
				go = true
				sampSendChat("/lockid "..carId)
				lua_thread.create(function()
					for i = 1, 4 do
						local door = getCarDoorLockStatus(vehicle)
						local carId, dist = getClosestCarId()
						if door ~= 2 and dist < 4 then
							sampSendEnterVehicle(carId, false)
							taskEnterCarAsDriver(PLAYER_PED, vehicle, 4000)
							break
						end
						wait(500)
					end
				end)
			end
			if wasKeyReleased(0x46) and go then
				go = false
				lua_thread.create(function()
					for i = 1, 30 do
						if isCharInAnyCar(PLAYER_PED) then local id, dist = getClosestCarId() sampSendChat("/lockid "..id) break end
						wait(500)
					end
				end)
			end
		end
	end
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
			moneySeparate_state_c = moneySeparate_state.v,
			cruise_state_c = cruise_state.v,
			sbiv_state_c = sbiv_state.v,
			notepad_text_c = encodeJson(notepad_text.v),
			autolock_state_c = autolock_state.v,
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
		autoPiar = {
			delay_c = autoPiar_delay.v,
			text_c = autoPiar_text.v,
			vr_c = autoPiar_vr.v,
			ad_c = autoPiar_ad.v,
			ad_vip_c = autoPiar_ad_vip.v,
			j_c = autoPiar_j.v,
			org_c = autoPiar_org.v,
			selected_org = autoPiar_selected_org.v,
		},
		police = {
			taser_state_c = taser_state.v,
			rpGuns_state_c = rpGuns_state.v,
			megafon_state_c = megafon_state.v,
			autoMiranda_state_c = autoMiranda_state.v,
			autoRP_state_c = autoRP_state.v,
			requireSu_state_c = requireSu_state.v,
		},
		insurance = {
			catch_state_c = insuranceCatch_state.v,
			NY_state_c = insuranceNY_state.v,
			fill_state_c = insuranceFill_state.v,
			anim_state_c = insuranceRemoveAnim_state.v,
		},
		medic = {
			
		},
	}
	inicfg.save(newData,"unknown.ini")
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
                                            sampAddChatMessage("{c41e3a}[Unknown]: {ffffff}Обновление прошло успешно на версию "..updateversion,-1)
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