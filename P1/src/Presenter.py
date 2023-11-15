#Clase Presenter

import gi
import threading
import time
import queue

gi.require_version('Gtk','4.0')
from gi.repository import Gtk, GLib

from Modelo import Modelo
from Vista import Vista
from PIL import Image
from io import BytesIO

import gettext
_ = gettext.gettext
import locale


class Presenter:

    def __init__(self):
        self.vista = Vista()
        self.modelo = Modelo()
        self.busqueda = []
        self.dialogo_espera = None
       
    def run(self) -> None:
        app = Gtk.Application(application_id = "com.udc.ipm.Parada_Pineiro_Olveira")
        gettext.bindtextdomain('messages', 'locales')
        gettext.textdomain('messages')
        locale.setlocale(locale.LC_ALL, 'es_ES.UTF-8')
        app.connect('activate', self.on_activate)
        app.run(None)
        
    def on_activate(self, app: Gtk.Application) -> None:
        self.vista.build_menu_principal(None,self,app,None)

    def on_coctel_clicked(self, button,app,win) -> None:
        self.vista.build_menu_busqueda_coctel(button, self,app,win)

    def on_ingrediente_clicked(self, button,app,win) -> None:
        self.vista.build_menu_busqueda_ingrediente(button, self,app,win)

    def on_menu_principal_clicked(self, button, app, win) -> None:
        self.vista.build_menu_principal(button,self,app,win)
    
    def thread_busqueda(self, busqueda, response_cola, win, app, dialogo_espera,tipo):
        time.sleep(3)
        if(tipo==1):
            response = self.modelo.search_cocktail(busqueda)
            GLib.idle_add(self.vista.hide_dialogo_espera, dialogo_espera)
            GLib.idle_add(self.on_thread_coctel_responded, response, win, busqueda, app)
        else:
            response = self.modelo.search_ingredient(busqueda)
            GLib.idle_add(self.vista.hide_dialogo_espera, dialogo_espera)
            GLib.idle_add(self.on_thread_ingrediente_responded, response, win, busqueda, app)
        
    def on_thread_coctel_responded(self, response, win, busqueda,app):

        if response is not None:
            if response != []:
                nombre = response[0]
                imagen = response[1]
                ingredientes = response[2]
                medidas = response[3]
                self.vista.build_menu_info_coctel(
                    busqueda, self, nombre, imagen, ingredientes, medidas, app, win
                )
            else:
                error = _("Error: Su busqueda no se ha podido realizar\n\nIntroduzca un nombre valido e intentelo de nuevo")
                self.vista.build_dialogo_error(self, error, 1, win)
        else:
            error = _("Error: Compruebe su conexion a internet y pruebe de nuevo")
            self.vista.build_dialogo_error(self, error, 2, win)

    def on_thread_ingrediente_responded(self, response, win, busqueda,app):

        if response is not None:
            if response != []:
                nombre = response[0]
                tipo_ing = response[1]
                alcohol_ing = response[2]
                cocteles = response[3]
                self.vista.build_menu_info_ingrediente(busqueda, self, nombre, tipo_ing, alcohol_ing, cocteles, app, win)
            else:
                error = _("Error: Su busqueda no se ha podido realizar\n\nIntroduzca un nombre valido e intentelo de nuevo")
                self.vista.build_dialogo_error(self, error, 1, win)
        else:
            error = _("Error: Compruebe su conexion a internet y pruebe de nuevo")
            self.vista.build_dialogo_error(self, error, 2, win)

    def on_busqueda_changed(self, entry, manualEntry, isManualEntry, tipo, app, win):
        if tipo == 1:
            if(isManualEntry):
                busqueda = manualEntry
            else:
                busqueda = entry.get_text()


            if busqueda.strip():
                response_queue = queue.Queue()

                dialogo_espera = self.vista.build_dialogo_espera(win)

                thread = threading.Thread(target=self.thread_busqueda, args=(busqueda, response_queue, win, app, dialogo_espera,tipo))
                thread.start()
            else:
                error = _("Error: El campo de busqueda esta vacio\n\nIntroduzca un nombre valido e intentelo de nuevo")
                self.vista.build_dialogo_error(self, error, 0, win)

        else:
            if(isManualEntry):
                busqueda = manualEntry
            else:
                busqueda = entry.get_text()

            if busqueda.strip():
                response_queue = queue.Queue()

                dialogo_espera = self.vista.build_dialogo_espera(win)

                thread = threading.Thread(target=self.thread_busqueda, args=(busqueda, response_queue, win, app, dialogo_espera,tipo))
                thread.start()
            else:
                error = _("Error: El campo de busqueda esta vacio\n\nIntroduzca un nombre valido e intentelo de nuevo")
                self.vista.build_dialogo_error(self, error, 0, win)

if __name__ == '__main__':
    presenter = Presenter()
    presenter.run()