#Область ОбработчикКоманды

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
		Если  УправлениеПечатьюКлиент.ПроверитьДокументыПроведены(ПараметрКоманды, ПараметрыВыполненияКоманды.Источник) Тогда
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Документ.НазначениеОтветственных",
		"ПечатнаяФорма",
		ПараметрКоманды)
	КонецЕсли;

КонецПроцедуры

#КонецОбласти