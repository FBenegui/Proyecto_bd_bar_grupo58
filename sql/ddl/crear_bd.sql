CREATE DATABASE Gestion_Bar;

-- ============================================================
-- 1. DDL de PERSONAS y USUARIOS
--    (persona, cliente, ubicacion, usuario, rol
--     + relaciones necesarias)
-- ============================================================

    -- ------------------------------------------------------------
    -- Tabla PERSONA (entidad base)
    -- ------------------------------------------------------------
    CREATE TABLE IF NOT EXISTS persona (
        id_persona       SERIAL          PRIMARY KEY,
        dni              VARCHAR(20)     NOT NULL UNIQUE,
        nombre           VARCHAR(80)     NOT NULL,
        apellido         VARCHAR(80)     NOT NULL,
        email_personal   VARCHAR(120),
        telefono         VARCHAR(30)
    );

    COMMENT ON TABLE  persona                IS 'Datos personales base (clientes y usuarios heredan de aquí)';
    COMMENT ON COLUMN persona.id_persona     IS 'Identificador único de la persona';
    COMMENT ON COLUMN persona.dni            IS 'Documento Nacional de Identidad (único)';
    COMMENT ON COLUMN persona.email_personal IS 'Correo electrónico personal';
    COMMENT ON COLUMN persona.telefono       IS 'Teléfono de contacto';

    -- ------------------------------------------------------------
    -- Tabla ROL
    -- ------------------------------------------------------------
    CREATE TABLE IF NOT EXISTS rol (
        id_rol           SERIAL          PRIMARY KEY,
        nombre_rol       VARCHAR(50)     NOT NULL UNIQUE
    );

    COMMENT ON TABLE  rol              IS 'Roles del sistema (Administrador, Cajero, Mozo, etc.)';
    COMMENT ON COLUMN rol.id_rol       IS 'Identificador único del rol';
    COMMENT ON COLUMN rol.nombre_rol   IS 'Nombre del rol';

    -- ------------------------------------------------------------
    -- Tabla USUARIO  (especialización de Persona - relación Es_un)
    --    + relación Asignado_a con Rol
    -- ------------------------------------------------------------
    CREATE TABLE IF NOT EXISTS usuario (
        id_usuario       INTEGER         PRIMARY KEY,          -- mismo id que persona (1:1)
        email_empresa    VARCHAR(120)    NOT NULL UNIQUE,
        clave            VARCHAR(255)    NOT NULL,             -- idealmente hash
        id_rol           INTEGER         NOT NULL,
        
        CONSTRAINT fk_usuario_persona
            FOREIGN KEY (id_usuario)
            REFERENCES persona (id_persona)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
            
        CONSTRAINT fk_usuario_rol
            FOREIGN KEY (id_rol)
            REFERENCES rol (id_rol)
            ON DELETE RESTRICT
            ON UPDATE CASCADE
    );
    COMMENT ON TABLE  usuario              IS 'Usuarios del sistema (empleados). Especialización de Persona (Es_un)';
    COMMENT ON COLUMN usuario.id_usuario   IS 'PK/FK hacia persona (relación 1:1 Es_un)';
    COMMENT ON COLUMN usuario.email_empresa IS 'Correo corporativo del usuario';
    COMMENT ON COLUMN usuario.clave         IS 'Contraseña (almacenar hasheada en producción)';
    COMMENT ON COLUMN usuario.id_rol       IS 'FK - rol asignado (relación Asignado_a)';

    -- ------------------------------------------------------------
    -- Tabla CLIENTE  (especialización de Persona - relación Es_un)
    -- ------------------------------------------------------------
    CREATE TABLE IF NOT EXISTS cliente (
        id_cliente       INTEGER         PRIMARY KEY,          -- mismo id que persona (1:1)
        fecha_registro   DATE            NOT NULL DEFAULT CURRENT_DATE,
        
        CONSTRAINT fk_cliente_persona
            FOREIGN KEY (id_cliente)
            REFERENCES persona (id_persona)
            ON DELETE CASCADE
            ON UPDATE CASCADE
    );

    COMMENT ON TABLE  cliente                IS 'Clientes del negocio. Especialización de Persona (Es_un)';
    COMMENT ON COLUMN cliente.id_cliente     IS 'PK/FK hacia persona (relación 1:1 Es_un)';
    COMMENT ON COLUMN cliente.fecha_registro IS 'Fecha en que el cliente se registró en el sistema';

    -- ------------------------------------------------------------
    -- Tabla UBICACION
    -- ------------------------------------------------------------
    CREATE TABLE IF NOT EXISTS ubicacion (
        id_ubicacion     SERIAL          PRIMARY KEY,
        nombre_ubicacion VARCHAR(80)     NOT NULL,
        capacidad        INTEGER         CHECK (capacidad > 0),
        tipo_ubicacion   VARCHAR(40)     NOT NULL               -- Salón, Terraza, Barra, Delivery, etc.
    );

    COMMENT ON TABLE  ubicacion                  IS 'Ubicaciones físicas o lógicas donde ocurren las ventas';
    COMMENT ON COLUMN ubicacion.id_ubicacion     IS 'Identificador único de la ubicación';
    COMMENT ON COLUMN ubicacion.nombre_ubicacion IS 'Nombre descriptivo (Mesa 5, Terraza, etc.)';
    COMMENT ON COLUMN ubicacion.capacidad        IS 'Capacidad de personas';
    COMMENT ON COLUMN ubicacion.tipo_ubicacion   IS 'Tipo: Salón, Terraza, Barra, Delivery, Take Away...';


-- ============================================================
-- 2. DDL de productos e ingredientes
--    (categoria, producto, ingrediente, producto_ingrediente)  
-- ============================================================ 


    -- ------------------------------------------------------------
    -- Tabla CATEGORIA
    -- ------------------------------------------------------------
    CREATE TABLE categoria (
        id_categoria INT IDENTITY(1,1) PRIMARY KEY,
        nombre_categoria VARCHAR(100) NOT NULL UNIQUE,
        fecha_creacion DATETIME NOT NULL DEFAULT GETDATE(),
        fecha_modificacion DATETIME,
        usuario_modificacion VARCHAR(50)
    );

    --------------------------------------------------------------
    -- Tabla PRODUCTO --------------------------------------------
    --------------------------------------------------------------
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

    --------------------------------------------------------------
    -- Tabla INGREDIENTE
    --------------------------------------------------------------
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

    --------------------------------------------------------------
    -- Tabla PRODUCTO_INGREDIENTE
    --------------------------------------------------------------
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


-- ============================================================
-- 4. MÓDULO VENTAS - DDL (SQL Server / SSMS)
--    Solo: venta y venta_detalle*/
-- ============================================================

    -- ------------------------------------------------------------
    -- Tabla VENTA
    -- cliente, ubicacion y mesero son NULL porque puede haber ventas de
    -- mostrador / consumidor final / para llevar sin mesero ni mesa.
    ------------------------------------------------------------
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
    
    -- ------------------------------------------------------------
    -- Tabla VENTA_DETALLE  (PK compuesta: una línea por producto en cada venta)
    -- Sin campo subtotal: se calcula (cantidad * precio_unitario) -> 3FN
    -- precio_unitario guarda el precio AL MOMENTO de la venta (historial),
    -- por eso no es redundante con producto.precio.
    -- ------------------------------------------------------------
    CREATE TABLE venta_detalle (
        id_venta         VARCHAR(20)    NOT NULL,
        id_producto      VARCHAR(20)    NOT NULL,
        cantidad         DECIMAL(10,2)  NOT NULL,
        precio_unitario  DECIMAL(10,2)  NOT NULL,
    
        CONSTRAINT PK_venta_detalle PRIMARY KEY (id_venta, id_producto),
    
        CONSTRAINT CK_venta_detalle_cantidad CHECK (cantidad > 0),
        CONSTRAINT CK_venta_detalle_precio   CHECK (precio_unitario >= 0),