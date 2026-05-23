PySide6 
pandas 
mysql-connector-python 
pymongo 
plotly 
bcrypt 
openpyxl


Fase 1: Arquitectura y Conexiones (El Motor) 

El objetivo aquí es preparar el terreno y lograr que Python hable con tus dos bases de datos.

Paso 1: Entorno Virtual y Dependencias.

Qué hacer: Abre tu terminal (Símbolo del sistema o PowerShell en Windows) en la carpeta donde vas a guardar tu proyecto.

Comandos: 1. Crea el entorno virtual: python -m venv venv
2. Actívalo: venv\Scripts\activate (En Windows).
3. Instala las librerías necesarias: pip install PySide6 pandas mysql-connector-python pymongo plotly bcrypt openpyxl (Nota: openpyxl es vital para que pandas pueda leer archivos Excel).


Paso 2: Gestor de Conexiones. 

Qué hacer: En tu editor de código (como VS Code), crea un archivo llamado database.py.

Código a escribir: Crea dos funciones. Una conectar_mysql() que use tus credenciales de MySQL Workbench, y otra conectar_mongo() que use la URI por defecto mongodb://localhost:27017. Pon un print("Conexión exitosa") en ambas y ejecuta el archivo para probar.


Paso 3: Funciones CRUD Básicas. 

Qué hacer: Crea un archivo queries.py.


Código a escribir: Empieza a escribir funciones en Python que ejecuten tus SELECT y llamen a tus procedimientos almacenados, como sp_registrar_asistencia.

Fase 2: Autenticación y Seguridad (El Portero) 

Vamos a proteger el sistema y crear la primera pantalla visual.


Paso 4: Actualizar Base de Datos y Lógica de Login. 


Qué hacer: Actualmente tus contraseñas están en texto plano (ej. ConfioEnLos3Ninos). Abre MySQL Workbench, y actualiza esos campos con hashes generados por la librería bcrypt.

Código a escribir: Crea auth.py. Haz una función verificar_usuario(correo, password) que busque el correo en SQL y use bcrypt.checkpw() para validar la contraseña.


Paso 5: Interfaz de Login en PySide6. 

Qué hacer: Crea login.py.

Código a escribir: Programa una ventana simple con dos cajas de texto (QLineEdit) para el correo y la contraseña, y un botón (QPushButton) de "Ingresar". Conecta el clic del botón a tu función verificar_usuario. Si pasa, que imprima "Bienvenido"; si no, que muestre un error.

Fase 3: El Pipeline de Ingesta (El Reemplazo de Google Forms) 

Aquí construimos el corazón de la aplicación: procesar el Excel de asistencias.


Paso 6: Lector de Pandas. 

Qué hacer: Crea ingestion.py.


Código a escribir: Usa pd.read_excel('ruta_del_archivo.xlsx'). Escribe código para limpiar los datos (quitar filas vacías, asegurar que las fechas estén en formato correcto).


Paso 7: Orquestador Dual (SQL + Mongo). 

Qué hacer: En el mismo archivo ingestion.py, crea una función maestra que recorra las filas del Excel (el DataFrame).


Código a escribir: Por cada fila, lanza un bloque try/except. Primero, inserta la asistencia en MySQL llamando a tu procedimiento. Si MySQL retorna éxito, entonces actualiza MongoDB haciendo un $push del asistente y su calificación dentro de la colección programaciones. Si algo falla, el except debe hacer un rollback.

Fase 4: Estructura de la Aplicación (El Frontend) 

Vamos a construir la interfaz principal donde navegará tu cliente (Diana).


Paso 8: Ventana Principal y Menú. 

Qué hacer: Crea main_window.py.


Código a escribir: Construye un QMainWindow de PySide6 con un panel lateral que tenga tres botones/pestañas: "Dashboard", "Cargar Asistencia" y "Gestión TGI".


Paso 9: Vistas y Tablas. 

Qué hacer: Diseña el contenido de la pestaña "Gestión TGI".


Código a escribir: Usa el widget QTableWidget para mostrar las listas de trabajadores y capacitaciones consultando tus funciones de queries.py.


Paso 10: Integrar la Carga del Excel. 

Qué hacer: En la pestaña "Cargar Asistencia", coloca un botón de "Buscar Archivo".

Código a escribir: Usa QFileDialog.getOpenFileName() para que el usuario pueda buscar el Excel en su computadora. Pasa la ruta de ese archivo a tu script ingestion.py del Paso 7.

Fase 5: Visualización de Datos (El PowerBI Killer) 

La etapa final para cumplir con el RQF-A04 de auditoría gráfica.


Paso 11: Generador de Gráficos. 

Qué hacer: Crea dashboard.py.


Código a escribir: Crea funciones que ejecuten tus cálculos (como la función fn_porcentaje_cumplimiento_fechas en MySQL  o tus pipelines de agregación en Mongo). Usa plotly.express para convertir esos datos en gráficos (barras, líneas) y guárdalos como código HTML.


Paso 12: Renderizar en la Interfaz. 

Qué hacer: Vuelve a tu main_window.py en la pestaña de Dashboard.

Código a escribir: Inserta el widget QWebEngineView (de la librería PySide6.QtWebEngineWidgets) y pásale el HTML que generó Plotly. Esto incrustará el gráfico con toda su interactividad (zoom, hover) directamente en tu app.
