///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать ВзаимодействияКлиентСерверПереопределяемый.ПриОпределенииВозможныхКонтактов.
// См. свойство ИмяФормыНовогоКонтакта параметра ТипыКонтактов.
//
// Вызывается при создании нового контакта.
// Используется, если для одного или нескольких видов контактов требуется, 
// чтобы вместо основной формы при их создании открывалась другая форма.
// Например, это может быть форма помощника создания нового элемента справочника.
//
// Параметры:
//  ТипКонтакта   - Строка    - имя справочника контакта.
//  ПараметрФормы - Структура - параметр, который передается при открытии.
//
// Возвращаемое значение:
//  Булево - Ложь, если открытие нестандартной формы не выполнено, Истина в обратном случае.
//
// Пример:
//	Если ТипКонтакта = "Партнеры" Тогда
//		ОткрытьФорму("Справочник.Партнеры.Форма.ПомощникНового", ПараметрФормы);
//		Возврат Истина;
//	КонецЕсли;
//	
//	Возврат Ложь;
//
Функция СоздатьКонтактНестандартнаяФорма(ТипКонтакта, ПараметрФормы)  Экспорт
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#КонецОбласти
