-- Tabla CATEGORIA
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