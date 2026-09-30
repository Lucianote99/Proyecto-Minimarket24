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
