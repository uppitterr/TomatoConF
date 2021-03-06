#Область ПечатьДокумента
		
// Выполняет вывод печатной формы.
// Параметры:
//	ИмяМакета - имя макета печатной формы.
//	МассивОбъектов - массив содержащий ссылки на объекты для которых необходимо выполнить вывод печатной формы.
Функция Печать (ИмяМакета, МассивОбъектов) экспорт
	
	Если ИмяМакета = "ПечатнаяФорма" Тогда
		Результат = СформироватьПечатнуюФормуДокумента (МассивОбъектов);
	КонецЕсли;	
	
	Возврат (Новый ХранилищеЗначения (Результат));
	
КонецФункции

Функция СформироватьПечатнуюФормуДокумента (МассивОбъектов)
	
	ТабДок = Новый ТабличныйДокумент;
	Табдок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Ложь;
	ТабДок.ОтображатьЗаголовки = Ложь;
	
	Макет = Документы.Опыление.ПолучитьМакет("ПечатнаяФорма");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Опыление.Ссылка,
	               |	Опыление.Номер,
	               |	Опыление.Дата,
	               |	Опыление.Ферма,
	               |	Опыление.МоментВремени КАК МоментВремени
	               |ИЗ
	               |	Документ.Опыление КАК Опыление
				   |ГДЕ
	               |	Опыление.Ссылка В(&МассивСсылок)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	МоментВремени
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Опыление.Ссылка КАК Ссылка,
	               |	Опыление.Свиноматка КАК Свиноматка,
	               |	Опыление.Хряк,
	               |	Опыление.Хряк2,
	               |	Опыление.Хряк3,
	               |	Опыление.НомерСтроки КАК НомерСтроки
	               |ИЗ
	               |	Документ.Опыление.Свиноматки КАК Опыление	               
				   |ГДЕ
	               |	Опыление.Ссылка В(&МассивСсылок)
	               |УПОРЯДОЧИТЬ ПО
	               |	НомерСтроки,
	               |	Опыление.Ссылка.МоментВремени
	               |ИТОГИ
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Свиноматка)
	               |ПО
	               |	Ссылка";
	
	Запрос.УстановитьПараметр("МассивСсылок", МассивОбъектов);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	ДанныеШапки = МассивРезультатов[0].Выбрать();
	ВыборкаСвиноматки = МассивРезультатов[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ПервыйДокумент = Истина;
	СтруктураПоиска = Новый Структура ("Ссылка");
	
	Пока ДанныеШапки.Следующий() Цикл
		Если Не ПервыйДокумент Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		// Вывод заголовка
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ТекстЗаголовка = ОбщегоНазначенияСервер.СформироватьЗаголовокДокумента(ДанныеШапки, НСтр("ru = 'Осеменение'; en = 'Insemination'"));
		ОбластьМакета.Параметры.ТекстЗаголовка = ТекстЗаголовка;
		ТабДок.Вывести(ОбластьМакета);
	
		// Вывод данных ферма
		Областьмакета = Макет.ПолучитьОбласть("ДанныеШапки");
		ОбластьМакета.Параметры.Заполнить(ДанныеШапки);
		ТабДок.Вывести(ОбластьМакета);
		
		// вывод данных по свиноматкам
		СтруктураПоиска = ДанныеШапки.Ссылка;
		

		ЗаписиНайдены = ВыборкаСвиноматки.НайтиСледующий(СтруктураПоиска);
			ВыборкаДетали = ВыборкаСвиноматки.Выбрать();
			// вывод заголовка
			ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокСвиноматки");
			ТабДок.Вывести(ОбластьМакета);
			ОбластьШапки = Макет.ПолучитьОбласть("ШапкаСвиноматки");
			ОбластьДетали = Макет.ПолучитьОбласть("ДанныеСвиноматки");
			
			// вывод шапки
			ТабДок.Вывести(ОбластьШапки);
			
			НомерСтроки = 1;
			Пока ВыборкаДетали.Следующий() Цикл
				 // вывод данных
				ОбластьДетали.Параметры.НомерСтроки = НомерСтроки;
				ОбластьДетали.Параметры.Заполнить(ВыборкаДетали);
				ТабДок.Вывести(ОбластьДетали);
				НомерСтроки = НомерСтроки +1;
			КонецЦикла;
		
		// Вывод итогов
				ОбластьМакета = Макет.ПолучитьОбласть("ИтогиСвиноматки");
				ОбластьМакета.Параметры.ИтогоСвиноматок=ВыборкаСвиноматки.Свиноматка;
				Таб = Новый ТабличныйДокумент;
				Таб.Вывести(ОбластьДетали);
				Таб.Вывести(ОбластьМакета);
				Если Не ТабДок.ПроверитьВывод(Таб) Тогда
					Смещать = ТипСмещенияТабличногоДокумента.БезСмещения;
					Область = ТабДок.Область("ДанныеСвиноматки");
					ТабДок.УдалитьОбласть(Область, Смещать);
					ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
					ОбластьДетали.Параметры.Заполнить(ВыборкаДетали);
					ТабДок.Вывести(ОбластьДетали);
				КонецЕсли;

                ТабДок.Вывести(ОбластьМакета);
	КонецЦикла;
	

		ТабДок.АвтоМасштаб = Истина;
		
		Возврат (ТабДок);
	КонецФункции
	
#КонецОбласти

	
	
	
	

