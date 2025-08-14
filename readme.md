# 📋 Chinook: Sistema de Gestión para la tienda de Discos Chinook

## 📌 Descripción
Chinook es un sistema de base de datos MySQL diseñado para gestionar las operaciones de la tienda **Chinook** 
Permite administrar clientes, empleados, ventas, compras, canciones, álbums, playlists, y más.

## 🛠 Características Principales
- **Automatización**:  
  - 20 **consultas**
  - 5 **triggers**
  - 5 **funciones**
  - 5 **eventos** 

---

## 📂 Archivos del Proyecto
    • dql_select.sql (Consultas)
    • dql_funciones.sql (funciones)
    • dql_triggers.sql (triggers)
    • dql_eventos.sql (eventos)
    • Readme.md


## 🚀 Instrucciones para cargar y probar el sistema en DBeaver

### 1. Abrir DBeaver y crear conexión
Conecta a MySQL versión 8 o superior usando el usuario administrador (por ejemplo, root). Verifica que la base de datos `proyectoFinca` exista.

### 2. Cargar datos iniciales
Abre el archivo `ddl.sql` y ejecuta todo su contenido.

### 3. Cargar los triggers
Abre el archivo `dql_triggers.sql` y ejecútalo completo. Verifica que los triggers se crearon revisando la pestaña “Triggers” en DBeaver o listándolos en la base de datos.

### 4. Cargar los consultas
Abre el archivo `dql_select.sql` y ejecútalo completo. Confirma que aparecen en la sección “Procedures” de la base de datos.

### 5. Configurar eventos
Abre el archivo `dql_eventos.sql` y ejecútalo como usuario root. Verifica que los usuarios existen y tienen los permisos correctos.

---

## Pruebas recomendadas en DBeaver

### Probar triggers
Realiza una operación que dispare un trigger, como registrar una venta que afecte el inventario. Luego revisa que los cambios aparezcan tanto en `inventario` como en `historial_inventario`.

---

## Consideraciones
- Todas las pruebas deben hacerse únicamente en DBeaver.  
- Los triggers y procedimientos requieren que las tablas tengan datos iniciales cargados.  
- Para acceso remoto, es necesario ajustar el host y configurar SSL. 