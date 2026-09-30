-- ============================================================
-- 1. DDL + DML de PERSONAS y USUARIOS
--    (persona, cliente, ubicacion, usuario, rol
--     + relaciones necesarias)
--    Mínimo 8 registros por tabla de datos
-- ============================================================

-- ------------------------------------------------------------
-- 1. Tabla PERSONA (entidad base)
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
-- 2. Tabla ROL
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS rol (
    id_rol           SERIAL          PRIMARY KEY,
    nombre_rol       VARCHAR(50)     NOT NULL UNIQUE
);

COMMENT ON TABLE  rol              IS 'Roles del sistema (Administrador, Cajero, Mozo, etc.)';
COMMENT ON COLUMN rol.id_rol       IS 'Identificador único del rol';
COMMENT ON COLUMN rol.nombre_rol   IS 'Nombre del rol';


-- ------------------------------------------------------------
-- 3. Tabla USUARIO  (especialización de Persona - relación Es_un)
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
-- 4. Tabla CLIENTE  (especialización de Persona - relación Es_un)
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
-- 5. Tabla UBICACION
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
-- DML - Datos de ejemplo (mínimo 8 registros por tabla)
-- ============================================================

-- ------------------------------------------------------------
-- Roles (8 registros)
-- ------------------------------------------------------------
INSERT INTO rol (nombre_rol) VALUES
    ('Administrador'),
    ('Gerente'),
    ('Cajero'),
    ('Mozo'),
    ('Cocinero'),
    ('Bartender'),
    ('Encargado de depósito'),
    ('Delivery')
ON CONFLICT (nombre_rol) DO NOTHING;


-- ------------------------------------------------------------
-- Personas (20 registros: 10 serán usuarios + 10 serán clientes)
-- ------------------------------------------------------------
INSERT INTO persona (dni, nombre, apellido, email_personal, telefono) VALUES
    -- Usuarios (empleados)
    ('30111222', 'María',    'González',  'maria.gonzalez@gmail.com',  '11-5555-1001'),
    ('28999888', 'Carlos',   'Rodríguez', 'carlos.rod@gmail.com',      '11-5555-1002'),
    ('32555666', 'Lucía',    'Fernández', 'lucia.fer@hotmail.com',     '11-5555-1003'),
    ('27888777', 'Martín',   'López',     'martin.lopez@yahoo.com',    '11-5555-1004'),
    ('33444555', 'Valentina','Martínez',  'vale.martinez@gmail.com',   '11-5555-1005'),
    ('25666777', 'Diego',    'Pérez',     'diego.perez@outlook.com',   '11-5555-1006'),
    ('31222333', 'Sofía',    'Sánchez',   'sofia.sanchez@gmail.com',   '11-5555-1007'),
    ('26777888', 'Julián',   'Ramírez',   'julian.ramirez@gmail.com',  '11-5555-1008'),
    ('34555666', 'Camila',   'Torres',    'camila.torres@hotmail.com', '11-5555-1009'),
    ('29111222', 'Nicolás',  'Flores',    'nico.flores@gmail.com',     '11-5555-1010'),
    -- Clientes
    ('40111222', 'Ana',      'Silva',     'ana.silva@gmail.com',       '11-5555-2001'),
    ('41222333', 'Pedro',    'Acosta',    'pedro.acosta@hotmail.com',  '11-5555-2002'),
    ('42333444', 'Laura',    'Benítez',   'laura.benitez@yahoo.com',   '11-5555-2003'),
    ('43444555', 'Jorge',    'Castro',    'jorge.castro@gmail.com',    '11-5555-2004'),
    ('44555666', 'Mariana',  'Díaz',      'mariana.diaz@outlook.com',  '11-5555-2005'),
    ('45666777', 'Fernando', 'Giménez',   'fer.gimenez@gmail.com',     '11-5555-2006'),
    ('46777888', 'Carolina', 'Herrera',   'caro.herrera@hotmail.com',  '11-5555-2007'),
    ('47888999', 'Ricardo',  'Ibarra',    'ricardo.ibarra@gmail.com',  '11-5555-2008'),
    ('48999000', 'Paula',    'Jiménez',   'paula.jimenez@yahoo.com',   '11-5555-2009'),
    ('49000111', 'Andrés',   'Keller',    'andres.keller@gmail.com',   '11-5555-2010')
ON CONFLICT (dni) DO NOTHING;


-- ------------------------------------------------------------
-- Usuarios (10 registros) - relación Es_un + Asignado_a
-- id_usuario = id_persona de las primeras 10 personas
-- ------------------------------------------------------------
INSERT INTO usuario (id_usuario, email_empresa, clave, id_rol) VALUES
    (1,  'maria.gonzalez@empresa.com',  'hash$admin2024',    1),  -- Administrador
    (2,  'carlos.rodriguez@empresa.com','hash$gerente88',    2),  -- Gerente
    (3,  'lucia.fernandez@empresa.com', 'hash$caja123',      3),  -- Cajero
    (4,  'martin.lopez@empresa.com',    'hash$mozo456',      4),  -- Mozo
    (5,  'valentina.m@empresa.com',     'hash$cocina789',    5),  -- Cocinero
    (6,  'diego.perez@empresa.com',     'hash$bar321',       6),  -- Bartender
    (7,  'sofia.sanchez@empresa.com',   'hash$deposito654',  7),  -- Encargado de depósito
    (8,  'julian.ramirez@empresa.com',  'hash$delivery987',  8),  -- Delivery
    (9,  'camila.torres@empresa.com',   'hash$mozo222',      4),  -- Mozo
    (10, 'nicolas.flores@empresa.com',  'hash$caja555',      3)   -- Cajero
ON CONFLICT (id_usuario) DO NOTHING;


-- ------------------------------------------------------------
-- Clientes (10 registros) - relación Es_un
-- id_cliente = id_persona de las últimas 10 personas
-- ------------------------------------------------------------
INSERT INTO cliente (id_cliente, fecha_registro) VALUES
    (11, '2025-01-15'),
    (12, '2025-02-20'),
    (13, '2025-03-10'),
    (14, '2025-04-05'),
    (15, '2025-05-12'),
    (16, '2025-06-18'),
    (17, '2025-07-22'),
    (18, '2025-08-30'),
    (19, '2025-09-05'),
    (20, '2025-09-15')
ON CONFLICT (id_cliente) DO NOTHING;


-- ------------------------------------------------------------
-- Ubicaciones (10 registros)
-- ------------------------------------------------------------
INSERT INTO ubicacion (nombre_ubicacion, capacidad, tipo_ubicacion) VALUES
    ('Mesa 1',           4,  'Salón'),
    ('Mesa 2',           4,  'Salón'),
    ('Mesa 3',           6,  'Salón'),
    ('Mesa 4',           2,  'Salón'),
    ('Mesa 5',           8,  'Salón'),
    ('Terraza 1',        6,  'Terraza'),
    ('Terraza 2',        4,  'Terraza'),
    ('Barra Principal', 10,  'Barra'),
    ('Salón VIP',        12, 'Salón'),
    ('Zona Delivery',    NULL,'Delivery')
ON CONFLICT DO NOTHING;


-- ============================================================
-- Consultas de verificación
-- ============================================================
/*
-- Personas
SELECT * FROM persona ORDER BY id_persona;

-- Roles
SELECT * FROM rol ORDER BY id_rol;

-- Usuarios con su persona y rol
SELECT u.id_usuario, p.nombre, p.apellido, u.email_empresa, r.nombre_rol
FROM   usuario u
JOIN   persona p ON p.id_persona = u.id_usuario
JOIN   rol r     ON r.id_rol     = u.id_rol
ORDER BY u.id_usuario;

-- Clientes con sus datos personales
SELECT c.id_cliente, p.nombre, p.apellido, p.dni, c.fecha_registro, p.telefono
FROM   cliente c
JOIN   persona p ON p.id_persona = c.id_cliente
ORDER BY c.id_cliente;

-- Ubicaciones
SELECT * FROM ubicacion ORDER BY id_ubicacion;
*/
