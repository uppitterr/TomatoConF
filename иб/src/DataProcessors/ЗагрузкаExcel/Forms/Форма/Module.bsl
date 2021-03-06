

&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбора.Заголовок = "Выберите файл";

	Если ДиалогВыбора.Выбрать() Тогда
		Объект.ИмяФайла = ДиалогВыбора.ПолноеИмяФайла;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура Прочитать(Команда)
	Объект.Таблица.Очистить();
	//Объект.Таблица.Колонки.Очистить();
	//ЭлементыФормы.Объект.Таблица.Колонки.Очистить();
	Попытка
		Excel = Новый COMОбъект("Excel.Application");
		Excel.WorkBooks.Open(СокрЛП(Объект.ИмяФайла));
		//Состояние("Обработка файла Microsoft Excel...");
	Исключение
		Сообщить("Ошибка при открытии файла с помощью Excel! Загрузка не будет произведена!");
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	
	Попытка
		//Открываем необходимый лист
		Excel.Sheets(1).Select(); // лист 1, по умолчанию
	Исключение
		//Закрываем Excel
		Excel.ActiveWorkbook.Close();
		Excel = 0;
		Сообщить("Файл "+Строка(Объект.ИмяФайла)+" не соответствует необходимому формату! Первый лист не найден!");
		//ОтменитьТранзакцию();
		Возврат;
	КонецПопытки;
	
	//Получим количество строк и колонок.
	//В разных версиях Excel получаются по-разному, поэтому сначала определим версию Excel
	Версия = Лев(Excel.Version,Найти(Excel.Version,".")-1);
	Если Версия = "8" тогда
		ФайлСтрок = Excel.Cells.CurrentRegion.Rows.Count;
		ФайлКолонок = Макс(Excel.Cells.CurrentRegion.Columns.Count, 13);
	Иначе
		ФайлСтрок = Excel.Cells(1,1).SpecialCells(11).Row;
		ФайлКолонок = Excel.Cells(1,1).SpecialCells(11).Column;
	Конецесли;
	
	Сч = 1;
	//Пока ЗначениеЗаполнено(Excel.Cells(1, Сч).Text) Цикл
	//	ИмяКолонки = Excel.Cells(1, Сч).Text;
	//	ИмяБезПробелов = СтрЗаменить(ИмяКолонки," ",""); // убираем из имени колонок пробелы
	//	Объект.Таблица.Колонки.Добавить(ИмяБезПробелов,,ИмяКолонки);
	//	НоваяКолонка = Объект.Таблица.Колонки.Добавить(ИмяБезПробелов, ИмяКолонки);
	//	НоваяКолонка.Данные = ИмяБезПробелов;
	//	Сч = Сч + 1;
	//КонецЦикла;
	
	
	Для НС = Объект.НачальнаяСтрока по ФайлСтрок Цикл // НС указываем с какой строки начинать обработку
		
		//Состояние("Файл "+Строка(Объект.ИмяФайла)+": Обрабатывается первый лист "+Строка(Формат(?(ФайлСтрок=0,0,((100*НС)/ФайлСтрок)),"ЧЦ=3; ЧДЦ=0"))+" %");
		
		//ОбработкаПрерыванияПользователя(); //указав данный оператор, цикл можно прервать в любой момент нажатие ctrl+break
		
		НоваяСтрока = Объект.Таблица.Добавить();
		
		НоваяСтрока.Артикул =  СокрЛП(Excel.Cells(НС, Объект.КолонкаАртикул).Text);
		Если Объект.ПоискПоАртикулу Тогда
			НоваяСтрока.Номенклатура = ПолучитьСсылкуНоменклатурыПоАртикулу(СокрЛП(Excel.Cells(НС, Объект.КолонкаАртикул).Text));
			Если Объект.КолонкаШтрихкод <>0 Тогда
				НоваяСтрока.Штрихкод = СокрЛП(Excel.Cells(НС, Объект.КолонкаШтрихкод).Text);
			КонецЕсли;	
		Иначе
			НоваяСтрока.Штрихкод = СокрЛП(Excel.Cells(НС, Объект.КолонкаШтрихкод).Text);
			НоваяСтрока.Номенклатура = ПолучитьСсылкуНоменклатуры(СокрЛП(Excel.Cells(НС, Объект.КолонкаШтрихкод).Text));
			
		КонецЕсли;
		Если Объект.КартинкаНаСайте Тогда
			НоваяСтрока.АдресКартинки = СокрЛП(Excel.Cells(НС, Объект.КолонкаАдресКартинки).Text);
		    КопироватьФайл (НоваяСтрока.АдресКартинки, Объект.ПапкаСКартинками + "\" + НоваяСтрока.Артикул + ".jpg");
		КонецЕсли;
		
		//Excel.Application.ActiveSheet.Shapes("Picture 1").Select();
		//Excel.Cells(НС, 5).value.copy();
		Попытка
			Если Объект.ПоискПоАртикулу Тогда
				КартинкаПуть = Объект.ПапкаСКартинками + "\" + НоваяСтрока.Артикул + ".jpg";
			Иначе
				КартинкаПуть = Объект.ПапкаСКартинками+"\" + НоваяСтрока.Штрихкод + ".jpg";
			КонецЕсли;	
			Буфер = Новый ComОбъект("cClipBoardObject.cClipBoard"); //нужна внешняя комопонента
			Буфер.GetClipBoard(КартинкаПуть);
			НоваяСтрока.Картинка2 = Новый Картинка(КартинкаПуть);
		Исключение
			Сообщить ("Нет штрихкода " + НоваяСтрока.Штрихкод + " у товара" + НоваяСтрока.Номенклатура);
		КонецПопытки;
			
		
		//НоваяСтрока.Картинка = СокрЛП(Excel.Cells(НС, 5).Text);
		//НоваяСтрока.Картинка2 = СокрЛП(Excel.Cells(НС, 5).Text);
		//ПрописатьКодДМ(НоваяСтрока.Штрихкод,НоваяСтрока.КодДМ );
		//Для НомерКолонки = 1 по Объект.Таблица.Колонки.Количество() Цикл
		//	//заполняем строку значениями
		//	ТекущееЗначение = Excel.Cells(НС, НомерКолонки).Text;
		//	ИмяКолонки = Объект.Таблица.Колонки[НомерКолонки-1].Имя;
		//	НоваяСтрока[ИмяКолонки] = ТекущееЗначение;
		//КонецЦикла;
		
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПрописатьКодДМ(Штрихкод, КодДМ)
	НаборЗаписей = РегистрыСведений.ШтрихкодыНоменклатуры.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Штрихкод.Установить(Штрихкод);
	НаборЗаписей.Прочитать();
	Характеристика = НаборЗаписей[0].Характеристика;
	Табл = Новый ТаблицаЗначений;
	Табл.Колонки.Добавить("Свойство");
	Табл.Колонки.Добавить("Значение");
	НовСтрока = Табл.Добавить();
	НовСтрока.Свойство = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("Имя", "КодДМ"); 
	НовСтрока.Значение = КодДМ;
	УправлениеСвойствами.ЗаписатьСвойстваУОбъекта(Характеристика,Табл);
	
	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСсылкуНоменклатурыПоАртикулу(Артикул)
	НомСсылка = Справочники.Номенклатура.НайтиПоРеквизиту("Артикул", Артикул);
	Возврат НомСсылка;
КонецФункции


&НаСервере
Функция ПолучитьСсылкуНоменклатуры(Наименование)
	//ЧислоСимволов = 12;
	//Арт = Лев(Наименование, ЧислоСимволов);
	//НомСсылка = Справочники.Номенклатура.НайтиПоРеквизиту("Артикул",Арт);
	//Если НЕ ЗначениеЗаполнено(НомСсылка) Тогда
	//	Пока НомСсылка.Пустая() Цикл
	//		ЧислоСимволов = ЧислоСимволов - 1;
	//		Арт = Лев(Наименование, ЧислоСимволов);
	//		НомСсылка = Справочники.Номенклатура.НайтиПоРеквизиту("Артикул",Арт);
	//	КонецЦикла;
	//КонецЕсли;
	//
	//Возврат НомСсылка;
	 Запрос = Новый Запрос;
	 Запрос.Текст = 
	 "ВЫБРАТЬ
	 |	ШтрихкодыНоменклатуры.Номенклатура КАК Номенклатура
	 |ИЗ
	 |	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	 |ГДЕ
	 |	ШтрихкодыНоменклатуры.Штрихкод = &Штрихкод";
	 Запрос.УстановитьПараметр("Штрихкод", Наименование);
	 Выборка = Запрос.Выполнить().Выбрать();
	 Пока Выборка.Следующий() Цикл
		 НомСсылка = Выборка.Номенклатура;
	 КонецЦикла;
	 Возврат НомСсылка;
	
КонецФункции

&НаСервере
Процедура ЗаписатьШтрихкодИКартинкуНаСервере()
	Для Каждого Строка ИЗ Объект.Таблица Цикл
		Если ЗначениеЗаполнено(Строка.Номенклатура) Тогда
			НомСсылка =  ПолучитьСсылкуНоменклатуры(Строка.Штрихкод);
			Если Не ЗначениеЗаполнено(НомСсылка) Тогда
				МенеджерЗаписи = РегистрыСведений.ШтрихкодыНоменклатуры.СоздатьМенеджерЗаписи();
				МенеджерЗаписи.Штрихкод = Строка.Штрихкод;
				МенеджерЗаписи.Номенклатура = Строка.Номенклатура;
				МенеджерЗаписи.Записать();
			КонецЕсли;
			
		Карт = Справочники.НоменклатураПрисоединенныеФайлы.СоздатьЭлемент();
		Карт.ВладелецФайла = Строка.номенклатура;
		Карт.Наименование = Строка.Штрихкод;
		Карт.ДатаСоздания = ТекущаяДата();
		Карт.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе;
		Карт.ПутьКФайлу = Объект.ПапкаСКартинками+"\" + Строка.Штрихкод + ".jpg" ;
		Карт.Расширение = "jpg";
		Карт.Изменил = ПараметрыСеанса.ТекущийПользователь;
		Карт.ДатаМодификацииУниверсальная = ТекущаяДата();
		
		Карт.Записать();
		
		
		НомОбъект = НомСсылка.ПолучитьОбъект();
		НомОбъект.ФайлКартинки = Справочники.НоменклатураПрисоединенныеФайлы.НайтиПоНаименованию(Карт);
		НомОбъект.Записать();
		Данные = Новый ДвоичныеДанные(Объект.ПапкаСКартинками+"\" + Строка.Штрихкод + ".jpg");
		ЗаписатьФайл(Карт.ВладелецФайла, Данные , Строка.Номенклатура, НомОбъект.ФайлКартинки);
		
		КонецЕсли;
	КонецЦикла;			
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьШтрихкодИКартинку(Команда)
	ЗаписатьШтрихкодИКартинкуНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПапкаСКартинкамиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогВыбора.Заголовок = "Выберите каталог";

	Если ДиалогВыбора.Выбрать() Тогда
		Объект.ПапкаСКартинками = ДиалогВыбора.Каталог;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьКартинкуНаСервере()
	Для Каждого Строка ИЗ Объект.Таблица Цикл
		Если ЗначениеЗаполнено(Строка.Номенклатура) Тогда
			НомСсылка =  ПолучитьСсылкуНоменклатурыПоАртикулу(Строка.Артикул);
			
			
		Карт = Справочники.НоменклатураПрисоединенныеФайлы.СоздатьЭлемент();
		Карт.ВладелецФайла = Строка.номенклатура;
		Карт.Наименование = Строка.Артикул;
		Карт.ДатаСоздания = ТекущаяДата();
		Карт.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе;
		Карт.ПутьКФайлу = Объект.ПапкаСКартинками+"\" + Строка.Артикул + ".jpg" ;
		Карт.Расширение = "jpg";
		Карт.Изменил = ПараметрыСеанса.ТекущийПользователь;
		Карт.ДатаМодификацииУниверсальная = ТекущаяДата();
		
		Карт.Записать();
		
				
		НомОбъект = НомСсылка.ПолучитьОбъект();
		НомОбъект.ФайлКартинки = Справочники.НоменклатураПрисоединенныеФайлы.НайтиПоНаименованию(Карт);
		НомОбъект.Записать();
		Данные = Новый ДвоичныеДанные(Карт.Наименование);
		ЗаписатьФайл(Карт.ВладелецФайла, Данные , Строка.Номенклатура, НомОбъект.ФайлКартинки);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗаписатьФайл(ИмяФайла, Данные, Владелец, СсылкаНаФайл)
	НовыйФайл = Справочники.Файлы.СоздатьЭлемент();
	НовыйФайл.ФайлХранилище=Новый ХранилищеЗначения(Данные, Новый СжатиеДанных());
	НовыйФайл.Наименование=ИмяФайла;
	//НовыйФайл.ИмяФайла=ИмяФайла;
	НовыйФайл.ВладелецФайла=Справочники.ПапкиФайлов.Шаблоны;
	НовыйФайл.Записать();
	
	СтрокаРС = РегистрыСведений.ДвоичныеДанныеФайлов.СоздатьМенеджерЗаписи();
	СтрокаРС.Файл = СсылкаНаФайл;
	СтрокаРС.ДвоичныеДанныеФайла = Данные;
	СтрокаРС.Записать();
КонецПроцедуры


&НаКлиенте
Процедура ЗаписатьКартинку(Команда)
	ЗаписатьКартинкуНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаписатьШтрихкодыНаСервере()
	Для Каждого Строка ИЗ Объект.Таблица Цикл
		Если ЗначениеЗаполнено(Строка.Номенклатура) Тогда
			НомСсылка =  ПолучитьСсылкуНоменклатурыПоАртикулу(Строка.Артикул);
			//Если Не ЗначениеЗаполнено(НомСсылка) Тогда
				МенеджерЗаписи = РегистрыСведений.ШтрихкодыНоменклатуры.СоздатьМенеджерЗаписи();
				МенеджерЗаписи.Штрихкод = Строка.Штрихкод;
				МенеджерЗаписи.Номенклатура = Строка.Номенклатура;
				МенеджерЗаписи.Записать();
			//КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьШтрихкоды(Команда)
	ЗаписатьШтрихкодыНаСервере();
КонецПроцедуры
