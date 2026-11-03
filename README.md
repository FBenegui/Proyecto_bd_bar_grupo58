<div align="center">
  <img src="https://media.giphy.com/media/l41JRsph73VokN6ik/giphy.gif" alt="Pixel Art Bar" width="200"/>

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
