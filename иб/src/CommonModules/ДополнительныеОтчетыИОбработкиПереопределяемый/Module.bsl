#Область ЭкспортныеПроцедурыИФункции

// Экспортная функция - интерфейс, определяет общие команды конфигурации,
// которые образуют рабочие места для вызова дополнительных обработок.
// Возвращаемое значение - массив, в котором нужно перечислить имена
// общих команд для вызова дополнительных обработок.
Функция ПолучитьОбщиеКомандыДополнительныхОбработок() Экспорт
	
	ТаблицаКоманд = ДополнительныеОтчетыИОбработки.ПолучитьТаблицуКоманд();
	
	ДополнительныеОтчетыИОбработки.ДобавитьКоманду(ТаблицаКоманд,
	"ДополнительныеОбработкиКВУ",
	НСтр("ru='Раздел ""Количественно-весовой учет""';en='Раздел ""Количественно-весовой учет""'"));
	
	ДополнительныеОтчетыИОбработки.ДобавитьКоманду(ТаблицаКоманд,
	"ДополнительныеОбработкиПУ",
	НСтр("ru='Раздел ""Племенной учет""';en='Раздел ""Племенной учет""'"));
	
	ДополнительныеОтчетыИОбработки.ДобавитьКоманду(ТаблицаКоманд,
	"ДополнительныеОбработкиУРЦ",
	НСтр("ru='Раздел ""Учет репродуктивного цикла""';en='Раздел ""Учет репродуктивного цикла""'"));
	
	ДополнительныеОтчетыИОбработки.ДобавитьКоманду(ТаблицаКоманд,
	"ДополнительныеОбработкиНормативноСправочнаяИнформация",
	НСтр("ru='Раздел ""НСИ""';en='Раздел ""НСИ""'"));
	
	ДополнительныеОтчетыИОбработки.ДобавитьКоманду(ТаблицаКоманд,
	"ДополнительныеОбработкиОценка",
	НСтр("ru='Раздел ""Оценка""';en='Раздел ""Оценка""'"));
	
	Возврат ТаблицаКоманд;
	
КонецФункции

// Экспортная функция - интерфейс, определяет общие команды конфигурации,
// которые образуют рабочие места для вызова дополнительны отчетов.
// Возвращаемое значение -  массив, в котором нужно перечислить имена
// общих команд для вызова дополнительных отчетов.
Функция ПолучитьОбщиеКомандыДополнительныхОтчетов() Экспорт
	
	ТаблицаКоманд = ДополнительныеОтчетыИОбработки.ПолучитьТаблицуКоманд();
	
	ДополнительныеОтчетыИОбработки.ДобавитьКоманду(ТаблицаКоманд,
	"ДополнительныеОтчетыКВУ",
	НСтр("ru='Раздел ""Количественно-весовой учет""';en='Раздел ""Количественно-весовой учет""'"));
	
	ДополнительныеОтчетыИОбработки.ДобавитьКоманду(ТаблицаКоманд,
	"ДополнительныеОтчетыПУ",
	НСтр("ru='Раздел ""Племенной учет""';en='Раздел ""Племенной учет""'"));
	
	ДополнительныеОтчетыИОбработки.ДобавитьКоманду(ТаблицаКоманд,
	"ДополнительныеОтчетыУРЦ",
	НСтр("ru='Раздел ""Учет репродуктивного цикла""';en='Раздел ""Учет репродуктивного цикла""'"));
	
	ДополнительныеОтчетыИОбработки.ДобавитьКоманду(ТаблицаКоманд,
	"ДополнительныеОтчетыНормативноСправочнаяИнформация",
	НСтр("ru='Раздел ""НСИ""';en='Раздел ""НСИ""'"));
	
	ДополнительныеОтчетыИОбработки.ДобавитьКоманду(ТаблицаКоманд,
	"ДополнительныеОбработкиОценка",
	НСтр("ru='Раздел ""Оценка""';en='Раздел ""Оценка""'"));
	
	Возврат ТаблицаКоманд;
	
КонецФункции

// Функция формирования печатной формы по внешнему источнику.
// ИсточникДанных - Произвольный - источник данных.
// ПараметрыИсточника - Произвольный - параметры источника печати.
//
// Параметры, заполняемые в функции:
// КоллекцияПечатныхФорм - ТаблицаЗначений - таблица печатных форм,
//					структура совпадает с той, что формируется при печати
///					обычным способом.
// ОбъектыПечати - СписокЗначений - список объектов для печати.
// ПараметрыВывода - Структура - ключи и значения совпадает с теми,
//					то формируется при печати обычным способом.
Функция ПечатьПоВнешнемуИсточнику(ИсточникДанных,
	ПараметрыИсточника) Экспорт
	
	Если ТипЗнч(ИсточникДанных) = Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки") Тогда
		ТабличныйДокументХранилище = ДополнительныеОтчетыИОбработки.ПечатьПоВнешнемуИсточнику(
		ИсточникДанных, ПараметрыИсточника);
	иначе
		ТабличныйДокументХранилище = Новый ХранилищеЗначения (Новый ТабличныйДокумент());		
	КонецЕсли;
	
	Возврат (ТабличныйДокументХранилище);
	
КонецФункции

#КонецОбласти