///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Функция формирует таблицу значений которая будет выведена пользователю.
//
// Возвращаемое значение:
//  ТаблицаЗначений - итоговая таблица значений.
//
Функция ПоказателиПроизводительности() Экспорт
	
	ПараметрыВычисления = СтруктураПараметровДляРасчетаАпдекса();
	
	ШагЧисло = 0;
	КоличествоШагов = 0;
	Если Не ПериодичностьДиаграммы(ШагЧисло, КоличествоШагов) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыВычисления.ШагЧисло = ШагЧисло;
	ПараметрыВычисления.КоличествоШагов = КоличествоШагов;
	ПараметрыВычисления.ДатаНачала = ДатаНачала;
	ПараметрыВычисления.ДатаОкончания = ДатаОкончания;
	ПараметрыВычисления.ТаблицаКлючевыхОпераций = Производительность.Выгрузить(, "КлючеваяОперация, Приоритет, ЦелевоеВремя");
	Если Не ЗначениеЗаполнено(ОбщаяПроизводительностьСистемы) Или Производительность.Найти(ОбщаяПроизводительностьСистемы, "КлючеваяОперация") = Неопределено Тогда
		ПараметрыВычисления.ВыводитьИтоги = Ложь
	Иначе
		ПараметрыВычисления.ВыводитьИтоги = Истина;
	КонецЕсли;
	ПараметрыВычисления.Комментарий = Комментарий;
	Если НЕ ПустаяСтрока(Комментарий) Тогда
		ПараметрыВычисления.ВариантФильтраКомментарий = ВариантФильтраКомментарий;
	Иначе
		ПараметрыВычисления.ВариантФильтраКомментарий = "НеФильтровать";
	КонецЕсли;
	
	Возврат ВычислитьAPDEX(ПараметрыВычисления);
	
КонецФункции

// Функция динамически формирует запрос и получает APDEX.
//
// Параметры:
//  ПараметрыВычисления - Структура:
//    * ШагЧисло					- Число				- размер шага в секундах.
//    * КоличествоШагов			- Число				- количество шагов в периоде.
//    * ДатаНачала				- Дата				- дата начала замеров.
//    * ДатаОкончания				- Дата				- дата окончания замеров.
//    * ТаблицаКлючевыхОпераций	- ТаблицаЗначений	- содержит данные для выбора. Колонки:
//      ** КлючеваяОперация		- СправочникСсылка.КлючевыеОперации	- ключевая операция.
//      ** НомерСтроки			- Число								- приоритет ключевой операции.
//      ** Целевое время		- Число								- целевое время ключевой операции.
//    * ВыводитьИтоги				- Булево
//
// Возвращаемое значение:
//  ТаблицаЗначений - в таблице возвращается ключевая операция и 
//    показатель производительности за определенный период времени.
//
Функция ВычислитьAPDEX(ПараметрыВычисления) Экспорт
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТаблицаКлючевыхОпераций", ПараметрыВычисления.ТаблицаКлючевыхОпераций);
	Запрос.УстановитьПараметр("НачалоПериода", (ПараметрыВычисления.ДатаНачала - Дата(1,1,1))* 1000);
	Запрос.УстановитьПараметр("КонецПериода", (ПараметрыВычисления.ДатаОкончания - Дата(1,1,1)) * 1000);
	Запрос.УстановитьПараметр("КлючеваяОперацияИтого", ОбщаяПроизводительностьСистемы);
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КлючевыеОперации.КлючеваяОперация КАК КлючеваяОперация,
	|	КлючевыеОперации.Приоритет КАК Приоритет,
	|	КлючевыеОперации.ЦелевоеВремя КАК ЦелевоеВремя
	|ПОМЕСТИТЬ КлючевыеОперации
	|ИЗ
	|	&ТаблицаКлючевыхОпераций КАК КлючевыеОперации";
	Запрос.Выполнить();
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	КлючевыеОперации.КлючеваяОперация КАК КлючеваяОперация,
	|	КлючевыеОперации.Приоритет КАК Приоритет,
	|	КлючевыеОперации.ЦелевоеВремя КАК ЦелевоеВремя
	|	//%Колонки%
	|ИЗ
	|	КлючевыеОперации КАК КлючевыеОперации
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрСведений.ЗамерыВремени КАК ЗамерыВремени
	|ПО
	|	КлючевыеОперации.КлючеваяОперация = ЗамерыВремени.КлючеваяОперация
	|	И ЗамерыВремени.ДатаНачалаЗамера МЕЖДУ &НачалоПериода И &КонецПериода
	|	//%УсловиеКомментарий%
	|ГДЕ
	|	НЕ КлючевыеОперации.КлючеваяОперация = &КлючеваяОперацияИтого
	|
	|СГРУППИРОВАТЬ ПО
	|	КлючевыеОперации.КлючеваяОперация,
	|	КлючевыеОперации.Приоритет,
	|	КлючевыеОперации.ЦелевоеВремя
	|//%Итоги%";
	
	Выражение = 
	"
	|	ВЫБОР
	|		КОГДА 
	|			// Нет записей в периоде о замере по этой ключевой операции
	|			НЕ 1 В (
	|				ВЫБРАТЬ ПЕРВЫЕ 1
	|					1 
	|				ИЗ 
	|					РегистрСведений.ЗамерыВремени КАК ЗамерыВремениВнутр
	|				ГДЕ
	|					ЗамерыВремениВнутр.КлючеваяОперация = КлючевыеОперации.КлючеваяОперация 
	|					И ЗамерыВремениВнутр.КлючеваяОперация <> &КлючеваяОперацияИтого
	|					И ЗамерыВремениВнутр.ДатаНачалаЗамера МЕЖДУ &НачалоПериода И &КонецПериода
	|					И ЗамерыВремениВнутр.ДатаНачалаЗамера >= &НачалоПериода%Номер% 
	|					И ЗамерыВремениВнутр.ДатаНачалаЗамера <= &КонецПериода%Номер%
	|					%УсловиеКомментарийВнутр%
	|			) 
	|			ТОГДА 0
	|
	|		ИНАЧЕ (ВЫРАЗИТЬ((СУММА(ВЫБОР
	|								КОГДА ЗамерыВремени.ДатаНачалаЗамера >= &НачалоПериода%Номер%
	|										И ЗамерыВремени.ДатаНачалаЗамера <= &КонецПериода%Номер%
	|									ТОГДА ВЫБОР
	|											КОГДА ЗамерыВремени.ВремяВыполнения <= КлючевыеОперации.ЦелевоеВремя
	|												ТОГДА 1
	|											ИНАЧЕ 0
	|										КОНЕЦ
	|								ИНАЧЕ 0
	|							КОНЕЦ) + СУММА(ВЫБОР
	|								КОГДА ЗамерыВремени.ДатаНачалаЗамера >= &НачалоПериода%Номер%
	|										И ЗамерыВремени.ДатаНачалаЗамера <= &КонецПериода%Номер%
	|									ТОГДА ВЫБОР
	|											КОГДА ЗамерыВремени.ВремяВыполнения > КлючевыеОперации.ЦелевоеВремя
	|													И ЗамерыВремени.ВремяВыполнения <= КлючевыеОперации.ЦелевоеВремя * 4
	|												ТОГДА 1
	|											ИНАЧЕ 0
	|										КОНЕЦ
	|								ИНАЧЕ 0
	|							КОНЕЦ) / 2) / СУММА(ВЫБОР
	|								КОГДА ЗамерыВремени.ДатаНачалаЗамера >= &НачалоПериода%Номер%
	|										И ЗамерыВремени.ДатаНачалаЗамера <= &КонецПериода%Номер%
	|									ТОГДА 1
	|								ИНАЧЕ 0
	|							КОНЕЦ) + 0.001 КАК ЧИСЛО(6, 3)))
	|	КОНЕЦ КАК Производительность%Номер%";
	
	ВыражениеДляИтогов = 
	"
	|	СУММА(ВЫБОР
	|			КОГДА ЗамерыВремени.ДатаНачалаЗамера >= &НачалоПериода%Номер%
	|					И ЗамерыВремени.ДатаНачалаЗамера <= &КонецПериода%Номер%
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ВремВсего%Номер%,
	|	СУММА(ВЫБОР
	|			КОГДА ЗамерыВремени.ДатаНачалаЗамера >= &НачалоПериода%Номер%
	|					И ЗамерыВремени.ДатаНачалаЗамера <= &КонецПериода%Номер%
	|				ТОГДА ВЫБОР
	|						КОГДА ЗамерыВремени.ВремяВыполнения <= КлючевыеОперации.ЦелевоеВремя
	|							ТОГДА 1
	|						ИНАЧЕ 0
	|					КОНЕЦ
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ВремДоТ%Номер%,
	|	СУММА(ВЫБОР
	|			КОГДА ЗамерыВремени.ДатаНачалаЗамера >= &НачалоПериода%Номер%
	|					И ЗамерыВремени.ДатаНачалаЗамера <= &КонецПериода%Номер%
	|				ТОГДА ВЫБОР
	|						КОГДА ЗамерыВремени.ВремяВыполнения > КлючевыеОперации.ЦелевоеВремя
	|								И ЗамерыВремени.ВремяВыполнения <= КлючевыеОперации.ЦелевоеВремя * 4
	|							ТОГДА 1
	|						ИНАЧЕ 0
	|					КОНЕЦ
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ВремМеждуТ4Т%Номер%";
	
	Итог = 
	"
	|	МАКСИМУМ(ВремВсего%Номер%)";
	
	ПоОбщие = 
	"
	|ПО
	|	ОБЩИЕ";
	
	ЗаголовкиКолонок = Новый Массив;
	Колонки = "";
	Итоги = "";
	НачалоПериода = ПараметрыВычисления.ДатаНачала;
	Для ТекШаг = 0 По ПараметрыВычисления.КоличествоШагов - 1 Цикл
		
		КонецПериода = ?(ТекШаг = ПараметрыВычисления.КоличествоШагов - 1, ПараметрыВычисления.ДатаОкончания, НачалоПериода + ПараметрыВычисления.ШагЧисло - 1);
		
		ИндексШага = Формат(ТекШаг, "ЧН=0; ЧГ=0");
		Запрос.УстановитьПараметр("НачалоПериода" + ИндексШага, (НачалоПериода - Дата(1,1,1)) * 1000);
		Запрос.УстановитьПараметр("КонецПериода" + ИндексШага, (КонецПериода - Дата(1,1,1)) * 1000);
		
		ЗаголовкиКолонок.Добавить(ЗаголовокКолонки(НачалоПериода));
		
		НачалоПериода = НачалоПериода + ПараметрыВычисления.ШагЧисло;
		
		Колонки = Колонки + ?(ПараметрыВычисления.ВыводитьИтоги, "," + ВыражениеДляИтогов, "") + "," + Выражение;
		Колонки = СтрЗаменить(Колонки, "%Номер%", ИндексШага);
		
		Если ПараметрыВычисления.ВыводитьИтоги Тогда
			Итоги = Итоги + Итог + ?(ТекШаг = ПараметрыВычисления.КоличествоШагов - 1, "", ",");
			Итоги = СтрЗаменить(Итоги, "%Номер%", ИндексШага);
		КонецЕсли;
		
	КонецЦикла;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//%Колонки%", Колонки);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//%Итоги%", ?(ПараметрыВычисления.ВыводитьИтоги, "ИТОГИ" + Итоги, ""));
	ТекстЗапроса = ТекстЗапроса + ?(ПараметрыВычисления.ВыводитьИтоги, ПоОбщие, "");
	
	Если ПараметрыВычисления.ВариантФильтраКомментарий = "НеФильтровать" Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//%УсловиеКомментарий%", "");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//%УсловиеКомментарийВнутр%", "");
	ИначеЕсли ПараметрыВычисления.ВариантФильтраКомментарий = "Равен" Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//%УсловиеКомментарий%", "И ЗамерыВремени.Комментарий = &Комментарий");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//%УсловиеКомментарийВнутр%", "И ЗамерыВремениВнутр.Комментарий = &Комментарий");
		Запрос.УстановитьПараметр("Комментарий", ПараметрыВычисления.Комментарий);
	ИначеЕсли ПараметрыВычисления.ВариантФильтраКомментарий = "Содержит" Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//%УсловиеКомментарий%", "И ЗамерыВремени.Комментарий ПОДОБНО &Комментарий");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//%УсловиеКомментарийВнутр%", "И ЗамерыВремениВнутр.Комментарий ПОДОБНО &Комментарий");
		Запрос.УстановитьПараметр("Комментарий", "%" + ПараметрыВычисления.Комментарий + "%");
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Новый ТаблицаЗначений;
	Иначе
		ТаблицаКлючевыхОпераций = Результат.Выгрузить();
		
		ТаблицаКлючевыхОпераций.Сортировать("Приоритет");
		Если ПараметрыВычисления.ВыводитьИтоги Тогда
			ТаблицаКлючевыхОпераций[0][0] = ОбщаяПроизводительностьСистемы;
			ВычислитьИтоговыйAPDEX(ТаблицаКлючевыхОпераций);
		КонецЕсли;
		
		ИндексКолонки = 0;
		ИндексМассива = 0;
		Пока ИндексКолонки <= ТаблицаКлючевыхОпераций.Колонки.Количество() - 1 Цикл
			
			КолонкаТаблицаКлючевыхОпераций = ТаблицаКлючевыхОпераций.Колонки[ИндексКолонки];
			Если СтрНачинаетсяС(КолонкаТаблицаКлючевыхОпераций.Имя, "Врем") Тогда
				ТаблицаКлючевыхОпераций.Колонки.Удалить(КолонкаТаблицаКлючевыхОпераций);
				Продолжить;
			КонецЕсли;
			
			Если ИндексКолонки < 3 Тогда
				ИндексКолонки = ИндексКолонки + 1;
				Продолжить;
			КонецЕсли;
			КолонкаТаблицаКлючевыхОпераций.Заголовок = ЗаголовкиКолонок[ИндексМассива];
			
			ИндексМассива = ИндексМассива + 1;
			ИндексКолонки = ИндексКолонки + 1;
			
		КонецЦикла;
		
		Возврат ТаблицаКлючевыхОпераций;
	КонецЕсли;
	
КонецФункции

// Создает структуру параметров необходимую для расчета APDEX.
//
// Возвращаемое значение:
//  Структура:
//    ШагЧисло - Число - указывается размер шага в секундах.
//    КоличествоШагов - Число - количество шагов в периоде.
//    ДатаНачала - Дата - дата начала замеров.
//    ДатаОкончания - Дата - дата окончания замеров.
//    ТаблицаКлючевыхОпераций - ТаблицаЗначений:
//      КлючеваяОперация - СправочникСсылка.КлючевыеОперации, ключевая операция.
//      НомерСтроки - Число - приоритет ключевой операции.
//      ЦелевоеВремя - Число - целевое время ключевой операции.
//    ВыводитьИтоги - Булево,
//  		Истина, вычислять итоговую производительность
//  		Ложь, не вычислять итоговую производительность.
//
Функция СтруктураПараметровДляРасчетаАпдекса() Экспорт
	СтруктураПараметров = Новый Структура;
	
	СтруктураПараметров.Вставить("ШагЧисло");
	СтруктураПараметров.Вставить("КоличествоШагов");
	СтруктураПараметров.Вставить("ДатаНачала");
	СтруктураПараметров.Вставить("ДатаОкончания");
	СтруктураПараметров.Вставить("ТаблицаКлючевыхОпераций");
	СтруктураПараметров.Вставить("ВыводитьИтоги");
	СтруктураПараметров.Вставить("Комментарий");
	СтруктураПараметров.Вставить("ВариантФильтраКомментарий");
	
	Возврат СтруктураПараметров;
КонецФункции

// Вычисляет размер и количество шагов на заданном интервале.
//
// Параметры:
//  ШагЧисло		- Число - количество секунд, которое надо прибавить к дате начала чтобы выполнить следующий шаг.
//  КоличествоШагов - Число - количество шагов на заданном интервале.
//
// Возвращаемое значение:
//  Булево - 
//  	Истина, параметры рассчитаны
//  	Ложь, параметры не рассчитаны.
//
Функция ПериодичностьДиаграммы(ШагЧисло, КоличествоШагов) Экспорт
	РазницаВремени = ДатаОкончания - ДатаНачала + 1;
	
	Если РазницаВремени <= 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// КоличествоШагов - целое число, округленное вверх.
	КоличествоШагов = 0;
	Если Шаг = "Час" Тогда
		ШагЧисло = 86400 / 24;
		КоличествоШагов = РазницаВремени / ШагЧисло;
		КоличествоШагов = Цел(КоличествоШагов) + ?(КоличествоШагов - Цел(КоличествоШагов) > 0, 1, 0);
	ИначеЕсли Шаг = "День" Тогда
		ШагЧисло = 86400;
		КоличествоШагов = РазницаВремени / ШагЧисло;
		КоличествоШагов = Цел(КоличествоШагов) + ?(КоличествоШагов - Цел(КоличествоШагов) > 0, 1, 0);
	ИначеЕсли Шаг = "Неделя" Тогда
		ШагЧисло = 86400 * 7;
		КоличествоШагов = РазницаВремени / ШагЧисло;
		КоличествоШагов = Цел(КоличествоШагов) + ?(КоличествоШагов - Цел(КоличествоШагов) > 0, 1, 0);
	ИначеЕсли Шаг = "Месяц" Тогда
		ШагЧисло = 86400 * 30;
		Врем = КонецДня(ДатаНачала);
		Пока Врем <= ДатаОкончания Цикл
			Врем = ДобавитьМесяц(Врем, 1);
			КоличествоШагов = КоличествоШагов + 1;
		КонецЦикла;
	Иначе
		ШагЧисло = 0;
		КоличествоШагов = 1;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура рассчитывает итоговое значение APDEX.
//
// Параметры:
//  ТаблицаКлючевыхОпераций - ТаблицаЗначений - результат запроса рассчитавшего APDEX.
//
Процедура ВычислитьИтоговыйAPDEX(ТаблицаКлючевыхОпераций)
	
	// Начинаем с 4 колонки первые 3 это КлючеваяОперация, Приоритет, ЦелевоеВремя.
	ИндексНачальнойКолонки	= 3;
	ИндексСтрокиИтогов		= 0;
	ИндексКолонкиПриоритет	= 1;
	ИндексПоследнейСтроки	= ТаблицаКлючевыхОпераций.Количество() - 1;
	ИндексПоследнейКолонки	= ТаблицаКлючевыхОпераций.Колонки.Количество() - 1;
	МинимальныйПриоритет	= ТаблицаКлючевыхОпераций[ИндексПоследнейСтроки][ИндексКолонкиПриоритет];
	
	// Обнуление строки итогов
	Для Колонка = ИндексКолонкиПриоритет По ИндексПоследнейКолонки Цикл
		Если НЕ ЗначениеЗаполнено(ТаблицаКлючевыхОпераций[ИндексСтрокиИтогов][Колонка]) Тогда
			ТаблицаКлючевыхОпераций[ИндексСтрокиИтогов][Колонка] = 0;
		КонецЕсли;
	КонецЦикла;
	
	Если МинимальныйПриоритет < 1 Тогда
		МинимальныйПриоритет = 1;
	КонецЕсли;
	
	Колонка = ИндексНачальнойКолонки;
	Пока Колонка < ИндексПоследнейКолонки Цикл
		НН = 0;
		НС = 0;
		НТ = 0;
		
		МаксимальноеКоличествоОперацийЗаПериод = ТаблицаКлючевыхОпераций[ИндексСтрокиИтогов][Колонка];
		
		// с 1 т.к. 0 это строка итогов.
		Для Строка = 1 По ИндексПоследнейСтроки Цикл
			
			ПриоритетТекущейОперации = ТаблицаКлючевыхОпераций[Строка][ИндексКолонкиПриоритет];
			КоличествоТекущейОперации = ТаблицаКлючевыхОпераций[Строка][Колонка];
			
			Коэффициент = ?(КоличествоТекущейОперации = 0, 0, 
							МаксимальноеКоличествоОперацийЗаПериод / КоличествоТекущейОперации * (1 - (ПриоритетТекущейОперации - 1) / МинимальныйПриоритет));
			
			ТаблицаКлючевыхОпераций[Строка][Колонка] = ТаблицаКлючевыхОпераций[Строка][Колонка] * Коэффициент;
			ТаблицаКлючевыхОпераций[Строка][Колонка + 1] = ТаблицаКлючевыхОпераций[Строка][Колонка + 1] * Коэффициент;
			ТаблицаКлючевыхОпераций[Строка][Колонка + 2] = ТаблицаКлючевыхОпераций[Строка][Колонка + 2] * Коэффициент;
			
			НН = НН + ТаблицаКлючевыхОпераций[Строка][Колонка];
			НС = НС + ТаблицаКлючевыхОпераций[Строка][Колонка + 1];
			НТ = НТ + ТаблицаКлючевыхОпераций[Строка][Колонка + 2];
		КонецЦикла;
		
		Если НН = 0 Тогда
			ИтоговыйAPDEX = 0;
		ИначеЕсли НС = 0 И НТ = 0 И НН <> 0 Тогда
			ИтоговыйAPDEX = 0.001;
		Иначе
			ИтоговыйAPDEX = (НС + НТ / 2) / НН;
		КонецЕсли;
		ТаблицаКлючевыхОпераций[ИндексСтрокиИтогов][Колонка + 3] = ИтоговыйAPDEX;
		
		Колонка = Колонка + 4;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ЗаголовокКолонки(НачалоПериода)
	
	Если Шаг = "Час" Тогда
		ЗаголовокКолонки = Формат(НачалоПериода, "ДЛФ=T");
	Иначе
		ЗаголовокКолонки = Формат(НачалоПериода, "ДЛФ=D");
	КонецЕсли;
	Возврат ЗаголовокКолонки;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли