
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