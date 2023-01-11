
load("G:/OneDrive - Universidad de Oviedo/Uni/Y1T2/Estadística/acero.rda")

# Contrastes sobre una proporción
> No hay que estudiar normalidad, pero si hay que tener en cuenta el orden.
# Contrastes del promedio: elegir entre
> Contraste t de para una muestra (datos normales)
> Contraste de Wilcoxon (datos no normales)

> Estudiar normalidad con Shapiro-Wilk

# Comparación de proporciones
> 1. Elegir el contraste -> contraste de proporciones para dos muestras
<> Estadísticos -> Proporciones -> Test de proporciones para dos muestras
> 2. Establecer hipótesis
> 3. Interpretar el p-valor

<> Test de normalidad por grupos¡!¡!¡!¡!
<> Test de varianzas: Estadísticos -> Varianzas -> Test F para dos varianzas

t.test(consumo~linea, alternative='two.sided', conf.level=.95, var.equal=FALSE, data=acero)
t.test(consumo~linea, alternative='less', conf.level=.95, var.equal=TRUE, data=acero)
acero$dif.galv1.galv2 <- with(acero, pr.galv1-pr.galv2)

H0: datos normales
H1: no son normales
normalityTest(~dif.galv1.galv2, test="shapiro.test", data=acero)

p = 0.005665 < 0.05 -> H1
with(acero, median(pr.galv1 - pr.galv2, na.rm=TRUE)) # median difference
with(acero, wilcox.test(pr.galv1, pr.galv2, alternative='two.sided', paired=TRUE))

H0: mu.galv1 == mu.galv2
H1: mu.galv1 != mu.galv2
p-value < 2.2e-16 < 0.05 -> se rechaza H0, es H1 -> mu.galv1 != mu.galv2
