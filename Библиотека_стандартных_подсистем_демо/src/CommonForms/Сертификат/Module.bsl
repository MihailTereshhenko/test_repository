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
	
	Если ЗначениеЗаполнено(Параметры.АдресСертификата) Тогда
		ДанныеСертификата = ПолучитьИзВременногоХранилища(Параметры.АдресСертификата);
		Сертификат = Новый СертификатКриптографии(ДанныеСертификата);
		АдресСертификата = ПоместитьВоВременноеХранилище(ДанныеСертификата, УникальныйИдентификатор);
		
	ИначеЕсли ЗначениеЗаполнено(Параметры.Ссылка) Тогда
		АдресСертификата = АдресСертификата(Параметры.Ссылка, УникальныйИдентификатор);
		
		Если АдресСертификата = Неопределено Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось открыть сертификат ""%1"",
				           |т.к. он не существует в справочнике.'"), Параметры.Ссылка);
		КонецЕсли;
	Иначе // Отпечаток
		АдресСертификата = АдресСертификата(Параметры.Отпечаток, УникальныйИдентификатор);
		
		Если АдресСертификата = Неопределено Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось открыть сертификат, т.к. он не найден
				           |по отпечатку ""%1"".'"), Параметры.Отпечаток);
		КонецЕсли;
	КонецЕсли;
	
	Если ДанныеСертификата = Неопределено Тогда
		ДанныеСертификата = ПолучитьИзВременногоХранилища(АдресСертификата);
		Сертификат = Новый СертификатКриптографии(ДанныеСертификата);
	КонецЕсли;
	
	СвойстваСертификата = ЭлектроннаяПодпись.СвойстваСертификата(Сертификат);
	
	НазначениеПодписание = Сертификат.ИспользоватьДляПодписи;
	НазначениеШифрование = Сертификат.ИспользоватьДляШифрования;
	
	Отпечаток      = СвойстваСертификата.Отпечаток;
	КомуВыдан      = СвойстваСертификата.КомуВыдан;
	КемВыдан       = СвойстваСертификата.КемВыдан;
	ДействителенДо = СвойстваСертификата.ДатаОкончания;
	
	АлгоритмПодписи = ЭлектроннаяПодписьСлужебныйКлиентСервер.АлгоритмПодписиСертификата(
		ДанныеСертификата, Истина);
	
	Элементы.АлгоритмПодписи.Подсказка =
		Метаданные.Справочники.ПрограммыЭлектроннойПодписиИШифрования.Реквизиты.АлгоритмПодписи.Подсказка;
	
	ЗаполнитьКодыНазначенияСертификата(СвойстваСертификата.Назначение, НазначениеКоды);
	
	ЗаполнитьСвойстваСубъекта(Сертификат);
	ЗаполнитьСвойстваИздателя(Сертификат);
	
	ГруппаВнутреннихПолей = "Общие";
	ЗаполнитьВнутренниеПоляСертификата();
	
	Если Параметры.Свойство("ОткрытиеИзФормыЭлементаСертификата") Тогда
		Элементы.ФормаСохранитьВФайл.Видимость = Ложь;
		Элементы.ФормаПроверить.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГруппаВнутреннихПолейПриИзменении(Элемент)
	
	ЗаполнитьВнутренниеПоляСертификата();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаВнутреннихПолейОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьВФайл(Команда)
	
	ЭлектроннаяПодписьСлужебныйКлиент.СохранитьСертификат(Неопределено, АдресСертификата);
	
КонецПроцедуры

&НаКлиенте
Процедура Проверить(Команда)
	
	ЭлектроннаяПодписьКлиент.ПроверитьСертификат(Новый ОписаниеОповещения(
		"ПроверитьЗавершение", ЭтотОбъект), АдресСертификата);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Продолжение процедуры Проверить.
&НаКлиенте
Процедура ПроверитьЗавершение(Результат, Контекст) Экспорт
	
	Если Результат = Истина Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Сертификат действителен.'"));
		
	ИначеЕсли Результат <> Неопределено Тогда
		ПараметрыПредупреждения = Новый Структура;
		
		ПараметрыПредупреждения.Вставить("ТекстПредупреждения", Результат);
		ПараметрыПредупреждения.Вставить("ЗаголовокПредупреждения", НСтр("ru = 'Сертификат недействителен по причине:'"));
		
		ОткрытьФорму("ОбщаяФорма.РезультатПроверки", ПараметрыПредупреждения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСвойстваСубъекта(Сертификат)
	
	Коллекция = ЭлектроннаяПодпись.СвойстваСубъектаСертификата(Сертификат);
	
	ПредставленияСвойств = Новый Соответствие;
	ПредставленияСвойств["ОбщееИмя"] = НСтр("ru = 'Общее имя'");
	ПредставленияСвойств["Страна"] = НСтр("ru = 'Страна'");
	ПредставленияСвойств["Регион"] = НСтр("ru = 'Регион'");
	ПредставленияСвойств["НаселенныйПункт"] = НСтр("ru = 'Населенный пункт'");
	ПредставленияСвойств["Улица"] = НСтр("ru = 'Улица'");
	ПредставленияСвойств["Организация"] = НСтр("ru = 'Организация'");
	ПредставленияСвойств["Подразделение"] = НСтр("ru = 'Подразделение'");
	ПредставленияСвойств["ЭлектроннаяПочта"] = НСтр("ru = 'Электронная почта'");
	
	Если Метаданные.Обработки.Найти("ПрограммыЭлектроннойПодписиИШифрования") <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьСоответствие(ПредставленияСвойств,
			Обработки["ПрограммыЭлектроннойПодписиИШифрования"].ПредставленияСвойствСубъектаСертификата(), Истина);
	КонецЕсли;
	
	Для каждого ЭлементСписка Из ПредставленияСвойств Цикл
		ЗначениеСвойства = Коллекция[ЭлементСписка.Ключ];
		Если Не ЗначениеЗаполнено(ЗначениеСвойства) Тогда
			Продолжить;
		КонецЕсли;
		Строка = Субъект.Добавить();
		Строка.Свойство = ЭлементСписка.Значение;
		Строка.Значение = ЗначениеСвойства;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСвойстваИздателя(Сертификат)
	
	Коллекция = ЭлектроннаяПодпись.СвойстваИздателяСертификата(Сертификат);
	
	ПредставленияСвойств = Новый Соответствие;
	ПредставленияСвойств["ОбщееИмя"] = НСтр("ru = 'Общее имя'");
	ПредставленияСвойств["Страна"] = НСтр("ru = 'Страна'");
	ПредставленияСвойств["Регион"] = НСтр("ru = 'Регион'");
	ПредставленияСвойств["НаселенныйПункт"] = НСтр("ru = 'Населенный пункт'");
	ПредставленияСвойств["Улица"] = НСтр("ru = 'Улица'");
	ПредставленияСвойств["Организация"] = НСтр("ru = 'Организация'");
	ПредставленияСвойств["Подразделение"] = НСтр("ru = 'Подразделение'");
	ПредставленияСвойств["ЭлектроннаяПочта"] = НСтр("ru = 'Электронная почта'");
	
	Если Метаданные.Обработки.Найти("ПрограммыЭлектроннойПодписиИШифрования") <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьСоответствие(ПредставленияСвойств,
			Обработки["ПрограммыЭлектроннойПодписиИШифрования"].ПредставленияСвойствИздателяСертификата(), Истина);
	КонецЕсли;
	
	Для каждого ЭлементСписка Из ПредставленияСвойств Цикл
		ЗначениеСвойства = Коллекция[ЭлементСписка.Ключ];
		Если Не ЗначениеЗаполнено(ЗначениеСвойства) Тогда
			Продолжить;
		КонецЕсли;
		Строка = Издатель.Добавить();
		Строка.Свойство = ЭлементСписка.Значение;
		Строка.Значение = ЗначениеСвойства;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВнутренниеПоляСертификата()
	
	ВнутреннееСодержание.Очистить();
	ДвоичныеДанныеСертификата = ПолучитьИзВременногоХранилища(АдресСертификата);
	Сертификат = Новый СертификатКриптографии(ДвоичныеДанныеСертификата);
	
	Если ГруппаВнутреннихПолей = "Общие" Тогда
		Элементы.ВнутреннееСодержаниеИдентификатор.Видимость = Ложь;
		
		ДобавитьСвойство(Сертификат, "Версия",                    НСтр("ru = 'Версия'"));
		ДобавитьСвойство(Сертификат, "ДатаНачала",                НСтр("ru = 'Дата начала'"));
		ДобавитьСвойство(Сертификат, "ДатаОкончания",             НСтр("ru = 'Дата окончания'"));
		ДобавитьСвойство(Сертификат, "ИспользоватьДляПодписи",    НСтр("ru = 'Использовать для подписи'"));
		ДобавитьСвойство(Сертификат, "ИспользоватьДляШифрования", НСтр("ru = 'Использовать для шифрования'"));
		ДобавитьСвойство(Сертификат, "ОткрытыйКлюч",              НСтр("ru = 'Открытый ключ'"), Истина);
		ДобавитьСвойство(Сертификат, "Отпечаток",                 НСтр("ru = 'Отпечаток'"), Истина);
		ДобавитьСвойство(Сертификат, "СерийныйНомер",             НСтр("ru = 'Серийный номер'"), Истина);
		
	ИначеЕсли ГруппаВнутреннихПолей = "РасширенныеСвойства" Тогда
		Элементы.ВнутреннееСодержаниеИдентификатор.Видимость = Ложь;
		
		Коллекция = Сертификат.РасширенныеСвойства;
		Для Каждого КлючИЗначение Из Коллекция Цикл
			ДобавитьСвойство(Коллекция, КлючИЗначение.Ключ, КлючИЗначение.Ключ);
		КонецЦикла;
	Иначе
		Элементы.ВнутреннееСодержаниеИдентификатор.Видимость = Истина;
		
		ИменаИдентификаторов = Новый СписокЗначений;
		ИменаИдентификаторов.Добавить("OID2_5_4_3",              "CN");
		ИменаИдентификаторов.Добавить("OID2_5_4_6",              "C");
		ИменаИдентификаторов.Добавить("OID2_5_4_8",              "ST");
		ИменаИдентификаторов.Добавить("OID2_5_4_7",              "L");
		ИменаИдентификаторов.Добавить("OID2_5_4_9",              "Street");
		ИменаИдентификаторов.Добавить("OID2_5_4_10",             "O");
		ИменаИдентификаторов.Добавить("OID2_5_4_11",             "OU");
		ИменаИдентификаторов.Добавить("OID2_5_4_12",             "T");
		ИменаИдентификаторов.Добавить("OID1_2_840_113549_1_9_1", "E");
		
		ИменаИдентификаторов.Добавить("OID1_2_643_100_1",     "OGRN");
		ИменаИдентификаторов.Добавить("OID1_2_643_100_5",     "OGRNIP");
		ИменаИдентификаторов.Добавить("OID1_2_643_100_3",     "SNILS");
		ИменаИдентификаторов.Добавить("OID1_2_643_3_131_1_1", "INN");
		ИменаИдентификаторов.Добавить("OID2_5_4_4",           "SN");
		ИменаИдентификаторов.Добавить("OID2_5_4_42",          "GN");
		
		ИменаИИдентификаторы = Новый Соответствие;
		Коллекция = Сертификат[ГруппаВнутреннихПолей];
		
		Для Каждого ЭлементСписка Из ИменаИдентификаторов Цикл
			Если Коллекция.Свойство(ЭлементСписка.Значение) Тогда
				ДобавитьСвойство(Коллекция, ЭлементСписка.Значение, ЭлементСписка.Представление);
			КонецЕсли;
			ИменаИИдентификаторы.Вставить(ЭлементСписка.Значение, Истина);
			ИменаИИдентификаторы.Вставить(ЭлементСписка.Представление, Истина);
		КонецЦикла;
		
		Для Каждого КлючИЗначение Из Коллекция Цикл
			Если ИменаИИдентификаторы.Получить(КлючИЗначение.Ключ) = Неопределено Тогда
				ДобавитьСвойство(Коллекция, КлючИЗначение.Ключ, КлючИЗначение.Ключ);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСвойство(ЗначенияСвойств, Свойство, Представление, НижнийРегистр = Неопределено)
	
	Значение = ЗначенияСвойств[Свойство];
	Если ТипЗнч(Значение) = Тип("Дата") Тогда
		Значение = МестноеВремя(Значение, ЧасовойПоясСеанса());
	ИначеЕсли ТипЗнч(Значение) = Тип("ФиксированныйМассив") Тогда
		ФиксированныйМассив = Значение;
		Значение = "";
		Для каждого ЭлементМассива Из ФиксированныйМассив Цикл
			Значение = Значение + ?(Значение = "", "", Символы.ПС) + СокрЛП(ЭлементМассива);
		КонецЦикла;
	КонецЕсли;
	
	Строка = ВнутреннееСодержание.Добавить();
	Если СтрНачинаетсяС(Свойство, "OID") Тогда
		Строка.Идентификатор = СтрЗаменить(Сред(Свойство, 4), "_", ".");
		Если Свойство <> Представление Тогда
			Строка.Свойство = Представление;
		КонецЕсли;
	Иначе
		Строка.Свойство = Представление;
	КонецЕсли;
	
	Если НижнийРегистр = Истина Тогда
		Строка.Значение = НРег(Значение);
	Иначе
		Строка.Значение = Значение;
	КонецЕсли;
	
КонецПроцедуры

// Преобразует назначения сертификатов в коды назначения.
//
// Параметры:
//  Назначение    - Строка - многострочное назначение сертификата, например:
//                           "Microsoft Encrypted File System (1.3.6.1.4.1.311.10.3.4)
//                           |E-mail Protection (1.3.6.1.5.5.7.3.4)
//                           |TLS Web Client Authentication (1.3.6.1.5.5.7.3.2)".
//  
//  КодыНазначения - Строка - коды назначения "1.3.6.1.4.1.311.10.3.4, 1.3.6.1.5.5.7.3.4, 1.3.6.1.5.5.7.3.2".
//
&НаСервере
Процедура ЗаполнитьКодыНазначенияСертификата(Назначение, КодыНазначения)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Коды = "";
	
	Для Индекс = 1 По СтрЧислоСтрок(Назначение) Цикл
		
		Строка = СтрПолучитьСтроку(Назначение, Индекс);
		ТекущийКод = "";
		
		Позиция = СтрНайти(Строка, "(", НаправлениеПоиска.СКонца);
		Если Позиция <> 0 Тогда
			ТекущийКод = Сред(Строка, Позиция + 1, СтрДлина(Строка) - Позиция - 1);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ТекущийКод) Тогда
			Коды = Коды + ?(Коды = "", "", ", ") + СокрЛП(ТекущийКод);
		КонецЕсли;
		
	КонецЦикла;
	
	КодыНазначения = Коды;
	
КонецПроцедуры

&НаСервере
Функция АдресСертификата(СсылкаОтпечаток, ИдентификаторФормы = Неопределено)
	
	ДанныеСертификата = Неопределено;
	
	Если ТипЗнч(СсылкаОтпечаток) = Тип("СправочникСсылка.СертификатыКлючейЭлектроннойПодписиИШифрования") Тогда
		Хранилище = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаОтпечаток, "ДанныеСертификата");
		Если ТипЗнч(Хранилище) = Тип("ХранилищеЗначения") Тогда
			ДанныеСертификата = Хранилище.Получить();
		КонецЕсли;
	Иначе
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Отпечаток", СсылкаОтпечаток);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Сертификаты.ДанныеСертификата
		|ИЗ
		|	Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования КАК Сертификаты
		|ГДЕ
		|	Сертификаты.Отпечаток = &Отпечаток";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ДанныеСертификата = Выборка.ДанныеСертификата.Получить();
		Иначе
			Сертификат = ЭлектроннаяПодписьСлужебный.ПолучитьСертификатПоОтпечатку(СсылкаОтпечаток, Ложь, Ложь);
			Если Сертификат <> Неопределено Тогда
				ДанныеСертификата = Сертификат.Выгрузить();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеСертификата) = Тип("ДвоичныеДанные") Тогда
		Возврат ПоместитьВоВременноеХранилище(ДанныеСертификата, ИдентификаторФормы);
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти
