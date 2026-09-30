-- ============================================================
-- 3. DDL + DML de RECETAS y MÉTODOS DE PAGO
--    (incluyendo las relaciones necesarias)
-- ============================================================

-- ------------------------------------------------------------
-- 1. Tabla METODO_PAGO
-- ------------------------------------------------------------
CREATE TABLE metodo_pago (
    id_metodo_pago   SERIAL          PRIMARY KEY,
    nombre_metodo    VARCHAR(50)     NOT NULL UNIQUE
);

COMMENT ON TABLE  metodo_pago              IS 'Métodos de pago disponibles en el sistema';
COMMENT ON COLUMN metodo_pago.id_metodo_pago IS 'Identificador único del método de pago';
COMMENT ON COLUMN metodo_pago.nombre_metodo  IS 'Nombre del método (Efectivo, Tarjeta, Transferencia, etc.)';


-- ------------------------------------------------------------
-- 2. Tabla RECETA  (relación Posee 1:1 con Producto)
--    - id_producto es PK y FK hacia producto
-- ------------------------------------------------------------
CREATE TABLE receta (
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
-- 3. Relación necesaria en VENTA (Abona)
--    Se agrega la FK hacia metodo_pago
--    (asumiendo que la tabla venta ya existe)
-- ------------------------------------------------------------
ALTER TABLE venta
    ADD COLUMN id_metodo_pago INTEGER;

ALTER TABLE venta
    ADD CONSTRAINT fk_venta_metodo_pago
        FOREIGN KEY (id_metodo_pago)
        REFERENCES metodo_pago (id_metodo_pago)
        ON DELETE RESTRICT
        ON UPDATE CASCADE;

COMMENT ON COLUMN venta.id_metodo_pago IS 'FK - método de pago con el que se abonó la venta (relación Abona)';


-- ============================================================
-- DML - Datos de ejemplo
-- ============================================================

-- Métodos de pago
INSERT INTO metodo_pago (nombre_metodo) VALUES
    ('Efectivo'),
    ('Tarjeta de débito'),
    ('Tarjeta de crédito'),
    ('Transferencia bancaria'),
    ('Mercado Pago'),
    ('QR / Billetera virtual');


-- Recetas (solo se insertan si ya existen los productos correspondientes)
-- Ejemplo: se asume que ya hay productos con id 1, 2 y 3

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
4. Mezclar la pasta con la salsa y terminar con queso rallado.');


-- Ejemplo de actualización de ventas ya existentes
-- (asigna métodos de pago a ventas)
UPDATE venta SET id_metodo_pago = 1 WHERE id_venta = 1;  -- Efectivo
UPDATE venta SET id_metodo_pago = 2 WHERE id_venta = 2;  -- Tarjeta de débito
UPDATE venta SET id_metodo_pago = 5 WHERE id_venta = 3;  -- Mercado Pago


