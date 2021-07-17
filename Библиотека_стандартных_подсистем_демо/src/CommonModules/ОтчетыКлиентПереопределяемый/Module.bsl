///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возникает после окончания формирования отчета: после завершения фонового задания.
// Позволяет переопределить обработку результата формирования отчета.
//
// Параметры:
//   ФормаОтчета - ФормаКлиентскогоПриложения
//               - РасширениеУправляемойФормыДляОтчета - форма отчета:
//                   * Отчет - ОтчетОбъект - структура данных формы аналогичная объекту отчета.
//
//  ОтчетСформирован - Булево - Истина если отчет был успешно сформирован.
//
Процедура ПослеФормирования(ФормаОтчета, ОтчетСформирован) Экспорт
	
КонецПроцедуры

// Обработчик расшифровки табличного документа формы отчета.
// См. "Расширение поля формы для поля табличного документа.ОбработкаРасшифровки" в синтакс-помощнике.
//
// Параметры:
//   ФормаОтчета - ФормаКлиентскогоПриложения
//               - РасширениеУправляемойФормыДляОтчета - форма отчета:
//                   * Отчет - ОтчетОбъект - структура данных формы аналогичная объекту отчета.
//
//   Элемент     - ПолеФормы        - табличный документ.
//   Расшифровка - Произвольный     - значение расшифровки точки, серии или значения диаграммы.
//   СтандартнаяОбработка - Булево  - признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаРасшифровки(ФормаОтчета, Элемент, Расшифровка, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Обработчик дополнительной расшифровки (меню табличного документа формы отчета).
// См. "Расширение поля формы для поля табличного документа.ОбработкаДополнительнойРасшифровки" в синтакс-помощнике.
//
// Параметры:
//   ФормаОтчета - ФормаКлиентскогоПриложения
//               - РасширениеУправляемойФормыДляОтчета - форма отчета:
//                   * Отчет - ОтчетОбъект - структура данных формы аналогичная объекту отчета.
//
//   Элемент     - ПолеФормы        - табличный документ.
//   Расшифровка - Произвольный     - значение расшифровки точки, серии или значения диаграммы.
//   СтандартнаяОбработка - Булево  - признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаДополнительнойРасшифровки(ФормаОтчета, Элемент, Расшифровка, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Обработчик команд, добавленных динамически и подключенных к обработчику "Подключаемый_Команда".
// Пример добавления команды см. ОтчетыПереопределяемый.ПриСозданииНаСервере().
//
// Параметры:
//   ФормаОтчета - ФормаКлиентскогоПриложения
//               - РасширениеУправляемойФормыДляОтчета - форма отчета:
//                   * Отчет - ОтчетОбъект - структура данных формы аналогичная объекту отчета.
//
//   Команда     - КомандаФормы     - команда, которая была вызвана.
//   Результат   - Булево           - Истина, если вызов команды обработан.
//
Процедура ОбработчикКоманды(ФормаОтчета, Команда, Результат) Экспорт
	
	// _Демо начало примера
	ПолноеИмяОтчета = ФормаОтчета.НастройкиОтчета.ПолноеИмя;
	
	Если ПолноеИмяОтчета = "Отчет._ДемоФайлы" И Команда.Имя = "_ДемоКоманда" Тогда
		
		// Обработчик команды, определенной в модуле отчета Отчет._ДемоФайлы в процедуре ПриСозданииНаСервере.
		_ДемоСтандартныеПодсистемыКлиент.НачатьРедактированиеОтчета(ФормаОтчета);
		
	ИначеЕсли СтрНайти(ПолноеИмяОтчета, "_Демо") > 0 И СтрНачинаетсяС(Команда.Имя, "_ДемоОформить") Тогда 
		
		// Обработчик команды, определенной в ОтчетыПереопределяемый.ПриСозданииНаСервере.
		_ДемоСтандартныеПодсистемыКлиент.ОформитьВыделенныеОбластиОтчета(ФормаОтчета, Команда.Имя);
		
	КонецЕсли;
	// _Демо конец примера
	
КонецПроцедуры

// Обработчик результата выбора подчиненной формы.
// См. "ФормаКлиентскогоПриложения.ОбработкаВыбора" в синтакс-помощнике.
//
// Параметры:
//   ФормаОтчета - ФормаКлиентскогоПриложения
//               - РасширениеУправляемойФормыДляОтчета - форма отчета:
//                   * Отчет - ОтчетОбъект - структура данных формы аналогичная объекту отчета.
//
//   ВыбранноеЗначение - Произвольный     - результат выбора в подчиненной форме.
//   ИсточникВыбора    - ФормаКлиентскогоПриложения - форма, где осуществлен выбор.
//   Результат         - Булево           - Истина, если результат выбора обработан.
//
Процедура ОбработкаВыбора(ФормаОтчета, ВыбранноеЗначение, ИсточникВыбора, Результат) Экспорт
	
КонецПроцедуры

// Обработчик двойного щелчка мыши, нажатия клавиши Enter или гиперссылки в табличном документе формы отчета.
// См. "Расширение поля формы для поля табличного документа.Выбор" в синтакс-помощнике.
//
// Параметры:
//   ФормаОтчета - ФормаКлиентскогоПриложения
//               - РасширениеУправляемойФормыДляОтчета - форма отчета:
//                   * Отчет - ОтчетОбъект - структура данных формы аналогичная объекту отчета.
//
//   Элемент     - ПолеФормы        - табличный документ.
//   Область     - ОбластьЯчеекТабличногоДокумента - выбранное значение.
//   СтандартнаяОбработка - Булево - признак выполнения стандартной обработки события.
//
Процедура ОбработкаВыбораТабличногоДокумента(ФормаОтчета, Элемент, Область, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Обработчик широковещательного оповещения формы отчета.
// См. "ФормаКлиентскогоПриложения.ОбработкаОповещения" в синтакс-помощнике.
//
// Параметры:
//   ФормаОтчета - ФормаКлиентскогоПриложения
//               - РасширениеУправляемойФормыДляОтчета - форма отчета:
//                   * Отчет - ОтчетОбъект - структура данных формы аналогичная объекту отчета.
//
//   ИмяСобытия  - Строка           - идентификатор события для принимающих форм.
//   Параметр    - Произвольный     - расширенная информация о событии.
//   Источник    - ФормаКлиентскогоПриложения
//               - Произвольный - источник события.
//   ОповещениеОбработано - Булево - признак того, что событие обработано.
//
Процедура ОбработкаОповещения(ФормаОтчета, ИмяСобытия, Параметр, Источник, ОповещениеОбработано) Экспорт
	
КонецПроцедуры

// Обработчик нажатия на кнопку выбора периода в отдельной форме.
//  Если в конфигурации используется собственный диалог выбора периода,
//  тогда параметр СтандартнаяОбработка следует установить в Ложь,
//  а выбранный период следует вернуть в ОбработчикРезультата.
//
// Параметры:
//   ФормаОтчета - ФормаКлиентскогоПриложения
//               - РасширениеУправляемойФормыДляОтчета - форма отчета:
//                   * Отчет - ОтчетОбъект - структура данных формы аналогичная объекту отчета.
//
//   Период - СтандартныйПериод - значение настройки компоновщика, соответствующей выбранному периоду.
//
//   СтандартнаяОбработка - Булево - если Истина, то будет использован стандартный диалог выбора периода.
//       Если установить в Ложь то стандартный диалог не откроется.
//
//   ОбработчикРезультата - ОписаниеОповещения - обработчик результата выбора периода.
//       В качестве результата в ОбработчикРезультата могут быть переданы значения типов:
//       Неопределено - пользователь отказался от ввода периода.
//       СтандартныйПериод - выбранный период.
//
Процедура ПриНажатииКнопкиВыбораПериода(ФормаОтчета, Период, СтандартнаяОбработка, ОбработчикРезультата) Экспорт
	
	// _Демо начало примера
	ПолноеИмяОтчета = ФормаОтчета.НастройкиОтчета.ПолноеИмя;
	
	Если ПолноеИмяОтчета = "Отчет._ДемоФайлы"
		И Период.ДатаНачала > Период.ДатаОкончания Тогда 
		
		Период.ДатаОкончания = КонецГода(Период.ДатаНачала);
		
	КонецЕсли;
	// _Демо конец примера
	
КонецПроцедуры

#КонецОбласти
