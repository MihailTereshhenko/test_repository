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

	ЗаполнитьСписокВыбораВидовДокумента();

	Если Параметры.Свойство("ОтборВидыДокументов") Тогда
		
		Если Параметры.ОтборВидыДокументов.Количество() > 0 Тогда

			Для Каждого ВидДокумента Из ТаблицаВидыДокументов Цикл
				ВидДокумента.Отбор = Ложь;
			КонецЦикла;

			Для Каждого ВидДокумента Из Параметры.ОтборВидыДокументов Цикл
				Отбор = Новый Структура("ВидДокумента",ВидДокумента.Значение);
				НайденныеСтроки = ТаблицаВидыДокументов.НайтиСтроки(Отбор);
				Если ЗначениеЗаполнено(НайденныеСтроки) Тогда
					Для Каждого Строка Из НайденныеСтроки Цикл
						Строка.Отбор = Истина;
					КонецЦикла;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	Иначе
			
		Для Каждого ВидДокумента Из ТаблицаВидыДокументов Цикл
			ВидДокумента.Отбор = Истина;
		КонецЦикла;		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитВсеФлажки(Команда)

	Для Каждого ТекущийОтбор Из ТаблицаВидыДокументов Цикл
		ТекущийОтбор.Отбор = Истина;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура СнятьВсеФлажки(Команда)

	Для Каждого ТекущийОтбор Из ТаблицаВидыДокументов Цикл
		ТекущийОтбор.Отбор = Ложь;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ОтборВидыДокументовОК(Команда)

	ЗаполнитьСписокОтборПоВидуДокумента();
	Результат = Новый Структура("ОтборВидыДокументов,КоличествоДокументов",ОтборВидыДокументов,ТаблицаВидыДокументов.Количество());
	Закрыть(Результат);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокВыбораВидовДокумента()

	ТаблицаВидов = РеквизитФормыВЗначение("ТаблицаВидыДокументов");
	ТаблицаВидов.Очистить();

	ДоступныеТипы = Метаданные.ОпределяемыеТипы.ОбъектСУчетомОригиналовПервичныхДокументов.Тип.Типы();
	ИменаДокументов = Новый Массив;
	Для Каждого Тип Из ДоступныеТипы Цикл
		ТипДокумента = Метаданные.НайтиПоТипу(Тип);
		ИменаДокументов.Добавить(ТипДокумента.ПолноеИмя());
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ИдентификаторыОбъектовМетаданных.ПолноеИмя КАК ПолноеИмя,
	               |	ИдентификаторыОбъектовМетаданных.Синоним КАК Синоним,
	               |	ИдентификаторыОбъектовМетаданных.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.ИдентификаторыОбъектовМетаданных КАК ИдентификаторыОбъектовМетаданных
	               |ГДЕ
	               |	ИдентификаторыОбъектовМетаданных.ПолноеИмя В(&ИменаДокументов)";
	Запрос.УстановитьПараметр("ИменаДокументов",ИменаДокументов);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Отбор = Новый Структура("Представление", Выборка.Синоним);
		НайденныеСтроки = ТаблицаВидов.НайтиСтроки(Отбор);
		Если НайденныеСтроки.Количество()= 0 Тогда
			НоваяСтрока = ТаблицаВидов.Добавить();
			НоваяСтрока.ВидДокумента = Выборка.Ссылка;
			НоваяСтрока.Представление = Выборка.Синоним;
			НоваяСтрока.Отбор = Истина;
		КонецЕсли;
	КонецЦикла;

	ТаблицаВидов.Сортировать("Представление");
	ЗначениеВРеквизитФормы(ТаблицаВидов, "ТаблицаВидыДокументов");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокОтборПоВидуДокумента()

	ОтборВидыДокументов.Очистить();
	
	Для Каждого ВидДокумента Из ТаблицаВидыДокументов Цикл
			Если ВидДокумента.Отбор = Истина Тогда
				ОтборВидыДокументов.Добавить(ВидДокумента.ВидДокумента,ВидДокумента.Представление);
			КонецЕсли;
	КонецЦикла;

	Если ОтборВидыДокументов.Количество() = 0 Тогда
		Для Каждого ВидДокумента Из ТаблицаВидыДокументов Цикл
			ОтборВидыДокументов.Добавить(ВидДокумента.ВидДокумента,ВидДокумента.Представление);
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

