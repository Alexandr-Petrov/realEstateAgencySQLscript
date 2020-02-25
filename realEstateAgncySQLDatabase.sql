create table Посредник
(ID_посредника		 number(15),
Тип_Орг	               number(1) not null,
Название		varchar(30) not null,
Сегмент        	tinyint not null,
Наличие	               number(1) not null,
Рейтинг	               number(10) not null,
Дата_рег	               date not null,
Кол_спец		smallint not null,
Телефон		 number(15) not null,
constraint ID_посредника	primary key (ID_посредника))
go;
create table Арендодатель
(ID_Арендодателя				 number(15),
Тип_Арендодателя				bit not null,
ФИО								varchar(80) not null,
Тип_арен_ра	bit null,
Вред_привычки 	bit null,
Телефон							 number(15) not null,
constraint ID_Арендодателя		primary key (ID_Арендодателя))

create table Арендатор
(ID_Арендатора				 number(15),
Тип_Арендатора				bit not null,
ФИО							varchar(80) not null,
Возраст						tinyint not null,
Вред_привычки	bit not null,
Кол-прожив		tinyint not null,
Тип_аренды	tinyint not null,
Время_аренд 	tinyint  null,
Предпочитаемая_сумма_аренды	money null,
Телефон						 number(15) not null,
constraint ID_Арендатора	primary key (ID_Арендатора))

create table Договор_об_услугах_арендодатель
(Номер_договора_a						 number(15),
ID_посредника							 number(15) not null,
ID_клиента1								 number(15) not null,
ФИО_клиента								varchar(80) null,
Начало_дог			date not null,
Конец_дог		date not null,
Оплаченная_сумма						money not null,
Назв_посредник	varchar(30) null,
constraint Номер_договора_a	primary key (Номер_договора_a),
foreign key (ID_клиента1) references Арендодатель(ID_Арендодателя))

create table Договор_об_услугах_арендатор
(Номер_договора_b						 number(15),
ID_посредника							 number(15) not null,
ID_клиента2								 number(15) not null,
ФИО_клиента								varchar(80) null,
Начало_дог			date not null,
Конец_дог		date not null,
Оплаченная_сумма						money not null,
Назв_посредник	varchar(30) null,
constraint Номер_договора_b	primary key (Номер_договора_b),
foreign key (ID_клиента2) references Арендатор(ID_Арендатора))

create table Объявление_об_аренде
(Номер_объявления			 number(15),
Название_организации		varchar(80) null,
ID_посредника				 number(15) not null,
Тип_аренды 					tinyint null,
Сумма						money null,
Тип_дома					tinyint null,
Адрес						varchar(70) null,
Район						tinyint null,
Кем_размещено				tinyint null,
Этаж						tinyint null,
Площадь						tinyint null,
Количество_комнат			tinyint null,
Состояние					tinyint null,
Санузел						bit null,
Балкон						bit null,
Дверь						bit null,
Телефон						bit null,
Интернет					bit null,
Мебель						bit null,
Пол							bit null,
Дата_создания	date null,
Контактный_телефон			 number(15) null,
constraint Номер_объявления	primary key (Номер_объявления),
foreign key (ID_посредника) references Посредник(ID_посредника))

create table Договор_об_аренде
(Номер_договора_c					 number(15),
ID_Посредника						 number(15) null,
Назв_посредник	varchar(30) null,
ID_Арендатора						 number(15) not null,
ФИО_Арендатора						varchar(30) null,
ID_Арендодателя						 number(15) not null,
ФИО_Арендодателя					varchar(30) null,
Адрес_Квартиры						varchar(150) null,
Состояние_квартиры					tinyint not null,
Тип_аренды							tinyint not null,
Сумма								money not null,
constraint Номер_договора_c	primary key (Номер_договора_c),
foreign key (ID_Арендатора) references Арендатор(ID_Арендатора),
foreign key (ID_Посредника) references Посредник(ID_Посредника),
foreign key (ID_Арендодателя) references Арендодатель(ID_Арендодателя))
go
create trigger trgin
on Объявление_об_аренде
for insert
as
begin
declare @up number(10), @d number(10),@total number(15)
set @d = 0
SELECT @total = COUNT(ID_Посредника) FROM inserted
declare cur cursor scroll for select	ID_Посредника	from inserted
open cur
while @d!=@total
begin
set @d=@d+1
fetch next from cur number(10)o @up
update Объявление_об_аренде set Название_организации=(select Название From Посредник 
where @up=Посредник.ID_посредника),
Контактный_телефон=(select Телефон  From Посредник where @up=Посредник.ID_посредника) 
where @up=ID_посредника
end
close cur
end
go
create trigger trgin1
on Договор_об_услугах_арендатор
for insert
as
begin
declare @up number(15),@pu number(15), @d number(10),@total number(15)
set @d = 0
SELECT @total = COUNT(ID_клиента2) FROM inserted
declare cur cursor scroll for select ID_клиента2,ID_посредника	from inserted
open cur
while @d!=@total
begin
set @d=@d+1
fetch next from cur number(10)o @up,@pu
update Договор_об_услугах_арендатор 
set ФИО_клиента=(select ФИО From Арендатор where @up=Арендатор.ID_Арендатора),
Назв_посредник=(select Название From Посредник where @pu=Посредник.ID_посредника) 
where @up=ID_клиента2 and @pu=ID_посредника
end
close cur
end
go
create trigger trgin2
on Договор_об_услугах_арендодатель
for insert
as
begin
declare @up number(15),@pu number(15), @d number(10),@total number(15)
set @d = 0
SELECT @total = COUNT(ID_клиента1) FROM inserted
declare cur cursor scroll for select ID_клиента1,ID_посредника	from inserted
open cur
while @d!=@total
begin
set @d=@d+1
fetch next from cur number(10)o @up,@pu
update Договор_об_услугах_арендодатель
set ФИО_клиента=(select ФИО From Арендодатель where @up=Арендодатель.ID_Арендодателя),
Назв_посредник=(select Название From Посредник where @pu=Посредник.ID_посредника) 
where @up=ID_клиента1 and @pu=ID_посредника
end
close cur
end
go
create trigger trgin3
on Договор_об_аренде
for insert
as
begin
declare @up number(10),@pu number(10),@upr number(10), @d number(10),@total number(15)
set @d = 0
SELECT @total = COUNT(ID_Посредника) FROM inserted
declare cur cursor scroll for select	ID_посредника,ID_Арендатора,ID_Арендодателя	from inserted
open cur
while @d!=@total
begin
set @d=@d+1
fetch next from cur number(10)o @up,@pu,@upr
update Договор_об_аренде set Назв_посредник=
(select Название From Посредник where @up=Посредник.ID_посредника),
ФИО_Арендатора=(select ФИО From Арендодатель where @pu=Арендодатель.ID_Арендодателя),
ФИО_Арендодателя=(select ФИО From Арендатор where @upr=Арендатор.ID_Арендатора) 
where @up=ID_посредника and @pu=ID_Арендодателя and @upr=ID_Арендатора
end
close cur
end
go
insert number(10)o Посредник(Тип_Орг,Название,Сегмент_работы,Наличие_штрафов,
Рейтинг_Посредника,Дата_рег,Кол_спец,Телефон)
values
(1,'Home Finder',1,1,1,'20111111',1,870545435),
(1,'IP adilbek',1,1,1,'20111111',1,870545435),
(1,'Kazakhstan elite estate',1,1,1,'20111111',1,877777735),
(1,'Baiterek',1,1,1,'20111111',1,870545435)
insert number(10)o Арендатор(Тип_Арендатора,ФИО,Возраст,Вред_привычки,
Кол-прожив,Тип_аренды,Время_аренд,
Предпочитаемая_сумма_аренды,Телефон)
values
(1,'Jerom Levinski',1,1,1,1,1,100000,870545435),
(1,'Monika Levinnski',1,1,1,1,1,100000,870545435),
(1,'Steven King',1,1,1,1,1,100000,877777735),
(1,'Alex Mercer',1,1,1,1,1,100000,870545435)
insert number(10)o Арендодатель(Тип_Арендодателя,
ФИО,Тип_арен_ра,
Вред_привычки ,Телефон)
values
(1,'Sergey Malov',1,1,1),
(1,'Ulric kjolbar',1,1,1),
(1,'TOO JEROM',1,1,1),
(1,'IP EVGENII',1,1,1)
insert number(10)o Объявление_об_аренде(ID_посредника)
values
(1),
(3)
insert number(10)o Объявление_об_аренде(ID_посредника)
values
(1),
(4)
insert number(10)o Договор_об_услугах_арендодатель
(ID_клиента1,ID_посредника,Начало_дог,Дата_окончани_действия_договора,Оплаченная_сумма)
values
(1,3,'20111111','20111212',25000)
insert number(10)o Договор_об_услугах_арендатор
(ID_клиента2,ID_посредника,Начало_дог,Дата_окончани_действия_договора,Оплаченная_сумма)
values
(3,1,'20111111','20111212',15000)
insert number(10)o Договор_об_аренде(ID_Посредника,ID_Арендатора,
ID_Арендодателя,Адрес_Квартиры,Состояние_квартиры,Тип_аренды,Сумма)
values
(1,1,1,'Mukanova 127 kv 45',1,1,100000)
select * from Объявление_об_аренде
select * from Арендатор
select * from Посредник
select * from Договор_об_услугах_арендатор
select * from Договор_об_услугах_арендодатель
select * from Договор_об_аренде