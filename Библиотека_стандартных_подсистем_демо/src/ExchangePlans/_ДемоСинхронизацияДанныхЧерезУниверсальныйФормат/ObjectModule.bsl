///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Очистка неиспользуемых реквизитов и заполнение служебных.
	Если ПравилаОтправкиСправочников = "НеСинхронизировать" Тогда
		
		ИспользоватьОтборПоОрганизациям = Ложь;
		РежимВыгрузкиСправочников       = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
		РежимВыгрузкиПриНеобходимости   = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
		
	ИначеЕсли ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости" Тогда
		
		РежимВыгрузкиСправочников = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
		
	Иначе
		
		РежимВыгрузкиСправочников       = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
		
	КонецЕсли;
	
	Если ПравилаОтправкиДокументов = "НеСинхронизировать" Тогда
		РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
	ИначеЕсли ПравилаОтправкиДокументов = "ИнтерактивнаяСинхронизация" Тогда
		РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВручную;
	Иначе
		РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
	КонецЕсли;
	
	Если Не ИспользоватьОтборПоОрганизациям И Организации.Количество() <> 0 Тогда
		Организации.Очистить();
	ИначеЕсли Организации.Количество() = 0 И ИспользоватьОтборПоОрганизациям Тогда
		ИспользоватьОтборПоОрганизациям = Ложь;
	КонецЕсли;
	
	Если ПравилаОтправкиДокументов <> "АвтоматическаяСинхронизация" Тогда
		ДатаНачалаВыгрузкиДокументов = Дата(1,1,1,0,0,0);
	КонецЕсли;
	
	// Обновление кэшируемых данных, зависящих от значений реквизитов данного узла обмена.
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		ОбменДаннымиВызовСервера.СброситьКэшМеханизмаРегистрацииОбъектов();
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	// При подключении через WS и COM узел записывается в режиме ОбменДанными.Загрузка = ИСТИНА
	// поэтому проверку и запись обменов "Без сопоставления" и без настроек синхронизации 
	// необходимо выполнять всегда, т.е. до проверки.
	Если НеобходимоЗафиксироватьЗавершениеНастройкиСинхронизации() Тогда
		
		ОбменДаннымиСервер.ЗавершитьНастройкуСинхронизацииДанных(Ссылка);
		
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьОбъект(ДанныеЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НеобходимоЗафиксироватьЗавершениеНастройкиСинхронизации()
	
	Возврат ВариантНастройки = "БСПБезСопоставления"
		И НомерПринятого = 0
		И Не ОбменДаннымиСервер.НастройкаСинхронизацииЗавершена(Ссылка);
	
КонецФункции

Процедура ИнициализироватьОбъект(ДанныеЗаполнения)
	
	Если Не ДанныеЗаполнения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИспользоватьОтборПоОрганизациям = Ложь;
	ДатаНачалаВыгрузкиДокументов  = НачалоГода(ТекущаяДатаСеанса());
	
	РежимВыгрузкиПриНеобходимости = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
	
	РежимВыгрузкиДокументов   = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
	РежимВыгрузкиСправочников = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
	
	ПравилаОтправкиДокументов = ПланыОбмена._ДемоСинхронизацияДанныхЧерезУниверсальныйФормат.ОпределитьВариантСинхронизацииДокументов(
		РежимВыгрузкиДокументов);
	ПравилаОтправкиСправочников = ПланыОбмена._ДемоСинхронизацияДанныхЧерезУниверсальныйФормат.ОпределитьВариантСинхронизацииСправочников(
		РежимВыгрузкиСправочников);
		
	СтавкаНДСПоУмолчанию    = Справочники._ДемоСтавкиНДС.НайтиПоРеквизиту("Ставка", 18);
	НоменклатураПоУмолчанию = Справочники._ДемоНоменклатура.ПустаяСсылка();
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли