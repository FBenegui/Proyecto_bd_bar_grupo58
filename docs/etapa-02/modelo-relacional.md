Diagrama 

cliente ||--o{ persona : "es un" 

persona ||--o{ usuario : "es un" 

persona ||--o{ ubicacion : "tiene" 

usuario ||--o{ rol : "tiene" 

usuario ||--o{ venta : "fabrica" 

usuario ||--o{ venta_detalle : "fabrica" 

rol ||--o{ metodo_pago : "usos" 

metodo_pago ||--o{ producto : "paga" 

producto ||--o{ categoria : "pertenece a" 

producto ||--o{ receta : "es parte de" 

producto ||--o{ producto_ingrediente : "tiene" 

categoria ||--o{ receta : "define" 

receta ||--o{ ingrediente : "usos" 

producto_ingrediente ||--o{ ingrediente : "usos" 

venta ||--o{ venta_detalle : "tiene" 

venta_detalle ||--o{ producto : "contiene"


    cliente {
        string id_cliente PK
        date fecha_registro
        date fecha_creacion
        date fecha_modificacion
        string usuario_modificacion
        string id_persona FK
    }
    persona {
        string id_persona PK
        string nombre
        string apellido
        string dni_cuit
        string telefono
        string email_personal
        date fecha_creacion
        date fecha_modificacion
        string usuario_modificacion
    }
    ubicacion {
        string id_ubicacion PK
        string nombre_ubicacion
        int capacidad
        string tipo_ubicacion
        date fecha_creacion
        date fecha_modificacion
        string usuario_modificacion
    }
    usuario {
        string id_usuario PK
        string email_empresa
        string clave
        date fecha_creacion
        date fecha_modificacion
        string usuario_modificacion
        string id_persona FK
        string idRol FK
    }
    rol {
        string idRol PK
        string nombreRol
        date fecha_creacion
        date fecha_modificacion
        string usuario_modificacion
    }
    metodo_pago {
        string id_metodo_pago PK
        string nombre_metodo
        date fecha_creacion
        date fecha_modificacion
        string usuario_modificacion
    }
    producto {
        string id_producto PK
        string nombre
        string descripcion
        float precio
        int stock
        int stock_minimo
        string ruta_imagen
        date fecha_creacion
        date fecha_modificacion
        string usuario_modificacion
        string id_categoria FK
    }
    categoria {
        string id_categoria PK
        string nombre_categoria
        date fecha_creacion
        date fecha_modificacion
        string usuario_modificacion
    }
    receta {
        string id_producto FK
        string preparacion
        date fecha_creacion
        date fecha_modificacion
        string usuario_modificacion
    }
    producto_ingrediente {
        string id_producto FK
        string id_ingrediente FK
        float cantidad_necesaria
    }
    ingrediente {
        string id_ingrediente PK
        string nombre
        string unidad_medida
        int stock
        int stock_minimo
        date fecha_creacion
        date fecha_modificacion
        string usuario_modificacion
    }
    venta {
        date fecha_hora
        string estado_venta
        string modalidad_consumo
        date fecha_creacion
        date fecha_modificacion
        string usuario_modificacion
        string id_cliente FK
        string id_ubicacion FK
        string id_metodo_pago FK
        string id_cajero FK
        string id_mesero FK
    }
    venta_detalle {
        float cantidad
        float precio_unitario
        float subtotal
        string id_venta FK
        string id_producto FK
    }
    
    tablas: cliente, persona, ubicación, usuario, rol, metodo_pago, producto, categoria, receta, producto_ingrediente, ingrediente, venta y venta_detalle.
