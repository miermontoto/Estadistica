### Contraste de hipótesis
> H0. hipótesis nula
> H1. hipótesis contraria
# La hipótesis con un igual en SIEMPRE va en H0.
> Si el p-valor es menor que alpha, se rechaza H0 -> se acepta H1.
> Si el p-valor es mayor que alpha, se acepta H0.
# Se considera alpha = 0.05

load("G:/OneDrive - Universidad de Oviedo/Uni/Y1T2/Estadística/Estad-stica_R/acero.rda")

## Estudiar si el consumo medio es distinto de 120
> 1. Seleccionar el contraste adecuado
> 2. Establecer hipótesis
> 3. Interpretar el p-valor

> 1. Seleccionar el contraste válido: t para una muestra(dist. normal, paramétricos) o Wilcoxon(dist. no normal, no paramétricos)
H0. los datos siguen una distribución normal
H1. los datos NO siguen una distribución normal
<> Test de Shapiro-Wilk: Estadísticos -> Resúmenes -> Test de normalidad -> Test de Shapiro-Wilk
> Se escoge el contraste siguiendo la normalidad.

> 2. Establecer hipótesis
H0. Consumo medio = 120
H1. Consumo medio != 120

> 3. Interpretar el p-valor
<> Contraste t para una muestra: Estadísticos -> Medias -> Test t para una muestra
<> Contraste de Wilcoxon: Estadisticos -> Test no paramétricos -> Test de Wilcoxon para una muestra

> Calcular la media de una variable: Test t para una muestra con hipótesis nula 0.0

