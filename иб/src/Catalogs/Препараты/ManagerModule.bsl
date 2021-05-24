#Область Печати

Процедура Печать(ТабДок, Ссылка) Экспорт
	//{{_КОНСТРУКТОР_ПЕЧАТИ(Печать)
	Макет = Справочники.Препараты.ПолучитьМакет("Печать");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Препараты.Вакцина,
	|	Препараты.ДляПодсосных,
	|	Препараты.ЕдиницаДляОтчетов,
	|	Препараты.ЕдиницаИзмерения,
	|	Препараты.ЕдиницаХраненияОстатков,
	|	Препараты.Инструкция,
	|	Препараты.Картинка,
	|	Препараты.Код,
	|	Препараты.Кратность,
	|	Препараты.КратностьРаспределения,
	|	Препараты.МаксимальныйЗаказ,
	|	Препараты.Наименование,
	|	Препараты.НормаРаспределения,
	|	Препараты.НормаРасхода,
	|	Препараты.Описание,
	|	Препараты.ПолноеНаименование,
	|	Препараты.Производитель,
	|	Препараты.РекомендацииПоПрименению,
	|	Препараты.Состав,
	|	Препараты.СпособПрименения,
	|	Препараты.СпособРаспределенияЗаказа,
	|	Препараты.СпособСписания,
	|	Препараты.СрокВывода,
	|	Препараты.СтавкаНДС,
	|	Препараты.СтраховойЗапас,
	|	Препараты.ТипПрепарата,
	|	Препараты.ТочкаЗаказа,
	|	Препараты.ПоражаемыеЗаболевания.(
	|		Заболевание
	|	),
	|	Препараты.ПоражаемыеВозбудители.(
	|		Возбудитель
	|	)
	|ИЗ
	|	Справочник.Препараты КАК Препараты
	|ГДЕ
	|	Препараты.Ссылка В (&Ссылка)";
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьПоражаемыеЗаболеванияШапка = Макет.ПолучитьОбласть("ПоражаемыеЗаболеванияШапка");
	ОбластьПоражаемыеЗаболевания = Макет.ПолучитьОбласть("ПоражаемыеЗаболевания");
	ОбластьПоражаемыеВозбудителиШапка = Макет.ПолучитьОбласть("ПоражаемыеВозбудителиШапка");
	ОбластьПоражаемыеВозбудители = Макет.ПолучитьОбласть("ПоражаемыеВозбудители");
	ТабДок.Очистить();

	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		ТабДок.Вывести(ОбластьЗаголовок);

		Шапка.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(Шапка, Выборка.Уровень());

		ТабДок.Вывести(ОбластьПоражаемыеЗаболеванияШапка);
		ВыборкаПоражаемыеЗаболевания = Выборка.ПоражаемыеЗаболевания.Выбрать();
		Пока ВыборкаПоражаемыеЗаболевания.Следующий() Цикл
			ОбластьПоражаемыеЗаболевания.Параметры.Заполнить(ВыборкаПоражаемыеЗаболевания);
			ТабДок.Вывести(ОбластьПоражаемыеЗаболевания, ВыборкаПоражаемыеЗаболевания.Уровень());
		КонецЦикла;

		ТабДок.Вывести(ОбластьПоражаемыеВозбудителиШапка);
		ВыборкаПоражаемыеВозбудители = Выборка.ПоражаемыеВозбудители.Выбрать();
		Пока ВыборкаПоражаемыеВозбудители.Следующий() Цикл
			ОбластьПоражаемыеВозбудители.Параметры.Заполнить(ВыборкаПоражаемыеВозбудители);
			ТабДок.Вывести(ОбластьПоражаемыеВозбудители, ВыборкаПоражаемыеВозбудители.Уровень());
		КонецЦикла;

		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
	//}}
КонецПроцедуры

#КонецОбласти
