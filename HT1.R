library(readxl)

# Establecer el directorio de trabajo
setwd("D:/Repositorios/SoftwareEstadistico_HT1")

# Leer las hojas 1 y 2 de datos de supermarket
hoja1 <- read_xlsx("Supermarket_Transactions.xlsx", sheet = "Data")
hoja2 <- read_xlsx("Supermarket_Transactions.xlsx", sheet = "Hoja1", skip = 2)

# Crear una base de datos de consumo, mediante el comando merge
consumo <- merge(hoja1, hoja2)

# Determinar el numero de filas y columnas
n_filas <- nrow(consumo)
n_columnas <- ncol(consumo)

# Obtener una muestra aleatoria simple (m.a.s) de 30 elementos sin reposición usando la funcion set.seed
set.seed(1993)
idSinReposicion <- sample(1:n_filas, 30, replace = FALSE)
muestraSinReposicion <- consumo[idSinReposicion,]

# Obtener una m.a.s de 20 elementos con reposicion
set.seed(8)
idConReposicion <- sample(1:n_filas, 20, replace = TRUE)
muestraConReposicion <- consumo[idConReposicion,]

# Realice una muestra sistematica de 30 elementos
set.seed(1)
primerElementoSistematico <- sample(1:n_filas, 1)
incrementoSistematico <- floor(n_filas / 30)
consumo30Sistematico <- seq(from = primerElementoSistematico, by = incrementoSistematico, length.out = 30)
consumo30Sistematico <- consumo30Sistematico %% n_filas
muestraSistematica <- consumo[consumo30Sistematico,]

# Obtener la muestra estratificada usando la variable Product.Family

# Identificar los estratos

# Obtener 90 muestras en las cuales 30, 30, 30 corresponde a cada categoria