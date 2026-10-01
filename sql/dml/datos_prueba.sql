-- Tabla ROL
SET IDENTITY_INSERT rol ON;
INSERT INTO rol (id_rol, nombre_rol) VALUES
    (1, 'Administrador'), (2, 'Gerente'), (3, 'Cajero'), (4, 'Mozo'),
    (5, 'Cocinero'), (6, 'Bartender'), (7, 'Encargado de depósito'), (8, 'Delivery');
SET IDENTITY_INSERT rol OFF;

-- Tabla PERSONA
SET IDENTITY_INSERT persona ON;
INSERT INTO persona (id_persona, dni, nombre, apellido, email_personal, telefono) VALUES
    -- Usuarios (empleados)
    (1, '30111222', 'María', 'González', 'maria.gonzalez@gmail.com', '11-5555-1001'),
    (2, '28999888', 'Carlos', 'Rodríguez', 'carlos.rod@gmail.com', '11-5555-1002'),
    (3, '32555666', 'Lucía', 'Fernández', 'lucia.fer@hotmail.com', '11-5555-1003'),
    (4, '27888777', 'Martín', 'López', 'martin.lopez@yahoo.com', '11-5555-1004'),
    (5, '33444555', 'Valentina', 'Martínez', 'vale.martinez@gmail.com', '11-5555-1005'),
    (6, '25666777', 'Diego', 'Pérez', 'diego.perez@outlook.com', '11-5555-1006'),
    (7, '31222333', 'Sofía', 'Sánchez', 'sofia.sanchez@gmail.com', '11-5555-1007'),
    (8, '26777888', 'Julián', 'Ramírez', 'julian.ramirez@gmail.com', '11-5555-1008'),
    (9, '34555666', 'Camila', 'Torres', 'camila.torres@hotmail.com', '11-5555-1009'),
    (10, '29111222', 'Nicolás', 'Flores', 'nico.flores@gmail.com', '11-5555-1010'),
    -- Clientes
    (11, '40111222', 'Ana', 'Silva', 'ana.silva@gmail.com', '11-5555-2001'),
    (12, '41222333', 'Pedro', 'Acosta', 'pedro.acosta@hotmail.com', '11-5555-2002'),
    (13, '42333444', 'Laura', 'Benítez', 'laura.benitez@yahoo.com', '11-5555-2003'),
    (14, '43444555', 'Jorge', 'Castro', 'jorge.castro@gmail.com', '11-5555-2004'),
    (15, '44555666', 'Mariana', 'Díaz', 'mariana.diaz@outlook.com', '11-5555-2005'),
    (16, '45666777', 'Fernando', 'Giménez', 'fer.gimenez@gmail.com', '11-5555-2006'),
    (17, '46777888', 'Carolina', 'Herrera', 'caro.herrera@hotmail.com', '11-5555-2007'),
    (18, '47888999', 'Ricardo', 'Ibarra', 'ricardo.ibarra@gmail.com', '11-5555-2008'),
    (19, '48999000', 'Paula', 'Jiménez', 'paula.jimenez@yahoo.com', '11-5555-2009'),
    (20, '49000111', 'Andrés', 'Keller', 'andres.keller@gmail.com', '11-5555-2010');
SET IDENTITY_INSERT persona OFF;

-- Tabla USUARIO
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
    (10, 'nicolas.flores@empresa.com',  'hash$caja555',      3);  -- Cajero

-- Tabla CLIENTE
INSERT INTO cliente (id_cliente, fecha_registro) VALUES
    (11, '2025-01-15'), (12, '2025-02-20'), (13, '2025-03-10'), (14, '2025-04-05'), (15, '2025-05-12'),
    (16, '2025-06-18'), (17, '2025-07-22'), (18, '2025-08-30'), (19, '2025-09-05'), (20, '2025-09-15');

-- Tabla UBICACION
SET IDENTITY_INSERT ubicacion ON;
INSERT INTO ubicacion (id_ubicacion, nombre_ubicacion, capacidad, tipo_ubicacion) VALUES
    (1, 'Mesa 1', 4, 'Salón'), (2, 'Mesa 2', 4, 'Salón'), (3, 'Mesa 3', 6, 'Salón'),
    (4, 'Mesa 4', 2, 'Salón'), (5, 'Mesa 5', 8, 'Salón'), (6, 'Terraza 1', 6, 'Terraza'),
    (7, 'Terraza 2', 4, 'Terraza'), (8, 'Barra Principal', 10, 'Barra'),
    (9, 'Salón VIP', 12, 'Salón'), (10, 'Zona Delivery', NULL, 'Delivery');
SET IDENTITY_INSERT ubicacion OFF;

-- Tabla CATEGORIA
SET IDENTITY_INSERT categoria ON;
INSERT INTO categoria (id_categoria, nombre_categoria, usuario_modificacion) VALUES
    (1, 'Botellas', 'admin'), (2, 'Cócteles', 'admin'), (3, 'Bebidas sin alcohol', 'admin'),
    (4, 'Cervezas Tiradas', 'admin'), (5, 'Tragos Directos', 'admin'), (6, 'Vinos y Espumantes', 'admin'),
    (7, 'Cafetería', 'admin'), (8, 'Para Picar', 'admin');
SET IDENTITY_INSERT categoria OFF;

-- Tabla PRODUCTO
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

-- Tabla INGREDIENTE
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

-- Tabla PRODUCTO_INGREDIENTE
INSERT INTO producto_ingrediente (id_producto, id_ingrediente, cantidad_necesaria) VALUES
    -- Receta: Fernet con Coca (Producto 4)
    (4, 1, 60.00), (4, 2, 240.00), (4, 7, 4.00),
    -- Receta: Gin Tonic (Producto 5)
    (5, 3, 60.00), (5, 4, 200.00), (5, 7, 5.00),
    -- Receta: Mojito Clásico (Producto 6)
    (6, 5, 60.00), (6, 6, 30.00), (6, 10, 8.00), (6, 7, 4.00),
    -- Receta: Campari Orange (Producto 7)
    (7, 8, 60.00), (7, 9, 200.00), (7, 7, 4.00);

-- Tabla METODO_PAGO
SET IDENTITY_INSERT metodo_pago ON;
INSERT INTO metodo_pago (id_metodo_pago, nombre_metodo) VALUES
    (1, 'Efectivo'), (2, 'Tarjeta de débito'), (3, 'Tarjeta de crédito'),
    (4, 'Transferencia bancaria'), (5, 'Mercado Pago'), (6, 'QR / Billetera virtual'),
    (7, 'Pago en cuotas'), (8, 'Cheque'), (9, 'Vale de comida'), (10, 'Cuenta corriente');
SET IDENTITY_INSERT metodo_pago OFF;

-- Tabla RECETA
INSERT INTO receta (id_producto, preparacion) VALUES
    (4, '1. Llenar el vaso largo con hielo. 2. Servir el Fernet Branca. 3. Completar suavemente con Coca-Cola. 4. Revolver levemente.'),
    (5, '1. Llenar el copón con hielo. 2. Agregar Gin. 3. Completar con agua tónica. 4. Perfumar y decorar con rodaja de limón.'),
    (6, '1. Macerar en el vaso menta y jugo de limón. 2. Llenar con hielo. 3. Agregar Ron Blanco. 4. Completar con soda y decorar.'),
    (7, '1. Llenar el vaso de trago largo con hielo. 2. Verter el Campari. 3. Completar con jugo de naranja. 4. Revolver suavemente.'),
    (1, '1. Llevar la botella cerrada a la mesa. 2. Entregar junto con hielera, pinzas y dos vasos de trago largo.'),
    (8, '1. Servir en vaso de trago largo. 2. Agregar 2 cubos de hielo. 3. Decorar con una rodaja de limón opcional.'),
    (9, '1. Entregar la botella fría. 2. Acompañar con vaso de vidrio limpio sin hielo a menos que el cliente lo solicite.'),
    (10, '1. Servir desde el grifo inclinando el vaso a 45 grados. 2. Enderezar al final para dejar exactamente dos dedos de espuma.');

-- Tabla VENTA
SET IDENTITY_INSERT venta ON;
INSERT INTO venta (id_venta, fecha_hora, estado_venta, modalidad_consumo, id_cliente, id_ubicacion, id_metodo_pago, id_cajero, id_mesero, usuario_modificacion) VALUES
    (1, '2026-09-24 20:30:00', 'PAGADA',    'EN_LOCAL',    11,   1,    1, 3,  4,    'admin'),  -- Mesa 1, cliente registrado
    (2, '2026-09-24 22:15:00', 'PAGADA',    'EN_LOCAL',    NULL, 6,    2, 3,  9,    'admin'),  -- Terraza 1, consumidor final
    (3, '2026-09-25 21:00:00', 'PAGADA',    'EN_LOCAL',    12,   3,    2, 10, 4,    'admin'),  -- Mesa 3, botella en mesa
    (4, '2026-09-26 23:10:00', 'PAGADA',    'EN_LOCAL',    NULL, 8,    1, 10, NULL, 'admin'),  -- Barra, atendida sin mozo
    (5, '2026-09-27 19:40:00', 'PAGADA',    'PARA_LLEVAR', 13,   NULL, 3, 3,  NULL, 'admin'),  -- Para llevar
    (6, '2026-09-28 21:30:00', 'CANCELADA', 'EN_LOCAL',    14,   2,    1, 3,  9,    'admin'),  -- Mesa 2, cancelada
    (7, '2026-09-29 22:00:00', 'PAGADA',    'EN_LOCAL',    15,   9,    2, 10, 4,    'admin'),  -- Salón VIP, grupo grande
    (8, '2026-09-30 20:45:00', 'PENDIENTE', 'EN_LOCAL',    16,   7,    1, 3,  9,    'admin'),  -- Terraza 2, mesa abierta
    (9, '2026-09-30 21:20:00', 'PAGADA',    'DELIVERY',    17,   10,   3, 10, NULL, 'admin');  -- Zona Delivery
SET IDENTITY_INSERT venta OFF;

-- Tabla VENTA_DETALLE
INSERT INTO venta_detalle (id_venta, id_producto, cantidad, precio_unitario) VALUES
    -- Venta 1: Mesa 1
    (1, 4,  2, 4500.00),   -- 2 Fernet con Coca
    (1, 5,  1, 5200.00),   -- 1 Gin Tonic
    (1, 9,  1, 1500.00),   -- 1 Agua Mineral

    -- Venta 2: Terraza 1
    (2, 6,  2, 5500.00),   -- 2 Mojitos
    (2, 10, 2, 3500.00),   -- 2 Pintas IPA

    -- Venta 3: Mesa 3 (botella para compartir)
    (3, 1,  1, 12000.00),  -- 1 Botella Fernet Branca
    (3, 8,  4, 2000.00),   -- 4 Coca-Cola
    (3, 9,  2, 1500.00),   -- 2 Agua Mineral

    -- Venta 4: Barra
    (4, 10, 3, 3500.00),   -- 3 Pintas IPA
    (4, 4,  2, 4500.00),   -- 2 Fernet con Coca

    -- Venta 5: Para llevar
    (5, 2,  1, 9500.00),   -- 1 Botella Smirnoff
    (5, 8,  2, 2000.00),   -- 2 Coca-Cola

    -- Venta 6: Mesa 2 (cancelada)
    (6, 5,  2, 5200.00),   -- 2 Gin Tonic
    (6, 7,  1, 4800.00),   -- 1 Campari Orange

    -- Venta 7: Salón VIP (grupo grande)
    (7, 1,  1, 12000.00),  -- 1 Botella Fernet Branca
    (7, 3,  1, 10500.00),  -- 1 Botella Campari
    (7, 8,  6, 2000.00),   -- 6 Coca-Cola

    -- Venta 8: Terraza 2 (pendiente)
    (8, 6,  2, 5500.00),   -- 2 Mojitos
    (8, 5,  1, 5200.00),   -- 1 Gin Tonic
    (8, 9,  1, 1500.00),   -- 1 Agua Mineral

    -- Venta 9: Delivery
    (9, 4,  3, 4500.00),   -- 3 Fernet con Coca
    (9, 8,  2, 2000.00);   -- 2 Coca-Cola