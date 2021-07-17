///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.ОбменДаннымиСВнешнимиСистемамиПереопределяемый".
// ОбщийМодуль.ОбменДаннымиСВнешнимиСистемамиПереопределяемый.
//
// Серверные переопределяемые процедуры обмена данными с внешними системами:
//  - определение плана обмена для хранения настроек;
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет имя плана обмена, в котором будет сохранены настройки
// обмена данными с внешними системами.
//
// Параметры:
//  ИмяПланаОбмена - Строка - имя метаданных плана обмена.
//
// Пример:
//	ИмяПланаОбмена = "СинхронизацияДанныхЧерезУниверсальныйФормат";
//
Процедура ПриОпределенииИмениПланаОбмена(ИмяПланаОбмена) Экспорт
	
	// _Демо начало примера
	ИмяПланаОбмена = "_ДемоСинхронизацияДанныхЧерезУниверсальныйФормат";
	// _Демо конец примера
	
КонецПроцедуры

#КонецОбласти
