//- Computer_WindowsInfo() - Ф., позволяющая получить информацию об установленной Windows на лок./уд. компьютере.
//- SendKeys() - П.: - Имитация нажатия клавиш.
//- ВремяВМиллисекундах() - Ф., возвращающая время в миллисекундах или секундах.
//- ЗадержкаВВыполнении() - Ф. задержки выполнения процесса.
//- SetDateTime() - Ф. вызова оснастки установки системных Даты и Времени.
//- ControlPanelItem() - Ф. вызова оснастки Панели управления.
//- SystemEnvironment() - Ф., позволяющая получить Переменные окружения лок. компьютера.
//- Computer_Motherboard() - Ф., позволяющая информацию о материнской плате лок./уд. компьютера.
//- Computer_BIOS() - Ф., позволяющая информацию о BIOS лок./уд. компьютера.
//- Computer_Processor() - Ф., позволяющая получить информацию о процессоре(ах) на лок./уд. компьютере.
//- Computer_RAM() - Ф., позволяющая получить информацию о памяти на лок./уд. компьютере.
//- Computer_TotalPhysicalMemory() - Ф., позволяющая получить информацию об объеме установленной памяти на лок./уд. компьютере.
//- Computer_PhysicalMemory() - Ф., позволяющая получить информацию о физической памяти на лок./уд. компьютере.
//- Computer_VirtualMemory() - Ф., позволяющая получить информацию о виртуальной памяти на лок./уд. компьютере.
//- Computer_Video() - Ф., позволяющая получить информацию о видео на лок./уд. компьютере.
//- Computer_Monitor() - Ф., позволяющая получить информацию о мониторе(ах) на лок./уд. компьютере.
//- Computer_Printer() - Ф., позволяющая получить список подключенных принтеров лок./уд. компьютера.
//- Network_Printer() - П. подключения сетевого принтера.
//- User_ComputerSystem() - Ф., позволяющая получить Имя пользователя, зарегистрировавшегося на лок./уд. компьютере.
//- GET_ComputerName_UserName_UserDomain() - Ф., позволяющая получить локальные имена: Компьютера, Пользователя, Домена.
//- Computer_UserList() - Ф., позволяющая получить список учётных записей на лок./уд. компьютере.
//- Computer_GroupList() - Ф., позволяющая получить список групп пользователей на лок./уд. компьютере.
//- Computer_GroupUsersList() - Ф., позволяющая получить список групп и их пользователей на лок./уд. компьютере.
//- Computer_BuildINAdministrator() - Ф., позволяющая получить данные встроенной учетной записи Администратора на лок./уд. компьютере.
//- Computer_MAC_IP() - Ф., позволяющая получить данные MAC-Адрес, IP-Адрес лок./уд. компьютера.
//- NetworkNeighborhood() - Ф. получения информации о сетевом окружении.
//- Computer_PING() - Ф., позволяющая невизуально "пропинговать" удаленный компьютер.
//- Computer_SystemService() - Ф., позволяющая получить информацию о службах на лок./уд. компьютере.
//- Computer_SystemProcess() - Ф., позволяющая получить информацию о процессах на лок./уд. компьютере.
//- Computer_KillProccess() - Ф., позволяющая завершить некий процесс на лок./уд. компьютере.
//- Computer_EventsList() - Ф., позволяющая получить список событий за период из журналов System/Application лок./уд. компьютера.
//- Computer_ServerSession() - Ф., позволяющая получить информацию об открытых сессиях на сервере (локальный/удаленный компьютер).
//- Computer_Terminal() - Ф., позволяющая получить информацию о терминальных сессиях на сервере (локальный/удаленный компьютер).
//- Computer_ServerConnection() - Ф., позволяющая получить информацию об установленных подключениях к серверу (лок./уд. компьютер).
//- Computer_RebootShutdown() - Ф., позволяющая произвести завершение сеанса/перезагрузку/выключение лок./уд. компьютера.

//*
// Windows Management Instrumentation - Инструментарий управления Windows:
//
// Для выполнения следующих действий необходимы права Администратора Windows.
//
// Перед применением функций, испоьзующих WMI на локальном/удаленном компьютере
// необходимо изменить и проверить настройки Windows:
// (выполняется локально на каждом компьютере)
//
// 1. Состояние службы Windows Management Instrumentation (WMI):
//    
//    Имя Службы: "Инструментарий управления Windows" 
//    Запуск: "Автоматически".
//
// 2. Разрешение в брандмауэре Windows:
//
//    ОБЯЗАТЕЛЬНО:
//
//    Общий доступ к файлам и принтерам:
//    Если используется брандмауэр Windows,то он автоматически открывает порты, 
//    необходимые для предоставления общего доступа к файлам и принтерам, после включения обнаружения сети.
//
//    Разрешение для PING:
//
//    Вкладка "Дополнительные параметры - ICMP":
//    Разрешить запрос входящего эха.
//
//    Разрешить "Удаленное управление Windows":
//    (Становится доступным "Сервер RPC").
//
//    Windows XP:
//    Из комендной строки:
//    netsh firewall set service type = REMOTEADMIN mode = ENABLE scope = SUBNET
//
//    Разрешить "Инструментарий управления Windows (WMI)":
//    (Становится доступным "Сервер RPC").
//
//    Windows 7: 
//    Предпочтительный способ:
//    Включить в оснастке брандмауэра исключения для "Инструментарий управления Windows (WMI)".
//    ИЛИ
//    Из комендной строки:
//    netsh advfirewall firewall set rule group="Инструментарий управления Windows (WMI)" new enable=Yes
//
//    Использование WMI на Windows 2003:
//    Например: функции Computer_Programs_Product()  см. 1С и WSH и WMI. ОТ ТЕОРИИ К ПРАКТИКЕ. Часть III.
//    Функция, позволяющая получить информацию об установленных программах локальном/удаленном компьютере.
//
//    При запуске на  на компьютере под управлением Windows Server 2003 возможна ошибка чтения данных,
//    т.к. поставщик объекта Win32_Product по умолчанию в Windows Server 2003 не устаналивается.
//    Установка:
//    Панель управления - Установка и уделение программ - Установка компонентов Windows - Средства наблюдения и управления:
//    Компонента: "Поставщик установщика Windows через WMI".
//
//    ВОЗМОЖНО:
//
//    Разрешить удаленное управление (TCP 135, 445):
//
//    Windows XP: 
//    Открыть порт TCP 135 для локальной подсети.
//    Открытие порта TCP 445:
//    Если разрешено "Совместное использование файлов и принтеров", то 
//    Открывать порт 445 не нужно, иначе - открыть.
//
//    Windows 7:
//    Предпочтительный способ:
//    Включить в оснастке брандмауэра исключения для "Удаленное управление Windows".
//    ИЛИ
//    Из комендной строки:
//    netsh advfirewall firewall set rule group="Удаленное управление Windows" new enable=Yes
//
// 3. Синхронизировать время на компьютерах.
//
// 4. Проверка функционирования доступа к WMI на локальном/удаленном компьютере:
//
//    WMIC = WMI командной строки (WMIC, WMI command-line).
//    Упрощенный интерфейс командной строки для работы с WMI.
//
//    Командный файл, следующего содержания:
//
//    rem Запрос: имя ОС сервера c помощью команды wmic:
//    wmic /node:"%1" os get name
//
//    Где:
//    %1 - Имя локального/удаленного компьютера.
//*/

// Функция, позволяющая получить информацию об установленной Windows на локальном/удаленном компьютере.
// Параметры:
//    Computer - Имя компьютера.
// Возвращаемое значение:
//    ТаблицаЗначений.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//
Функция Computer_WindowsInfo(Computer = ".")
    Перем WINInfo, WINInfoOS;
    Перем WinMGMT, Win32_OperatingSystem, OperatingSystem;
    
    WINInfo = Новый ТаблицаЗначений;
    WINInfo.Колонки.Добавить("BootDevice");
    WINInfo.Колонки.Добавить("BuildNumber");
    WINInfo.Колонки.Добавить("BuildType");
    WINInfo.Колонки.Добавить("Caption");
    WINInfo.Колонки.Добавить("CodeSet");
    WINInfo.Колонки.Добавить("CountryCode");
    WINInfo.Колонки.Добавить("CreationClassName");
    WINInfo.Колонки.Добавить("CSCreationClassName");
    WINInfo.Колонки.Добавить("CSDVersion");
    WINInfo.Колонки.Добавить("CSName");
    WINInfo.Колонки.Добавить("CurrentTimeZone");
    WINInfo.Колонки.Добавить("DataExecutionPrevention_32BitApplications");
    WINInfo.Колонки.Добавить("DataExecutionPrevention_Available");
    WINInfo.Колонки.Добавить("DataExecutionPrevention_Drivers");
    WINInfo.Колонки.Добавить("DataExecutionPrevention_SupportPolicy");
    WINInfo.Колонки.Добавить("Debug");
    WINInfo.Колонки.Добавить("Description");
    WINInfo.Колонки.Добавить("Distributed");
    WINInfo.Колонки.Добавить("EncryptionLevel");
    WINInfo.Колонки.Добавить("ForegroundApplicationBoost");
    WINInfo.Колонки.Добавить("FreePhysicalMemory");
    WINInfo.Колонки.Добавить("FreeSpaceInPagingFiles");
    WINInfo.Колонки.Добавить("FreeVirtualMemory");
    WINInfo.Колонки.Добавить("InstallDate");
    WINInfo.Колонки.Добавить("LargeSystemCache");
    WINInfo.Колонки.Добавить("LastBootUpTime");
    WINInfo.Колонки.Добавить("LocalDateTime");
    WINInfo.Колонки.Добавить("Locale");
    WINInfo.Колонки.Добавить("Manufacturer");
    WINInfo.Колонки.Добавить("MaxNumberOfProcesses");
    WINInfo.Колонки.Добавить("MaxProcessMemorySize");
    WINInfo.Колонки.Добавить("MUILanguages");
    WINInfo.Колонки.Добавить("Name");
    WINInfo.Колонки.Добавить("NumberOfLicensedUsers");
    WINInfo.Колонки.Добавить("NumberOfProcesses");
    WINInfo.Колонки.Добавить("NumberOfUsers");
    WINInfo.Колонки.Добавить("OperatingSystemSKU");
    WINInfo.Колонки.Добавить("Organization");
    WINInfo.Колонки.Добавить("OSArchitecture");
    WINInfo.Колонки.Добавить("OSLanguage");
    WINInfo.Колонки.Добавить("OSProductSuite");
    WINInfo.Колонки.Добавить("OSType");
    WINInfo.Колонки.Добавить("OtherTypeDescription");
    WINInfo.Колонки.Добавить("PAEEnabled");
    WINInfo.Колонки.Добавить("PlusProductID");
    WINInfo.Колонки.Добавить("PlusVersionNumber");
    WINInfo.Колонки.Добавить("Primary");
    WINInfo.Колонки.Добавить("ProductType");
    WINInfo.Колонки.Добавить("RegisteredUser");
    WINInfo.Колонки.Добавить("SerialNumber");
    WINInfo.Колонки.Добавить("ServicePackMajorVersion");
    WINInfo.Колонки.Добавить("ServicePackMinorVersion");
    WINInfo.Колонки.Добавить("SizeStoredInPagingFiles");
    WINInfo.Колонки.Добавить("Status");
    WINInfo.Колонки.Добавить("SuiteMask");
    WINInfo.Колонки.Добавить("SystemDevice");
    WINInfo.Колонки.Добавить("SystemDirectory");
    WINInfo.Колонки.Добавить("SystemDrive");
    WINInfo.Колонки.Добавить("TotalSwapSpaceSize");
    WINInfo.Колонки.Добавить("TotalVirtualMemorySize");
    WINInfo.Колонки.Добавить("TotalVisibleMemorySize");
    WINInfo.Колонки.Добавить("Version");
    WINInfo.Колонки.Добавить("WindowsDirectory");
    
    Попытка
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2"); 
        Win32_OperatingSystem = WinMGMT.ExecQuery("SELECT * FROM Win32_OperatingSystem");
    Исключение
        Возврат WINInfo;
    КонецПопытки;
    
    Для Каждого OperatingSystem ИЗ Win32_OperatingSystem Цикл
        WINInfoOS = WINInfo.Добавить();
        WINInfoOS.BootDevice = ПолучитьЗначениеВПопытке(OperatingSystem, "BootDevice");
        WINInfoOS.BuildNumber = ПолучитьЗначениеВПопытке(OperatingSystem, "BuildNumber");
        WINInfoOS.BuildType = ПолучитьЗначениеВПопытке(OperatingSystem, "BuildType");
        WINInfoOS.Caption = ПолучитьЗначениеВПопытке(OperatingSystem, "Caption");
        WINInfoOS.CodeSet = ПолучитьЗначениеВПопытке(OperatingSystem, "CodeSet");
        WINInfoOS.CountryCode = ПолучитьЗначениеВПопытке(OperatingSystem, "CountryCode");
        WINInfoOS.CreationClassName = ПолучитьЗначениеВПопытке(OperatingSystem, "CreationClassName");
        WINInfoOS.CSCreationClassName = ПолучитьЗначениеВПопытке(OperatingSystem, "CSCreationClassName");
        WINInfoOS.CSDVersion = ПолучитьЗначениеВПопытке(OperatingSystem, "CSDVersion");
        WINInfoOS.CSName = ПолучитьЗначениеВПопытке(OperatingSystem, "CSName");
        WINInfoOS.CurrentTimeZone = ПолучитьЗначениеВПопытке(OperatingSystem, "CurrentTimeZone");
        WINInfoOS.DataExecutionPrevention_32BitApplications = ПолучитьЗначениеВПопытке(OperatingSystem, "DataExecutionPrevention_32BitApplications");
        WINInfoOS.DataExecutionPrevention_Available = ПолучитьЗначениеВПопытке(OperatingSystem, "DataExecutionPrevention_Available");
        WINInfoOS.DataExecutionPrevention_Drivers = ПолучитьЗначениеВПопытке(OperatingSystem, "DataExecutionPrevention_Drivers");
        WINInfoOS.DataExecutionPrevention_SupportPolicy = ПолучитьЗначениеВПопытке(OperatingSystem, "DataExecutionPrevention_SupportPolicy");
        WINInfoOS.Debug = ПолучитьЗначениеВПопытке(OperatingSystem, "Debug");
        WINInfoOS.Description = ПолучитьЗначениеВПопытке(OperatingSystem, "Description");
        WINInfoOS.Distributed = ПолучитьЗначениеВПопытке(OperatingSystem, "Distributed");
        WINInfoOS.EncryptionLevel = ПолучитьЗначениеВПопытке(OperatingSystem, "EncryptionLevel");
        WINInfoOS.ForegroundApplicationBoost = ПолучитьЗначениеВПопытке(OperatingSystem, "ForegroundApplicationBoost");
        WINInfoOS.FreePhysicalMemory = ПолучитьЗначениеВПопытке(OperatingSystem, "FreePhysicalMemory");
        WINInfoOS.FreeSpaceInPagingFiles = ПолучитьЗначениеВПопытке(OperatingSystem, "FreeSpaceInPagingFiles");
        WINInfoOS.FreeVirtualMemory = ПолучитьЗначениеВПопытке(OperatingSystem, "FreeVirtualMemory");
        WINInfoOS.InstallDate = ПреобразоватьЗначениеВДатуВремя(ПолучитьЗначениеВПопытке(OperatingSystem, "InstallDate"));    // Дата установки Windows.
        WINInfoOS.LargeSystemCache = ПолучитьЗначениеВПопытке(OperatingSystem, "LargeSystemCache");
        WINInfoOS.LastBootUpTime = ПреобразоватьЗначениеВДатуВремя(ПолучитьЗначениеВПопытке(OperatingSystem, "LastBootUpTime"));
        WINInfoOS.LocalDateTime = ПреобразоватьЗначениеВДатуВремя(ПолучитьЗначениеВПопытке(OperatingSystem, "LocalDateTime"));
        WINInfoOS.Locale = ПолучитьЗначениеВПопытке(OperatingSystem, "Locale");
        WINInfoOS.Manufacturer = ПолучитьЗначениеВПопытке(OperatingSystem, "Manufacturer");
        WINInfoOS.MaxNumberOfProcesses = ПолучитьЗначениеВПопытке(OperatingSystem, "MaxNumberOfProcesses");
        WINInfoOS.MaxProcessMemorySize = ПреобразоватьЗначениеВЧисло(ПолучитьЗначениеВПопытке(OperatingSystem, "MaxProcessMemorySize"));
        MUILanguagesARRAY = ПолучитьЗначениеВПопытке(OperatingSystem, "MUILanguages");
        MUILanguages = Неопределено;
        Попытка
            Для Каждого ит ИЗ MUILanguagesARRAY Цикл
                MUILanguages = ит;
            КонецЦикла;
        Исключение
        КонецПопытки;
        WINInfoOS.MUILanguages = MUILanguages;
        WINInfoOS.Name = ПолучитьЗначениеВПопытке(OperatingSystem, "Name");
        WINInfoOS.NumberOfLicensedUsers = ПолучитьЗначениеВПопытке(OperatingSystem, "NumberOfLicensedUsers");
        WINInfoOS.NumberOfProcesses = ПолучитьЗначениеВПопытке(OperatingSystem, "NumberOfProcesses");
        WINInfoOS.NumberOfUsers = ПолучитьЗначениеВПопытке(OperatingSystem, "NumberOfUsers");
        WINInfoOS.OperatingSystemSKU = ПолучитьЗначениеВПопытке(OperatingSystem, "OperatingSystemSKU");
        WINInfoOS.Organization = ПолучитьЗначениеВПопытке(OperatingSystem, "Organization");
        WINInfoOS.OSArchitecture = ПолучитьЗначениеВПопытке(OperatingSystem, "OSArchitecture");
        WINInfoOS.OSLanguage = ПолучитьЗначениеВПопытке(OperatingSystem, "OSLanguage");
        WINInfoOS.OSProductSuite = ПолучитьЗначениеВПопытке(OperatingSystem, "OSProductSuite");
        WINInfoOS.OSType = ПолучитьЗначениеВПопытке(OperatingSystem, "OSType");
        WINInfoOS.OtherTypeDescription = ПолучитьЗначениеВПопытке(OperatingSystem, "OtherTypeDescription");
        WINInfoOS.PAEEnabled = ПолучитьЗначениеВПопытке(OperatingSystem, "PAEEnabled");
        WINInfoOS.PlusProductID = ПолучитьЗначениеВПопытке(OperatingSystem, "PlusProductID");
        WINInfoOS.PlusVersionNumber = ПолучитьЗначениеВПопытке(OperatingSystem, "PlusVersionNumber");
        WINInfoOS.Primary = ПолучитьЗначениеВПопытке(OperatingSystem, "Primary");
        WINInfoOS.ProductType = ПолучитьЗначениеВПопытке(OperatingSystem, "ProductType");
        WINInfoOS.RegisteredUser = ПолучитьЗначениеВПопытке(OperatingSystem, "RegisteredUser");
        WINInfoOS.SerialNumber = ПолучитьЗначениеВПопытке(OperatingSystem, "SerialNumber");
        WINInfoOS.ServicePackMajorVersion = ПолучитьЗначениеВПопытке(OperatingSystem, "ServicePackMajorVersion");
        WINInfoOS.ServicePackMinorVersion = ПолучитьЗначениеВПопытке(OperatingSystem, "ServicePackMinorVersion");
        WINInfoOS.SizeStoredInPagingFiles = ПолучитьЗначениеВПопытке(OperatingSystem, "SizeStoredInPagingFiles");
        WINInfoOS.Status = ПолучитьЗначениеВПопытке(OperatingSystem, "Status");
        WINInfoOS.SuiteMask = ПолучитьЗначениеВПопытке(OperatingSystem, "SuiteMask");
        WINInfoOS.SystemDevice = ПолучитьЗначениеВПопытке(OperatingSystem, "SystemDevice");
        WINInfoOS.SystemDirectory = ПолучитьЗначениеВПопытке(OperatingSystem, "SystemDirectory");
        WINInfoOS.SystemDrive = ПолучитьЗначениеВПопытке(OperatingSystem, "SystemDrive");
        WINInfoOS.TotalSwapSpaceSize = ПреобразоватьЗначениеВЧисло(ПолучитьЗначениеВПопытке(OperatingSystem, "TotalSwapSpaceSize"));
        WINInfoOS.TotalVirtualMemorySize = ПреобразоватьЗначениеВЧисло(ПолучитьЗначениеВПопытке(OperatingSystem, "TotalVirtualMemorySize"));
        WINInfoOS.TotalVisibleMemorySize = ПреобразоватьЗначениеВЧисло(ПолучитьЗначениеВПопытке(OperatingSystem, "TotalVisibleMemorySize"));
        WINInfoOS.Version = ПолучитьЗначениеВПопытке(OperatingSystem, "Version");
        WINInfoOS.WindowsDirectory = ПолучитьЗначениеВПопытке(OperatingSystem, "WindowsDirectory");
    КонецЦикла;

    Возврат WINInfo;
    
КонецФункции

Функция ПолучитьЗначениеВПопытке(хОбъект, хРеквизит)
    Попытка
        Возврат хОбъект[хРеквизит];
    Исключение
        Возврат Неопределено;
    КонецПопытки;
    Возврат Неопределено;
КонецФункции

Функция ПреобразоватьЗначениеВДатуВремя(Значение)
    Попытка
        Возврат Дата(Лев(Значение,14));
    Исключение
        Возврат Дата("00010101");
    КонецПопытки;
    Возврат Дата("00010101");
КонецФункции

Функция ПреобразоватьЗначениеВЧисло(Значение)
    Попытка
        Возврат Число(Значение);
    Исключение
        Возврат 0;
    КонецПопытки;
    Возврат 0;
КонецФункции

// Процедура Имитация нажатия клавиш Ctrl+Shift+Z для закрытия окна сообщения типа "Контрольная точка №:...",
// сформированного в другой процедуре.

Процедура SendKeys(KEYS_ENG = "^+z", KEYS_RUS = "^+я")
    
    Попытка
        WshShell = Новый COMОбъект("Wscript.Shell");
        WshShell.SendKeys(KEYS_ENG);    // для случая, если текущей является английская раскладка клавиатуры.
        WshShell.SendKeys(KEYS_RUS);    // для случая, если текущей является русская раскладка клавиатуры.
        
        // SendKeys(String) - имитируется нажатие клавиши или последовательности клавиш, указанных в параметре String.
        // В качестве параметра можно указывать как алфавитно-цифровые символы, так и символы специальных клавиш, например:
        // "Enter", "Tab", "F1", "Alt", "Shift", "Ctrl" и т.д. 
        // Для указания клавиш "Alt", "Shift", "Ctrl" существуют специальные коды:
        // "Shift" - +;
        // "Ctrl" - ^;
        // "Alt" - %.
        // Если возникнет необходимость передать специальные символы именно как символы, а не команды, 
        // нужно заключать их в фигурные скобки, например {+}.   
    Исключение
    КонецПопытки;

КонецПроцедуры

// Функция, возвращающая время в миллисекундах или секундах.
//

Функция ВремяВМиллисекундах()
    Попытка
        Script = Новый COMОбъект("MSScriptControl.ScriptControl");
        Script.Language = "javascript";
        Script.Timeout   = -1;
        Время = Script.Eval("var d = new Date(); d.getTime()");
    Исключение
        Время = ТекущаяДата();
    КонецПопытки;
    
    Возврат Время;
КонецФункции

// Функция задержки выполнения процесса.
//

Процедура ЗадержкаВВыполнении(ВремяОжидания)

   Попытка
      xPing = "ping -n 1 -w "+Формат(1000*ВремяОжидания, "ЧГ=0")+" 127.255.255.255";
      WshShell = Новый COMОбъект("WScript.Shell");
      WshShell.Run(xPing, 0, -1);
   Исключение
   КонецПопытки;
    
КонецПроцедуры

// Функция вызова оснастки установки системных Даты и Времени.
// Необходимы права Администратора/Опытного пользователя.
// ОС Windows.
//

Функция SetDateTime()
    
    Попытка
        ShellApplication = Новый COMОбъект("Shell.Application");
        ShellApplication.SetTime();
    Исключение
    КонецПопытки;
    
КонецФункции

// Функция вызова оснастки Панели управления.
// Пример: Установка системных Даты и Времени.
// Необходимы права Администратора/Опытного пользователя.
// ОС Windows.
//

Функция ControlPanelItem(Item = "timedate.cpl")
    
    Попытка
        ShellApplication = Новый COMОбъект("Shell.Application");
        // Открыть Панель управления:
        //ShellApplication.ControlPanelItem("");
        
        ShellApplication.ControlPanelItem(Item);
        
        // Приложения панели управления:
        // access.cpl - специальные возможности.
        // appwiz.cpl - установка и удаление программ.
        // desk.cpl - настройка экрана.
        // hdwwiz.cpl - мастер установки оборудования.
        // inetcpl.cpl - свойства обозревателя.
        // intl.cpl - язык и региональные стандарты.
        // joy.cpl - игровые устройства.
        // main.cpl - мышь.
        // mmsys.cpl - звуки и аудиоустройства.
        // ncpa.cpl - сетевые подключения.
        // nusrmgr.cpl - учётные записи пользователей.
        // odbccp32.cpl - настройка источников данных ODBC.
        // powercfg.cpl - управление электропитанием.
        // sysdm.cpl - свойства системы.
        // telephon.cpl - телефон и модем.
        // timedate.cpl - настройки времени и даты.

    Исключение
    КонецПопытки;
    
КонецФункции

// Функция, позволяющая получить Переменные окружения локального компьютера.
//

Функция SystemEnvironment()
    
    ПеременныеОкружения = Новый Структура;
    Попытка
        WshShell = Новый COMОбъект("WScript.Shell");
        WshSysEnv = WshShell.Environment("Process");

        // Имя компьютера.
        ПеременныеОкружения.Вставить("COMPUTERNAME" , WshSysEnv.Item("COMPUTERNAME"));
        // Домен Windows компьютера.
        ПеременныеОкружения.Вставить("USERDOMAIN" , WshSysEnv.Item("USERDOMAIN"));
        // Имя контроллера домена, использовавшегося для авторизации текущего пользователя.
        ПеременныеОкружения.Вставить("LOGONSERVER" , WshSysEnv.Item("LOGONSERVER"));
        // Имя активного пользовательского сеанса.
        // При локальном входе имеет значение "Console".
        // Ппри удаленном доступе имеет вид RDP-Tcp#НомерСеанса.
        ПеременныеОкружения.Вставить("SESSIONNAME" , WshSysEnv.Item("SESSIONNAME"));
        // Количество процессоров компьютера.
        ПеременныеОкружения.Вставить("NUMBER_OF_PROCESSORS" , WshSysEnv.Item("NUMBER_OF_PROCESSORS"));
        // Архитектура процессора. Возможные варианты: x86, IA64, AMD64.
        ПеременныеОкружения.Вставить("PROCESSOR_ARCHITECTURE" , WshSysEnv.Item("PROCESSOR_ARCHITECTURE"));
        // Описание процессора.
        ПеременныеОкружения.Вставить("PROCESSOR_IDENTIFIER" , WshSysEnv.Item("PROCESSOR_IDENTIFIER"));
        // Номер модели процессора.
        ПеременныеОкружения.Вставить("PROCESSOR_LEVEL" , WshSysEnv.Item("PROCESSOR_LEVEL"));
        // Ревизия процессора. 
        ПеременныеОкружения.Вставить("PROCESSOR_REVISION" , WshSysEnv.Item("PROCESSOR_REVISION"));
        // Операционная Система.
        ПеременныеОкружения.Вставить("OS" , WshSysEnv.Item("OS"));
        // Каталог, в котором установлена Windows.
        ПеременныеОкружения.Вставить("WINDIR" , WshSysEnv.Item("WINDIR"));
        // Диск, на котором расположен корневой каталог Windows.
        ПеременныеОкружения.Вставить("SYSTEMDRIVE" , WshSysEnv.Item("SYSTEMDRIVE"));
        // Путь к корневому каталогу Windows.
        ПеременныеОкружения.Вставить("SYSTEMROOT" , WshSysEnv.Item("SYSTEMROOT"));
        // Каталог "Common Files" (обычно %ProgramFiles%\Common Files).
        ПеременныеОкружения.Вставить("COMMONPROGRAMFILES" , WshSysEnv.Item("COMMONPROGRAMFILES"));
        // Каталог "Common Files" в Program Files (x86).
        // Для 64-разрядной ОС (обычно %ProgramFiles(x86)%\Common Files).
        ПеременныеОкружения.Вставить("COMMONPROGRAMFILESx86" , WshSysEnv.Item("COMMONPROGRAMFILES(x86)"));
        // Командный интерпретатор Windows.
        ПеременныеОкружения.Вставить("COMSPEC" , WshSysEnv.Item("COMSPEC"));
        // Путь поиска исполняемых файлов.
        ПеременныеОкружения.Вставить("PATH" , WshSysEnv.Item("PATH"));
        // Каталог временных файлов Windows TEMP.
        ПеременныеОкружения.Вставить("TEMP" , WshSysEnv.Item("TEMP"));
        // Каталог временных файлов Windows TMP.
        ПеременныеОкружения.Вставить("TMP" , WshSysEnv.Item("TMP"));
        // В Windows 7 возвращает путь к каталогу C:\Users\Public.
        ПеременныеОкружения.Вставить("PUBLIC" , WshSysEnv.Item("PUBLIC"));
        // Каталог общих для всех пользователей документов и настроек.
        ПеременныеОкружения.Вставить("ALLUSERSPROFILE" , WshSysEnv.Item("ALLUSERSPROFILE"));
         // Имя пользователя Windows.
        ПеременныеОкружения.Вставить("USERNAME" , WshSysEnv.Item("USERNAME"));
        // Путь к профилю текущего пользователя Windows.
        ПеременныеОкружения.Вставить("USERPROFILE" , WshSysEnv.Item("USERPROFILE"));
        // Имя диска локальной рабочей станции, связанного с основным каталогом пользователя.
        ПеременныеОкружения.Вставить("HOMEDRIVE" , WshSysEnv.Item("HOMEDRIVE"));
        // Полный путь к основному каталогу пользователя основании основного каталога.
        ПеременныеОкружения.Вставить("HOMEPATH" , WshSysEnv.Item("HOMEPATH"));
        // Сетевой путь к общему основному каталогу пользователя на основании основного каталога.
        ПеременныеОкружения.Вставить("HOMESHARE" , WshSysEnv.Item("HOMESHARE"));
    Исключение
    КонецПопытки;
    
    Возврат ПеременныеОкружения;
    
КонецФункции

// Функция, позволяющая информацию о материнской плате локального/удаленного компьютера.
// Параметры:
//    Computer - Имя компьютера.
// Возвращаемое значение:
//    Струтура:
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//

Функция Computer_Motherboard(Computer = ".")
    
    MotherboardInfo = Новый Структура("Height,Manufacturer,Model,Name,PartNumber,Product,SerialNumber,Version,Width");
    
    Попытка
        
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2");
        Win32_BaseBoard = WinMGMT.ExecQuery("SELECT * FROM Win32_BaseBoard");
        //Win32_BaseBoard = WinMGMT.ExecQuery("SELECT * FROM Win32_MotherboardDevice");
        
        Для Каждого BaseBoard ИЗ Win32_BaseBoard Цикл
            MotherboardInfo.Height = BaseBoard.Height;
            MotherboardInfo.Manufacturer = BaseBoard.Manufacturer;
            MotherboardInfo.Model = BaseBoard.Model;
            MotherboardInfo.Name = BaseBoard.Name;
            MotherboardInfo.Product = BaseBoard.Product;
            MotherboardInfo.SerialNumber = BaseBoard.SerialNumber;
            MotherboardInfo.Version = BaseBoard.Version;
            MotherboardInfo.Width = BaseBoard.Width;
        КонецЦикла;
        
    Исключение
    КонецПопытки;
    
    Возврат MotherboardInfo;
    
КонецФункции

// Функция, позволяющая информацию о BIOS локального/удаленного компьютера.
// Параметры:
//    Computer - Имя компьютера.
// Возвращаемое значение:
//    Струтура:
// Manufacturer, Name, SMBIOSBIOSVersion, ReleaseDate, Version, SerialNumber.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//

Функция Computer_BIOS(Computer = ".")
    
    BIOSInfo = Новый Структура("Manufacturer,Name,SMBIOSBIOSVersion,ReleaseDate,Version,SerialNumber");
    
    Попытка
        
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2"); 
        PrimaryBIOS = WinMGMT.ExecQuery("Select * from Win32_BIOS where PrimaryBIOS = true");
        
        Для Каждого BIOS ИЗ PrimaryBIOS Цикл
            BIOSInfo.Manufacturer = BIOS.Manufacturer;
            BIOSInfo.Name = BIOS.Name;
            BIOSInfo.SMBIOSBIOSVersion = BIOS.SMBIOSBIOSVersion;
            BIOSInfo.ReleaseDate = Дата(Лев(BIOS.ReleaseDate,8));
            BIOSInfo.Version = BIOS.Version;
            BIOSInfo.SerialNumber = BIOS.SerialNumber;
        КонецЦикла;
        
    Исключение
    КонецПопытки;
    
    Возврат BIOSInfo;
    
КонецФункции

// Функция, позволяющая получить информацию о процессоре(ах) на локальном/удаленном компьютере.
// Параметры:
//    Computer - Имя компьютера.
// Возвращаемое значение:
//    ТаблицаЗначений.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//

Функция Computer_Processor(Computer = ".")
    
    Win32_ProcessorInfo = Новый ТаблицаЗначений;
    Win32_ProcessorInfo.Колонки.Добавить("AddressWidth");
    Win32_ProcessorInfo.Колонки.Добавить("Architecture");
    Win32_ProcessorInfo.Колонки.Добавить("Availability");
    Win32_ProcessorInfo.Колонки.Добавить("Caption");
    Win32_ProcessorInfo.Колонки.Добавить("ConfigManagerErrorCode");
    Win32_ProcessorInfo.Колонки.Добавить("ConfigManagerUserConfig");
    Win32_ProcessorInfo.Колонки.Добавить("CpuStatus");
    Win32_ProcessorInfo.Колонки.Добавить("CreationClassName");
    Win32_ProcessorInfo.Колонки.Добавить("CurrentClockSpeed");
    Win32_ProcessorInfo.Колонки.Добавить("CurrentVoltage");
    Win32_ProcessorInfo.Колонки.Добавить("DataWidth");
    Win32_ProcessorInfo.Колонки.Добавить("Description");
    Win32_ProcessorInfo.Колонки.Добавить("DeviceID");
    Win32_ProcessorInfo.Колонки.Добавить("ErrorCleared");
    Win32_ProcessorInfo.Колонки.Добавить("ErrorDescription");
    Win32_ProcessorInfo.Колонки.Добавить("ExtClock");
    Win32_ProcessorInfo.Колонки.Добавить("Family");
    Win32_ProcessorInfo.Колонки.Добавить("InstallDate");
    Win32_ProcessorInfo.Колонки.Добавить("L2CacheSize");
    Win32_ProcessorInfo.Колонки.Добавить("L2CacheSpeed");
    Win32_ProcessorInfo.Колонки.Добавить("L3CacheSize");
    Win32_ProcessorInfo.Колонки.Добавить("L3CacheSpeed");
    Win32_ProcessorInfo.Колонки.Добавить("LastErrorCode");
    Win32_ProcessorInfo.Колонки.Добавить("Level");
    Win32_ProcessorInfo.Колонки.Добавить("LoadPercentage");
    Win32_ProcessorInfo.Колонки.Добавить("Manufacturer");
    Win32_ProcessorInfo.Колонки.Добавить("MaxClockSpeed");
    Win32_ProcessorInfo.Колонки.Добавить("Name");
    Win32_ProcessorInfo.Колонки.Добавить("NumberOfCores");
    Win32_ProcessorInfo.Колонки.Добавить("NumberOfLogicalProcessors");
    Win32_ProcessorInfo.Колонки.Добавить("OtherFamilyDescription");
    Win32_ProcessorInfo.Колонки.Добавить("PNPDeviceID");
    Win32_ProcessorInfo.Колонки.Добавить("PowerManagementCapabilities");
    Win32_ProcessorInfo.Колонки.Добавить("PowerManagementSupported");
    Win32_ProcessorInfo.Колонки.Добавить("ProcessorId");
    Win32_ProcessorInfo.Колонки.Добавить("ProcessorType");
    Win32_ProcessorInfo.Колонки.Добавить("Revision");
    Win32_ProcessorInfo.Колонки.Добавить("Role");
    Win32_ProcessorInfo.Колонки.Добавить("SocketDesignation");
    Win32_ProcessorInfo.Колонки.Добавить("Status");
    Win32_ProcessorInfo.Колонки.Добавить("StatusInfo");
    Win32_ProcessorInfo.Колонки.Добавить("Stepping");
    Win32_ProcessorInfo.Колонки.Добавить("SystemCreationClassName");
    Win32_ProcessorInfo.Колонки.Добавить("SystemName");
    Win32_ProcessorInfo.Колонки.Добавить("UniqueId");
    Win32_ProcessorInfo.Колонки.Добавить("UpgradeMethod");
    Win32_ProcessorInfo.Колонки.Добавить("Version");
    Win32_ProcessorInfo.Колонки.Добавить("VoltageCaps");
    
    Попытка
        
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2");
        Win32_Processor = WinMGMT.ExecQuery("SELECT * FROM Win32_Processor");
        
        Для Каждого Processor ИЗ Win32_Processor Цикл
            ProcessorInfo = Win32_ProcessorInfo.Добавить();
            ProcessorInfo.AddressWidth = Processor.AddressWidth;
            ProcessorInfo.Architecture = Processor.Architecture;
            ProcessorInfo.Availability = Processor.Availability;
            ProcessorInfo.Caption = Processor.Caption;
            ProcessorInfo.ConfigManagerErrorCode = Processor.ConfigManagerErrorCode;
            ProcessorInfo.ConfigManagerUserConfig = Processor.ConfigManagerUserConfig;
            ProcessorInfo.CpuStatus = Processor.CpuStatus;
            ProcessorInfo.CreationClassName = Processor.CreationClassName;
            ProcessorInfo.CurrentClockSpeed = Processor.CurrentClockSpeed;
            ProcessorInfo.CurrentVoltage = Processor.CurrentVoltage;
            ProcessorInfo.DataWidth = Processor.DataWidth;
            ProcessorInfo.Description = СокрЛП(Processor.Description);
            ProcessorInfo.DeviceID = Processor.DeviceID;
            ProcessorInfo.ErrorCleared = Processor.ErrorCleared;
            ProcessorInfo.ErrorDescription = Processor.ErrorDescription;
            ProcessorInfo.ExtClock = Processor.ExtClock;
            ProcessorInfo.Family = Processor.Family;
            ProcessorInfo.InstallDate = Processor.InstallDate;
            ProcessorInfo.L2CacheSize = Processor.L2CacheSize;
            ProcessorInfo.L2CacheSpeed = Processor.L2CacheSpeed;
            Попытка
                ProcessorInfo.L3CacheSize = Processor.L3CacheSize;
                ProcessorInfo.L3CacheSpeed = Processor.L3CacheSpeed;
            Исключение
            КонецПопытки;
            ProcessorInfo.LastErrorCode = Processor.LastErrorCode;
            ProcessorInfo.Level = Processor.Level;
            ProcessorInfo.LoadPercentage = Processor.LoadPercentage;
            ProcessorInfo.Manufacturer = Processor.Manufacturer;
            ProcessorInfo.MaxClockSpeed = Processor.MaxClockSpeed;
            ProcessorInfo.Name = СокрЛП(Processor.Name);
            Попытка
                ProcessorInfo.NumberOfCores = Processor.NumberOfCores;
                ProcessorInfo.NumberOfLogicalProcessors = Processor.NumberOfLogicalProcessors;
            Исключение
            КонецПопытки;
            ProcessorInfo.OtherFamilyDescription = Processor.OtherFamilyDescription;
            ProcessorInfo.PNPDeviceID = Processor.PNPDeviceID;
            ProcessorInfo.PowerManagementCapabilities = Processor.PowerManagementCapabilities;
            ProcessorInfo.PowerManagementSupported = Processor.PowerManagementSupported;
            ProcessorInfo.ProcessorId = Processor.ProcessorId;
            ProcessorInfo.ProcessorType = Processor.ProcessorType;
            ProcessorInfo.Revision = Processor.Revision;
            ProcessorInfo.Role = Processor.Role;
            ProcessorInfo.SocketDesignation = Processor.SocketDesignation;
            ProcessorInfo.Status = Processor.Status;
            ProcessorInfo.StatusInfo = Processor.StatusInfo;
            ProcessorInfo.Stepping = Processor.Stepping;
            ProcessorInfo.SystemCreationClassName = Processor.SystemCreationClassName;
            ProcessorInfo.SystemName = Processor.SystemName;
            ProcessorInfo.UniqueId = Processor.UniqueId;
            ProcessorInfo.UpgradeMethod = Processor.UpgradeMethod;
            ProcessorInfo.Version = Processor.Version;
            ProcessorInfo.VoltageCaps = Processor.VoltageCaps;
        КонецЦикла;
        
    Исключение
    КонецПопытки;

    Возврат Win32_ProcessorInfo;
    
КонецФункции

// Функция, позволяющая получить информацию о памяти на локальном/удаленном компьютере.
// Параметры:
//    Computer - Имя компьютера.
// Возвращаемое значение:
//    Структура.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//

Функция Computer_RAM(Computer = ".")
    
    RAMInfo = Новый Структура("AvailableVirtualMemory,Caption,Description,Name,SettingID,TotalPageFileSpace,TotalPhysicalMemory,TotalVirtualMemory");
    
    Попытка
        
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2");
        Win32_LogicalMemoryConfiguration = WinMGMT.ExecQuery("SELECT * FROM Win32_LogicalMemoryConfiguration");
        
        Для Каждого LogicalMemoryConfiguration ИЗ Win32_LogicalMemoryConfiguration Цикл
            RAMInfo.AvailableVirtualMemory = LogicalMemoryConfiguration.AvailableVirtualMemory;
            RAMInfo.Caption = LogicalMemoryConfiguration.Caption;
            RAMInfo.Description = LogicalMemoryConfiguration.Description;
            RAMInfo.Name = LogicalMemoryConfiguration.Name;
            RAMInfo.SettingID = LogicalMemoryConfiguration.SettingID;
            RAMInfo.TotalPageFileSpace = LogicalMemoryConfiguration.TotalPageFileSpace;
            RAMInfo.TotalPhysicalMemory = LogicalMemoryConfiguration.TotalPhysicalMemory;
            RAMInfo.TotalVirtualMemory = LogicalMemoryConfiguration.TotalVirtualMemory;
        КонецЦикла;
        
    Исключение
    КонецПопытки;

    Возврат RAMInfo;
    
КонецФункции

// Функция, позволяющая получить информацию об объеме установленной памяти на локальном/удаленном компьютере.
// Параметры:
//    Computer - Имя компьютера.
// Возвращаемое значение:
//    Структура.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//

Функция Computer_TotalPhysicalMemory(Computer = ".")
    
    PhysicalMemoryInfo = Новый Структура;
    PhysicalMemoryInfo.Вставить("Name");
    PhysicalMemoryInfo.Вставить("TotalPhysicalMemory");
    
    Попытка
        
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2");
        Win32_TotalPhysicalMemory = WinMGMT.ExecQuery("SELECT TotalPhysicalMemory FROM Win32_ComputerSystem");
        
        Для Каждого PhysicalMemory ИЗ Win32_TotalPhysicalMemory Цикл
            PhysicalMemoryInfo.Name = PhysicalMemory.Name;
            PhysicalMemoryInfo.TotalPhysicalMemory = PhysicalMemory.TotalPhysicalMemory;
            Прервать;
        КонецЦикла;
        
    Исключение
    КонецПопытки;

    Возврат PhysicalMemoryInfo;
    
КонецФункции

 

// Функция, позволяющая получить информацию о физической памяти на локальном/удаленном компьютере.
// Параметры:
//    Computer - Имя компьютера.
// Возвращаемое значение:
//    ТаблицаЗначений.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//
Функция Computer_PhysicalMemory(Computer = ".") 
    Перем WinMGMT;
    Перем Win32_PhysicalMemory, PhysicalMemory;
    Перем PhysicalMemoryInfo, PHMemory;
    
    PhysicalMemoryInfo = Новый ТаблицаЗначений;
    PhysicalMemoryInfo.Колонки.Добавить("BankLabel");
    PhysicalMemoryInfo.Колонки.Добавить("Capacity");
    PhysicalMemoryInfo.Колонки.Добавить("Caption");
    PhysicalMemoryInfo.Колонки.Добавить("CreationClassName");
    PhysicalMemoryInfo.Колонки.Добавить("DataWidth");
    PhysicalMemoryInfo.Колонки.Добавить("Description");
    PhysicalMemoryInfo.Колонки.Добавить("DeviceLocator");
    PhysicalMemoryInfo.Колонки.Добавить("FormFactor");
    PhysicalMemoryInfo.Колонки.Добавить("HotSwappable");
    PhysicalMemoryInfo.Колонки.Добавить("InstallDate");
    PhysicalMemoryInfo.Колонки.Добавить("InterleaveDataDepth");
    PhysicalMemoryInfo.Колонки.Добавить("InterleavePosition");
    PhysicalMemoryInfo.Колонки.Добавить("Manufacturer");
    PhysicalMemoryInfo.Колонки.Добавить("MemoryType");
    PhysicalMemoryInfo.Колонки.Добавить("Model");
    PhysicalMemoryInfo.Колонки.Добавить("Name");
    PhysicalMemoryInfo.Колонки.Добавить("OtherIdentifyingInfo");
    PhysicalMemoryInfo.Колонки.Добавить("PartNumber");
    PhysicalMemoryInfo.Колонки.Добавить("PositionInRow");
    PhysicalMemoryInfo.Колонки.Добавить("PoweredOn");
    PhysicalMemoryInfo.Колонки.Добавить("Removable");
    PhysicalMemoryInfo.Колонки.Добавить("Replaceable");
    PhysicalMemoryInfo.Колонки.Добавить("SerialNumber");
    PhysicalMemoryInfo.Колонки.Добавить("SKU");
    PhysicalMemoryInfo.Колонки.Добавить("Speed");
    PhysicalMemoryInfo.Колонки.Добавить("Status");
    PhysicalMemoryInfo.Колонки.Добавить("Tag");
    PhysicalMemoryInfo.Колонки.Добавить("TotalWidth");
    PhysicalMemoryInfo.Колонки.Добавить("TypeDetail");
    PhysicalMemoryInfo.Колонки.Добавить("Version");
    
    Попытка
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2");
        Win32_PhysicalMemory = WinMGMT.ExecQuery("SELECT * FROM Win32_PhysicalMemory");
    Исключение
        Возврат PhysicalMemoryInfo;
    КонецПопытки;
    
    Для Каждого PhysicalMemory ИЗ Win32_PhysicalMemory Цикл
        PHMemory = PhysicalMemoryInfo.Добавить();
        PHMemory.BankLabel = ПолучитьЗначениеВПопытке(PhysicalMemory, "BankLabel");
        PHMemory.Capacity = ПреобразоватьЗначениеВЧисло(ПолучитьЗначениеВПопытке(PhysicalMemory, "Capacity"));
        PHMemory.Capacity = PHMemory.Capacity/1024/1024;
        PHMemory.Caption = ПолучитьЗначениеВПопытке(PhysicalMemory, "Caption");
        PHMemory.CreationClassName = ПолучитьЗначениеВПопытке(PhysicalMemory, "CreationClassName");
        PHMemory.DataWidth = ПолучитьЗначениеВПопытке(PhysicalMemory, "DataWidth");
        PHMemory.Description = ПолучитьЗначениеВПопытке(PhysicalMemory, "Description");
        PHMemory.DeviceLocator = ПолучитьЗначениеВПопытке(PhysicalMemory, "DeviceLocator");
        PHMemory.FormFactor = ПолучитьЗначениеВПопытке(PhysicalMemory, "FormFactor");
        PHMemory.HotSwappable = ПолучитьЗначениеВПопытке(PhysicalMemory, "HotSwappable");
        PHMemory.InstallDate = ПреобразоватьЗначениеВДатуВремя(ПолучитьЗначениеВПопытке(PhysicalMemory, "InstallDate"));
        PHMemory.InterleaveDataDepth = ПолучитьЗначениеВПопытке(PhysicalMemory, "InterleaveDataDepth");
        PHMemory.InterleavePosition = ПолучитьЗначениеВПопытке(PhysicalMemory, "InterleavePosition");
        PHMemory.Manufacturer = ПолучитьЗначениеВПопытке(PhysicalMemory, "Manufacturer");
        PHMemory.MemoryType = ПолучитьЗначениеВПопытке(PhysicalMemory, "MemoryType");
        PHMemory.Model = ПолучитьЗначениеВПопытке(PhysicalMemory, "Model");
        PHMemory.Name = ПолучитьЗначениеВПопытке(PhysicalMemory, "Name");
        PHMemory.OtherIdentifyingInfo = ПолучитьЗначениеВПопытке(PhysicalMemory, "OtherIdentifyingInfo");
        PHMemory.PartNumber = ПолучитьЗначениеВПопытке(PhysicalMemory, "PartNumber");
        PHMemory.PositionInRow = ПолучитьЗначениеВПопытке(PhysicalMemory, "PositionInRow");
        PHMemory.PoweredOn = ПолучитьЗначениеВПопытке(PhysicalMemory, "PoweredOn");
        PHMemory.Removable = ПолучитьЗначениеВПопытке(PhysicalMemory, "Removable");
        PHMemory.Replaceable = ПолучитьЗначениеВПопытке(PhysicalMemory, "Replaceable");
        PHMemory.SerialNumber = ПолучитьЗначениеВПопытке(PhysicalMemory, "SerialNumber");
        PHMemory.SKU = ПолучитьЗначениеВПопытке(PhysicalMemory, "SKU");
        PHMemory.Speed = ПолучитьЗначениеВПопытке(PhysicalMemory, "Speed");
        PHMemory.Status = ПолучитьЗначениеВПопытке(PhysicalMemory, "Status");
        PHMemory.Tag = ПолучитьЗначениеВПопытке(PhysicalMemory, "Tag");
        PHMemory.TotalWidth = ПолучитьЗначениеВПопытке(PhysicalMemory, "TotalWidth");
        PHMemory.TypeDetail = ПолучитьЗначениеВПопытке(PhysicalMemory, "TypeDetail");
        PHMemory.Version = ПолучитьЗначениеВПопытке(PhysicalMemory, "Version");
    КонецЦикла;

    Возврат PhysicalMemoryInfo;
    
КонецФункции

// Функция, позволяющая получить информацию о виртуальной памяти на локальном/удаленном компьютере.
// Параметры:
//    Computer - Имя компьютера.
// Возвращаемое значение:
//    ТаблицаЗначений.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//

Функция Computer_VirtualMemory(Computer = ".")
    
    VirtualMemoryInfo = Новый ТаблицаЗначений;
    VirtualMemoryInfo.Колонки.Добавить("AllocatedBaseSize");
    VirtualMemoryInfo.Колонки.Добавить("Caption");
    VirtualMemoryInfo.Колонки.Добавить("CurrentUsage");
    VirtualMemoryInfo.Колонки.Добавить("Description");
    VirtualMemoryInfo.Колонки.Добавить("InstallDate");
    VirtualMemoryInfo.Колонки.Добавить("Name");
    VirtualMemoryInfo.Колонки.Добавить("PeakUsage");
    VirtualMemoryInfo.Колонки.Добавить("Status");
    VirtualMemoryInfo.Колонки.Добавить("TempPageFile");
    
    Попытка
        
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2");
        Win32_PageFileUsage = WinMGMT.ExecQuery("SELECT * FROM Win32_PageFileUsage");
        
        Для Каждого PageFileUsage ИЗ Win32_PageFileUsage Цикл
            PageFileUsageInfo = VirtualMemoryInfo.Добавить();
            PageFileUsageInfo.AllocatedBaseSize = PageFileUsage.AllocatedBaseSize;
            PageFileUsageInfo.Caption = PageFileUsage.Caption;
            PageFileUsageInfo.CurrentUsage = PageFileUsage.CurrentUsage;
            PageFileUsageInfo.Description = PageFileUsage.Description;
            PageFileUsageInfo.InstallDate = Дата(Лев(PageFileUsage.InstallDate,14));
            PageFileUsageInfo.Name = PageFileUsage.Name;
            PageFileUsageInfo.PeakUsage = PageFileUsage.PeakUsage;
            PageFileUsageInfo.Status = PageFileUsage.Status;
            PageFileUsageInfo.TempPageFile = PageFileUsage.TempPageFile;
        КонецЦикла;
        
    Исключение
    КонецПопытки;

    Возврат VirtualMemoryInfo;
    
КонецФункции

// Функция, позволяющая получить информацию о видео на локальном/удаленном компьютере.
// Параметры:
//    Computer - Имя компьютера.
// Возвращаемое значение:
//    ТаблицаЗначений.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//

Функция Computer_Video(Computer = ".")
    
    Win32_VideoControllerInfo = Новый ТаблицаЗначений;
    Win32_VideoControllerInfo.Колонки.Добавить("AcceleratorCapabilities");
    Win32_VideoControllerInfo.Колонки.Добавить("AdapterCompatibility");
    Win32_VideoControllerInfo.Колонки.Добавить("AdapterDACType");
    Win32_VideoControllerInfo.Колонки.Добавить("AdapterRAM");
    Win32_VideoControllerInfo.Колонки.Добавить("Availability");
    Win32_VideoControllerInfo.Колонки.Добавить("CapabilityDescriptions");
    Win32_VideoControllerInfo.Колонки.Добавить("Caption");
    Win32_VideoControllerInfo.Колонки.Добавить("ColorTableEntries");
    Win32_VideoControllerInfo.Колонки.Добавить("ConfigManagerErrorCode");
    Win32_VideoControllerInfo.Колонки.Добавить("ConfigManagerUserConfig");
    Win32_VideoControllerInfo.Колонки.Добавить("CreationClassName");
    Win32_VideoControllerInfo.Колонки.Добавить("CurrentBitsPerPixel");
    Win32_VideoControllerInfo.Колонки.Добавить("CurrentHorizontalResolution");
    Win32_VideoControllerInfo.Колонки.Добавить("CurrentNumberOfColors");
    Win32_VideoControllerInfo.Колонки.Добавить("CurrentNumberOfColumns");
    Win32_VideoControllerInfo.Колонки.Добавить("CurrentNumberOfRows");
    Win32_VideoControllerInfo.Колонки.Добавить("CurrentRefreshRate");
    Win32_VideoControllerInfo.Колонки.Добавить("CurrentScanMode");
    Win32_VideoControllerInfo.Колонки.Добавить("CurrentVerticalResolution");
    Win32_VideoControllerInfo.Колонки.Добавить("Description");
    Win32_VideoControllerInfo.Колонки.Добавить("DeviceID");
    Win32_VideoControllerInfo.Колонки.Добавить("DeviceSpecificPens");
    Win32_VideoControllerInfo.Колонки.Добавить("DitherType");
    Win32_VideoControllerInfo.Колонки.Добавить("DriverDate");
    Win32_VideoControllerInfo.Колонки.Добавить("DriverVersion");
    Win32_VideoControllerInfo.Колонки.Добавить("ErrorCleared");
    Win32_VideoControllerInfo.Колонки.Добавить("ErrorDescription");
    Win32_VideoControllerInfo.Колонки.Добавить("ICMIntent");
    Win32_VideoControllerInfo.Колонки.Добавить("ICMMethod");
    Win32_VideoControllerInfo.Колонки.Добавить("InfFilename");
    Win32_VideoControllerInfo.Колонки.Добавить("InfSection");
    Win32_VideoControllerInfo.Колонки.Добавить("InstallDate");
    Win32_VideoControllerInfo.Колонки.Добавить("InstalledDisplayDrivers");
    Win32_VideoControllerInfo.Колонки.Добавить("LastErrorCode");
    Win32_VideoControllerInfo.Колонки.Добавить("MaxMemorySupported");
    Win32_VideoControllerInfo.Колонки.Добавить("MaxNumberControlled");
    Win32_VideoControllerInfo.Колонки.Добавить("MaxRefreshRate");
    Win32_VideoControllerInfo.Колонки.Добавить("MinRefreshRate");
    Win32_VideoControllerInfo.Колонки.Добавить("Monochrome");
    Win32_VideoControllerInfo.Колонки.Добавить("Name");
    Win32_VideoControllerInfo.Колонки.Добавить("NumberOfColorPlanes");
    Win32_VideoControllerInfo.Колонки.Добавить("NumberOfVideoPages");
    Win32_VideoControllerInfo.Колонки.Добавить("PNPDeviceID");
    Win32_VideoControllerInfo.Колонки.Добавить("PowerManagementCapabilities");
    Win32_VideoControllerInfo.Колонки.Добавить("PowerManagementSupported");
    Win32_VideoControllerInfo.Колонки.Добавить("ProtocolSupported");
    Win32_VideoControllerInfo.Колонки.Добавить("ReservedSystemPaletteEntries");
    Win32_VideoControllerInfo.Колонки.Добавить("SpecificationVersion");
    Win32_VideoControllerInfo.Колонки.Добавить("Status");
    Win32_VideoControllerInfo.Колонки.Добавить("StatusInfo");
    Win32_VideoControllerInfo.Колонки.Добавить("SystemCreationClassName");
    Win32_VideoControllerInfo.Колонки.Добавить("SystemName");
    Win32_VideoControllerInfo.Колонки.Добавить("SystemPaletteEntries");
    Win32_VideoControllerInfo.Колонки.Добавить("TimeOfLastReset");
    Win32_VideoControllerInfo.Колонки.Добавить("VideoArchitecture");
    Win32_VideoControllerInfo.Колонки.Добавить("VideoMemoryType");
    Win32_VideoControllerInfo.Колонки.Добавить("VideoMode");
    Win32_VideoControllerInfo.Колонки.Добавить("VideoModeDescription");
    Win32_VideoControllerInfo.Колонки.Добавить("VideoProcessor");
    
    Попытка
        
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2");
        Win32_VideoController = WinMGMT.ExecQuery("SELECT * FROM Win32_VideoController");
        
        Для Каждого VideoController ИЗ Win32_VideoController Цикл
            VideoControllerInfo = Win32_VideoControllerInfo.Добавить();
            VideoControllerInfo.AcceleratorCapabilities = VideoController.AcceleratorCapabilities;
            VideoControllerInfo.AdapterCompatibility = VideoController.AdapterCompatibility;
            VideoControllerInfo.AdapterDACType = VideoController.AdapterDACType;
            VideoControllerInfo.AdapterRAM = VideoController.AdapterRAM;
            VideoControllerInfo.Availability = VideoController.Availability;
            VideoControllerInfo.CapabilityDescriptions = VideoController.CapabilityDescriptions;
            VideoControllerInfo.Caption = VideoController.Caption;
            VideoControllerInfo.ColorTableEntries = VideoController.ColorTableEntries;
            VideoControllerInfo.ConfigManagerErrorCode = VideoController.ConfigManagerErrorCode;
            VideoControllerInfo.ConfigManagerUserConfig = VideoController.ConfigManagerUserConfig;
            VideoControllerInfo.CreationClassName = VideoController.CreationClassName;
            VideoControllerInfo.CurrentBitsPerPixel = VideoController.CurrentBitsPerPixel;
            VideoControllerInfo.CurrentHorizontalResolution = VideoController.CurrentHorizontalResolution;
            VideoControllerInfo.CurrentNumberOfColors = VideoController.CurrentNumberOfColors;
            VideoControllerInfo.CurrentNumberOfColumns = VideoController.CurrentNumberOfColumns;
            VideoControllerInfo.CurrentNumberOfRows = VideoController.CurrentNumberOfRows;
            VideoControllerInfo.CurrentRefreshRate = VideoController.CurrentRefreshRate;
            VideoControllerInfo.CurrentScanMode = VideoController.CurrentScanMode;
            VideoControllerInfo.CurrentVerticalResolution = VideoController.CurrentVerticalResolution;
            VideoControllerInfo.Description = VideoController.Description;
            VideoControllerInfo.DeviceID = VideoController.DeviceID;
            VideoControllerInfo.DeviceSpecificPens = VideoController.DeviceSpecificPens;
            VideoControllerInfo.DitherType = VideoController.DitherType;
            VideoControllerInfo.DriverDate = VideoController.DriverDate;
            VideoControllerInfo.DriverVersion = VideoController.DriverVersion;
            VideoControllerInfo.ErrorCleared = VideoController.ErrorCleared;
            VideoControllerInfo.ErrorDescription = VideoController.ErrorDescription;
            VideoControllerInfo.ICMIntent = VideoController.ICMIntent;
            VideoControllerInfo.ICMMethod = VideoController.ICMMethod;
            VideoControllerInfo.InfFilename = VideoController.InfFilename;
            VideoControllerInfo.InfSection = VideoController.InfSection;
            VideoControllerInfo.InstallDate = VideoController.InstallDate;
            VideoControllerInfo.InstalledDisplayDrivers = VideoController.InstalledDisplayDrivers;
            VideoControllerInfo.LastErrorCode = VideoController.LastErrorCode;
            VideoControllerInfo.MaxMemorySupported = VideoController.MaxMemorySupported;
            VideoControllerInfo.MaxNumberControlled = VideoController.MaxNumberControlled;
            VideoControllerInfo.MaxRefreshRate = VideoController.MaxRefreshRate;
            VideoControllerInfo.MinRefreshRate = VideoController.MinRefreshRate;
            VideoControllerInfo.Monochrome = VideoController.Monochrome;
            VideoControllerInfo.Name = VideoController.Name;
            VideoControllerInfo.NumberOfColorPlanes = VideoController.NumberOfColorPlanes;
            VideoControllerInfo.NumberOfVideoPages = VideoController.NumberOfVideoPages;
            VideoControllerInfo.PNPDeviceID = VideoController.PNPDeviceID;
            VideoControllerInfo.PowerManagementCapabilities = VideoController.PowerManagementCapabilities;
            VideoControllerInfo.PowerManagementSupported = VideoController.PowerManagementSupported;
            VideoControllerInfo.ProtocolSupported = VideoController.ProtocolSupported;
            VideoControllerInfo.ReservedSystemPaletteEntries = VideoController.ReservedSystemPaletteEntries;
            VideoControllerInfo.SpecificationVersion = VideoController.SpecificationVersion;
            VideoControllerInfo.Status = VideoController.Status;
            VideoControllerInfo.StatusInfo = VideoController.StatusInfo;
            VideoControllerInfo.SystemCreationClassName = VideoController.SystemCreationClassName;
            VideoControllerInfo.SystemName = VideoController.SystemName;
            VideoControllerInfo.SystemPaletteEntries = VideoController.SystemPaletteEntries;
            VideoControllerInfo.TimeOfLastReset = VideoController.TimeOfLastReset;
            VideoControllerInfo.VideoArchitecture = VideoController.VideoArchitecture;
            VideoControllerInfo.VideoMemoryType = VideoController.VideoMemoryType;
            VideoControllerInfo.VideoMode = VideoController.VideoMode;
            VideoControllerInfo.VideoModeDescription = VideoController.VideoModeDescription;
            VideoControllerInfo.VideoProcessor = VideoController.VideoProcessor;
        КонецЦикла;
        
    Исключение
    КонецПопытки;

    Возврат Win32_VideoControllerInfo;
    
КонецФункции

 

// Функция, позволяющая получить информацию о мониторе(ах) на локальном/удаленном компьютере.
// Параметры:
//    Computer - Имя компьютера.
// Возвращаемое значение:
//    ТаблицаЗначений.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//
Функция Computer_Monitor(Computer = ".")
    Перем WinMGMT;
    Перем Win32_DesktopMonitor, Monitor, MonitorInfo;
    Перем Win32_DesktopMonitorInfo;
    
    Win32_DesktopMonitorInfo = Новый ТаблицаЗначений;
    Win32_DesktopMonitorInfo.Колонки.Добавить("Availability");
    Win32_DesktopMonitorInfo.Колонки.Добавить("Bandwidth");
    Win32_DesktopMonitorInfo.Колонки.Добавить("Caption");
    Win32_DesktopMonitorInfo.Колонки.Добавить("ConfigManagerErrorCode");
    Win32_DesktopMonitorInfo.Колонки.Добавить("ConfigManagerUserConfig");
    Win32_DesktopMonitorInfo.Колонки.Добавить("CreationClassName");
    Win32_DesktopMonitorInfo.Колонки.Добавить("Description");
    Win32_DesktopMonitorInfo.Колонки.Добавить("DeviceID");
    Win32_DesktopMonitorInfo.Колонки.Добавить("DisplayType");
    Win32_DesktopMonitorInfo.Колонки.Добавить("ErrorCleared");
    Win32_DesktopMonitorInfo.Колонки.Добавить("ErrorDescription");
    Win32_DesktopMonitorInfo.Колонки.Добавить("InstallDate");
    Win32_DesktopMonitorInfo.Колонки.Добавить("IsLocked");
    Win32_DesktopMonitorInfo.Колонки.Добавить("LastErrorCode");
    Win32_DesktopMonitorInfo.Колонки.Добавить("MonitorManufacturer");
    Win32_DesktopMonitorInfo.Колонки.Добавить("MonitorType");
    Win32_DesktopMonitorInfo.Колонки.Добавить("Name");
    Win32_DesktopMonitorInfo.Колонки.Добавить("PixelsPerXLogicalInch");
    Win32_DesktopMonitorInfo.Колонки.Добавить("PixelsPerYLogicalInch");
    Win32_DesktopMonitorInfo.Колонки.Добавить("PNPDeviceID");
    Win32_DesktopMonitorInfo.Колонки.Добавить("PowerManagementCapabilities");
    Win32_DesktopMonitorInfo.Колонки.Добавить("PowerManagementSupported");
    Win32_DesktopMonitorInfo.Колонки.Добавить("ScreenHeight");
    Win32_DesktopMonitorInfo.Колонки.Добавить("ScreenWidth");
    Win32_DesktopMonitorInfo.Колонки.Добавить("Status");
    Win32_DesktopMonitorInfo.Колонки.Добавить("StatusInfo");
    Win32_DesktopMonitorInfo.Колонки.Добавить("SystemCreationClassName");
    Win32_DesktopMonitorInfo.Колонки.Добавить("SystemName");

    Попытка
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2");
        Win32_DesktopMonitor = WinMGMT.ExecQuery("SELECT * FROM Win32_DesktopMonitor");
    Исключение
        Возврат Win32_DesktopMonitorInfo;
    КонецПопытки;
    
    Для Каждого Monitor ИЗ Win32_DesktopMonitor Цикл
        MonitorInfo = Win32_DesktopMonitorInfo.Добавить();
        MonitorInfo.Availability = ПолучитьЗначениеВПопытке(Monitor, "Availability");
        MonitorInfo.Bandwidth = ПолучитьЗначениеВПопытке(Monitor, "Bandwidth");
        MonitorInfo.Caption = ПолучитьЗначениеВПопытке(Monitor, "Caption");
        MonitorInfo.ConfigManagerErrorCode = ПолучитьЗначениеВПопытке(Monitor, "ConfigManagerErrorCode");
        MonitorInfo.ConfigManagerUserConfig = ПолучитьЗначениеВПопытке(Monitor, "ConfigManagerUserConfig");
        MonitorInfo.CreationClassName = ПолучитьЗначениеВПопытке(Monitor, "CreationClassName");
        MonitorInfo.Description = ПолучитьЗначениеВПопытке(Monitor, "Description");
        MonitorInfo.DeviceID = ПолучитьЗначениеВПопытке(Monitor, "DeviceID");
        MonitorInfo.DisplayType = ПолучитьЗначениеВПопытке(Monitor, "DisplayType");
        MonitorInfo.ErrorCleared = ПолучитьЗначениеВПопытке(Monitor, "ErrorCleared");
        MonitorInfo.ErrorDescription = ПолучитьЗначениеВПопытке(Monitor, "ErrorDescription");
        MonitorInfo.InstallDate = ПолучитьЗначениеВПопытке(Monitor, "InstallDate");
        MonitorInfo.IsLocked = ПолучитьЗначениеВПопытке(Monitor, "IsLocked");
        MonitorInfo.LastErrorCode = ПолучитьЗначениеВПопытке(Monitor, "LastErrorCode");
        MonitorInfo.MonitorManufacturer = ПолучитьЗначениеВПопытке(Monitor, "MonitorManufacturer");
        MonitorInfo.MonitorType = ПолучитьЗначениеВПопытке(Monitor, "MonitorType");
        MonitorInfo.Name = ПолучитьЗначениеВПопытке(Monitor, "Name");
        MonitorInfo.PixelsPerXLogicalInch = ПолучитьЗначениеВПопытке(Monitor, "PixelsPerXLogicalInch");
        MonitorInfo.PixelsPerYLogicalInch = ПолучитьЗначениеВПопытке(Monitor, "PixelsPerYLogicalInch");
        MonitorInfo.PNPDeviceID = ПолучитьЗначениеВПопытке(Monitor, "PNPDeviceID");
        MonitorInfo.PowerManagementCapabilities = ПолучитьЗначениеВПопытке(Monitor, "PowerManagementCapabilities");
        MonitorInfo.PowerManagementSupported = ПолучитьЗначениеВПопытке(Monitor, "PowerManagementSupported");
        MonitorInfo.ScreenHeight = ПолучитьЗначениеВПопытке(Monitor, "ScreenHeight");
        MonitorInfo.ScreenWidth = ПолучитьЗначениеВПопытке(Monitor, "ScreenWidth");
        MonitorInfo.Status = ПолучитьЗначениеВПопытке(Monitor, "Status");
        MonitorInfo.StatusInfo = ПолучитьЗначениеВПопытке(Monitor, "StatusInfo");
        MonitorInfo.SystemCreationClassName = ПолучитьЗначениеВПопытке(Monitor, "SystemCreationClassName");
        MonitorInfo.SystemName = ПолучитьЗначениеВПопытке(Monitor, "SystemName");
    КонецЦикла;
    
    Возврат Win32_DesktopMonitorInfo;
    
КонецФункции

// Функция, позволяющая получить список подключенных принтеров локального/удаленного компьютера,
// в т.ч. и предоставленных в общее пользование.
// Параметры:
//    Computer - Имя компьютера, список принтеров которого необходимо получить.
// Возвращаемое значение:
//    TPrinters - Таблица значений.
//    Колонки:
//        Computer - Имя компьюьера, на котором установлен(ы) прентер(а).
//        LocalName- Локальное имя принтера на компьютере.
//        Shared     - Общий/Локальный.
//        ShareName- Имя принтера для общего доступа.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//

Функция Computer_Printer(Computer = ".")
    
    TPrinters = Новый ТаблицаЗначений;
    TPrinters.Колонки.Добавить("Computer");
    TPrinters.Колонки.Добавить("LocalName");
    TPrinters.Колонки.Добавить("Shared");
    TPrinters.Колонки.Добавить("ShareName");
    
    Попытка
        
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2");
        Printers = WinMGMT.ExecQuery("Select * from Win32_Printer");
        
        Для Каждого Printer ИЗ Printers Цикл
            НоваяСтрока = TPrinters.Добавить();
            НоваяСтрока.Computer = Printer.SystemName;
            НоваяСтрока.LocalName = Printer.Name;
            НоваяСтрока.Shared = Printer.Shared;
            Если Printer.Shared Тогда
                НоваяСтрока.ShareName = Printer.ShareName;
            КонецЕсли;
        КонецЦикла;
        
    Исключение
    КонецПопытки;
    
    Возврат TPrinters;
    
КонецФункции

// Процедура подключения сетевого принтера.
//

Процедура Network_Printer(ИмяСервера, ИмяПринтера)
    
    Network = Новый COMobject("Wscript.Network");
    
    Попытка
        // Установка принтера
        Network.AddWindowsPrinterConnection("\\"+ИмяСервера+"\"+ИмяПринтера);
        // Принтер по-умолчанию
        Network.SetDefaultPrinter("\\"+ИмяСервера+"\"+ИмяПринтера);
    Исключение
        Сообщить("Невозможно произвести подключение принтера.");
    КонецПопытки;
    
КонецПроцедуры

// Функция, позволяющая получить Имя пользователя, зарегистрировавшегося на локальном/удаленном компьютере.
// Параметры:
//    Computer - Имя компьютера.
// Возвращаемое значение:
//    DomainName(ComputerName)\UserName - Имя пользователя.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//

Функция User_ComputerSystem(Computer = ".")

    UserComputer = "";
    
    Попытка
        
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2");
        ComputerSystem = WinMGMT.ExecQuery("SELECT * FROM Win32_ComputerSystem");
        
        Для Каждого System ИЗ ComputerSystem Цикл
            Возврат System.UserName;
        КонецЦикла;
        
    Исключение
    КонецПопытки;
    
    Возврат UserComputer;
    
КонецФункции

// Функция, позволяющая получить локальные имена: Компьютера, Пользователя, Домена.
// 

Функция GET_ComputerName_UserName_UserDomain()
    
    C_U_D = Новый Структура;
    
   Попытка
      Network = Новый COMobject("Wscript.Network");
      C_U_D.Вставить("ComputerName", Network.ComputerName);
      C_U_D.Вставить("UserName", Network.UserName);
      C_U_D.Вставить("UserDomain", Network.UserDomain);
   Исключение
   КонецПопытки;
    
    Возврат C_U_D;
    
КонецФункции

// Функция, позволяющая получить список учётных записей на локальном/удаленном компьютере.
// Параметры:
//    Computer - Имя компьютера.
// Возвращаемое значение:
//    Таблица значений.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//

Функция Computer_UserList(Computer = ".", АдминистраторПоУмолчанию, ГруппыИПользователи)
    
    Win32_UserAccountInfo = Новый ТаблицаЗначений;
    Win32_UserAccountInfo.Колонки.Добавить("AccountType");
    Win32_UserAccountInfo.Колонки.Добавить("Caption");
    Win32_UserAccountInfo.Колонки.Добавить("Description");
    Win32_UserAccountInfo.Колонки.Добавить("Disabled");
    Win32_UserAccountInfo.Колонки.Добавить("Domain");
    Win32_UserAccountInfo.Колонки.Добавить("FullName");
    Win32_UserAccountInfo.Колонки.Добавить("InstallDate");
    Win32_UserAccountInfo.Колонки.Добавить("LocalAccount");
    Win32_UserAccountInfo.Колонки.Добавить("Lockout");
    Win32_UserAccountInfo.Колонки.Добавить("Name");
    Win32_UserAccountInfo.Колонки.Добавить("PasswordChangeable");
    Win32_UserAccountInfo.Колонки.Добавить("PasswordExpires");
    Win32_UserAccountInfo.Колонки.Добавить("PasswordRequired");
    Win32_UserAccountInfo.Колонки.Добавить("SID");
    // Дополнительно.
    Win32_UserAccountInfo.Колонки.Добавить("BuildINAdministrator");
    Win32_UserAccountInfo.Колонки.Добавить("Group");
    
    Попытка
        
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2");
        //Win32_UserAccount = WinMGMT.ExecQuery("SELECT * FROM Win32_UserAccount Where LocalAccount = True");    // Загрузка процессора 75%.
        Win32_UserAccount = WinMGMT.ExecQuery("SELECT * FROM Win32_UserAccount");
        
        Для Каждого UserAccount ИЗ Win32_UserAccount Цикл
            UserAccountInfo = Win32_UserAccountInfo.Добавить();
            UserAccountInfo.AccountType = UserAccount.AccountType;
            UserAccountInfo.Caption = UserAccount.Caption;
            UserAccountInfo.Description = UserAccount.Description;
            UserAccountInfo.Disabled = UserAccount.Disabled;
            UserAccountInfo.Domain = UserAccount.Domain;
            UserAccountInfo.FullName = UserAccount.FullName;
            UserAccountInfo.InstallDate = UserAccount.InstallDate;
            UserAccountInfo.LocalAccount = UserAccount.LocalAccount;
            UserAccountInfo.Lockout = UserAccount.Lockout;
            UserAccountInfo.Name = UserAccount.Name;
            UserAccountInfo.PasswordChangeable = UserAccount.PasswordChangeable;
            UserAccountInfo.PasswordExpires = UserAccount.PasswordExpires;
            UserAccountInfo.PasswordRequired = UserAccount.PasswordRequired;
            UserAccountInfo.SID = UserAccount.SID;
            
            // Флажок Встроенная учетная запись администратора.
            UserAccountInfo.BuildINAdministrator = UserAccount.Name = АдминистраторПоУмолчанию.Name;
            
            // Группы, в которые входит пользователь.
            Отбор = Новый Структура("User", UserAccount.Name);
            СтрокиТаблицыГруппыИПользователи = ГруппыИПользователи.НайтиСтроки(Отбор);
            UserAccountInfo.Group = "";
            Для Каждого СтрокаТаблицы ИЗ СтрокиТаблицыГруппыИПользователи Цикл
                UserAccountInfo.Group = UserAccountInfo.Group + СтрокаТаблицы.Group + "; ";
            КонецЦикла;
            Если СтрДлина(UserAccountInfo.Group) > 0 Тогда
                UserAccountInfo.Group = Лев(UserAccountInfo.Group, СтрДлина(UserAccountInfo.Group)-2);
            КонецЕсли;
        КонецЦикла;
        
    Исключение
    КонецПопытки;

    Возврат Win32_UserAccountInfo;
    
КонецФункции

// Функция, позволяющая получить список групп пользователей на локальном/удаленном компьютере.
// Параметры:
//    Computer - Имя компьютера.
// Возвращаемое значение:
//    Таблица значений.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//

Функция Computer_GroupList(Computer = ".")
    
    Win32_GroupInfo = Новый ТаблицаЗначений;
    Win32_GroupInfo.Колонки.Добавить("Caption");
    Win32_GroupInfo.Колонки.Добавить("Description");
    Win32_GroupInfo.Колонки.Добавить("Domain");
    Win32_GroupInfo.Колонки.Добавить("LocalAccount");
    Win32_GroupInfo.Колонки.Добавить("Name");
    Win32_GroupInfo.Колонки.Добавить("SID");
    
    Попытка
        
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2");
        Win32_Group = WinMGMT.ExecQuery("SELECT * FROM Win32_Group Where LocalAccount = True");
        
        Для Каждого Group ИЗ Win32_Group Цикл
            GroupInfo = Win32_GroupInfo.Добавить();
            GroupInfo.Caption = Group.Caption;
            GroupInfo.Description = Group.Description;
            GroupInfo.Domain = Group.Domain;
            GroupInfo.LocalAccount = Group.LocalAccount;
            GroupInfo.Name = Group.Name;
            GroupInfo.SID = Group.SID;
        КонецЦикла;
        
    Исключение
    КонецПопытки;

    Возврат Win32_GroupInfo;
    
КонецФункции

// Функция, позволяющая получить список групп и их пользователей на локальном/удаленном компьютере.
// Параметры:
//    Computer - Имя компьютера.
// Возвращаемое значение:
//    Таблица значений.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//

Функция Computer_GroupUsersList(Computer = ".")
    
    Win32_GroupUsersInfo = Новый ТаблицаЗначений;
    Win32_GroupUsersInfo.Колонки.Добавить("Group");
    Win32_GroupUsersInfo.Колонки.Добавить("User");
    
    Попытка
        
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2");
        Win32_GroupUser = WinMGMT.ExecQuery("SELECT * FROM Win32_GroupUser WHERE GroupComponent IS NOT NULL");
        
        Для Каждого GroupUser ИЗ Win32_GroupUser Цикл
            GroupInfo = Win32_GroupUsersInfo.Добавить();
            
            // Группа.
            GroupComponent = GroupUser.GroupComponent;
            ПозицицияИмени = Найти(GroupComponent, "Name=");
            GroupInfo.Group = Сред(GroupComponent, ПозицицияИмени+6);
            GroupInfo.Group = СтрЗаменить(GroupInfo.Group, """", "");
            
            // Пользователь.
            PartComponent = GroupUser.PartComponent;
            ПозицицияИмени = Найти(PartComponent, "Name=");
            GroupInfo.User = Сред(PartComponent, ПозицицияИмени+6);
            GroupInfo.User = СтрЗаменить(GroupInfo.User, """", "");
        КонецЦикла;
        
    Исключение
    КонецПопытки;
    
    Возврат Win32_GroupUsersInfo;
    
КонецФункции

// Функция, позволяющая получить данные встроенной учетной записи Администратора на локальном/удаленном компьютере.
// Параметры:
//    Computer - Имя компьютера.
// Возвращаемое значение:
//    Структура.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//

Функция Computer_BuildINAdministrator(Computer = ".")
    
    BuildINAdministratorInfo = Новый Структура("AccountType,Caption,Description,Disabled,Domain,FullName,InstallDate,LocalAccount, Lockout,Name,PasswordChangeable,PasswordExpires,PasswordRequired,SID");
    
    Попытка
        
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2");
        //Win32_UserAccount = WinMGMT.ExecQuery("SELECT * FROM Win32_UserAccount Where LocalAccount = True");    // Загрузка процессора 75%.
        Win32_UserAccount = WinMGMT.ExecQuery("SELECT * FROM Win32_UserAccount");
        
        Для Каждого UserAccount ИЗ Win32_UserAccount Цикл
            AdmSID = Сред(UserAccount.SID,1,6) + "*" + Прав(UserAccount.SID, 4);
            Если AdmSID = "S-1-5-*-500" Тогда
                BuildINAdministratorInfo.AccountType = UserAccount.AccountType;
                BuildINAdministratorInfo.Caption = UserAccount.Caption;
                BuildINAdministratorInfo.Description = UserAccount.Description;
                BuildINAdministratorInfo.Disabled = UserAccount.Disabled;
                BuildINAdministratorInfo.Domain = UserAccount.Domain;
                BuildINAdministratorInfo.FullName = UserAccount.FullName;
                BuildINAdministratorInfo.InstallDate = UserAccount.InstallDate;
                BuildINAdministratorInfo.LocalAccount = UserAccount.LocalAccount;
                BuildINAdministratorInfo.Lockout = UserAccount.Lockout;
                BuildINAdministratorInfo.Name = UserAccount.Name;
                BuildINAdministratorInfo.PasswordChangeable = UserAccount.PasswordChangeable;
                BuildINAdministratorInfo.PasswordExpires = UserAccount.PasswordExpires;
                BuildINAdministratorInfo.PasswordRequired = UserAccount.PasswordRequired;
                BuildINAdministratorInfo.SID = UserAccount.SID;
                Прервать;
            КонецЕсли;
        КонецЦикла;
        
    Исключение
    КонецПопытки;
        
    Возврат BuildINAdministratorInfo;
        
КонецФункции

// Функция, позволяющая получить данные MAC-Адрес, IP-Адрес локального/удаленного компьютера.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//

Функция Computer_MAC_IP(Computer = ".")
   
    MAC_IP = Новый ТаблицаЗначений;
    MAC_IP.Колонки.Добавить("MAC");
    MAC_IP.Колонки.Добавить("IP");
    
    Попытка
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2");
        Win32_NetworkAdapterConfiguration = WinMGMT.ExecQuery("SELECT * From Win32_NetworkAdapterConfiguration Where IPEnabled = True");

        Для Каждого NetworkAdapterConfiguration ИЗ Win32_NetworkAdapterConfiguration Цикл
            MACAddress = NetworkAdapterConfiguration.MACAddress;
            
            NetworkAdapterConfigurationInfo = MAC_IP.Добавить();
            NetworkAdapterConfigurationInfo.MAC = MACAddress;
            
            Если ЗначениеЗаполнено(MACAddress) Тогда
                Для Каждого IPAddress ИЗ NetworkAdapterConfiguration.IPAddress Цикл
                    Если ЗначениеЗаполнено(IPAddress) Тогда
                        NetworkAdapterConfigurationInfo.IP = IPAddress;
                        Прервать;
                    КонецЕсли;
                КонецЦикла;
            КонецЕсли;
            
        КонецЦикла;
    Исключение
    КонецПопытки;
    
    Возврат MAC_IP;
    
КонецФункции

// Функция получения информации о сетевом окружении.
// Возвращает:
// Таблица значений со структурой: 
// №, Домен, Компьютер, IP-адрес, Комментарий.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//
// Примечание:
// 1. WMI - медленнее, PING - быстрее.
// 2. WMI - безоконный, PING - с формированием окна.
//

Функция NetworkNeighborhood()
    
    ТСетевоеОкружение = Новый ТаблицаЗначений;
    ТСетевоеОкружение.Колонки.Добавить("нПП", ,"№");
    ТСетевоеОкружение.Колонки.Добавить("Домен");
    ТСетевоеОкружение.Колонки.Добавить("Компьютер");
    ТСетевоеОкружение.Колонки.Добавить("IP");
    ТСетевоеОкружение.Колонки.Добавить("Комментарий");
    
    Попытка
        ShellApplication = Новый COMОбъект("Shell.Application");
        // Сетевое окружение.
        Network = ShellApplication.NameSpace(18);
        // Вся сеть.
        EntireNetwork = Network.Items().Item("EntireNetwork").GetFolder;
        
        Для Каждого EntireNetworkItem ИЗ EntireNetwork.Items() Цикл
            Если EntireNetworkItem.Name = "Microsoft Windows Network" Тогда
                MicrosoftWindowsNetwork = EntireNetworkItem.GetFolder;
                Прервать;
            КонецЕсли;
        КонецЦикла;
        
        нПП = 0;
        Для Каждого MicrosoftWindowsNetworkItem ИЗ MicrosoftWindowsNetwork.Items() Цикл
            // Рабочая группа или Домен.
            Domain = MicrosoftWindowsNetworkItem.GetFolder;
            Домен = ВРег(Domain.Title);
            НоваяСтрока = ТСетевоеОкружение.Добавить();
            нПП = нПП+1;
            НоваяСтрока.нПП = нПП;
            НоваяСтрока.Домен = Домен;
            Для Каждого DomainItem ИЗ Domain.Items() Цикл
                // Компьютер.
                Компьютер = ВРег(DomainItem.Name);
                НоваяСтрока = ТСетевоеОкружение.Добавить();
                нПП = нПП+1;
                НоваяСтрока.нПП = нПП;
                НоваяСтрока.Домен = Домен;
                НоваяСтрока.Компьютер = Компьютер;
                Попытка
                    WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Компьютер + "\root\cimv2");
                    // Без вывода окна на экран.
                    IPConfig = WinMGMT.ExecQuery("Select IPAddress from Win32_NetworkAdapterConfiguration where ipenabled = true");
                    // IP-адреса.
                    Для Каждого IPCFG ИЗ IPConfig Цикл
                        Если ЗначениеЗаполнено(IPCFG.IPAddress) Тогда
                            Для Каждого IP ИЗ IPCFG.IPAddress Цикл
                                НоваяСтрока = ТСетевоеОкружение.Добавить();
                                нПП = нПП+1;
                                НоваяСтрока.нПП = нПП;
                                НоваяСтрока.Домен = Домен;
                                НоваяСтрока.Компьютер = Компьютер;
                                НоваяСтрока.IP = IP;
                                НоваяСтрока.Комментарий = "WMI";
                            КонецЦикла;
                        КонецЕсли;
                    КонецЦикла;
                Исключение
                    Сообщить("Проверьте на компьютере " + Компьютер + "
                    |Windows Management Instrumentation (WMI):
                    |1. Состояние служб, отвечающих за WMI;
                    |2. Разрешение в брандмауэре для WMI.");
                    WshShell = Новый COMОбъект("WScript.Shell");
                    // Exec - выводит окно на экран.
                    WshExec = WshShell.Exec("ping -n 1 " + Компьютер);
                    TextStream = WshExec.StdOut;
                    // IP-адреса.
                    Пока НЕ TextStream.AtEndOfStream Цикл
                        СтрокаIP = TextStream.ReadLine();
                        ПозицияСкобкиЛевая = Найти(СтрокаIP, "[");
                        Если ПозицияСкобкиЛевая > 0 Тогда
                            ПозицияСкобкиПравая = Найти(СтрокаIP, "]");
                            IP = Сред(СтрокаIP, ПозицияСкобкиЛевая+1, ПозицияСкобкиПравая-ПозицияСкобкиЛевая-1);
                            НоваяСтрока = ТСетевоеОкружение.Добавить();
                            нПП = нПП+1;
                            НоваяСтрока.нПП = нПП;
                            НоваяСтрока.Домен = Домен;
                            НоваяСтрока.Компьютер = Компьютер;
                            НоваяСтрока.IP = IP;
                            НоваяСтрока.Комментарий = "PING";
                            Прервать;
                        КонецЕсли;
                    КонецЦикла;
                КонецПопытки;
            КонецЦикла;
        КонецЦикла;
    Исключение
    КонецПопытки;
    
    Возврат ТСетевоеОкружение;
    
КонецФункции

// Функция, позволяющая невизуально "пропинговать" удаленный компьютер.
// Параметры:
//    Computer - Имя компьютера.
// Возвращаемое значение:
//    Ложь/Истина.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//

Функция Computer_PING(Computer = "localhost")
    
    WinMGMT = ПолучитьCOMОбъект("winmgmts:{impersonationLevel=impersonate}!\\");
    Win32_PingStatus = WinMGMT.ExecQuery("SELECT StatusCode FROM Win32_PingStatus WHERE Address = '" + Computer + "'");
    
    Успешно = Ложь;
    Для Каждого PingStatus ИЗ Win32_PingStatus Цикл
        Если PingStatus.StatusCode = NULL Тогда
            Успешно = Ложь;
        Иначе
            Успешно = PingStatus.StatusCode = 0;
        КонецЕсли;
    КонецЦикла;
    
    Возврат Успешно;
    
КонецФункции

// Функция, позволяющая получить информацию о службах на локальном/удаленном компьютере.
// Параметры:
//    Computer - Имя компьютера.
// Возвращаемое значение:
//    Таблица значений.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//

Функция Computer_SystemService(Computer = ".")
    
    Win32_ServiceInfo = Новый ТаблицаЗначений;
    Win32_ServiceInfo.Колонки.Добавить("Name");
    Win32_ServiceInfo.Колонки.Добавить("Caption");
    Win32_ServiceInfo.Колонки.Добавить("Description");
    Win32_ServiceInfo.Колонки.Добавить("PathName");
    Win32_ServiceInfo.Колонки.Добавить("StartMode");
    Win32_ServiceInfo.Колонки.Добавить("StartName");
    Win32_ServiceInfo.Колонки.Добавить("State");
    Win32_ServiceInfo.Колонки.Добавить("ProcessID");
    Win32_ServiceInfo.Колонки.Добавить("SystemName");
    
    Попытка
        
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2");
        Win32_Service = WinMGMT.ExecQuery("SELECT * FROM Win32_Service");
        
        Для Каждого Service ИЗ Win32_Service Цикл
            ServiceInfo = Win32_ServiceInfo.Добавить();
            ServiceInfo.Name = Service.Name;
            ServiceInfo.Caption = Service.Caption;
            ServiceInfo.Description = Service.Description;
            ServiceInfo.PathName = Service.PathName;
            ServiceInfo.StartMode = Service.StartMode;
            ServiceInfo.StartName = Service.StartName;
            ServiceInfo.State = Service.State;
            ServiceInfo.ProcessID = Service.ProcessID;
            ServiceInfo.SystemName = Service.SystemName;
        КонецЦикла;
        
    Исключение
    КонецПопытки;
    
    Возврат Win32_ServiceInfo;

КонецФункции

// Функция, позволяющая получить информацию о процессах на локальном/удаленном компьютере.
// Параметры:
//    Computer - Имя компьютера.
// Возвращаемое значение:
//    Таблица значений.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//

Функция Computer_SystemProcess(Computer = ".")
    
    Win32_ProcessInfo = Новый ТаблицаЗначений;
    Win32_ProcessInfo.Колонки.Добавить("Caption");
    Win32_ProcessInfo.Колонки.Добавить("CommandLine");
    Win32_ProcessInfo.Колонки.Добавить("CreationDate");
    Win32_ProcessInfo.Колонки.Добавить("CSName");
    Win32_ProcessInfo.Колонки.Добавить("ExecutablePath");
    Win32_ProcessInfo.Колонки.Добавить("OSName");
    Win32_ProcessInfo.Колонки.Добавить("ParentProcessId");
    Win32_ProcessInfo.Колонки.Добавить("ProcessId");
    Win32_ProcessInfo.Колонки.Добавить("WindowsVersion");
    Win32_ProcessInfo.Колонки.Добавить("Owner");
    
    Попытка
        
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2");
        Win32_Process = WinMGMT.ExecQuery("SELECT * FROM Win32_Process");
        
        Для Каждого Proccess ИЗ Win32_Process Цикл
            ProccessInfo = Win32_ProcessInfo.Добавить();
            ProccessInfo.Caption = Proccess.Caption;
            ProccessInfo.CommandLine = Proccess.CommandLine;
            Попытка
                ProccessInfo.CreationDate = Дата(Лев(Proccess.CreationDate,14));
            Исключение
            КонецПопытки;
            ProccessInfo.CSName = Proccess.CSName;
            ProccessInfo.ExecutablePath = Proccess.ExecutablePath;
            ProccessInfo.OSName = Proccess.OSName;
            ProccessInfo.ParentProcessID = Proccess.ParentProcessID;
            ProccessInfo.ProcessID = Proccess.ProcessID;
            ProccessInfo.WindowsVersion = Proccess.WindowsVersion;
            User = "";
            Domain = "";
            Owner = Proccess.GetOwner(User, Domain);
            Если User = NULL И Domain = NULL Тогда
                ProccessInfo.Owner = "System";
            Иначе
                ProccessInfo.Owner = Domain + "\" + User;
            КонецЕсли;
        КонецЦикла;
        
    Исключение
    КонецПопытки;
    
    Возврат Win32_ProcessInfo;

КонецФункции

// Функция, позволяющая завершить некий процесс на локальном/удаленном компьютере.
// Параметры:
//    Computer - Имя компьютера.
//    ProccessName - Имя процесса, который необходимо завершить.
// Возвращаемое значение:
//    Количество завершенных процессов.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//

Функция Computer_KillProccess(Computer = ".", ProccessName = "")
    
    Попытка
        
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2");
        Win32_Process = WinMGMT.ExecQuery("SELECT * FROM Win32_Process Where Name = '" + ProccessName + "'");
        
        Для Каждого Process ИЗ Win32_Process Цикл
            Process.Terminate();
        КонецЦикла;
        
    Исключение
    КонецПопытки;

    Возврат Win32_Process.Count;

КонецФункции

// Функция, позволяющая получить список событий за период из журналов System/Application локального/удаленного компьютера.
// Параметры:
//    Computer - Имя компьютера.
//    Logfile - Имя LOG-файла (System/Application).
//    EventsType:
//        1 - Error 
//        2 - Warning 
//        3 - Information 
//        4 - Security audit success 
//        5 - Security audit failure
//    DateStart - Дата начала в формате даты.
//    DateEnd - Дата окончания в формате даты.
// Возвращаемое значение:
//    Таблица значений.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//

Функция Computer_EventsList(Computer = ".", Logfile = "System", EventType = "0", DateStart = Неопределено, DateEnd = Неопределено)
    
    Если DateStart = Неопределено Тогда
        DateStart = ТекущаяДата();
    КонецЕсли;
    
    Если DateEnd = Неопределено Тогда
        DateEnd = ТекущаяДата();
    КонецЕсли;
    
    FiltreType = ?(EventType = "0", "", " and EventType = " + EventType);
    
    Win32_EventsInfo = Новый ТаблицаЗначений;
    Win32_EventsInfo.Колонки.Добавить("Category");
    Win32_EventsInfo.Колонки.Добавить("ComputerName");
    Win32_EventsInfo.Колонки.Добавить("EventCode");
    Win32_EventsInfo.Колонки.Добавить("Message");
    Win32_EventsInfo.Колонки.Добавить("RecordNumber");
    Win32_EventsInfo.Колонки.Добавить("SourceName");
    Win32_EventsInfo.Колонки.Добавить("TimeWritten");
    Win32_EventsInfo.Колонки.Добавить("Type");
    Win32_EventsInfo.Колонки.Добавить("User");
    
    Попытка
        
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2");
        Win32_NTLogEvent = WinMGMT.ExecQuery("SELECT * FROM Win32_NTLogEvent Where Logfile = '" + Logfile + "'" 
        + FiltreType 
        + " and TimeWritten >= '" + НачалоДня(DateStart) + "' and TimeWritten <= '" + КонецДня(DateEnd) + "'");
        
        Для Каждого NTLogEvent ИЗ Win32_NTLogEvent Цикл
            EventsInfo = Win32_EventsInfo.Добавить();
            EventsInfo.Category = NTLogEvent.Category;
            EventsInfo.ComputerName = NTLogEvent.ComputerName;
            EventsInfo.EventCode = NTLogEvent.EventCode;
            EventsInfo.Message = NTLogEvent.Message;
            EventsInfo.RecordNumber = NTLogEvent.RecordNumber;
            EventsInfo.SourceName = NTLogEvent.SourceName;
            EventsInfo.TimeWritten = Дата(Лев(NTLogEvent.TimeWritten,14));
            EventsInfo.Type = NTLogEvent.Type;
            EventsInfo.User = NTLogEvent.User;
        КонецЦикла;
        
    Исключение
    КонецПопытки;

    Возврат Win32_EventsInfo;

КонецФункции

// Функция, позволяющая получить информацию об открытых сессиях на сервере (локальный/удаленный компьютер).
// Параметры:
//    Computer - Имя компьютера.
// Возвращаемое значение:
//    Таблица значений.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//

Функция Computer_ServerSession(Computer = ".")
    
    ServerSessionInfo = Новый ТаблицаЗначений;
    ServerSessionInfo.Колонки.Добавить("ActiveTime");
    ServerSessionInfo.Колонки.Добавить("Caption");
    ServerSessionInfo.Колонки.Добавить("ClientType");
    ServerSessionInfo.Колонки.Добавить("ComputerName");
    ServerSessionInfo.Колонки.Добавить("Description");
    ServerSessionInfo.Колонки.Добавить("IdleTime");
    ServerSessionInfo.Колонки.Добавить("InstallDate");
    ServerSessionInfo.Колонки.Добавить("Name");
    ServerSessionInfo.Колонки.Добавить("ResourcesOpened");
    ServerSessionInfo.Колонки.Добавить("SessionType");
    ServerSessionInfo.Колонки.Добавить("Status");
    ServerSessionInfo.Колонки.Добавить("TransportName");
    ServerSessionInfo.Колонки.Добавить("UserName");
    
    Попытка
        
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2");
        ServerSession = WinMGMT.ExecQuery("Select * from Win32_ServerSession");
        
        Для Каждого Session ИЗ ServerSession Цикл
            SessionInfo = ServerSessionInfo.Добавить();
            SessionInfo.ActiveTime = Формат(Дата("00010101")+Session.ActiveTime,"ДЛФ=T");
            SessionInfo.Caption = Session.Caption;
            SessionInfo.ClientType = Session.ClientType;
            SessionInfo.ComputerName = Session.ComputerName;
            SessionInfo.Description = Session.Description;
            SessionInfo.IdleTime = Формат(Дата("00010101")+Session.IdleTime,"ДЛФ=T");
            SessionInfo.InstallDate = Session.InstallDate;
            SessionInfo.Name = Session.Name;
            SessionInfo.ResourcesOpened = Session.ResourcesOpened;
            SessionInfo.SessionType = Session.SessionType;
            SessionInfo.Status = Session.Status;
            SessionInfo.TransportName = Session.TransportName;
            SessionInfo.UserName = Session.UserName;
        КонецЦикла;
    
    Исключение
    КонецПопытки;
    
    Возврат ServerSessionInfo;
    
КонецФункции

// Функция, позволяющая получить информацию о терминальных сессиях на сервере (локальный/удаленный компьютер).
// Параметры:
//    Computer - Имя компьютера.
// Возвращаемое значение:
//    Name = DomainName\UserName - Имя пользователя.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//

Функция Computer_Terminal(Computer = ".")
    
    TerminalInfo = Новый ТаблицаЗначений;
    TerminalInfo.Колонки.Добавить("Caption");
    TerminalInfo.Колонки.Добавить("Description");
    TerminalInfo.Колонки.Добавить("fEnableTerminal");
    TerminalInfo.Колонки.Добавить("InstallDate");
    TerminalInfo.Колонки.Добавить("Name");
    TerminalInfo.Колонки.Добавить("Status");
    TerminalInfo.Колонки.Добавить("TerminalName");
    
    Попытка
        
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2");
        Terminal = WinMGMT.ExecQuery("Select * from Win32_Terminal");
        
        Для Каждого Session ИЗ Terminal Цикл
            SessionInfo = TerminalInfo.Добавить();
            SessionInfo.Caption = Session.Caption;
            SessionInfo.Description = Session.Description;
            SessionInfo.fEnableTerminal = Session.fEnableTerminal;
            SessionInfo.InstallDate = Session.InstallDate;
            SessionInfo.Name = Session.Name;
            SessionInfo.Status = Session.Status;
            SessionInfo.TerminalName = Session.TerminalName;
        КонецЦикла;
        
    Исключение
    КонецПопытки;
    
    Возврат TerminalInfo;
    
КонецФункции

// Функция, позволяющая получить информацию об установленных подключениях к серверу (локальный/удаленный компьютер).
// Параметры:
//    Computer - Имя компьютера.
// Возвращаемое значение:
//    Таблица значений.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//

Функция Computer_ServerConnection(Computer = ".")
    
    ServerConnectionInfo = Новый ТаблицаЗначений;
    ServerConnectionInfo.Колонки.Добавить("ActiveTime");
    ServerConnectionInfo.Колонки.Добавить("Caption");
    ServerConnectionInfo.Колонки.Добавить("ComputerName");
    ServerConnectionInfo.Колонки.Добавить("ConnectionID");
    ServerConnectionInfo.Колонки.Добавить("Description");
    ServerConnectionInfo.Колонки.Добавить("InstallDate");
    ServerConnectionInfo.Колонки.Добавить("Name");
    ServerConnectionInfo.Колонки.Добавить("NumberOfFiles");
    ServerConnectionInfo.Колонки.Добавить("NumberOfUsers");
    ServerConnectionInfo.Колонки.Добавить("ShareName");
    ServerConnectionInfo.Колонки.Добавить("Status");
    ServerConnectionInfo.Колонки.Добавить("UserName");
    
    Попытка
        
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2");
        ServerConnection = WinMGMT.ExecQuery("Select * from Win32_ServerConnection");
        
        Для Каждого Connection ИЗ ServerConnection Цикл
            ConnectionInfo = ServerConnectionInfo.Добавить();
            ConnectionInfo.ActiveTime = Формат(Дата("00010101")+Connection.ActiveTime,"ДЛФ=T");
            ConnectionInfo.Caption = Connection.Caption;
            ConnectionInfo.ComputerName = Connection.ComputerName;
            ConnectionInfo.ConnectionID = Connection.ConnectionID;
            ConnectionInfo.Description = Connection.Description;
            ConnectionInfo.InstallDate = Connection.InstallDate;
            ConnectionInfo.Name = Connection.Name;
            ConnectionInfo.NumberOfFiles = Connection.NumberOfFiles;
            ConnectionInfo.NumberOfUsers = Connection.NumberOfUsers;
            ConnectionInfo.ShareName = Connection.ShareName;
            ConnectionInfo.Status = Connection.Status;
            ConnectionInfo.UserName = Connection.UserName;
        КонецЦикла;
        
    Исключение
    КонецПопытки;
    
    Возврат ServerConnectionInfo;

КонецФункции

// Функция, позволяющая произвести завершение сеанса/перезагрузку/выключение локаьного/удаленного компьютера.
// Параметры:
//    Computer - Имя компьютера.
//    Flags - Действие:
//    Log Off;
//    0 (0x0)    -    Log Off
//    4 (0x4)    -    Forced Log Off (0 + 4)
//    Shutdown:
//    1 (0x1)    -    Shutdown
//    5 (0x5)    -    Forced Shutdown (1 + 4)
//    Reboot:
//    2 (0x2)    -    Reboot
//    6 (0x6)    -    Forced Reboot (2 + 4)
//    Power Off:
//    8 (0x8)    -    Power Off
//    12 (0xC)-    Forced Power Off (8 + 4)
// Возвращаемое значение:
//    Нет.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//

Функция Computer_RebootShutdown(Computer = ".", Flags = 0)
    
    Попытка
        
        WinMGMT = ПолучитьCOMОбъект("winmgmts:{impersonationLevel=impersonate,(Shutdown)}!\\" + Computer + "\root\cimv2");
        Win32_OS = WinMGMT.ExecQuery("SELECT * FROM Win32_OperatingSystem where Primary=true");
        
        Reserved = 0;   // Зарезервированный параметр. Игнорируется.
        Для Каждого OS ИЗ Win32_OS Цикл
            OS.Win32Shutdown(Flags, Reserved);
        КонецЦикла;
        
    Исключение
    КонецПопытки;
    
КонецФункции

//Если Найти(СтрокаСоединенияИнформационнойБазы(), "Srvr") > 0 Тогда
//	// серверный вариант
//	Поиск1 = Найти(СтрокаСоединенияИнформационнойБазы(), "Srvr=");
//	ПодстрокаПоиска = Сред(СтрокаСоединенияИнформационнойБазы(), Поиск1 + 6);
//	ИмяСервера = Лев(ПодстрокаПоиска, Найти(ПодстрокаПоиска, """") - 1);
//	// теперь ищем имя базы
//	Поиск1 = Найти(СтрокаСоединенияИнформационнойБазы(), "Ref=");
//	ПодстрокаПоиска = Сред(СтрокаСоединенияИнформационнойБазы(), Поиск1 + 5);
//	ИмяБазы = Лев(ПодстрокаПоиска, Найти(ПодстрокаПоиска, """") - 1);
//Иначе
//	// для других способов подключения алгоритм не актуален
//	Возврат;
//КонецЕсли;

//Коннектор = Новый COMОбъект("v82.COMConnector");
//Агент = Коннектор.ConnectAgent(ИмяСервера);
//Кластеры = Агент.GetClusters();
//Для каждого Кластер из Кластеры Цикл
//	АдминистраторКластера = "Имя администратора кластера";
//	ПарольКластера = "Пароль администратора кластера";
//	Агент.Authenticate(Кластер, АдминистраторКластера, ПарольКластера);
//	Процессы = Агент.GetWorkingProcesses(Кластер);
//	Для каждого Процесс из Процессы Цикл
//		Порт = Процесс.MainPort;
//		// теперь есть адрес и порт для подключения к рабочему процессу
//		РабПроц = Коннектор.ConnectWorkingProcess(Имяервера + ":" + СтрЗаменить(Порт, Символы.НПП, ""));
//		РабПроц.AddAuthentication("Имя администратора БД", "Пароль администратора БД");

//		ИнформационнаяБаза = "";

//		Базы = Агент.GetInfoBases(Кластер);
//		Для каждого База из Базы Цикл
//			Если База.Name = ИмяБазы Тогда
//				ИнформационнаяБаза = База;
//				Прервать;
//			КонецЕсли;
//		КонецЦикла;
//		Если ИнформационнаяБаза = "" Тогда
//			// база не найдена
//		КонецЕсли;

//		Сеансы = Агент.GetInfoBaseSessions(Кластер, ИнформационнаяБаза);
//		Для каждого Сеанс из Сеансы Цикл
//			Если нРег(Сеанс.AppID) = "backgroundjob" ИЛИ нРег(Сеанс.AppID) = "designer" Тогда
//				// если это сеансы конфигуратора или фонового задания, то не отключаем
//				Продолжить;
//			КонецЕсли;
//			Если Сеанс.UserName = ИмяПользователя() Тогда
//				// это текущий пользователь
//				Продолжить;
//			КонецЕсли;
//			Агент.TerminateSession(Кластер, Сеанс);
//		КонецЦикла;

//		СоединенияБазы = Агент.GetInfoBaseConnections(Кластер, ИнформационнаяБаза);
//		// Разорвать соединения клиентских приложений.
//		Для Каждого Соединение Из СоединенияБазы Цикл
//			Если нРег(Соединение.Application) = "backgroundjob" ИЛИ нРег(Соединение.Application) = "designer" Тогда
//				// если это соединение конфигуратора или фонового задания, то не отключаем
//				Продолжить;
//			КонецЕсли;
//			Если Соединение.UserName = ИмяПользователя() Тогда
//				// это текущий пользователь
//				Продолжить;
//			КонецЕсли;
//			РабПроц.Disconnect(Соединение);
//		КонецЦикла;
//	КонецЦикла;
//КонецЦикла;