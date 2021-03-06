#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Инициализируем внутренние флаги
	ЭтоПлатформа83 = ОбщегоНазначенияКлиентСервер.ЭтоПлатформа83();
	
	МожноДобавлятьВСправочник = Справочники.СтраныМира.ЕстьПравоДобавления();
	
	Если Параметры.РазрешитьДанныеКлассификатора=Неопределено Тогда
		РазрешитьДанныеКлассификатора = Истина;
	Иначе
		ТипБулево = Новый ОписаниеТипов("Булево");
		РазрешитьДанныеКлассификатора = ТипБулево.ПривестиЗначение(Параметры.РазрешитьДанныеКлассификатора);
	КонецЕсли;
	
	ТолькоДанныеКлассификатора = Параметры.ТолькоДанныеКлассификатора;
	
	Параметры.Свойство("РежимВыбора", РежимВыбора);
	
	// Разрешаем элементы
	//Элементы.Список.РежимВыбора = РежимВыбора;
	//Элементы.СписокВыбрать.Видимость         = РежимВыбора;
	//Элементы.СписокВыбрать.КнопкаПоУмолчанию = РежимВыбора;
	
	Элементы.СписокВыбратьИзКлассификатора.Видимость = (РежимВыбора И Не ТолькоДанныеКлассификатора);
	Элементы.СписокКлассификатор.Видимость           = Не Элементы.СписокВыбратьИзКлассификатора.Видимость;
	
	// По флагам определяем режим
	Если РежимВыбора Тогда
		Если РазрешитьДанныеКлассификатора Тогда
			Если ТолькоДанныеКлассификатора Тогда
				Если МожноДобавлятьВСправочник Тогда 
					// Выбор только стран классификатора
					ОткрытьФормуКлассификатора = Истина
					
				Иначе
					// Показываем только пересечение справочника и классификатора
					УстановитьОтборПересеченияСКлассификатором();
					// Кнопки классификатора скрываем
					Элементы.СписокВыбратьИзКлассификатора.Видимость = Ложь;
					Элементы.СписокКлассификатор.Видимость           = Ложь;
				КонецЕсли;
				
			Иначе
				Если МожноДобавлятьВСправочник Тогда 
					// Показываем справочник и кнопку выбора из классификатора (установки по умолчанию)
				Иначе
					// Кнопки классификатора скрываем
					Элементы.СписокВыбратьИзКлассификатора.Видимость = Ложь;
					Элементы.СписокКлассификатор.Видимость           = Ложь;
				КонецЕсли;
			КонецЕсли;
			
		 Иначе
			// Показываем только элементы справочника
			Элементы.СписокКлассификатор.Видимость = Ложь;
			// Кнопки классификатора скрываем
			Элементы.СписокВыбратьИзКлассификатора.Видимость = Ложь;
			Элементы.СписокКлассификатор.Видимость           = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ОткрытьФормуКлассификатора Тогда
		// Выбор только стран классификатора, открываем его форму для выбора
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("РежимВыбора",        Истина);
		ПараметрыОткрытия.Вставить("ЗакрыватьПриВыборе", ЗакрыватьПриВыборе);
		ПараметрыОткрытия.Вставить("ТекущаяСтрока",      Элементы.Список.ТекущаяСтрока);
		ПараметрыОткрытия.Вставить("РежимОткрытияОкна",  РежимОткрытияОкна);
		ПараметрыОткрытия.Вставить("ТекущаяСтрока",      Элементы.Список.ТекущаяСтрока);
		
		ОткрытьФорму("Справочник.СтраныМира.Форма.Классификатор", ПараметрыОткрытия, ВладелецФормы);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия="Справочник.СтраныМира.Изменение" Тогда
		ОбновитьОтображениеСпискаСтран();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	ТекстВопроса = НСтр("ru='Есть возможность подобрать страну мира из классификатора."
"Подобрать?';en='Есть возможность подобрать страну мира из классификатора."
"Подобрать?'");
	Результат = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	Если Результат = КодВозвратаДиалога.Да Тогда
		Отказ = Истина;
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
		ОткрытьФорму("Справочник.СтраныМира.Форма.Классификатор", ПараметрыОткрытия, Элементы.Список);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если РежимВыбора Тогда
		// Выбор из классификатора
		ОповеститьОВыборе(ВыбранноеЗначение);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	ОбновитьОтображениеСпискаСтран();
КонецПроцедуры

#КонецОбласти

#Область ВспомогательныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьКлассификатор(Команда)
	// Открываем на просмотр
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ТекущаяСтрока", Элементы.Список.ТекущаяСтрока);
	ОткрытьФорму("Справочник.СтраныМира.Форма.Классификатор", ПараметрыОткрытия, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИзКлассификатора(Команда)
	// Открываем для выбора
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
	ПараметрыОткрытия.Вставить("ЗакрыватьПриВыборе", ЗакрыватьПриВыборе);
	ПараметрыОткрытия.Вставить("ТекущаяСтрока", Элементы.Список.ТекущаяСтрока);
	ПараметрыОткрытия.Вставить("РежимОткрытияОкна", РежимОткрытияОкна);
	ПараметрыОткрытия.Вставить("ТекущаяСтрока", Элементы.Список.ТекущаяСтрока);
	ОткрытьФорму("Справочник.СтраныМира.Форма.Классификатор", ПараметрыОткрытия, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтображениеСпискаСтран()
	
	Если ИдентификаторЭлементаОтбораСсылки<>Неопределено Тогда
		// Был наложен дополнительный отбор, который надо обновить
		УстановитьОтборПересеченияСКлассификатором();
	КонецЕсли;
	
	Элементы.Список.Обновить();
КонецПроцедуры
	
&НаСервере
Процедура УстановитьОтборПересеченияСКлассификатором()
	ОтборСписка = ?(ЭтоПлатформа83, Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор, Список.Отбор);
	
	Если ИдентификаторЭлементаОтбораСсылки=Неопределено Тогда
		ЭлементОтбора = ОтборСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("Ссылка");
		ЭлементОтбора.ВидСравнения     = ВидСравненияКомпоновкиДанных.ВСписке;
		ЭлементОтбора.Использование    = Истина;
		
		ИдентификаторЭлементаОтбораСсылки = ОтборСписка.ПолучитьИдентификаторПоОбъекту(ЭлементОтбора);
	Иначе
		ЭлементОтбора = ОтборСписка.ПолучитьОбъектПоИдентификатору(ИдентификаторЭлементаОтбораСсылки);
	КонецЕсли;
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	Код, Наименование
		|ПОМЕСТИТЬ
		|	Классификатор
		|ИЗ
		|	&Классификатор КАК Классификатор
		|ИНДЕКСИРОВАТЬ ПО
		|	Код, Наименование
		|;////////////////////////////////////////////////////////////
		|ВЫБРАТЬ 
		|	Ссылка
		|ИЗ
		|	Справочник.СтраныМира КАК СтраныМира
		|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|	Классификатор КАК Классификатор
		|ПО
		|	СтраныМира.Код = Классификатор.Код
		|	И СтраныМира.Наименование = Классификатор.Наименование
		|");
	Запрос.УстановитьПараметр("Классификатор", Справочники.СтраныМира.ТаблицаКлассификатора());
	ЭлементОтбора.ПравоеЗначение = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьИзКлассификатора(Команда)
	
	ТекстВопроса = "При выполнении операции классификатор стран (ОКСМ) будет
				   |полностью загружен в справочник. Продолжить?";
	Ответ = Вопрос (ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	Иначе
		ЗаполнитьИзКлассификатораНаСервере();
		Элементы.Список.Обновить();
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Процедура заполнения завершена";
		Сообщение.Сообщить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьИзКлассификатораНаСервере()
	
	ТаблицаКлассификатора = Справочники.СтраныМира.ТаблицаКлассификатора();

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаКлассификатора.Код,
		|	ТаблицаКлассификатора.Наименование,
		|	ТаблицаКлассификатора.НаименованиеПолное,
		|	ТаблицаКлассификатора.КодАльфа2,
		|	ТаблицаКлассификатора.КодАльфа3
		|ПОМЕСТИТЬ ТаблицаКлассификатора
		|ИЗ
		|	&ТаблицаКлассификатора КАК ТаблицаКлассификатора
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаКлассификатора.Код,
		|	ТаблицаКлассификатора.Наименование,
		|	ТаблицаКлассификатора.НаименованиеПолное,
		|	ТаблицаКлассификатора.КодАльфа2,
		|	ТаблицаКлассификатора.КодАльфа3,
		|	ЕСТЬNULL(СтраныМира.Ссылка, ЗНАЧЕНИЕ(Справочник.СтраныМира.ПустаяСсылка)) КАК СправочникСсылка
		|ИЗ
		|	ТаблицаКлассификатора КАК ТаблицаКлассификатора
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтраныМира КАК СтраныМира
		|		ПО ТаблицаКлассификатора.Код = СтраныМира.Код";
	Запрос.УстановитьПараметр("ТаблицаКлассификатора", ТаблицаКлассификатора);
	Результат = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.СправочникСсылка) Тогда
			СпрОбъект = ВыборкаДетальныеЗаписи.СправочникСсылка.ПолучитьОбъект();
		Иначе
			СпрОбъект = Справочники.СтраныМира.СоздатьЭлемент();
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(СпрОбъект, ВыборкаДетальныеЗаписи);
		СпрОбъект.Записать();		
	КонецЦикла;

КонецПроцедуры

#КонецОбласти
