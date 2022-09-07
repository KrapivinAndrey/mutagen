///////////////////////////////////////////////////////////////////////////////

#Использовать "."
#Использовать cli
#Использовать tempfiles

// Логгер
Перем Лог;

///////////////////////////////////////////////////////////////////////////////

Процедура ВыполнитьПриложение()

	Лог.Отладка("Подключаем мутантов");
	Для Каждого ФайлМутант Из НайтиФайлы("src/Мутанты", "*.os") Цикл

		Лог.Отладка("Подключаю " + ФайлМутант.ПолноеИмя + " как " + ФайлМутант.ИмяБезРасширения);
		ПодключитьСценарий(ФайлМутант.ПолноеИмя, ФайлМутант.ИмяБезРасширения);

	КонецЦикла;

	Приложение = Новый КонсольноеПриложение(ПараметрыПриложения.ИмяПриложения(),
												"приложение для генерация файлов с мутациями кода");

	Приложение.Версия("v version", ПараметрыПриложения.Версия());

	Приложение.ДобавитьКоманду("l list", "Список доступных мутаций", Новый КомандаСписокМутантов);
	Приложение.ДобавитьКоманду("g generate", "Создать мутации", Новый КомандаСоздатьМутации);

	Приложение.Запустить(АргументыКоманднойСтроки);

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////

Лог = ПараметрыПриложения.Лог();

Попытка
	
	ВыполнитьПриложение();

Исключение

	Лог.КритичнаяОшибка(ОписаниеОшибки());

КонецПопытки;