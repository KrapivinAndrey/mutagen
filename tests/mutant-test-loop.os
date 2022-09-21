#Использовать asserts
#Использовать "../src"

Перем ЮнитТест;

Перем КодПродолжить;
Перем КодПрервать;


// Процедура выполняется перед запуском теста
//
Процедура ПередЗапускомТеста() Экспорт
	
	
КонецПроцедуры // ПередЗапускомТеста()

Функция МутацииДляТеста()

	Мутант = ЗагрузитьСценарий("src/Мутанты/ПрерываниеЦиклов.os");
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

	СписокТестов.Добавить("ТестДолжен_СформироватьПродолжить");
	СписокТестов.Добавить("ТестДолжен_СформироватьПрервать");

	Возврат СписокТестов;

КонецФункции

Процедура ТестДолжен_ПроверитьИдентификатор() Экспорт

	Ожидаем.Что(МутацииДляТеста()[0].Мутант()).Равно("LoopBreak");

КонецПроцедуры

Процедура ТестДолжен_СформироватьМутанта(ИсходныйКод, КонтрольноеЗначение)

	Мутации = МутацииДляТеста();
	Результат = Кодогенерация.ВыполнитьЗаменыВКоде(ИсходныйКод, Мутации);

	Ожидаем.Что(Результат.Количество(), "Должна быть одна мутация").Равно(1);
	Для Каждого ИмяКод Из Результат Цикл

		Ожидаем.Что(ИмяКод.Значение).Равно(КонтрольноеЗначение);

	КонецЦикла;

КонецПроцедуры

Процедура ТестДолжен_СформироватьПродолжить() Экспорт

	ТестДолжен_СформироватьМутанта(КодПрервать, КодПродолжить);

КонецПроцедуры

Процедура ТестДолжен_СформироватьПрервать() Экспорт

	ТестДолжен_СформироватьМутанта(КодПродолжить, КодПрервать);

КонецПроцедуры

КодПрервать = "Пока Истина Цикл Прервать; КонецЦикла;";
КодПродолжить = "Пока Истина Цикл Продолжить; КонецЦикла;";
