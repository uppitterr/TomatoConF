#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ТипВетеринарногоМероприятияПриИзменении(Элемент)
	Если Объект.ТипВетеринарногоМероприятия = ПредопределенноеЗначение("Перечисление.сжсвТипыВетеринарныхМероприятий.ДиагностическиеИсследования") тогда
		Элементы.Показатели.Видимость = Истина;
	иначе
		Элементы.Показатели.Видимость = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти