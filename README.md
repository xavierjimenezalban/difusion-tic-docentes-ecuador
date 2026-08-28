# Difusión de herramientas digitales en la enseñanza de matemáticas

Datos, código y documento reproducible del estudio sobre la difusión de GeoGebra,
Desmos y Khan Academy entre docentes de matemáticas del Ecuador.

Se reconstruyen las series temporales de adopción de las tres herramientas a
partir del año de primera adopción reportado retrospectivamente, se ajustan tres
modelos de difusión (logístico, Gompertz y Bass) por mínimos cuadrados no
lineales, se demuestra por simulación que los criterios de información no pueden
discriminar entre ellos en series de esta longitud, y se caracterizan los
perfiles contextuales de adopción mediante Análisis de Correspondencia Múltiple.

- **Trabajo de titulación**: Maestría en Educación, mención Enseñanza de la
  Matemática — Universidad de Guayaquil.
- **Autoría del contenido de este repositorio** —código de análisis, canalización
  de datos y documento reproducible—: Xavier Jiménez-Albán
  ([0000-0002-7227-9392](https://orcid.org/0000-0002-7227-9392)).
- **Firmas del trabajo de titulación**: Xavier Jiménez-Albán y Susan Narváez.
- **Dirección del trabajo de titulación**: Víctor Manuel Barros
  ([0000-0001-8542-6454](https://orcid.org/0000-0001-8542-6454)) — Universidad de Guayaquil.
- **DOI del archivo citable**: <!-- TODO: pegar el DOI de Zenodo -->
- **Muestra analizada**: N = 63 docentes (66 respuestas recibidas, 3 excluidas
  por no ejercer ni haber ejercido la docencia en matemáticas o ciencias afines).

## Cómo citar

Use el DOI de Zenodo, no la URL de este repositorio: GitHub es mutable y un
cambio de nombre de repositorio o de cuenta rompería el enlace de forma
permanente. El archivo `CITATION.cff` genera la cita en APA y BibTeX; GitHub
muestra un botón «Cite this repository» a partir de él.

## Contenido

| Archivo | Qué es |
|---|---|
| `analysis/pfm.Rmd` | Fuente del documento completo. Genera el PDF y contiene todo el código de análisis |
| `R/consolidar.R` | Une los dos formularios en `encuesta_consolidada.csv`, emparejando **por nombre de columna normalizado, nunca por posición**, y validando la integridad columna a columna |
| `R/anonimizar.R` | Prepara los CSV para su publicación (ver «Anonimización») |
| `data/raw/encuesta1.csv`, `data/raw/encuesta2.csv` | Los dos frentes de recolección, ya anonimizados |
| `data/derived/encuesta_consolidada.csv` | Archivo de análisis. 66 filas, 55 columnas |
| `referencias.bib`, `apa.csl` | Bibliografía y estilo de citas |
| `cover.tex`, `header.tex`, `logo.png` | Portada y preámbulo LaTeX |

**El PDF compilado no se distribuye en este repositorio.** Se obtiene ejecutando
los dos comandos de la sección siguiente, que lo reconstruyen a partir de estos
mismos archivos.

## Cómo reproducirlo

```bash
Rscript R/consolidar.R                        # regenera data/derived/encuesta_consolidada.csv
Rscript -e 'rmarkdown::render("analysis/pfm.Rmd")'   # genera analysis/pfm.pdf
```

**Trampa conocida.** Si `pandoc` no está en el `PATH` del sistema, `render()`
falla con «pandoc version 1.12.3 or higher is required». En una instalación de
RStudio el binario vive dentro de la propia aplicación:

```bash
export PATH="/usr/lib/rstudio/resources/app/bin/quarto/bin/tools/x86_64:$PATH"
```

La primera compilación tarda unos minutos: el remuestreo bootstrap y el
experimento de simulación suman 27 000 ajustes no lineales. Ambos chunks van con
`cache = TRUE`, de modo que las compilaciones siguientes son rápidas. **Si
cambian los datos, borre `analysis/pfm_cache/`**, o el bootstrap y la simulación quedarán
calculados sobre los datos anteriores.

Aparece de forma habitual el aviso `!h float specifier changed to !ht`. Es
benigno.

## Por qué reproduce de verdad

Las dos semillas están fijadas en el código (`set.seed(2026)` en el bootstrap y
en la simulación). Quien clone este repositorio obtiene **exactamente** el 42,0 %
de acierto del AIC y **exactamente** el mismo intervalo del techo de adopción, no
unos valores parecidos.

### Entorno de referencia

```
R 4.3.3 (2024-02-29) — x86_64-pc-linux-gnu (64-bit)
pandoc 3.1.11

tidyverse  2.0.0     ggplot2     4.0.2     dplyr      1.2.1
tibble     3.2.1     tidyr       1.3.2     readr      2.1.5
purrr      1.0.2     stringr     1.5.1     forcats    1.0.0
lubridate  1.9.3     knitr       1.51      kableExtra 1.4.0
scales     1.4.0     FactoMineR  2.16      factoextra 2.2.0
psych      2.6.5     broom       1.0.6     readxl     1.4.3
```

Las versiones importan: los valores por defecto de `FactoMineR` o de `nls()`
pueden cambiar entre versiones, y con ellos los resultados.

## Anonimización

El formulario no recogía el correo ni el nombre del respondente, de modo que
ninguna celda contiene datos de contacto. Aun así, dos campos permitían la
reidentificación indirecta y se publican vacíos:

- **`Marca temporal`** — 66 valores únicos en 66 filas, con precisión de segundo.
  Es un identificador de fila perfecto: quien sepa cuándo respondió una persona
  ubica su fila y lee todas sus respuestas.
- **`8b. Nombre de la institución educativa donde trabaja`** — 60 valores
  distintos en 66 filas, y varias instituciones aportan un único docente.

Ninguno de los dos se usa en el análisis, así que vaciarlos no altera ninguna
cifra del documento.

**Se vacían los valores pero se conservan las columnas, y es deliberado.**
`analysis/pfm.Rmd` renombra las 55 columnas del archivo consolidado por posición;
eliminar una columna desplazaría todas las siguientes sin que ninguna
comprobación lo detectara.

## Licencias

Este repositorio contiene tres clases de material y cada una tiene su licencia:

| Material | Archivos | Titular | Licencia |
|---|---|---|---|
| **Código** | `R/consolidar.R`, `R/anonimizar.R`, los bloques de código de `analysis/pfm.Rmd`, `*.tex` | Xavier Jiménez-Albán | MIT — ver `LICENSE-CODE` |
| **Datos** | Los tres CSV de `data/` | Ambos autores | CC BY 4.0 — ver `LICENSE` |
| **Documento** | El texto del trabajo de titulación: la prosa de `analysis/pfm.Rmd` | Ambos autores | CC BY 4.0 — ver `LICENSE` |

El código de análisis y el texto del trabajo son obras distintas con autoría distinta,
y por eso se licencian por separado. El archivo `CITATION.cff` es otra cosa: declara
cómo debe **citarse** el trabajo, que es el trabajo de titulación completo, y por eso
recoge las dos firmas.

El trabajo de titulación conserva además la **licencia gratuita, intransferible y no
exclusiva para el uso no comercial de la obra con fines no académicos** que el Anexo X
del *Reglamento para el Proceso de Titulación en Posgrado* obliga a otorgar a favor de
la Universidad de Guayaquil, conforme al artículo 114 del Código Orgánico de la Economía
Social de los Conocimientos, Creatividad e Innovación.

Esa concesión y la CC BY 4.0 de este repositorio **no entran en conflicto**, y conviene
dejar dicho por qué, porque a primera vista una permite el uso comercial y la otra no.
El propio Anexo X declara que los contenidos son «de mi/nuestra absoluta propiedad»: la
titularidad no se cede. Y califica la licencia de **no exclusiva**, de modo que no
impide a los titulares conceder otras sobre la misma obra. La restricción a uso no
comercial acota lo que la Universidad puede hacer con el trabajo, no lo que pueden
hacer quienes lo firman.

## Contribuciones

- **Xavier Jiménez-Albán**
  ([0000-0002-7227-9392](https://orcid.org/0000-0002-7227-9392)) —
  Conceptualización y diseño del estudio. Metodología. *Software*: desarrollo
  íntegro del código de análisis, de la canalización de datos y del documento
  reproducible. Análisis formal. Curación y anonimización de los datos.
  Visualización. Redacción del borrador original y de la versión revisada.
  Investigador responsable del instrumento. Difusión y administración de **los dos
  frentes de recolección** (`data/raw/encuesta1.csv` y `data/raw/encuesta2.csv`).
  Administración del proyecto.
- **Susan Narváez** — Gestión del acceso a la institución del núcleo inicial y
  administración de la encuesta en la Unidad Educativa Particular Siete de Mayo
  (Machala).
- **Víctor Manuel Barros**
  ([0000-0001-8542-6454](https://orcid.org/0000-0001-8542-6454)) — Dirección
  académica del trabajo de titulación.

Las contribuciones se declaran conforme a la taxonomía CRediT. La autoría de este
repositorio recoge a quien desarrolló su contenido —el código, la canalización de
datos y el documento reproducible—, que es un criterio distinto del de las firmas
del trabajo de titulación; estas constan en `CITATION.cff`, que es donde se declara
cómo debe citarse la obra.

La columna `fuente` del archivo consolidado identifica de cuál de los dos
formularios procede cada registro.

## Lo que este repositorio no contiene

Por respeto a personas que no consintieron la difusión de sus datos, quedan
deliberadamente fuera la nómina de docentes empleada para la difusión, el
listado de correos electrónicos de contacto y la autorización institucional
firmada, que lleva la firma y el membrete de un tercero.
