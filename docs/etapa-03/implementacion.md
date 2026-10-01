[implementacion.md](https://github.com/user-attachments/files/32884010/implementacion.md)
# Implementación de la Base de Datos — Etapa III

## Motor de base de datos
El modelo relacional de la Etapa II se implementó en **SQL Server**, siguiendo el script de creación `sql/ddl/crear_bd.sql` y el script de carga de datos `sql/dml/datos_prueba.sql`.

## Organización del script DDL
El script se organiza en tres módulos, en el mismo orden en que se diseñaron las entidades en la Etapa II:

1. **Personas y usuarios:** `persona`, `rol`, `usuario`, `cliente`, `ubicacion`.
2. **Productos e ingredientes:** `categoria`, `producto`, `ingrediente`, `producto_ingrediente`, `receta`.
3. **Ventas:** `venta`, `venta_detalle`, `metodo_pago`.

## Decisiones de implementación

### Claves primarias
- La mayoría de las tablas usa `INT IDENTITY(1,1)` como clave primaria autogenerada: `persona`, `rol`, `ubicacion`, `categoria`, `ingrediente`, `metodo_pago`, `producto`, `venta`.
- `usuario` y `cliente` **no usan IDENTITY**: su PK es también FK hacia `persona.id_persona`. Esto implementa la relación "Es_un" (especialización) del modelo conceptual: comparten el mismo identificador que la persona de la que derivan.
- `receta` sigue el mismo patrón: su PK es `id_producto`, FK hacia `producto`, implementándola como entidad débil (una receta por producto como máximo).
- `producto_ingrediente` y `venta_detalle` usan **clave primaria compuesta**, tal como se definió en la normalización de la Etapa II.

### Tipos de datos
- Identificadores: `INT`.
- Textos cortos: `VARCHAR` con longitud acorde al dato (`VARCHAR(20)` para DNI, `VARCHAR(255)` para rutas de imagen, etc.).
- Textos largos: `TEXT` (`descripcion` de producto, `preparacion` de receta).
- Montos: `DECIMAL(10,2)`, para evitar errores de redondeo propios de los tipos de punto flotante.
- Fechas: `DATE` para fechas sin hora (`fecha_registro`), `DATETIME`/`DATETIME2` para fecha y hora (`fecha_hora` de venta, columnas de auditoría).

### Valores por defecto
- `venta.fecha_hora` usa `DEFAULT SYSDATETIME()`, para registrar automáticamente el momento de la operación.
- `venta.estado_venta` usa `DEFAULT 'PENDIENTE'`, el estado inicial de toda venta.
- `producto.stock`, `producto.stock_minimo`, `ingrediente.stock` e `ingrediente.stock_minimo` usan `DEFAULT 0`.
- Las columnas de auditoría `fecha_creacion` usan `DEFAULT GETDATE()`.

### Columnas de auditoría
Las tablas `categoria`, `producto` e `ingrediente` incluyen `fecha_creacion`, `fecha_modificacion` y `usuario_modificacion`, para llevar registro de altas y modificaciones sobre el catálogo de productos.

## Datos de prueba
El script `datos_prueba.sql` carga datos de ejemplo para validar el modelo: 20 personas (10 usuarios + 10 clientes), 8 roles, 10 ubicaciones, 8 categorías, 10 productos, 10 ingredientes con sus relaciones en `producto_ingrediente`, 10 métodos de pago, 8 recetas y 9 ventas con sus respectivos detalles.
