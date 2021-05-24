// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ СО СТРОКАМИ

// Подставляет параметры в строку. Максимально возможное число параметров - 9.//надо
// Параметры в строке задаются как %<номер параметра>. Нумерация параметров
// начинается с единицы.
//
// Параметры
//  СтрокаПодстановки  – Строка – шаблон строки с параметрами (вхождениями вида "%ИмяПараметра").
// Параметр<n>         - Строка - параметр
// Возвращаемое значение:
//   Строка   – текстовая строка с подставленными параметрами
//
// Пример:
// Строка = ПодставитьПараметрыВСтроку(НСтр("ru='%1 пошел в %2'"), "Вася", "Зоопарк");
//
Функция ПодставитьПараметрыВСтроку(Знач СтрокаПодстановки,
	Знач Параметр1,	Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено,
	Знач Параметр4 = Неопределено, Знач Параметр5 = Неопределено, Знач Параметр6 = Неопределено,
	Знач Параметр7 = Неопределено, Знач Параметр8 = Неопределено, Знач Параметр9 = Неопределено) Экспорт
	
	Если СтрокаПодстановки = Неопределено ИЛИ СтрДлина(СтрокаПодстановки) = 0 Тогда
		Возврат "";
	КонецЕсли;
	
	Результат = "";
	НачПозиция = 1;
	Позиция = 1;
	Пока Позиция <= СтрДлина(СтрокаПодстановки) Цикл
		СимволСтроки = Сред(СтрокаПодстановки, Позиция, 1);
		Если СимволСтроки <> "%" Тогда
			Позиция = Позиция + 1;
			Продолжить;
		КонецЕсли;
		Результат = Результат + Сред(СтрокаПодстановки, НачПозиция, Позиция - НачПозиция);
		Позиция = Позиция + 1;
		СимволСтроки = Сред(СтрокаПодстановки, Позиция, 1);
		
		Если СимволСтроки = "%" Тогда
			Позиция = Позиция + 1;
			НачПозиция = Позиция;
			Продолжить;
		КонецЕсли;
		
		Попытка
			НомерПараметра = Число(СимволСтроки);
		Исключение
			ВызватьИсключение НСтр("ru='Входная строка СтрокаПодстановки имеет неверный формат: %'" + СимволСтроки);
		КонецПопытки;
		
		Если СимволСтроки = "1" Тогда
			ЗначениеПараметра = Параметр1;
		ИначеЕсли СимволСтроки = "2" Тогда
			ЗначениеПараметра = Параметр2;
		ИначеЕсли СимволСтроки = "3" Тогда
			ЗначениеПараметра = Параметр3;
		ИначеЕсли СимволСтроки = "4" Тогда
			ЗначениеПараметра = Параметр4;
		ИначеЕсли СимволСтроки = "5" Тогда
			ЗначениеПараметра = Параметр5;
		ИначеЕсли СимволСтроки = "6" Тогда
			ЗначениеПараметра = Параметр6;
		ИначеЕсли СимволСтроки = "7" Тогда
			ЗначениеПараметра = Параметр7;
		ИначеЕсли СимволСтроки = "8" Тогда
			ЗначениеПараметра = Параметр8;
		ИначеЕсли СимволСтроки = "9" Тогда
			ЗначениеПараметра = Параметр9;
		Иначе
			ВызватьИсключение НСтр("ru='Входная строка СтрокаПодстановки имеет неверный формат: %'" + ЗначениеПараметра);
		КонецЕсли;
		Если ЗначениеПараметра = Неопределено Тогда
			ЗначениеПараметра = "";
		Иначе
			ЗначениеПараметра = Строка(ЗначениеПараметра);
		КонецЕсли;
		Результат = Результат + ЗначениеПараметра;
		Позиция = Позиция + 1;
		НачПозиция = Позиция;
		
	КонецЦикла;
	
	Если (НачПозиция <= СтрДлина(СтрокаПодстановки)) Тогда
		Результат = Результат + Сред(СтрокаПодстановки, НачПозиция, СтрДлина(СтрокаПодстановки) - НачПозиция + 1);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

//////////////////////////////////////////////////
// Функция для получения файла из интернета.
//
// Параметры:
// URL           - строка - url файла в формате:
//                 [Протокол://]<Сервер>/<Путь к файлу на сервере>
// Пользователь  - строка - пользователь от имени которого установлено соединение
// Пароль        - строка - пароль пользователя от которого установлено соединение
// Порт          - число  - порт сервера с которым установлено соединение
// ЗащищенноеПассивноеСоединение
//
// НастройкаСохранения - соответствие - содержит параметры для сохранения скачанного файла
//                 ключи:
//                 МестоХранения - строка - может содержать 
//                        "Клиент" - клиент,
//                        "Сервер" - сервер,
//                        "ВременноеХранилище" - временное хранилище
//                 Путь - строка (необязательный параметр) - 
//                        путь к каталогу на клиенте либо на сервере либо адрес во временном хранилище
//                        если не задано будет сгенерировано автоматически
//
// Возвращаемое значение:
// структура
// успех  - булево - успех или неудача операции
// строка - строка - в случае успеха либо строка-путь сохранения файла
//                   либо адрес во временном хранилище
//                   в случае неуспеха сообщение об ошибке
//
Функция ПодготовитьПолучениеФайла(	знач URL,
	знач Пользователь			= Неопределено,
	знач Пароль					= Неопределено,
	знач Порт					= Неопределено,
	знач ЗащищенноеСоединение	= Ложь,
	знач ПассивноеСоединение	= Ложь,
	знач НастройкаСохранения) Экспорт
	
	НастройкаСоединения = Новый Соответствие;
	НастройкаСоединения.Вставить("Пользователь",	Пользователь);
	НастройкаСоединения.Вставить("Пароль",			Пароль);
	НастройкаСоединения.Вставить("Порт",			Порт);
	
	Протокол = РазделитьURL(URL).Протокол;
	
	Если Протокол = "ftp" Тогда
		НастройкаСоединения.Вставить("ПассивноеСоединение", ПассивноеСоединение);
	Иначе
		НастройкаСоединения.Вставить("ЗащищенноеСоединение", ЗащищенноеСоединение);
	КонецЕсли;
	
	НастройкаПроксиСервера = Неопределено;
	
	Результат = ПолучитьФайлИзИнтернет(URL, НастройкаСохранения, НастройкаСоединения, НастройкаПроксиСервера);
	
	Возврат Результат;
	
КонецФункции

// Функция для получения файла из интернета.
//
// Параметры:
// URL           - строка - url файла в формате:
//                 [Протокол://]<Сервер>/<Путь к файлу на сервере>
//
// НастройкаСоединения - Соответствие -
//                 ЗащищенноеСоединение* - булево - соединение защищенное
//                 ПассивноеСоединение*  - булево - соединение защищенное
//                 Пользователь - строка - пользователь от имени которого установлено соединение
//                 Пароль       - строка - пароль пользователя от которого установлено соединение
//                 Порт         - число  - порт сервера с которым установлено соединение
//                 * - взаимоисключающие ключи
//
// Прокси        - Соответствие -
//                 ключи:
//                 НеИспользоватьПроксиДляЛокальныхАдресов - строка - 
//                 Сервер       - адрес прокси-сервера
//                 Порт         - порт прокси-сервера
//                 Пользователь - имя пользователя для авторизации на прокси-сервере
//                 Пароль       - пароль пользователя
//
// НастройкаСохранения - соответствие - содержит параметры для сохранения скачанного файла
//                 ключи:
//                 МестоХранения - строка - может содержать 
//                        "Клиент" - клиент,
//                        "Сервер" - сервер,
//                        "ВременноеХранилище" - временное хранилище
//                 Путь - строка (необязательный параметр) - 
//                        путь к каталогу на клиенте либо на сервере либо адрес во временном хранилище
//                        если не задано будет сгенерировано автоматически
//
// Возвращаемое значение:
// структура
// успех  - булево - успех или неудача операции
// строка - строка - в случае успеха либо строка-путь сохранения файла
//                   либо адрес во временном хранилище
//                   в случае неуспеха сообщение об ошибке
//
Функция ПолучитьФайлИзИнтернет(знач URL,
	знач НастройкаСохранения,
	знач НастройкаСоединения = Неопределено,
	знач Прокси = Неопределено)
	
	// Объявление переменных перед первым использованием в качестве
	// параметра метода Свойство, при анализе параметров получения файлов
	// из ПараметрыПолучения. Содержат значения переданных параметров получения файла
	Перем ИмяСервера, ИмяПользователя, Пароль, Порт,
	ЗащищенноеСоединение,ПассивноеСоединение,
	ПустьКФайлуНаСервере, Протокол;
	
	URLРазделенный = РазделитьURL(URL);
	
	ИмяСервера           = URLРазделенный.ИмяСервера;
	ПустьКФайлуНаСервере = URLРазделенный.ПустьКФайлуНаСервере;
	Протокол             = ?(URLРазделенный.Протокол=Неопределено, "", URLРазделенный.Протокол);
	
	ЗащищенноеСоединение = НастройкаСоединения.Получить("ЗащищенноеСоединение");
	ПассивноеСоединение  = НастройкаСоединения.Получить("ПассивноеСоединение");
	
	ИмяПользователя      = НастройкаСоединения.Получить("Пользователь");
	ПарольПользователя   = НастройкаСоединения.Получить("Пароль");
	Порт                 = НастройкаСоединения.Получить("Порт");
	
	Если Не ЗначениеЗаполнено(URLРазделенный.Протокол) Тогда
		Если ЗащищенноеСоединение <> Неопределено Тогда
			Если ЗащищенноеСоединение Тогда
				Протокол = "https";
			Иначе
				Протокол = "http";
			КонецЕсли;
		ИначеЕсли ПассивноеСоединение <> Неопределено Тогда
			Если ПассивноеСоединение Тогда
				Протокол = "ftp";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Протокол = ?(ЗначениеЗаполнено(Протокол), Протокол, "http");
	
	//Прокси =Неопределено;
	
	Если Протокол = "ftp" Тогда
		Попытка
			Соединение = Новый FTPСоединение(ИмяСервера, Порт, ИмяПользователя, ПарольПользователя, Прокси, ПассивноеСоединение);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			СообщениеОбОшибке = НСтр("ru = 'Ошибка при создании FTP-соединения с сервером %1:'") + Символы.ПС + "%2";
			СообщениеОбОшибке = ФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СообщениеОбОшибке, ИмяСервера,
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
			Возврат СформироватьРезультат(Ложь, СообщениеОбОшибке);
		КонецПопытки;
	Иначе
		Попытка
			Соединение = Новый HTTPСоединение(ИмяСервера, Порт, ИмяПользователя, ПарольПользователя, Прокси, ЗащищенноеСоединение);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			СообщениеОбОшибке = НСтр("ru = 'Ошибка при создании HTTP-соединения с сервером %1:'") + Символы.ПС + "%2";
			СообщениеОбОшибке = ФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СообщениеОбОшибке, ИмяСервера, 
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
			Возврат СформироватьРезультат(Ложь, СообщениеОбОшибке);
		КонецПопытки;
	КонецЕсли;
	
	Если НастройкаСохранения["Путь"] <> Неопределено Тогда
		ПутьДляСохранения = НастройкаСохранения["Путь"];
	Иначе
		#Если НЕ ВебКлиент Тогда
			ПутьДляСохранения = ПолучитьИмяВременногоФайла();
		#КонецЕсли
	КонецЕсли;
	
	Попытка
		Соединение.Получить(ПустьКФайлуНаСервере, ПутьДляСохранения);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		СообщениеОбОшибке = НСтр("ru = 'Ошибка при получении файла с сервера %1:'") + Символы.ПС + "%2";
		СообщениеОбОшибке = ФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СообщениеОбОшибке, ИмяСервера, 
		КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		Возврат СформироватьРезультат(Ложь, СообщениеОбОшибке);
	КонецПопытки;
	
	// Если сохраняем файл в соответствии с настройкой 
	Если НастройкаСохранения["МестоХранения"] = "ВременноеХранилище" Тогда
		КлючУникальности = Новый УникальныйИдентификатор;
		Адрес = ПоместитьВоВременноеХранилище (ПутьДляСохранения, КлючУникальности);
		Возврат СформироватьРезультат(Истина, Адрес);
	ИначеЕсли НастройкаСохранения["МестоХранения"] = "Клиент"
		ИЛИ НастройкаСохранения["МестоХранения"] = "Сервер" Тогда
		Возврат СформироватьРезультат(Истина, ПутьДляСохранения);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Разделяем URL по составным частям (протокол, сервер и путь)
// Параметры:
// URL           - строка - правильный url к ресурсу в Интернет
//
// Возвращаемое значение:
// структура с полями:
// протокол   - строка - протокол доступа к ресурсу
// ИмяСервера - строка - сервер на котором располагается ресурс
// ПустьКФайлуНаСервере - строка - пусть к файлу на сервере
//
Функция РазделитьURL(знач URL)
	
	Результат = Новый Структура;
	
	// протокол по умолчанию
	Протокол = "http";
	
	URL = СокрЛП(URL);
	
	Если Лев(URL, 5) = "ftp://" Тогда
		URL = Прав(URL, СтрДлина(URL) - 7);
	КонецЕсли;
	
	Если Лев(URL, 7) = "http://" Тогда
		URL = Прав(URL, СтрДлина(URL) - 7);
		Протокол = "http";
	КонецЕсли;
	
	Если Лев(URL, 8) = "https://" Тогда
		URL = Прав(URL, СтрДлина(URL) - 8);
		Протокол = "https";
	КонецЕсли;
	
	Индекс = 1;
	ИмяСервера = "";
	
	Пока Индекс < СтрДлина(URL) Цикл
		_Символ = Сред(URL, Индекс, 1);
		Если _Символ = "/" Тогда
			Прервать;
		КонецЕсли;
		ИмяСервера = ИмяСервера + _Символ;
		Индекс = Индекс + 1;
	КонецЦикла;
	
	ПустьКФайлу = Прав(URL, СтрДлина(URL) - Индекс);
	
	Результат.Вставить("ИмяСервера", ИмяСервера);
	Результат.Вставить("ПустьКФайлуНаСервере", ПустьКФайлу);
	Результат.Вставить("Протокол", Протокол);
	
	Возврат Результат;
	
КонецФункции

// Функция, заполняющая структуру по параметрам.
//
// Параметры:
// УспехОперации - булево - успех или неуспех операции
// СообщениеПуть - строка - 
//
// Возвращаемое значение:
// стуктура :
//          поле успех - булево
//          поле путь  - строка
//
Функция СформироватьРезультат(знач Статус, знач СообщениеПуть)
	
	Результат = Новый Структура("Статус");
	
	Результат.Статус = Статус;
	
	Если Статус Тогда
		Результат.Вставить("Путь", СообщениеПуть);
	Иначе
		Результат.Вставить("СообщениеОбОшибке", СообщениеПуть);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
Функция ЗагрузитьКурсыВалютПоПараметрам(знач Валюты,
	знач НачалоПериодаЗагрузки,
	знач ОкончаниеПериодаЗагрузки,
	ПриЗагрузкеВозниклиОшибки = Ложь) Экспорт
	
	СостояниеЗагрузки = Новый Массив;
	
	ПриЗагрузкеВозниклиОшибки = Ложь;
	
	СерверИсточник = "cbrates.rbc.ru";
	
	Если НачалоПериодаЗагрузки = ОкончаниеПериодаЗагрузки Тогда
		Адрес = "tsv/";
		ТМП   = "/"+Формат(Год(ОкончаниеПериодаЗагрузки),"ЧРГ=; ЧГ=0")+"/"+Формат(Месяц(ОкончаниеПериодаЗагрузки),"ЧЦ=2;ЧДЦ=0;ЧВН=")+"/"+Формат(День(ОкончаниеПериодаЗагрузки),"ЧЦ=2;ЧДЦ=0;ЧВН=");
	Иначе
		Адрес = "tsv/cb/";
		ТМП   = "";
	КонецЕсли;
	
	Для Каждого Валюта из Валюты Цикл
		ФайлНаВебСервере = "http://" + СерверИсточник + "/" + Адрес + Прав(Валюта.КодВалюты, 3) + ТМП + ".tsv";
		
		#Если НаКлиенте Тогда
			Результат = ОбщиеКлиент.СкачатьФайлНаКлиенте(ФайлНаВебСервере); //ноу
		#Иначе
			Результат = ОбщиеСервер.СкачатьФайлНаСервере(ФайлНаВебСервере);  //ноу
		#КонецЕсли
		
		Если Результат.Статус Тогда
			#Если НаКлиенте Тогда
				ДвоичныеДанные = Новый ДвоичныеДанные (Результат.Путь);
				АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
				ПоясняющееСообщение = РаботаСКурсамиВалют.ЗагрузитьКурсВалютыИзФайла(Валюта.Валюта, АдресВоВременномХранилище, НачалоПериодаЗагрузки, ОкончаниеПериодаЗагрузки) + Символы.ПС;
			#Иначе
				ПоясняющееСообщение = РаботаСКурсамиВалют.ЗагрузитьКурсВалютыИзФайла(Валюта.Валюта, Результат.Путь, НачалоПериодаЗагрузки, ОкончаниеПериодаЗагрузки) + Символы.ПС;
			#КонецЕсли
			УдалитьФайлы(Результат.Путь);
			СтатусОперации = Истина;
		Иначе
			ПоясняющееСообщение= НСтр("ru = 'Не возможно получить файл данных с курсами валюты (%1 - %2):
			|%3
			|Возможно, нет доступа к веб сайту с курсами валют, либо указана несуществующая валюта.'");
			ПоясняющееСообщение = 
			ФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ПоясняющееСообщение,
			Валюта.КодВалюты,
			Валюта.Валюта,
			Результат.СообщениеОбОшибке);
			СтатусОперации = Ложь;
			ПриЗагрузкеВозниклиОшибки = Истина;
		КонецЕсли;
		
		СостояниеЗагрузки.Добавить(Новый Структура("Валюта,СтатусОперации,Сообщение", Валюта.Валюта, СтатусОперации, ПоясняющееСообщение));
		
	КонецЦикла;
	
	
	Возврат СостояниеЗагрузки;
	
КонецФункции

////////////////////////////////////////////////
Функция ПодЗаказ(НаСкладе,Количество) Экспорт 
	Если НаСкладе>=Количество Тогда
		КолЗаказ=0;
	ИначеЕсли Количество>НаСкладе Тогда
		КолЗаказ=Количество-НаСкладе;
	КонецЕсли;
	
	Возврат КолЗаказ;
КонецФункции
