-- ============================================================
-- 3. DDL + DML de RECETAS y MÉTODOS DE PAGO
--    + tablas faltantes necesarias para que el script sea
--      autocontenido y las FK funcionen
--    Mínimo 8 registros por tabla de datos
-- ============================================================

-- ------------------------------------------------------------
-- 0. TABLAS PADRE / RELACIONADAS (necesarias para las FK)
-- ------------------------------------------------------------

-- Tabla PRODUCTO (necesaria para la relación Posee con Receta
-- y para Compuesto_por con Ingrediente)
CREATE TABLE IF NOT EXISTS producto (
    id_producto      SERIAL          PRIMARY KEY,
    nombre           VARCHAR(100)    NOT NULL,
    descripcion      TEXT,
    precio           NUMERIC(10,2)   NOT NULL CHECK (precio >= 0),
    stock            INTEGER         NOT NULL DEFAULT 0 CHECK (stock >= 0),
    stock_minimo     INTEGER         NOT NULL DEFAULT 0 CHECK (stock_minimo >= 0),
    imagen           VARCHAR(255)    -- ruta o nombre de archivo (opcional)
);

COMMENT ON TABLE  producto              IS 'Productos disponibles para la venta';
COMMENT ON COLUMN producto.id_producto  IS 'Identificador único del producto';
COMMENT ON COLUMN producto.nombre       IS 'Nombre del producto';
COMMENT ON COLUMN producto.precio       IS 'Precio de venta unitario';
COMMENT ON COLUMN producto.stock        IS 'Stock actual disponible';
COMMENT ON COLUMN producto.stock_minimo IS 'Nivel mínimo de stock para alerta';


-- Tabla INGREDIENTE (necesaria para la composición de la receta)
CREATE TABLE IF NOT EXISTS ingrediente (
    id_ingrediente   SERIAL          PRIMARY KEY,
    nombre           VARCHAR(100)    NOT NULL,
    unidad_medida    VARCHAR(30)     NOT NULL,  -- gramos, ml, unidades, etc.
    stock            NUMERIC(10,2)   NOT NULL DEFAULT 0 CHECK (stock >= 0),
    stock_minimo     NUMERIC(10,2)   NOT NULL DEFAULT 0 CHECK (stock_minimo >= 0)
);

COMMENT ON TABLE  ingrediente               IS 'Ingredientes utilizados en las recetas';
COMMENT ON COLUMN ingrediente.id_ingrediente IS 'Identificador único del ingrediente';
COMMENT ON COLUMN ingrediente.unidad_medida  IS 'Unidad de medida (g, ml, u, etc.)';


-- Tabla de relación COMPUESTO_POR (Producto N:M Ingrediente)
-- Atributo de relación: cantidad_necesaria
CREATE TABLE IF NOT EXISTS compuesto_por (
    id_producto          INTEGER         NOT NULL,
    id_ingrediente       INTEGER         NOT NULL,
    cantidad_necesaria   NUMERIC(10,2)   NOT NULL CHECK (cantidad_necesaria > 0),
    
    PRIMARY KEY (id_producto, id_ingrediente),
    
    CONSTRAINT fk_compuesto_producto
        FOREIGN KEY (id_producto)
        REFERENCES producto (id_producto)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
        
    CONSTRAINT fk_compuesto_ingrediente
        FOREIGN KEY (id_ingrediente)
        REFERENCES ingrediente (id_ingrediente)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

COMMENT ON TABLE  compuesto_por                    IS 'Relación N:M Producto-Ingrediente (Compuesto_por)';
COMMENT ON COLUMN compuesto_por.cantidad_necesaria IS 'Cantidad del ingrediente necesaria para el producto';


-- Tabla VENTA (necesaria para la relación Abona con Metodo_pago)
CREATE TABLE IF NOT EXISTS venta (
    id_venta             SERIAL          PRIMARY KEY,
    fecha_hora           TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado_venta         VARCHAR(30)     NOT NULL DEFAULT 'Pendiente',
    total_venta          NUMERIC(12,2)   NOT NULL CHECK (total_venta >= 0),
    modalidad_consumo    VARCHAR(30),    -- local, take-away, delivery, etc.
    id_metodo_pago       INTEGER         -- FK se agrega después de crear metodo_pago
);

COMMENT ON TABLE  venta                  IS 'Ventas realizadas';
COMMENT ON COLUMN venta.estado_venta     IS 'Estado: Pendiente, Completada, Cancelada, etc.';
COMMENT ON COLUMN venta.modalidad_consumo IS 'Forma de consumo: Local, Para llevar, Delivery...';


-- ------------------------------------------------------------
-- 1. Tabla METODO_PAGO
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS metodo_pago (
    id_metodo_pago   SERIAL          PRIMARY KEY,
    nombre_metodo    VARCHAR(50)     NOT NULL UNIQUE
);

COMMENT ON TABLE  metodo_pago                IS 'Métodos de pago disponibles en el sistema';
COMMENT ON COLUMN metodo_pago.id_metodo_pago IS 'Identificador único del método de pago';
COMMENT ON COLUMN metodo_pago.nombre_metodo  IS 'Nombre del método (Efectivo, Tarjeta, etc.)';


-- ------------------------------------------------------------
-- 2. Tabla RECETA  (relación Posee 1:1 con Producto)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS receta (
    id_producto      INTEGER         PRIMARY KEY,
    preparacion      TEXT            NOT NULL,
    
    CONSTRAINT fk_receta_producto
        FOREIGN KEY (id_producto)
        REFERENCES producto (id_producto)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

COMMENT ON TABLE  receta                IS 'Receta asociada a un producto (relación Posee 1:1)';
COMMENT ON COLUMN receta.id_producto    IS 'PK/FK - identifica la receta con el producto';
COMMENT ON COLUMN receta.preparacion    IS 'Instrucciones de preparación del producto';


-- ------------------------------------------------------------
-- 3. FK de VENTA hacia METODO_PAGO (relación Abona)
-- ------------------------------------------------------------
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'fk_venta_metodo_pago'
    ) THEN
        ALTER TABLE venta
            ADD CONSTRAINT fk_venta_metodo_pago
                FOREIGN KEY (id_metodo_pago)
                REFERENCES metodo_pago (id_metodo_pago)
                ON DELETE RESTRICT
                ON UPDATE CASCADE;
    END IF;
END $$;

COMMENT ON COLUMN venta.id_metodo_pago IS 'FK - método de pago con el que se abonó la venta (relación Abona)';


-- ============================================================
-- DML - Datos de ejemplo (mínimo 8 registros por tabla)
-- ============================================================

-- ------------------------------------------------------------
-- Productos (10 registros) - necesarios para las recetas
-- ------------------------------------------------------------
INSERT INTO producto (nombre, descripcion, precio, stock, stock_minimo) VALUES
    ('Torta de Chocolate',     'Torta húmeda de chocolate con cobertura',           4500.00, 12, 3),
    ('Hamburguesa Clásica',    'Hamburguesa con carne, lechuga, tomate y queso',    3200.00, 25, 5),
    ('Spaghetti Bolognesa',    'Pasta con salsa bolognesa casera',                  2800.00, 18, 4),
    ('Ensalada César',         'Lechuga, croutons, pollo y aderezo césar',          2500.00, 15, 3),
    ('Pizza Muzzarella',       'Pizza tradicional con muzzarella y orégano',        3800.00, 20, 4),
    ('Arroz con Pollo',        'Arroz salteado con pollo y verduras',               2700.00, 14, 3),
    ('Omelette Jamón y Queso', 'Omelette relleno de jamón y queso',                 2200.00, 10, 2),
    ('Café Latte',             'Espresso con leche vaporizada',                      1500.00, 50, 10),
    ('Yogur con Frutas',       'Yogur natural con frutas de estación y granola',    1800.00, 22, 5),
    ('Bife de Chorizo',        'Bife de chorizo a la parrilla con guarnición',       5500.00,  8, 2)
ON CONFLICT DO NOTHING;


-- ------------------------------------------------------------
-- Ingredientes (10 registros)
-- ------------------------------------------------------------
INSERT INTO ingrediente (nombre, unidad_medida, stock, stock_minimo) VALUES
    ('Harina 000',             'gramos',   5000, 1000),
    ('Azúcar',                 'gramos',   3000,  500),
    ('Huevos',                 'unidades',  120,   30),
    ('Carne picada',           'gramos',   4000,  800),
    ('Queso muzzarella',       'gramos',   2500,  500),
    ('Fideos spaghetti',       'gramos',   3000,  600),
    ('Pollo',                  'gramos',   3500,  700),
    ('Lechuga',                'unidades',   40,   10),
    ('Café en grano',          'gramos',   2000,  400),
    ('Leche',                  'ml',       8000, 1500)
ON CONFLICT DO NOTHING;


-- ------------------------------------------------------------
-- Composición de productos (Compuesto_por) - 12 registros
-- ------------------------------------------------------------
INSERT INTO compuesto_por (id_producto, id_ingrediente, cantidad_necesaria) VALUES
    -- Torta de Chocolate
    (1, 1, 300),   -- Harina
    (1, 2, 200),   -- Azúcar
    (1, 3,   4),   -- Huevos
    -- Hamburguesa Clásica
    (2, 4, 150),   -- Carne picada
    (2, 5,  50),   -- Queso
    -- Spaghetti Bolognesa
    (3, 6, 200),   -- Fideos
    (3, 4, 120),   -- Carne picada
    -- Ensalada César
    (4, 8,   1),   -- Lechuga
    (4, 7, 100),   -- Pollo
    -- Pizza Muzzarella
    (5, 1, 250),   -- Harina (masa)
    (5, 5, 200),   -- Queso
    -- Café Latte
    (8, 9,  18),   -- Café
    (8, 10, 200)   -- Leche
ON CONFLICT DO NOTHING;


-- ------------------------------------------------------------
-- Métodos de pago (10 registros)
-- ------------------------------------------------------------
INSERT INTO metodo_pago (nombre_metodo) VALUES
    ('Efectivo'),
    ('Tarjeta de débito'),
    ('Tarjeta de crédito'),
    ('Transferencia bancaria'),
    ('Mercado Pago'),
    ('QR / Billetera virtual'),
    ('Pago en cuotas'),
    ('Cheque'),
    ('Vale de comida'),
    ('Cuenta corriente')
ON CONFLICT (nombre_metodo) DO NOTHING;


-- ------------------------------------------------------------
-- Recetas (10 registros) - relación Posee 1:1 con Producto
-- ------------------------------------------------------------
INSERT INTO receta (id_producto, preparacion) VALUES
(1, '1. Precalentar el horno a 180°C.
2. Mezclar harina, azúcar y huevos hasta obtener una masa homogénea.
3. Verter en molde enmantecado.
4. Hornear 35-40 minutos o hasta que al insertar un palillo salga limpio.
5. Dejar enfriar antes de desmoldar.'),

(2, '1. Cocinar la carne a la plancha con sal y pimienta.
2. Tostar el pan.
3. Armar la hamburguesa: pan, lechuga, tomate, carne, queso y salsa especial.
4. Servir inmediatamente.'),

(3, '1. Hervir agua con sal.
2. Cocinar la pasta al dente (8-10 min).
3. Saltear ajo y aceite de oliva.
4. Mezclar la pasta con la salsa y terminar con queso rallado.'),

(4, '1. Lavar y cortar las verduras en trozos medianos.
2. Sofreír cebolla y ajo en aceite.
3. Agregar las verduras y cocinar a fuego medio 15 minutos.
4. Condimentar con sal, pimienta y hierbas.
5. Servir caliente.'),

(5, '1. Amasar la masa de pizza y estirarla.
2. Untar salsa de tomate.
3. Agregar mozzarella, jamón y orégano.
4. Hornear a 220°C durante 12-15 minutos.
5. Retirar y cortar en porciones.'),

(6, '1. Cocinar el arroz en agua con sal hasta que esté tierno.
2. Sofreír el pollo en cubos con especias.
3. Mezclar el arroz con el pollo y verduras salteadas.
4. Rectificar condimentos y servir.'),

(7, '1. Batir huevos con leche, sal y pimienta.
2. Calentar una sartén antiadherente con un poco de manteca.
3. Verter la mezcla y cocinar a fuego bajo.
4. Cuando esté casi cuajada, agregar relleno (jamón y queso).
5. Doblar y servir.'),

(8, '1. Preparar el café espresso.
2. Calentar y espumar la leche.
3. Verter el espresso en la taza.
4. Agregar la leche espumada con cuidado.
5. Decorar con cacao en polvo si se desea.'),

(9, '1. Licuar los ingredientes de la base hasta obtener una crema suave.
2. Verter en vasos o bowls.
3. Refrigerar al menos 2 horas.
4. Decorar con frutas frescas y granola antes de servir.'),

(10, '1. Marinar la carne con ajo, limón y especias durante 30 minutos.
2. Cocinar a la parrilla o plancha hasta el punto deseado.
3. Dejar reposar 5 minutos.
4. Cortar en tiras y servir con guarnición.')
ON CONFLICT (id_producto) DO NOTHING;


-- ------------------------------------------------------------
-- Ventas de ejemplo (10 registros) + asignación de método de pago
-- ------------------------------------------------------------
INSERT INTO venta (fecha_hora, estado_venta, total_venta, modalidad_consumo, id_metodo_pago) VALUES
    ('2026-09-20 12:30:00', 'Completada', 4500.00, 'Local',       1),  -- Efectivo
    ('2026-09-21 13:15:00', 'Completada', 3200.00, 'Para llevar', 2),  -- Débito
    ('2026-09-22 20:00:00', 'Completada', 7600.00, 'Local',       3),  -- Crédito
    ('2026-09-23 11:45:00', 'Completada', 2800.00, 'Delivery',    5),  -- Mercado Pago
    ('2026-09-24 19:20:00', 'Completada', 3800.00, 'Local',       6),  -- QR
    ('2026-09-25 14:00:00', 'Pendiente',  5500.00, 'Para llevar', 1),  -- Efectivo
    ('2026-09-26 18:30:00', 'Completada', 2700.00, 'Local',       4),  -- Transferencia
    ('2026-09-27 12:10:00', 'Completada', 2200.00, 'Local',       7),  -- Cuotas
    ('2026-09-28 16:45:00', 'Completada', 1500.00, 'Para llevar', 2),  -- Débito
    ('2026-09-29 21:00:00', 'Completada', 6300.00, 'Local',       5)   -- Mercado Pago
ON CONFLICT DO NOTHING;


-- ============================================================
-- Consultas de verificación
-- ============================================================
/*
SELECT * FROM metodo_pago ORDER BY id_metodo_pago;

SELECT r.id_producto, p.nombre, LEFT(r.preparacion, 60) || '...' AS preparacion
FROM   receta r
JOIN   producto p ON p.id_producto = r.id_producto
ORDER BY r.id_producto;

SELECT p.nombre AS producto, i.nombre AS ingrediente, cp.cantidad_necesaria, i.unidad_medida
FROM   compuesto_por cp
JOIN   producto p    ON p.id_producto    = cp.id_producto
JOIN   ingrediente i ON i.id_ingrediente = cp.id_ingrediente
ORDER BY p.nombre, i.nombre;

SELECT v.id_venta, v.fecha_hora, v.total_venta, v.estado_venta, mp.nombre_metodo
FROM   venta v
LEFT JOIN metodo_pago mp ON mp.id_metodo_pago = v.id_metodo_pago
ORDER BY v.id_venta;
*/
