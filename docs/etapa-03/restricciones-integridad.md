[restricciones-integridad.md](https://github.com/user-attachments/files/32884041/restricciones-integridad.md)
# Restricciones de Integridad — Etapa III

Siguiendo la clasificación vista en la cátedra, las restricciones implementadas en `crear_bd.sql` se agrupan en: integridad de entidad, integridad referencial, reglas de dominio y nulidad/valores por defecto.

## Integridad de entidad (PRIMARY KEY / UNIQUE)

| Tabla | Clave primaria | Observación |
|---|---|---|
| persona | id_persona | IDENTITY |
| rol | id_rol | IDENTITY |
| ubicacion | id_ubicacion | IDENTITY |
| categoria | id_categoria | IDENTITY |
| ingrediente | id_ingrediente | IDENTITY |
| metodo_pago | id_metodo_pago | IDENTITY |
| producto | id_producto | IDENTITY |
| usuario | id_usuario | FK a persona (relación 1:1 Es_un) |
| cliente | id_cliente | FK a persona (relación 1:1 Es_un) |
| receta | id_producto | FK a producto (entidad débil, 1:1) |
| producto_ingrediente | (id_producto, id_ingrediente) | Clave compuesta |
| venta | id_venta | IDENTITY |
| venta_detalle | (id_venta, id_producto) | Clave compuesta (PK_venta_detalle) |

Restricciones `UNIQUE` adicionales (claves alternativas):
- `persona.dni`
- `usuario.email_empresa`
- `rol.nombre_rol`
- `categoria.nombre_categoria`
- `metodo_pago.nombre_metodo`

## Integridad referencial (FOREIGN KEY)

| FK | Columna | Referencia | ON DELETE | ON UPDATE |
|---|---|---|---|---|
| fk_usuario_persona | usuario.id_usuario | persona.id_persona | CASCADE | CASCADE |
| fk_usuario_rol | usuario.id_rol | rol.id_rol | NO ACTION | CASCADE |
| fk_cliente_persona | cliente.id_cliente | persona.id_persona | CASCADE | CASCADE |
| fk_producto_categoria | producto.id_categoria | categoria.id_categoria | NO ACTION | CASCADE |
| fk_receta_producto | receta.id_producto | producto.id_producto | CASCADE | CASCADE |
| fk_prod_ingred_producto | producto_ingrediente.id_producto | producto.id_producto | CASCADE | CASCADE |
| fk_prod_ingred_ingrediente | producto_ingrediente.id_ingrediente | ingrediente.id_ingrediente | NO ACTION | NO ACTION |
| FK_venta_cliente | venta.id_cliente | cliente.id_cliente | NO ACTION | CASCADE |
| FK_venta_ubicacion | venta.id_ubicacion | ubicacion.id_ubicacion | NO ACTION | CASCADE |
| FK_venta_metodo_pago | venta.id_metodo_pago | metodo_pago.id_metodo_pago | NO ACTION | CASCADE |
| FK_venta_cajero | venta.id_cajero | usuario.id_usuario | NO ACTION | NO ACTION |
| FK_venta_mesero | venta.id_mesero | usuario.id_usuario | NO ACTION | NO ACTION |
| FK_venta_detalle_venta | venta_detalle.id_venta | venta.id_venta | CASCADE | CASCADE |
| FK_venta_detalle_producto | venta_detalle.id_producto | producto.id_producto | NO ACTION | NO ACTION |

### Criterio de las acciones CASCADE / NO ACTION
- Se usa **CASCADE** cuando la tabla hija no tiene sentido sin la tabla padre: al borrar una `persona` se elimina su `usuario` y/o `cliente` asociado (relación Es_un); al borrar un `producto` se elimina su `receta` y sus filas en `producto_ingrediente`; al borrar una `venta` se eliminan sus `venta_detalle`.
- Se usa **NO ACTION** cuando la tabla referenciada es un catálogo o entidad independiente que no debe desaparecer por una acción en cascada (`rol`, `ingrediente`, `categoria`, `ubicacion`, `metodo_pago`, `usuario` como cajero/mesero, `producto` desde `venta_detalle`). Esto obliga a resolver manualmente la dependencia antes de eliminar, evitando pérdidas accidentales de información histórica.

## Reglas de dominio (CHECK)

| Tabla.Columna | Restricción |
|---|---|
| ubicacion.capacidad | > 0 |
| ingrediente.stock | >= 0 |
| ingrediente.stock_minimo | >= 0 |
| producto.precio | >= 0 |
| producto.stock | >= 0 |
| producto.stock_minimo | >= 0 |
| producto_ingrediente.cantidad_necesaria | > 0 |
| venta.estado_venta (CK_venta_estado) | IN ('PENDIENTE','PAGADA','CANCELADA') |
| venta.modalidad_consumo (CK_venta_modalidad) | IN ('EN_LOCAL','PARA_LLEVAR','DELIVERY') |
| venta_detalle.cantidad (CK_venta_detalle_cantidad) | > 0 |
| venta_detalle.precio_unitario (CK_venta_detalle_precio) | >= 0 |

## Nulidad y valores por defecto

- **Columnas obligatorias (NOT NULL):** identificadores, nombres, precios, cantidades, y las columnas de las que depende la operación de negocio (`venta.modalidad_consumo`, `venta.id_metodo_pago`, `venta.id_cajero`).
- **Columnas opcionales (NULL):** `persona.email_personal`, `persona.telefono`, `producto.descripcion`, `producto.ruta_imagen`, `venta.id_cliente` (consumidor final), `venta.id_ubicacion` (para llevar / delivery), `venta.id_mesero` (ventas sin mozo asignado, como en la barra).
- **Valores por defecto (DEFAULT):** `venta.fecha_hora` (`SYSDATETIME()`), `venta.estado_venta` (`'PENDIENTE'`), stock/stock_minimo de producto e ingrediente (`0`), `cliente.fecha_registro` (`GETDATE()`), columnas de auditoría `fecha_creacion` (`GETDATE()`).
