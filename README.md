<div align="center">
  <img src="https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExd3h6cHk1bWtpazBwdWM4dTkwaDJ4NWYxc3NqbWhlcWFkbGxjMWZ3eiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/qgQUggAC3Pfv687qPC/giphy.gif" alt="Pixel Art Bar" width="200"/>

  # Sistema de Gestión de Ventas para Bar

  **Proyecto de Base de Datos relacional**
</div>

---

## 📖 Contexto del Proyecto

Este proyecto consiste en el diseño, implementación y optimización de un sistema de base de datos relacional para la gestión completa de un Bar. El sistema está preparado para administrar el flujo operativo diario, incluyendo el control de inventario, gestión de recetas, registro de ventas (en salón, para llevar y delivery), control de ubicaciones (mesas, terraza, salón VIP) y la administración del personal mediante un sistema de roles y permisos.

## ⚙️ Características y Funcionamiento

El sistema está estructurado bajo una arquitectura de base de datos robusta en SQL Server, garantizando la integridad de los datos y el rendimiento operativo a través de:

*   **Gestión de Inventario y Recetas:** Control preciso de stock de botellas cerradas e ingredientes fraccionados. Las recetas descuentan ingredientes específicos al momento de la venta.
*   **Módulo de Ventas Transaccional:** Sistema de ventas que soporta múltiples modalidades de consumo y métodos de pago, implementado con transacciones (ACID) para asegurar consistencia (ej: reversión automática si no hay stock).
*   **Auditoría Automática:** Implementación de Triggers para el registro silencioso e histórico de los cambios de precios en el catálogo.
*   **Seguridad y Roles:** Estructura de usuarios basada en roles funcionales (Administrador, Gerente, Cajero, Mozo, Delivery, etc.) para restringir el acceso a las operaciones sensibles.
*   **Optimización de Consultas:** Uso de índices para agilizar la generación de reportes y balances estadísticos de ventas.

## 🗂️ Estructura del Repositorio

El repositorio separa la **documentación** (`docs/`, organizada por etapas del proyecto) del **código SQL** (`sql/`, organizado por tipo de script).

```text
Proyecto_bd_bar_grupo58/
├── README.md
├── docs/                              # Documentación por etapa
│   ├── etapa-01/                      # Análisis del problema
│   │   ├── descripcion-caso.md
│   │   ├── alcance.md
│   │   ├── reglas-negocio.md
│   │   └── decisiones-diseno.md
│   ├── etapa-02/                      # Diseño del modelo de datos
│   │   ├── der/der.png                # Diagrama Entidad-Relación
│   │   ├── modelo-relacional.md
│   │   ├── normalizacion.md           # 1FN y 2FN
│   │   ├── diagrama_relacional_3fn.md
│   │   ├── Explicacion-Normalizaciones.md
│   │   └── decisiones-diseno.md
│   ├── etapa-03/                      # Implementación en SQL Server
│   │   ├── implementacion.md
│   │   ├── restricciones-integridad.md
│   │   └── pruebas-validacion.md
│   ├── etapa-04/                      # Consultas e informes
│   │   ├── informe-ventas.md
│   │   └── clientes-frecuentes.md
│   └── etapa-05/                      # Temas técnicos avanzados
│       ├── transacciones.md
│       ├── triggers.md
│       ├── optimizacion-consultas.md
│       └── capturas/                  # Planes de ejecución y estadísticas
└── sql/                               # Scripts de la base de datos
    ├── ddl/
    │   └── crear_bd.sql               # Creación de la BD y las tablas
    ├── dml/
    │   └── datos_prueba.sql           # Datos de prueba
    ├── consultas/
    │   ├── informe_ventas.sql
    │   ├── clientes_frecuentes.sql
    │   ├── Comprobante_venta.sql      # Procedimiento sp_comprobante_venta
    │   └── optimizacion_ventas_benchmark.sql
    └── tecnico/
        ├── transacciones/transacciones.sql   # sp_registrar_venta
        ├── triggers/triggers.sql             # trg_auditoria_precio
        └── optimizacion/indice_ventas.sql    # Índice IX_venta_estado_fecha
```

### 📚 Documentación por etapas

| Etapa | Contenido | Documentos |
|-------|-----------|------------|
| **1. Análisis** | Descripción del caso, alcance del sistema, reglas de negocio y decisiones de diseño iniciales. | [Descripción](docs/etapa-01/descripcion-caso.md) · [Alcance](docs/etapa-01/alcance.md) · [Reglas de negocio](docs/etapa-01/reglas-negocio.md) · [Decisiones](docs/etapa-01/decisiones-diseno.md) |
| **2. Diseño** | DER, modelo relacional y normalización hasta 3FN. | [DER](docs/etapa-02/der/der.png) · [Modelo relacional](docs/etapa-02/modelo-relacional.md) · [Normalización (1FN y 2FN)](docs/etapa-02/normalizacion.md) · [3FN](docs/etapa-02/diagrama_relacional_3fn.md) · [Explicación](docs/etapa-02/Explicacion-Normalizaciones.md) · [Decisiones](docs/etapa-02/decisiones-diseno.md) |
| **3. Implementación** | Creación de la base en SQL Server, restricciones de integridad y pruebas de validación. | [Implementación](docs/etapa-03/implementacion.md) · [Restricciones](docs/etapa-03/restricciones-integridad.md) · [Pruebas](docs/etapa-03/pruebas-validacion.md) |
| **4. Consultas** | Informes de negocio: ventas por categoría y clientes frecuentes. | [Informe de ventas](docs/etapa-04/informe-ventas.md) · [Clientes frecuentes](docs/etapa-04/clientes-frecuentes.md) |
| **5. Temas técnicos** | Transacciones (ACID), triggers de auditoría y optimización con índices. | [Transacciones](docs/etapa-05/transacciones.md) · [Triggers](docs/etapa-05/triggers.md) · [Optimización](docs/etapa-05/optimizacion-consultas.md) |

### 🧩 Modelo de datos

El DER completo está en [`docs/etapa-02/der/der.png`](docs/etapa-02/der/der.png). La base `Gestion_Bar` tiene las siguientes tablas:

| Grupo | Tablas |
|-------|--------|
| Personas y accesos | `persona`, `rol`, `usuario`, `cliente` |
| Catálogo | `categoria`, `producto` |
| Inventario y recetas | `ingrediente`, `receta`, `producto_ingrediente` |
| Ventas | `venta`, `venta_detalle`, `metodo_pago`, `ubicacion` |
| Auditoría (triggers) | `auditoria_producto` |

## 🚀 Cómo ejecutar el proyecto

**Requisitos:** SQL Server y un cliente como SQL Server Management Studio (SSMS) o Azure Data Studio.

Ejecutar los scripts en este orden:

| Paso | Script | Qué hace |
|------|--------|----------|
| 1 | [`sql/ddl/crear_bd.sql`](sql/ddl/crear_bd.sql) | Crea la base `Gestion_Bar` y todas sus tablas con sus restricciones. |
| 2 | [`sql/dml/datos_prueba.sql`](sql/dml/datos_prueba.sql) | Carga roles, personas, productos, ventas y demás datos de prueba. |
| 3 | [`sql/tecnico/triggers/triggers.sql`](sql/tecnico/triggers/triggers.sql) | Crea la tabla `auditoria_producto` y el trigger `trg_auditoria_precio`. |
| 4 | [`sql/tecnico/transacciones/transacciones.sql`](sql/tecnico/transacciones/transacciones.sql) | Crea el procedimiento `sp_registrar_venta` (con `COMMIT`/`ROLLBACK`). |
| 5 | [`sql/consultas/Comprobante_venta.sql`](sql/consultas/Comprobante_venta.sql) | Crea el procedimiento `sp_comprobante_venta`. |
| 6 | [`sql/consultas/informe_ventas.sql`](sql/consultas/informe_ventas.sql) y [`clientes_frecuentes.sql`](sql/consultas/clientes_frecuentes.sql) | Consultas de los informes (se pueden ejecutar cuando se quiera). |

**Opcional (optimización):**
- [`sql/tecnico/optimizacion/indice_ventas.sql`](sql/tecnico/optimizacion/indice_ventas.sql) crea el índice `IX_venta_estado_fecha`. No se aplica automáticamente sobre la base real.
- [`sql/consultas/optimizacion_ventas_benchmark.sql`](sql/consultas/optimizacion_ventas_benchmark.sql) mide el impacto del índice sobre una base sintética independiente (`Gestion_Bar_Benchmark`), sin tocar `Gestion_Bar`.

La explicación, el índice sugerido y el procedimiento reproducible de medición del informe de ventas se encuentran en [`docs/etapa-05/optimizacion-consultas.md`](docs/etapa-05/optimizacion-consultas.md).

## 🛠️ Tecnologías Utilizadas

<div align="center">
  <img src="https://img.shields.io/badge/SQL_Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white" alt="SQL Server" />
  <img src="https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white" alt="GitHub" />
  <img src="https://img.shields.io/badge/Markdown-000000?style=for-the-badge&logo=markdown&logoColor=white" alt="Markdown" />
</div>

---

## 👥 Equipo 58 - Integrantes

<div align="center">
  <table>
    <tr>
      <td align="center">
        <a href="https://github.com/Nicolasbitmil">
          <img src="https://github.com/Nicolasbitmil.png" width="100px;" alt="Nicolasbitmil"/>
          <br />
          <sub><b>Nicolasbitmil</b></sub>
        </a>
      </td>
      <td align="center">
        <a href="https://github.com/FBenegui">
          <img src="https://github.com/FBenegui.png" width="100px;" alt="FBenegui"/>
          <br />
          <sub><b>FBenegui</b></sub>
        </a>
      </td>
      <td align="center">
        <a href="https://github.com/Gottoli">
          <img src="https://github.com/Gottoli.png" width="100px;" alt="Gottoli"/>
          <br />
          <sub><b>Gottoli</b></sub>
        </a>
      </td>
      <td align="center">
        <a href="https://github.com/Lucasz-net">
          <img src="https://github.com/Lucasz-net.png" width="100px;" alt="Lucasz-net"/>
          <br />
          <sub><b>Lucasz-net</b></sub>
        </a>
      </td>
      <td align="center">
        <a href="https://github.com/angelB1206">
          <img src="https://github.com/angelB1206.png" width="100px;" alt="angelB1206"/>
          <br />
          <sub><b>angelB1206</b></sub>
        </a>
      </td>
    </tr>
  </table>
</div>
