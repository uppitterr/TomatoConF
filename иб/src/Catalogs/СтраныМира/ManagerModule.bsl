#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
#Область ОбработчикиСобытийФормы

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	Если Не СтандартнаяОбработка Тогда 
		// Обрабатывается в другом месте
		Возврат;
		
	ИначеЕсли Не Параметры.Свойство("РазрешитьДанныеКлассификатора") Тогда
		// Поведение по умолчанию, подбор только справочника
		Возврат;
		
	ИначеЕсли Истина<>Параметры.РазрешитьДанныеКлассификатора Тогда
		// Подбор классификатора отключен, поведение по умолчанию
		Возврат;
		
	ИначеЕсли Не ЕстьПравоДобавления() Тогда
		// Нет прав на добавление страны мира, поведение по умолчанию.
		Возврат;
		
	КонецЕсли;
	
	// Будем имитировать поведение платформы - поиск по всем доступным полям поиска с формированием подобного списка. 
	
	// Подразумеваем, что поля справочника и классификатора совпадают, за исключением отсутствующего в классификаторе поля "Ссылка".
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ПрефиксПараметраОтбора = "ПараметрыОтбора";
	
	// Общий отбор по параметрам
	ШаблонОтбора = "ИСТИНА";
	Для Каждого КлючЗначение Из Параметры.Отбор Цикл
		ЗначениеПоля = КлючЗначение.Значение;
		ИмяПоля      = КлючЗначение.Ключ;
		ИмяПараметра = ПрефиксПараметраОтбора + ИмяПоля;
		
		Если ТипЗнч(ЗначениеПоля)=Тип("Массив") Тогда
			ШаблонОтбора = ШаблонОтбора + " И %1." + ИмяПоля + " В (&" + ИмяПараметра + ")";
		Иначе
			ШаблонОтбора = ШаблонОтбора + " И %1." + ИмяПоля + " = &" + ИмяПараметра;
		КонецЕсли;
		
		Запрос.УстановитьПараметр(ИмяПараметра, КлючЗначение.Значение);
	КонецЦикла;
	
	// Дополнительные отборы
	Если Параметры.Свойство("ВыборГруппИЭлементов") Тогда
		Если Параметры.ВыборГруппИЭлементов = ИспользованиеГруппИЭлементов.Группы Тогда
			ШаблонОтбора = ШаблонОтбора + " И %1.ЭтоГруппа";
			
		ИначеЕсли Параметры.ВыборГруппИЭлементов = ИспользованиеГруппИЭлементов.Элементы Тогда
			ШаблонОтбора = ШаблонОтбора + " И (НЕ %1.ЭтоГруппа)";
			
		КонецЕсли;
	КонецЕсли;
	
	// Источники данных
	Если (Параметры.Свойство("ТолькоДанныеКлассификатора") И Параметры.ТолькоДанныеКлассификатора) Тогда
		// Запрос только по классификатору
		ШаблонЗапроса = "
			|ВЫБРАТЬ ПЕРВЫЕ 50
			|	NULL                       КАК Ссылка,
			|	Классификатор.Код          КАК Код,
			|	Классификатор.Наименование КАК Наименование,
			|	ЛОЖЬ                       КАК ПометкаУдаления,
			|	%2                         КАК Представление
			|ИЗ
			|	Классификатор КАК Классификатор
			|ГДЕ
			|	Классификатор.%1 ПОДОБНО &СтрокаПоиска
			|	И (
			|		" + ПодставитьПараметрыВСтроку(ШаблонОтбора, "Классификатор") + "
			|	)
			|УПОРЯДОЧИТЬ ПО
			|	Классификатор.%1
			|";
	Иначе
		// Запрос и по справочнику и по классификатору
		ШаблонЗапроса = "
			|ВЫБРАТЬ ПЕРВЫЕ 50 
			|	СтраныМира.Ссылка                                             КАК Ссылка,
			|	ЕСТЬNULL(СтраныМира.Код, Классификатор.Код)                   КАК Код,
			|	ЕСТЬNULL(СтраныМира.Наименование, Классификатор.Наименование) КАК Наименование,
			|	ЕСТЬNULL(СтраныМира.ПометкаУдаления, ЛОЖЬ)                    КАК ПометкаУдаления,
			|
			|	ВЫБОР КОГДА СтраныМира.Ссылка ЕСТЬ NULL ТОГДА 
			|		%2 
			|	ИНАЧЕ 
			|		%3
			|	КОНЕЦ КАК Представление
			|
			|ИЗ
			|	Справочник.СтраныМира КАК СтраныМира
			|ПОЛНОЕ СОЕДИНЕНИЕ
			|	Классификатор
			|ПО
			|	Классификатор.Код = СтраныМира.Код
			|	И Классификатор.Наименование = СтраныМира.Наименование
			|ГДЕ 
			|	(СтраныМира.%1 ПОДОБНО &СтрокаПоиска ИЛИ Классификатор.%1 ПОДОБНО &СтрокаПоиска)
			|	И (" + ПодставитьПараметрыВСтроку(ШаблонОтбора, "Классификатор") + ")
			|	И (" + ПодставитьПараметрыВСтроку(ШаблонОтбора, "СтраныМира") + ")
			|
			|УПОРЯДОЧИТЬ ПО
			|	ЕСТЬNULL(СтраныМира.%1, Классификатор.%1)
			|";
	КонецЕсли;
	
	ИменаПолей = ПоляПоиска();
	
	// Код + Наименование - ключевые поля соответствия справочника классифкатору. Их обрабатываем всегда.
	ИменаПолейСтрокой = "," + СтрЗаменить(ИменаПолей.ИменаПолейСтрокой, " ", "");
	ИменаПолейСтрокой = СтрЗаменить(ИменаПолейСтрокой, ",Код", "");
	ИменаПолейСтрокой = СтрЗаменить(ИменаПолейСтрокой, ",Наименование", "");
	
	Запрос.Текст = "
		|ВЫБРАТЬ
		|	Код, Наименование " + ИменаПолейСтрокой + "
		|ПОМЕСТИТЬ
		|	Классификатор
		|ИЗ
		|	&Классификатор КАК Классификатор
		|ИНДЕКСИРОВАТЬ ПО
		|	Код, Наименование
		|	" + ИменаПолейСтрокой + "
		|";
	Запрос.УстановитьПараметр("Классификатор", ТаблицаКлассификатора());
	Запрос.Выполнить();
	Запрос.УстановитьПараметр("СтрокаПоиска", ЭкранироватьСимволыПодобия(Параметры.СтрокаПоиска) + "%");
	
	Для Каждого ДанныеПоля Из ИменаПолей.СписокПолей Цикл
		Запрос.Текст = ПодставитьПараметрыВСтроку(ШаблонЗапроса, 
			ДанныеПоля.Имя,
			ПодставитьПараметрыВСтроку(ДанныеПоля.ШаблонПредставления, "Классификатор"),
			ПодставитьПараметрыВСтроку(ДанныеПоля.ШаблонПредставления, "СтраныМира"),
		);
		
		Результат = Запрос.Выполнить();
		Если Не Результат.Пустой() Тогда
			ДанныеВыбора = Новый СписокЗначений;
			СтандартнаяОбработка = Ложь;
			
			Выборка = Результат.Выбрать();
			Пока Выборка.Следующий() Цикл
				Если ЗначениеЗаполнено(Выборка.Ссылка) Тогда
					// Данные справочника
					ЭлементВыбора = Выборка.Ссылка;
				Иначе
					// Данные классификатора
					РезультатВыбора = Новый Структура("Код, Наименование", 
						Выборка.Код, Выборка.Наименование
					);
					
					ЭлементВыбора = Новый Структура("Значение, ПометкаУдаления, Предупреждение",
						РезультатВыбора, Выборка.ПометкаУдаления, Неопределено,
					);
				КонецЕсли;
				
				ДанныеВыбора.Добавить(ЭлементВыбора, Выборка.Представление);
			КонецЦикла;
		
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ВспомогательныеПроцедурыИФункции

// Определяет данные страны по справочнику стран или классификатору ОКСМ.
//
// Параметры:
//    КодСтраны    - строка или число с кодом ОКСМ страны. Если не указано, то поиск по коду не производится.
//    Наименование - наименование страны. Если не указано, то поиск по наименованию не производится.
//
// Возвращаемое значение:
//    Структура с полями "Ссылка", "Код", "Наименование", "НаименованиеПолное", "КодАльфа2", "КодАльфа3".
//    Если страна не найдена в справочнике, но найдена в классфикаторе, то поле "Ссылка" не заполнено.
//
//    Если страна не найдена ни в адресе, ни в классификаторе, то возвращается значение Неопределено.
//
Функция ДанныеСтраныМира(Знач КодСтраны=Неопределено, Знач Наименование=Неопределено) Экспорт
	Если КодСтраны=Неопределено И Наименование=Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НормализованыйКод = КодСтраныМира(КодСтраны);
	Если КодСтраны=Неопределено Тогда
		УсловиеПоиска = "ИСТИНА";
		ФильтрКлассификатора = Новый Структура;
	Иначе
		УсловиеПоиска = "Код=" + ЗакавычитьСтроку(НормализованыйКод);
		ФильтрКлассификатора = Новый Структура("Код", НормализованыйКод);
	КонецЕсли;
	
	Если Наименование<>Неопределено Тогда
		УсловиеПоиска = УсловиеПоиска + " И Наименование=" + ЗакавычитьСтроку(Наименование);
		ФильтрКлассификатора.Вставить("Наименование", Наименование);
	КонецЕсли;
	
	Результат = Новый Структура("Ссылка, Код, Наименование, НаименованиеПолное, КодАльфа2, КодАльфа3");
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	Ссылка, Код, Наименование, НаименованиеПолное, КодАльфа2, КодАльфа3
		|ИЗ
		|	Справочник.СтраныМира
		|ГДЕ
		|	" + УсловиеПоиска + "
		|УПОРЯДОЧИТЬ ПО
		|	Наименование
		|");
		
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда 
		ЗаполнитьЗначенияСвойств(Результат, Выборка);
		
	Иначе
		ДанныеКлассификатора = ТаблицаКлассификатора();
		СтрокиДанных = ДанныеКлассификатора.НайтиСтроки(ФильтрКлассификатора);
		Если СтрокиДанных.Количество()=0 Тогда
			Результат = Неопределено
		Иначе
			ЗаполнитьЗначенияСвойств(Результат, СтрокиДанных[0]);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Определяет данные страны по классификатору ОКСМ.
//
// Параметры:
//    КодСтраны - строка кода страны или числовой код.
//
// Возвращаемое значение:
//    - в случае успеха - структура с полями "Код", "Наименование", "НаименованиеПолное", "КодАльфа2", "КодАльфа3".
//    - в случае отсуствия страны в классфикаторе - Неопределено.
//
Функция ДанныеКлассификатораСтранМираПоКоду(Знач КодСтраны) Экспорт
	
	ДанныеКлассификатора = ТаблицаКлассификатора();
	СтрокаДанных = ДанныеКлассификатора.Найти(КодСтраныМира(КодСтраны), "Код");
	Если СтрокаДанных=Неопределено Тогда
		Результат = Неопределено;
	Иначе
		Результат = Новый Структура("Код, Наименование, НаименованиеПолное, КодАльфа2, КодАльфа3");
		ЗаполнитьЗначенияСвойств(Результат, СтрокаДанных);
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Определяет данные страны по классификатору ОКСМ.
//
// Параметры:
//    Наименование - строка наименования страны.
//
// Возвращаемое значение:
//    - в случае успеха - структура с полями "Код", "Наименование", "НаименованиеПолное", "КодАльфа2", "КодАльфа3".
//    - в случае отсуствия страны в классфикаторе - Неопределено.
//
Функция ДанныеКлассификатораСтранМираПоНаименованию(Знач Наименование) Экспорт
	ДанныеКлассификатора = ТаблицаКлассификатора();
	СтрокаДанных = ДанныеКлассификатора.Найти(Наименование, "Наименование");
	Если СтрокаДанных=Неопределено Тогда
		Результат = Неопределено;
	Иначе
		Результат = Новый Структура("Код, Наименование, НаименованиеПолное, КодАльфа2, КодАльфа3");
		ЗаполнитьЗначенияСвойств(Результат, СтрокаДанных);
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Обновляет справочник стран мира по данным макета - классификатора.
// Идентификация существующих элементов в справочнике выполняется по полю Код.
//
// Параметры:
//    Добавлять - необязательный флаг. Если Истина, то добавляются страны, которые есть в классификаторе,
//                но отсутствуют в справочнике стран мира.
//
Процедура ОбновитьСтраныМираПоКлассификатору(Знач Добавлять=Ложь) Экспорт
	ВсеОшибки = "";
	
	Фильтр = Новый Структура("Код");
	
	// Сравнивать в запросе нельзя из-за возможной регистронезависимости базы данных
	Для Каждого СтрокаКлассификатора Из ТаблицаКлассификатора() Цикл
		Фильтр.Код = СтрокаКлассификатора.Код;
		Выборка = Справочники.СтраныМира.Выбрать(,,Фильтр);
		СтранаНайдена = Выборка.Следующий();
		Если Не СтранаНайдена И Добавлять Тогда
			// Добавление страны
			Страна = Справочники.СтраныМира.СоздатьЭлемент();
		ИначеЕсли СтранаНайдена И (
			      Выборка.Наименование<>СтрокаКлассификатора.Наименование
			  Или Выборка.КодАльфа2<>СтрокаКлассификатора.КодАльфа2
			  Или Выборка.КодАльфа3<>СтрокаКлассификатора.КодАльфа3
			  Или Выборка.НаименованиеПолное<>СтрокаКлассификатора.НаименованиеПолное
			) Тогда
			// Изменение страны
			Страна = Выборка.ПолучитьОбъект();
		Иначе
			Продолжить;
		КонецЕсли;
		
		НачатьТранзакцию();
		Попытка
			Если Не Страна.ЭтоНовый() Тогда
				ЗаблокироватьДанныеДляРедактирования(Страна.Ссылка);
			КонецЕсли;
			ЗаполнитьЗначенияСвойств(Страна, СтрокаКлассификатора, "Код, Наименование, КодАльфа2, КодАльфа3, НаименованиеПолное");		
			Страна.ДополнительныеСвойства.Вставить("НеПроверятьУникальность");
			Страна.Записать();
			ЗафиксироватьТранзакцию();
		Исключение
			Инфо = ИнформацияОбОшибке();
			ТекстОшибки = ПодставитьПараметрыВСтроку(
				НСтр("ru='Ошибка записи страны мира %1 (код %2) при обновлении классификатора, %3';en='Ошибка записи страны мира %1 (код %2) при обновлении классификатора, %3'"),
				Выборка.Код, Выборка.Наименование, КраткоеПредставлениеОшибки(Инфо));
			
			ВсеОшибки = ВсеОшибки + Символы.ПС + ТекстОшибки;
			ОтменитьТранзакцию();
		КонецПопытки;
		
	КонецЦикла;
	
	Если Не ПустаяСтрока(ВсеОшибки) Тогда
		ВызватьИсключение СокрЛП(ВсеОшибки);
	КонецЕсли;
КонецПроцедуры

// Возвращает таблицу значений с данными ОКСМ
//
// Колонки:
//     Код                - Строка(3, Переменная).
//     Наименование       - Строка(60, Переменная).
//     НаименованиеПолное - Строка(100, Переменная).
//     КодАльфа2          - Строка(2, Переменная).
//     КодАльфа3          - Строка(3, Переменная).
// Индексы:
//     Код,
//     Наименование.
//
Функция ТаблицаКлассификатора() Экспорт
	Макет = Справочники.СтраныМира.ПолучитьМакет("Классификатор");
	
	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(Макет.ПолучитьТекст());
	
	Возврат СериализаторXDTO.ПрочитатьXML(Чтение);
КонецФункции

// Возвращает поля поиска в порядке предпочтения для справочника стран мира
//
// Результат - массив структур с полями:
//    - Имя                 - имя реквизита поиска.
//    - ШаблонПредставления - шаблон для формирования значения представления по именам реквизитов. 
//                            Например: "%1.Наменование (%1.Код)". Здесь "Наименование" и "Код" - имена реквизитов.
//                            "%1" - заполнитель для передачи псевдонима таблицы.
//
Функция ПоляПоиска() Экспорт
	Результат = Новый Массив;
	СписокПолей = Справочники.СтраныМира.ПустаяСсылка().Метаданные().ВводПоСтроке;
	ГраницаПолей = СписокПолей.Количество() - 1;
	ВсеИменаСтрокой = "";
	
	ПредставлениеРазделителя = ", ";
	РазделительПредставлений = " + """ + ПредставлениеРазделителя + """ + ";
	
	Для Индекс=0 По ГраницаПолей Цикл
		ИмяПоля = СписокПолей[Индекс].Имя;
		ВсеИменаСтрокой = ВсеИменаСтрокой + "," + ИмяПоля;
		
		ШаблонПредставления = "%1." + ИмяПоля;
		
		ОстальныеПоля = "";
		Для Позиция=0 По ГраницаПолей Цикл
			Если Позиция<>Индекс Тогда
				ОстальныеПоля = ОстальныеПоля + РазделительПредставлений + СписокПолей[Позиция].Имя;
			КонецЕсли;
		КонецЦикла;
		Если Не ПустаяСтрока(ОстальныеПоля) Тогда
			ШаблонПредставления = ШаблонПредставления
				+ " + "" ("" + " 
				+ "%1." + Сред(ОстальныеПоля, СтрДлина(РазделительПредставлений) + 1) 
				+ " + "")""";
		КонецЕсли;
		
		Результат.Добавить(
			Новый Структура("Имя, ШаблонПредставления", ИмяПоля, ШаблонПредставления)
		);
	КонецЦикла;
	
	Возврат Новый Структура("СписокПолей, ИменаПолейСтрокой", Результат, Сред(ВсеИменаСтрокой, 2));
КонецФункции

// Создает или возвращает существующую ссылку по данным классификатора
//
// Параметры:
//    Отбор  - объект с полем Код для поиска страны в классфикаторе.
//    Данные - необязательная структура для заполнения оставшихся полей создаваемого объекта.
//
// Возвращаемое значение - ссылка на созданый элемент.
//
Функция СсылкаПоДаннымКлассификатора(Знач Отбор, Знач ДополнительныеДанные=Неопределено) Экспорт
	
	// Убеждаемся, что страна есть в классификаторе
	ДанныеПоиска = ДанныеКлассификатораСтранМираПоКоду(Отбор.Код);
	Если ДанныеПоиска=Неопределено Тогда
		ВызватьИсключение НСтр("ru='Некорректный код страны мира для поиска в классификаторе';en='Некорректный код страны мира для поиска в классификаторе'");
	КонецЕсли;
	
	// Проверяем на существование в справочнике по данным классификатора
	ДанныеПоиска = ДанныеСтраныМира(ДанныеПоиска.Код, ДанныеПоиска.Наименование);
	Результат = ДанныеПоиска.Ссылка;
	Если Не ЗначениеЗаполнено(Результат) Тогда
		ОбъектСтраны = Справочники.СтраныМира.СоздатьЭлемент();
		ЗаполнитьЗначенияСвойств(ОбъектСтраны, ДанныеПоиска);
		Если ДополнительныеДанные<>Неопределено Тогда
			ЗаполнитьЗначенияСвойств(ОбъектСтраны, ДополнительныеДанные);
		КонецЕсли;
		ОбъектСтраны.Записать();
		Результат = ОбъектСтраны.Ссылка;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Возвращает флаг возможности добавления и изменения элементов.
//
Функция ЕстьПравоДобавления() Экспорт
	Возврат ПравоДоступа("Добавление", Справочники.СтраныМира.ПустаяСсылка().Метаданные());
КонецФункции

// Приводит код страны к единому виду - строка длиной три символа.
//
Функция КодСтраныМира(Знач КодСтраны)
	
	Если ТипЗнч(КодСтраны)=Тип("Число") Тогда
		Возврат Формат(КодСтраны, "ЧЦ=3; ЧН=; ЧВН=; ЧГ=");
	КонецЕсли;
	
	Возврат Прав("000" + КодСтраны, 3);
КонецФункции

// Возвращает строку в кавычках
//
Функция ЗакавычитьСтроку(Знач Строка)
	Возврат """" + СтрЗаменить(Строка, """", """""") + """";
КонецФункции

// Экранирует символы для использования в функции запроса ПОДОБНО.
//
Функция ЭкранироватьСимволыПодобия(Знач Текст, Знач СпецСимвол = "\")
	Результат = Текст;
	СимволыПодобия = "%_[]^" + СпецСимвол;
	
	Для Позиция=1 По СтрДлина(СимволыПодобия) Цикл
		ТекущийСимвол = Сред(СимволыПодобия, Позиция, 1);
		Результат = СтрЗаменить(Результат, ТекущийСимвол, СпецСимвол + ТекущийСимвол);
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

// Подставляет параметры в строку. Максимально возможное число параметров - 9.
// Параметры в строке задаются как %<номер параметра>. Нумерация параметров начинается с единицы.
//
// Параметры:
//  СтрокаПодстановки  – Строка – шаблон строки с параметрами (вхождениями вида "%ИмяПараметра").
//  Параметр<n>        - Строка - подставляемый параметр.
//
// Возвращаемое значение:
//  Строка   – текстовая строка с подставленными параметрами.
//
// Пример:
//  ПодставитьПараметрыВСтроку(НСтр("en='%1 go to %2';ru='%1 пошел в %2'"), "Вася", "Зоопарк") = "Вася пошел в Зоопарк".
//
Функция ПодставитьПараметрыВСтроку(Знач СтрокаПодстановки,
	Знач Параметр1, Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено,
	Знач Параметр4 = Неопределено, Знач Параметр5 = Неопределено, Знач Параметр6 = Неопределено,
	Знач Параметр7 = Неопределено, Знач Параметр8 = Неопределено, Знач Параметр9 = Неопределено) 
	
	ИспользоватьАльтернативныйАлгоритм = 
		Найти(Параметр1, "%")
		Или Найти(Параметр2, "%")
		Или Найти(Параметр3, "%")
		Или Найти(Параметр4, "%")
		Или Найти(Параметр5, "%")
		Или Найти(Параметр6, "%")
		Или Найти(Параметр7, "%")
		Или Найти(Параметр8, "%")
		Или Найти(Параметр9, "%");
		
	Если ИспользоватьАльтернативныйАлгоритм Тогда
		СтрокаПодстановки = ПодставитьПараметрыВСтрокуАльтернативныйАлгоритм(СтрокаПодстановки, Параметр1,
			Параметр2, Параметр3, Параметр4, Параметр5, Параметр6, Параметр7, Параметр8, Параметр9);
	Иначе
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%1", Параметр1);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%2", Параметр2);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%3", Параметр3);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%4", Параметр4);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%5", Параметр5);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%6", Параметр6);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%7", Параметр7);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%8", Параметр8);
		СтрокаПодстановки = СтрЗаменить(СтрокаПодстановки, "%9", Параметр9);
	КонецЕсли;
	
	Возврат СтрокаПодстановки;
КонецФункции

// Вставляет параметры в строку, учитывая, что в параметрах могут использоваться подстановочные слова %1, %2 и т.д.
Функция ПодставитьПараметрыВСтрокуАльтернативныйАлгоритм(Знач СтрокаПодстановки,
	Знач Параметр1, Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено,
	Знач Параметр4 = Неопределено, Знач Параметр5 = Неопределено, Знач Параметр6 = Неопределено,
	Знач Параметр7 = Неопределено, Знач Параметр8 = Неопределено, Знач Параметр9 = Неопределено)
	
	Результат = "";
	Позиция = Найти(СтрокаПодстановки, "%");
	Пока Позиция > 0 Цикл 
		Результат = Результат + Лев(СтрокаПодстановки, Позиция - 1);
		СимволПослеПроцента = Сред(СтрокаПодстановки, Позиция + 1, 1);
		ПодставляемыйПараметр = "";
		Если СимволПослеПроцента = "1" Тогда
			ПодставляемыйПараметр =  Параметр1;
		ИначеЕсли СимволПослеПроцента = "2" Тогда
			ПодставляемыйПараметр =  Параметр2;
		ИначеЕсли СимволПослеПроцента = "3" Тогда
			ПодставляемыйПараметр =  Параметр3;
		ИначеЕсли СимволПослеПроцента = "4" Тогда
			ПодставляемыйПараметр =  Параметр4;
		ИначеЕсли СимволПослеПроцента = "5" Тогда
			ПодставляемыйПараметр =  Параметр5;
		ИначеЕсли СимволПослеПроцента = "6" Тогда
			ПодставляемыйПараметр =  Параметр6;
		ИначеЕсли СимволПослеПроцента = "7" Тогда
			ПодставляемыйПараметр =  Параметр7
		ИначеЕсли СимволПослеПроцента = "8" Тогда
			ПодставляемыйПараметр =  Параметр8;
		ИначеЕсли СимволПослеПроцента = "9" Тогда
			ПодставляемыйПараметр =  Параметр9;
		КонецЕсли;
		Если ПодставляемыйПараметр = "" Тогда
			Результат = Результат + "%";
			СтрокаПодстановки = Сред(СтрокаПодстановки, Позиция + 1);
		Иначе
			Результат = Результат + ПодставляемыйПараметр;
			СтрокаПодстановки = Сред(СтрокаПодстановки, Позиция + 2);
		КонецЕсли;
		Позиция = Найти(СтрокаПодстановки, "%");
	КонецЦикла;
	Результат = Результат + СтрокаПодстановки;
	
	Возврат Результат;
КонецФункции

#КонецОбласти

#КонецЕсли
