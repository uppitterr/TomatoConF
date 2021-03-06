#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Элементы.Подбор.Отображение = ОтображениеТаблицы.Дерево;
	Элементы.Подбор.НачальноеОтображениеДерева = НачальноеОтображениеДерева.РаскрыватьВерхнийУровень;
	ВидНазначения = Параметры.ВидНазначения;
	Если ВидНазначения = "ВетеринарныеМероприятия" Тогда
		Подбор.ОсновнаяТаблица = "Справочник.ОздоровительныеМероприятия"; 
		Подбор.ТекстЗапроса =
		"ВЫБРАТЬ
		|	ВетеринарныеМероприятия.Ссылка,
		|	ВетеринарныеМероприятия.Родитель
		|ИЗ
		|	Справочник.ОздоровительныеМероприятия КАК ВетеринарныеМероприятия
		|ГДЕ
		|	ВетеринарныеМероприятия.ЭтоГруппа = ЛОЖЬ";
		Подбор.Группировка.Элементы.Очистить();
        ЭлементГруппировки = Подбор.Группировка.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
        ЭлементГруппировки.Использование = Истина;
        ЭлементГруппировки.Поле = Новый ПолеКомпоновкиДанных("Родитель");
	ИначеЕсли ВидНазначения = "ПереносчикиБолезни" Тогда
		Подбор.ОсновнаяТаблица = "Справочник.ПереносчикиБолезней";
		Подбор.ТекстЗапроса =
		"ВЫБРАТЬ
		|	ПереносчикиБолезней.Ссылка,
		|	ПереносчикиБолезней.Родитель
		|ИЗ
		|	Справочник.ПереносчикиБолезней КАК ПереносчикиБолезней
		|ГДЕ
		|	ПереносчикиБолезней.ЭтоГруппа = ЛОЖЬ";
		Подбор.Группировка.Элементы.Очистить();
        ЭлементГруппировки = Подбор.Группировка.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
        ЭлементГруппировки.Использование = Истина;
        ЭлементГруппировки.Поле = Новый ПолеКомпоновкиДанных("Родитель");
	ИначеЕсли ВидНазначения = "ПоражаемыеСистемы" Тогда
		Подбор.ОсновнаяТаблица = "Справочник.ПоражаемыеСистемы";
		Подбор.ТекстЗапроса =
		"ВЫБРАТЬ
		|	ПоражаемыеСистемы.Ссылка КАК ПоражаемыеСистемы,
		|	ПоражаемыеСистемы.Родитель
		|ИЗ
		|	Справочник.ПоражаемыеСистемы КАК ПоражаемыеСистемы
		|ГДЕ
		|	ПоражаемыеСистемы.ЭтоГруппа = ЛОЖЬ";
		Подбор.Группировка.Элементы.Очистить();
        ЭлементГруппировки = Подбор.Группировка.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
        ЭлементГруппировки.Использование = Истина;
        ЭлементГруппировки.Поле = Новый ПолеКомпоновкиДанных("Родитель");
	ИначеЕсли ВидНазначения = "ВозбудителиБолезни" Тогда
		Подбор.ОсновнаяТаблица = "Справочник.Возбудители";
		Подбор.ТекстЗапроса =
		"ВЫБРАТЬ
		|	Возбудители.Ссылка
		|ИЗ
		|	Справочник.Возбудители КАК Возбудители";
	ИначеЕсли ВидНазначения = "Литература" Тогда
		Подбор.ОсновнаяТаблица = "Справочник.Литература";
		Подбор.ТекстЗапроса =
		"ВЫБРАТЬ
		|	Литература.Ссылка,
		|	Литература.Родитель
		|ИЗ
		|	Справочник.Литература КАК Литература
		|ГДЕ
		|	Литература.ЭтоГруппа = ЛОЖЬ";
		Подбор.Группировка.Элементы.Очистить();
        ЭлементГруппировки = Подбор.Группировка.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
        ЭлементГруппировки.Использование = Истина;
        ЭлементГруппировки.Поле = Новый ПолеКомпоновкиДанных("Родитель");
	ИначеЕсли ВидНазначения = "ПризнакиБолезни" Тогда
		Подбор.ОсновнаяТаблица = "Справочник.ПризнакиБолезней";
		Подбор.ТекстЗапроса =
		"ВЫБРАТЬ
		|	ПризнакиБолезни.Ссылка,
		|	ПризнакиБолезни.Родитель
		|ИЗ
		|	Справочник.ПризнакиБолезней КАК ПризнакиБолезни
		|ГДЕ
		|	ПризнакиБолезни.ЭтоГруппа = ЛОЖЬ";
		Подбор.Группировка.Элементы.Очистить();
        ЭлементГруппировки = Подбор.Группировка.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
        ЭлементГруппировки.Использование = Истина;
        ЭлементГруппировки.Поле = Новый ПолеКомпоновкиДанных("Родитель");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НазначенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если НЕ Элемент.ТекущиеДанные.РодительскаяГруппировкаСтроки = Неопределено тогда
	ВыбранноеНазначение = ВыбранныеЭлементы.Добавить();
	ВыбранноеНазначение.Ссылка = Элемент.ТекущиеДанные.Ссылка;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеНазначенияПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
	Для Каждого НомерСтроки Из ПараметрыПеретаскивания.Значение Цикл
		СтрокаВыбора = Элементы.Подбор.ДанныеСтроки(НомерСтроки);
		Если НЕ Элементы.Подбор.ДанныеСтроки(НомерСтроки).РодительскаяГруппировкаСтроки = Неопределено тогда
		ВыбранноеНазначение = ВыбранныеЭлементы.Добавить();
		ВыбранноеНазначение.Ссылка = СтрокаВыбора.Ссылка;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область ВспомогательныеПроцедурыИФункции

&НаКлиенте
Процедура Перенести(Команда)
	ОповеститьОВыборе(ВыбранныеЭлементы);
 	Закрыть();
КонецПроцедуры

#КонецОбласти




