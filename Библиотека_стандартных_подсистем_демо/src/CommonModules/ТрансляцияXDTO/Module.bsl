///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция выполняет трансляцию произвольного XDTO-объекта 
// между версиями по зарегистрированным в системе обработчикам трансляции,
// определяя результирующую версию по пространству имен результирующего сообщения.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИсходныйОбъект - ОбъектXDTO - транслируемый объект.
//  РезультирующаяВерсия - Строка - номер результирующей версии интерфейса, в формате РР.{П|ПП}.ЗЗ.СС.
//  ПакетИсходнойВерсии - Строка - пространство имен версии сообщения.
//
// Возвращаемое значение:
//  ОбъектXDTO - результат трансляции объекта.
//
Функция ТранслироватьВВерсию(Знач ИсходныйОбъект, Знач РезультирующаяВерсия,
		Знач ПакетИсходнойВерсии = "") Экспорт
КонецФункции

// Функция выполняет трансляцию произвольного XDTO-объекта 
// между версиями по зарегистрированным в системе обработчикам трансляции,
// определяя результирующую версию по пространству имен результирующего сообщения.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИсходныйОбъект - ОбъектXDTO - транслируемый объект.
//  ПакетРезультирующейВерсии - Строка - пространство имен результирующей версии.
//  ПакетИсходнойВерсии - Строка - пространство имен версии сообщения.
//
// Возвращаемое значение:
//  ОбъектXDTO - результат трансляции объекта.
//
Функция ТранслироватьВПространствоИмен(Знач ИсходныйОбъект,
		Знач ПакетРезультирующейВерсии, Знач ПакетИсходнойВерсии = "") Экспорт
КонецФункции

#КонецОбласти
