
-- Tabla CATEGORIA
CREATE TABLE categoria (
    id_categoria INT IDENTITY(1,1) PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL UNIQUE,
    fecha_creacion DATETIME NOT NULL DEFAULT GETDATE(),
    fecha_modificacion DATETIME,
    usuario_modificacion VARCHAR(50)
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
    
    CONSTRAINT fk_producto_categoria 
        FOREIGN KEY (id_categoria) 
        REFERENCES categoria (id_categoria)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
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

-- Tabla PRODUCTO_INGREDIENTE
CREATE TABLE producto_ingrediente (
    id_producto INT NOT NULL,
    id_ingrediente INT NOT NULL,
    cantidad_necesaria DECIMAL(10,2) NOT NULL CHECK (cantidad_necesaria > 0),
    
    PRIMARY KEY (id_producto, id_ingrediente),
    
    CONSTRAINT fk_prod_ingred_producto 
        FOREIGN KEY (id_producto) 
        REFERENCES producto (id_producto)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
        
    CONSTRAINT fk_prod_ingred_ingrediente 
        FOREIGN KEY (id_ingrediente) 
        REFERENCES ingrediente (id_ingrediente)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
);

/* MÓDULO VENTAS - DDL (SQL Server / SSMS)
   Solo: venta y venta_detalle*/

-- venta
-- cliente, ubicacion y mesero son NULL porque puede haber ventas de
-- mostrador / consumidor final / para llevar sin mesero ni mesa.
CREATE TABLE venta (
    id_venta              VARCHAR(20)   NOT NULL,
    fecha_hora            DATETIME2     NOT NULL CONSTRAINT DF_venta_fecha_hora DEFAULT SYSDATETIME(),
    estado_venta          VARCHAR(20)   NOT NULL CONSTRAINT DF_venta_estado DEFAULT 'PENDIENTE',
    modalidad_consumo     VARCHAR(20)   NOT NULL,
    fecha_creacion        DATETIME     NOT NULL DEFAULT GETDATE(),
    fecha_modificacion    DATETIME     NULL,
    usuario_modificacion  VARCHAR(100)  NULL,
    id_cliente            VARCHAR(20)   NULL,
    id_ubicacion          VARCHAR(20)   NULL,
    id_metodo_pago        VARCHAR(20)   NOT NULL,
    id_cajero             VARCHAR(20)   NOT NULL,
    id_mesero             VARCHAR(20)   NULL,
 
    CONSTRAINT PK_venta PRIMARY KEY (id_venta),
 
    -- Integridad de dominio
    CONSTRAINT CK_venta_estado CHECK (estado_venta IN ('PENDIENTE','PAGADA','CANCELADA')),
    CONSTRAINT CK_venta_modalidad CHECK (modalidad_consumo IN ('EN_LOCAL','PARA_LLEVAR','DELIVERY')),
 
    -- Integridad referencial
    CONSTRAINT FK_venta_cliente FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente)
        ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT FK_venta_ubicacion FOREIGN KEY (id_ubicacion)
        REFERENCES ubicacion (id_ubicacion)
        ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT FK_venta_metodo_pago FOREIGN KEY (id_metodo_pago)
        REFERENCES metodo_pago (id_metodo_pago)
        ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT FK_venta_cajero FOREIGN KEY (id_cajero)
        REFERENCES usuario (id_usuario)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT FK_venta_mesero FOREIGN KEY (id_mesero)
        REFERENCES usuario (id_usuario)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);
 
 
-- venta_detalle  (PK compuesta: una línea por producto en cada venta)
-- Sin campo subtotal: se calcula (cantidad * precio_unitario) -> 3FN
-- precio_unitario guarda el precio AL MOMENTO de la venta (historial),
-- por eso no es redundante con producto.precio.
CREATE TABLE venta_detalle (
    id_venta         VARCHAR(20)    NOT NULL,
    id_producto      VARCHAR(20)    NOT NULL,
    cantidad         DECIMAL(10,2)  NOT NULL,
    precio_unitario  DECIMAL(10,2)  NOT NULL,
 
    CONSTRAINT PK_venta_detalle PRIMARY KEY (id_venta, id_producto),
 
    CONSTRAINT CK_venta_detalle_cantidad CHECK (cantidad > 0),
    CONSTRAINT CK_venta_detalle_precio   CHECK (precio_unitario >= 0),