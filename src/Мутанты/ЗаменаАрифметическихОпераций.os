﻿
Перем Токены;
Перем ТаблицаЗамен;

Перем ТокеныАрифметическихОпераций;

Функция Мутант() Экспорт

	Возврат "SwitchOp";

КонецФункции

Функция Описание() Экспорт

	Возврат "Замена арифметических операций в выражениях. + -> - | - -> * | / -> - | * -> *"

КонецФункции

#Область Плагин

Процедура Открыть(Парсер, Параметры) Экспорт
	Токены = Парсер.Токены();
	ТаблицаЗамен = Парсер.ТаблицаЗамен();

	ТокеныАрифметическихОпераций = Новый Массив();
	ТокеныАрифметическихОпераций.Добавить(Токены.ЗнакСложения);
	ТокеныАрифметическихОпераций.Добавить(Токены.ЗнакВычитания);
	ТокеныАрифметическихОпераций.Добавить(Токены.ЗнакУмножения);
	ТокеныАрифметическихОпераций.Добавить(Токены.ЗнакДеления);

КонецПроцедуры // Открыть()

Функция Закрыть() Экспорт
	Возврат Неопределено;
КонецФункции // Закрыть()

Функция Подписки() Экспорт
	Перем Подписки;
	Подписки = Новый Массив;
	Подписки.Добавить("ПосетитьВыражениеБинарное");
	Возврат Подписки;
КонецФункции // Подписки()

#КонецОбласти

#Область ВспомогательныеФункции

Функция ЭтоАрифметическаяОперация(Токен)

	Результат = ТокеныАрифметическихОпераций.Найти(Токен) <> Неопределено;

	Возврат Результат;

КонецФункции

Функция ЗаменаОперации(Токен)

	Замены = Новый Соответствие();
	// + -> /
	// - -> *
	// / -> -
	// * -> +
	Замены.Вставить(Токены.ЗнакСложения, "/");
	Замены.Вставить(Токены.ЗнакВычитания, "*");
	Замены.Вставить(Токены.ЗнакДеления, "-");
	Замены.Вставить(Токены.ЗнакУмножения, "+");

	Результат = Замены.Получить(Токен);

	Возврат Результат;

КонецФункции

Процедура Вставка(Текст, Позиция)
	НоваяЗамена = ТаблицаЗамен.Добавить();
	НоваяЗамена.Источник = Мутант();
	НоваяЗамена.Текст = Текст;
	НоваяЗамена.Позиция = Позиция;
	НоваяЗамена.Длина = 1;
КонецПроцедуры

#КонецОбласти

#Область Подписки

Процедура ПосетитьВыражениеБинарное(ВыражениеБинарное) Экспорт 

	Если ЭтоАрифметическаяОперация(ВыражениеБинарное.Операция.Токен) Тогда

		НовыйТокен = ЗаменаОперации(ВыражениеБинарное.Операция.Токен);
		Вставка(НовыйТокен, ВыражениеБинарное.Операция.Позиция);

	КонецЕсли;

КонецПроцедуры

#КонецОбласти