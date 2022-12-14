#Использовать osparser

// Лог
Перем Лог;

Функция ВыполнитьЗаменыВКоде(Код, Мутации) Экспорт

	Результат = Новый Соответствие();

	Парсер = Новый ПарсерВстроенногоЯзыка;

	Замер = ТекущаяУниверсальнаяДатаВМиллисекундах();
	Лог.Отладка("Начинаю генерацию мутантов.");
	Парсер.Пуск(Код, Мутации);
	Коэф = 1000;
	Заняло = (ТекущаяУниверсальнаяДатаВМиллисекундах() - Замер) / Коэф;
	Лог.Отладка("Генерация закончилась. Затрачено: " + Заняло);
	
	ТаблицаЗамен = Парсер.ТаблицаЗамен();

	Для Каждого Замена Из ТаблицаЗамен Цикл

		Исходник = Парсер.Исходник(); 
	
		ПерваяЧасть = Лев(Исходник, Замена.Позиция - 1);
		ТекстЗамены = Замена.Текст;
		ВтораяЧасть = Сред(Исходник, Замена.Позиция + Замена.Длина);
	
		Состав = Новый Массив();
		Состав.Добавить(ПерваяЧасть);
		Состав.Добавить(ТекстЗамены);
		Состав.Добавить(ВтораяЧасть);
	
		НовыйИсходник = СтрСоединить(Состав);
		Имя = ХешКода(НовыйИсходник);

		Результат.Вставить(Имя, НовыйИсходник);

	КонецЦикла;

	Возврат Результат;

КонецФункции

Функция ХешКода(Код) Экспорт

	Хеш = Новый ХешированиеДанных(ХешФункция.MD5);
	Хеш.Добавить(Код);

	Возврат СтрЗаменить(Строка(Хеш.ХешСумма), " ", "");

КонецФункции



Лог = ПараметрыПриложения.Лог();
