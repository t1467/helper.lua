local memory = require("memory")
require("lib.sampfuncs")
require("moonloader")
local inicfg = require 'inicfg'
local imgui = require('imgui')
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local mainIni = inicfg.load({
	afktools = {
		antiafk_state_c = false,
		autologin_enable_c = false,
        autologin_pass_c = "",
        autoEat_enable_c = false,
	},
    removeTrash = {
        enable_c = false,
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
    }
},"helper.ini")

local state = imgui.ImBool(false)
local afktools_window = imgui.ImBool(false)
local removeTrash_window = imgui.ImBool(false)

if not doesDirectoryExist(getWorkingDirectory().."\\unknown") then createDirectory(getWorkingDirectory().."\\unknown") end
if doesFileExist(getWorkingDirectory().."\\unknown\\logo.jpg") then
	img = imgui.CreateTextureFromFile(getWorkingDirectory().."\\unknown\\logo.jpg")
else
	downloadUrlToFile("https://i.yapx.ru/RORWj.jpg", getWorkingDirectory().."\\unknown\\logo.jpg", function() img = imgui.CreateTextureFromFile(getWorkingDirectory().."\\unknown\\logo.jpg") end)
end

function imgui.OnDrawFrame()
	if state.v then
		local resX, resY = getScreenResolution()
		local sizeX, sizeY = 940, 505
		imgui.SetNextWindowPos(imgui.ImVec2(resX / 2 - sizeX / 2, resY / 2 - sizeY / 2), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY), imgui.Cond.FirstUseEver)
		imgui.Begin('Choose Window', state, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoTitleBar)
		imgui.BeginChild("Panel", imgui.ImVec2(276, 490), true, imgui.WindowFlags.NoScrollbar)
			imgui.Image(img, imgui.ImVec2(260, 100))
			if imgui.CollapsingHeader(u8'Основное') then
				if imgui.Button(u8"AFK Tools", imgui.ImVec2(-1,20)) then closeAllWindows() afktools_window.v = true end
                if imgui.Button(u8"Remove trash", imgui.ImVec2(-1,20)) then closeAllWindows() removeTrash_window.v = true end
			end
		imgui.EndChild()
		imgui.SameLine(290)
		imgui.BeginChild("Menu", imgui.ImVec2(644, 490), true, imgui.WindowFlags.NoScrollbar)
        if afktools_window.v then
            imgui.Checkbox(u8"Антиафк", antiafk_state)
            imgui.Checkbox(u8"Автологин", autologin_enable)
            imgui.InputText(u8"Пароль", autologin_pass, imgui.InputTextFlags.Password)
            imgui.Checkbox(u8"Авто еда (оленина)", autoEat_enable)
        end
        if removeTrash_window.v then
            imgui.Checkbox(u8"Включить", removeTrash_enable)
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
        end
		imgui.EndChild()
		imgui.End()
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
function onWindowMessage(slot0, slot1, slot2)
    if (slot0 == 256 or slot0 == 257) and slot1 == 27 and state.v and not isPauseMenuActive() then
        consumeWindowMessage(true, false) 
        if slot0 == 257 then
            state.v = false
        end
    end
end

function main()
	while not isSampAvailable() do wait(100) end
	if not doesDirectoryExist(getWorkingDirectory().."\\unknown") then createDirectory(getWorkingDirectory().."\\unknown") end
    lua_thread.create(antiafk)
    lua_thread.create(autologin)
    lua_thread.create(removeTrash)
    lua_thread.create(autoEat)
	sampRegisterChatCommand("helper",function()
		state.v = not state.v
	end)
	while true do wait(0)
		imgui.Process = state.v
        save()
	end
end

function closeAllWindows()
    afktools_window.v = false
    removeTrash_window.v = false
end

----------------------------------------------------ФУНКЦИИ----------------------------------------------------------------------
function antiafk()
    antiafk_state = imgui.ImBool(mainIni.afktools.antiafk_state_c)
    while true do wait(0)
        if antiafk_state.v then
            memory.setuint8(7634870, 1, false)
            memory.setuint8(7635034, 1, false)
            memory.fill(7623723, 144, 8, false)
            memory.fill(5499528, 144, 6, false)
        else
            memory.setuint8(7634870, 0, false)
            memory.setuint8(7635034, 0, false)
            memory.hex2bin('0F 84 7B 01 00 00', 7623723, 8)
            memory.hex2bin('50 51 FF 15 00 83 85 00', 5499528, 6)
        end
    end
end
function autologin()
	autologin_enable = imgui.ImBool(mainIni.afktools.autologin_enable_c)
	autologin_pass = imgui.ImBuffer(tostring(mainIni.afktools.autologin_pass_c), 255)
	addEventHandler("onReceiveRpc", function(id, bs)
		if id == 61 and autologin_enable.v then
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
function removeTrash()
    removeTrash_enable = imgui.ImBool(mainIni.removeTrash.enable_c)
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
    lua_thread.create(function()
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
    end)
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
        "[Информация] (.+)[_](.+) при сборе урожая на ферме словил (.+)",
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
            if removeTrash_bonus_status.v then
                for i = 1, #removeTrash_bonus do
                    if text:match(removeTrash_bonus[i]) then return false end
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
        end
    end)
    while true do wait(0) end
end
function autoEat()
    autoEat_enable = imgui.ImBool(mainIni.afktools.autoEat_enable_c)
    addEventHandler("onReceiveRpc", function()
        if id == 73 and autoEat_enable.v then
            local style = raknetBitStreamReadInt32(bs)
            local time = raknetBitStreamReadInt32(bs)
            local ml = raknetBitStreamReadInt32(bs)
            local m = tostring(raknetBitStreamReadString(bs,ml))
            if m:find('You are hungry!') or m:find('You are very hungry!') then
                sampSendChat('/jmeat')
            end
        end
    end)
    while true do wait(0) end
end
---------------------------------------------------------------------------------------------------------------------------------

function save()
	local newData = {
		afktools = {
			antiafk_state_c = antiafk_state.v,
			autologin_enable_c = autologin_enable.v,
            autologin_pass_c = autologin_pass.v,
            autoEat_enable_c = autoEat_enable.v
		},
        removeTrash = {
            enable_c = removeTrash_enable.v,
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
		}
	}
	inicfg.save(newData,"helper.ini")
end