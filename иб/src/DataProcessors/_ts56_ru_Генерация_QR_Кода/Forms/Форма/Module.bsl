&НаСервере
Функция мСформировать_Сервер()
	лТекст = СокрЛП( Объект._Текст );
	Если лТекст = "" Тогда
		Сообщить( "Текст пустой." );
		Возврат Ложь;
	КонецЕсли;
	
	лЭтот_Объект = РеквизитФормыВЗначение( "Объект" );
	
	лДанные = лЭтот_Объект._QR_Код_Получить( лТекст, Объект._Погрешность_Уровень, Объект._Размер_Пикселей, Объект._Файл_Имя_Полное );
	Если ТипЗнч( лДанные ) <> Тип( "ДвоичныеДанные" ) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ЭтаФорма._Изображение = ПоместитьВоВременноеХранилище( лДанные );
	Возврат Истина;
КонецФункции

&НаКлиенте
Процедура мСформировать(Команда)
	мСформировать_Сервер();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Объект._Размер_Пикселей = 0 Тогда
		Объект._Размер_Пикселей = 1000;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура мФайл_Имя_Полное_Начало_Выбора( пЭлемент, пДанные_Выбора, пСтандартная_Обработка )
	пСтандартная_Обработка = Ложь;
	лДиалог = Новый ДиалогВыбораФайла( РежимДиалогаВыбораФайла.Сохранение );
	лДиалог.ПолноеИмяФайла = Объект._Файл_Имя_Полное;
	лДиалог.Фильтр = "PNG (*.png)|*.png";

	Если лДиалог.Выбрать() Тогда
		Объект._Файл_Имя_Полное = лДиалог.ПолноеИмяФайла;
	КонецЕсли;
КонецПроцедуры
