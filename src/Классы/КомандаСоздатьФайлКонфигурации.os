#Использовать json


Перем КонфигФайл;

Процедура ОписаниеКоманды(Команда) Экспорт

	Команда.Аргумент("CONFIG", "", "Путь куда сохранить файл конфигурации")
		.ТСтрока()
		.ПоУмолчанию("./mutagen.json");

КонецПроцедуры

Процедура ВыполнитьКоманду(Знач Команда) Экспорт

	ИнициализацияПараметров(Команда);

	Сообщить("Ответе на несколько вопросов");

	Сообщить("Путь к команде запуска тестов:");
	Запуск = Консоль.ПрочитатьСтроку();
	Сообщить(Запуск);

	Сообщить("Путь к каталогу с исходным кодом");
	Исходники = Консоль.ПрочитатьСтроку();

	Сообщить("Путь для сохранения ""выживщих"" мутантов");
	ВыжившиеМутанты = Консоль.ПрочитатьСтроку();

	Конфигурация = Новый Структура;
	Конфигурация.Вставить("run", Запуск);
	Конфигурация.Вставить("src", Исходники);
	Конфигурация.Вставить("survivors", ВыжившиеМутанты);

	_преобразовательJSON = Новый ПарсерJSON;

	конфиг = _преобразовательJSON.ЗаписатьJSON(Конфигурация);
	ЗаписьТекста = Новый ЗаписьТекста(КонфигФайл);
	ЗаписьТекста.ЗаписатьСтроку(конфиг);
	ЗаписьТекста.Закрыть();

	Сообщить("Done");

КонецПроцедуры

Процедура ИнициализацияПараметров(Знач Команда)

	КонфигФайл = Команда.ЗначениеАргумента("CONFIG");

	ТестФайл = Новый Файл(КонфигФайл);

	Если ТестФайл.Существует() Тогда

		УдалитьФайлы(КонфигФайл);

	КонецЕсли;

КонецПроцедуры