#Clase Modelo

import requests
import json
import base64
from PIL import Image
from io import BytesIO
import gi
gi.require_version('Gtk', '4.0')
from gi.repository import GdkPixbuf
import time
import gettext
_ = gettext.gettext

class Modelo:

    def search_cocktail(self,nombre) -> list:
        url="https://www.thecocktaildb.com/api/json/v1/1/search.php?s="
        url = url + nombre
    
        try:
            response=requests.get(url)

            if response.status_code == 200:
                
                comenzar = False
                campos = response.json()


                if(campos['drinks'] is None):
                    return []


                listacampos = campos['drinks'][0]

                resultadoIngredientes = []
                resultadoMedidas = []
                resultadoFinal = []

                nombre_coctel=campos['drinks'][0]['strDrink']
                url_imagen=campos['drinks'][0]['strDrinkThumb']   
                imagen = self.get_image(url_imagen)
                resultadoFinal.append(nombre_coctel) 
                resultadoFinal.append(imagen)


                for clave,valor in listacampos.items():

                    if(clave=='strIngredient1'):
                        comenzar = True
                    if(comenzar):
                        if(valor is None):
                            resultadoFinal.append(resultadoIngredientes)
                            break
                        resultadoIngredientes.append(valor)
                        
                comenzar= False
     
                for clave,valor in listacampos.items():

                    if(clave=='strMeasure1'):
                        comenzar=True
                    if(comenzar):
                        if(valor is None):
                            resultadoFinal.append(resultadoMedidas)
                            break
                        resultadoMedidas.append(valor)

                return resultadoFinal
            elif response.status_code == 404:
                error = []
                error.append[_("fallo")]
                return error
            else:
                error2 = []
                error2.append[_("fallo2")]
                return error2
        
        except Exception as e:
            return None
                
    def search_ingredient(self,nombre) -> list:
        url="https://www.thecocktaildb.com/api/json/v1/1/search.php?i="
        url = url + nombre
    
        try:
            response=requests.get(url)
            
            if response.status_code == 200:
                resultadoFinal = []
                campos = response.json()

                if(campos['ingredients'] is None):
                    return []
                
                listacampos = campos['ingredients'][0]
                nombre_ingrediente=campos['ingredients'][0]['strIngredient']  
                tipo_ingrediente=campos['ingredients'][0]['strType']
                alcohol_ingrediente=campos['ingredients'][0]['strAlcohol']
                resultadoFinal.append(nombre_ingrediente)
                if(tipo_ingrediente is None):
                    resultadoFinal.append(_("Desconocido"))
                else:
                    resultadoFinal.append(tipo_ingrediente)    

                resultadoFinal.append(alcohol_ingrediente)
                lista_coctel = self.filter_by_ingredient(nombre_ingrediente)

                resultadoFinal.append(lista_coctel)

                return resultadoFinal
            else:
                error2 = []
                error2.append[_("fallo2")]
                return error2           
        except Exception as e:
            return None

    def filter_by_ingredient(self,nombre) -> list:
        url="https://www.thecocktaildb.com/api/json/v1/1/filter.php?i="
        url = url + nombre
        try:
            response=requests.get(url)
            
            if response.status_code == 200 and len(response.content) > 0:
                lista_final = []

                campos = response.json()
           
                lista_cocteles = campos['drinks']
                if(lista_cocteles is None):
                    return None
                for clave in lista_cocteles:
                    lista_final.append(clave['strDrink'])
                return lista_final
            else:
                return []
                
        except Exception as e:
            return None

    def get_image(self,url_imagen) -> GdkPixbuf:
        response = requests.get(url_imagen)
        if response.status_code == 200:
            image_data = response.content
            loader = GdkPixbuf.PixbufLoader.new()
            loader.write(image_data)
            pixbuf = loader.get_pixbuf()
            loader.close()
            return pixbuf