
Процедура Печать(ТабДок, Ссылка) Экспорт
	//{{_КОНСТРУКТОР_ПЕЧАТИ(Печать)
	Макет = Справочники.СписокГеновТомата.ПолучитьМакет("Печать");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СписокГеновТомата.Gene,
	|	СписокГеновТомата.GeneName,
	|	СписокГеновТомата.ТаблицаГенов.(
	|		Gene,
	|		GeneName,
	|		Allele,
	|		AlleleName,
	|		Synonyms,
	|		Phenotype,
	|		Notes,
	|		About
	|	)
	|ИЗ
	|	Справочник.СписокГеновТомата КАК СписокГеновТомата
	|ГДЕ
	|	СписокГеновТомата.Ссылка В (&Ссылка)";
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьТаблицаГеновШапка = Макет.ПолучитьОбласть("ТаблицаГеновШапка");
	ОбластьТаблицаГенов = Макет.ПолучитьОбласть("ТаблицаГенов");
	ТабДок.Очистить();

	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		ТабДок.Вывести(ОбластьЗаголовок);

		Шапка.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(Шапка, Выборка.Уровень());

		ТабДок.Вывести(ОбластьТаблицаГеновШапка);
		ВыборкаТаблицаГенов = Выборка.ТаблицаГенов.Выбрать();
		Пока ВыборкаТаблицаГенов.Следующий() Цикл
			ОбластьТаблицаГенов.Параметры.Заполнить(ВыборкаТаблицаГенов);
			ТабДок.Вывести(ОбластьТаблицаГенов, ВыборкаТаблицаГенов.Уровень());
		КонецЦикла;

		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
	//}}
КонецПроцедуры
