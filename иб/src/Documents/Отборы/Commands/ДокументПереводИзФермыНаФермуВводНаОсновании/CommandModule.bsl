#Область ОбработчикКоманды

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	СвязанныеОбъектыСуществуют = ПроверитьСуществованиеСвязанныхОбъектов(ПараметрКоманды);
		
	Если СвязанныеОбъектыСуществуют тогда
		ТекстВопроса = "Для данного документа уже выполнен ввод на основании! Продолжить?";
		Ответ = Вопрос (ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
		если Ответ = КодВозвратаДиалога.Нет тогда
			Возврат;			
		КонецЕсли;
	Конецесли;
	
	Данные = ПрочитатьДанныеДляВводаНаОсновании(ПараметрКоманды);
	СозданиеИЗаполнениеДокументов(Данные);		
		
КонецПроцедуры

&НаСервере
Функция ПроверитьСуществованиеСвязанныхОбъектов(ДокументСсылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	сжсвСвязанныеДокументы.Ссылка
	               |ИЗ
	               |	КритерийОтбора.сжсвСвязанныеДокументы(&Документ) КАК сжсвСвязанныеДокументы";				   
	Запрос.УстановитьПараметр("Документ",ДокументСсылка);
	РезультатЗапроса = Запрос.Выполнить();
	
	если РезультатЗапроса.Пустой() тогда
		СвязанныеОбъектыСуществуют = ложь;
	иначе
		СвязанныеОбъектыСуществуют = истина;
	КонецЕсли;
	
	Возврат (СвязанныеОбъектыСуществуют);
	
КонецФункции

&НаКлиенте
Процедура СозданиеИЗаполнениеДокументов(Данные)

	ПараметрыОткрытия = Новый Структура ("ЗначенияЗаполнения", Данные);
	ОткрытьФорму("Документ.сжсвПереводИзФермыНаФерму.ФормаОбъекта",ПараметрыОткрытия,,новый УникальныйИдентификатор);
			
КонецПроцедуры

&НаСервере
Функция ПрочитатьДанныеДляВводаНаОсновании(ДокументСсылка)

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Отборы.Дата,
	               |	Отборы.Ферма,
	               |	Отборы.Корпус,
	               |	Отборы.Сектор,
	               |	Отборы.Группа,
	               |	Отборы.ТехнолГруппа,
	               |	Отборы.Группировка,
	               |	Отборы.Свиноматки.(
	               |		Свиноматка,
	               |		Масса,
	               |		Станок
	               |	),
	               |	Отборы.Хряки.(
	               |		Хряк,
	               |		Масса,
	               |		Станок
	               |	)
	               |ИЗ
	               |	Документ.Отборы КАК Отборы
	               |ГДЕ
	               |	Отборы.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Результат = Новый Структура;
	Результат.Вставить("Дата", Выборка.Дата+1);
	Результат.Вставить("Ферма", Выборка.Ферма);
	Результат.Вставить("Корпус", Выборка.Корпус);
	Результат.Вставить("Сектор", Выборка.Сектор);
	Результат.Вставить("Группа", Выборка.Группа);
	Результат.Вставить("ТехнолГруппа", Выборка.ТехнолГруппа);
	Результат.Вставить("Группировка", Выборка.Группировка);
	Результат.Вставить("Основание", ДокументСсылка);
	Результат.Вставить("Свиноматки", Новый ХранилищеЗначения(Выборка.Свиноматки.Выгрузить()));
	Результат.Вставить("Хряки", Новый ХранилищеЗначения(Выборка.Хряки.Выгрузить()));
	
	Возврат (Результат);
	
КонецФункции

#КонецОбласти