
load("G:/OneDrive - Universidad de Oviedo/Uni/Y1T2/Estadística/Estad-stica_R/VidaEstudiantes3.RData")
# Nota antes de empezar: en Pearson, si no hay normalidad y la n es grande, sigue siendo válido.

### Pregunta 1

# Se recodifica la variable
Datos <- within(Datos, {
  LlamadaEmitidaRecodificada <- Recode(LlamadaEmitida, 'lo:1 = "Corta"; 1:2 = "Media"; 2:hi = "Larga";', 
  as.factor=TRUE)
})
# Se obtienen las frecuencias mediante un resumen de la distribución de frecuencias
local({
  .Table <- with(Datos, table(LlamadaEmitidaRecodificada))
  cat("\ncounts:\n")
  print(.Table)
  cat("\npercentages:\n")
  print(round(100*.Table/sum(.Table), 2))
})
# Se filtra y se crea un nuevo conjunto del que solo formen parte aquellos individuos que pertenezcan a un grupo distinto de 'A'.
DatosGrupoNoA <- subset(Datos, subset=Grupo != "A")
# Se halla la frecuencia de la misma manera que en el apartado anterior.
local({
  .Table <- with(DatosGrupoNoA, table(LlamadaEmitidaRecodificada))
  cat("\ncounts:\n")
  print(.Table)
  cat("\npercentages:\n")
  print(round(100*.Table/sum(.Table), 2))
})

### Pregunta 2
## Se pregunta si el tiempo promedio que se utiliza el campus y el estudio de lunes a viernes son diferentes.
# Primero se analiza la normalidad de las variables

> H0: se sigue una distribución normal
> H1: NO se sigue una distribución normal
normalityTest(~TiempoCampus, test="shapiro.test", data=DatosGrupoNoA)
normalityTest(~EstudioLaV, test="shapiro.test", data=DatosGrupoNoA)
# En ambos casos, el p-valor es inferior al nivel de significación, 0.05, con lo que NO siguen una distribución normal.

# Se escoge, en este caso, el test de Wilcoxon para muestras pareadas al no presentar ninguna de ellas normalidad.
# Estamos trabajando con muestras INDEPENDIENTES porque el tiempo que se usa en una de las actividades no está
# disponible para la otra, es decir, que dependen entre sí.
# Se escogen las hipótesis:
> H0: media(TiempoCampus) == media(EstudioLaV)
> H1: media(TiempoCampus) != media(EstudioLaV)

with(Datos, median(TiempoCampus - EstudioLaV, na.rm=TRUE)) # median difference
with(Datos, wilcox.test(TiempoCampus, EstudioLaV, alternative='two.sided', paired=TRUE))

# Se analiza el p-valor y se concluye que, como el valor es MENOR a 2.2e-16 y por lo tanto mucho
# menor a 0.05 que es el valor que se buscaba superar, se rechaza H0 y, por lo tanto, hay suficientes
# evidencias para rechazar que los tiempos medios sean iguales.

### Ejercicio 3
## Se pide estudiar la dependencia entre dos datos.
# Como ambos datos son CUALITATIVOS, se escoge el test de independencia Chi-Cuadrado.
library(abind, pos=25)
local({
  .Table <- xtabs(~Fumar+TP, data=Datos)
  cat("\nFrequency table:\n")
  print(.Table)
  cat("\nTotal percentages:\n")
  print(totPercents(.Table))
  .Test <- chisq.test(.Table, correct=FALSE)
  print(.Test)
  cat("\nExpected counts:\n")
  print(.Test$expected)
})
# Puesto que el p-valor obtenido es mayor que 0.05, suponemos que hay independencia estadística entre las variables
local({
  .Table <- xtabs(~Fumar+TP, data=Datos)
  cat("\nFrequency table:\n")
  print(.Table)
  cat("\nRow percentages:\n")
  print(rowPercents(.Table))
  .Test <- chisq.test(.Table, correct=FALSE)
  print(.Test)
  cat("\nExpected counts:\n")
  print(.Test$expected)
})

### Ejercicio 4
## Se quiere ver si el tiempo medio que pasan dos grupos en redes sociales es igual o no.
# Primero de todo, observamos normalidad SEGÚN GRUPO
> H0: se sigue una distribución normal
> H1: NO se sigue una distribución normal
normalityTest(Redes ~ Grupo, test="shapiro.test", data=Datos)
# Ambos p-valores son menores que 0.05, con lo que NO siguen una distribución normal
# Son muestras independientes porque no dependen los individuos de un grupo de los de otro.
# Deberia ser el test de Wilcoxon para dos muestras (independientes) pero no puedo
# elegir por grupo.


### Ejercicio 5
## Se quiere decidir si el promedio de horas viendo la TV es distinto de 7:
# Se estudia normalidad:
> H0: se sigue una distribución normal
> H1: NO se sigue una distribución normal
normalityTest(~TV, test="shapiro.test", data=Datos)
# Se obtiene un p-valor mucho menor a 0.05, con lo que se rechaza H0 y se determina que no es normal.
# Como no es normal, se aplica el test de Wilcoxon para una muestra.
> H0: media(TV) == 7
> H1: media(TV) != 7

with(Datos, median(TV, na.rm=TRUE))
with(Datos, mean(TV, na.rm=TRUE))
with(Datos, wilcox.test(TV, alternative='two.sided', mu=7))
# Como sale un p-valor mayor que 0.05, se ACEPTA H0 con lo que la media es igual a 7.

### Ejercicio 6
## Durante todo el ejercicio se sigue una distribución Weibull.
# Como se trata de una distribución normal, es ESTADÍSTICAMENTE IMPOSIBLE que sea igual a un solo valor. p(W=0)=0
pweibull(c(1), shape=1.3, scale=2, lower.tail=TRUE)
# Puesto que en la cola izquierda (en distribuciones continuas) da lo mismo menor que menor o igual, los
# resultados de los apartados 2 y 3 son iguales.
pweibull(c(1,3), shape=1.3, scale=2, lower.tail=FALSE)
# Para el apartado 4, el resultado está claro.
# Para el apartado 5 se resta una cola derecha 1 a una cola izquierda 1
pweibull(c(3), shape=1.3, scale=2, lower.tail=TRUE)
0.8162208 - 0.6662261

# Como Poisson es una distribución discreta, esta vez la probabilidad de igual NO es cero.
local({
  .Table <- data.frame(Probability=dpois(0:6, lambda=1))
  rownames(.Table) <- 0:6 
  print(.Table)
})
# p(X < 2) == p(X <= 1) <- porque las colas son muy traicioneras
ppois(c(1), lambda=1, lower.tail=TRUE)
ppois(c(2), lambda=1, lower.tail=TRUE)
qpois(c(.5), lambda=1, lower.tail=TRUE)


### Ejercicio 7
## Se pregunta información sobre una variable
# Primero se obtiene un resumen de la variable.
numSummary(Datos[,"Nota", drop=FALSE], statistics=c("mean", "sd", "IQR", "quantiles", "median", "max"), quantiles=c(.95))
# De aquí se obtiene directamente el percentil 95 y la desviación típica
# Luego podemos obtener los datos de manera manual (incluyendo Datos$ delante porque si no no encuentra la variable)
median(Datos$Nota)
max(Datos$Nota)
var(Datos$Nota)

### Ejercicio 8
## Se quiere estudiar la dependencia lineal entre dos variables
# Como ambas variables son cuantittivas, se utiliza el test de correlación de Pearson
# Se evalua la normalidad
normalityTest(~EstudioLaV, test="shapiro.test", data=Datos)
normalityTest(~TV, test="shapiro.test", data=Datos)
# Ninguna de las variables es normal.
# Voy a suponer que n = 400+ se toma como "grande"
> H0: r=0 (no hay relación lineal)
> H1: r!=0 (hay relación lineal)
with(Datos, cor.test(EstudioLaV, TV, alternative="two.sided", method="pearson"))
# El p-valor es muy superior a 0.05, con lo que se acepta H0 y no hay relación lineal
# Además, rho es prácticamente 0, con lo que es nula.

### Ejercicio 9
## Nos preguntan por la variable Carnet.
# Analizamos las frecuencias.
local({
  .Table <- with(Datos, table(Carnet))
  cat("\ncounts:\n")
  print(.Table)
  cat("\npercentages:\n")
  print(round(100*.Table/sum(.Table), 2))
})

# Se establecen hipótesis.
> H0: proporción <= 0.57
> H1: proporción > 0.57


local({
  .Table <- xtabs(~ Carnet , data= Datos )
  cat("\nFrequency counts (test is for first level):\n")
  print(.Table)
  prop.test(rbind(.Table), alternative='greater', p=.57, conf.level=.95, correct=FALSE)
})

### Ejercicio 10
## Se busca la recta EstudioFinde = Redes*a + b
# Se estudia la normalidad
normalityTest(~EstudioFinde, test="shapiro.test", data=Datos)
normalityTest(~Redes, test="shapiro.test", data=Datos)
# No son normales?!?!?!

# Se representan gráficamente
scatterplot(EstudioFinde~Redes, regLine=TRUE, smooth=list(span=0.5, spread=TRUE), boxplots='xy', data=Datos)
# Estimación de parámetros del modelo

modelo <- lm(EstudioFinde~Redes, data=Datos)
summary(modelo)
# Algo está fallando y no tengo muy claro el qué.

# Se obtienen los valores: (Intercept)Estimate es b y Redes.Estimate es a

# La R cuadrado es negativa???

predict(modelo, data.frame(Redes=c(13.5)), interval = "prediction")


#### Final del examen
# ¿Cómo es posible que no me haya salido ni una sola variable normal?
