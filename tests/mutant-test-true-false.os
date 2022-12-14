#Использовать asserts
#Использовать "../src"

Перем ЮнитТест;


// Процедура выполняется перед запуском теста
//
Процедура ПередЗапускомТеста() Экспорт
	
	
КонецПроцедуры // ПередЗапускомТеста()

Функция МутацииДляТеста()

	Мутант = ЗагрузитьСценарий("src/Мутанты/ЗаменаИстинаЛожь.os");
	Мутации = Новый Массив;
	Мутации.Добавить(Мутант);

	Возврат Мутации;

КонецФункции

// Функция возвращает список тестов для выполнения
//
// Параметры:
//    Тестирование    - Тестер        - Объект Тестер (1testrunner)
//    
// Возвращаемое значение:
//    Массив        - Массив имен процедур-тестов
//    
Функция ПолучитьСписокТестов(Тестирование) Экспорт
	
	ЮнитТест = Тестирование;
	СписокТестов = Новый Массив;

	СписокТестов.Добавить("ТестДолжен_ПроверитьИдентификатор");

	СписокТестов.Добавить("ТестДолжен_СформироватьЗаменитьПрисвоение");
	СписокТестов.Добавить("ТестДолжен_СформироватьЗаменитьУсловие");
	СписокТестов.Добавить("ТестДолжен_СформироватьЗаменитьЦикл");

	Возврат СписокТестов;

КонецФункции

Процедура ТестДолжен_ПроверитьИдентификатор() Экспорт

	Ожидаем.Что(МутацииДляТеста()[0].Мутант()).Равно("SwitchTrueFalse");

КонецПроцедуры


Процедура ТестДолжен_СформироватьМутанта(ИсходныйКод, КонтрольноеЗначение)

	Мутации = МутацииДляТеста();
	Результат = Кодогенерация.ВыполнитьЗаменыВКоде(ИсходныйКод, Мутации);

	Ожидаем.Что(Результат.Количество(), "Должна быть одна мутация").Равно(1);
	Для Каждого ИмяКод Из Результат Цикл

		Ожидаем.Что(ИмяКод.Значение).Равно(КонтрольноеЗначение);

	КонецЦикла;

КонецПроцедуры

Процедура ТестДолжен_СформироватьЗаменитьПрисвоение() Экспорт

	ТестДолжен_СформироватьМутанта("а = Истина;", "а = Ложь;");

КонецПроцедуры

Процедура ТестДолжен_СформироватьЗаменитьУсловие() Экспорт

	ТестДолжен_СформироватьМутанта("Если а = Ложь Тогда а=5; КонецЕсли;", "Если а = Истина Тогда а=5; КонецЕсли;");

КонецПроцедуры

Процедура ТестДолжен_СформироватьЗаменитьЦикл() Экспорт

	ТестДолжен_СформироватьМутанта("Пока Истина Цикл Сообщить(5); КонецЦикла;", "Пока Ложь Цикл Сообщить(5); КонецЦикла;");

КонецПроцедуры
