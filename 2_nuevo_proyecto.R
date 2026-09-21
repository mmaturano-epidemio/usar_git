# ==============================================================================
# SCRIPT 2: VINCULAR UN PROYECTO NUEVO A GITHUB (UNA VEZ POR PROYECTO)
# ==============================================================================
# REQUISITOS:
# - Estar dentro de un proyecto de RStudio (abrir el archivo .Rproj).
# - Haber completado el Script 1 en esta computadora.
#
# ¡Correr BLOQUE POR BLOQUE (Ctrl+Enter), no con "Source"!
# use_git() reinicia RStudio y corta la ejecución. Después del reinicio,
# retomar desde el PASO 3.
#
# Equivalencias con lo que ya conocemos de la terminal:
#   use_git_ignore()  ~  editar el .gitignore
#   use_git()         ~  git init  +  git add .  +  git commit -m "Initial commit"
#                        (pidiendo confirmación antes del commit)
#   use_github()      ~  crear el repo en GitHub (API)  +  git remote add origin
#                        +  git push -u origin main

# Cargar/instalar herramientas del proyecto
if(!require(pacman)) install.packages("pacman")

pacman::p_load(usethis, here, data.table, ggplot2)


# ------------------------------------------------------------------------------
# PASO 0: ¿DÓNDE ESTAMOS PARADAS?
# ------------------------------------------------------------------------------
# usethis escribe el .gitignore en la raíz del "proyecto activo".
# Esa carpeta tiene que ser la del proyecto nuevo (la misma donde está el .Renviron).

proj_get() == getwd()


# ------------------------------------------------------------------------------
# PASO 1: EL ESCUDO DE DATOS SENSIBLES (.gitignore)
# ------------------------------------------------------------------------------
# BUENA PRÁCTICA CRÍTICA EN EPIDEMIOLOGÍA:
# Manejamos datos sensibles de pacientes (DEIS). NUNCA deben subir a la nube.
# Creamos la regla de exclusión ANTES de encender Git para que las bases
# no queden guardadas en la historia del repositorio.
#
# Es seguro correr esto más de una vez: usethis no duplica líneas.

# file.remove(".gitignore") # Para mostrar cómo crearlo

use_git_ignore(c(
  ".Renviron",     # Variables de entorno/credenciales locales
  ".Rproj.user/",  # Configuraciones personales de tu RStudio
  "data/raw/",     # Carpeta de microdatos originales
  "*.csv",         # Archivos separados por comas
  "*.xlsx",        # Planillas de Excel
  "*.xls",
  "*.rds",         # Objetos de R (también pueden contener datos individuales)
  "*.RData",
  "*.dbf",         # Formatos habituales de bases de salud
  "*.sav",
  "*.dta",
  "*.parquet"
))

# Ojo: el .gitignore solo actúa sobre archivos que Git TODAVÍA NO sigue.
# Si un archivo ya fue commiteado alguna vez, agregarlo al .gitignore no
# alcanza (ver el bloque "SI YA SE COMMITEÓ" al final).


# ------------------------------------------------------------------------------
# PASO 2: ENCENDER GIT EN ESTE PROYECTO
# ------------------------------------------------------------------------------
# Le decimos a RStudio que esta carpeta se convierta en un "Repositorio Git".

use_git()

# -> LA CONSOLA TE VA A PREGUNTAR: "There are N uncommitted files: ..."
#    ¡LEÉ ESA LISTA ANTES DE CONTESTAR! Es tu última barrera antes del commit.
#    - Tienen que aparecer: .gitignore, el .Rproj, tus scripts.
#    - NO tienen que aparecer: .Renviron, .csv, .xlsx, nada de data/raw.
#    Si aparece algo de eso, contestá "No", corregí el PASO 1 y corré use_git()
#    de nuevo. Si la lista está bien, contestá "Yes".
#
# RStudio se va a reiniciar. Al volver, verás la pestaña "Git" arriba a la derecha.


# ------------------------------------------------------------------------------
# PASO 2b: VERIFICAR (después del reinicio)
# ------------------------------------------------------------------------------
# ¿Qué archivos está siguiendo Git? No debería estar .Renviron ni ninguna base.

system("git ls-files")

# ¿Qué regla está ignorando el .Renviron? Debería mostrar algo como:
#   .gitignore:1:.Renviron    .Renviron
system("git check-ignore -v .Renviron")

# Si "git ls-files" lista .Renviron, Git ya lo estaba siguiendo:
# ver el bloque "SI YA SE COMMITEÓ" al final.


# ------------------------------------------------------------------------------
# PASO 3: CREAR EL REPOSITORIO EN GITHUB Y SUBIR EL PROYECTO
# ------------------------------------------------------------------------------
# Como la computadora ya conoce tu Token (gracias al Script 1), esto es automático.
#
# ¡CUIDADO! Por defecto use_github() crea un repositorio PÚBLICO (visible para
# cualquier persona en internet). En salud, arrancamos siempre en PRIVADO:

use_github(private = TRUE)

# -> Si te avisa de cambios sin commitear, revisá la lista antes de seguir.
# ¡Felicidades! Se abrirá el navegador mostrando tu proyecto publicado en GitHub.
# (Si algún día necesitás hacerlo público: GitHub -> Settings -> Danger Zone.)


# ------------------------------------------------------------------------------
# PASO 4 (OPCIONAL): UNA PLANTILLA DEL .Renviron PARA EL EQUIPO
# ------------------------------------------------------------------------------
# El .Renviron real NO se sube, pero una compañera que clone el proyecto necesita
# saber qué variables tiene que definir. Solución: un .Renviron.example, SIN
# valores, que sí se versiona (el nombre es distinto, así que el .gitignore
# no lo toca).

writeLines(
  c("# Copiá este archivo como .Renviron y completá tus valores",
    "USUARIO=",
    "E_MAIL="),
  here(".Renviron.example")
)

# Después: commit desde la pestaña Git de RStudio (o con git add / git commit).

# NOTA SOBRE .Renviron: al arrancar, R lee UN solo .Renviron. Si el proyecto
# tiene uno propio, ese tiene prioridad y el de tu carpeta personal (~/.Renviron)
# NO se lee (no se combinan). Además, se lee al iniciar la sesión: si lo editás,
# reiniciá R o usá readRenviron(".Renviron").
# Y ojo: usethis::edit_r_environ("project") crea/abre el archivo, pero no lo
# agrega solo al .gitignore. Eso lo hace el PASO 1.


# ------------------------------------------------------------------------------
# SI YA SE COMMITEÓ: DEJAR DE SEGUIR UN ARCHIVO
# ------------------------------------------------------------------------------
# Síntoma: el .Renviron (o una base) aparece en la pestaña Git aunque esté en
# el .gitignore. Causa: Git ya lo tenía en su índice.
#
# 1) Sacarlo del índice SIN borrar el archivo local:
#    system("git rm --cached .Renviron")
#    system('git commit -m "Dejar de seguir .Renviron"')
#
# 2) Si ya se hizo push a GitHub, el archivo sigue en la historia del repo.
#    - Si tenía credenciales/tokens: revocarlos y generar nuevos (es lo urgente).
#    - Si tenía datos de pacientes: avisar y limpiar la historia
#      (git filter-repo) o borrar y recrear el repositorio.


# ------------------------------------------------------------------------------
# BUENA PRÁCTICA DE COLABORACIÓN: CHAU SETWD()
# ------------------------------------------------------------------------------
# Usar setwd("C:/MisDocumentos/...") hace que el script falle cuando otra
# residente intente correrlo en su máquina.
# Solución: Usamos la función here() del paquete {here}, que parte de la raíz del proyecto.
#
# Ejemplo de lectura reproducible:
# base_deis <- fread(here("data", "raw", "defunciones_2024.csv"))