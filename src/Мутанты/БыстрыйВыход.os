
Перем Токены;
Перем ТаблицаЗамен;

Перем ТипФункция;
Перем ТипПроцедура;

Функция Мутант() Экспорт

	Возврат "FastExit";

КонецФункции

Функция Описание() Экспорт

	Возврат "Выход из процедуры или функции без исполнения"

КонецФункции

#Область Плагин

Процедура Открыть(Парсер, Параметры) Экспорт

	Токены = Парсер.Токены();
	Типы = Парсер.Типы();

	ТаблицаЗамен = Парсер.ТаблицаЗамен();

	ТипФункция = Типы.ОбъявлениеСигнатурыФункции;
	ТипПроцедура = Типы.ОбъявлениеСигнатурыПроцедуры;

КонецПроцедуры // Открыть()

Функция Закрыть() Экспорт
	Возврат Неопределено;
КонецФункции // Закрыть()

Функция Подписки() Экспорт
	Перем Подписки;
	Подписки = Новый Массив;
	Подписки.Добавить("ПосетитьОбъявлениеМетода");

	Возврат Подписки;

КонецФункции // Подписки()

#КонецОбласти

#Область ВспомогательныеФункции

Процедура Вставка(Текст, Позиция)
	НоваяЗамена = ТаблицаЗамен.Добавить();
	НоваяЗамена.Источник = Мутант();
	НоваяЗамена.Текст = Текст;
	НоваяЗамена.Позиция = Позиция;
	НоваяЗамена.Длина = 0;
КонецПроцедуры

#КонецОбласти

#Область Подписки

Процедура ПосетитьОбъявлениеМетода(ОбъявлениеМетода) Экспорт 

	Если ОбъявлениеМетода.Сигнатура.Тип = ТипФункция Тогда
	
		Вставка("Возврат Null;", ОбъявлениеМетода.Операторы[0].Начало.Позиция);

	ИначеЕсли ОбъявлениеМетода.Сигнатура.Тип = ТипПроцедура Тогда

		Вставка("Возврат;", ОбъявлениеМетода.Операторы[0].Начало.Позиция);

	Иначе

		ВызватьИсключение "Неизвестная сигнатура";

	КонецЕсли;

КонецПроцедуры

#КонецОбласти