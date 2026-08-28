# =============================================================================
#  consolidar.R — Construcción de `encuesta_consolidada.csv`
#  -----------------------------------------------------------------------------
#  Une `encuesta1.csv` (recolección de la cotesista) y `encuesta2.csv`
#  (recolección propia) en un único archivo de análisis.
#
#  El emparejamiento se hace POR NOMBRE DE COLUMNA NORMALIZADO, nunca por
#  posición: `encuesta2.csv` incluye una columna adicional de filtro
#  ("¿Es docente o ha sido docente de matemáticas o ciencias afines?") y varios
#  encabezados difieren en espacios finales. Un `bind_rows` posicional
#  desalinearía las columnas a partir de la extra y produciría faltantes
#  silenciosos.
#
#  Ejecutar desde el directorio del proyecto:  Rscript consolidar.R
# =============================================================================

suppressMessages({
  library(readr)
  library(dplyr)
})

norm_names <- function(x) {
  n <- trimws(gsub("[[:space:]]+", " ", names(x)))
  names(x) <- n
  x
}

e1 <- norm_names(read_csv("data/raw/encuesta1.csv", locale = locale(encoding = "UTF-8"),
                          show_col_types = FALSE, col_types = cols(.default = col_character())))
e2 <- norm_names(read_csv("data/raw/encuesta2.csv", locale = locale(encoding = "UTF-8"),
                          show_col_types = FALSE, col_types = cols(.default = col_character())))

COL_FILTRO <- "¿Es docente o ha sido docente de matemáticas o ciencias afines?"

# --- Verificación: fuera la columna de filtro, ambos archivos deben coincidir --
extra <- setdiff(names(e2), names(e1))
falta <- setdiff(names(e1), names(e2))
stopifnot(identical(extra, COL_FILTRO), length(falta) == 0)

e1[[COL_FILTRO]] <- NA_character_          # el formulario 1 no incluía el filtro
e1$fuente <- "encuesta1"
e2$fuente <- "encuesta2"

orden <- c(names(e1)[1], COL_FILTRO, "fuente",
           setdiff(names(e1), c(names(e1)[1], COL_FILTRO, "fuente")))

consolidada <- bind_rows(e1[orden], e2[orden])

# --- Verificación de integridad frente a los archivos de origen ---------------
ts <- names(consolidada)[1]
stopifnot(nrow(consolidada) == nrow(e1) + nrow(e2))
for (cl in setdiff(names(consolidada), c("fuente", COL_FILTRO))) {
  orig <- c(e1[[cl]], e2[[cl]])
  if (!identical(consolidada[[cl]], orig)) {
    stop("Columna desalineada al consolidar: ", cl)
  }
}

write_csv(consolidada, "data/derived/encuesta_consolidada.csv", na = "")

cat("data/derived/encuesta_consolidada.csv escrito\n")
cat("  encuesta1:", nrow(e1), "respuestas\n")
cat("  encuesta2:", nrow(e2), "respuestas\n")
cat("  total    :", nrow(consolidada), "respuestas\n")
cat("  columnas :", ncol(consolidada), "\n")
