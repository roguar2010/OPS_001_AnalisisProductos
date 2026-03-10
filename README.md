# OPS_001_AnalisisProductos — PIX RPA

![Status](https://img.shields.io/badge/Status-Completado-success?style=for-the-badge)
![API](https://img.shields.io/badge/API-Fake%20Store%20API-FF6B35?style=for-the-badge)
![BD](https://img.shields.io/badge/Microsoft_SQL_Server-CC2927?style=for-the-badge&logo=microsoftsqlserver)

---

## Descripción
<div style="text-align: justify;">
<p>Robot RPA desarrollado con <b>PIX Studio</b> como <b>Prueba Técnica PIX RPA 2026</b>.</p>
<p>Automatiza el análisis diario de productos de una tienda online ficticia, integrando consumo de API REST, almacenamiento en base de datos, generación de reportes Excel, sincronización con OneDrive y envío de formulario web.</p>
</div>

---

## ¿Qué hace el robot?

```
Fake Store API
      |
      v
① GET /products ──────────────► Backup Productos_YYYY-MM-DD.json
      |                                        |
      |                               OneDrive /RPA/Logs/ ◄──── Microsoft Graph API (client_credentials)
      v
② SQL Server (tabla Productos)
   └─ Validación anti-duplicados
      |
      v
③ Excel Reporte_YYYY-MM-DD.xlsx
   ├─ Hoja 1: Productos (lista completa)
   └─ Hoja 2: Resumen (estadísticas por categoría)
      |
      v
④ OneDrive /RPA/Reportes/ ◄──── Microsoft Graph API (client_credentials)
      |
      v
⑤ Formulario Web
   └─ Evidencia: /Evidencias/formulario_confirmacion.png
```

---

## Estructura del Proyecto

```
OPS_001_AnalisisProductos/
│
├── Business/
│   ├── FetchProducts.pix          # Consumo API + backup JSON
│   ├── SaveToDatabase.pix         # Inserción en SQL Server
│   ├── GenerateReport.pix         # Reporte Excel (2 hojas)
│   ├── UploadOneDrive.pix         # Microsoft Graph API
│   └── SubmitWebForm.pix          # Automatización formulario web
│
├── Framework/
│   ├── Main.pix                   # Orquestador principal
│   ├── ReadConfig.pix             # Lectura Config.xlsx → Diccionario
│   ├── InitApplications.pix       # Inicialización de aplicaciones
│   ├── CloseApplications.pix      # Cierre limpio
│   ├── GetTransactionItem.pix     # Obtención de ítems
│   ├── ProcessTransactionItem.pix
│   ├── SetTransactionStatus.pix
│   ├── KillApplications.pix
│   └── TakeScreenshot.pix         # Captura de evidencia
│
├── Data/
│   ├── Config.xlsx                # Configuración centralizada del robot
│   └── crear_db.sql               # Script de creación de base de datos
│
├── Reportes/                      # Excel generados (output)
├── Logs/                          # JSON backup de API (output)
├── Evidencias/                    # Screenshots del proceso (output)
│   └── formulario_confirmacion.png
│
└── README.md
```

---

## Requisitos

### Software

| Herramienta    | Versión           | Uso                              |
|----------------|-------------------|----------------------------------|
| PIX Studio     | Última disponible | Desarrollo y ejecución del robot |
| SQL Server     | 20008 o superior  | Base de datos                    |

### Cuenta Azure AD

Se requiere una aplicación registrada en Azure AD con los siguientes permisos:

```
Tipo de permiso:  Aplicación (sin usuario)
Permiso:          Files.ReadWrite.All
Flujo OAuth2:     client_credentials
```

> ⚠️ **NO** se incluyen credenciales en el repositorio. Actualizar Data/Config.xlsx con credenciales de pruebas

---

## Pasos para Ejecutar

### 1. Clonar el repositorio

```bash
git clone https://github.com/roguar2010/OPS_001_AnalisisProductos.git
```

### 2. Inicializar la base de datos

**Motor:** SQL Server 2008 o superior 
**Script de creación:** `Data/crear_db.sql`

```bash
# Ejecutar en SQL Server Management Studio

Script Data/crear_db.sql
```

> El robot valida que el `id` no exista antes de insertar, evitando duplicados en ejecuciones repetidas.

### 3. Configurar credenciales en PIX Credential Manager

```
AZ_TENANT_ID     → ID del tenant de Azure AD
AZ_CLIENT_ID     → Client ID de la app registrada
AZ_CLIENT_SECRET → Client Secret generado en Azure
```

### 4. Actualizar Data/Config.xlsx

| Key                 | Valor de ejemplo                  |
|---------------------|-----------------------------------|
| UrlFakeStoreApi     | https://fakestoreapi.com/products |
| PathReports         | Reportes\                         |
| PathLogs            | Logs\                             |
| PathEvidences       | Evidencias\                       |
| UrlGoogleForm       | https://forms.google.com/...      |
| UrlOneDrive         | /RPA/                             |

> Validar configuración completa. Actualizar `UrlOneDrive`, `credenciales de Azure` y `cadena de conexión a la base de datos`.

### 5. Abrir y ejecutar en PIX Studio

```
1. Abrir PIX Studio
2. Cargar proyecto OPS_001_AnalisisProductos
3. Abrir main.pix
4. Ejecutar con F5 o desde PIX Runner
```

---

## Reporte Excel Generado

**Nombre:** `Reporte_YYYY-MM-DD.xlsx`

| Hoja          | Contenido                                                                                          |
|---------------|----------------------------------------------------------------------------------------------------|
| **Productos** | Lista completa: id, title, price, category, description, fecha_insercion                           |
| **Resumen**   | Total de productos · Precio promedio general · Precio promedio por categoría · Cantidad por categoría |

---

## Integración OneDrive

Autenticación sin interacción del usuario mediante **OAuth2 client_credentials** con Microsoft Graph API.

```
Archivos subidos automáticamente:
  /RPA/Logs/Productos_YYYY-MM-DD.json
  /RPA/Reportes/Reporte_YYYY-MM-DD.xlsx
```

---

## Formulario Web

**Plataforma:** Google Forms  
**Enlace:** [Ver formulario](https://docs.google.com/forms/d/e/1FAIpQLSejZJlJcTNmwqBSwPWGWNvuZamCMt4OxNGznlEw0rKqA1x7gQ/viewform)

Campos automatizados por el robot:
- Nombre del colaborador
- Fecha de generación del reporte
- Comentarios del proceso
- Subida del archivo Excel

---

## Entregables del Proceso

Tras cada ejecución se generan los siguientes archivos:

```
Reportes/
  └── Reporte_YYYY-MM-DD.xlsx

Logs/
  └── Productos_YYYY-MM-DD.json

Evidencias/
  └── formulario_confirmacion.png
```

---

## Convenciones de Código (PIX RPA)

Siguiendo las buenas prácticas de PIX RPA:

**Nomenclatura de variables:**

```
str → Texto      strApiUrl, strJsonPath
int → Entero     intProductCount, intInserted
dbl → Decimal    dblAvgPrice
is  → Booleano   isSuccess, isFormSubmitted
dt  → Fecha      dtToday
tbl → DataTable  tblProductos
```

**Reglas de arquitectura:**
- Máximo 100 pasos por script
- Cada script ejecuta un único bloque funcional
- Comentarios descriptivos en cada sección del flujo
- Parámetros clave registrados en logs
- Try/Catch en cada módulo desde Main

---

## Recursos

| Recurso               | Enlace                                                 |
|-----------------------|--------------------------------------------------------|
| PIX Academy           | https://academy.es.pixrobotics.com                     |
| Documentación PIX RPA | https://docs.pixrobotics.com/articles/#!rpa-es/welcome |
| Fake Store API        | https://fakestoreapi.com/docs                          |
| Microsoft Graph API   | https://learn.microsoft.com/graph/api/overview         |

---

## Autor

**Ronald Guarín**  
Prueba Técnica PIX RPA 2026 — Marzo de 2026

---

*Desarrollado como prueba técnica para PIX Robotics LATAM*
