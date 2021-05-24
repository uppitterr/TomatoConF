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
	
	Макет = Документы.Отборы.ПолучитьМакет("ПечатнаяФорма");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Отборы.Ссылка,
	               |	Отборы.Номер,
	               |	Отборы.Дата,
	               |	Отборы.Ферма,
	               |	Отборы.Корпус,
	               |	Отборы.Сектор,
	               |	Отборы.Группа,
	               |	Отборы.ТехнолГруппа,
	               |	Отборы.Группировка
	               |ИЗ
	               |	Документ.Отборы КАК Отборы
				   |ГДЕ
	               |	Отборы.Ссылка В(&МассивСсылок)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Отборы.МоментВремени
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Отборы.Ссылка КАК Ссылка,
	               |	Отборы.НомерСтроки КАК НомерСтрокиСв,
	               |	Отборы.НомерГнездаОтъема НомерГнездаОСв,
	               |	Отборы.НомерГнезда НомерГнездаСв,
	               |	Отборы.СосковПравых ПСв,
	               |	Отборы.СосковЛевых ЛСв,
	               |	Отборы.Масса КАК МассаСв,
	               |	Отборы.Станок КАК СтанокСв,
	               |	Отборы.Свиноматка КАК Свинка,
	               |	Отборы.НомерСвиноматки
	               |ИЗ
	               |	Документ.Отборы.Свиноматки КАК Отборы
				   |ГДЕ
	               |	Отборы.Ссылка В(&МассивСсылок)
	               |УПОРЯДОЧИТЬ ПО
	               |	НомерСтроки,
	               |	Отборы.Ссылка.МоментВремени
	               |ИТОГИ
	               |	СУММА(Масса),
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Свинка)
	               |ПО
	               |	Ссылка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Отборы.Ссылка КАК Ссылка,
	               |	Отборы.НомерСтроки КАК НомерСтрокиХр,
	               |	Отборы.НомерГнездаОтъема НомерГнездаОХр,
	               |	Отборы.НомерГнезда КАК НомерГнездаХр,
	               |	Отборы.НомерХряка,
	               |	Отборы.СосковПравых КАК ПХр,
	               |	Отборы.СосковЛевых КАК ЛХр,
	               |	Отборы.Хряк КАК Хрячок,
	               |	Отборы.Масса КАК МассаХр,
	               |	Отборы.Станок КАК СтанокХр
	               |ИЗ
	               |	Документ.Отборы.Хряки КАК Отборы
				   |ГДЕ
	               |	Отборы.Ссылка В(&МассивСсылок)
	               |УПОРЯДОЧИТЬ ПО
	               |	Отборы.Ссылка.МоментВремени
	               |ИТОГИ
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Хрячок),
	               |	СУММА(Масса)
	               |ПО
	               |	Ссылка";	
	Запрос.УстановитьПараметр("МассивСсылок", МассивОбъектов);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	ДанныеШапки = МассивРезультатов[0].Выбрать();
	ВыборкаСвиноматки = МассивРезультатов[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ВыборкаХряки = МассивРезультатов[2].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ПервыйДокумент = Истина;
	СтруктураПоиска = Новый Структура ("Ссылка");
	
	Пока ДанныеШапки.Следующий() Цикл
		Если Не ПервыйДокумент Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		ПараметрФО = Новый Структура("Ферма", ДанныеШапки.Ферма);
		ИспользуетсяРазрезГруппировки = ПолучитьФункциональнуюОпцию("УчетВРазрезеГруппировок", ПараметрФО);
		ИспользуетсяРазрезТехнолГрупп = ПолучитьФункциональнуюОпцию("УчетВРазрезеТехнолГрупп", ПараметрФО);
		ИспользуетсяРазрезСекторов = ПолучитьФункциональнуюОпцию("УчетПоСекторам", ПараметрФО);
		ИспользуетсяРазрезСтанков = ПолучитьФункциональнуюОпцию("УчетПоСтанкам", ПараметрФО);


		// Вывод заголовка
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ТекстЗаголовка = ОбщегоНазначенияСервер.СформироватьЗаголовокДокумента(ДанныеШапки, НСтр("ru = 'Отбор ремонтного молодняка'; en = 'Selection of breeding gilts'"));
		ОбластьМакета.Параметры.ТекстЗаголовка = ТекстЗаголовка;
		ТабДок.Вывести(ОбластьМакета);
	
		// Вывод данных ферма
		Областьмакета = Макет.ПолучитьОбласть("ДанныеШапки");
		ОбластьМакета.Параметры.Заполнить(ДанныеШапки);
		ТабДок.Вывести(ОбластьМакета);
		
		Если ИспользуетсяРазрезСекторов Тогда
		Областьмакета = Макет.ПолучитьОбласть("КорпусСектор");
		ОбластьМакета.Параметры.Заполнить(ДанныеШапки);
		ТабДок.Вывести(ОбластьМакета);
		КонецЕсли;
	
		Областьмакета = Макет.ПолучитьОбласть("Группа");
		ОбластьМакета.Параметры.Заполнить(ДанныеШапки);
		ТабДок.Вывести(ОбластьМакета);
		
		Если ИспользуетсяРазрезТехнолГрупп Тогда
		Областьмакета = Макет.ПолучитьОбласть("ТехГруппа");
		ОбластьМакета.Параметры.Заполнить(ДанныеШапки);
		ТабДок.Вывести(ОбластьМакета);
		КонецЕсли;

	    Если ИспользуетсяРазрезГруппировки Тогда
		Областьмакета = Макет.ПолучитьОбласть("Группировка");
		ОбластьМакета.Параметры.Заполнить(ДанныеШапки);
		ТабДок.Вывести(ОбластьМакета);
		КонецЕсли;

		
		// вывод данных по свиноматкам
		СтруктураПоиска = ДанныеШапки.Ссылка;
		ЗаписиНайдены = ВыборкаСвиноматки.НайтиСледующий(СтруктураПоиска);
		Если ЗаписиНайдены Тогда
			ВыборкаДетали = ВыборкаСвиноматки.Выбрать();
			// вывод заголовка
			ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокСвиноматки");
			ТабДок.Вывести(ОбластьМакета);
			ОбластьШапки = Макет.ПолучитьОбласть("ШапкаСвиноматки");
			ОбластьДетали = Макет.ПолучитьОбласть("ДанныеСвиноматки");
			
			// вывод шапки
			ТабДок.Вывести(ОбластьШапки);
			Если  НЕ ИспользуетсяРазрезСтанков Тогда
				Смещать = ТипСмещенияТабличногоДокумента.ПоГоризонтали;
				Область = ТабДок.Область("ШапкаСтанокСв");
				ТабДок.УдалитьОбласть(Область, Смещать);
				Область2 = ТабДок.Область("ЗаголовокСтанокСв");
				ТабДок.УдалитьОбласть(Область2, Смещать);
			КонецЕсли;

			
			НомерСтроки = 1;
			Пока ВыборкаДетали.Следующий() Цикл
				 // вывод данных
				ОбластьДетали.Параметры.НомерСтрокиСв = НомерСтроки;
				ОбластьДетали.Параметры.Заполнить(ВыборкаДетали);
				ТабДок.Вывести(ОбластьДетали);
				Если  НЕ ИспользуетсяРазрезСтанков Тогда
				Смещать = ТипСмещенияТабличногоДокумента.ПоГоризонтали;
				Область = ТабДок.Область("ДанныеСтанокСв");
				ТабДок.УдалитьОбласть(Область, Смещать);
				КонецЕсли;
				НомерСтроки = НомерСтроки +1;
			КонецЦикла;
			
		// Вывод итогов
			ОбластьМакета = Макет.ПолучитьОбласть("ИтогиСвиноматки");
			ОбластьМакета.Параметры.ИтогоСвинок = ВыборкаСвиноматки.Свинка;
			ОбластьМакета.Параметры.ИтогоМассаСв = ВыборкаСвиноматки.МассаСв;
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
				Если  НЕ ИспользуетсяРазрезСтанков Тогда
				Смещать = ТипСмещенияТабличногоДокумента.ПоГоризонтали;
				Область = ТабДок.Область("ИтогиСтанокСв");
				ТабДок.УдалитьОбласть(Область, Смещать);
				КонецЕсли;
			КонецЕсли;
			   
		// вывод данных по хряка
		СтруктураПоиска = ДанныеШапки.Ссылка;
		
		ЗаписиНайдены = ВыборкаХряки.НайтиСледующий(СтруктураПоиска);
		Если ЗаписиНайдены Тогда
			ВыборкаДетали = ВыборкаХряки.Выбрать();
			// вывод заголовка
			ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокХряки");
			ТабДок.Вывести(ОбластьМакета);
			ОбластьШапки = Макет.ПолучитьОбласть("ШапкаХряки");
			ОбластьДетали = Макет.ПолучитьОбласть("ДанныеХряки");
			
			// вывод шапки
			ТабДок.Вывести(ОбластьШапки);
			Если  НЕ ИспользуетсяРазрезСтанков Тогда
				Смещать = ТипСмещенияТабличногоДокумента.ПоГоризонтали;
				Область = ТабДок.Область("ШапкаСтанокХр");
				ТабДок.УдалитьОбласть(Область, Смещать);
				Область2 = ТабДок.Область("ЗаголовокСтанокХр");
				ТабДок.УдалитьОбласть(Область2, Смещать);
			КонецЕсли;

			НомерСтроки = 1;
			Пока ВыборкаДетали.Следующий() Цикл
				 // вывод данных
				ОбластьДетали.Параметры.НомерСтрокиХр = НомерСтроки;
				ОбластьДетали.Параметры.Заполнить(ВыборкаДетали);
				ТабДок.Вывести(ОбластьДетали);
				Если  НЕ ИспользуетсяРазрезСтанков Тогда
				Смещать = ТипСмещенияТабличногоДокумента.ПоГоризонтали;
				Область = ТабДок.Область("ДанныеСтанокХр");
				ТабДок.УдалитьОбласть(Область, Смещать);
				КонецЕсли;
	
				НомерСтроки = НомерСтроки +1;
			КонецЦикла;
			
		// Вывод итогов
				ОбластьМакета = Макет.ПолучитьОбласть("ИтогиХряки");
				ОбластьМакета.Параметры.ИтогоХрячков = ВыборкаХряки.Хрячок;
			   ОбластьМакета.Параметры.ИтогоМассаХр = ВыборкаХряки.МассаХр;
			   Таб = Новый ТабличныйДокумент;
				Таб.Вывести(ОбластьДетали);
				Таб.Вывести(ОбластьМакета);
				Если Не ТабДок.ПроверитьВывод(Таб) Тогда
					Смещать = ТипСмещенияТабличногоДокумента.БезСмещения;
					Область = ТабДок.Область("ДанныеХряки");
					ТабДок.УдалитьОбласть(Область, Смещать);
					ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
					ОбластьДетали.Параметры.Заполнить(ВыборкаДетали);
					ТабДок.Вывести(ОбластьДетали);
				КонецЕсли;
               ТабДок.Вывести(ОбластьМакета);
			   	Если  НЕ ИспользуетсяРазрезСтанков Тогда
				Смещать = ТипСмещенияТабличногоДокумента.ПоГоризонтали;
				Область = ТабДок.Область("ИтогиСтанокХр");
				ТабДок.УдалитьОбласть(Область, Смещать);
				КонецЕсли;
         КонецЕсли;
	КонецЦикла;
	

		ТабДок.АвтоМасштаб = Истина;
		
		Возврат (ТабДок);
	КонецФункции
	
#КонецОбласти