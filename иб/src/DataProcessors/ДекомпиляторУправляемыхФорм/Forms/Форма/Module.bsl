
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДеревоОМД = Новый ДеревоЗначений;
	ДеревоОМД.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	ДеревоОМД.Колонки.Добавить("ПолныйПуть", Новый ОписаниеТипов("Строка"));
	ДеревоОМД.Колонки.Добавить("Вид", Новый ОписаниеТипов("Строка"));
	ДеревоОМД.Колонки.Добавить("ИндексКартинки", Новый ОписаниеТипов("Число"));
	
	ДобавитьОМД(ДеревоОМД, Метаданные.ОбщиеФормы, 0, "ОбщиеФормы");
	ДобавитьОМД(ДеревоОМД, Метаданные.Справочники, 0, "Справочники");
	ДобавитьОМД(ДеревоОМД, Метаданные.Документы, 1, "Документы");
	ДобавитьОМД(ДеревоОМД, Метаданные.ПланыОбмена, 2, "ПланыОбмена");
	ДобавитьОМД(ДеревоОМД, Метаданные.ПланыВидовХарактеристик, 3, "ПланыВидовХарактеристик");
	ДобавитьОМД(ДеревоОМД, Метаданные.ПланыСчетов, 4, "ПланыСчетов");
	ДобавитьОМД(ДеревоОМД, Метаданные.ПланыВидовРасчета, 5, "ПланыВидовРасчета");
	ДобавитьОМД(ДеревоОМД, Метаданные.РегистрыРасчета, 6, "РегистрыРасчета");
	ДобавитьОМД(ДеревоОМД, Метаданные.РегистрыСведений, 7, "РегистрыСведений");
	ДобавитьОМД(ДеревоОМД, Метаданные.РегистрыНакопления, 8, "РегистрыНакопления");
	ДобавитьОМД(ДеревоОМД, Метаданные.РегистрыБухгалтерии, 9, "РегистрыБухгалтерии");
	ДобавитьОМД(ДеревоОМД, Метаданные.БизнесПроцессы, 10, "БизнесПроцессы");
	ДобавитьОМД(ДеревоОМД, Метаданные.Задачи, 11, "Задачи");
	
	ЗначениеВРеквизитФормы(ДеревоОМД, "ТаблицаОМД");     	
	
	ДеревоЭФ = Новый ДеревоЗначений;
	ДеревоЭФ.Колонки.Добавить("Представление",Новый ОписаниеТипов("Строка"));
	ДеревоЭФ.Колонки.Добавить("ПолноеИмя",    Новый ОписаниеТипов("Строка"));
	ДеревоЭФ.Колонки.Добавить("ТипРеквизита", Новый ОписаниеТипов("Строка"));  
	ДеревоЭФ.Колонки.Добавить("ТипЭлемента",  Новый ОписаниеТипов("Строка"));  

	ДеревоЭФ.Колонки.Добавить("ПутьКДанным",  Новый ОписаниеТипов("Строка"));
	ДеревоЭФ.Колонки.Добавить("РодительГр",   Новый ОписаниеТипов("Строка"));  
	ДеревоЭФ.Колонки.Добавить("РодительТип",  Новый ОписаниеТипов("Строка")); 
	ДеревоЭФ.Колонки.Добавить("УровеньЭл",    Новый ОписаниеТипов("Число"));
	ДеревоЭФ.Колонки.Добавить("Пометка",      Новый ОписаниеТипов("Булево"));
	
	ЗначениеВРеквизитФормы(ДеревоЭФ, "ТаблицаЭлементовФормы");
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьОМД(ДеревоОМД, ОбъектыМетаданных, ИндексКартинки, СтрМетаданные) 
	Строки = ДеревоОМД.Строки.Добавить(); 
	Строки.Представление = СтрМетаданные;
	Строки.Вид = СтрМетаданные;
	Строки.ИндексКартинки = ИндексКартинки;
	
	Для Каждого ОМД Из ОбъектыМетаданных Цикл
		
		Если СтрМетаданные = "ОбщиеФормы" Тогда
			стрФорм =  Строки.Строки.Добавить();
			стрФорм.Представление = ОМД.Имя;
			стрФорм.ПолныйПуть = ОМД.ПолноеИМя();
			стрФорм.Вид = "Форма";
		Иначе	
			НоваяСтрока = Строки.Строки.Добавить();
			НоваяСтрока.ПолныйПуть = ОМД.ПолноеИМя();
			НоваяСтрока.Вид = СтрМетаданные;
			НоваяСтрока.Представление = Строка(ОМД);
			НоваяСтрока.ИндексКартинки = ИндексКартинки;
			Для каждого Форма из ОМД.Формы Цикл
				Если Строка(Форма.ТипФормы)="Управляемая" Тогда
					стрФорм = НоваяСтрока.Строки.Добавить();
					стрФорм.Представление = Форма.Имя;
					стрФорм.ПолныйПуть = ОМД.ПолноеИМя();
					стрФорм.Вид = "Форма";
				КонецЕсли;
			КонецЦикла;	
		КонецЕсли;	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаОМДПриАктивизацииСтроки(Элемент)
	ТекСтрока = Элемент.ТекущиеДанные;
	сОчиститьДеревоЭлементов();
	
	Если ТекСтрока.Вид= "Форма" Тогда
		Если Найти(Элемент.ТекущиеДанные.ПолныйПуть,"ОбщаяФорма") > 0 ТОгда
			Форма = ПолучитьФорму(ТекСтрока.ПолныйПуть);
		Иначе	
			Форма = ПолучитьФорму(ТекСтрока.ПолныйПуть+".Форма."+ТекСтрока.Представление); 
		КонецЕсли;
		Для каждого Элемент из Форма.Элементы Цикл
			РодительТип = "";
			Если Строка(Элемент.Родитель) = "УправляемаяФорма" Тогда
				Родитель    = "";
			Иначе
				Родитель    = Элемент.Родитель.Имя;    
				РодительНайден = Ложь;
				Попытка
					РодительТип = Строка(ТипЗнч(Форма[Родитель]));
					РодительНайден = Истина;
				Исключение
				КонецПопытки;
				Если НЕ РодительНайден Тогда
					Попытка
						РодительТип = Строка(ТипЗнч(Форма["Объект"][Родитель]));
						РодительТип = "Динамическийсписок";  // для таблицы объекта реквизиты не добавяем
					Исключение
					КонецПопытки;    
				КонецЕсли;	
			КонецЕсли;	
			ВыводитьЭлемент = Истина;
			Попытка
				Если Строка(Элемент.Вид) = "Контекстное меню" Тогда
					ВыводитьЭлемент = Ложь;
				КонецЕсли;
			Исключение
			КонецПопытки;	
			
			Если ВыводитьЭлемент Тогда
				ТипЭлементаЗнч = "";
				ТипЭлемента = Строка(Тип(Элемент));
				ГруппыФормыВид = "";
				Если Тип(Элемент) = Тип("ГруппаФормы") Тогда
					ГруппыФормыВид = Строка(Элемент.Вид);
				КонецЕсли;	
				ТипРеквизита = "";
				ПутьКДанным  = "";
				Если ТипЭлемента = "Поле формы" Тогда
					ТипЭлементаЗнч = "ПолеФормы";
					ОпределенТипРеквизита = Ложь;
					Попытка
						ТипРеквизита = "" + Строка(ТипЗнч(Форма[Элемент.Имя])) + "";
						ОпределенТипРеквизита = Истина;
						ПутьКДанным  = """" + Элемент.Имя + """";
					Исключение
						ТипРеквизита = "???????";
						Если Тип(Элемент.Родитель) = Тип("ТаблицаФормы") Тогда
							ТипЭлемента  = "Колонка";
							ПутьКДанным  = """"+Родитель +"."+Элемент.Имя+"""";
						Иначе
							ПутьКДанным  = "???????";
						КонецЕсли;
					КонецПопытки;
					Если Не ОпределенТипРеквизита Тогда
						Попытка
							ТипРеквизита = "" + "??????" + Строка(ТипЗнч(Форма["Объект"][Элемент.Имя])) + "";
							Если ПутьКДанным  = "???????" Тогда
								ПутьКДанным  = """Объект." + Элемент.Имя + """";
							Иначе
								ПутьКДанным  = """Объект." + Сред(ПутьКДанным,2);
							КонецЕсли;
						Исключение
							ПутьКДанным  = """Объект." + Сред(ПутьКДанным,2);
						КонецПопытки;
					КонецЕсли;    
					Если РодительТип = "Динамическийсписок" Тогда
						ТипРеквизита = "----------------";
					КонецЕсли;	
				ИначеЕсли ТипЭлемента = "Группа формы" Тогда
					ТипЭлементаЗнч = ТипЭлемента;
					ТипРеквизита   = ГруппыФормыВид;
				ИначеЕсли ТипЭлемента = "Таблица формы" Тогда
					ТипЭлементаЗнч = "ТаблицаФормы";
					ОпределенТипРеквизита = Ложь;
					Попытка
						ТипРеквизита = "" + Строка(ТипЗнч(Форма[Элемент.Имя])) + "";
						ОпределенТипРеквизита = Истина;
						//ПутьКДанным  = """" + Элемент.Имя + """";
					Исключение
						ТипРеквизита = "???????";
					КонецПопытки;
					
					Если Не ОпределенТипРеквизита Тогда
						Попытка
							ТипРеквизита = "" +Строка(ТипЗнч(Форма["Объект"][Элемент.Имя])) + "";
							ТипРеквизита   = "Динамическийсписок";  // для таблицы объекта реквизиты не добавяем
							ПутьКДанным  = """Объект." + Элемент.Имя + """";
						Исключение
						КонецПопытки;
					Иначе
						Если Строка(ТипЗнч(Форма[Элемент.Имя])) = "Динамический список" Тогда
							ТипРеквизита   = "" + Строка(ТипЗнч(Форма[Элемент.Имя])) + "";
						Иначе
							ТипРеквизита   = "Таблицазначений";
						КонецЕсли;
					КонецЕсли;             
				ИначеЕсли ТипЭлемента = "Кнопка формы" Тогда
					ТипЭлементаЗнч = "КнопкаФормы";
				КонецЕсли;
				сДобавитьЭлементыФормыВДеревоЭлементов(Элемент.Имя,СтрЗаменить(ТипЭлементаЗнч," ",""),СтрЗаменить(ТипЭлемента," ",""),СтрЗаменить(ТипРеквизита," ",""),ПутьКДанным,Родитель,СтрЗаменить(РодительТип," ",""));
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ОпределитьТипРеквизитаОбъекта(ТипЗнчРеквизитаОбъекта,ИмяРеквизита)
	Если ТипЗнчРеквизитаОбъекта = Тип("СправочникСсылка."+Строка(ТипЗнчРеквизитаОбъекта)) Тогда
		Возврат "СправочникСсылка."+ИмяРеквизита;
	ИначеЕсли ТипЗнчРеквизитаОбъекта = Тип("ДокументСсылка."+ИмяРеквизита) Тогда
		Возврат "ДокументСсылка."+ИмяРеквизита;
	ИначеЕсли ТипЗнчРеквизитаОбъекта = Тип("ПеречислениеСсылка."+ИмяРеквизита) Тогда
		Возврат "ПеречислениеСсылка."+ИмяРеквизита;
	КонецЕсли;
КонецФункции	

&НаСервере
Процедура сДобавитьЭлементыФормыВДеревоЭлементов(Имя, ТипЭлементаЗнч, ТипЭлемента, ТипРеквизита, ПутьКДанным, Родитель, РодительТип) 
	
	дЭлементовФормы = РеквизитФормыВЗначение("ТаблицаЭлементовФормы",Тип("ДеревоЗначений"));
	
	Если ПутьКДанным = "" Тогда
		ПутьКДанным = """" + Имя + """";
	КонецЕсли;

	Если Родитель = "" Тогда
		Строки 					= дЭлементовФормы.Строки.Добавить();
		Строки.Представление	= Имя;
		Строки.ПолноеИмя 		= Имя+" ("+ТипЭлемента+")";       
		Строки.ТипРеквизита		= ТипРеквизита;  
		Строки.ТипЭлемента		= ТипЭлементаЗнч;
		Строки.ПутьКДанным		= ПутьКДанным;
		Строки.РодительГр  		= ?(ТипЭлемента = "Колонка",Родитель,"");  
		Строки.РодительТип		= РодительТип; 
		Строки.УровеньЭл  		= Строки.Уровень();

		ЗначениеВРеквизитФормы(дЭлементовФормы, "ТаблицаЭлементовФормы");
	Иначе
		мСтрока = дЭлементовФормы.Строки.Найти(Родитель,"Представление",Истина);
		Если НЕ мСтрока = Неопределено Тогда
			Строки 					= мСтрока.Строки.Добавить();
			Строки.Представление 	= Имя;
			Строки.ПолноеИмя 		= Имя+" ("+ТипЭлемента+")";
			Строки.ТипРеквизита		= ТипРеквизита;
			Строки.ТипЭлемента		= ТипЭлементаЗнч;
			Строки.ПутьКДанным		= ПутьКДанным;
			Строки.РодительГр  		= ?(ТипЭлемента = "Колонка",Родитель,"");  
			Строки.РодительТип  	= РодительТип;
			Строки.УровеньЭл  		= Строки.Уровень();
			ЗначениеВРеквизитФормы(дЭлементовФормы, "ТаблицаЭлементовФормы");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура сОчиститьДеревоЭлементов() 
	
	дЭлементовФормы = РеквизитФормыВЗначение("ТаблицаЭлементовФормы",Тип("ДеревоЗначений"));
	дЭлементовФормы.Строки.Очистить();
	ЗначениеВРеквизитФормы(дЭлементовФормы, "ТаблицаЭлементовФормы");
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЭлементовФормыПометкаПриИзменении(Элемент)
	Если ЭтаФорма.Элементы.ТаблицаЭлементовФормы.ТекущиеДанные.Пометка Тогда
	НайтиЭлементДляДекомпиляции(ЭтаФорма.Элементы.ТаблицаЭлементовФормы.ТекущиеДанные.Представление);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НайтиЭлементДляДекомпиляции(ВыбЭлементФормы)
	ТекСтрока = ЭтаФорма.Элементы.ТаблицаОМД.ТекущиеДанные;
	Форма = ПолучитьФорму(ТекСтрока.ПолныйПуть+".Форма."+ТекСтрока.Представление);
	Для каждого Элемент из Форма.Элементы Цикл
		Если ВыбЭлементФормы = Элемент.Имя Тогда
			ДекомпелироватьЭлемент(Элемент,ТекСтрока.ПолныйПуть,ТекСтрока.Представление);
		КонецЕсли;	
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ДекомпелироватьЭлемент(ВыбЭлементФормы,ПолныйПуть,Представление)
	ТипРеквизитаФормы	= ЭтаФорма.Элементы.ТаблицаЭлементовФормы.ТекущиеДанные.ТипРеквизита;
	ТипЭлементаФормы  = ЭтаФорма.Элементы.ТаблицаЭлементовФормы.ТекущиеДанные.ТипЭлемента;
	Если Тип(ВыбЭлементФормы) = Тип("ПолеФормы") Тогда
		ДобавитьРеквизитЭлемент(ВыбЭлементФормы,ТипРеквизитаФормы,ТипЭлементаФормы,"ПолеВвода");	
	ИначеЕсли Тип(ВыбЭлементФормы) = Тип("ГруппаФормы") Тогда
		ДобавитьРеквизитЭлемент(ВыбЭлементФормы,"",ТипЭлементаФормы,ТипЭлементаФормы);
	ИначеЕсли Тип(ВыбЭлементФормы) = Тип("ТаблицаФормы") Тогда
		ДобавитьРеквизитЭлемент(ВыбЭлементФормы,"Динамическийсписок",ТипЭлементаФормы,ТипРеквизитаФормы);
	ИначеЕсли Тип(ВыбЭлементФормы) = Тип("КнопкаФормы") Тогда
		ДобавитьРеквизитЭлемент(ВыбЭлементФормы,"",ТипЭлементаФормы,ТипРеквизитаФормы);
	ИначеЕсли Тип(ВыбЭлементФормы) = Тип("ДекорацияФормы") Тогда
		ДобавитьРеквизитЭлемент(ВыбЭлементФормы,"",ТипЭлементаФормы,ТипРеквизитаФормы);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьРеквизитЭлемент(ВыбЭлементФормы,ТипСписка,ТипЭлементаФормы,ОбластьМакета)
	
	ПутьКДанным 		= ЭтаФорма.Элементы.ТаблицаЭлементовФормы.ТекущиеДанные.ПутьКДанным;
	РодительЭл  		= ЭтаФорма.Элементы.ТаблицаЭлементовФормы.ТекущиеДанные.РодительГр;
	РодительТип         = ЭтаФорма.Элементы.ТаблицаЭлементовФормы.ТекущиеДанные.РодительТип;
	Уровень     		= ЭтаФорма.Элементы.ТаблицаЭлементовФормы.ТекущиеДанные.УровеньЭл;
	ТипРеквизитаФормы	= ЭтаФорма.Элементы.ТаблицаЭлементовФормы.ТекущиеДанные.ТипРеквизита;
	
	Если ПутьКДанным = "" Тогда
		ПутьКДанным = """" + ВыбЭлементФормы.Имя + """";
	КонецЕсли;
	
	ДобавитьСтрокуОтсеченияНаСервере(Уровень,"-");
	Если ЗначениеЗаполнено(ТипСписка) и РодительТип <> "Динамическийсписок" Тогда
		ДобавитьРеквизитыПоляНаСервере(ВыбЭлементФормы.Имя,""+ТипРеквизитаФормы+"",Уровень,РодительЭл,?(ТипРеквизитаФормы = "Динамическийсписок",Истина,Ложь));
		ДобавитьСтрокуОтсеченияНаСервере(Уровень,"`");
	КонецЕсли;

	ПолучитьОбластьНаСервере(ОбластьМакета);
	Для Каждого СтрокаСвойств ИЗ ТаблицаСвойствЭлементов Цикл
		Если СтрокаСвойств.НеИспользовать <> "" Тогда
			Продолжить;
		КонецЕсли;	
		Свойство = СтрокаСвойств.Свойство;
		Если Свойство = "Родитель" Тогда
			Попытка
				ДобавитьЭлементФормыНаСервере(ВыбЭлементФормы.Имя,ТипЭлементаФормы,ВыбЭлементФормы[Свойство]["Имя"],Уровень);
			Исключение
				ДобавитьЭлементФормыНаСервере(ВыбЭлементФормы.Имя,ТипЭлементаФормы,"",Уровень);
			КонецПопытки;
			Продолжить;
		ИначеЕсли Свойство = "ПутьКДанным" Тогда
			ДобавитьСвойствоПоляНаСервере(Свойство,ПутьКДанным,Уровень);
			Продолжить;
		КонецЕсли;
		ЗначениеПоУмолчанию = СтрокаСвойств.ЗначениеПоУмолчанию;
		ЗначениеОбязательно = СтрокаСвойств.ЗначениеОбязательно;
		ЗначенияСвойства = "";     
		Попытка
			ТипЗначенияСвойства = ТипЗнч(ВыбЭлементФормы[Свойство]);
			Если ТипЗначенияСвойства = Тип("Булево") Тогда
				ЗначенияСвойства = Формат(ВыбЭлементФормы[Свойство],"БЛ=Ложь; БИ=Истина");  
			ИначеЕсли ТипЗначенияСвойства = Тип("ГруппаФормы") Тогда
				ЗначенияСвойства = "Элементы.Найти("""+ВыбЭлементФормы[Свойство]["Имя"]+""")";
			ИначеЕсли ТипЗначенияСвойства = Тип("ВидГруппыФормы") Тогда
				ЗначенияСвойства = "ВидГруппыФормы."+ТипРеквизитаФормы;
			ИначеЕсли ТипЗначенияСвойства = Тип("ВидПоляФормы") Тогда
				ЗначенияСвойства = "ВидПоляФормы."+ОбластьМакета;  
			ИначеЕсли ТипЗначенияСвойства = Тип("ИспользованиеГруппИЭлементов") Тогда
				ЗначенияСвойства = "ИспользованиеГруппИЭлементов."+Строка(ВыбЭлементФормы[Свойство]); 
			ИначеЕсли ТипЗначенияСвойства = Тип("ГруппировкаПодчиненныхЭлементовФормы") Тогда
                 ЗначенияСвойства = "ГруппировкаПодчиненныхЭлементовФормы."+Строка(ВыбЭлементФормы[Свойство]);
			ИначеЕсли ТипЗначенияСвойства = Тип("ОписаниеТипов") Тогда
			ИначеЕсли ТипЗначенияСвойства = Тип("ПоложениеЗаголовкаЭлементаФормы") Тогда
			ИначеЕсли ТипЗначенияСвойства = Тип("РежимВыбораНезаполненного") Тогда	  
			ИначеЕсли ТипЗначенияСвойства = Тип("РежимРедактированияКолонки") Тогда  
			ИначеЕсли ТипЗначенияСвойства = Тип("ГоризонтальноеПоложениеЭлемента") Тогда
			ИначеЕсли ТипЗначенияСвойства = Тип("Строка") Тогда
				ЗначенияСвойства = """"+Строка(ВыбЭлементФормы[Свойство])+""""; 	
			Иначе
				ЗначенияСвойства = Строка(ВыбЭлементФормы[Свойство]);
			КонецЕсли;
			Если ЗначениеЗаполнено(ЗначенияСвойства) И НЕ (ЗначенияСвойства = ЗначениеПоУмолчанию) Тогда
				ДобавитьСвойствоПоляНаСервере(Свойство,ЗначенияСвойства,Уровень);
			ИначеЕсли  (ЗначенияСвойства = ЗначениеПоУмолчанию) И ЗначениеЗаполнено(ЗначениеОбязательно) Тогда
				ДобавитьСвойствоПоляНаСервере(Свойство,ЗначениеОбязательно,Уровень);
			КонецЕсли;
		Исключение
		КонецПопытки;
	КонецЦикла;
	ДобавитьСтрокуОтсеченияНаСервере(Уровень,"-");
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСвойствоПоляНаСервере(Свойство,ЗначениеСвойства,Уровень)
	
	Таб = "    " + Сред("                      ",1,Уровень*5);
	мТекст = ПолеТекстовогоДокумента;
	мТекст.ДобавитьСтроку(Таб+"НовыйЭлемент."+Свойство+" = "+ЗначениеСвойства+";");
	
КонецПроцедуры	

&НаСервере
Процедура ДобавитьСтрокуОтсеченияНаСервере(Уровень,СимвРазделитель)
	
	Таб = ""; //Сред("                      ",1,Уровень*5);
	мТекст = ПолеТекстовогоДокумента;
	СтрокаРазделитель = Таб+"//";
	Для КолСим = 1 По 80 Цикл
		СтрокаРазделитель = СтрокаРазделитель + СимвРазделитель;
	КонецЦикла;	
	мТекст.ДобавитьСтроку(СтрокаРазделитель);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьКомандуНаСервере()
	
	//// Добавить команду.
	//НоваяКоманда = Команды.Добавить("НоваяКоманда");
	//НоваяКоманда.Действие = "КомандаФормыДобавленнаяПрограммно";
	//
	//// Добавить кнопку и связать ее с командой.
	//НовыйЭлемент = Элементы.Добавить("КнопкаНоваяКоманда", Тип("КнопкаФормы"), Элементы.ФормаКоманднаяПанель);
	//НовыйЭлемент.ИмяКоманды = "НоваяКоманда";
	//
	//НовыйЭлемент.Заголовок = "Новая команда";
	//НовыйЭлемент.КнопкаПоУмолчанию = Истина;									 
	
КонецПроцедуры	

&НаСервере
Процедура ДобавитьРеквизитыПоляНаСервере(Поле,ТипРеквизита,Уровень,РодительЭл,Список = Ложь)
	
	Таб = Сред("                      ",1,Уровень*5);
	мТекст = ПолеТекстовогоДокумента;
	
    мТекст.ДобавитьСтроку(Таб+"ТипыРеквизита = Новый Массив;");
	мТекст.ДобавитьСтроку(Таб+"ТипыРеквизита.Добавить(Тип("""+ТипРеквизита+"""));");

	мТекст.ДобавитьСтроку(Таб+"ОписаниеТиповДляРеквизита = Новый ОписаниеТипов(ТипыРеквизита);");
	мТекст.ДобавитьСтроку(Таб+"ДобавляемыеРеквизиты = Новый Массив;");
	мТекст.ДобавитьСтроку(Таб+"ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы("""+Поле+""",ОписаниеТиповДляРеквизита,"""+?(ЗначениеЗаполнено(РодительЭл),РодительЭл,"")+""","""+Поле+""",Истина));");
	мТекст.ДобавитьСтроку(Таб+"ИзменитьРеквизиты(ДобавляемыеРеквизиты);");
	Если Список Тогда
		
		// Задать текст запроса и другие свойства динамического списка.
		мТекст.ДобавитьСтроку(Таб+"РеквизитСписок = ЭтаФорма["""+Поле+"""];");
		мТекст.ДобавитьСтроку(Таб+"//РеквизитСписок.ТекстЗапроса    = ""????????????Текст запроса?????????????????????"";");
		мТекст.ДобавитьСтроку(Таб+"РеквизитСписок.ОсновнаяТаблица = ""????????????Основная таблица?????????????????????"";");

	КонецЕсли;	
	
КонецПроцедуры	

&НаСервере
Процедура ДобавитьЭлементФормыНаСервере(Поле,ТипПоля,Родитель,Уровень)
	
	Таб = "  " + Сред("                      ",1,Уровень*5);
	мТекст = ПолеТекстовогоДокумента;
	Если ЗначениеЗаполнено(Родитель) Тогда
		мТекст.ДобавитьСтроку(Таб+"НовыйЭлемент = Элементы.Добавить("""+Поле+""", Тип("""+ТипПоля+"""),Элементы.Найти("""+Родитель+"""));");
	Иначе
		мТекст.ДобавитьСтроку(Таб+"НовыйЭлемент = Элементы.Добавить("""+Поле+""", Тип("""+ТипПоля+"""));");
	КонецЕсли;
	Если ТипПоля = "ПолеФормы" Тогда
		мТекст.ДобавитьСтроку(Таб+"//НовыйЭлемент.УстановитьДействие("+"""ПриИзменении"""+", "+"""ОбработчикПриИзмененииПоля????????"""+");");
	КонецЕсли;
КонецПроцедуры	

&НаСервере
Процедура ПолучитьОбластьНаСервере(Область)
	Макет = РеквизитФормыВЗначение("Объект").ПолучитьМакет("СвойстаЭлементовФормы");
	ТаблицаСвЭлементов = РеквизитФормыВЗначение("ТаблицаСвойствЭлементов");
	ТаблицаСвЭлементов.Очистить();
	ОбластьСвойств = Макет.ПолучитьОбласть(Область);
	Для Стр = 1 По ОбластьСвойств.ВысотаТаблицы Цикл
		   СтрокаСв = ТаблицаСвЭлементов.Добавить();
		   СтрокаСв.Свойство            = ОбластьСвойств.ПолучитьОбласть(Стр,1,Стр,1).ТекущаяОбласть.Текст;
		   СтрокаСв.ЗначениеПоУмолчанию = ОбластьСвойств.ПолучитьОбласть(Стр,2,Стр,2).ТекущаяОбласть.Текст;
		   СтрокаСв.ЗначениеОбязательно = ОбластьСвойств.ПолучитьОбласть(Стр,4,Стр,4).ТекущаяОбласть.Текст;
		   СтрокаСв.НеИспользовать      = ОбластьСвойств.ПолучитьОбласть(Стр,3,Стр,3).ТекущаяОбласть.Текст;
	КонецЦикла;	
	ЗначениеВРеквизитФормы(ТаблицаСвЭлементов,"ТаблицаСвойствЭлементов");
КонецПроцедуры	

