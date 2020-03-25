library(readxl)

################################################################
########### Establecer el directorio de trabajo ################
################################################################
setwd("D:/Repositorios/SoftwareEstadistico_HT1")

# Leer las hojas 1 y 2 de datos de supermarket
hoja1 <- read_xlsx("Supermarket_Transactions.xlsx", sheet = "Data")
hoja2 <- read_xlsx("Supermarket_Transactions.xlsx", sheet = "Hoja1", skip = 2)

# Crear una base de datos de consumo, mediante el comando merge
consumo <- merge(hoja1, hoja2)

################################################################
######### Determinar el numero de filas y columnas #############
################################################################
n_filas <- nrow(consumo)
n_columnas <- ncol(consumo)

################################################################################################################################
####### Obtener una muestra aleatoria simple (m.a.s) de 30 elementos sin reposición usando la funcion set.seed #################
################################################################################################################################
set.seed(1993)
idSinReposicion <- sample(1:n_filas, 30, replace = FALSE)
muestraSinReposicion <- consumo[idSinReposicion,]

################################################################
###### Obtener una m.a.s de 20 elementos con reposicion ########
################################################################
set.seed(8)
idConReposicion <- sample(1:n_filas, 20, replace = TRUE)
muestraConReposicion <- consumo[idConReposicion,]

################################################################
######## Realice una muestra sistematica de 30 elementos #######
################################################################
set.seed(1)
primerElementoSistematico <- sample(1:n_filas, 1)
incrementoSistematico <- floor(n_filas / 30)
consumo30Sistematico <- seq(from = primerElementoSistematico, by = incrementoSistematico, length.out = 30)
consumo30Sistematico <- consumo30Sistematico %% n_filas
muestraSistematica <- consumo[consumo30Sistematico,]

################################################################################################################################
########### Obtener la muestra estratificada usando la variable Product.Family Identificar los estratos ########################
########### Obtener 90 muestras en las cuales 30, 30, 30 corresponde a cada categoria ##########################################
################################################################################################################################
# Primero identificar los estratos
categorias <- unique(consumo$`Product Family`)

# Luego obtener las muestras de los estratos
consumoOrdenado <- c()
# Recorrer cada uno de los estratos identificados
for (i in 1:length(categorias)) {
  # Si es el primer estrato, limpiar la muestraEstratificada
  if(i == 1) {
    muestraEstratificada <- c()
  }
  
  # Obtener subset del estrato
  consumoOrdenado <- subset(consumo, consumo$`Product Family` == categorias[i], select = colnames(consumo))
  # Identificar si el tamanio de la muestra del estrato es menor a la cantidad de elementos que queremos obtener
  banderaReemplazo <- nrow(consumoOrdenado) < 30
  # Fijar bandera unica para cada estrato
  set.seed(length(consumoOrdenado))
  # Unir data frames con rbind
  muestraEstratificada <- rbind(
    muestraEstratificada, 
    # Obtener muestra desde el subset del estrato
    consumoOrdenado[sample(1:nrow(consumoOrdenado), 30, replace = banderaReemplazo),]
    )
}

################################################################################################################################
############### Seleccionar los datos de 4 ciudades mediante conglomerados para analizar sus precios ###########################
################################################################################################################################

ciudades <- unique(consumo$City)
set.seed(length(ciudades))
ciudadesElegidas <- ciudades[sample(1:length(ciudades), 4, replace = FALSE)]
muestraDeConglomerados <- consumo[consumo$City %in% ciudadesElegidas, ]

######################################################################################################
###### Muestreo polietapico de 4 ciudades, y una submuestra de 10 productos por cada genero ##########
######################################################################################################
# Primero identificar los generos
generos <- unique(muestraDeConglomerados$Gender)

# Luego obtener las muestras de los estratos
consumoPolietapico <- c()
# Recorrer cada uno de los estratos identificados
for (i in 1:length(generos)) {
  # Si es el primer estrato, limpiar la muestraEstratificada
  if(i == 1) {
    muestraPolietapico <- c()
  }
  
  # Obtener subset del estrato
  consumoPolietapico <- subset(muestraDeConglomerados, muestraDeConglomerados$Gender == generos[i], select = colnames(muestraDeConglomerados))
  # Identificar si el tamanio de la muestra del estrato es menor a la cantidad de elementos que queremos obtener
  banderaReemplazo <- nrow(consumoPolietapico) < 10
  # Fijar bandera unica para cada estrato
  set.seed(length(consumoPolietapico))
  # Unir data frames con rbind
  muestraPolietapico <- rbind(
    muestraPolietapico, 
    # Obtener muestra desde el subset del estrato
    consumoPolietapico[sample(1:nrow(consumoPolietapico), 10, replace = banderaReemplazo),]
  )
}
