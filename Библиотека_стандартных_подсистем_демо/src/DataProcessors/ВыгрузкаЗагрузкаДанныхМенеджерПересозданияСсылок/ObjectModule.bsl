///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ТекущийКонтейнер;
Перем ТекущийПотокЗаменыСсылок;

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура Инициализировать(Контейнер, ПотокЗаменыСсылок) Экспорт
	
	ТекущийКонтейнер = Контейнер;
	ТекущийПотокЗаменыСсылок = ПотокЗаменыСсылок;
	
КонецПроцедуры

Процедура ВыполнитьПересозданиеСсылок() Экспорт
	
	ФайлыПересоздаваемыхСсылок = ТекущийКонтейнер.ПолучитьФайлыИзКаталога(ВыгрузкаЗагрузкаДанныхСлужебный.ReferenceRebuilding());
	Для Каждого ФайлПересоздаваемыхСсылок Из ФайлыПересоздаваемыхСсылок Цикл
		
		ИсходныеСсылки = ТекущийКонтейнер.ПрочитатьОбъектИзФайла(ФайлПересоздаваемыхСсылок); // Массив Из ЛюбаяСсылка
		
		Для Каждого ИсходнаяСсылка Из ИсходныеСсылки Цикл
			
			ИмяТипаXML = ВыгрузкаЗагрузкаДанныхСлужебный.XMLТипСсылки(ИсходнаяСсылка);
			ПолноеИмяОбъекта = ИсходнаяСсылка.Метаданные().ПолноеИмя(); 
			НоваяСсылка = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмяОбъекта).ПолучитьСсылку();
			
			ТекущийПотокЗаменыСсылок.ЗаменитьСсылку(ИмяТипаXML, Строка(ИсходнаяСсылка.УникальныйИдентификатор()), Строка(НоваяСсылка.УникальныйИдентификатор()));

			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли