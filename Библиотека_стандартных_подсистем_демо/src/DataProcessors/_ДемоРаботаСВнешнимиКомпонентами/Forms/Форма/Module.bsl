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
	
	ПапкаWindows = "%APPDATA%\1C\1Cv8\ExtCompT";
	ПапкаWindowsWeb = "%ProgramData%\1C\1CEWebExt";
	
	ПапкаLinux = "~/.1cv8/1C/1cv8/ExtCompT/";
	ПапкаLinuxWeb = "~/bin";
	
	СформироватьПредставлениеИнформации();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Сценарии подключения

&НаКлиенте
Процедура ПодключитьКомпонентуБезКэширования(Команда)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Ключ", "Значение");
	
	Оповещение = Новый ОписаниеОповещения("ПодключитьКомпонентуПослеПодключения", ЭтотОбъект, ДополнительныеПараметры);
	
	ПараметрыПодключения = ВнешниеКомпонентыКлиент.ПараметрыПодключения();
	ПараметрыПодключения.Кэшировать = Ложь;
	ПараметрыПодключения.ТекстПояснения = 
		НСтр("ru = 'Демо: Для использования сканера штрихкодов требуется
		           |внешняя компонента «1С:Сканеры штрихкода (NativeApi)».'");
	
	ВнешниеКомпонентыКлиент.ПодключитьКомпоненту(Оповещение, "InputDevice",, ПараметрыПодключения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьКомпоненту(Команда)

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Ключ", "Значение");
	
	Оповещение = Новый ОписаниеОповещения("ПодключитьКомпонентуПослеПодключения", ЭтотОбъект, ДополнительныеПараметры);
	
	ПараметрыПодключения = ВнешниеКомпонентыКлиент.ПараметрыПодключения();
	ПараметрыПодключения.ТекстПояснения = 
		НСтр("ru = 'Демо: Для использования сканера штрихкодов требуется
		           |внешняя компонента «1С:Сканеры штрихкода (NativeApi)».'");
	
	ВнешниеКомпонентыКлиент.ПодключитьКомпоненту(Оповещение, "InputDevice", "8.1.7.1", ПараметрыПодключения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьКомпонентуCOM(Команда)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Ключ", "Значение");
	
	Оповещение = Новый ОписаниеОповещения("ПодключитьКомпонентуПослеПодключения", ЭтотОбъект, ДополнительныеПараметры);
	
	ПараметрыПодключения = ВнешниеКомпонентыКлиент.ПараметрыПодключения();
	ПараметрыПодключения.ТекстПояснения = 
		НСтр("ru = 'Демо: Для использования сканера штрихкодов требуется
		           |внешняя компонента «1С:Сканеры штрихкода».'");
	
	ВнешниеКомпонентыКлиент.ПодключитьКомпоненту(Оповещение, "Scanner",, ПараметрыПодключения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьКомпонентуИзМакета(Команда)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Ключ", "Значение");
	
	Оповещение = Новый ОписаниеОповещения("ПодключитьКомпонентуПослеПодключения", ЭтотОбъект, ДополнительныеПараметры);
	
	ПараметрыПодключения = ОбщегоНазначенияКлиент.ПараметрыПодключенияКомпоненты();
	ПараметрыПодключения.ТекстПояснения = 
		НСтр("ru = 'Демо: Для сканирования документов требуется подключить внешнюю компоненту.'");
	ПараметрыПодключения.Кэшировать = Ложь;
	
	ОбщегоНазначенияКлиент.ПодключитьКомпонентуИзМакета(Оповещение, 
		"AddInNativeExtension",
		"ОбщийМакет.КомпонентаTWAIN",
		ПараметрыПодключения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьКомпонентуИзРеестраWindows(Команда)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Ключ", "Значение");
	
	Оповещение = Новый ОписаниеОповещения("ПодключитьКомпонентуПослеПодключения", ЭтотОбъект, ДополнительныеПараметры);
	
	ВнешниеКомпонентыКлиент.ПодключитьКомпонентуИзРеестраWindows(Оповещение, "SBRFCOMObject", "SBRFCOMExtension");
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьКомпонентуИзМакетаНаСервере(Команда)
	
	ПодключитьКомпонентуИзМакетаНаСервереНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьКомпонентуНаСервере(Команда)
	ПодключитьКомпонентуНаСервереНаСервере();
КонецПроцедуры

// Сценарий установки

&НаКлиенте
Процедура УстановитьКомпоненту(Команда)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Ключ", "Значение");
	
	ПараметрыУстановки = ВнешниеКомпонентыКлиент.ПараметрыУстановки();
	ПараметрыУстановки.ТекстПояснения = 
		НСтр("ru = 'Демо: Для использования сканера штрихкодов требуется
		           |внешняя компонента «1С:Сканеры штрихкода (NativeApi)».'");
	
	Оповещение = Новый ОписаниеОповещения(
		"УстановитьКомпонентуПослеУстановки", ЭтотОбъект, ДополнительныеПараметры);
	
	ВнешниеКомпонентыКлиент.УстановитьКомпоненту(Оповещение, "InputDevice",, ПараметрыУстановки);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьКомпонентуИзМакета(Команда)
	
	Оповещение = Новый ОписаниеОповещения("УстановитьКомпонентуПослеУстановки", ЭтотОбъект);
	
	ПараметрыУстановки = ОбщегоНазначенияКлиент.ПараметрыУстановкиКомпоненты();
	ПараметрыУстановки.ТекстПояснения = 
		НСтр("ru = 'Для оформления заявления на выпуск сертификата требуется
		           |внешняя компонента «Криптография (CryptS)».'");
	
	ОбщегоНазначенияКлиент.УстановитьКомпонентуИзМакета(Оповещение,
		"Обработка._ДемоРаботаСВнешнимиКомпонентами.Макет.КомпонентаОбмена",
		ПараметрыУстановки);
	
КонецПроцедуры

// Сценарий загрузки из файла.

&НаКлиенте
Процедура ЗагрузитьВнешнийМодульИзФайла(Команда)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Ключ", "Значение");
	
	ПараметрыЗагрузки = ВнешниеКомпонентыКлиент.ПараметрыЗагрузки();
	ПараметрыЗагрузки.Идентификатор = Идентификатор;
	ПараметрыЗагрузки.Версия = Версия;
	
	Оповещение = Новый ОписаниеОповещения(
		"ЗагрузитьВнешнийМодульИзФайлаПослеЗагрузки", ЭтотОбъект, ДополнительныеПараметры);
	
	ВнешниеКомпонентыКлиент.ЗагрузитьКомпонентуИзФайла(Оповещение, ПараметрыЗагрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьВнешнийМодульИзФайлаСДополнительнойИнформацией(Команда)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Ключ", "Значение");
	
	ПараметрыПоискаТипаДрайвера = ВнешниеКомпонентыКлиент.ПараметрыПоискаДополнительнойИнформации();
	ПараметрыПоискаТипаДрайвера.ИмяФайлаXML = "INFO.XML";
	ПараметрыПоискаТипаДрайвера.ВыражениеXPath = "//drivers/component/@type";
	
	ПараметрыЗагрузки = ВнешниеКомпонентыКлиент.ПараметрыЗагрузки();
	ПараметрыЗагрузки.Идентификатор = Идентификатор;
	ПараметрыЗагрузки.Версия = Версия;
	ПараметрыЗагрузки.ПараметрыПоискаДополнительнойИнформации.Вставить("ТипДрайвера", ПараметрыПоискаТипаДрайвера);
	
	Оповещение = Новый ОписаниеОповещения(
		"ЗагрузитьВнешнийМодульИзФайлаПослеЗагрузки", ЭтотОбъект, ДополнительныеПараметры);
	
	ВнешниеКомпонентыКлиент.ЗагрузитьКомпонентуИзФайла(Оповещение, ПараметрыЗагрузки);
	
КонецПроцедуры

// Сценарий получения информации.

&НаКлиенте
Процедура ПолучитьИнформацию(Команда)
	
	ПолучитьИнформациюНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Сценарии подключения

&НаКлиенте
Процедура ПодключитьКомпонентуПослеПодключения(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.Подключено Тогда 
		ПодключаемыйМодуль = Результат.ПодключаемыйМодуль;
		Если ПодключаемыйМодуль <> Неопределено Тогда 
			ПоказатьПредупреждение(, НСтр("ru = 'Компонента подключена успешно.'"));
		КонецЕсли;
	ИначеЕсли Не ПустаяСтрока(Результат.ОписаниеОшибки) Тогда 
		ПоказатьПредупреждение(, Результат.ОписаниеОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодключитьКомпонентуИзМакетаНаСервереНаСервере()
	
	ПодключаемыйМодуль = ОбщегоНазначения.ПодключитьКомпонентуИзМакета(
		"CryptS", "Обработка._ДемоРаботаСВнешнимиКомпонентами.Макет.КомпонентаОбмена");
	Если ПодключаемыйМодуль = Неопределено Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Демо: Ошибка при подключении компоненты'"));
	Иначе
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Демо: Успешное подключение'"));
	КонецЕсли;
	
	ПодключаемыйМодуль = Неопределено;
	
КонецПроцедуры

&НаСервере
Процедура ПодключитьКомпонентуНаСервереНаСервере()
	Результат = ВнешниеКомпонентыСервер.ПодключитьКомпоненту("CustomerDisplay1C");
	Если Не Результат.Подключено Тогда
		ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Демо: Ошибка при подключении компоненты: %1'"),
			Результат.ОписаниеОшибки));
	Иначе
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Демо: Успешное подключение'"));
	КонецЕсли;
КонецПроцедуры

// Сценарий установки

&НаКлиенте
Процедура УстановитьКомпонентуПослеУстановки(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.Установлено Тогда 
		ПоказатьПредупреждение(, НСтр("ru = 'Компонента установлена успешно.'"));
	ИначеЕсли Не ПустаяСтрока(Результат.ОписаниеОшибки) Тогда
		ПоказатьПредупреждение(, Результат.ОписаниеОшибки);
	КонецЕсли;
	
КонецПроцедуры

// Сценарий загрузки из файла.

// Параметры:
//  Результат - см. ИнформацияОКомпоненте
//  ДополнительныеПараметры - Произвольный
//
&НаКлиенте
Процедура ЗагрузитьВнешнийМодульИзФайлаПослеЗагрузки(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.Загружена Тогда 
		
		ИнформацияОКомпоненте = ИнформацияОКомпоненте();
		ЗаполнитьЗначенияСвойств(ИнформацияОКомпоненте, Результат);
		Идентификатор = Результат.Идентификатор;
		Версия        = Результат.Версия;
		ТипДрайвера = Результат.ДополнительнаяИнформация.Получить("ТипДрайвера");
		
		ПоказатьПредупреждение(, НСтр("ru = 'Компонента успешно загружена'"));
	Иначе 
		ПоказатьПредупреждение(, НСтр("ru = 'Компонента не загружена'"));
	КонецЕсли;
	
	СформироватьПредставлениеИнформации();
	
КонецПроцедуры

// Сценарий получения информации.

// Возвращаемое значение:
//  Структура:
//   * Наименование - Строка
//   * Версия - Строка
//   * Идентификатор - Строка
//
&НаКлиентеНаСервереБезКонтекста
Функция ИнформацияОКомпоненте()
	
	Информация = Новый Структура;
	Информация.Вставить("Идентификатор");
	Информация.Вставить("Версия");
	Информация.Вставить("Наименование");
	
	Возврат Информация;
	
КонецФункции

&НаСервере
Процедура СформироватьПредставлениеИнформации()
	
	Если ЗначениеЗаполнено(ИнформацияОКомпоненте) Тогда
		
		Шаблон = НСтр("ru = 'Демо: %1. Версия %2.'");
		
		Элементы.ИнформацияОВнешнемМодуле.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон,
			ИнформацияОКомпоненте.Наименование, 
			ИнформацияОКомпоненте.Версия);
			
		Элементы.ЗагрузитьВнешнийМодульИзФайла.Заголовок = НСтр("ru = 'Демо: Обновить из файла...'");
		Элементы.ЗагрузитьВнешнийМодульИзФайлаСДополнительнойИнформацией.Заголовок = 
			НСтр("ru = 'Демо: Обновить из файла (с определением типа драйвера)...'");
	Иначе
		Элементы.ИнформацияОВнешнемМодуле.Заголовок = НСтр("ru = 'Демо: Не загружен.'");
		Элементы.ЗагрузитьВнешнийМодульИзФайла.Заголовок = НСтр("ru = 'Демо: Загрузить из файла...'");
		Элементы.ЗагрузитьВнешнийМодульИзФайлаСДополнительнойИнформацией.Заголовок = 
			НСтр("ru = 'Демо: Загрузить из файла (с определением типа драйвера)...'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьИнформациюНаСервере()
	
	Результат = ВнешниеКомпонентыВызовСервера.ИнформацияОКомпоненте(Идентификатор,
		?(ПустаяСтрока(Версия), Неопределено, Версия));
		
	Если Результат.Существует Тогда
		
		ИнформацияОКомпоненте = ИнформацияОКомпоненте();
		ЗаполнитьЗначенияСвойств(ИнформацияОКомпоненте, Результат);
		
		Идентификатор = Результат.Идентификатор;
		Версия        = Результат.Версия;

	Иначе
		
		ИнформацияОКомпоненте = Неопределено;
		ОбщегоНазначения.СообщитьПользователю(Результат.ОписаниеОшибки);
		
	КонецЕсли;
	
	СформироватьПредставлениеИнформации(); // Формируем представление по полученным данным.
	
КонецПроцедуры

#КонецОбласти


