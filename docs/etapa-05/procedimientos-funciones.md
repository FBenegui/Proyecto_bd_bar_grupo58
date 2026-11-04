# Etapa V - Tema 1: Procedimientos y funciones almacenadas

Proyecto: Gestion_Bar (grupo 58) - SQL Server Express

## 1. Definición y objetivo

**Procedimiento almacenado:** programa SQL guardado dentro de la base de datos. Que recibe parámetros y puede realizar varias operaciones (consultas, inserts, updates, control de errores) y devolver uno o varios resultados. En el proyecto: `sp_comprobante_venta`.

**Función almacenada:** rutina que recibe parámetros y devuelve un valor escalar o una tabla. Se usa dentro de un `SELECT`, un `WHERE` o un `CASE` y no puede modificar datos de las tablas. En el proyecto: `fn_CalcularDescuentoCliente`.


## 2. Ventajas y aplicaciones

- Reutilizan la lógica de negocio: la regla del descuento se escribe una sola vez y la usan el comprobante y `clientes_frecuentes`.
- Reducen código repetido: si cambia un umbral, se modifica en un único lugar.
- Mejoran la mantenibilidad: `CREATE OR ALTER` permite corregir sin romper dependencias.
- Centralizan reglas de negocio y facilitan la seguridad: se puede otorgar `EXECUTE` sobre el procedimiento sin dar acceso directo a las tablas.
- Rendimiento: el plan de ejecución se reutiliza y viaja menos texto entre la aplicación y el servidor.
- Aplicaciones en el bar: comprobante de venta, descuento por cliente frecuente, registro de ventas, reportes.

## 3. Implementación en SQL Server Express


| `fn_GastoAcumuladoCliente` | `sql/tecnico/funciones/fn_GastoAcumuladoCliente.sql` |
| `fn_CalcularDescuentoCliente` | `sql/tecnico/funciones/fn_CalcularDescuentoCliente.sql` |
| `sp_comprobante_venta` | `sql/tecnico/procedimientos/sp_comprobante_venta.sql` |
| Clientes frecuentes (con descuento) | `sql/consultas/clientes_frecuentes.sql` |
| Pruebas de las funciones y demostración de tramos (con ROLLBACK) | `sql/tecnico/funciones/pruebas_funciones_descuento.sql` |
| Pruebas del procedimiento | `sql/tecnico/procedimientos/pruebas_sp_comprobante_venta.sql` |

Orden de ejecución: primero las dos funciones, luego el procedimiento y la consulta, por último las pruebas.

**Regla de descuento** (sobre el gasto acumulado de ventas con `estado_venta = 'PAGADA'`):

- más de $350.000 → 10 %
- más de $140.000 → 5 %
- caso contrario → 0 %

`fn_CalcularDescuentoCliente` devuelve el porcentaje y usa internamente `fn_GastoAcumuladoCliente`. Un cliente inexistente o el consumidor final (`NULL`) devuelve 0.

`sp_comprobante_venta` conserva el encabezado y el detalle con `ROLLUP` y agrega un tercer resultado con subtotal, descuento, monto del descuento y total a pagar.

### 3.1 Criterio de precios y umbrales

El sistema modela un **bar de bebidas**. Los precios son los de la carta del bar:

| Bebida | Precio |
|---|---|
| Agua | $5.000 |
| Gaseosas | $5.000 |
| Chopp Heineken | $10.000 |
| Heineken lata | $7.000 |
| Red Bull | $6.000 |
| Tragos sin alcohol | $7.000 |
| Gin Tonic | $9.000 |
| Fernet | $9.000 |
| Aperol Spritz | $8.000 |
| Negroni | $8.000 |
| Campari | $8.000 |
| Caipi frutos rojos | $8.000 |
| Cuba Libre | $8.000 |

Ticket de referencia de una mesa: 1 chopp Heineken + 1 fernet + 1 negroni + 1 aperol spritz = **$35.000**.

- más de $140.000 acumulados ≈ más de 4 visitas → 5 %
- más de $350.000 acumulados ≈ más de 10 visitas → 10 %

Los porcentajes (5 % y 10 %) y los umbrales son una decisión de diseño del grupo.

## 4. Caso aplicado al sistema de ventas

El comprobante de una venta muestra el descuento que le corresponde al cliente según lo que acumuló en compras pagadas. La misma función se reutiliza en el listado de clientes frecuentes.

Nota de diseño: el gasto acumulado incluye la venta que se está consultando si está pagada.

## 5. Pruebas y resultados

Demostración (`pruebas_funciones_descuento.sql`, sección 5.5). Cada ticket es de $35.000:

| Caso |      Tickets     | Gasto pagado | Descuento esperado |
|------|------------------|--------------|--------------------|
|  1   |  11 pagados      |   $385.000   |      10 %          |
|  2   |10 pagados(límite)|    $350.000  |       5 %          |
|  3   |    5 pagado      |   $175.000   |       5 %          |
|  4   |4 pagados (límite)|    $140.000  |       0 %          |
|  5   |4pagados+3pendientes|  $140.000  |0%(ignora no pagadas)|
|  6   |sin ventas        |     $0       |       0 %          |

Comprobante del cliente 1: subtotal $35.000, descuento 10 % = $3.500, total a pagar $31.500.

