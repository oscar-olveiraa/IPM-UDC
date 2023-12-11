# Casos de uso
Nuestra aplicación es simplemente un conversor de divisas. Su funcionalidad esencial es aplicar el cambio de una divisa a otra.
Dentro de esta idea simple, podemos diferenciar algunos casos de uso:
### Introducir Valor de Entrada
Escribir la cantidad de dinero de la moneda que queremos, para poder después convertirla a otra. En este caso de uso concreto, nos hemos encargado de hacer válido
cualquier valor de entrada del usuario (aunque no cumpla con el formato esperado), apoyándonos en un mensaje explicativo de la verdadera cantidad que se va a convertir.
### Convertir Valor
Aplicar el cambio del valor de entrada a las monedas de salida previamente establecidas, mostrando el resultado. Es durante este proceso cuando se lanza la petición
a la base de datos.
### Cambiar Moneda de Entrada
Escoger otra divisa distinta como base de la conversión. Nuestra aplicación cuenta con 17 monedas para elegir.
### Cambiar Moneda de Salida
Escoger otra divisa destino de la conversión. Si se escoge la misma moneda que la de entrada, saltará un error avisando al usuario de que debe cambiar una de las dos si
quiere realizar la conversión.
### Añadir Moneda de Salida
Indicar una nueva divisa destino de la conversión. En nuestra aplicación, se pueden tener hasta 4 posibles salidas simultáneas. No se gestiona ningún error relacionado 
con esto ya que nosotros mismos impedimos que suceda.
### Eliminar Moneda de Salida
Indicar una divisa destino menos de las actuales. En nuestra aplicación, tiene que haber como mínimo una salida. No se gestiona ningún error relacionado con esto
ya que nosotros mismos impedimos que suceda.
