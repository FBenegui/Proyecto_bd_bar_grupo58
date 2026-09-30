# Proceso de Normalización: 1FN y 2FN

## Primera Forma Normal (1FN): Eliminación de grupos repetitivos y garantía de atomicidad
Para que el modelo cumpla con la Primera Forma Normal, nos aseguramos de que todos los atributos contengan valores atómicos y que no existan grupos o matrices repetitivas en ninguna tabla. Verificamos que cada entidad posea una clave primaria que identifique cada registro de forma única.

* **Atomicidad:** Se revisaron tablas como persona, asegurando que atributos como telefono o email_personal almacenen un único valor por fila. Si una persona tuviera múltiples teléfonos, el modelo actual almacena solo el principal, evitando un campo con valores separados por comas. Lo mismo aplica para la direccion o descripcion en otras tablas.
* **Claves Primarias:** Todas las tablas definidas en el modelo cuentan con una clave primaria única claramente identificada. Por ejemplo: id_cliente en la tabla cliente, id_producto en producto, id_venta en venta, garantizando el cumplimiento estricto de la 1FN.

## Segunda Forma Normal (2FN): Eliminación de dependencias funcionales parciales en claves compuestas
La Segunda Forma Normal exige que todos los atributos que no formen parte de la clave primaria dependan de la totalidad de la clave primaria y no solo de una parte de ella. Este análisis se aplica exclusivamente a las entidades que poseen una clave primaria compuesta.

En nuestro modelo existen dos tablas con claves primarias compuestas resultantes de relaciones de muchos a muchos (N:M):

### Tabla venta_detalle:
* **Clave Primaria Compuesta:** id_venta e id_producto.
* **Atributos no clave:** cantidad y precio_unitario.

La cantidad vendida y el precio_unitario (registrado en el momento de la venta, como dicta la RN.06) no dependen únicamente de la venta, ni dependen únicamente del producto. Ambos valores existen y tienen sentido funcional únicamente cuando se combinan ambos identificadores (cuántos de ese producto específico se vendieron en esa venta específica). Por lo tanto, hay dependencia funcional completa.

### Tabla producto_ingrediente:
* **Clave Primaria Compuesta:** id_producto e id_ingrediente.
* **Atributos no clave:** cantidad_necesaria.

La cantidad_necesaria de un ingrediente no depende solo del producto final ni solo del ingrediente genérico. Depende de la combinación de ambos (qué cantidad exacta de ese ingrediente requiere esa receta específica). La dependencia funcional es completa sobre toda la clave compuesta.

Como ninguna de estas tablas posee dependencias parciales, el modelo cumple satisfactoriamente con la 2FN.