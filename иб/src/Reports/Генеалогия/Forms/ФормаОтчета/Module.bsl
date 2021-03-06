#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура СхемаВыбор(Элемент)
	
	если НЕ Элемент.ТекущийЭлемент = Неопределено тогда
		если Элемент.ТекущийЭлемент.Имя = "Животное" тогда
			Возврат;
		КонецЕсли;
		
		УсловиеПоиска = Новый Структура ("Признак", Элемент.ТекущийЭлемент.Имя);
		СтрПоиска = ДанныеГенеалогическогоДерева.НайтиСтроки(УсловиеПоиска);
		если СтрПоиска.Количество() = 0 тогда
			Возврат;
		иначе
			ПараметрыФормы = Новый Структура ("Ключ", СтрПоиска[0].Ссылка);
			если ТипЗнч(СтрПоиска[0].Ссылка) = Тип("СправочникСсылка.сжсвСвиноматки") тогда
				ОткрытьФорму("Справочник.сжсвСвиноматки.ФормаОбъекта", ПараметрыФормы);
			иначе
				ОткрытьФорму("Справочник.сжсвХряки.ФормаОбъекта", ПараметрыФормы);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Животное = Параметры.Животное;
	ВыполнитьВыводГенеалогическогоДерева();
	
КонецПроцедуры

#КонецОбласти

#Область ВспомогательныеПроцедурыИФункции

&НаСервере
Процедура ВыполнитьВыводГенеалогическогоДерева()
	
	Схема = РеквизитФормыВЗначение("Отчет").ПолучитьМакет("ГенеалогическоеДерево");
		
	ЗаполнитьДанныеГенеалогическогоДерева(Животное);
	для каждого Строка из ДанныеГенеалогическогоДерева цикл
		Схема.ЭлементыГрафическойСхемы[Строка.Признак].Наименование = Строка.Представление;
	КонецЦикла;
	
	ПризнакиПредков = ПолучитьПолныйСписокПризнаковПредков();
	УсловиеПоиска = Новый Структура ("Признак");
	для каждого Признак из ПризнакиПредков цикл
		УсловиеПоиска.Признак = Признак;
		СтрПоиска = ДанныеГенеалогическогоДерева.НайтиСтроки(УсловиеПоиска);
		если СтрПоиска.Количество()= 0 тогда
			Схема.ЭлементыГрафическойСхемы[Признак].ЦветФона = WebЦвета.СветлоСерый;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеГенеалогическогоДерева(ЖивотноеСсылка)
	
	ТаблицаВыборкиПредков = Новый ТаблицаЗначений;
	ТаблицаВыборкиПредков.Колонки.Добавить("Ссылка");
	ТаблицаВыборкиПредков.Колонки.Добавить("Признак");
	ТаблицаВыборкиПредков.Колонки.Добавить("Уровень");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Справочник.Ссылка,
				   |	Справочник.Наименование КАК Наименование,
				   |	Справочник.ДополнительныйНомер КАК ДопНомер1,
	               |	Справочник.Мать,
	               |	Справочник.Мать.Наименование КАК МатьНаименование,
	               |	Справочник.Мать.ДополнительныйНомер КАК МатьДопНомер1,
	               |	Справочник.Отец,
	               |	Справочник.Отец.Наименование КАК ОтецНаименование,
	               |	Справочник.Отец.ДополнительныйНомер КАК ОтецДопНомер1
	               |ИЗ
	               |	Справочник." + ?(ТипЗнч(ЖивотноеСсылка)=Тип("СправочникСсылка.сжсвСвиноматки"), "сжсвСвиноматки", "сжсвХряки")+ " КАК Справочник
	               |ГДЕ
	               |	Справочник.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ЖивотноеСсылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	НовСтр = ДанныеГенеалогическогоДерева.Добавить();
	НовСтр.Ссылка = ЖивотноеСсылка;
	ПредставлениеЖивотного = Выборка.Наименование;
	если ЗначениеЗаполнено(Выборка.ДопНомер1) тогда
		ПредставлениеЖивотного = ПредставлениеЖивотного + " (" + Выборка.ДопНомер1 + ")";
	КонецЕсли;
	НовСтр.Представление = ПредставлениеЖивотного;
	НовСтр.Признак = "Животное";
	
	если ЗначениеЗаполнено(Выборка.Мать) тогда
		НовСтр = ДанныеГенеалогическогоДерева.Добавить();
		НовСтр.Ссылка = Выборка.Мать;
		ПредставлениеЖивотного = НСтр("en = 'M: '; ru = 'М: '") + Выборка.МатьНаименование;
		если ЗначениеЗаполнено(Выборка.МатьДопНомер1) тогда
			ПредставлениеЖивотного = ПредставлениеЖивотного + " (" + Выборка.МатьДопНомер1 + ")";
		КонецЕсли;
		НовСтр.Представление = ПредставлениеЖивотного;
		НовСтр.Признак = "М";
		
		НовСтр = ТаблицаВыборкиПредков.Добавить();
		НовСтр.Ссылка = Выборка.Мать;
		НовСтр.Признак = "М";
		НовСтр.Уровень = 1;
	КонецЕсли;
	
	если ЗначениеЗаполнено(Выборка.Отец) тогда
		НовСтр = ДанныеГенеалогическогоДерева.Добавить();
		НовСтр.Ссылка = Выборка.Отец;
		ПредставлениеЖивотного = НСтр("en = 'F: '; ru = 'О: '") + Выборка.ОтецНаименование;
		если ЗначениеЗаполнено(Выборка.ОтецДопНомер1) тогда
			ПредставлениеЖивотного = ПредставлениеЖивотного + " (" + Выборка.ОтецДопНомер1 + ")";
		КонецЕсли;
		НовСтр.Представление = ПредставлениеЖивотного;
		НовСтр.Признак = "О";
		
		НовСтр = ТаблицаВыборкиПредков.Добавить();
		НовСтр.Ссылка = Выборка.Отец;
		НовСтр.Признак = "О";
		НовСтр.Уровень = 1;
	КонецЕсли;
	
	пока ТаблицаВыборкиПредков.Количество() > 0 цикл
		ТекСтр = ТаблицаВыборкиПредков[0];
		
		Запрос.Текст = "ВЫБРАТЬ
	               |	Справочник.Ссылка,
	               |	Справочник.Мать,
	               |	Справочник.Мать.Наименование КАК МатьНаименование,
	               |	Справочник.Мать.ДополнительныйНомер КАК МатьДопНомер1,
	               |	Справочник.Отец,
	               |	Справочник.Отец.Наименование КАК ОтецНаименование,
	               |	Справочник.Отец.ДополнительныйНомер КАК ОтецДопНомер1
	               |ИЗ
	               |	Справочник." + ?(ТипЗнч(ТекСтр.Ссылка)=Тип("СправочникСсылка.сжсвСвиноматки"), "сжсвСвиноматки", "сжсвХряки")+ " КАК Справочник
	               |ГДЕ
	               |	Справочник.Ссылка = &Ссылка";
		Запрос.УстановитьПараметр("Ссылка", ТекСтр.Ссылка);
		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		
		если ЗначениеЗаполнено(Выборка.Мать) тогда
			НовСтр = ДанныеГенеалогическогоДерева.Добавить();
			НовСтр.Ссылка = Выборка.Мать;
			ПредставлениеЖивотного = НСтр("en = 'M'; ru = 'М'") + ТекСтр.Признак + ": " + Выборка.МатьНаименование;
			если ЗначениеЗаполнено(Выборка.МатьДопНомер1) тогда
				ПредставлениеЖивотного = ПредставлениеЖивотного + " (" + Выборка.МатьДопНомер1 + ")";
			КонецЕсли;
			НовСтр.Представление = ПредставлениеЖивотного;
			НовСтр.Признак = "М" + ТекСтр.Признак;
			
			если ТекСтр.Уровень < 3 тогда
				НовСтр = ТаблицаВыборкиПредков.Добавить();
				НовСтр.Ссылка = Выборка.Мать;
				НовСтр.Признак = "М" + ТекСтр.Признак;
				НовСтр.Уровень = ТекСтр.Уровень + 1;
			КонецЕсли;
		КонецЕсли;
		
		если ЗначениеЗаполнено(Выборка.Отец) тогда
			НовСтр = ДанныеГенеалогическогоДерева.Добавить();
			НовСтр.Ссылка = Выборка.Отец;
			ПредставлениеЖивотного = НСтр("en = 'F'; ru = 'О'") + ТекСтр.Признак + ": " + Выборка.ОтецНаименование;
			если ЗначениеЗаполнено(Выборка.ОтецДопНомер1) тогда
				ПредставлениеЖивотного = ПредставлениеЖивотного + " (" + Выборка.ОтецДопНомер1 + ")";
			КонецЕсли;
			НовСтр.Представление = ПредставлениеЖивотного;
			НовСтр.Признак = "О" + ТекСтр.Признак;
			
			если ТекСтр.Уровень < 3 тогда
				НовСтр = ТаблицаВыборкиПредков.Добавить();
				НовСтр.Ссылка = Выборка.Отец;
				НовСтр.Признак = "О" + ТекСтр.Признак;;
				НовСтр.Уровень = ТекСтр.Уровень + 1;
			КонецЕсли;
		КонецЕсли;
		
		ТаблицаВыборкиПредков.Удалить(ТекСтр);
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПолныйСписокПризнаковПредков()
	
	Результат = Новый Массив;
	Результат.Добавить("М");
	Результат.Добавить("ММ");
	Результат.Добавить("ОМ");
	Результат.Добавить("МММ");
	Результат.Добавить("МОМ");
	Результат.Добавить("ОММ");
	Результат.Добавить("ООМ");
	Результат.Добавить("ММММ");
	Результат.Добавить("ММОМ");
	Результат.Добавить("ОМММ");
	Результат.Добавить("ОМОМ");
	Результат.Добавить("МОММ");
	Результат.Добавить("МООМ");
	Результат.Добавить("ООММ");
	Результат.Добавить("ОООМ");
	Результат.Добавить("О");
	Результат.Добавить("МО");
	Результат.Добавить("ОО");
	Результат.Добавить("ММО");
	Результат.Добавить("МОО");
	Результат.Добавить("ОМО");
	Результат.Добавить("ООО");
	Результат.Добавить("МММО");
	Результат.Добавить("ММОО");
	Результат.Добавить("ОММО");
	Результат.Добавить("ОМОО");
	Результат.Добавить("МОМО");
	Результат.Добавить("МООО");
	Результат.Добавить("ООМО");
	Результат.Добавить("ОООО");
	Возврат (Результат);
	
КонецФункции

&НаКлиенте
Процедура Обновить(Команда)
	
	ВыполнитьВыводГенеалогическогоДерева();	
	
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	
	Схема.Напечатать(РежимИспользованияДиалогаПечати.Использовать);
	
КонецПроцедуры

#КонецОбласти

