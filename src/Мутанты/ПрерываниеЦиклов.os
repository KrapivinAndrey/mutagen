﻿Перем Токены;
Перем ТаблицаЗамен;


Функция Мутант() Экспорт
	
	Возврат "LoopBreak";
	
КонецФункции

Функция Описание() Экспорт
	
	Возврат "Замена Прервать/Продолжить на противоположные"
	
КонецФункции

#Область Плагин

Процедура Открыть(Парсер, Параметры) Экспорт
	
	ТаблицаЗамен = Парсер.ТаблицаЗамен();
	
КонецПроцедуры // Открыть()

Функция Закрыть() Экспорт
	Возврат Неопределено;
КонецФункции // Закрыть()

Функция Подписки() Экспорт
	Перем Подписки;
	Подписки = Новый Массив;
	Подписки.Добавить("ПосетитьОператорПрервать");
	Подписки.Добавить("ПосетитьОператорПродолжить");
	Возврат Подписки;
КонецФункции // Подписки()

#КонецОбласти

#Область ВспомогательныеФункции

Процедура Вставка(Текст, Позиция, Длина)
	НоваяЗамена = ТаблицаЗамен.Добавить();
	НоваяЗамена.Источник = Мутант();
	НоваяЗамена.Текст = Текст;
	НоваяЗамена.Позиция = Позиция;
	НоваяЗамена.Длина = Длина;
КонецПроцедуры

#КонецОбласти

#Область Подписки

Процедура ПосетитьОператорПродолжить(ОбъявлениеОператора) Экспорт
	
	Вставка("Прервать", ОбъявлениеОператора.Начало.Позиция, ОбъявлениеОператора.Начало.Длина);
	
КонецПроцедуры

Процедура ПосетитьОператорПрервать(ОбъявлениеОператора) Экспорт
	
	Вставка("Продолжить", ОбъявлениеОператора.Начало.Позиция, ОбъявлениеОператора.Начало.Длина);
	
КонецПроцедуры

#КонецОбласти