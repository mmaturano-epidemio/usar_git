# ==============================================================================
# BUENAS PRÁCTICAS: CHAU CARPETA ENSALADA Y CHAU HARDCODING
# Paquetes: install.packages(c("here", "data.table"))
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. EL CONCEPTO DE HARDCODING (¿Por qué se rompen los scripts?)
# ------------------------------------------------------------------------------
# "Hardcodear" (del inglés hard-coding) es escribir valores fijos, rutas exactas 
# o contraseñas directamente adentro del código fuente. 
#
# Ejemplos de hardcoding TÓXICO:
# ❌ setwd("C:/Users/Maria/Desktop/proyecto_mortalidad") 
# ❌ token_github <- "ghp_123456789secreto"
#
# ¿Por qué evitarlo?
# 1. Rompe la reproducibilidad: Si tu compañera clona el repo, su computadora 
#    no tiene un usuario "Maria". El script tira error en la línea 1.
# 2. Riesgo de seguridad: Si subís el código a GitHub, todo el mundo ve tu token.
#
# LA SOLUCIÓN:
# - Para contraseñas y tokens secretos -> Usamos el archivo .Renviron
# - Para las rutas de los archivos -> Usamos una estructura de carpetas + paquete {here}

# ------------------------------------------------------------------------------
# 2. LA ESTRUCTURA DE CARPETAS MODULARIZADA
# ------------------------------------------------------------------------------
# Un proyecto ordenado NO tiene archivos sueltos. Todo va en su caja:
# 
# 📁 mi_proyecto/
# ├── 📁 data/
# │   ├── 📁 raw/        (Bases originales, intocables. Ej: DEIS.csv)
# │   └── 📁 processed/  (Bases limpias generadas por R)
# ├── 📁 scripts/        (Solo archivos .R, ej: 01_limpieza.R)
# ├── 📁 outputs/        (Gráficos y tablas exportadas)
# └── 📄 mi_proyecto.Rproj

# Tip: Podés crear estas carpetas rápido desde R corriendo esto:
# dir.create("data/raw", recursive = TRUE)
# dir.create("data/processed", recursive = TRUE)
# dir.create("scripts")
# dir.create("outputs")

# ------------------------------------------------------------------------------
# 3. LEYENDO DATOS SIN ROMPER EL CÓDIGO DE LAS DEMÁS (Paquete {here})
# ------------------------------------------------------------------------------
# La función here() averigua automáticamente dónde está la carpeta principal 
# del proyecto en TU computadora, y construye la ruta desde ahí.

# ❌ MAL (Hardcodeado - Solo funciona en tu PC):
# defunciones <- fread("C:/Mis_Documentos/Hospital/data/raw/defunciones_2024.csv")

# ✅ BIEN (Reproducible - Funciona en cualquier PC que abra el proyecto):
# defunciones <- fread(here("data", "raw", "defunciones_2024.csv"))

# Guardar un archivo limpio también se hace con here():
# fwrite(defunciones_limpias, here("data", "processed", "defunciones_analisis.csv"))

# Ejemplo:

if(!require(here)) install.packages("here")
library(here)
library(data.table)

# Creamos un directorio
dir.create("datos/ejemplo", recursive = TRUE)

# Constatamos la ruta:
here("datos", "ejemplo")

# Guardamos un dataset
ejemplo <- as.data.table(iris)
str(ejemplo)
fwrite(ejemplo, here("datos", "ejemplo", "iris.csv"))
list.files(here("datos", "ejemplo"))
