#Использовать asserts
#Использовать "../src"

Перем ЮнитТест;

Перем КодУсловие;
Перем КодУсловиеНов;

Перем КодЦикл;
Перем КодЦиклНов;


// Процедура выполняется перед запуском теста
//
Процедура ПередЗапускомТеста() Экспорт
	
	
КонецПроцедуры // ПередЗапускомТеста()

Функция МутацииДляТеста()

	Мутант = ЗагрузитьСценарий("src/Мутанты/ВсегдаИстинныеУсловия.os");
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
	
	СписокТестов.Добавить("ТестДолжен_СформироватьЗаменуНаИстина");
	СписокТестов.Добавить("ТестДолжен_СформироватьЗаменуНаИстинаЦикл");

	Возврат СписокТестов;

КонецФункции

Процедура ТестДолжен_ПроверитьИдентификатор() Экспорт

	Ожидаем.Что(МутацииДляТеста()[0].Мутант()).Равно("AlwaysTrue");

КонецПроцедуры

Процедура ТестДолжен_СформироватьМутанта(ИсходныйКод, КонтрольноеЗначение)

	Мутации = МутацииДляТеста();
	Результат = Кодогенерация.ВыполнитьЗаменыВКоде(ИсходныйКод, Мутации);

	Ожидаем.Что(Результат.Количество(), "Должна быть одна мутация").Равно(1);
	Для Каждого ИмяКод Из Результат Цикл

		Ожидаем.Что(ИмяКод.Значение).Равно(КонтрольноеЗначение);

	КонецЦикла;

КонецПроцедуры

Процедура ТестДолжен_СформироватьЗаменуНаИстина() Экспорт

	ТестДолжен_СформироватьМутанта(КодУсловие, КодУсловиеНов);

КонецПроцедуры

Процедура ТестДолжен_СформироватьЗаменуНаИстинаЦикл() Экспорт

	ТестДолжен_СформироватьМутанта(КодЦикл, КодЦиклНов);

КонецПроцедуры


КодУсловие = "Если 2 = 5 Тогда а=5; КонецЕсли;";
КодУсловиеНов = "Если Истина Тогда а=5; КонецЕсли;";

КодЦикл = "Пока 2 = 5 Цикл а=5; КонецЦикла;";
КодЦиклНов = "Пока Истина Цикл а=5; КонецЦикла;";
