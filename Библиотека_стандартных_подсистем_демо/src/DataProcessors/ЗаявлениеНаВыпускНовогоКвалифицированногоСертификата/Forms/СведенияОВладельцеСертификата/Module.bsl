///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем РеквизитыПроверкиАдреса;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьСведенияОВладельце(ЭтотОбъект, Параметры.СведенияОВладельце);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		
		МодульУправлениеКонтактнойИнформацией = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформацией");
		ВидКонтактнойИнформации = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(
			Перечисления["ТипыКонтактнойИнформации"].Адрес);
			
		ВидКонтактнойИнформации.НастройкиПроверки.ТолькоНациональныйАдрес = Истина;
		
		ВидКонтактнойИнформацииТелефон = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(
			Перечисления["ТипыКонтактнойИнформации"].Телефон);
		
	КонецЕсли;
	
	Если СведенияОВладельце.ЭтоФизическоеЛицо Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = НСтр("ru = 'Сведения о физическом лице'");
		ПроверитьАдрес("ВладелецАдресРегистрации");
	КонецЕсли;
	
	Если Параметры.ТолькоПросмотр Тогда
		Элементы.ВсеЭлементы.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	ЭлектроннаяПодписьСлужебный.СброситьРазмерыИПоложениеОкна(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РеквизитыПроверкиАдреса = Новый Структура;
	РеквизитыПроверкиАдреса.Вставить("ВладелецАдресРегистрации", Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	СтандартнаяОбработка = Ложь;
	ЗадатьВопросПередЗакрытием();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия <> "ИзменениеВладельцаВЗаявленииНаВыпускСертификата" Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	ЗаполнитьСведенияОВладельце(ЭтотОбъект, Параметр);
	
	Если СведенияОВладельце.ЭтоФизическоеЛицо Тогда
		РеквизитыПроверкиАдреса.ВладелецАдресРегистрации = Истина;
		ПодключитьОбработчикОжидания("ПроверитьАдресОбработчикОжидания", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РеквизитПриИзменении(Элемент)
	
	Модифицированность = Истина;
	Если ТипЗнч(ЭтотОбъект[Элемент.Имя]) = Тип("Строка") Тогда
		ЭтотОбъект[Элемент.Имя] = СокрЛП(ЭтотОбъект[Элемент.Имя]);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтраховойНомерПФРПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	СтраховойНомерПФР = ТолькоЦифры(СтраховойНомерПФР);
	
КонецПроцедуры

&НаКлиенте
Процедура ГражданствоПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ГражданствоСвойства(Гражданство));
	Если Не ЗначениеЗаполнено(ГражданствоОКСМКодАльфа3) Тогда
		Если ЗначениеЗаполнено(Гражданство) Тогда
			ПоказатьПредупреждение(, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'У страны ""%1"" не указан трехзначный буквенный код альфа-3 по ОКСМ.'"),
				Гражданство));
		КонецЕсли;
		Гражданство = Неопределено;
		ГражданствоПредставление = "";
		ГражданствоОКСМКодАльфа3 = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументВидПриИзменении(Элемент)
	
	Модифицированность = Истина;
	ПриИзмененииВидаДокумента(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументВидОчистка(Элемент, СтандартнаяОбработка)
	
	Модифицированность = Истина;
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументНомерПриИзменении(Элемент)
	
	Модифицированность = Истина;
	Если ДокументВид = "21" Тогда
		ДокументНомер = ТолькоЦифры(ДокументНомер);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументДатаВыдачиПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументКодПодразделенияПриИзменении(Элемент)
	
	Модифицированность = Истина;
	ДокументКодПодразделения = ТолькоЦифры(ДокументКодПодразделения);
	
КонецПроцедуры


&НаКлиенте
Процедура ВладелецАдресРегистрацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПредставлениеАдресаНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка,
		"ВладелецАдресРегистрации", НСтр("ru = 'Адрес регистрации физического лица'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ВладелецАдресРегистрацииОчистка(Элемент, СтандартнаяОбработка)
	
	ПредставлениеАдресаОчистка(ЭтотОбъект, Элемент, СтандартнаяОбработка, "ВладелецАдресРегистрации");
	
КонецПроцедуры

&НаКлиенте
Процедура ВладелецАдресРегистрацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Модифицированность = Истина;
	ПредставлениеАдресаОбработкаВыбора(ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка, "ВладелецАдресРегистрации");
	
КонецПроцедуры

&НаКлиенте
Процедура АдресПредупреждениеНажатие(Элемент)
	
	ПоказатьПредупреждение(, Элемент.Подсказка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВладелецТелефонНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПредставлениеТелефонаНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка,
		"ВладелецТелефон", НСтр("ru = 'Телефон'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ВладелецТелефонОчистка(Элемент, СтандартнаяОбработка)
	
	Модифицированность = Истина;
	ПредставлениеТелефонаОчистка(ЭтотОбъект, Элемент, СтандартнаяОбработка, "ВладелецТелефон");
	
КонецПроцедуры

&НаКлиенте
Процедура ВладелецТелефонОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Модифицированность = Истина;
	ПредставлениеТелефонаОбработкаВыбора(ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка, "ВладелецТелефон");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	СохранитьИзмененияИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ЗадатьВопросПередЗакрытием();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗадатьВопросПередЗакрытием()
	
	Если Не Модифицированность Тогда
		Закрыть(Неопределено);
		Возврат;
	КонецЕсли;
	
	ПоказатьВопрос(Новый ОписаниеОповещения("ЗакрытиеПослеОтветаНаВопрос", ЭтотОбъект),
		НСтр("ru = 'Данные были изменены. Сохранить изменения?'"), РежимДиалогаВопрос.ДаНетОтмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытиеПослеОтветаНаВопрос(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть(Неопределено);
	ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
		СохранитьИзмененияИЗакрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзмененияИЗакрыть()
	
	ОчиститьСообщения();
	
	Если Не ПроверитьСведенияОВладельце() Тогда
		Если Не Элементы.ВсеЭлементы.ТолькоПросмотр Тогда
			ПоказатьВопрос(Новый ОписаниеОповещения("СохранениеПослеОтветаНаВопрос", ЭтотОбъект),
				НСтр("ru = 'Есть ошибки. Все равно сохранить изменения?'"),
				РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если Не Модифицированность Тогда
		Закрыть(Неопределено);
		Возврат;
	КонецЕсли;
	
	СохранениеПослеОтветаНаВопрос(КодВозвратаДиалога.Да, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранениеПослеОтветаНаВопрос(Ответ, Контекст) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ПодготовитьИзмененияНаСервере();
	
	Модифицированность = Ложь;
	Закрыть(СведенияОВладельце);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПриИзмененииВидаДокумента(Форма)
	
	Если Форма.ДокументВид = "" Тогда
		Форма.ДокументВид = "21";
	КонецЕсли;
	
	Элементы = Форма.Элементы;
	
	Если Форма.ДокументВид = "21" Тогда
		Элементы.ДокументНомер.Заголовок = НСтр("ru = 'Серия и номер'");
		Элементы.ДокументНомер.Маска = "99 99 999999";
		Элементы.ДокументКодПодразделения.Видимость = Истина;
	Иначе
		Элементы.ДокументНомер.Заголовок = НСтр("ru = 'Номер'");
		Элементы.ДокументНомер.Маска = "";
		Элементы.ДокументКодПодразделения.Видимость = Ложь;
		Форма.ДокументКодПодразделения = "";
	КонецЕсли;
	
	Если Форма.ДокументВид = 91 Тогда
		Форма.ДокументВид = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеАдресаНачалоВыбора(Форма, Элемент, ДанныеВыбора, СтандартнаяОбработка, ИмяРеквизита, ЗаголовокФормы)
	
	Если Не ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		Возврат;
	КонецЕсли;
	
	МодульУправлениеКонтактнойИнформациейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль(
		"УправлениеКонтактнойИнформациейКлиент");
	
	УстановитьНаименованиеКонтактнойИнформации(ВидКонтактнойИнформации, ЗаголовокФормы);
	ПараметрыФормы = МодульУправлениеКонтактнойИнформациейКлиент.ПараметрыФормыКонтактнойИнформации(
		ВидКонтактнойИнформации, ЭтотОбъект[ИмяРеквизита + "XML"], ЭтотОбъект[ИмяРеквизита]);
	
	МодульУправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыФормы, Элемент);
	
КонецПроцедуры

// Параметры:
//  ВидКИ - см. УправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации
//  ЗаголовокФормы - Строка
//
&НаКлиенте
Процедура УстановитьНаименованиеКонтактнойИнформации(ВидКИ, ЗаголовокФормы)
	ВидКИ.Наименование = ЗаголовокФормы;
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеАдресаОчистка(Форма, Элемент, СтандартнаяОбработка, ИмяРеквизита)
	
	Форма[ИмяРеквизита + "XML"] = "";
	Форма[ИмяРеквизита] = "";
	
	РеквизитыПроверкиАдреса[ИмяРеквизита] = Истина;
	ПодключитьОбработчикОжидания("ПроверитьАдресОбработчикОжидания", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеАдресаОбработкаВыбора(Форма, Элемент, ВыбранноеЗначение, СтандартнаяОбработка, ИмяРеквизита)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Форма[ИмяРеквизита + "XML"] = ВыбранноеЗначение.КонтактнаяИнформация;
	Форма[ИмяРеквизита] = ВыбранноеЗначение.Представление;
	
	РеквизитыПроверкиАдреса[ИмяРеквизита] = Истина;
	ПодключитьОбработчикОжидания("ПроверитьАдресОбработчикОжидания", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеТелефонаНачалоВыбора(Форма, Элемент, ДанныеВыбора, СтандартнаяОбработка, ИмяРеквизита, ЗаголовокФормы)
	
	Если Не ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		Возврат;
	КонецЕсли;
	
	МодульУправлениеКонтактнойИнформациейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль(
		"УправлениеКонтактнойИнформациейКлиент");
	
	ПараметрыФормы = МодульУправлениеКонтактнойИнформациейКлиент.ПараметрыФормыКонтактнойИнформации(
		ВидКонтактнойИнформацииТелефон, ЭтотОбъект[ИмяРеквизита + "XML"], ЭтотОбъект[ИмяРеквизита]);
	
	ПараметрыФормы.Вставить("Заголовок", ЗаголовокФормы);
	
	МодульУправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеТелефонаОчистка(Форма, Элемент, СтандартнаяОбработка, ИмяРеквизита)
	
	Форма[ИмяРеквизита + "XML"] = "";
	Форма[ИмяРеквизита] = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеТелефонаОбработкаВыбора(Форма, Элемент, ВыбранноеЗначение, СтандартнаяОбработка, ИмяРеквизита)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда
		// Данные не изменены.
		Возврат;
	КонецЕсли;
	
	Форма[ИмяРеквизита + "XML"] = ВыбранноеЗначение.КонтактнаяИнформация;
	Форма[ИмяРеквизита] = ВыбранноеЗначение.Представление;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьАдресОбработчикОжидания()
	
	Для Каждого КлючИЗначение Из РеквизитыПроверкиАдреса Цикл
		
		Если КлючИЗначение.Значение Тогда
			ПроверитьАдрес(КлючИЗначение.Ключ);
			РеквизитыПроверкиАдреса[КлючИЗначение.Ключ] = Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьАдрес(ИмяРеквизита)
	
	ОбработкаМодуль = Обработки.ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата;
	Сообщение = ОбработкаМодуль.ПроверитьАдрес(ЭтотОбъект[ИмяРеквизита + "XML"],
		СведенияОВладельце.ЭтоФизическоеЛицо);
	
	Если ЗначениеЗаполнено(Сообщение) Тогда
		Элементы[ИмяРеквизита + "Предупреждение"].Подсказка = Сообщение;
		Элементы[ИмяРеквизита + "Предупреждение"].Видимость = Истина;
	Иначе
		Элементы[ИмяРеквизита + "Предупреждение"].Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПодготовитьИзмененияНаСервере()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		МодульУправлениеКонтактнойИнформацией = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформацией");
		ЭлектроннаяПочта = МодульУправлениеКонтактнойИнформацией.КонтактнаяИнформацияВJSON(
			ЭлектроннаяПочта, Перечисления["ТипыКонтактнойИнформации"].АдресЭлектроннойПочты);
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(СведенияОВладельце, ЭтотОбъект);
	
	Если Пол = 1 Тогда
		СведенияОВладельце.Пол = "Мужской";
	ИначеЕсли Пол = 2 Тогда
		СведенияОВладельце.Пол = "Женский";
	Иначе
		СведенияОВладельце.Пол = "";
	КонецЕсли;
	
	СведенияОВладельце.ВладелецТелефон = ЭтотОбъект.ВладелецТелефонXML;
	СведенияОВладельце.ВладелецАдресРегистрации = ЭтотОбъект.ВладелецАдресРегистрацииXML;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ПроверитьСведенияОВладельце()
	
	ОбработкаМодуль = Обработки.ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата;
	ЭтоИП = СведенияОВладельце.ЭтоИндивидуальныйПредприниматель;
	ЭтоФЛ = СведенияОВладельце.ЭтоФизическоеЛицо;
	
	ПроверяемыеРеквизиты = Новый Массив;
	ОбработкаМодуль.ДобавитьРеквизитыДляПроверки(ЭтотОбъект,
		ПроверяемыеРеквизиты, ОбработкаМодуль.РеквизитыВладельцаСертификата(ЭтотОбъект, ЭтоИП, ЭтоФЛ));
	
	Возврат Не Обработки.ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата.ПроверитьЗаполнениеРеквизитов(
		ЭтотОбъект, ПроверяемыеРеквизиты, ЭтоИП, ЭтоФЛ, Ложь);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьСведенияОВладельце(Форма, СведенияОВладельце)
	
	ЗаполнитьЗначенияСвойств(Форма, СведенияОВладельце);
	Форма.СведенияОВладельце = СведенияОВладельце;
	
	Если Форма.СведенияОВладельце.Пол = "Мужской" Тогда
		Форма.Пол = 1;
	ИначеЕсли Форма.СведенияОВладельце.Пол = "Женский" Тогда
		Форма.Пол = 2;
	КонецЕсли;
	
	ПриИзмененииВидаДокумента(Форма);
	
	Элементы = Форма.Элементы;
	ЭтоФизическоеЛицо = Форма.СведенияОВладельце.ЭтоФизическоеЛицо;
	ЭтоЮридическоеЛицо = Не ЭтоФизическоеЛицо И Не Форма.СведенияОВладельце.ЭтоИндивидуальныйПредприниматель;
	
	Элементы.Должность.Видимость     = ЭтоЮридическоеЛицо;
	Элементы.Подразделение.Видимость = ЭтоЮридическоеЛицо;
	Если Не ЭтоЮридическоеЛицо Тогда
		Форма.Должность = "";
		Форма.Подразделение = "";
	КонецЕсли;
	
	Элементы.ВладелецИНН.Видимость                    = ЭтоФизическоеЛицо;
	Элементы.ВладелецТелефон.Видимость                = ЭтоФизическоеЛицо;
	Элементы.ГруппаВладелецАдресРегистрации.Видимость = ЭтоФизическоеЛицо;
	Если Не ЭтоФизическоеЛицо Тогда
		Форма.ВладелецИНН = "";
		Форма.ВладелецТелефон = "";
		Форма.ВладелецТелефонXML = "";
	КонецЕсли;
	
	Форма.Модифицированность = Ложь;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ГражданствоСвойства(Гражданство)
	
	Возврат Обработки.ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата.ГражданствоСвойства(Гражданство);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ТолькоЦифры(Строка)
	
	ДлинаСтроки = СтрДлина(Строка);
	
	ОбработаннаяСтрока = "";
	Для НомерСимвола = 1 По ДлинаСтроки Цикл
		
		Символ = Сред(Строка, НомерСимвола, 1);
		Если Символ >= "0" И Символ <= "9" Тогда
			ОбработаннаяСтрока = ОбработаннаяСтрока + Символ;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ОбработаннаяСтрока;
	
КонецФункции

#КонецОбласти