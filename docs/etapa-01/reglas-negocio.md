# Reglas de Negocio

A continuación se detallan las reglas de negocio definidas para el Sistema de Gestión de Ventas del Bar:

**RN.01:** Cada cliente registrado debe poseer un identificador único dentro del sistema.

**RN.02:** Cada venta debe estar asociada a un cliente registrado.

**RN.03:** Cada venta debe ser registrada por un usuario del sistema.

**RN.04:** Cada venta debe utilizar un único método de pago.

**RN.05:** Una venta debe contener al menos un producto en su detalle.

**RN.06:** Cada producto incluido en una venta debe registrar la cantidad vendida y el precio unitario correspondiente al momento de realizar la venta.

**RN.07:** El precio registrado en el detalle de una venta no debe modificarse automáticamente cuando se modifique el precio actual del producto.

**RN.08:** El stock de un producto debe disminuir cuando se registra una venta.

**RN.09:** No se debe permitir registrar una venta cuando la cantidad solicitada de un producto sea superior al stock disponible.

**RN.10:** Cada producto debe pertenecer a una categoría.

**RN.11:** Cada usuario debe poseer un rol que determine las operaciones que puede realizar dentro del sistema.

**RN.12:** Un producto puede estar asociado a una receta para determinar los ingredientes necesarios para su elaboración.

**RN.13:** Una receta puede estar compuesta por uno o varios ingredientes.

**RN.14:** Cada ingrediente debe registrar su unidad de medida y cantidad disponible.

**RN.15:** El sistema debe conservar la fecha de creación y modificación de los registros relevantes.