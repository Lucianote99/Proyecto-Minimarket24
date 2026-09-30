CREATE DATABASE minimarket_24;
GO

USE minimarket_24;
GO

CREATE TABLE cliente (
    id_cliente INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    dni INT NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    email VARCHAR(100) NULL,
    CONSTRAINT pk_cliente PRIMARY KEY (id_cliente),
    CONSTRAINT uk_cliente_dni UNIQUE (dni),
    CONSTRAINT uk_cliente_email UNIQUE (email)
);

CREATE TABLE empleado (
    id_empleado INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    dni INT NOT NULL,
    CONSTRAINT pk_empleado PRIMARY KEY (id_empleado),
    CONSTRAINT uk_empleado_dni UNIQUE (dni)
);

CREATE TABLE venta (
    id_venta INT NOT NULL,
    fecha_hora DATETIME NOT NULL,
    estado VARCHAR(20) NOT NULL,
    id_cliente INT NOT NULL,
    id_empleado INT NOT NULL,
    CONSTRAINT pk_venta PRIMARY KEY (id_venta),
    CONSTRAINT fk_venta_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    CONSTRAINT fk_venta_empleado FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado),
    CONSTRAINT chk_venta_estado CHECK (estado IN ('completada', 'pendiente', 'cancelada'))
);

CREATE TABLE categoria (
    id_categoria INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(150) NULL,
    CONSTRAINT pk_categoria PRIMARY KEY (id_categoria),
    CONSTRAINT uk_categoria_nombre UNIQUE (nombre)
);

CREATE TABLE producto (
    id_producto INT NOT NULL,
    codigo_barra VARCHAR(50) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(200) NULL,
    precio_actual DECIMAL(10,2) NOT NULL,
    id_categoria INT NOT NULL,
    CONSTRAINT pk_producto PRIMARY KEY (id_producto),
    CONSTRAINT uk_producto_codigo_barra UNIQUE (codigo_barra),
    CONSTRAINT fk_producto_categoria FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria),
    CONSTRAINT chk_producto_precio CHECK (precio_actual > 0)
);

CREATE TABLE stock (
    id_stock INT NOT NULL,
    cantidad INT NOT NULL,
    stock_minimo INT NOT NULL,
    id_producto INT NOT NULL,
    CONSTRAINT pk_stock PRIMARY KEY (id_stock),
    CONSTRAINT fk_stock_producto FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    CONSTRAINT chk_stock_cantidad CHECK (cantidad >= 0),
    CONSTRAINT chk_stock_minimo CHECK (stock_minimo >= 0)
);

CREATE TABLE detalle_venta (
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    CONSTRAINT pk_detalle_venta PRIMARY KEY (id_venta, id_producto),
    CONSTRAINT fk_detalle_venta_venta FOREIGN KEY (id_venta) REFERENCES venta(id_venta),
    CONSTRAINT fk_detalle_venta_producto FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    CONSTRAINT chk_detalle_cantidad CHECK (cantidad > 0),
    CONSTRAINT chk_detalle_precio CHECK (precio_unitario > 0)
);

CREATE TABLE metodo_pago (
    id_metodo_pago INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    CONSTRAINT pk_metodo_pago PRIMARY KEY (id_metodo_pago),
    CONSTRAINT uk_metodo_pago_nombre UNIQUE (nombre)
);

CREATE TABLE pago (
    id_pago INT NOT NULL,
    importe DECIMAL(10,2) NOT NULL,
    fecha_hora DATETIME NOT NULL,
    id_venta INT NOT NULL,
    id_metodo_pago INT NOT NULL,
    CONSTRAINT pk_pago PRIMARY KEY (id_pago),
    CONSTRAINT fk_pago_venta FOREIGN KEY (id_venta) REFERENCES venta(id_venta),
    CONSTRAINT fk_pago_metodo_pago FOREIGN KEY (id_metodo_pago) REFERENCES metodo_pago(id_metodo_pago),
    CONSTRAINT chk_pago_importe CHECK (importe > 0)
);
-----Modificación para fecha y hora default

ALTER TABLE venta 
ADD CONSTRAINT df_venta_fecha_hora DEFAULT GETDATE() FOR fecha_hora;

ALTER TABLE pago 
ADD CONSTRAINT df_pago_fecha_hora DEFAULT GETDATE() FOR fecha_hora;


--A partir de aca se veran los comandos correspondientes a la insercion de datos
----------------------------------
--Inserción de CLIENTES(10 Registros)
----------------------------------
INSERT INTO cliente (id_cliente,nombre,apellido,dni,email,telefono) 
VALUES (1,'Fernando','Arce',46823671,'ferar11@gmail.com',3746895531);

INSERT INTO cliente (id_cliente,nombre,apellido,dni,email,telefono)
VALUES (2,'Juan Roman','Zacarias', 45882369,'zacarjuan26@gmail.com', 3764894378);

INSERT INTO cliente (id_cliente,nombre,apellido,dni,email,telefono)
VALUES (3,'Facundo Tobias','Acevedo', 46812327,'facuaceved0@gmail,com', 3523698475);

INSERT INTO cliente (id_cliente,nombre,apellido,dni,email,telefono)
VALUES (4,'Eugenio','Erck', 42521367,'eugeerck31@gmail.com', 3751845712);

INSERT INTO cliente (id_cliente,nombre,apellido,dni,email,telefono)
VALUES (5,'Santiago','Candia', 45214657,'santiagocar6@gmail.com', 3743457829);

INSERT INTO cliente (id_cliente,nombre,apellido,dni,email,telefono)
VALUES (6,'Agustin','Gomez', 21249360,'agusgom67@outlook.com', 3764892217);

INSERT INTO cliente (id_cliente,nombre,apellido,dni,email,telefono)
VALUES (7,'Agustina','Gimenez', 48791360,'agusjungkook@gmail.com', 3748552978);

INSERT INTO cliente (id_cliente,nombre,apellido,dni,email,telefono)
VALUES (8,'Geronimo','Alegre Perez', 46885677,'lurien67@gmail.com', 3746213648);

INSERT INTO cliente (id_cliente,nombre,apellido,dni,email,telefono)
VALUES (9,'Carlos','Aguilar Moreira', 45127881,'carlitos420@gmail.com', 3751537600);

INSERT INTO cliente (id_cliente,nombre,apellido,dni,email,telefono)
VALUES (10,'Cleopatra','Tapia', 46574967,'egipto840@gmail.com', 3764882367);



SELECT * FROM cliente;

-- ==========================================
-- 1. Inserción de EMPLEADOS (10 registros)
-- ==========================================
INSERT INTO empleado (id_empleado, nombre, apellido, dni) 
VALUES (1, 'Marcos', 'Benitez', 35412896);

INSERT INTO empleado (id_empleado, nombre, apellido, dni) 
VALUES (2, 'Valeria', 'Rios', 38965412);

INSERT INTO empleado (id_empleado, nombre, apellido, dni) 
VALUES (3, 'Lucas', 'Medina', 40125896);

INSERT INTO empleado (id_empleado, nombre, apellido, dni) 
VALUES (4, 'Romina', 'Sosa', 33214589);

INSERT INTO empleado (id_empleado, nombre, apellido, dni) 
VALUES (5, 'Esteban', 'Peralta', 36589214);

INSERT INTO empleado (id_empleado, nombre, apellido, dni) 
VALUES (6, 'Camila', 'Duarte', 41258963);

INSERT INTO empleado (id_empleado, nombre, apellido, dni) 
VALUES (7, 'Diego', 'Vera', 32456789);

INSERT INTO empleado (id_empleado, nombre, apellido, dni) 
VALUES (8, 'Florencia', 'Acosta', 39874561);

INSERT INTO empleado (id_empleado, nombre, apellido, dni) 
VALUES (9, 'Gonzalo', 'Cabral', 37456123);

INSERT INTO empleado (id_empleado, nombre, apellido, dni) 
VALUES (10, 'Natalia', 'Ojeda', 42159874);

SELECT * FROM empleado;

-- ==========================================
-- 2. Inserción de CATEGORÍAS (8 registros)
-- ==========================================
INSERT INTO categoria (id_categoria, nombre, descripcion) 
VALUES (1, 'Bebidas', 'Bebidas con y sin alcohol, jugos y gaseosas');

INSERT INTO categoria (id_categoria, nombre, descripcion) 
VALUES (2, 'Almacén', 'Productos de primea necesidad, fideos, arroz, aceite');

INSERT INTO categoria (id_categoria, nombre, descripcion) 
VALUES (3, 'Lácteos', 'Leche, yogures, quesos y derivados');

INSERT INTO categoria (id_categoria, nombre, descripcion) 
VALUES (4, 'Limpieza', 'Artículos de limpieza para el hogar y cuidado de ropa');

INSERT INTO categoria (id_categoria, nombre, descripcion) 
VALUES (5, 'Snacks y Golosinas', 'Galletitas, chocolates, alfajores y papas fritas');

INSERT INTO categoria (id_categoria, nombre, descripcion) 
VALUES (6, 'Verdulería y Fruteria', 'Frutas y verduras frescas');

INSERT INTO categoria (id_categoria, nombre, descripcion) 
VALUES (7, 'Panadería', 'Pan, facturas y panificados');

INSERT INTO categoria (id_categoria, nombre, descripcion) 
VALUES (8, 'Cuidado Personal', 'Jabones, champú, dentífricos y desodorantes');

SELECT * FROM categoria;

-- ==========================================
-- 3. Inserción de PRODUCTOS (10 registros)
-- ==========================================
INSERT INTO producto (id_producto, codigo_barra, nombre, descripcion, precio_actual, id_categoria) 
VALUES (1, '7791234567890', 'Gaseosa Cola 2.25L', 'Bebida sabor cola descartable', 2500.00, 1);

INSERT INTO producto (id_producto, codigo_barra, nombre, descripcion, precio_actual, id_categoria) 
VALUES (2, '7791234567891', 'Fideos Tallarín 500g', 'Fideos de sémola de trigo duro', 1200.50, 2);

INSERT INTO producto (id_producto, codigo_barra, nombre, descripcion, precio_actual, id_categoria) 
VALUES (3, '7791234567892', 'Leche Entera 1L', 'Leche entera sachet primera marca', 1400.00, 3);

INSERT INTO producto (id_producto, codigo_barra, nombre, descripcion, precio_actual, id_categoria) 
VALUES (4, '7791234567893', 'Lavandina 1L', 'Lavandina tradicional desinfectante', 950.00, 4);

INSERT INTO producto (id_producto, codigo_barra, nombre, descripcion, precio_actual, id_categoria) 
VALUES (5, '7791234567894', 'Alfajor de Chocolate', 'Alfajor relleno de dulce de leche bañado en chocolate', 700.00, 5);

INSERT INTO producto (id_producto, codigo_barra, nombre, descripcion, precio_actual, id_categoria) 
VALUES (6, '7791234567895', 'Tomate Redondo x Kg', 'Tomate fresco seleccionado por kilo', 1800.00, 6);

INSERT INTO producto (id_producto, codigo_barra, nombre, descripcion, precio_actual, id_categoria) 
VALUES (7, '7791234567896', 'Pan Mignon x Kg', 'Pan fresco tipo mignon', 2200.00, 7);

INSERT INTO producto (id_producto, codigo_barra, nombre, descripcion, precio_actual, id_categoria) 
VALUES (8, '7791234567897', 'Jabón de Tocador 90g', 'Jabón antibacterial aroma floral', 650.00, 8);

INSERT INTO producto (id_producto, codigo_barra, nombre, descripcion, precio_actual, id_categoria) 
VALUES (9, '7791234567898', 'Aceite de Girasol 900ml', 'Aceite refinado puro de girasol', 2100.00, 2);

INSERT INTO producto (id_producto, codigo_barra, nombre, descripcion, precio_actual, id_categoria) 
VALUES (10, '7791234567899', 'Agua Mineral Sin Gas 1.5L', 'Agua mineral en botellas PET', 900.00, 1);

SELECT * FROM producto;

-- ==========================================
-- 4. Inserción de STOCK (10 registros)
-- ==========================================
INSERT INTO stock (id_stock, cantidad, stock_minimo, id_producto) 
VALUES (1, 45, 10, 1);

INSERT INTO stock (id_stock, cantidad, stock_minimo, id_producto) 
VALUES (2, 80, 15, 2);

INSERT INTO stock (id_stock, cantidad, stock_minimo, id_producto) 
VALUES (3, 30, 8, 3);

INSERT INTO stock (id_stock, cantidad, stock_minimo, id_producto) 
VALUES (4, 50, 10, 4);

INSERT INTO stock (id_stock, cantidad, stock_minimo, id_producto) 
VALUES (5, 120, 20, 5);

INSERT INTO stock (id_stock, cantidad, stock_minimo, id_producto) 
VALUES (6, 25, 5, 6);

INSERT INTO stock (id_stock, cantidad, stock_minimo, id_producto) 
VALUES (7, 40, 10, 7);

INSERT INTO stock (id_stock, cantidad, stock_minimo, id_producto) 
VALUES (8, 60, 12, 8);

INSERT INTO stock (id_stock, cantidad, stock_minimo, id_producto) 
VALUES (9, 35, 10, 9);

INSERT INTO stock (id_stock, cantidad, stock_minimo, id_producto) 
VALUES (10, 90, 20, 10);

SELECT * FROM stock;

-- ==========================================
-- 5. Inserción de VENTAS (10 registros)
-- ==========================================
INSERT INTO venta (id_venta,estado, id_cliente, id_empleado) 
VALUES (1,'completada', 1, 3);

INSERT INTO venta (id_venta,estado, id_cliente, id_empleado) 
VALUES (2, 'completada', 2, 1);

INSERT INTO venta (id_venta,estado, id_cliente, id_empleado) 
VALUES (3,'pendiente', 3, 4);

INSERT INTO venta (id_venta,estado, id_cliente, id_empleado) 
VALUES (4,'completada', 4, 2);

INSERT INTO venta (id_venta,estado,id_cliente, id_empleado) 
VALUES (5,'cancelada', 5, 5);

INSERT INTO venta (id_venta,estado, id_cliente, id_empleado) 
VALUES (6, 'completada', 6, 7);

INSERT INTO venta (id_venta,estado, id_cliente, id_empleado) 
VALUES (7,'completada', 7, 6);

INSERT INTO venta (id_venta,estado, id_cliente, id_empleado) 
VALUES (8, 'completada', 8, 8);

INSERT INTO venta (id_venta, estado, id_cliente, id_empleado) 
VALUES (9, 'pendiente', 9, 10);

INSERT INTO venta (id_venta,estado, id_cliente, id_empleado) 
VALUES (10, 'completada', 10, 9);

SELECT * FROM venta;

-- ==========================================
-- 6. Inserción de DETALLE_VENTA (10 registros)
-- ==========================================
INSERT INTO detalle_venta (cantidad, precio_unitario, id_venta, id_producto) 
VALUES (2, 2500.00, 1, 1);

INSERT INTO detalle_venta (cantidad, precio_unitario, id_venta, id_producto) 
VALUES (1, 1400.00, 2, 3);

INSERT INTO detalle_venta (cantidad, precio_unitario, id_venta, id_producto) 
VALUES (3, 700.00, 3, 5);

INSERT INTO detalle_venta (cantidad, precio_unitario, id_venta, id_producto) 
VALUES (1, 2100.00, 4, 9);

INSERT INTO detalle_venta (cantidad, precio_unitario, id_venta, id_producto)
VALUES (2, 900.00, 5, 10);

INSERT INTO detalle_venta (cantidad, precio_unitario, id_venta, id_producto) 
VALUES (4, 1200.50, 6, 2);

INSERT INTO detalle_venta (cantidad, precio_unitario, id_venta, id_producto) 
VALUES (1, 950.00, 7, 4);

INSERT INTO detalle_venta (cantidad, precio_unitario, id_venta, id_producto) 
VALUES (2, 1800.00, 8, 6);

INSERT INTO detalle_venta (cantidad, precio_unitario, id_venta, id_producto) 
VALUES (1, 2200.00, 9, 7);

INSERT INTO detalle_venta (cantidad, precio_unitario, id_venta, id_producto) 
VALUES (3, 650.00, 10, 8);

SELECT * FROM detalle_venta;

-- ==========================================
-- 7. Inserción de METODO_PAGO (4 registros)
-- ==========================================

INSERT INTO metodo_pago (id_metodo_pago, nombre) 
VALUES (1, 'Efectivo');

INSERT INTO metodo_pago (id_metodo_pago, nombre)
VALUES (2, 'Tarjeta de Débito');

INSERT INTO metodo_pago (id_metodo_pago, nombre) 
VALUES (3, 'Tarjeta de Crédito');

INSERT INTO metodo_pago (id_metodo_pago, nombre) 
VALUES (4, 'Mercado Pago');

SELECT * FROM metodo_pago;

-- ==========================================
-- 8. Inserción de PAGO (8 registros)
-- ==========================================
INSERT INTO pago (id_pago, importe,id_venta, id_metodo_pago) 
VALUES (1, 5000.00, 1, 1);

INSERT INTO pago (id_pago, importe,id_venta, id_metodo_pago) 
VALUES (2, 1400.00,2, 4);

INSERT INTO pago (id_pago, importe,id_venta, id_metodo_pago) 
VALUES (3, 2100.00,4, 2);

INSERT INTO pago (id_pago, importe,id_venta, id_metodo_pago) 
VALUES (4, 4802.00,6, 3);

INSERT INTO pago (id_pago, importe,id_venta, id_metodo_pago)
VALUES (5, 950.00,7, 1);

INSERT INTO pago (id_pago, importe,id_venta, id_metodo_pago) 
VALUES (6, 3600.00,8, 4);

INSERT INTO pago (id_pago, importe,id_venta, id_metodo_pago) 
VALUES (7, 2200.00, 10, 2);

INSERT INTO pago (id_pago, importe,id_venta, id_metodo_pago) 
VALUES (8, 1950.00, 10, 1);

SELECT * FROM pago;
