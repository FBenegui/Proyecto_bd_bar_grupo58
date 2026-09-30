-- Tabla PERSONA
CREATE TABLE persona (
    id_persona INT IDENTITY(1,1) PRIMARY KEY,
    dni VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(80) NOT NULL,
    apellido VARCHAR(80) NOT NULL,
    email_personal VARCHAR(120),
    telefono VARCHAR(30)
);

-- Tabla ROL
CREATE TABLE rol (
    id_rol INT IDENTITY(1,1) PRIMARY KEY,
    nombre_rol VARCHAR(50) NOT NULL UNIQUE
);

-- Tabla UBICACION
CREATE TABLE ubicacion (
    id_ubicacion INT IDENTITY(1,1) PRIMARY KEY,
    nombre_ubicacion VARCHAR(80) NOT NULL,
    capacidad INT CHECK (capacidad > 0),
    tipo_ubicacion VARCHAR(40) NOT NULL
);

-- Tabla CATEGORIA
CREATE TABLE categoria (
    id_categoria INT IDENTITY(1,1) PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL UNIQUE,
    fecha_creacion DATETIME NOT NULL DEFAULT GETDATE(),
    fecha_modificacion DATETIME,
    usuario_modificacion VARCHAR(50)
);

-- Tabla INGREDIENTE
CREATE TABLE ingrediente (
    id_ingrediente INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    unidad_medida VARCHAR(30) NOT NULL,
    stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0),
    stock_minimo INT NOT NULL DEFAULT 0 CHECK (stock_minimo >= 0),
    fecha_creacion DATETIME NOT NULL DEFAULT GETDATE(),
    fecha_modificacion DATETIME,
    usuario_modificacion VARCHAR(50)
);

-- Tabla METODO_PAGO
CREATE TABLE metodo_pago (
    id_metodo_pago INT IDENTITY(1,1) PRIMARY KEY,
    nombre_metodo VARCHAR(50) NOT NULL UNIQUE
);

-- Tabla USUARIO
CREATE TABLE usuario (
    id_usuario INT PRIMARY KEY,
    email_empresa VARCHAR(120) NOT NULL UNIQUE,
    clave VARCHAR(255) NOT NULL,
    id_rol INT NOT NULL,
    
    CONSTRAINT fk_usuario_persona FOREIGN KEY (id_usuario) REFERENCES persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_usuario_rol FOREIGN KEY (id_rol) REFERENCES rol (id_rol) ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Tabla CLIENTE
CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY,
    fecha_registro DATE NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT fk_cliente_persona FOREIGN KEY (id_cliente) REFERENCES persona (id_persona) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla PRODUCTO
CREATE TABLE producto (
    id_producto INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0),
    stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0),
    stock_minimo INT NOT NULL DEFAULT 0 CHECK (stock_minimo >= 0),
    ruta_imagen VARCHAR(255),
    fecha_creacion DATETIME NOT NULL DEFAULT GETDATE(),
    fecha_modificacion DATETIME,
    usuario_modificacion VARCHAR(50),
    id_categoria INT NOT NULL,
    
    CONSTRAINT fk_producto_categoria FOREIGN KEY (id_categoria) REFERENCES categoria (id_categoria) ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Tabla RECETA
CREATE TABLE receta (
    id_producto INT PRIMARY KEY,
    preparacion TEXT NOT NULL,
    
    CONSTRAINT fk_receta_producto FOREIGN KEY (id_producto) REFERENCES producto (id_producto) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla PRODUCTO_INGREDIENTE
CREATE TABLE producto_ingrediente (
    id_producto INT NOT NULL,
    id_ingrediente INT NOT NULL,
    cantidad_necesaria DECIMAL(10,2) NOT NULL CHECK (cantidad_necesaria > 0),
    
    PRIMARY KEY (id_producto, id_ingrediente),
    CONSTRAINT fk_prod_ingred_producto FOREIGN KEY (id_producto) REFERENCES producto (id_producto) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_prod_ingred_ingrediente FOREIGN KEY (id_ingrediente) REFERENCES ingrediente (id_ingrediente) ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Tabla VENTA
CREATE TABLE venta (
    id_venta INT IDENTITY(1,1) PRIMARY KEY,
    fecha_hora DATETIME2 NOT NULL CONSTRAINT DF_venta_fecha_hora DEFAULT SYSDATETIME(),
    estado_venta VARCHAR(20) NOT NULL CONSTRAINT DF_venta_estado DEFAULT 'PENDIENTE',
    modalidad_consumo VARCHAR(20) NOT NULL,
    id_cliente INT NULL,
    id_ubicacion INT NULL,
    id_metodo_pago INT NOT NULL,
    id_cajero INT NOT NULL,
    id_mesero INT NULL,

    CONSTRAINT CK_venta_estado CHECK (estado_venta IN ('PENDIENTE','PAGADA','CANCELADA')),
    CONSTRAINT CK_venta_modalidad CHECK (modalidad_consumo IN ('EN_LOCAL','PARA_LLEVAR','DELIVERY')),
    
    CONSTRAINT FK_venta_cliente FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT FK_venta_ubicacion FOREIGN KEY (id_ubicacion) REFERENCES ubicacion (id_ubicacion) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT FK_venta_metodo_pago FOREIGN KEY (id_metodo_pago) REFERENCES metodo_pago (id_metodo_pago) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT FK_venta_cajero FOREIGN KEY (id_cajero) REFERENCES usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT FK_venta_mesero FOREIGN KEY (id_mesero) REFERENCES usuario (id_usuario) ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Tabla VENTA_DETALLE
CREATE TABLE venta_detalle (
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,

    CONSTRAINT PK_venta_detalle PRIMARY KEY (id_venta, id_producto),
    CONSTRAINT CK_venta_detalle_cantidad CHECK (cantidad > 0),
    CONSTRAINT CK_venta_detalle_precio CHECK (precio_unitario >= 0),
    
    CONSTRAINT FK_venta_detalle_venta FOREIGN KEY (id_venta) REFERENCES venta (id_venta) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_venta_detalle_producto FOREIGN KEY (id_producto) REFERENCES producto (id_producto) ON DELETE NO ACTION ON UPDATE NO ACTION
);