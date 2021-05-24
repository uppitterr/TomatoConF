#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Владелец = Параметры.Владелец;
	Картинка = ПредопределенноеЗначение("Перечисление.сжсвТипыФайлов.Картинка");
	
	Список.Отбор.Элементы.Очистить();
	Если ЗначениеЗаполнено(Владелец) Тогда
	
		Если ЗначениеЗаполнено(Владелец) Тогда
			Отбор = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Владелец");
			Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			Отбор.ПравоеЗначение = Владелец;
			Отбор.Использование = Истина;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Картинка) Тогда
			ОтборВ = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ОтборВ.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТипФайла");
			ОтборВ.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			ОтборВ.ПравоеЗначение = Картинка;
			ОтборВ.Использование = Истина;
		КонецЕсли;
		УстановленОтбор = Истина;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
