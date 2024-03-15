# Listar las bases de datos actuales en el servidor
show databases;

# Crear base de datos
create database southwind;

# Este comando nos permitira ejecutar diferentes funciones dentro de la bd
use southwind;

# Listar tablas actuales
show tables;

# Crear tabla inicial de products
CREATE TABLE IF NOT EXISTS products (
         productID    INT UNSIGNED  NOT NULL AUTO_INCREMENT,
         productCode  CHAR(3)       NOT NULL DEFAULT '',
         name         VARCHAR(30)   NOT NULL DEFAULT '',
         quantity     INT UNSIGNED  NOT NULL DEFAULT 0,
         price        DECIMAL(7,2)  NOT NULL DEFAULT 99999.99,
         PRIMARY KEY  (productID)
       );
 
# Para entender como quedo creada la tabla y ver sus atributos 
DESCRIBE products;

# Insertar products individualmente
INSERT INTO products VALUES (1001, 'PEN', 'Pen Red', 5000, 1.23);

# Insertar products de manera grupal
INSERT INTO products VALUES
         (NULL, 'PEN', 'Pen Blue',  8000, 1.25),
         (NULL, 'PEN', 'Pen Black', 2000, 1.25);

# Insertar products con definición de parámetros
INSERT INTO products (productCode, name, quantity, price) VALUES
         ('PEC', 'Pencil 2B', 10000, 0.48),
         ('PEC', 'Pencil 2H', 8000, 0.49);

# Intenta insertar valores nulos, esta consulta va a arrojar un error
INSERT INTO products values (NULL, NULL, NULL, NULL, NULL);

# Insertar products unicamente con los parametros obligatorios
INSERT INTO products (productCode, name) VALUES ('PEC', 'Pencil HB');

# Borrando un registro
DELETE FROM products WHERE productID=1006;

# Consultar products
SELECT * from products;

# Consultar ciertos atributos de products, ordenando descendentemente por productID
SELECT productID, name, price from products Order by productID DESC;

# Consultar ciertos atributos de products, donde el valor de quantity sea mayor a 2000
SELECT name, price from products WHERE quantity >2000;

# Consultar ciertos atributos de products, donde se cumpla una condición
SELECT productCode, name, price from products WHERE productCode='PEN';

# Consultar ciertos atributos de products, donde el nombre coincida con el parametro y el wildcard
SELECT productCode, name, price from products WHERE name LIKE 'PENCIL%';

# Consultar ciertos atributos de products, donde el nombre coincida con el parametro y el wildcard
SELECT productCode, name, price from products WHERE name LIKE '%blue%';

# Consultar ciertos atributos de products, donde se deben cumplir dos condiciones
SELECT productCode, name, price from products WHERE name LIKE '%blue%' AND quantity > 2000 ;

# Consultar ciertos atributos de products, donde se deben cumplir tres condiciones
SELECT productCode, name, price from products WHERE name LIKE 'pen%' AND quantity > 2000 AND price >= 1.25 ;

# Consultar ciertos atributos de products, donde el atributo nombre este contenido en el set provisto
SELECT productCode, name, price from products WHERE name IN ('Pen Red', 'Pen Black');

# Consultar ciertos atributos de products, donde el previo este dentro del rango definido y limitando el número de resultados
SELECT productCode, name, price from products WHERE price BETWEEN 1.0 AND 1.5 ORDER BY price LIMIT 2;

# Contar el número de registros en products
SELECT COUNT(*) from products;

# Consultar products, ordenando por dos parametros simultaneamente
SELECT * FROM products ORDER BY productCode, productID;

# Aplicando las funciones predefinidas al consultar nuestros products
SELECT MAX(price), MIN(price), AVG(price), STD(price), SUM(quantity)
       FROM products;

# Consulta usando alias y agrupando por product Code
SELECT productCode, MAX(price) AS `Highest Price`, MIN(price) AS `Lowest Price`
       FROM products
       GROUP BY productCode;

# Creando nuestra segunda tabla de proveedores
CREATE TABLE suppliers (
         supplierID  INT UNSIGNED  NOT NULL AUTO_INCREMENT, 
         name        VARCHAR(30)   NOT NULL DEFAULT '', 
         phone       CHAR(8)       NOT NULL DEFAULT '',
         PRIMARY KEY (supplierID)
       );

# Detallando los parametros de suppliers
DESCRIBE suppliers;

# Insertando nuestros valores iniciales 
INSERT INTO suppliers VALUE
          (501, 'ABC Traders', '88881111'), 
          (502, 'XYZ Company', '88882222'), 
          (503, 'QQ Corp', '88883333');

# Creando una tabla itermedia para poder evidenciar la relación de muchos a muchos   
CREATE TABLE products_suppliers (
         productID   INT UNSIGNED  NOT NULL,
         supplierID  INT UNSIGNED  NOT NULL,
         PRIMARY KEY (productID, supplierID),
         FOREIGN KEY (productID)  REFERENCES products  (productID),
         FOREIGN KEY (supplierID) REFERENCES suppliers (supplierID)
       );

SET SQL_SAFE_UPDATES = 0;
SET FOREIGN_KEY_CHECKS=0;

# Insertando nuestros valores iniciales
INSERT INTO products_suppliers VALUES (1001, 501), (1002, 501),
       (1003, 501), (1004, 502), (1001, 503);
       
# Describir la tabla de products suppliers
describe products_suppliers;

# Consultado products_suppliers
SELECT * FROM products_suppliers;

# Consultando simultaneamente entre las tres tablas, mediante un inner JOIN, usando alias
SELECT products.name AS `Product Name`, price, suppliers.name AS `Supplier Name`
       FROM products_suppliers 
          JOIN products  ON products_suppliers.productID = products.productID
          JOIN suppliers ON products_suppliers.supplierID = suppliers.supplierID
       WHERE price < 0.6; 
       
SELECT p.name AS `Product Name`, s.name AS `Supplier Name`
       FROM products_suppliers AS ps 
          JOIN products AS p ON ps.productID = p.productID
          JOIN suppliers AS s ON ps.supplierID = s.supplierID
       WHERE p.name = 'Pencil 3B';


# Trabajando con Fechas

# Creando una tabla para almacenar diferentes fechas
CREATE TABLE patients (
          patientID      INT UNSIGNED  NOT NULL AUTO_INCREMENT,
          name           VARCHAR(30)   NOT NULL DEFAULT '',
          dateOfBirth    DATE          NOT NULL,
          lastVisitDate  DATE          NOT NULL,
          nextVisitDate  DATE          NULL,
                         -- The 'Date' type contains a date value in 'yyyy-mm-dd'
          PRIMARY KEY (patientID)
       );

# Describiendo la tabla
describe patients;

# Insertando unos datos iniciales
INSERT INTO patients VALUES
          (1001, 'Ah Teck', '1991-12-31', '2012-01-20', NULL),
          (NULL, 'Kumar', '2011-10-29', '2012-09-20', NULL),
          (NULL, 'Ali', '2011-01-30', CURDATE(), NULL);
          
# Mostrando los registros de patients
select * from patients;

# Selecciona los pacientes que tuvieron su última visita entre una fecha y la fecha de hoy, ordendando por la ultima fecha de visita
SELECT * FROM patients
       WHERE lastVisitDate BETWEEN '2012-09-15' AND CURDATE()
       ORDER BY lastVisitDate;
	
# Selecciona los pacientes, donde se cumpla la comparación de año, ordenando por mes y día
SELECT * FROM patients
       WHERE YEAR(dateOfBirth) = 2011
       ORDER BY MONTH(dateOfBirth), DAY(dateOfBirth);

# Comparando las funciones de ahora, fecha actual, momento actual
select now(), curdate(), curtime();

