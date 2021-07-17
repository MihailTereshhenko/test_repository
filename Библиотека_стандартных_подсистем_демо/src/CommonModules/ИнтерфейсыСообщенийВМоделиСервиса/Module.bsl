///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

// @strict-types

#Область ПрограммныйИнтерфейс

// Возвращает версии интерфейса сообщений, поддерживаемые ИБ-корреспондентом.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИнтерфейсСообщения - Строка - имя программного интерфейса сообщений.
//  ПараметрыПодключения - Структура - параметры подключения к ИБ-корреспонденту.
//  ПредставлениеПолучателя - Строка - представление ИБ-корреспондента.
//  ИнтерфейсТекущейИБ - Строка - имя программного интерфейса текущей ИБ (используется
//    для обеспечения обратной совместимости с предыдущими версиями БСП).
//
// Возвращаемое значение:
//  Строка - максимальная версия интерфейса, поддерживаемая как ИБ-корреспондентом, так и текущей ИБ.
//
Функция ВерсияИнтерфейсаКорреспондента(Знач ИнтерфейсСообщения, Знач ПараметрыПодключения, 
	Знач ПредставлениеПолучателя, Знач ИнтерфейсТекущейИБ = "") Экспорт	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// См. ОбщегоНазначенияПереопределяемый.ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов(Знач СтруктураПоддерживаемыхВерсий) Экспорт
КонецПроцедуры

// См. ОбменСообщениямиПереопределяемый.ПолучитьОбработчикиКаналовСообщений
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ПриОпределенииОбработчиковКаналовСообщений(Обработчики) Экспорт
КонецПроцедуры

// Возвращает фиксированный массив, заполненный общими модулями, 
// являющимися обработчиками интерфейсов принимаемых сообщений.
// @skip-warning ПустойМетод - особенность реализации.
//
// Возвращаемое значение:
//  ФиксированныйМассив - элементами массива являются общие модули.
//
Функция ПолучитьОбработчикиИнтерфейсовПринимаемыхСообщений() Экспорт
КонецФункции

// Возвращает имена каналов сообщений из заданного пакета.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  URIПакета - Строка - URI пакета XDTO, типы сообщений из которого требуется получить.
//  БазовыйТип - ОбъектXDTO - базовый тип.
//
// Возвращаемое значение:
//  ФиксированныйМассив из Строка - имена каналов найденные в пакете.
//
Функция ПолучитьКаналыПакета(Знач URIПакета, Знач БазовыйТип) Экспорт	
КонецФункции

#КонецОбласти

