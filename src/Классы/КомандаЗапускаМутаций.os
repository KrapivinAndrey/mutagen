#Использовать logos
#Использовать json
#Использовать fs
#Использовать tempfiles
#Использовать 1commands
#Использовать coloratos

// Лог приложения
Перем Лог;

// Список файлов с исходным кодом
Перем ФайлыИсходников;

// Команда запуска тестирования
Перем КомандаЗапуска;

// Место хранения выживших мутантов
Перем КаталогВыгрузки;

// Спиоск применяемых мутаций
Перем Мутации;

//Допустимый уровень MSI
Перем УровеньВыживаемости;

Процедура ОписаниеКоманды(Команда) Экспорт

	Команда.Аргумент("CONFIG", "", "Файл конфигурации запуска")
		.ТСтрока()
		.ПоУмолчанию("./mutagen.json");

КонецПроцедуры

Процедура ВыполнитьКоманду(Знач Команда) Экспорт

	ИнициализацияПараметров(Команда);

КонецПроцедуры

Процедура ИнициализацияПараметров(Знач Команда)

	КонфигФайл = Команда.ЗначениеАргумента("CONFIG");

	Если НЕ ФС.ФайлСуществует(КонфигФайл) Тогда

		Лог.Ошибка("Не найден файл конфигурации запуска. Можете создать его командой mutagen config");
		ЗавершитьРаботу(1);

	КонецЕсли;
	
	Данные = ОбщегоНазначения.ПолучитьТекстИзФайла(КонфигФайл);
	Парсер = Новый ПарсерJSON;
	Конфигурация = Парсер.ПрочитатьJSON(Данные);

	ПрочитатьФайлыИсходников(Конфигурация);
	ПрочитатьКомандуЗапуска(Конфигурация);
	ПрочитатьКаталогВыгрузки(Конфигурация);
	ПрочитатьМутантов(Конфигурация);
	ПрочитатьДопустимыйУровень(Конфигурация);

	ЗапуститьГенерацию();

КонецПроцедуры

Процедура ЗапуститьГенерацию()

	НачалоЗамера = ТекущаяУниверсальнаяДатаВМиллисекундах();

	МоиВременныеФайлы = Новый МенеджерВременныхФайлов();

	ВсегоМутантов = 0;
	Выжило = 0;

	Для Каждого Исходник Из ФайлыИсходников Цикл

		Лог.Информация("Генерация мутаций для файла " + Исходник.Имя);

		ИсходныйКод = ОбщегоНазначения.ПолучитьТекстИзФайла(Исходник.ПолноеИмя);
		ПутьВПроекте = ФС.ОтносительныйПуть(ТекущийКаталог(), Исходник.ПолноеИмя);
		Лог.Отладка("Путь к исходнику: " + ПутьВПроекте);

		НовыеИсходники = Кодогенерация.ВыполнитьЗаменыВКоде(ИсходныйКод, Мутации);
		Лог.Отладка("Новых исходников " + НовыеИсходники.Количество());
		Сч = 1;

		Для Каждого ИмяКод Из НовыеИсходники Цикл

			ВсегоМутантов = ВсегоМутантов + 1;

			Лог.Информация("Работаю над мутантом #" + Сч);

			КаталогДляЗапуска = МоиВременныеФайлы.СоздатьКаталог();

			Лог.Отладка("Копируем каталог проекта в " + КаталогДляЗапуска);
			ФС.КопироватьСодержимоеКаталога(ПараметрыПриложения.КаталогПриложения(), КаталогДляЗапуска);

			Лог.Отладка("Копируем мутанта");
			НовыйПуть = ОбъединитьПути(КаталогДляЗапуска, ПутьВПроекте);
			Лог.Отладка("Копируем мутанта в " + НовыйПуть);
			ОбщегоНазначения.ЗаписатьТекстВФайл(НовыйПуть, ИмяКод.Значение);

			Лог.Отладка("Запуск тестов");
			
			КомандаТестов = КомандаТестирования(КаталогДляЗапуска);
			
			Попытка

				КомандаТестов.Исполнить();
				ЦветнойВывод.ВывестиСтроку("Мутант убит", "Зеленый");

			Исключение

				ЦветнойВывод.ВывестиСтроку("Мутант выжил", "Красный");
				Выжило = Выжило + 1;
				ПутьСохраненияМутанта = ОбъединитьПути(КаталогВыгрузки, ИмяМутанта(ПутьВПроекте, ИмяКод.Ключ));
				ОбщегоНазначения.ЗаписатьТекстВФайл(ПутьСохраненияМутанта, ИмяКод.Значение);

			КонецПопытки;
			
			Сч = Сч + 1;

		КонецЦикла;
		
	КонецЦикла;

	МоиВременныеФайлы.Удалить();

	Лог.Информация("Всего мутантов:" + ВсегоМутантов);
	Лог.Информация("Выжило мутантов: " + Выжило);

	MSI = Окр((Выжило / ВсегоМутантов) * 100, 2);

	Лог.Информация("MSI = " + MSI + " %");

	Затрачено = Окр((ТекущаяУниверсальнаяДатаВМиллисекундах() - НачалоЗамера) / 1000);
	Лог.Отладка("Затрачено времени: " + Затрачено + " сек.");

	Если MSI > УровеньВыживаемости Тогда

		Лог.Ошибка("Уровень выживаемости мутантов превышает допустимый");
		ЗавершитьРаботу(1);

	КонецЕсли;

КонецПроцедуры

Функция КомандаТестирования(РабочийКаталог)

	КомандаТестов = Новый Команда;
	КомандаТестов.УстановитьРабочийКаталог(РабочийКаталог);
	КомандаТестов.УстановитьКоманду("oscript");
	КомандаТестов.ДобавитьПараметр(КомандаЗапуска);
	КомандаТестов.УстановитьПериодОпросаЗавершения(15000);
	КомандаТестов.УстановитьПравильныйКодВозврата(3);

	Возврат КомандаТестов;

КонецФункции

#Область ЧтениеНастроек

Процедура ПрочитатьФайлыИсходников(КонфигурацияЗапуска)

	Если КонфигурацияЗапуска["src"] = Неопределено
			ИЛИ НЕ ФС.КаталогСуществует(КонфигурацияЗапуска["src"]) Тогда

		Лог.Ошибка("Некорректно указан каталог исходников для генерации мутаций");
		ЗавершитьРаботу(1);

	КонецЕсли;

	ФайлыИсходников = НайтиФайлы(КонфигурацияЗапуска["src"], "*.os", Истина);

	Если ФайлыИсходников.Количество() = 0 Тогда

		Лог.Ошибка("Не найдены файлы для генерации мутаций в каталоге исходников");
		ЗавершитьРаботу(1);

	КонецЕсли;

	Лог.Отладка("Найдено файлов для генерации: " + ФайлыИсходников.Количество());

КонецПроцедуры

Процедура ПрочитатьКомандуЗапуска(КонфигурацияЗапуска)

	КомандаЗапуска = ФС.ОтносительныйПуть(ТекущийКаталог(), КонфигурацияЗапуска["task"]);
	Если КомандаЗапуска = Неопределено 
			ИЛИ Не ФС.ФайлСуществует(КомандаЗапуска) Тогда

		Лог.Ошибка("Не указан файл для запуска тестов");
		ЗавершитьРаботу(1);

	КонецЕсли;

	Лог.Отладка("Команда запуска тестов: " + КомандаЗапуска);

КонецПроцедуры

Процедура ПрочитатьКаталогВыгрузки(КонфигурацияЗапуска)

	КаталогВыгрузки = ФС.ПолныйПуть(КонфигурацияЗапуска["survivors"]);
	Если КаталогВыгрузки = Неопределено Тогда 

		Лог.Ошибка("Не указан каталог для сохранения выживших");
		ЗавершитьРаботу(1);

	КонецЕсли;

	Лог.Отладка("Создаю/очищаю каталог выгрузки " + КаталогВыгрузки);
	ФС.ОбеспечитьПустойКаталог(КаталогВыгрузки);
	УдалитьФайлы(КаталогВыгрузки, "*.os");
	УдалитьФайлы(КаталогВыгрузки, "*.bls"); // Это конечно не os, но на всякий случай удалим

КонецПроцедуры

Процедура ПрочитатьМутантов(КонфигурацияЗапуска)

	Пропуск = ФС.ПолныйПуть(КонфигурацияЗапуска["skip"]);
	ИсключаемыеМутации = Новый Массив;
	Если ЗначениеЗаполнено(Пропуск) Тогда

		ИсключаемыеМутации = СтрРазделить(Пропуск, ",");

	КонецЕсли;

	Мутации = Новый Массив;
	Для Каждого Мутация Из ОбщегоНазначения.ДоступныеМутанты() Цикл

		Если ИсключаемыеМутации.Найти(Мутация.Идентификатор) <> Неопределено Тогда

			Лог.Информация("Исключена мутация: " + Мутация.Идентификатор);
			Продолжить;
		
		КонецЕсли;

		Мутации.Добавить(Вычислить("Новый " + Мутация.Класс));

	КонецЦикла;

	Если Мутации.Количество() = 0 Тогда

		Лог.Ошибка("Не осталось мутаций для применения");
		ЗавершитьРаботу(1);

	КонецЕсли;

КонецПроцедуры

Процедура ПрочитатьДопустимыйУровень(КонфигурацияЗапуска)

	УровеньВыживаемости = КонфигурацияЗапуска["msi"];
	Если УровеньВыживаемости = Неопределено Тогда

		УровеньВыживаемости = 70;

	КонецЕсли;

	Лог.Отладка("Уровень MSI " + УровеньВыживаемости);

КонецПроцедуры


#КонецОбласти

Функция ИмяМутанта(ПутьКИсходникам, Идентификатор)

	Имя = Лев(ПутьКИсходникам, СтрДлина(ПутьКИсходникам) - 3) + "_" + Идентификатор + ".os";
	Имя = СтрЗаменить(Имя, "\\", "_");
	Имя = СтрЗаменить(Имя, "\", "_");
	Имя = СтрЗаменить(Имя, "/", "_");

	Лог.Отладка("Имя для сохранения " + Имя);

	Возврат Имя;

КонецФункции

Лог = ПараметрыПриложения.Лог();