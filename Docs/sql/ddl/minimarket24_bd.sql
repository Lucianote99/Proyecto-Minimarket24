CREATE DATABASE sistema_ventas;
GO
USE sistema_ventas;
GO

CREATE TABLE CLIENTE (
    id_cliente INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    dni INT NOT NULL UNIQUE,
    telefono VARCHAR(20) NOT NULL,
    email VARCHAR(100) NULL UNIQUE,
    PRIMARY KEY (id_cliente)
);

CREATE TABLE EMPLEADO (
    id_empleado INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    dni INT NOT NULL UNIQUE,
    PRIMARY KEY (id_empleado)
);

CREATE TABLE VENTA (
    id_venta INT NOT NULL,
    fecha_hora DATETIME NOT NULL,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('PENDIENTE', 'COMPLETADA', 'CANCELADA')),
    id_cliente INT NOT NULL,
    id_empleado INT NOT NULL,
    PRIMARY KEY (id_venta),
    FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente) ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (id_empleado) REFERENCES EMPLEADO(id_empleado) ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE CATEGORIA (
    id_categoria INT NOT NULL,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(150) NULL,
    PRIMARY KEY (id_categoria)
);

CREATE TABLE PRODUCTO (
    id_producto INT NOT NULL,
    codigo_barra VARCHAR(50) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(200) NULL,
    precio_actual DECIMAL(10,2) NOT NULL CHECK (precio_actual > 0),
    id_categoria INT NOT NULL,
    PRIMARY KEY (id_producto),
    FOREIGN KEY (id_categoria) REFERENCES CATEGORIA(id_categoria) ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE STOCK (
    id_stock INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad >= 0),
    stock_minimo INT NOT NULL CHECK (stock_minimo >= 0),
    id_producto INT NOT NULL,
    PRIMARY KEY (id_stock),
    FOREIGN KEY (id_producto) REFERENCES PRODUCTO(id_producto) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE DETALLE_VENTA (
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2) NOT NULL CHECK (precio_unitario > 0),
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    PRIMARY KEY (id_venta, id_producto),
    FOREIGN KEY (id_venta) REFERENCES VENTA(id_venta) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES PRODUCTO(id_producto) ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE METODO_PAGO (
    id_metodo_pago INT NOT NULL,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    PRIMARY KEY (id_metodo_pago)
);

CREATE TABLE PAGO (
    id_pago INT NOT NULL,
    importe DECIMAL(10,2) NOT NULL CHECK (importe > 0),
    fecha_hora DATETIME NOT NULL,
    id_venta INT NOT NULL,
    id_metodo_pago INT NOT NULL,
    PRIMARY KEY (id_pago),
    FOREIGN KEY (id_venta) REFERENCES VENTA(id_venta) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_metodo_pago) REFERENCES METODO_PAGO(id_metodo_pago) ON UPDATE CASCADE ON DELETE NO ACTION
);
GO
