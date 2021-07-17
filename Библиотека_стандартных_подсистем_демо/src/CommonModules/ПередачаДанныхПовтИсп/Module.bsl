///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Функция МенеджерыЛогическихХранилищ() Экспорт
	
	ВсеМенеджерыЛогическихХранилищ = Новый Соответствие;
	
	ПередачаДанныхВстраивание.МенеджерыЛогическихХранилищ(ВсеМенеджерыЛогическихХранилищ);
	ПередачаДанныхПереопределяемый.МенеджерыЛогическихХранилищ(ВсеМенеджерыЛогическихХранилищ);
	
	Возврат Новый ФиксированноеСоответствие(ВсеМенеджерыЛогическихХранилищ);
	
КонецФункции

Функция МенеджерыФизическихХранилищ() Экспорт
	
	ВсеМенеджерыФизическихХранилищ = Новый Соответствие;
	
	ПередачаДанныхВстраивание.МенеджерыФизическихХранилищ(ВсеМенеджерыФизическихХранилищ);
	ПередачаДанныхПереопределяемый.МенеджерыФизическихХранилищ(ВсеМенеджерыФизическихХранилищ);
	
	Возврат Новый ФиксированноеСоответствие(ВсеМенеджерыФизическихХранилищ);
	
КонецФункции

#КонецОбласти