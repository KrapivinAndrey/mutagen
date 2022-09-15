#Использовать 1testrunner
#Использовать asserts
#Использовать ".."


Функция ПровестиТестирование(КаталогТестов)
	
	Тестер = Новый Тестер;
	Тестер.ВыключитьОтладкуВЛогахЗапускаемыхСкриптовOnescript();
	Результат = Тестер.ТестироватьКаталог(КаталогТестов);

	Возврат Результат;

КонецФункции

КаталогПроекта = ОбъединитьПути(ТекущийСценарий().Каталог, "..");
КаталогТестов = Новый Файл(ОбъединитьПути(КаталогПроекта, "tests"));

// Первый этап. Запуск тестов без изменения

Результат = ПровестиТестирование(КаталогТестов);
Утверждения.ПроверитьРавенство(Результат, 0, "Тесты и так не работают");

ФайлыДляМутаций = Новый Массив;
ФайлыДляМутаций.Добавить("./src/Мутанты/ЗаменаАрифметическихОпераций.os");

ВсегоМутантов = 0;
УбитоМутантов = 0;

Мутации = Новый Массив;
Для Каждого Мутация Из ОбщегоНазначения.ДоступныеМутанты() Цикл
	Мутации.Добавить(Вычислить("Новый " + Мутация.Класс))
КонецЦикла;

Для Каждого ФайлСКодом Из ФайлыДляМутаций Цикл

	Сообщить("Мутации для: " + ФайлСКодом);

	// Сохраним файл для того, чтобы потом восстановить

	Файл = Новый ЧтениеТекста(ФайлСКодом, КодировкаТекста.UTF8);
	ИсходныйКод = Файл.Прочитать();
	Файл.Закрыть();

	Запись = Новый ЗаписьТекста();
	
	ВсеМутанты = Кодогенерация.ВыполнитьЗаменыВКоде(ИсходныйКод, Мутации);
	ВсегоМутантов = ВсегоМутантов + ВсеМутанты.Количество();

	Для Каждого КлючМутант Из ВсеМутанты Цикл

		Запись.Открыть(ФайлСКодом, КодировкаТекста.UTF8);
		Запись.Записать(КлючМутант.Значение);
		Запись.Закрыть();

		Результат = ПровестиТестирование(КаталогТестов);

		Если Результат <> 0 Тогда

			УбитоМутантов = УбитоМутантов + 1;

		КонецЕсли;

	КонецЦикла;

	Запись.Открыть(ФайлСКодом, КодировкаТекста.UTF8);
	Запись.Записать(ИсходныйКод);
	Запись.Закрыть();

КонецЦикла;

Сообщить("Всего мутантов: " + ВсегоМутантов);
Сообщить("Убито мутантов: " + УбитоМутантов);
Сообщить("--------------------------------------");
Сообщить("MSI = " + Формат(УбитоМутантов/ВсегоМутантов * 100, "ЧДЦ=0; ЧН=0") + "%");