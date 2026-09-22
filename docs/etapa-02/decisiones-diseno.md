### Decisiones de diseño

Para el diseño de la base de datos del Sistema de Gestión de Ventas para un Bar se tomaron decisiones orientadas a mantener la información organizada, evitar redundancias y representar correctamente las operaciones principales del negocio.

1. Separación entre Persona, Cliente y Usuario**
Se decidió separar los datos personales en la entidad `persona` y utilizarla como base para `cliente` y `usuario`. De esta manera, los datos como nombre, apellido, DNI, teléfono y correo personal no necesitan repetirse cuando una misma persona cumple diferentes funciones dentro del sistema.

2. Implementación de roles para los usuarios**
Los usuarios se relacionan con la entidad `rol`, permitiendo definir las funciones o permisos que posee cada usuario dentro del sistema. Esta decisión permite diferenciar los distintos tipos de usuarios sin tener que almacenar el rol directamente como texto en cada operación.

3. Separación de ventas y detalle de venta**
Se decidió dividir la información de una venta en las entidades `venta` y `venta_detalle`. La entidad `venta` almacena los datos generales de la operación, como cliente, ubicación, método de pago, cajero, mesero, fecha y estado. Por otro lado, `venta_detalle` almacena los productos vendidos, la cantidad, el precio unitario y el subtotal.

Esta separación permite que una misma venta contenga varios productos sin repetir los datos generales de la venta.

4. Conservación del precio histórico**
Se decidió almacenar `precio_unitario` dentro de `venta_detalle` en lugar de utilizar únicamente el precio actual de `producto`. Esto permite conservar el precio utilizado al momento de realizar cada venta. De esta manera, si el precio de un producto cambia posteriormente, las ventas anteriores mantienen su valor histórico.

5. Separación de productos e ingredientes**
Se decidió diferenciar `producto` de `ingrediente`, ya que no todos los productos tienen necesariamente los mismos componentes ni requieren elaboración. Los ingredientes poseen su propio stock y unidad de medida, mientras que los productos tienen información comercial como nombre, descripción, precio y stock.

6. Relación entre productos e ingredientes**
Para relacionar productos con ingredientes se creó la entidad `producto_ingrediente`. Esta entidad permite representar una relación de muchos a muchos y almacenar además la `cantidad_necesaria` de cada ingrediente para un producto determinado.

Esta decisión evita almacenar varios ingredientes dentro de un único campo y permite controlar correctamente las cantidades utilizadas.

7. Uso de recetas**
Se decidió incorporar la entidad `receta` para registrar la preparación de determinados productos. La receta contiene la información correspondiente a la preparación y se relaciona con los productos e ingredientes necesarios para su elaboración.

8. Clasificación de productos mediante categorías**
Los productos se relacionan con `categoria` para permitir su clasificación y facilitar la organización y consulta de la información. Esto evita repetir el nombre de la categoría en cada producto y permite administrar las categorías de manera independiente.

9. Métodos de pago independientes**
Se decidió crear la entidad `metodo_pago` para registrar los diferentes medios utilizados en las ventas. La venta mantiene una referencia al método de pago utilizado mediante una clave foránea. Esto permite agregar o modificar métodos de pago sin alterar la estructura de la tabla `venta`.

10. Registro de ubicación y modalidad de consumo**
Se incorporó la entidad `ubicacion` para representar el lugar asociado a una venta dentro del bar, por ejemplo, una mesa u otra ubicación disponible. Además, se utiliza `modalidad_consumo` para diferenciar la forma en que se realiza el consumo.

11. Control de stock**
Se decidió almacenar información de stock tanto para productos como para ingredientes. En ambos casos se contempla un stock mínimo, lo que permite identificar cuándo las existencias se encuentran por debajo del nivel establecido y facilitar el control de inventario.

12. Auditoría de modificaciones**
Las entidades principales incluyen campos como `fecha_creacion`, `fecha_modificacion` y `usuario_modificacion`. Estos atributos permiten conservar información básica sobre cuándo se creó o modificó un registro y qué usuario realizó la última modificación.

13. Identificación mediante claves primarias y foráneas**
Cada entidad posee una clave primaria que permite identificar sus registros de forma única. Las relaciones entre las entidades se implementan mediante claves foráneas, permitiendo mantener la integridad referencial de la información.

14. Separación de funcionalidades para mantener el alcance acotado**
El diseño se mantuvo enfocado en las operaciones principales definidas para el proyecto: clientes, usuarios, productos, categorías, ventas, métodos de pago, stock, recetas e ingredientes. Se decidió no incorporar funcionalidades como facturación electrónica, sueldos, contabilidad, delivery o integraciones externas, con el objetivo de mantener el sistema acorde a los objetivos de la materia.
