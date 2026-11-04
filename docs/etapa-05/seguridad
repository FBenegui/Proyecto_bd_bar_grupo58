# Etapa V – Tema 4: Seguridad (usuarios, roles y permisos en SQL Server)

**Base de datos:** `Gestion_Bar` | **Motor:** SQL Server Express
**Script:** `sql/tecnico/seguridad/seguridad.sql`

## 1. Definición y objetivo

La seguridad en una base de datos controla **quién puede entrar** y **qué puede hacer** una vez adentro. En SQL Server hay tres piezas:

| Concepto | Qué es | En este proyecto |
|---|---|---|
| **Login** | Credencial de acceso al servidor | `usuario_admin`, `usuario_lector`, `usuario_con_rol`, `usuario_sin_rol` |
| **Usuario** | Identidad dentro de una base, ligada a un login | Un usuario por cada login, en `Gestion_Bar` |
| **Permiso** | Autorización sobre un objeto (`SELECT`, `INSERT`, `EXECUTE`, ...) | `GRANT SELECT ON dbo.venta`, etc. |
| **Rol** | Grupo de permisos que se asigna a varios usuarios | `db_owner` (fijo) y `rol_consulta_productos` (personalizado) |

El objetivo es aplicar el **principio de mínimo privilegio**: cada usuario recibe solo lo que necesita.

> **Aclaración importante:** la tabla `rol` del proyecto (Administrador, Gerente, Cajero, Mozo, ...) representa los **roles funcionales de los empleados del bar**, y es información del negocio. Los **roles de seguridad de SQL Server** (como `rol_consulta_productos`) son un mecanismo del motor para controlar permisos. No están relacionados entre sí y no se deben confundir.

## 2. Ventajas y aplicaciones

- Protege información sensible (por ejemplo `usuario.clave`).
- Evita modificaciones accidentales o no autorizadas sobre ventas y productos.
- Permite asignar responsabilidades según el perfil (administrar, solo consultar).
- Los roles simplifican la administración: se otorgan permisos una vez al rol y luego se suman o quitan usuarios.
- Un procedimiento almacenado permite habilitar una operación puntual (registrar una venta) sin dar acceso directo de escritura a la tabla.

## 3. Implementación en SQL Server Express

Pasos que realiza `seguridad.sql`:

1. `CREATE LOGIN` para cuatro usuarios de prueba.
2. `CREATE USER` en `Gestion_Bar` para cada login.
3. `CREATE PROCEDURE dbo.sp_RegistrarVentaSimple`, que inserta en `venta`.
4. Permisos:
   - `usuario_admin` → `ALTER ROLE db_owner ADD MEMBER` (administrador).
   - `usuario_lector` → `GRANT SELECT ON dbo.venta` y `GRANT EXECUTE ON dbo.sp_RegistrarVentaSimple`.
   - `rol_consulta_productos` (rol propio) → `GRANT SELECT ON dbo.producto`; `usuario_con_rol` se agrega a ese rol y `usuario_sin_rol` queda sin ningún permiso.
5. Consultas de verificación sobre `sys.database_permissions` y `sys.database_role_members`.
6. Pruebas de acceso con `EXECUTE AS USER` / `REVERT`, dentro de una transacción que se deshace al final para no dejar ventas de prueba.

## 4. Caso concreto aplicado al sistema de ventas del bar

- **Tabla `venta`:** el administrador puede insertar directamente; el lector no.
- **Procedimiento `sp_RegistrarVentaSimple`:** el lector no puede escribir en `venta`, pero sí registrar una venta ejecutando el procedimiento. Funciona porque el procedimiento y la tabla pertenecen al mismo esquema (`dbo`) y SQL Server no vuelve a verificar el permiso de `INSERT` sobre la tabla (encadenamiento de propiedad).
- **Tabla `producto`:** solo quien pertenece a `rol_consulta_productos` puede consultarla.

El procedimiento recibe `modalidad_consumo`, `id_metodo_pago` e `id_cajero`. `fecha_hora` y `estado_venta` los completan los valores por defecto definidos en `crear_bd.sql`.

## 5. Script de demostración y resultados

Resultados esperados (reemplazar la última columna con lo que muestre SSMS al ejecutar, o adjuntar capturas):

| # |               Prueba             | Usuario      | Esperado | Resultado obtenido |
|---|---|---|---|---|
| 1 | `INSERT` directo sobre `venta` | `usuario_admin` | Correcto | _completar_ |
| 2 | `INSERT` directo sobre `venta` | `usuario_lector` | **Acceso denegado** | _completar_ |
| 3 | `EXEC sp_RegistrarVentaSimple` | `usuario_lector` | Correcto | _completar_ |
| 4 | `SELECT` sobre `venta` | `usuario_lector` | Correcto | _completar_ |
| 5 | `SELECT` sobre `producto` | `usuario_con_rol` | Correcto | _completar_ |
| 6 | `SELECT` sobre `producto` | `usuario_sin_rol` | **Acceso denegado** | _completar_ |
| 7 | `SELECT` sobre `venta` | `usuario_con_rol` | **Acceso denegado** (el rol solo cubre `producto`) | _completar_ |

Mensaje típico de SQL Server en las pruebas denegadas: `The INSERT permission was denied on the object 'venta'` / `The SELECT permission was denied on the object 'producto'`.

**Conclusión de la demostración:** los permisos directos, los permisos por rol y el permiso de ejecución sobre un procedimiento se comportan de forma independiente. Un usuario sin permiso de escritura puede igualmente realizar una operación autorizada a través del procedimiento, manteniendo la lógica de negocio bajo control.

> Nota: las contraseñas del script son solo de prueba y no deben usarse en un entorno real.
