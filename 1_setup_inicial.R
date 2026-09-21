# ==============================================================================
# SCRIPT 1: TEORÍA Y CONFIGURACIÓN INICIAL (¡UNA SOLA VEZ EN LA VIDA POR COMPU!)
# ==============================================================================

# ------------------------------------------------------------------------------
# PARTE 0: INSTALACIÓN AUTOMATIZADA DE PAQUETES
# ------------------------------------------------------------------------------
# Para esta parte necesitamos las librerías usethis y gitcreds
# Para no instalarlas manualmente y para más reproducibilidad, usamos
# un gestor de paquetes: pacman

# 1ro: Verificamos si tenemos 'pacman'; si no, instalamos
if(!require(pacman)) install.packages("pacman")

# 2do: Pacman carga o instala automáticamente los paquetes necesarios para el setup
pacman::p_load(usethis, gitcreds)

# Esta forma de trabajo es muy práctica para proyectos que requieren muchos paquetes
# o para scripts que tenemos que correr en distintas compus donde las librerías que
# necesitamos pueden no estar instaladas. En fin, vamos al tema de hoy.
# Pero antes... 

# 3ro: Chequeamos que Git esté instalado en el sistema operativo y RStudio lo detecte:
if(Sys.which("git") == "") {"Ojo, no se encuentra Git"} else {"¡Perfecto, Git está disponible!"}

# Si al correr
Sys.which("git")
# la consola devuelve una ruta, estilo "C:\\DIRECTORIO\\bla\\bla\\bla\\git.exe", 
# está todo listo para seguir

# Si la consola devuelve "", Git NO está instalado o RStudio no lo encuentra. 
# Hay que descargarlo de https://git-scm.com/downloads e instalarlo (dar 'Next' a todo).
# Luego reiniciar RStudio (cerrar y volver a abrir). Si sigue dando "", revisar en:
# Tools -> Global Options -> Git/SVN que la ruta apunte al ejecutable git.exe.


# ------------------------------------------------------------------------------
# PARTE 1: CONCEPTOS CLAVE Y TEORÍA DE CONTROL DE VERSIONES
# ------------------------------------------------------------------------------
# ¿Por qué hacemos esto? Para erradicar el pase de scripts por mail o pendrive, 
# evitar borrar avances por error, y terminar con los archivos llamados:
# "analisis_deis_final_FINAL_v4_corregido.R"
#
# -> ¿Qué es Git? 
# Es un software que funciona dentro de tu computadora. Es un sistema de control 
# de versiones que registra y gestiona los cambios realizados en tus scripts a lo 
# largo del tiempo.
# 
# ¿Para qué nos sirve en epidemiología?
# - Historial completo: Guarda un registro de qué cambios se hicieron, cuándo 
#   y quién los hizo.
# - Recuperación de datos: Permite volver a una versión anterior y estable si algo se rompe.
# - Trabajo en equipo: Varios profesionales pueden modificar el proyecto en paralelo 
#   sin sobrescribir ni perder el trabajo de las demás.
#
# -> ¿Qué es GitHub?
# Es una plataforma web donde alojamos nuestros repositorios (carpetas) gestionados 
# por Git. Funciona como una nube (similar a Google Drive), pero diseñada para 
# respaldar código, publicar reportes y colaborar en proyectos de salud.
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# PARTE 2: CREACIÓN DE CUENTA EN LA WEB
# ------------------------------------------------------------------------------
# ANTES de seguir por código, necesitamos nuestra cuenta en la nube:
# 1. Entrá a https://github.com/ y hacé clic en "Sign up".
# 2. CONSEJOS:
#    - Nombre de usuario profesional (ej. 'jgomez-epidemio').
#    - Usá un mail al que siempre tengas acceso.
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# PARTE 3: PRESENTARNOS ANTE GIT EN ESTA MÁQUINA
# ------------------------------------------------------------------------------
# Git necesita firmar cada cambio con tu nombre y correo.
# Vamos a colocar nuestras credenciales en el archivo .Renviron 

# ATENCIÓN: Usá exactamente el mismo mail con el que te registraste en GitHub.

readRenviron(".Renviron")
use_git_config(
  user.name  = Sys.getenv("USUARIO"), 
  user.email = Sys.getenv("E_MAIL"))


# ------------------------------------------------------------------------------
# PARTE 4: VINCULAR RSTUDIO CON GITHUB (EL TOKEN)
# ------------------------------------------------------------------------------
# GitHub requiere un Token (una contraseña de acceso personal) para conectar RStudio.

# Paso A: Generar el Token en la web
create_github_token()
# -> Se abre el navegador. Asigná un nombre (ej: "Compu_Hospital"), 
#    bajá al final y hacé clic en "Generate token".
# -> ¡COPIÁ EL CÓDIGO LARGO QUE EMPIEZA CON 'ghp_'! Si cerrás la solapa, se pierde.

# Paso B: Guardar el Token en el sistema
gitcreds_set()
# -> Mirá la Consola (abajo). Te pedirá pegar el Token. Pegalo y apretá Enter.

# ¡LISTO EL SETUP GENERAL! Tu computadora ya está configurada para trabajar con Git.