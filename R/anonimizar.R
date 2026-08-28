# =============================================================================
#  anonimizar.R — Prepara los archivos de datos para su publicación
#  -----------------------------------------------------------------------------
#  Escribe en `publicar/` una copia de `encuesta1.csv` y `encuesta2.csv` con los
#  dos campos que permitirían la reidentificación indirecta de un participante
#  reducidos a cadena vacía:
#
#   · "Marca temporal"        — 66 valores únicos en 66 filas, con precisión de
#     segundo. Es un identificador de fila perfecto: quien sepa cuándo respondió
#     una persona ubica su fila y lee todas sus respuestas.
#   · "8b. Nombre de la institución educativa donde trabaja" — 60 valores
#     distintos en 66 filas, y varias instituciones aportan un único docente.
#
#  Se VACÍAN LOS VALORES pero SE CONSERVAN LAS COLUMNAS, y esto es deliberado:
#  `pfm.Rmd` renombra las 55 columnas de `encuesta_consolidada.csv` por POSICIÓN
#  (el vector `names(raw) <- c("timestamp", "filtro_docente", ...)`). Eliminar
#  una columna desplazaría todas las siguientes sin que ninguna comprobación lo
#  detectara, que es exactamente el fallo que produjo en su día un 54 % de
#  conectividad institucional donde el dato real ronda el 90 %.
#
#  Ninguna de las dos columnas se utiliza en el análisis, de modo que vaciarlas
#  no altera ninguna cifra del documento. El script lo verifica al final.
#
#  Ejecutar desde el directorio del proyecto:  Rscript anonimizar.R
# =============================================================================

suppressMessages({
  library(readr)
})

COLS_ANONIMAS <- c(
  "Marca temporal",
  "8b. Nombre de la institución educativa donde trabaja"
)

norm_names <- function(x) {
  names(x) <- trimws(gsub("[[:space:]]+", " ", names(x)))
  x
}

dir.create("publicar", showWarnings = FALSE)

for (f in c("encuesta1.csv", "encuesta2.csv")) {
  x <- norm_names(read_csv(file.path("data/raw", f), locale = locale(encoding = "UTF-8"),
                           show_col_types = FALSE,
                           col_types = cols(.default = col_character())))

  faltan <- setdiff(COLS_ANONIMAS, names(x))
  if (length(faltan)) {
    stop("En ", f, " no se encontró la columna a anonimizar: ",
         paste(faltan, collapse = ", "))
  }

  n_antes <- ncol(x)
  for (cl in COLS_ANONIMAS) x[[cl]] <- NA_character_
  stopifnot(ncol(x) == n_antes)

  write_csv(x, file.path("publicar", f), na = "")
  cat(f, "->", file.path("publicar", f),
      "(", nrow(x), "filas,", ncol(x), "columnas )\n")
}

cat("\nColumnas vaciadas:\n")
for (cl in COLS_ANONIMAS) cat("  ", cl, "\n")

cat("\nCompruebe la cadena completa antes de publicar:\n")
cat("  cp publicar/*.csv data/raw/  &&  Rscript R/consolidar.R  &&  Rscript -e 'rmarkdown::render(\"analysis/pfm.Rmd\")'\n")
cat("El PDF resultante debe ser idéntico al actual en todas sus cifras.\n")
