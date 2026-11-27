CREATE DATABASE IF NOT EXISTS foodfleet_hybrid;
USE foodfleet_hybrid;
DROP VIEW IF EXISTS vw_restaurant_analytics;
DROP TABLE IF EXISTS delivery_events,order_items,orders,menu_items,restaurants,customers;
CREATE TABLE customers(customer_id INT AUTO_INCREMENT PRIMARY KEY,name VARCHAR(100) NOT NULL,area VARCHAR(80) NOT NULL);
CREATE TABLE restaurants(restaurant_id INT AUTO_INCREMENT PRIMARY KEY,name VARCHAR(100) NOT NULL,cuisine VARCHAR(80) NOT NULL,area VARCHAR(80) NOT NULL);
CREATE TABLE menu_items(item_id INT AUTO_INCREMENT PRIMARY KEY,restaurant_id INT NOT NULL,name VARCHAR(100) NOT NULL,price DECIMAL(10,2) NOT NULL CHECK(price>0),FOREIGN KEY(restaurant_id) REFERENCES restaurants(restaurant_id));
CREATE TABLE orders(order_id INT AUTO_INCREMENT PRIMARY KEY,customer_id INT NOT NULL,restaurant_id INT NOT NULL,total_amount DECIMAL(10,2) NOT NULL CHECK(total_amount>0),payment_method ENUM('UPI','Card','COD') NOT NULL,status ENUM('PLACED','READY_FOR_PICKUP','DISPATCHED','COMPLETED','CANCELLED') DEFAULT 'PLACED',ordered_at DATETIME DEFAULT CURRENT_TIMESTAMP,ready_at DATETIME NULL,dispatched_at DATETIME NULL,completed_at DATETIME NULL,FOREIGN KEY(customer_id) REFERENCES customers(customer_id),FOREIGN KEY(restaurant_id) REFERENCES restaurants(restaurant_id));
CREATE TABLE order_items(order_item_id INT AUTO_INCREMENT PRIMARY KEY,order_id INT NOT NULL,item_id INT NOT NULL,quantity INT NOT NULL CHECK(quantity>0),unit_price DECIMAL(10,2) NOT NULL,FOREIGN KEY(order_id) REFERENCES orders(order_id),FOREIGN KEY(item_id) REFERENCES menu_items(item_id));
CREATE TABLE delivery_events(event_id INT AUTO_INCREMENT PRIMARY KEY,order_id INT NOT NULL,status VARCHAR(30) NOT NULL,created_at DATETIME DEFAULT CURRENT_TIMESTAMP,FOREIGN KEY(order_id) REFERENCES orders(order_id));
DELIMITER //
CREATE TRIGGER trg_log_order_workflow AFTER UPDATE ON orders FOR EACH ROW
BEGIN
 IF OLD.status<>NEW.status THEN
 INSERT INTO delivery_events(order_id,status) VALUES(NEW.order_id,NEW.status);
 END IF;
END//
DELIMITER ;
CREATE VIEW vw_restaurant_analytics AS SELECT o.order_id,r.name restaurant,r.cuisine,r.area,o.ordered_at,o.total_amount,o.payment_method,o.status,TIMESTAMPDIFF(MINUTE,o.ordered_at,o.completed_at) delivery_minutes FROM orders o JOIN restaurants r ON r.restaurant_id=o.restaurant_id;
