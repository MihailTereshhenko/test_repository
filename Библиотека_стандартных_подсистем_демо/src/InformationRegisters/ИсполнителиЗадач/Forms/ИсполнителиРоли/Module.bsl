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
	
	УстановитьУсловноеОформление();
	
	Исполнители.Параметры.УстановитьЗначениеПараметра("БезОбъектаАдресации", НСтр("ru = '<Без объекта адресации>'"));
	
	НастроитьОтображениеСпискаРолей();

КонецПроцедуры

&НаСервере
Процедура НастроитьОтображениеСпискаРолей()
	
	Перем ПолеГруппировки, СвойстваРоли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Исполнители, 
	"РольИсполнителя", Параметры.РольИсполнителя, ВидСравненияКомпоновкиДанных.Равно);
	СвойстваРоли = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.РольИсполнителя, "ИспользуетсяСОбъектамиАдресации,ТипыДополнительногоОбъектаАдресации,ТипыОсновногоОбъектаАдресации");
	Если СвойстваРоли.ИспользуетсяСОбъектамиАдресации Тогда
		ПолеГруппировки = Исполнители.Группировка.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных("ОсновнойОбъектАдресации");
		ПолеГруппировки.Использование = Истина;
		Если Не СвойстваРоли.ТипыДополнительногоОбъектаАдресации.Пустая() Тогда
			ПолеГруппировки = Исполнители.Группировка.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных("ДополнительныйОбъектАдресации");
			ПолеГруппировки.Использование = Истина;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИсполнителиПослеУдаления(Элемент)
	Оповестить("Запись_РолеваяАдресация", Неопределено, Неопределено);
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ЭлементУсловногоОформления = Исполнители.УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("Исполнитель");
	ОформляемоеПоле.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Исполнитель.Недействителен");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Метаданные.ЭлементыСтиля.ТекстЗапрещеннойЯчейкиЦвет.Значение);
	
КонецПроцедуры


#КонецОбласти