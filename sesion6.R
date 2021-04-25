
load("G:/OneDrive - Universidad de Oviedo/Uni/Y1T2/Estadística/acero.rda")

### X variable explicativa/independiente

> 1. Buscar un modelo (elegir variable)
> 2. Estimación de los parámetros del modelo
> 3. Comprobaciones para saber si el modelo es fiable
> 4. Pronósticos

### Ejercicio: conocer una aproximación a la emisión de N20 on la emisión de alguno de los otros gases: CO, CO2, NOx, SO2.

 # Estudiar normalidad
<> Estadísticos -> Resúmenes -> Test de normalidad (Shaphiro-Wilk)
> CO normal
> CO2 normal
> NOx normal
> N20 normal
> SO2 normal

 # Buscar el modelo

library(lattice, pos=26)
library(survival, pos=26)
library(Formula, pos=26)
library(ggplot2, pos=26)
library(Hmisc, pos=26)
rcorr.adjust(acero[,c("CO","CO2","N2O","NOx","SO2")], type="pearson", use="complete")

 <> Estadísticos -> Resúmenes -> Matriz de correlaciones

# De esto obtenemos que:
> Con S02 no hay relación
> Con CO y CO2 hay una alta relación
> Con NOx hay una relación moderada
# Se escoge CO2 (máx. correlación)
# Se busca la recta N20 = C02*a + b


normalityTest(~CO, test="shapiro.test", data=acero)
normalityTest(~CO2, test="shapiro.test", data=acero)
normalityTest(~NOx, test="shapiro.test", data=acero)
normalityTest(~N2O, test="shapiro.test", data=acero)
normalityTest(~SO2, test="shapiro.test", data=acero)

 # Se representan gráficamente

<> Gráficas -> Matriz de diagramas de dispersión
scatterplotMatrix(~CO+CO2+N2O+NOx+SO2, regLine=FALSE, smooth=FALSE, diagonal=list(method="density"), data=acero)
<> Gráficas -> Diagrama de dispersión -> Seleccionar las cuatro opciones encima del suavizado
scatterplot(N2O~CO2, regLine=TRUE, smooth=list(span=0.5, spread=TRUE), boxplots='xy', data=acero)

 # Podemos concluir que el CO2 se ajusta bien como variable explicativa

> 2. Estimación de los parámetros del modelo
<> Estadísticos -> Ajuste de modelos -> Regresión lineal
modelo <- lm(N2O~CO2, data=acero)
summary(modelo)

# Con esto: NO2 = Estimate.(Intercept) + Estimate.CO2*CO2
#           NO2 = 1.526865 + 0.043850*CO2
# Adjusted R-squared: 0.7269 -> Un 72.69% de la variabilidad que hay en No2 es explicado con CO2

> 3. Comprobaciones para saber que el modelo es fiable

# Se estudian los residuos del modelo
# El estudio se hace de forma gráfica

oldpar <- par(oma=c(0,0,3,0), mfrow=c(2,2))
plot(modelo)
par(oldpar)
<> Modelos -> Gráficas -> Gráficas básicas de diagnóstico
# Si en la gráfica Normal Q-Q se asemejan todos los puntos a la recta, entonces los residuos son normales.
# En la gráfica de Residuals vs Fitted, la línea roja se asemeja mucho a la recta de abscisas, con lo que la damos por buena.
# La varianza es constante
# Linealidad -> no hay ningún patrón extraño

> 4. Pronósticos (solo dentro del intervalo observado)
<> Resúmenes -> Resúmenes numéricos
library(e1071, pos=31)
numSummary(acero[,"CO2", drop=FALSE], statistics=c("mean", "sd", "IQR", "quantiles"), quantiles=c(0,.25,.5,.75,1))

#### IMPORTANTE: se introduce manualmente
predict(modelo, data.frame(CO2=c(100,110,120)), interval = "prediction")

> La estimación será de 6.35
# ¿Y con una confianza del 99%?
predict(modelo, data.frame(CO2=c(100,110,120)), interval = "prediction", level=0.99)

# Si se quiere el intervalo de confianza para la media estimada de N2O
predict(modelo, data.frame(CO2=c(110)), interval = "prediction", level=0.95)
# Con una confianza del 95% podemos decir que la emsión MEDIA de N2O en aquellas horas en las que la emisión de CO2 es 110, estará entre 6.14 y 6.55
