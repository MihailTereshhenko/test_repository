///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// В данной процедуре следует описать дополнительные зависимости объектов метаданных
//   конфигурации, которые будут использоваться для связи настроек отчетов.
//
// Параметры:
//   СвязиОбъектовМетаданных - ТаблицаЗначений:
//       * ПодчиненныйРеквизит - Строка - имя реквизита подчиненного объекта метаданных.
//       * ПодчиненныйТип      - Тип    - тип подчиненного объекта метаданных.
//       * ВедущийТип          - Тип    - тип ведущего объекта метаданных.
//
Процедура ДополнитьСвязиОбъектовМетаданных(СвязиОбъектовМетаданных) Экспорт
	
	// _Демо начало примера
	СтрокаСвязиОтбора = СвязиОбъектовМетаданных.Добавить();
	СтрокаСвязиОтбора.ВедущийТип          = Тип("ДокументСсылка._ДемоЗаказПокупателя");
	СтрокаСвязиОтбора.ПодчиненныйТип      = Тип("ДокументСсылка._ДемоСчетНаОплатуПокупателю");
	СтрокаСвязиОтбора.ПодчиненныйРеквизит = "Основание";
	// _Демо конец примера
	
КонецПроцедуры

// Вызывается в форме отчета и в форме настройки отчета перед выводом настройки 
// для указания дополнительных параметров выбора.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения
//        - РасширениеУправляемойФормыДляОтчета
//        - Неопределено - форма отчета.
//  СвойстваНастройки - Структура - описание настройки отчета, которая будет выведена в форме отчета, где:
//      * ПолеКД - ПолеКомпоновкиДанных - выводимая настройка.
//      * ОписаниеТипов - ОписаниеТипов - тип выводимой настройки.
//      * ЗначенияДляВыбора - СписокЗначений - указать объекты, которые будут предложены пользователю в списке выбора.
//                            Дополняет список объектов, уже выбранных пользователем ранее.
//                            При этом не следует присваивать в этот параметр новый список значений.
//      * ЗапросЗначенийВыбора - Запрос - указать запрос для выборки объектов, которыми необходимо дополнить 
//                               ЗначенияДляВыбора. Первой колонкой (с индексом 0) должен выбираться объект,
//                               который следует добавить в ЗначенияДляВыбора.Значение.
//                               Для отключения автозаполнения в свойство ЗапросЗначенийВыбора.Текст следует записать
//                               пустую строку.
//      * ОграничиватьВыборУказаннымиЗначениями - Булево - указать Истина, чтобы ограничить выбор пользователя
//                                                значениями, указанными в ЗначенияДляВыбора (его конечным состоянием).
//      * Тип - Строка.
//
// Пример:
//   1. Для всех настроек типа СправочникСсылка.Пользователи скрыть и не разрешать выбирать помеченных на удаление, 
//   недействительных и служебных пользователей.
//
//   Если СвойстваНастройки.ОписаниеТипов.СодержитТип(Тип("СправочникСсылка.Пользователи")) Тогда
//     СвойстваНастройки.ОграничиватьВыборУказаннымиЗначениями = Истина;
//     СвойстваНастройки.ЗначенияДляВыбора.Очистить();
//     СвойстваНастройки.ЗапросЗначенийВыбора.Текст =
//       "ВЫБРАТЬ Ссылка ИЗ Справочник.Пользователи
//       |ГДЕ НЕ ПометкаУдаления И НЕ Недействителен И НЕ Служебный";
//   КонецЕсли;
//
//   2. Для настройки "Размер" предусмотреть дополнительное значение для выбора.
//
//   Если СвойстваНастройки.ПолеКД = Новый ПолеКомпоновкиДанных("ПараметрыДанных.Размер") Тогда
//     СвойстваНастройки.ЗначенияДляВыбора.Добавить(10000000, НСтр("ru = 'Больше 10 Мб'"));
//   КонецЕсли;
//
Процедура ПриОпределенииПараметровВыбора(Форма, СвойстваНастройки) Экспорт
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
// См. "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике и ОтчетыКлиентПереопределяемый.ОбработчикКоманды.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма отчета.
//         - РасширениеУправляемойФормыДляОтчета
//         - Структура:
//           * НастройкиОтчета - см. ВариантыОтчетов.НастройкиФормыОтчета
//   Отказ - Булево - признак отказа от создания формы.
//   СтандартнаяОбработка - Булево - признак выполнения стандартной (системной) обработки события.
//
// Пример:
//	//Добавление команды с обработчиком в ОтчетыКлиентПереопределяемый.ОбработчикКоманды:
//	Команда = ФормаОтчета.Команды.Добавить("МояОсобеннаяКоманда");
//	Команда.Действие  = "Подключаемый_Команда";
//	Команда.Заголовок = НСтр("ru = 'Моя команда...'");
//	
//	Кнопка = ФормаОтчета.Элементы.Добавить(Команда.Имя, Тип("КнопкаФормы"), ФормаОтчета.Элементы.<ИмяПодменю>);
//	Кнопка.ИмяКоманды = Команда.Имя;
//	
//	ФормаОтчета.ПостоянныеКоманды.Добавить(КомандаСоздать.Имя);
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	// _Демо начало примера
	ПолноеИмяОтчета = Форма.НастройкиОтчета.ПолноеИмя;
	Если СтрНайти(ПолноеИмяОтчета, "_Демо") = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	Команда = Форма.Команды.Добавить("_ДемоОформитьОшибочныеДанные");
	Команда.Действие = "Подключаемый_Команда";
	Команда.Заголовок = НСтр("ru = 'Оформить как ошибочные данные'");
	Команда.Подсказка = НСтр("ru = 'Закрашивание выделенных ячеек цветом, подчеркивающим некорректность данных'");
	Команда.Картинка = БиблиотекаКартинок.Оформление;
	Команда.Отображение = ОтображениеКнопки.Картинка;
	ОтчетыСервер.ВывестиКоманду(Форма, Команда, "Прочее");
	
	Команда = Форма.Команды.Добавить("_ДемоОформитьКорректныеДанные");
	Команда.Действие = "Подключаемый_Команда";
	Команда.Заголовок = НСтр("ru = 'Оформить как корректные данные'");
	Команда.Подсказка = НСтр("ru = 'Закрашивание выделенных ячеек цветом доверия'");
	ОтчетыСервер.ВывестиКоманду(Форма, Команда, "Прочее", , Истина);
	
	Команда = Форма.Команды.Добавить("_ДемоОформитьСомнительныеДанные");
	Команда.Действие = "Подключаемый_Команда";
	Команда.Заголовок = НСтр("ru = 'Оформить как сомнительные данные'");
	Команда.Подсказка = НСтр("ru = 'Закрашивание выделенных ячеек предупреждающим цветом'");
	ОтчетыСервер.ВывестиКоманду(Форма, Команда, "Прочее", , Истина);
	// _Демо конец примера
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета и формы настройки отчета.
// См. "Расширение управляемой формы для отчета.ПередЗагрузкойВариантаНаСервере" в синтакс-помощнике.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма отчета или настроек отчета.
//   НовыеНастройкиКД - НастройкиКомпоновкиДанных - настройки для загрузки в компоновщик настроек.
//
Процедура ПередЗагрузкойВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт
	
	// _Демо начало примера
	ПараметрМакетОформления = НовыеНастройкиКД.ПараметрыВывода.Элементы.Найти("МакетОформления");
	Если ПараметрМакетОформления.Значение = "Main" Или ПараметрМакетОформления.Значение = "Основной" Тогда
		ПараметрМакетОформления.Значение      = "_ДемоОформлениеОтчетовБежевый";
		ПараметрМакетОформления.Использование = Истина;
	КонецЕсли;
	
	Для Каждого ЭлементСтруктуры Из НовыеНастройкиКД.Структура Цикл
		
		Если ТипЗнч(ЭлементСтруктуры) = Тип("НастройкиВложенногоОбъектаКомпоновкиДанных") Тогда
			
			ПараметрМакетОформления = ЭлементСтруктуры.Настройки.ПараметрыВывода.Элементы.Найти("МакетОформления");
			Если ПараметрМакетОформления.Значение = "Main" 
				Или ПараметрМакетОформления.Значение = "Основной" Тогда
				ПараметрМакетОформления.Значение      = "_ДемоОформлениеОтчетовБежевый";
				ПараметрМакетОформления.Использование = Истина;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Форма может быть не формой отчета, а формой настроек отчета.
	Если Форма.Элементы.Найти("ОтчетТабличныйДокумент") <> Неопределено Тогда 
		Форма.Элементы.ОтчетТабличныйДокумент.РежимМасштабированияПросмотра = РежимМасштабированияПросмотра.Обычный;
	КонецЕсли;
	
	// _Демо конец примера
	
КонецПроцедуры

// Вызывается при инициализации свойств результата отчета.
//  Если основные поля определены, то при вызове команд контекстной настройки
//   (Вставить поле слева, Вставить поле справа, Вставить группировку ниже,
//   Вставить группировку выше), они будут выводиться в подменю
//   для выбора полей вставки.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма отчета.
//   ОсновныеПоля - Массив из Строка - имена часто используемых полей отчета.
//
Процедура ПриОпределенииОсновныхПолей(Форма, ОсновныеПоля) Экспорт 
	
	// _Демо начало примера
	Если СтрНачинаетсяС(Форма.КлючСохраненияПоложенияОкна, "Отчет._ДемоФайлы") Тогда 
		
		ОсновныеПоля.Добавить("Ссылка");
		ОсновныеПоля.Добавить("Владелец");
		ОсновныеПоля.Добавить("Регистратор");
		
	КонецЕсли;
	// _Демо конец примера
	
КонецПроцедуры

#КонецОбласти
