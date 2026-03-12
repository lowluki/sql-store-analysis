-- CREATING CUSTOMERS TABLE 
CREATE TABLE customers(
	customer_id int NOT NULL auto_increment,
    first_name varchar(255) NOT NULL,
	last_name varchar(255) NOT NULL,
    email varchar(255) UNIQUE NOT NULL,
    country varchar(255) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    PRIMARY KEY(customer_id)
);
-- CREATING CATEGORIES TABLE
CREATE TABLE categories(
	category_id int NOT NULL auto_increment,
	name varchar(255) UNIQUE NOT NULL,
    PRIMARY KEY(category_id)
);
-- CREATING PRODUCTS TABLE
CREATE TABLE products(
	product_id int NOT NULL auto_increment,
    name varchar(255) NOT NULL,
    category_id INT not null,
    price DECIMAL(19,2) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    PRIMARY KEY(product_id),
    FOREIGN KEY(category_id) REFERENCES categories(category_id)
);
-- CREATING ORDERS TABLE
CREATE TABLE orders(
	order_id INT NOT NULL AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date TIMESTAMP NOT NULL,
    status ENUM('pending', 'paid', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending' NOT NULL,
    total_amount DECIMAL(19,2) NOT NULL,
	PRIMARY KEY(order_id),
    FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
);
-- CREATING ORDERS ITEMS TABLE
CREATE TABLE order_items(
	order_item_id INT NOT NULL AUTO_INCREMENT,
    order_id INT NOT NULL,
	product_id INT NOT NULL,
	quantity INT NOT NULL CHECK (quantity > 0 ),
	unit_price DECIMAL(19,2) NOT NULL,
    PRIMARY KEY(order_item_id),
    FOREIGN KEY(order_id) REFERENCES orders(order_id),
    FOREIGN KEY(product_id) REFERENCES products(product_id)
);
-- CREATING PAYMENTS TABLE
CREATE TABLE payments(
	payment_id INT NOT NULL AUTO_INCREMENT,
	order_id INT NOT NULL,
	payment_date TIMESTAMP NOT NULL, 
    payment_method ENUM('card', 'cash', 'blik', 'paypal', 'google_pay', 'apple_pay') NOT NULL,
	status ENUM('pending', 'completed', 'failed', 'refunded') DEFAULT 'pending' NOT NULL,
    amount DECIMAL(19,2) NOT NULL CHECK (amount > 0),
    PRIMARY KEY(payment_id),
    FOREIGN KEY(order_id) REFERENCES orders(order_id)
);
