[pruebas-validacion.md](https://github.com/user-attachments/files/32884072/pruebas-validacion.md)
# Pruebas de Validación — Etapa III

Se probaron los distintos tipos de restricciones del modelo: para cada regla de negocio se plantea una operación válida y una inválida, y se analiza el resultado esperado.

## 1. Integridad de entidad (UNIQUE)

```sql
-- Válido
INSERT INTO persona (dni, nombre, apellido) VALUES ('50111222', 'Test', 'Uno');

-- Inválido: DNI repetido
INSERT INTO persona (dni, nombre, apellido) VALUES ('50111222', 'Test', 'Dos');
```
**Resultado esperado:** la segunda sentencia es rechazada por la restricción `UNIQUE` sobre `persona.dni`.

## 2. Integridad referencial (FOREIGN KEY)

```sql
-- Válido: categoría existente
INSERT INTO producto (nombre, precio, id_categoria) VALUES ('Nuevo trago', 5000, 1);

-- Inválido: categoría inexistente
INSERT INTO producto (nombre, precio, id_categoria) VALUES ('Nuevo trago', 5000, 999);
```
**Resultado esperado:** la segunda sentencia es rechazada por `fk_producto_categoria`, ya que no existe `id_categoria = 999`.

### 2.1 Comportamiento ON DELETE CASCADE

```sql
DELETE FROM persona WHERE id_persona = 1;
```
**Resultado esperado:** se elimina en cascada el `usuario` asociado a esa persona (`fk_usuario_persona ... ON DELETE CASCADE`), ya que no puede existir un usuario sin la persona que le da origen.

### 2.2 Comportamiento ON DELETE NO ACTION

```sql
-- Producto 4 (Fernet con Coca) tiene ventas registradas en venta_detalle
DELETE FROM producto WHERE id_producto = 4;
```
**Resultado esperado:** la sentencia es **rechazada**, porque existen filas en `venta_detalle` que referencian ese producto (`FK_venta_detalle_producto ... ON DELETE NO ACTION`). Esto evita perder el historial de ventas al intentar borrar un producto que ya fue vendido.

## 3. Reglas de dominio (CHECK)

```sql
-- Válido
INSERT INTO venta_detalle (id_venta, id_producto, cantidad, precio_unitario) VALUES (1, 1, 2, 12000);

-- Inválido: cantidad negativa
INSERT INTO venta_detalle (id_venta, id_producto, cantidad, precio_unitario) VALUES (1, 1, -2, 12000);
```
**Resultado esperado:** la segunda sentencia es rechazada por `CK_venta_detalle_cantidad`, que exige `cantidad > 0`.

```sql
-- Inválido: estado de venta no contemplado
UPDATE venta SET estado_venta = 'DEVUELTA' WHERE id_venta = 1;
```
**Resultado esperado:** rechazada por `CK_venta_estado`, que solo admite `'PENDIENTE'`, `'PAGADA'` o `'CANCELADA'`.

## 4. Nulidad (NOT NULL)

```sql
-- Inválido: venta sin método de pago
INSERT INTO venta (modalidad_consumo, id_metodo_pago, id_cajero) VALUES ('EN_LOCAL', NULL, 3);
```
**Resultado esperado:** rechazada, `venta.id_metodo_pago` es `NOT NULL`.

```sql
-- Válido: venta atendida en la barra, sin mesero
INSERT INTO venta (modalidad_consumo, id_metodo_pago, id_cajero, id_mesero) VALUES ('EN_LOCAL', 1, 10, NULL);
```
**Resultado esperado:** se acepta, ya que `id_mesero` admite `NULL` para los casos en que no interviene un mozo.

## 5. Valores por defecto (DEFAULT)

```sql
INSERT INTO venta (modalidad_consumo, id_metodo_pago, id_cajero) VALUES ('PARA_LLEVAR', 1, 3);
SELECT fecha_hora, estado_venta FROM venta WHERE id_venta = (SELECT MAX(id_venta) FROM venta);
```
**Resultado esperado:** `fecha_hora` toma el momento actual (`SYSDATETIME()`) y `estado_venta` queda en `'PENDIENTE'`, sin necesidad de especificarlos explícitamente en el INSERT.
