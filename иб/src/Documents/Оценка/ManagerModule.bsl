#Область ПечатьДокумента

// Выполняет вывод печатной формы.
// Параметры:
//	ИмяМакета - имя макета печатной формы.
//	МассивОбъектов - массив содержащий ссылки на объекты для которых необходимо выполнить вывод печатной формы.
Функция Печать (ИмяМакета, МассивОбъектов) экспорт
	
	если ИмяМакета = "ФормаСП43" тогда
		Результат = СформироватьПечатнуюФормуСП43(МассивОбъектов);
	ИначеЕсли ИмяМакета = "ПечатнаяФорма" Тогда
		Результат = СформироватьПечатнуюФормуДокумента (МассивОбъектов);
	КонецЕсли;	
	
	Возврат (Новый ХранилищеЗначения (Результат));
	
КонецФункции

Функция СформироватьПечатнуюФормуСП43 (МассивОбъектов)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ОтображатьСетку = Ложь;
	ТабличныйДокумент.Защита = Ложь;
	ТабличныйДокумент.ТолькоПросмотр = Ложь;
	ТабличныйДокумент.ОтображатьЗаголовки = Ложь;

	Макет = Документы.Оценка.ПолучитьМакет("ФормаСП43");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Оценка.Ссылка КАК Ссылка,
	               |	Оценка.Номер,
	               |	Оценка.Дата,
	               |	Оценка.Ферма,
	               |	ЕСТЬNULL(Оценка.Ферма.Хозяйство, ЗНАЧЕНИЕ(Справочник.сжсвХозяйства.ПустаяСсылка)) КАК Организация,
	               |	Оценка.Сектор КАК Бригада,
	               |	ЕСТЬNULL(Зоотехник.Сотрудник, ЗНАЧЕНИЕ(Справочник.сжсвДолжности.ПустаяСсылка)) КАК Зоотехник,
	               |	ЕСТЬNULL(Управляющий.Сотрудник, ЗНАЧЕНИЕ(Справочник.сжсвДолжности.ПустаяСсылка)) КАК Бригадир,
	               |	Оценка.Представление,
	               |	Ответственные.Ответственный,
	               |	Оценка.ТехнолГруппа КАК Группа,
	               |	Оценка.ТехнолГруппа.Сотрудник КАК Сотрудник
	               |ИЗ
	               |	Документ.Оценка КАК Оценка
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.сжсвСотрудникиФерм КАК Зоотехник
	               |		ПО Оценка.Ферма = Зоотехник.Ферма
	               |			И (Зоотехник.Должность = ЗНАЧЕНИЕ(Справочник.сжсвДолжности.Зоотехник))
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.сжсвСотрудникиФерм КАК Управляющий
	               |		ПО Оценка.Ферма = Управляющий.Ферма
	               |			И (Управляющий.Должность = ЗНАЧЕНИЕ(Справочник.сжсвДолжности.Управляющий))
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.сжсвОтветственные.СрезПоследних(&ДатаДокумента, ) КАК Ответственные
	               |		ПО Оценка.Сектор = Ответственные.ОбъектОтветственности
	               |ГДЕ
	               |	Оценка.Ссылка В(&МассивСсылка)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Оценка.МоментВремени
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	сжсвОценкаСвиноматки.Ссылка КАК Ссылка,
	               |	сжсвОценкаСвиноматки.Свиноматка КАК Представление,
	               |	ЕСТЬNULL(сжсвОценкаСвиноматки.Масса, 0) КАК Масса,
	               |	ЕСТЬNULL(сжсвЖивотныеВНаличииОстатки.МассаОстаток, 0) КАК МассаПослВзв,
	               |	ЕСТЬNULL(сжсвОценкаСвиноматки.Масса - сжсвЖивотныеВНаличииОстатки.МассаОстаток, 0) КАК Привес,
	               |	1 КАК КоличествоГолов,
	               |	сжсвОценкаСвиноматки.Свиноматка.Представление КАК НомерЖивотного
	               |ИЗ
	               |	Документ.Оценка.Свиноматки КАК сжсвОценкаСвиноматки
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.сжсвЖивотныеВНаличии.Остатки(&ДатаДокумента, ) КАК сжсвЖивотныеВНаличииОстатки
	               |		ПО сжсвОценкаСвиноматки.Свиноматка = сжсвЖивотныеВНаличииОстатки.Свиноматка
	               |ГДЕ
	               |	сжсвОценкаСвиноматки.Ссылка В(&МассивСсылка)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	сжсвОценкаСвиноматки.Ссылка.МоментВремени,
	               |	сжсвОценкаСвиноматки.НомерСтроки
	               |ИТОГИ
	               |	СУММА(Масса),
	               |	СУММА(МассаПослВзв),
	               |	СУММА(Привес),
	               |	СУММА(КоличествоГолов)
	               |ПО
	               |	Ссылка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	сжсвОценкаХряки.Ссылка КАК Ссылка,
	               |	сжсвОценкаХряки.Хряк КАК Представление,
	               |	ЕСТЬNULL(сжсвОценкаХряки.Масса, 0) КАК Масса,
	               |	ЕСТЬNULL(сжсвЖивотныеВНаличииОстатки.МассаОстаток, 0) КАК МассаПослВзв,
	               |	ЕСТЬNULL(сжсвОценкаХряки.Масса - сжсвЖивотныеВНаличииОстатки.МассаОстаток, 0) КАК Привес,
	               |	1 КАК КоличествоГолов,
	               |	сжсвОценкаХряки.Хряк.Представление КАК НомерЖивотного
	               |ИЗ
	               |	Документ.Оценка.Хряки КАК сжсвОценкаХряки
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.сжсвЖивотныеВНаличии.Остатки(&ДатаДокумента, ) КАК сжсвЖивотныеВНаличииОстатки
	               |		ПО сжсвОценкаХряки.Хряк = сжсвЖивотныеВНаличииОстатки.Хряк
	               |ГДЕ
	               |	сжсвОценкаХряки.Ссылка В(&МассивСсылка)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	сжсвОценкаХряки.Ссылка.МоментВремени,
	               |	сжсвОценкаХряки.НомерСтроки
	               |ИТОГИ
	               |	СУММА(Масса),
	               |	СУММА(МассаПослВзв),
	               |	СУММА(Привес),
	               |	СУММА(КоличествоГолов)
	               |ПО
	               |	Ссылка";
				   
				   
	Индекс = 0;
	СпскЗнач = Новый СписокЗначений;
	МассивОбъектов_Нов = Новый Массив;
	пока Индекс < МассивОбъектов.Количество() цикл
		МассивОбъектов_Нов.Добавить(МассивОбъектов[Индекс].Дата);
		Индекс = Индекс + 1;
	конеццикла;
	
	СпскЗнач.ЗагрузитьЗначения(МассивОбъектов_Нов);	
	СпскЗнач.СортироватьПоЗначению(НаправлениеСортировки.Возр);
	
	МассивОбъектов_Нов = СпскЗнач.ВыгрузитьЗначения();
	
	Запрос.УстановитьПараметр("МассивСсылка",МассивОбъектов);
	Запрос.УстановитьПараметр("ДатаДокумента", МассивОбъектов_Нов[0]);	
	
	Выборка = Запрос.ВыполнитьПакет();
	ДанныеШапки = Выборка[0].Выбрать();
	ВыборкаСвиноматки = Выборка[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам) ;
	ВыборкаХряки = Выборка[2].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам) ;
	
	ПервыйДокумент = истина;
	СтруктураПоиска = Новый Структура ("Ссылка");	
	
	пока ДанныеШапки.Следующий() цикл
		если НЕ ПервыйДокумент тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли; 
		
		ПервыйДокумент = ложь;
        ТекстЗаголовка = ОбщегоНазначенияСервер.СформироватьЗаголовокДокумента(ДанныеШапки, "Ведомость ");
		
	    СтруктураПоиска.Ссылка = ДанныеШапки.Ссылка;
		ОбластьЗаголовка = Макет.ПолучитьОбласть("Заголовок");
		ОбластьЗаголовка.Параметры.Заполнить(ДанныеШапки);
		Если ЗначениеЗаполнено(ДанныеШапки.Группа) тогда
			 ОбластьЗаголовка.Параметры.Ответственный = ДанныеШапки.Сотрудник;
		иначе
			 ОбластьЗаголовка.Параметры.Ответственный = ДанныеШапки.Ответственный;
		конецесли;

		ОбластьЗаголовка.Параметры.ДатаД = Формат(ДанныеШапки.Дата,"ДФ=дд") ;
		ОбластьЗаголовка.Параметры.ДатаМ = Формат(ДанныеШапки.Дата,"ДФ=ММ") ;
		ОбластьЗаголовка.Параметры.ДатаГ = Формат(ДанныеШапки.Дата,"ДФ=гг") ;
		ОбластьЗаголовка.Параметры.Номер = ТекстЗаголовка;
	    ТабличныйДокумент.Вывести(ОбластьЗаголовка);
		
		ОбластьШапка = Макет.ПолучитьОбласть("Шапка");		
		ТабличныйДокумент.Вывести(ОбластьШапка);
        Четное = ложь;
		ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
		
		КоличествоГоловСвиноматки = 0;
		КоличествоГоловХряки = 0;
		Масса = 0;
		Масса2 = 0;
		Привес = 0;
		Привес2 = 0;
                     				
		ЗаписиНайдены = ВыборкаСвиноматки.НайтиСледующий(СтруктураПоиска);
		///------////
		если ЗаписиНайдены тогда				
			Выборка_Свиноматки = ВыборкаСвиноматки.Выбрать();			
			пока Выборка_Свиноматки.Следующий() цикл
				
				если не Четное тогда 
					ОбластьСтрока.Параметры.НомерЖивотного = Выборка_Свиноматки.НомерЖивотного;
					ОбластьСтрока.Параметры.КоличествоГолов = Выборка_Свиноматки.КоличествоГолов;
					ОбластьСтрока.Параметры.МассаПослВзв = Выборка_Свиноматки.МассаПослВзв;
					ОбластьСтрока.Параметры.Масса = Выборка_Свиноматки.Масса;
					ОбластьСтрока.Параметры.Привес = Выборка_Свиноматки.Привес;					
					Четное = истина;
					
					Масса = Масса + ОбластьСтрока.Параметры.Масса;
					Если ОбластьСтрока.Параметры.Привес <> Null тогда
						Привес = Привес + ОбластьСтрока.Параметры.Привес;
					Иначе
						Привес = 0;
					КонецЕсли;
					
				иначе
					ОбластьСтрока.Параметры.НомерЖивотного2 = Выборка_Свиноматки.НомерЖивотного;
					ОбластьСтрока.Параметры.КоличествоГолов2 = Выборка_Свиноматки.КоличествоГолов;
					ОбластьСтрока.Параметры.МассаПослВзв2 = Выборка_Свиноматки.МассаПослВзв;
					ОбластьСтрока.Параметры.Масса2 = Выборка_Свиноматки.Масса;
					ОбластьСтрока.Параметры.Привес2 = Выборка_Свиноматки.Привес;					
					Четное = ложь;
				    ТабличныйДокумент.Вывести(ОбластьСтрока);
					
					Масса2 = Масса2 + ОбластьСтрока.Параметры.Масса2;
					Если ОбластьСтрока.Параметры.Привес2 <> Null тогда
						Привес2 = Привес2 + ОбластьСтрока.Параметры.Привес2;
					Иначе
						Привес2 = 0;
					КонецЕсли;

				конецесли;
				КоличествоГоловСвиноматки = КоличествоГоловСвиноматки + Выборка_Свиноматки.КоличествоГолов;
			конеццикла;	
		конецесли;
		///-----////		
		
		ЗаписиНайдены = ВыборкаХряки.НайтиСледующий(СтруктураПоиска);
		///------////
		если ЗаписиНайдены тогда			 
			Выборка_Хряки = ВыборкаХряки.Выбрать();		    			
			пока Выборка_Хряки.Следующий() цикл
				
				если не Четное тогда
					ОбластьСтрока.Параметры.НомерЖивотного = Выборка_Хряки.НомерЖивотного;
					ОбластьСтрока.Параметры.КоличествоГолов = Выборка_Хряки.КоличествоГолов;
					ОбластьСтрока.Параметры.МассаПослВзв = Выборка_Хряки.МассаПослВзв;
					ОбластьСтрока.Параметры.Масса = Выборка_Хряки.Масса;
					ОбластьСтрока.Параметры.Привес = Выборка_Хряки.Привес;					
					Четное = истина;
					
					Масса = Масса + ОбластьСтрока.Параметры.Масса;
					Если ОбластьСтрока.Параметры.Привес <> Null тогда
						Привес = Привес + ОбластьСтрока.Параметры.Привес;
					Иначе
						Привес = 0;
					КонецЕсли;

				иначе
					ОбластьСтрока.Параметры.НомерЖивотного2 = Выборка_Хряки.НомерЖивотного;
					ОбластьСтрока.Параметры.КоличествоГолов2 = Выборка_Хряки.КоличествоГолов;
					ОбластьСтрока.Параметры.МассаПослВзв2 = Выборка_Хряки.МассаПослВзв;
					ОбластьСтрока.Параметры.Масса2 = Выборка_Хряки.Масса;
					ОбластьСтрока.Параметры.Привес2 = Выборка_Хряки.Привес;					
					Четное = ложь;
				    ТабличныйДокумент.Вывести(ОбластьСтрока);
					
					Масса2 = Масса2 + ОбластьСтрока.Параметры.Масса2;
					Если ОбластьСтрока.Параметры.Привес2 <> Null тогда
						Привес2 = Привес2 + ОбластьСтрока.Параметры.Привес2;
					Иначе
						Привес2 = 0;
					КонецЕсли;

				конецесли;
				КоличествоГоловХряки = КоличествоГоловХряки + Выборка_Хряки.КоличествоГолов;	
			конеццикла;	
		конецесли;
		///-----////
		
		если Четное тогда
			ОбластьСтрока.Параметры.НомерЖивотного2 = "";
			ОбластьСтрока.Параметры.КоличествоГолов2 = "";
			ОбластьСтрока.Параметры.МассаПослВзв2 = "";
			ОбластьСтрока.Параметры.Масса2 = "";
			ОбластьСтрока.Параметры.Привес2 = "";
			ТабличныйДокумент.Вывести(ОбластьСтрока);
		конецесли; 
		
		областьИтого = Макет.ПолучитьОбласть("СтрокаИтогов");
		областьИтого.Параметры.Масса = Масса ;
        областьИтого.Параметры.Масса2 = Масса2 ;
		областьИтого.Параметры.Привес = Привес ; 
        областьИтого.Параметры.Привес2 = Привес2 ;
		ТабличныйДокумент.Вывести(областьИтого);
		
		областьПодвал = Макет.ПолучитьОбласть("Подвал");
		областьПодвал.Параметры.Заполнить(ДанныеШапки);
		Если ЗначениеЗаполнено(ДанныеШапки.Группа) тогда
			 ОбластьЗаголовка.Параметры.Ответственный = ДанныеШапки.Сотрудник;
		иначе
			 ОбластьЗаголовка.Параметры.Ответственный = ДанныеШапки.Ответственный;
		конецесли;
		областьПодвал.Параметры.ДатаДень = Формат(ДанныеШапки.Дата,"ДФ=дд") ;
		областьПодвал.Параметры.ДатаМесяц = Сред(Формат(ДанныеШапки.Дата, "ДЛФ=ДД"),3, СтрДлина(Формат(ДанныеШапки.Дата, "ДЛФ=ДД"))-10);
		областьПодвал.Параметры.ДатаГод = Формат(ДанныеШапки.Дата,"ДФ=yyyy");
		областьПодвал.Параметры.ПривесВсего = Привес2 + Привес ;
		областьПодвал.Параметры.СреднийПривес = Окр( (Привес2 + Привес) / (КоличествоГоловСвиноматки + КоличествоГоловХряки) ,3);
		ТабличныйДокумент.Вывести(областьПодвал);
		
	Конеццикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	Возврат (ТабличныйДокумент);
	
КонецФункции
	 
Функция СформироватьПечатнуюФормуДокумента (МассивОбъектов)
	
	ТабДок = Новый ТабличныйДокумент;
	Табдок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Ложь;
	ТабДок.ОтображатьЗаголовки = Ложь;
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	Макет = Документы.Оценка.ПолучитьМакет("ПечатнаяФорма");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Оценка.Ссылка,
	               |	Оценка.Номер,
	               |	Оценка.Дата,
	               |	Оценка.Ферма,
	               |	Оценка.ТипОценки
	               |ИЗ
	               |	Документ.Оценка КАК Оценка
	               |ГДЕ
	               |	Оценка.Ссылка В(&МассивСсылок)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Оценка.МоментВремени
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Оценка.Ссылка КАК Ссылка,
	               |	Оценка.НомерСтроки КАК НомерСтроки,
	               |	Оценка.НомерСвиноматки,
	               |	Оценка.Свиноматка КАК Свиноматка,
	               |	Оценка.Масса,
	               |	Оценка.ДлинаТуловища,
	               |	Оценка.ТолщинаШпига,
	               |	Оценка.Экстерьер,
	               |	Оценка.ГлубинаМышцы,
	               |	Оценка.ТолщинаШпига1,
	               |	Оценка.ТолщинаШпига2
	               |ИЗ
	               |	Документ.Оценка.Свиноматки КАК Оценка
	               |ГДЕ
	               |	Оценка.Ссылка В(&МассивСсылок)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	НомерСтроки,
	               |	Оценка.Ссылка.МоментВремени
	               |ИТОГИ
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Свиноматка)
	               |ПО
	               |	Ссылка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Оценка.Ссылка КАК Ссылка,
	               |	Оценка.НомерСтроки КАК НомерСтроки,
	               |	Оценка.НомерХряка,
	               |	Оценка.Хряк КАК Хряк,
	               |	Оценка.Масса,
	               |	Оценка.ДлинаТуловища,
	               |	Оценка.ТолщинаШпига,
	               |	Оценка.Экстерьер,
	               |	Оценка.ОбщийВид,
	               |	Оценка.ГоловаШея,
	               |	Оценка.ПлечиХолкаГрудь,
	               |	Оценка.СпинаПоясницаБока,
	               |	Оценка.КрестецОкорока,
	               |	Оценка.НогиПередние,
	               |	Оценка.НогиЗадние,
	               |	Оценка.СоскиВымя,
	               |	Оценка.ПоловыеОрганы,
	               |	Оценка.ГлубинаМышцы,
	               |	Оценка.ТолщинаШпига1,
	               |	Оценка.ТолщинаШпига2
	               |ИЗ
	               |	Документ.Оценка.Хряки КАК Оценка
	               |ГДЕ
	               |	Оценка.Ссылка В(&МассивСсылок)
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	НомерСтроки,
	               |	Оценка.Ссылка.МоментВремени
	               |ИТОГИ
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Хряк)
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
      
		// Вывод заголовка
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ТекстЗаголовка = ОбщегоНазначенияСервер.СформироватьЗаголовокДокумента(ДанныеШапки,  НСтр("ru = 'Оценка животных'; en = 'Breeding evaluation'"));
		ОбластьМакета.Параметры.ТекстЗаголовка = ТекстЗаголовка;
		ТабДок.Вывести(ОбластьМакета);
	
		// Вывод данных шапки
		Областьмакета = Макет.ПолучитьОбласть("ДанныеШапки");
		ОбластьМакета.Параметры.Заполнить(ДанныеШапки);
		ТабДок.Вывести(ОбластьМакета);
		
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
			КонецЕсли;
			   
		// вывод данных по хрякам
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
			
			НомерСтроки = 1;
			Пока ВыборкаДетали.Следующий() Цикл
				// вывод данных
				ОбластьДетали.Параметры.НомерСтроки = НомерСтроки;
				ОбластьДетали.Параметры.Заполнить(ВыборкаДетали);
				ТабДок.Вывести(ОбластьДетали);
				//ТабДок.УдалитьОбласть(ОбластьДетали, ТипСмещенияТабличногоДокумента.ПоВертикали);
				НомерСтроки = НомерСтроки +1;
			КонецЦикла;
			
		// Вывод итогов
				
				ОбластьМакета = Макет.ПолучитьОбласть("ИтогиХряки");
				ОбластьМакета.Параметры.ИтогоХряков=ВыборкаХряки.Хряк;
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
	         КонецЕсли;
	КонецЦикла;
	

		ТабДок.АвтоМасштаб = Истина;
		
		Возврат (ТабДок);
	КонецФункции
	
#КонецОбласти	
