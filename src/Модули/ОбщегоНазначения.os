// Лог выполнения
#Использовать fs

Перем Лог;



Функция ПолучитьТекстИзФайла(ИмяФайла = "") Экспорт

    ФайлОбмена = Новый Файл(ИмяФайла);
    Данные = "";

    Если ФайлОбмена.Существует() Тогда
        Текст = Новый ЧтениеТекста(ИмяФайла, КодировкаТекста.UTF8);
        Данные = Текст.Прочитать();
        Текст.Закрыть();
    Иначе
        ВызватьИсключение "Файл не найден: " + ИмяФайла;
    КонецЕсли;

    Возврат Данные;

КонецФункции

Функция ЗаписатьТекстВФайл(ИмяФайла = "", Данные = Неопределено) Экспорт
    
	Попытка

		ЗаписьТекста = Новый ЗаписьТекста(ИмяФайла, КодировкаТекста.UTF8);
		ЗаписьТекста.Записать(Данные);
		ЗаписьТекста.Закрыть();

	Исключение

		_ОписаниеОшибки = ИнформацияОбОшибке();
		Лог.Ошибка("Не удалось записать файл. По причине: " + ПодробноеПредставлениеОшибки(_ОписаниеОшибки));
		ЗавершитьРаботу(1);

	КонецПопытки;

    возврат Истина;
КонецФункции

Процедура ПодключитьМутантов() Экспорт

	Лог.Отладка("Подключаем мутантов");
	ПутьКМутантам = ОбъединитьПути(ПараметрыПриложения.КаталогПриложения(), "src", "Мутанты");
	Для Каждого ФайлМутант Из НайтиФайлы(ПутьКМутантам, "*.os") Цикл

		Лог.Отладка("Подключаю " + ФайлМутант.ПолноеИмя + " как " + ФайлМутант.ИмяБезРасширения);
		ПодключитьСценарий(ФайлМутант.ПолноеИмя, ФайлМутант.ИмяБезРасширения);

	КонецЦикла;

КонецПроцедуры

Функция ДоступныеМутанты() Экспорт

	Результат = Новый Массив;
	ПутьКМутантам = ОбъединитьПути(ПараметрыПриложения.КаталогПриложения(), "src", "Мутанты");
	Для Каждого ФайлМутант Из НайтиФайлы(ПутьКМутантам, "*.os") Цикл

		Имя = ФайлМутант.ИмяБезРасширения;
		Мутант = Вычислить("Новый " + Имя);
		Идентификатор = Мутант.Мутант();
		Описание = Мутант.Описание();

		Запись = НовыйЗаписьОМутантах(Имя, Идентификатор, Описание);
		Результат.Добавить(Запись);

	КонецЦикла;

	Возврат Результат;

КонецФункции

Функция НовыйЗаписьОМутантах(Класс, Идентификатор, Описание)

	Запись = Новый Структура("Класс, Идентификатор, Описание", Класс, Идентификатор, Описание);
	Возврат Запись;

КонецФункции

Функция УбратьКавычки(Знач пСтрока) Экспорт
	
	строкаБезКавычек = пСтрока;
	
	Если СтрНачинаетсяС(строкаБезКавычек, """") Тогда
		СтрокаБезКавычек = Сред(СтрокаБезКавычек, 2);
	КонецЕсли;
	
	Если СтрЗаканчиваетсяНа(строкаБезКавычек, """") Тогда
		СтрокаБезКавычек = Лев(СтрокаБезКавычек, СтрДлина(СтрокаБезКавычек) - 1);
	КонецЕсли;
	
	СтрокаБезКавычек = СтрЗаменить(СтрокаБезКавычек, """""", """");
	
	Возврат строкаБезКавычек;
	
КонецФункции

Процедура СоздатьФайлыСМутантами(НовыеИсходники, КаталогВыгрузки, Расширение) Экспорт

	Для Каждого ИмяКод Из НовыеИсходники Цикл

		НовыйПуть = ОбъединитьПути(КаталогВыгрузки, ИмяКод.Ключ + Расширение);
		Лог.Отладка("Сохраняем новый исходник по пути: " + НовыйПуть);

		ЗаписатьТекстВФайл(НовыйПуть, ИмяКод.Значение);
	
	КонецЦикла;
	
КонецПроцедуры

Лог = ПараметрыПриложения.Лог();
