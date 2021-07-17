///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьЗаголовок();
	УстановитьОписание();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерейтиКДокументации(Команда)
	
	МодульРаботаСПочтовымиСообщениямиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСПочтовымиСообщениямиКлиент");
	МодульРаботаСПочтовымиСообщениямиКлиент.ПерейтиКДокументацииПоВводуУчетнойЗаписиЭлектроннойПочты();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьЗаголовок()
	
	ТекстЗаголовка = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "Заголовок");
	
	Если ЗначениеЗаполнено(ТекстЗаголовка) Тогда 
		Заголовок = ТекстЗаголовка;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОписание()
	
	Описание = Новый Структура("Текст, Подробно, Ссылка");
	ЗаполнитьЗначенияСвойств(Описание, Параметры);
	
	Элементы.ПерейтиКДокументации.Видимость =
		ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями")
		И ЗначениеЗаполнено(Описание.Подробно)
		И ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "ИспользоватьЭлектроннуюПочту", Ложь);
	
	Если Не ЗначениеЗаполнено(Описание.Текст) Тогда 
		Возврат;
	КонецЕсли;
	
	Текст.Добавить(Описание.Текст, Тип("ТекстФорматированногоДокумента"));
	
	Если ЗначениеЗаполнено(Описание.Подробно) Тогда 
		
		Текст.Добавить(, Тип("ПереводСтрокиФорматированногоДокумента"));
		Текст.Добавить(, Тип("ПереводСтрокиФорматированногоДокумента"));
		Текст.Добавить(Описание.Подробно, Тип("ТекстФорматированногоДокумента"));
		
		Элементы.Индикатор.Картинка = БиблиотекаКартинок.Предупреждение32;
		
	КонецЕсли;
	
	УстановитьОписаниеОшибкиАутентификации(Описание);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОписаниеОшибкиАутентификации(Описание)
	
	Если СтрНайти(ВРег(Описание.Подробно), "USERNAME AND PASSWORD NOT ACCEPTED") = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	Текст.Добавить(, Тип("ПереводСтрокиФорматированногоДокумента"));
	Текст.Добавить(, Тип("ПереводСтрокиФорматированногоДокумента"));
	
	Ссылка = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "Ссылка");
	
	Если ЗначениеЗаполнено(Ссылка) Тогда 
		
		ШаблонСтроки = НСтр("ru = 'Перейдите к <a href = ""%1"">настройкам учетной записи электронной почты</a> для корректировки логина, пароля.'");
		НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(Ссылка);
		
		Строка = СтроковыеФункции.ФорматированнаяСтрока(ШаблонСтроки, НавигационнаяСсылка);
		
	Иначе
		
		Строка = НСтр("ru = 'Перейдите к настройкам учетной записи электронной почты для корректировки логина, пароля.'");
		
	КонецЕсли;
	
	Строки = Новый Массив;
	Строки.Добавить(Текст.ПолучитьФорматированнуюСтроку());
	Строки.Добавить(Строка);
	
	Текст.УстановитьФорматированнуюСтроку(Новый ФорматированнаяСтрока(Строки));
	
КонецПроцедуры

#КонецОбласти