#Использовать gitrunner
#Использовать tempfiles

Перем Лог;
Перем КаталогПроекта;

Процедура СобратьПакет(Знач ВыходнойКаталог, Знач ПутьКМанифестуСборки)

	КомандаOpm = Новый Команда;
	// КомандаOpm.УстановитьРабочийКаталог(Каталог);
	КомандаOpm.УстановитьКоманду("opm");
	КомандаOpm.ДобавитьПараметр("build");
	КомандаOpm.ДобавитьПараметр("-m");
	КомандаOpm.ДобавитьПараметр(ПутьКМанифестуСборки);
	КомандаOpm.ДобавитьПараметр("-o");
	КомандаOpm.ДобавитьПараметр(ВыходнойКаталог);
	КомандаOpm.ДобавитьПараметр(КаталогПроекта);
	КомандаOpm.ПоказыватьВыводНемедленно(Истина);

	КодВозврата = КомандаOpm.Исполнить();

	Если КодВозврата <> 0  Тогда
		ВызватьИсключение КомандаOpm.ПолучитьВывод();
	КонецЕсли;

КонецПроцедуры

Процедура ПолезнаяРабота()

	// КаталогСборки = ВременныеФайлы.СоздатьКаталог();
	// КаталогУстановки = ВременныеФайлы.СоздатьКаталог();

	ПутьКМанифестуСборки = ОбъединитьПути(КаталогПроекта, "packagedef");

	СобратьПакет(КаталогПроекта, ПутьКМанифестуСборки);

	Лог.Информация("Пакет собран в каталог <%1>", КаталогПроекта);

КонецПроцедуры

КаталогПроекта = ОбъединитьПути(ТекущийСценарий().Каталог, "..");
Лог = Логирование.ПолучитьЛог("task.install-opm");
// Лог.УстановитьУровень(УровниЛОга.отладка);

ПолезнаяРабота();