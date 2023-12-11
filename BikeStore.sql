Create database BikeStores

Use BikeStores;

Create Table Customers(
	customers_id int identity(1,1) Primary Key not null,
	first_name varchar(255) not null,
	last_name varchar(255) not null,
	phone varchar(255),
	email varchar(255) not null,
	street varchar(255) not null,
	city varchar(50),
	state varchar(25),
	zip_code varchar(5),
);

select *from Customers;

Create table order_items(
	order_id int not null,
	item_id int not null,
	product_id int foreign key references products(product_id) not null,
	quantity int not null,
	list_price decimal(10,2) not null,
	discount decimal(4,2) default ((0)),
);

Create table brands(
	brand_id int identity(1,1) Primary key not null,
	brand_name varchar(255) not null,
);

select *from brands;

Create table staffs(
	staff_id int identity(1,1) Primary Key not null,
	first_name varchar(50) not null,
	last_name varchar(50) not null,
	email varchar(255) not null,
	phone varchar(25),
	active tinyint not null,
	store_id int foreign key references stores(store_id) not null,
	manager_id int,
);

Create table products(
	product_id int identity(1,1) Primary Key not null,
	product_name varchar(255) not null,
	brand_id int foreign key references brands not null,
	category_id int foreign key references categories(category_id) not null,
	model_year smallint not null,
	list_price decimal(10,2) not null,
);

Create table categories(
	category_id int identity(1,1) Primary Key not null,
	category_name varchar(255) not null,
);

Create table stores(
	store_id int identity(1,1) Primary Key not null,
	store_name varchar(255) not null,
	phone varchar(25),
	email varchar(255),
	street varchar(255),
	city varchar(255),
	state varchar(10),
	zip_code varchar(5),
);

Create table orders(
	order_id int Primary Key not null,
	customer_id int foreign key references Customers(customers_id),
	order_status tinyint not null,
	order_date date not null,
	required_date date not null,
	shipped_date date,
	store_id int foreign key references stores(store_id) not null,
	staff_id int foreign key references staffs(staff_id) not null,
);

Create table stocks(
	store_id int foreign key references stores(store_id) not null,
	product_id int foreign key references Products(product_id) not null,
	quantity int not null,
	Primary Key(store_id, product_id),
);

ALTER TABLE order_items
ADD CONSTRAINT FK_orders_order_items
foreign key(order_id) references orders(order_id);


ALTER TABLE Staffs
ADD CONSTRAINT fk_Staffs_Staffs
FOREIGN KEY(manager_id)
REFERENCES Staffs(staff_id);

ALTER TABLE brands
DROP column brand_name;