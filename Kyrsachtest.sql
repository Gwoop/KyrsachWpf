SELECT *
FROM pg_settings
WHERE name = 'port';



create table Post
(
	ID_Post SERIAL not null constraint PK_Post primary key,
	Name_Post varchar (30) not null default ('not state')
);

insert into Post(Name_Post)
values ('Продавец');

create or replace procedure Post_Insert (p_Name_Post varchar(30))
language plpgsql
as $$ 
 DECLARE have_record int := count(*) from Post where Name_Post = p_Name_Post;
	begin
	if have_record > 0 then
			raise exception 'Данная Должность уже есть. Ошибка имён';
	else
insert into Roles(Name_Post)
values (p_Name_Post);
	end if;
	end;
$$;


create table Marks
(
	ID_Marks SERIAL not null constraint PK_Marks primary key,
	Name_Marks varchar (30) not null UNIQUE
);


select * from Marks;


insert into Marks(Name_Marks)
values ('BMW'),('Mersedes'),('KIA');

create table Configurat
(
	ID_Configurat SERIAL not null constraint PK_Configurat primary key,
	Name_Configurat varchar (30) not null,
	Price decimal (38,1) null check (Price > 0.0) default (0.1) 
);

select * from Configurat;
insert into Configurat(Name_Configurat,Price)
values ('Compitision',12000000.0);

create table Model
(
	ID_Model SERIAL not null constraint PK_Model primary key,
	Name_Model varchar (30) not null,
	Image varchar (1000)  null,
	Marks_ID int not null references Marks (ID_Marks),
	Configurat_ID int null references Configurat (ID_Configurat)
);

insert into Model(Name_Model,Image,Marks_ID,Configurat_ID)
values ('M4','1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111100000000000111111111111111111111111111111000001001111111111111111011111111111111110001000110000111111110000000111111111111111000111111111110000000011111111111111111111111111111111111101111111111111111111101111111111111111110010000110000111100011111111111110011000001000011111111100001111111111111001000011101001111111100000011111111111000011111100000000111110000001111111110100011111110000000001111000000100000000000001111111110000000000000000000000000000001111111110000000000000000000000011111111111111111100000000000000011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111',1,1);


create or replace view fullcars ("id","Модель","Изображение", "Марка", "Кофигурация")
as
select
ID_Model,Name_Model,Image, Name_Marks, Name_Configurat

from Model
inner join Marks on ID_Marks = Marks_ID
inner join Configurat on ID_Configurat = Configurat_ID;


select * from fullcars;

select * from Model;


create table Gears
(
	ID_Gears SERIAL not null constraint PK_Gears primary key,
	Name_Gears varchar (30) not null,
	Price decimal (38,1) null check (Price > 0.0) default (0.1),
	Model_ID int not null references Model (ID_Model)
);



create table Roles
(
	ID_Roles SERIAL not null constraint PK_Roles primary key,
	NameR varchar (30) not null
);

create or replace procedure Roles_Insert (p_NameR varchar(30))
language plpgsql
as $$ 
 DECLARE have_record int := count(*) from Roles where NameR = p_NameR;
	begin
	if have_record > 0 then
			raise exception 'Данная роль уже есть. Ошибка имён';
	else
insert into Roles(NameR)
values (p_NameR);
	end if;
	end;
$$;

insert into Roles(NameR)
values ('Admin'),('User'),('Emp');



create table Users
(
	ID_Users SERIAL not null constraint PK_User primary key,
	Login varchar (30) not null UNIQUE,
	Passwor varchar (30) not null,
	Roles_ID int not null references Roles (ID_Roles)
);
select * from Users;
insert into Users(Login,Passwor,Roles_ID)
values ('Gwoop','1234',2),('Emp','1234',3),('admin','1234',1);




create table Cont_info
(
	ID_Cont_info SERIAL not null constraint PK_Cont_info primary key,
	Title varchar (30) null,
	Adress varchar (30) null,
	Numbe varchar (30) null ,
	Desribe varchar (30) null
);

create table Employee
(
	ID_Employee SERIAL not null constraint PK_Employee primary key,
	first_Name varchar (30) not null,
	Name_Employee varchar (30) not null,
	Middle_Name varchar (30) null default('-'),
	Date_Bithdais varchar(10) not null constraint Ch_Date_Bithdais
	check(Date_Bithdais similar to '[0-9][0-9].[0-9][0-9].[0-9][0-9][0-9][0-9]' ),
	Employee_Number varchar (19) not null constraint Ch_Employee_Number
	check(Employee_Number similar to '\+7\([0-9][0-9][0-9]\)[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]' ),
	Employee_Email varchar null constraint CH_Employee_Email check (Employee_Email similar to '%@%') default ('@'),
	Post_ID int not null references Post (ID_Post),
	Users_ID int not null references Users (ID_Users),
	Active bool default true
);

select * from Employee;

insert into Employee(first_Name,Name_Employee,Middle_Name,Date_Bithdais,Employee_Number,Employee_Email,Post_ID,Users_ID)
values ('Сальников','Александр','Борисович','06.03.2003','+7(985)348-40-10','gwooparap@gmail.com',1,2);


create table Soiscatel
(
	ID_Soiscatel SERIAL not null constraint PK_Soiscatel primary key,
	first_Name varchar (30) not null,
	Name_s varchar (30) not null,
	Middle_Name_s varchar (30) null default('-'),
	Post varchar (30) not null,
	Confirm bool null,
	Roles_ID int not null references Roles (ID_Roles),
	User_ID int not null references Employee (ID_Employee)
);

create table Client
(
	ID_Client SERIAL not null constraint PK_Client primary key,
	first_Name_c varchar (30) not null,
	Name_c varchar (30) not null,
	Middle_Name_c varchar (30) null default('-'),
	Date_Bithdais varchar(10) not null constraint Ch_Date_Bithdais
	check(Date_Bithdais similar to '[0-9][0-9].[0-9][0-9].[0-9][0-9][0-9][0-9]' ),
	Client_Number varchar (19) not null constraint Ch_Client_Number
	check(Client_Number similar to '\+7\([0-9][0-9][0-9]\)[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]' ),
	Client_Email varchar null constraint CH_Client_Email check (Client_Email similar to '%@%') default ('@'),
	User_ID int null references Users (ID_Users),
	Active bool not null default true
);

select * from Client;

insert into Client(first_Name_c,Name_c,Middle_Name_c,Date_Bithdais,Client_Number,Client_Email,User_ID)
values ('Сальников','Александр','Борисович','06.03.2003','+7(985)348-40-10','gwooparap@gmail.com',1);

create table Cheak
(
	ID_Cheak SERIAL not null constraint PK_Cheak primary key,
	Numbers SERIAL not null UNIQUE,
	Dates varchar(10) not null constraint Ch_Dates
	check(Dates similar to '[0-3][0-9].[0-1][1-9].[0-9][0-9][0-9][0-9]' ),
	Employee_ID int null references Employee (ID_Employee),
	Client_ID int not null references Client (ID_Client),
	Model_ID int not null references Model (ID_Model),
	Active_Ch bool null
);

select * from Cheak;

select * from Client;

insert into Cheak(Dates,Client_ID,Model_ID,Employee_ID)
values ('05.12.2022',1,1,1);



create or replace view fullCheak ("id","Номер","Дата", "Сотрудник", "Клиент","Покупка","Цена","Подтверждения")
as
select
ID_Cheak,Numbers,
Dates,
first_Name||' '||substring(Name_Employee from 1 for 1)||'.'|| substring(Middle_Name from 1 for 1)||'.',
first_Name_c||' '||substring(Name_c from 1 for 1)||'.'|| substring(Middle_Name_c from 1 for 1)||'.',
Name_Model||' '|| Name_Configurat,
Price,
Active_Ch

from Cheak
inner join Employee on ID_Employee = Employee_ID
inner join Client on ID_Client = Client_ID
inner join Model on ID_Model = Model_ID
inner join Configurat on ID_Configurat = Configurat_ID;


select * from fullCheak;













create or replace procedure Employee_Delete (p_ID_Employee int)
language plpgsql -- определение диалекта, где sql - база, plpgsql - алгоритмические команды + база 
as $$ -- начало тела области языка 
 DECLARE have_record int := count(*) from combination where  = p_ID_Employee;
	begin
	if have_record > 0 then 
	raise exception 'Данного сотрудника удалить нельзя';
	else
	delete from employee
	where 
	id_employee = p_ID_Employee;
	end if;
	end;
$$;

call Employee_Delete(3)

select * from Employee
select * from Combination

create or replace procedure Employee_Insert (p_first_Name varchar(30), p_nameEmployee varchar(30), p_Middle_Name varchar(30), p_Employee_Number varchar(19), p_Employee_Email varchar)
language plpgsql -- определение диалекта, где sql - база, plpgsql - алгоритмические команды + база 
as $$ -- начало тела области языка 
 DECLARE have_record int := count(*) from Employee where first_name = p_first_Name and name_employee = p_Name_Employee and middle_name = p_Middle_Name and employee_number = p_Employee_Number and employee_email = p_Employee_Email;
	begin
	if have_record > 0 then
			raise exception 'Сотрудник с указанными: Фамилией, Именем, Отчеством и телефоном, уже есть в таблице!';
	else
insert into Employee(first_name, name_employee, middle_name, employee_number, employee_email)
values (p_first_Name,p_nameEmployee,p_Middle_Name,p_Employee_Number,p_Employee_Email);
	end if;
	end;
$$; -- коне

create or replace procedure Employee_Update (p_ID_Employee int,p_Name_Employee varchar(30), p_first_Name varchar(30), p_Middle_Name varchar(30),p_Employee_Number varchar(19), p_Employee_Email varchar)
language plpgsql
as $$
 DECLARE have_record int := count(*) from Employee where first_name = p_first_Name and name_employee = p_Name_Employee and middle_name = p_Middle_Name and employee_number = p_Employee_Number and employee_email = p_Employee_Email;
	begin
	if have_record > 0 then 
	raise exception;
	else
	update Employee set  first_Name = p_first_Name,name_employee = p_Name_Employee, Middle_Name = p_Middle_Name,Employee_Number = p_Employee_Number,employee_email = p_Employee_Email
	where 
 	ID_Employee = p_ID_Employee;
	end if;
	end;
$$;

select * from employee
call Employee_Update (10,'Денис','Сальников','Андреевич','+7(999)999-99-00', 'alesha@mail.ru')

insert into Employee(first_name, Name_Employee, Middle_Name, Employee_Number, Employee_Email)
values ('Иванов','Иван','Иванович','+7(925)930-85-88', 'jpgmooder@gmail.com'),
('Алексеев','Алеша','Алешович','+7(999)999-99-00', 'alesha@mail.ru'),
('Павлов','Павел','Палыч','+7(123)456-78-90', 'palich@yahoo.com'),
('Гончар','Максим','Сергеевич','+7(968)424-69-34','ываыва@fg'),
('Миняев','Егор','Павлович','+7(456)795-23-12','екоо234@fg'),
('Подушкин','Артём','Алексаевич','+7(345)313-34-12','hgfhfg@fg'),
('Шакурова','Екатирина','Сергеевна','+7(945)594-34-87','FDFDD34@fg'),
('Парамонова','Елизавета','Максимовна','+7(985)453-87-23','ываыуfdgdf@fg'),
('Клесарев','Степан','Дмитрович','+7(834)345-12-54','fgdgf@fg'),
('Сальников','Денис','Алексеевич','+7(548)453-23-89','ыва@fg');

insert into Post(Post_Name,Post_Price)
values ('Директор','100000.0'),
('Администратор','50000.0'),
('Библиотекарь','60000.0'),
('Уборщик','20000.0'),
('Помощник Библиотекаря','30000.0'),
('Охранник','30000.0'),
('Зав. Хоз.','50000.0'),
('Почтальон','25000.0');

insert into Combination(Employee_ID,Post_ID,Post_Part)
values ('8','4','2'),
('1','8','1'),
('2','7','1'),
('3','6','2'),
('4','5','5'),
('5','3','1'),
('6','2','2'),
('7','1','3'),
('9','2','4'),
('10','4','1');


select * from Post




select * from  Employee

create table Combination 
(
	ID_Combination SERIAL not null constraint PK_Combination primary key,
	Employee_ID int not null references Employee (ID_Employee),
	Post_ID int not null references Post (ID_Post),
	--references - ссылка на значение первичного ключа родительской таблицы
	Post_Part decimal (38,1) null constraint CH_Post_Part check (Post_Part > 0.0) default (0.1) 
)

create or replace procedure Combination_Update (p_ID_Combination int, p_Employee_ID int, p_Post_ID int , p_Post_Part decimal(38,1))
language plpgsql 
as $$
 DECLARE have_record int := count(*) from Combination where Employee_ID = p_Employee_ID and Post_ID = p_Post_ID  and Post_Part = p_Post_Part;
begin 
if have_record > 0 then
raise exception 'Должность с указанными: зарплатой, названием уже есть в таблице!';
else
update Combination set  first_Name = p_first_Name, Middle_Name = p_Middle_Name,
 Employee_Number = p_Employee_Number
 where 
 ID_Combination = p_ID_Combination;
	end if;
	end;
$$;


create or replace procedure Combination_Insert (p_Employee_ID int, p_Post_ID int , p_Post_Part decimal(38,1))
language plpgsql
as $$
 DECLARE have_record int := count(*) from Combination where Employee_ID = p_Employee_ID and Post_Name = p_Post_Name and Post_ID = p_Post_ID  and Post_Part = p_Post_Part;
	begin
	if have_record > 0 then 
			raise exception 'Должность с указанными: Названием, Зарплатой уже есть в таблице!';
	else
insert into Combination(Employee_ID, Post_Name, Post_ID, Post_Part)
values (p_Employee_ID,p_Post_Name,p_Post_ID,p_Post_Part  );
	end if;
	end;
$$;


create or replace procedure Combination_Delete (p_ID_Combination int)
language plpgsql
as $$
 DECLARE have_record int := count(*) from Combination where ID_Combination = p_ID_Combination;
	begin
	if have_record > 0 then 
	raise exception 'Данную должность удалить нельзя';
	
	delete from Combination where 
	ID_Combination = p_ID_Combination;
	end if;
	end;
$$;


create table Date_Buier
(
	ID_Date_Buier SERIAL not null constraint PK_Date_Buier primary key,
	NameB varchar (20) not null,
	First_NameB varchar (20) not null,
	NumberB varchar (19) not null constraint Ch_NumberB
				check(NumberB similar to '\+7\([0-9][0-9][0-9]\)[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]' )
);

create or replace procedure Date_Buier_Delete (p_ID_Date_Buier int)
language plpgsql
as $$
 DECLARE have_record int := count(*) from Date_Buier where ID_Date_Buier = p_ID_Combination;
	begin
	if have_record > 0 then 
	raise exception 'Данную запись удалить нельзя';
	
	delete from Date_Buier where 
	ID_Date_Buier = p_ID_Combination;
	end if;
	end;
$$;


insert into Date_Buier(NameB, First_NameB, NumberB)
values ('Иванов','Иван','+7(925)930-85-88'),
('Алексеев','Алеша','+7(999)999-99-00'),
('Павлов','Павел','+7(123)456-78-90'),
('Гончар','Максим','+7(968)424-69-34'),
('Миняев','Егор','+7(456)795-23-12'),
('Подушкин','Артём','+7(345)313-34-12'),
('Шакурова','Екатирина','+7(945)594-34-87'),
('Парамонова','Елизавета','+7(985)453-87-23'),
('Клесарев','Степан','+7(834)345-12-54'),
('Сальников','Денис','+7(548)453-23-89');

select * from Post

create table Post
(
	ID_Post SERIAL not null constraint PK_Post primary key,
	Post_Name varchar (50) not null constraint UQ_Post_Name unique,
	Post_Price decimal (38,2) null constraint CH_Post_Price check (Post_Price >= 0.0) default 0.0
);

create or replace procedure Post_Update (p_ID_Post int, p_Post_Name varchar(50), p_Post_Price decimal(38,2))
language plpgsql
as $$
 DECLARE have_record int := count(*) from Post where Post_Name = p_Post_Name and Post_Price = p_Post_Price;
	begin
	if have_record > 0 then
	raise exception'Должность с указанными: зарплатой, названием уже есть в таблице!';
	else
	update Post set  Post_Name = p_Post_Name, Post_Price = p_Post_Price
	where 
	ID_Post = p_ID_Post;
	end if; 
	end;
$$;

create or replace procedure Post_Insert (p_Post_Name varchar(50), p_Post_Price decimal(38,2))
language plpgsql
as $$
 DECLARE have_record int := count(*) from Employee where first_Name = p_first_Name and Name_Employee = p_Name_Employee and Middle_Name = p_Middle_Name and Employee_Number = p_Employee_Number and Employee_Email = p_Employee_Email;
	begin
	if have_record > 0 then 
			raise exception 'Должность с указанными: Названием, Зарплатой уже есть в таблице!';
	else
insert into Post(Post_Name, Post_Price)
values (p_Post_Name,p_Post_Price);
	end if;
	end;
$$;

create or replace procedure Post_Delete (p_ID_Post int)
language plpgsql
as $$
 DECLARE have_record int := count(*) from Combination where post_id = p_ID_Post;
	begin
	if have_record > 0 then 
	raise exception 'Данную должность удалить нельзя';
	else
	delete from Post
	where 
	ID_Post = p_ID_Post;
	end if;
	end;
$$;

drop PROCEDURE   Post_Delete

select * from post
call Post_Delete ('1')
call Post_Insert ('Директор',100000)
call Post_Update (1,'Директор',100000)


create table Date_book
(
	ID_Date_book SERIAL not null constraint PK_Date_book primary key,
	Name_book varchar (30) not null,
	Autor varchar (20) not null,
	Izdatelstvo varchar (50) null default('-'),
	Years int not null constraint Ch_Employee_Number
	check(Years <= 2021)
)

create or replace procedure Date_book_Delete (p_ID_Date_book int)
language plpgsql
as $$
 DECLARE have_record int := count(*) from libraly_ticets where date_book_id = p_ID_Date_book;
	begin
	if have_record > 0 then 
	raise exception 'Данную запись удалить нельзя';
	else
	delete from Date_book
	where 
	Date_book = p_ID_Date_book;
	end if;
	end;
$$;

select * from Date_book
insert into Date_book(Name_book,Autor,Years)
values ('Сборник Рассказов','Бунин','1997'),
('Война и мир Том1','Толстой','2000'),
('Война и мир Том2','Толстой','2013'),
('Война и мир Том3','Толстой','2005'),
('Властелин колец','Джон Р. Р. Толкин','1997'),
('Гордость и предубеждение','Джейн Остин','1998'),
('Тёмные начала','Филип Пулман','2000'),
('Автостопом по галактике',' Дуглас Адамс','2005'),
('Гарри Поттер и Кубок огня','Джоан Роулинг','2008'),
('Убить пересмешника','Харпер Ли','1995');
	 

create table Libraly_ticets
(
	ID_Libraly_ticets SERIAL not null constraint PK_Libraly_ticets primary key,
	Date_book_ID int not null references Date_book (ID_Date_book),
	Employee_ID int not null references Employee (ID_Employee),
	Date_Buier_ID int not null references Date_Buier (ID_Date_Buier),
	Date_Buy date not null
)

create or replace procedure Libraly_ticets_Delete (p_Libraly_ticets int)
language plpgsql
as $$
 DECLARE have_record int := count(*) from sost_book where libraly_ticets_id = p_Libraly_ticets;
	begin
	if have_record > 0 then 
	raise exception 'Данную запись удалить нельзя';
	else
	delete from Date_book
	where 
	ID_Libraly_ticets = p_Libraly_ticets;
	end if;
	end;
$$;
insert into Libraly_ticets(Date_book_ID,Employee_ID,Date_Buier_ID,Date_Buy)
values ('1','10','1','27.10.2021'),
('2','9','5','27.10.2021'),
('3','8','6','03.09.2021'),
('4','7','7','15.10.2021'),
('5','6','8','13.10.2021'),
('6','5','5','09.10.2021'),
('7','4','1','06.01.2021'),
('8','3','2','23.02.2021'),
('9','2','3','05.10.2021'),
('10','1','4','26.10.2021');

select * from Libraly_ticets

create table Sost_Book
(
ID_Sost_Book SERIAL not null constraint PK_Sost_Book primary key,
Libraly_ticets_ID int not null references Libraly_ticets (ID_Libraly_ticets),
Mesto varchar (20) not null,
Sost varchar (50) not null
)

create or replace procedure Sost_Book_Delete (p_Sost_Book int)
language plpgsql
as $$
 DECLARE have_record int := count(*) from sost_book where ID_Sost_Book = p_Sost_Book;
	begin
	if have_record > 0 then 
	raise exception 'Данную запись удалить нельзя';
	else
	delete from sost_book
	where 
	ID_Sost_Book = p_Sost_Book;
	end if;
	end;
$$;


insert into Sost_Book(Libraly_ticets_ID,Mesto,Sost)
values ('1','5.6.1','С завода'),
('2','5.2.2','немного поношенное'),
('3','5.1.3','после полевх испытаний'),
('4','5.23.4','поношенное'),
('5','5.1.5','закалённое в боях'),
('6','3.6.6','после'),
('7','7.8.7','С завода'),
('8','16.2.8','после полевх испытаний'),
('9','23.6.23','поношенное'),
('10','24.6.16','поношенное');
select * from Sost_Book



create or replace view Cheak ("Фамилия и инициалы сотрудника", "Фамилия и инициалы покупателя", "Данные о Книги")
as
select
first_name||'  '||substring(name_employee from 1 for 1)||'.'|| substring(middle_name from 1 for 1)||'.','Фамилия Полкумателя '||first_nameb||'   '|| substring(first_nameb from 1 for 1),
'Название '|| name_book||'Автор '|| autor||'Издательсво '|| izdatelstvo
from libraly_ticets
inner join Employee on id_employee = employee_id 
inner join date_book on ID_date_book =date_book_id
inner join date_buier on ID_date_buier = date_buier_id;
select * from Cheak



create or replace function Employee_Ammount(p_Employee_ID int, p_Worked_Hours decimal(38,2))

returns decimal(38,2)
language plpgsql
as $$
declare count_money decimal(38,2);
begin
select (post_price*post_part*0.87)*(p_Worked_Hours/160) into count_money
from combination inner join post on id_post = post_id
where employee_id = p_Employee_ID;
--return комманда для возвращения значения из функции
return count_money;
end;
$$;


create table Employee_History 
(
ID_Employee_History SERIAL not null constraint PK_Employee_History primary key,
Status_Record varchar  not null,
Employee_Info varchar  not null, 
Post_Info varchar  not null, 
Date_Create timestamp null default(now()::timestamp)
);
create or replace function fc_History_insert()
returns trigger
as $$
begin
insert into employee_history(status_record, employee_info, post_info)
values ('Новая запись',
(select surename_employee||' '||name_employee||' '||middlename_employee from employee where id_employee = NEW.id_employee),
(select name_post||', Оклад: '||post_price from Post where id_post = NEW.post_id));
return new; 
end;
$$
language plpgsql;















