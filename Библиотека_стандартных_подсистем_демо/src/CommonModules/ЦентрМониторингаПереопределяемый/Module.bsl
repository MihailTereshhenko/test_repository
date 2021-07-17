///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Выполняется при запуске регламентного задания.
//
Процедура ПриСбореПоказателейСтатистикиКонфигурации() Экспорт
	
	// _Демо начало примера
	// Собрать статистику по количеству каждого вида номенклатуры.
	// В регистр сведений <СтатистикаКонфигураций> будут внесен набор записей следующего состава.
	//
	// Справочник._ДемоНоменклатура.ВидНоменклатуры1	Количество1
	// Справочник._ДемоНоменклатура.ВидНоменклатуры2	Количество2
	// ...
	// Справочник._ДемоНоменклатура.ВидНоменклатурыN	КоличествоN.
	СоответствиеИменМетаданных = Новый Соответствие;
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	_ДемоНоменклатура.ВидНоменклатуры КАК ВидНоменклатуры,
		|	КОЛИЧЕСТВО(*) КАК Количество
		|ИЗ
		|	Справочник._ДемоНоменклатура КАК _ДемоНоменклатура
		|ГДЕ
		|	_ДемоНоменклатура.ЭтоГруппа = ЛОЖЬ
		|
		|СГРУППИРОВАТЬ ПО
		|	_ДемоНоменклатура.ВидНоменклатуры";
	СоответствиеИменМетаданных.Вставить("Справочник._ДемоНоменклатура", ТекстЗапроса);
	
	ЦентрМониторинга.ЗаписатьСтатистикуКонфигурации(СоответствиеИменМетаданных);
	// _Демо конец примера
	
	// _Демо начало примера
	// Собрать статистику по способу установки курса справочника Валюты.
	// В регистр сведений <СтатистикаКонфигураций> будут внесена записи следующего вида.
	//
	// Справочник.Валюты.СпособУстановкиКурса1		Количество1
	// Справочник.Валюты.СпособУстановкиКурса2		Количество2
	// ...
	// Справочник.Валюты.СпособУстановкиКурсаN		КоличествоN.
	СоответствиеИменМетаданных = Новый Соответствие;
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	Валюты.СпособУстановкиКурса КАК СпособУстановкиКурса,
		|	КОЛИЧЕСТВО(*) КАК Количество
		|ИЗ
		|	Справочник.Валюты КАК Валюты
		|
		|СГРУППИРОВАТЬ ПО
		|	Валюты.СпособУстановкиКурса";
	СоответствиеИменМетаданных.Вставить("Справочник.Валюты", ТекстЗапроса);
	
	ЦентрМониторинга.ЗаписатьСтатистикуКонфигурации(СоответствиеИменМетаданных);
	// _Демо конец примера
	
	// _Демо начало примера
	// Собрать статистику по количество валют, курс которых загружается через интернет.
	// В регистр сведений <СтатистикаКонфигураций> будут внесена запись следующего вида
	// Справочник.Валюты.ЗагружаетсяИзИнтернета		Количество.
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(*) КАК Количество
		|ИЗ
		|	Справочник.Валюты КАК Валюты
		|ГДЕ
		|	Валюты.СпособУстановкиКурса = &СпособУстановкиКурса";
	
	Запрос.УстановитьПараметр("СпособУстановкиКурса", Перечисления.СпособыУстановкиКурсаВалюты.ЗагрузкаИзИнтернета);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	ЦентрМониторинга.ЗаписатьСтатистикуОбъектаКонфигурации("Справочник.Валюты.ЗагружаетсяИзИнтернета", Выборка.Количество);
	// _Демо конец примера
	
КонецПроцедуры

// Задает настройки, применяемые как умолчания для объектов подсистемы.
//
// Параметры:
//   Настройки - Структура - коллекция настроек подсистемы. Реквизиты:
//       * ВключитьОповещение - Булево - умолчание для оповещений пользователя:
//           Истина - По умолчанию оповещаем администратора системы, например, если нет подсистемы "Текущие дела".
//           Ложь   - По умолчанию не оповещаем администратора системы.
//           Значение по умолчанию: зависит от наличия подсистемы "Текущие дела".                              
//
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
	// _Демо начало примера
	Настройки.ВключитьОповещение = Истина;
	// _Демо конец примера
	
КонецПроцедуры

#КонецОбласти
