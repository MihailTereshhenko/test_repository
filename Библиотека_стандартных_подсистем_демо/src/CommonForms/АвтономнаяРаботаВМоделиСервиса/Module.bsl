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
	
	// Создавать и отключать автономные рабочие места может только администратор абонента.
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		
		ВызватьИсключение НСтр("ru = 'Недостаточно прав для настройки автономной работы.'");
		
	ИначеЕсли Не АвтономнаяРаботаСлужебный.АвтономнаяРаботаПоддерживается() Тогда
		
		ВызватьИсключение НСтр("ru = 'Возможность автономной работы в программе не предусмотрена.'");
		
	КонецЕсли;
	
	ОбновитьМониторАвтономнойРаботыНаСервере();
	
	ПоддерживаетсяПередачаБольшихФайлов = АвтономнаяРаботаСлужебный.ПоддерживаетсяПередачаБольшихФайлов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ОбновитьМониторАвтономнойРаботы", 60);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если    ИмяСобытия = "Создание_АвтономноеРабочееМесто"
		ИЛИ ИмяСобытия = "Запись_АвтономноеРабочееМесто"
		ИЛИ ИмяСобытия = "Удаление_АвтономноеРабочееМесто" Тогда
		
		ОбновитьМониторАвтономнойРаботы();
		
	ИначеЕсли ИмяСобытия = "ЗакрытаФормаРезультатовОбменаДанными" Тогда
		
		ОбновитьЗаголовокПереходаККонфликтам();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьАвтономноеРабочееМесто(Команда)
	
	Оповещение = Новый ОписаниеОповещения("СоздатьАвтономноеРабочееМестоЗавершение", ЭтотОбъект);
	
	Если ПоддерживаетсяПередачаБольшихФайлов Тогда
		ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(Оповещение, "", Ложь);
	Иначе
		ВыполнитьОбработкуОповещения(Оповещение, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрекратитьСинхронизациюСАвтономнымРабочимМестом(Команда)
	
	ОтключитьАвтономноеРабочееМесто(АвтономноеРабочееМесто);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрекратитьСинхронизациюСАвтономнымРабочимМестомВСписке(Команда)
	
	ТекущиеДанные = Элементы.СписокАвтономныхРабочихМест.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		ОтключитьАвтономноеРабочееМесто(ТекущиеДанные.АвтономноеРабочееМесто);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьАвтономноеРабочееМесто(Команда)
	
	Если АвтономноеРабочееМесто <> Неопределено Тогда
		
		ПоказатьЗначение(, АвтономноеРабочееМесто);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьАвтономноеРабочееМестоВСписке(Команда)
	
	ТекущиеДанные = Элементы.СписокАвтономныхРабочихМест.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		ПоказатьЗначение(, ТекущиеДанные.АвтономноеРабочееМесто);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьМониторАвтономнойРаботы();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокАвтономныхРабочихМестВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьЗначение(, Элементы.СписокАвтономныхРабочихМест.ТекущиеДанные.АвтономноеРабочееМесто);
	
КонецПроцедуры

&НаКлиенте
Процедура КакУстановитьИлиОбновитьВерсиюПлатформы1СПредприятие(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИмяМакета", "КакУстановитьИлиОбновитьВерсиюПлатформы1СПредприятие");
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Как установить или обновить версию платформы 1С:Предприятие'"));
	
	ОткрытьФорму("Обработка.ПомощникСозданияАвтономногоРабочегоМеста.Форма.ДополнительноеОписание", ПараметрыФормы, ЭтотОбъект, "КакУстановитьИлиОбновитьВерсиюПлатформы1СПредприятие");
	
КонецПроцедуры

&НаКлиенте
Процедура КакНастроитьАвтономноеРабочееМесто(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИмяМакета", "ИнструкцияПоНастройкеАРМ");
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Как настроить автономное рабочее место'"));
	
	ОткрытьФорму("Обработка.ПомощникСозданияАвтономногоРабочегоМеста.Форма.ДополнительноеОписание", ПараметрыФормы, ЭтотОбъект, "ИнструкцияПоНастройкеАРМ");
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиККонфликтам(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("УзлыОбмена", МассивИспользуемыхУзлов(АвтономноеРабочееМесто, СписокАвтономныхРабочихМест));
	
	ОткрытьФорму("РегистрСведений.РезультатыОбменаДанными.Форма.Форма", ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура СоставОтправляемыхДанных(Команда)
	
	ТекущаяСтраница = Элементы.АвтономнаяРабота.ТекущаяСтраница;
	АвтономныйУзел  = Неопределено;
	
	Если ТекущаяСтраница = Элементы.ОдноАвтономноеРабочееМесто Тогда
		АвтономныйУзел = АвтономноеРабочееМесто;
		
	ИначеЕсли ТекущаяСтраница = Элементы.НесколькоАвтономныхРабочихМест Тогда
		ТекущиеДанные = Элементы.СписокАвтономныхРабочихМест.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			АвтономныйУзел = ТекущиеДанные.АвтономноеРабочееМесто;
		КонецЕсли;
		
	КонецЕсли;
		
	Если ЗначениеЗаполнено(АвтономныйУзел) Тогда
		ОбменДаннымиКлиент.ОткрытьСоставОтправляемыхДанных(АвтономныйУзел);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СоздатьАвтономноеРабочееМестоЗавершение(РасширениеПодключено, ДополнительныеПараметры) Экспорт
	
	Если РасширениеПодключено Тогда
		ОткрытьФорму("Обработка.ПомощникСозданияАвтономногоРабочегоМеста.Форма.НастройкаНаСторонеСервиса", , ЭтотОбъект, "1");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьМониторАвтономнойРаботыНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	КоличествоАвтономныхРабочихМест = АвтономнаяРаботаСлужебный.КоличествоАвтономныхРабочихМест();
	ОбновитьЗаголовокПереходаККонфликтам();
	
	Если КоличествоАвтономныхРабочихМест = 0 Тогда
		
		Элементы.АвтономнаяРаботаНеНастроена.Видимость = Истина;
		
		Элементы.АвтономнаяРабота.ТекущаяСтраница = Элементы.АвтономнаяРаботаНеНастроена;
		Элементы.ОдноАвтономноеРабочееМесто.Видимость = Ложь;
		Элементы.НесколькоАвтономныхРабочихМест.Видимость = Ложь;
		
	ИначеЕсли КоличествоАвтономныхРабочихМест = 1 Тогда
		
		Элементы.ОдноАвтономноеРабочееМесто.Видимость = Истина;
		
		Элементы.АвтономнаяРабота.ТекущаяСтраница = Элементы.ОдноАвтономноеРабочееМесто;
		Элементы.АвтономнаяРаботаНеНастроена.Видимость = Ложь;
		Элементы.НесколькоАвтономныхРабочихМест.Видимость = Ложь;
		
		АвтономноеРабочееМесто = АвтономнаяРаботаСлужебный.АвтономноеРабочееМесто();
		СписокАвтономныхРабочихМест.Очистить();
		
		Элементы.ИнформацияОПоследнейСинхронизации.Заголовок = ОбменДаннымиСервер.ПредставлениеДатыСинхронизации(
			АвтономнаяРаботаСлужебный.ДатаПоследнейУспешнойСинхронизации(АвтономноеРабочееМесто)) + ".";
		
		Элементы.ОписаниеОграниченийПередачиДанных.Заголовок = АвтономнаяРаботаСлужебный.ОписаниеОграниченийПередачиДанных(АвтономноеРабочееМесто);
		
	ИначеЕсли КоличествоАвтономныхРабочихМест > 1 Тогда
		
		Элементы.НесколькоАвтономныхРабочихМест.Видимость = Истина;
		
		Элементы.АвтономнаяРабота.ТекущаяСтраница = Элементы.НесколькоАвтономныхРабочихМест;
		Элементы.АвтономнаяРаботаНеНастроена.Видимость = Ложь;
		Элементы.ОдноАвтономноеРабочееМесто.Видимость = Ложь;
		
		АвтономноеРабочееМесто = Неопределено;
		СписокАвтономныхРабочихМест.Загрузить(АвтономнаяРаботаСлужебный.МониторАвтономныхРабочихМест());
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовокПереходаККонфликтам()
	
	Если ОбменДаннымиПовтИсп.ИспользуетсяВерсионирование() Тогда
		
		СтруктураЗаголовка = ОбменДаннымиСервер.СтруктураЗаголовкаГиперссылкиМонитораПроблем(
			МассивИспользуемыхУзлов(АвтономноеРабочееМесто, СписокАвтономныхРабочихМест));
		
		ЗаполнитьЗначенияСвойств (Элементы.ПерейтиККонфликтам, СтруктураЗаголовка);
		ЗаполнитьЗначенияСвойств (Элементы.ПерейтиККонфликтам1, СтруктураЗаголовка);
		
	Иначе
		
		Элементы.ПерейтиККонфликтам.Видимость = Ложь;
		Элементы.ПерейтиККонфликтам1.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьТекущийИндексСтроки()
	
	// возвращаемое значение функции
	ИндексСтроки = Неопределено;
	
	// при обновлении монитора выполняем позиционирование курсора
	ТекущиеДанные = Элементы.СписокАвтономныхРабочихМест.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		ИндексСтроки = СписокАвтономныхРабочихМест.Индекс(ТекущиеДанные);
		
	КонецЕсли;
	
	Возврат ИндексСтроки;
КонецФункции

&НаКлиенте
Процедура ВыполнитьПозиционированиеКурсора(ИндексСтроки)
	
	Если ИндексСтроки <> Неопределено Тогда
		
		// выполняем проверки позиционирования курсора после получения новых данных
		Если СписокАвтономныхРабочихМест.Количество() <> 0 Тогда
			
			Если ИндексСтроки > СписокАвтономныхРабочихМест.Количество() - 1 Тогда
				
				ИндексСтроки = СписокАвтономныхРабочихМест.Количество() - 1;
				
			КонецЕсли;
			
			// позиционируем курсор
			Элементы.СписокАвтономныхРабочихМест.ТекущаяСтрока = СписокАвтономныхРабочихМест[ИндексСтроки].ПолучитьИдентификатор();
			
		КонецЕсли;
		
	КонецЕсли;
	
	// если спозиционировать строку не удалось, то устанавливаем текущей первую строку
	Если Элементы.СписокАвтономныхРабочихМест.ТекущаяСтрока = Неопределено
		И СписокАвтономныхРабочихМест.Количество() <> 0 Тогда
		
		Элементы.СписокАвтономныхРабочихМест.ТекущаяСтрока = СписокАвтономныхРабочихМест[0].ПолучитьИдентификатор();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьМониторАвтономнойРаботы()
	
	ИндексСтроки = ПолучитьТекущийИндексСтроки();
	
	ОбновитьМониторАвтономнойРаботыНаСервере();
	
	// выполняем позиционирование курсора
	ВыполнитьПозиционированиеКурсора(ИндексСтроки);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция МассивИспользуемыхУзлов(АвтономноеРабочееМесто, СписокАвтономныхРабочихМест)
	
	УзлыОбмена = Новый Массив;
	
	Если ЗначениеЗаполнено(АвтономноеРабочееМесто) Тогда
		УзлыОбмена.Добавить(АвтономноеРабочееМесто);
	Иначе
		Для Каждого СтрокаУзла Из СписокАвтономныхРабочихМест Цикл
			УзлыОбмена.Добавить(СтрокаУзла.АвтономноеРабочееМесто);
		КонецЦикла;
	КонецЕсли;
	
	Возврат УзлыОбмена;
	
КонецФункции

&НаКлиенте
Процедура ОтключитьАвтономноеРабочееМесто(ОтключаемоеАвтономноеРабочееМесто)
	
	ПараметрыФормы = Новый Структура("АвтономноеРабочееМесто", ОтключаемоеАвтономноеРабочееМесто);
	
	ОткрытьФорму("ОбщаяФорма.ОтключениеАвтономногоРабочегоМеста", ПараметрыФормы, ЭтотОбъект, ОтключаемоеАвтономноеРабочееМесто);
	
КонецПроцедуры

#КонецОбласти
