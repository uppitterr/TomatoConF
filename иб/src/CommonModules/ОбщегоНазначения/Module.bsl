Процедура ХранилищеОбщихНастроекСохранить(КлючОбъекта, КлючНастроек = Неопределено, Значение,
	ОписаниеНастроек = Неопределено, НужноОбновитьПовторноИспользуемыеЗначения = Ложь) Экспорт
	
	ХранилищеОбщихНастроек.Сохранить(КлючОбъекта, КлючНастроек, Значение, ОписаниеНастроек);
	Если НужноОбновитьПовторноИспользуемыеЗначения Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
КонецПроцедуры

// Передает с клиента на сервер для записи
	
Функция ХранилищеОбщихНастроекЗагрузить(КлючОбъекта, КлючНастроек = Неопределено, ЗначениеПоУмолчанию = Неопределено,ОписаниеНастроек = Неопределено) Экспорт
	
	Результат = ХранилищеОбщихНастроек.Загрузить(КлючОбъекта, КлючНастроек, ОписаниеНастроек);
	
	Если (Результат = Неопределено) И (ЗначениеПоУмолчанию <> Неопределено) Тогда
		Результат = ЗначениеПоУмолчанию;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции
// Формирует и выводит сообщение, которое может быть связано с элементом 
// управления формы.
//
//  Параметры
//  ТекстСообщенияПользователю - Строка - текст сообщения.
//  КлючДанных                - Любая ссылка на объект информационной базы.
//                               Ссылка на объект информационной базы, к которому это сообщение относится,
//                               или ключ записи.
//  Поле                       - Строка - наименование реквизита формы
//  ПутьКДанным                - Строка - путь к данным (путь к реквизиту формы)
//  Отказ                      - Булево - Выходной параметр
//                               Всегда устанавливается в значение Истина
//
//	Примеры использования:
//
//	1. Для вывода сообщения у поля управляемой формы, связанного с реквизитом объекта:
//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
//		НСтр("ru = 'Сообщение об ошибке.'"), ,
//		"ПолеВРеквизитеФормыОбъект",
//		"Объект");
//
//	Альтернативный вариант использования в форме объекта:
//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
//		НСтр("ru = 'Сообщение об ошибке.'"), ,
//		"Объект.ПолеВРеквизитеФормыОбъект");
//
//	2. Для вывода сообщения рядом с полем управляемой формы, связанным с реквизитом формы:
//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
//		НСтр("ru = 'Сообщение об ошибке.'"), ,
//		"ИмяРеквизитаФормы");
//
//	3. Для вывода сообщения связанного с объектом информационной базы
//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
//		НСтр("ru = 'Сообщение об ошибке.'"), ОбъектИнформационнойБазы, "Ответственный",,Отказ);
//
// 4. Для вывода сообщения по ссылке на объект информационной базы
//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
//		НСтр("ru = 'Сообщение об ошибке.'"), Ссылка, , , Отказ);
//
// Случаи некорректного использования:
//  1. Передача одновременно параметров КлючДанных и ПутьКДанным
//  2. Передача в параметре КлючДанных значения типа отличного от допустимых
//  3. Установка ссылки без установки поля (и/или пути к данным)
//
Процедура СообщитьПользователю(
	Знач ТекстСообщенияПользователю,
	Знач КлючДанных = Неопределено,
	Знач Поле = "",
	Знач ПутьКДанным = "",
	Отказ = Ложь) Экспорт
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = ТекстСообщенияПользователю;
	Сообщение.Поле = Поле;
	
	ЭтоОбъект = Ложь;
	
	#Если НЕ (ТонкийКлиент ИЛИ ВебКлиент) Тогда
		Если КлючДанных <> Неопределено
			И XMLТипЗнч(КлючДанных) <> Неопределено Тогда
			ТипЗначенияСтрокой = XMLТипЗнч(КлючДанных).ИмяТипа;
			ЭтоОбъект = Найти(ТипЗначенияСтрокой, "Object.") > 0;
		КонецЕсли;
	#КонецЕсли
	
	Если ЭтоОбъект Тогда
		Сообщение.УстановитьДанные(КлючДанных);
	Иначе
		Сообщение.КлючДанных = КлючДанных;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ПутьКДанным) Тогда
		Сообщение.ПутьКДанным = ПутьКДанным;
	КонецЕсли;
	
	Сообщение.Сообщить();
	
	Отказ = Истина;
	
КонецПроцедуры

Функция ОпределитьОстатокНаСкладе(Дата,Товар) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДвижениеТоваровОстатки.ВНаличииОстаток КАК Остаток
	               |ИЗ
	               |	РегистрНакопления.ДвижениеТоваров.Остатки(&ДатаДок, Номенклатура.Ссылка = &Товар) КАК ДвижениеТоваровОстатки";
	
	Запрос.УстановитьПараметр("ДатаДок",Дата);
	Запрос.УстановитьПараметр("Товар",Товар);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Возврат Выборка.Остаток;	
	КонецЦикла; 
	
	Возврат 0;
	
КонецФункции

