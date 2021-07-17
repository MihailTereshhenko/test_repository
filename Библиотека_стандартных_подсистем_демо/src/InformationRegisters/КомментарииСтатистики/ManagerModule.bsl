///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСсылку(Наименование, ОперацияСсылка) Экспорт
	Если Наименование <> Неопределено Тогда 
		ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.SHA1);
		ХешированиеДанных.Добавить(Наименование);
		ХешНаименования = СтрЗаменить(Строка(ХешированиеДанных.ХешСумма), " ", "");
		
		Ссылки = НайтиПоХешу(ХешНаименования, ОперацияСсылка);
		Если Ссылки.СсылкаКомментарий = Неопределено Тогда
			Если РегистрыСведений.ОперацииСтатистики.МожноНовыйКомментарий(ОперацияСсылка) Тогда
				Ссылка = СоздатьНовый(Наименование, ХешНаименования, ОперацияСсылка);
			Иначе
				Ссылка = ПолучитьСсылкуМногоКомментариев(ОперацияСсылка);
			КонецЕсли;
		Иначе
			Если Ссылки.СсылкаКомментарийОперации = Неопределено Тогда
				Если РегистрыСведений.ОперацииСтатистики.МожноНовыйКомментарий(ОперацияСсылка) Тогда
					РегистрыСведений.КомментарииОперацииСтатистики.СоздатьНовуюЗапись(ОперацияСсылка, Ссылки.СсылкаКомментарий);
					Ссылка = Ссылки.СсылкаКомментарий;
					РегистрыСведений.ОперацииСтатистики.УвеличитьКоличествоУникальныхКомментариев(ОперацияСсылка, Ссылка);
				Иначе
					Ссылка = ПолучитьСсылкуМногоКомментариев(ОперацияСсылка);
				КонецЕсли;
			Иначе
				Ссылка = Ссылки.СсылкаКомментарий;
			КонецЕсли;
		КонецЕсли;
	Иначе
		Ссылка = ОбщегоНазначенияКлиентСервер.ПустойУникальныйИдентификатор();
	КонецЕсли;
		
	Возврат Ссылка;
КонецФункции

Функция ПолучитьСсылкуМногоКомментариев(СсылкаОперация)
	Ссылки = Новый Структура;
	Ссылки.Вставить("СсылкаКомментарий", Неопределено);
		
	НачатьТранзакцию();
	Попытка
		ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.SHA1);
		СлишкомМногоКомментариев = НСтр("ru = 'Слишком много комментариев'");
		ХешированиеДанных.Добавить(СлишкомМногоКомментариев);
		ХешНаименования = СтрЗаменить(Строка(ХешированиеДанных.ХешСумма), " ", "");
		
		Ссылки = НайтиПоХешу(ХешНаименования, СсылкаОперация);
		Если Ссылки.СсылкаКомментарий = Неопределено Тогда
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.КомментарииСтатистики");
			ЭлементБлокировки.УстановитьЗначение("ХешНаименования", ХешНаименования);
						
			Блокировка.Заблокировать();
			
			Ссылки = НайтиПоХешу(ХешНаименования, СсылкаОперация);
			
			Если Ссылки.СсылкаКомментарий = Неопределено Тогда
				Ссылки.СсылкаКомментарий = Новый УникальныйИдентификатор();
				
				НаборЗаписей = СоздатьНаборЗаписей();
				НаборЗаписей.ОбменДанными.Загрузка = Истина;
				НовЗапись = НаборЗаписей.Добавить();
				НовЗапись.ХешНаименования = ХешНаименования;
				НовЗапись.ИдентификаторКомментария = Ссылки.СсылкаКомментарий;
				НовЗапись.Наименование = СлишкомМногоКомментариев;
				НаборЗаписей.Записать(Ложь);
			КонецЕсли;
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат Ссылки.СсылкаКомментарий;
КонецФункции

Функция НайтиПоХешу(Хеш, СсылкаОперация)
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	КомментарииСтатистики.ИдентификаторКомментария КАК ИдентификаторКомментария,
	|	ISNULL(КомментарииОперацииСтатистики.ИдентификаторКомментария, Неопределено) КАК ИдентификаторКомментарияОперации
	|ИЗ
	|	РегистрСведений.КомментарииСтатистики КАК КомментарииСтатистики
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрСведений.КомментарииОперацииСтатистики КАК КомментарииОперацииСтатистики
	|ПО
	|	КомментарииОперацииСтатистики.ИдентификаторОперации = &ИдентификаторОперации
	|	И КомментарииОперацииСтатистики.ИдентификаторКомментария = КомментарииСтатистики.ИдентификаторКомментария
	|ГДЕ
	|	КомментарииСтатистики.ХешНаименования = &ХешНаименования
	|";
	Запрос.УстановитьПараметр("ХешНаименования", Хеш);
	Запрос.УстановитьПараметр("ИдентификаторОперации", СсылкаОперация);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Ссылки = Новый Структура;
		Ссылки.Вставить("СсылкаКомментарий", Неопределено);
		Ссылки.Вставить("СсылкаКомментарийОперации", Неопределено);
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		Ссылки = Новый Структура;
		Ссылки.Вставить("СсылкаКомментарий", Выборка.ИдентификаторКомментария);
		Ссылки.Вставить("СсылкаКомментарийОперации", Выборка.ИдентификаторКомментарияОперации);
	КонецЕсли;
	
	Возврат Ссылки;
КонецФункции

Функция СоздатьНовый(Наименование, ХешНаименования, ОперацияСсылка)
	НачатьТранзакцию();
	
	Попытка
		Блокировка = Новый БлокировкаДанных;
		
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.КомментарииСтатистики");
		ЭлементБлокировки.УстановитьЗначение("ХешНаименования", ХешНаименования);
				
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ОперацииСтатистики");
		ЭлементБлокировки.УстановитьЗначение("ИдентификаторОперации", ОперацияСсылка);
				
		Блокировка.Заблокировать();
		
		Ссылки = НайтиПоХешу(ХешНаименования, ОперацияСсылка);
		
		Если Ссылки.СсылкаКомментарий = Неопределено Тогда
			Ссылка = Новый УникальныйИдентификатор();
			
			НаборЗаписей = СоздатьНаборЗаписей();
			НаборЗаписей.ОбменДанными.Загрузка = Истина;
			НовЗапись = НаборЗаписей.Добавить();
			НовЗапись.ХешНаименования = ХешНаименования;
			НовЗапись.ИдентификаторКомментария = Ссылка;
			НовЗапись.Наименование = Наименование;
			НаборЗаписей.Записать(Ложь);
			
			РегистрыСведений.ОперацииСтатистики.УвеличитьКоличествоУникальныхКомментариев(ОперацияСсылка, Ссылка);
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат Ссылка;
КонецФункции

#КонецОбласти

#КонецЕсли
