-- =========================================================================
-- DML de Personas y Usuarios - Datos de ejemplo (min 8 registros por tabla)
-- =========================================================================

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

-- =========================================================================
-- DML de Productos e Ingredientes - Datos de ejemplo
-- ========================================================================

    -- ------------------------------------------------------------
    -- Tabla CATEGORIA
    -- ------------------------------------------------------------
    SET IDENTITY_INSERT categoria ON;
    INSERT INTO categoria (id_categoria, nombre_categoria, usuario_modificacion) VALUES
        (1, 'Botellas', 'admin'),
        (2, 'Cócteles', 'admin'),
        (3, 'Bebidas sin alcohol', 'admin'),
        (4, 'Cervezas Tiradas', 'admin'),
        (5, 'Tragos Directos', 'admin'),
        (6, 'Vinos y Espumantes', 'admin'),
        (7, 'Cafetería', 'admin'),
        (8, 'Para Picar', 'admin');
    SET IDENTITY_INSERT categoria OFF;

    -- ------------------------------------------------------------
    -- Tabla PRODUCTO
    -- ------------------------------------------------------------
    SET IDENTITY_INSERT producto ON;
    INSERT INTO producto (id_producto, nombre, descripcion, precio, stock, stock_minimo, id_categoria, usuario_modificacion) VALUES
        (1, 'Botella Fernet Branca 750ml', 'Botella cerrada para venta en mesa', 12000.00, 15, 5, 1, 'admin'),
        (2, 'Botella Smirnoff 700ml', 'Botella cerrada de vodka tradicional', 9500.00, 10, 3, 1, 'admin'),
        (3, 'Botella Campari 750ml', 'Aperitivo clásico botella cerrada', 10500.00, 12, 4, 1, 'admin'),
        (4, 'Fernet con Coca', 'Trago directo clásico en vaso largo', 4500.00, 50, 10, 5, 'admin'),
        (5, 'Gin Tonic', 'Gin, agua tónica, rodaja de limón y hielo', 5200.00, 40, 10, 2, 'admin'),
        (6, 'Mojito Clásico', 'Ron blanco, menta, limón, soda y azúcar', 5500.00, 30, 5, 2, 'admin'),
        (7, 'Campari Orange', 'Campari con jugo de naranja natural', 4800.00, 35, 10, 5, 'admin'),
        (8, 'Coca-Cola 500ml', 'Gaseosa línea Coca-Cola en botella de vidrio', 2000.00, 100, 20, 3, 'admin'),
        (9, 'Agua Mineral 500ml', 'Agua sin gas', 1500.00, 80, 20, 3, 'admin'),
        (10, 'Pinta IPA', 'Cerveza artesanal India Pale Ale', 3500.00, 60, 15, 4, 'admin');
    SET IDENTITY_INSERT producto OFF;

    -- ------------------------------------------------------------
    -- Tabla INGREDIENTE
    -- ------------------------------------------------------------
    SET IDENTITY_INSERT ingrediente ON;
    INSERT INTO ingrediente (id_ingrediente, nombre, unidad_medida, stock, stock_minimo, usuario_modificacion) VALUES
    (1, 'Fernet Branca', 'ml', 5000, 1000, 'admin'),
    (2, 'Coca-Cola (Línea de barril)', 'ml', 20000, 5000, 'admin'),
    (3, 'Gin', 'ml', 4000, 700, 'admin'),
    (4, 'Agua Tónica', 'ml', 15000, 3000, 'admin'),
    (5, 'Ron Blanco', 'ml', 3000, 700, 'admin'),
    (6, 'Jugo de Limón', 'ml', 2000, 500, 'admin'),
    (7, 'Hielo', 'unidades', 10000, 2000, 'admin'),
    (8, 'Campari', 'ml', 3500, 750, 'admin'),
    (9, 'Jugo de Naranja', 'ml', 5000, 1000, 'admin'),
    (10, 'Menta Fresca', 'hojas', 500, 100, 'admin');
    SET IDENTITY_INSERT ingrediente OFF;

    -- ------------------------------------------------------------
    -- Tabla PRODUCTO_INGREDIENTE
    -- ------------------------------------------------------------
    INSERT INTO producto_ingrediente (id_producto, id_ingrediente, cantidad_necesaria) VALUES
        -- Receta: Fernet con Coca (Producto 4)
        (4, 1, 60.00),   -- 60 ml de Fernet
        (4, 2, 240.00),  -- 240 ml de Coca-Cola
        (4, 7, 4.00),    -- 4 cubos de hielo

        -- Receta: Gin Tonic (Producto 5)
        (5, 3, 60.00),   -- 60 ml de Gin
        (5, 4, 200.00),  -- 200 ml de Tónica
        (5, 7, 5.00),    -- 5 cubos de hielo

        -- Receta: Mojito Clásico (Producto 6)
        (6, 5, 60.00),   -- 60 ml de Ron Blanco
        (6, 6, 30.00),   -- 30 ml de Jugo de Limón
        (6, 10, 8.00),   -- 8 hojas de menta
        (6, 7, 4.00),    -- 4 cubos de hielo

        -- Receta: Campari Orange (Producto 7)
        (7, 8, 60.00),   -- 60 ml de Campari
        (7, 9, 200.00),  -- 200 ml de Jugo de Naranja
        (7, 7, 4.00);    -- 4 cubos de hielo