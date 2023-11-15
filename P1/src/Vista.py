#Clase Vista

import gi

gi.require_version('Gtk','4.0')
from gi.repository import Gtk
from PIL import Image
from io import BytesIO

import os
import gettext
_ = gettext.gettext

class Vista:

    def build_menu_principal(self, button, presenter, app, win):
        win1 = Gtk.ApplicationWindow(title= (_("App Cocteles")), default_width = 600, default_height = 400)
        
        app.add_window(win1)
        if(win is not None):
            win.destroy()

        grid = Gtk.Grid()

        ruta=os.path.join("imagenes","logo.jpeg")
        logo = Gtk.Image.new_from_file(ruta)
        logo.set_pixel_size(80)
        
        textolabel = '<big><b>MaxCoctelPro</b></big>'
        label = Gtk.Label()
        label.set_markup(textolabel)

        button1 = Gtk.Button(
            label=(_("Cocteles")),
        )

        button2 = Gtk.Button(
            label=(_("Ingredientes")),
        )

        label.set_hexpand(True)
        label.set_vexpand(True)
        label.set_halign(Gtk.Align.FILL)
        label.set_valign(Gtk.Align.FILL)

        button1.set_hexpand(True)
        button1.set_vexpand(True)
        button1.set_halign(Gtk.Align.FILL)
        button1.set_valign(Gtk.Align.FILL)
        button1.set_margin_start(20)
        button1.set_margin_end(20)
        button1.set_margin_top(60)
        button1.set_margin_bottom(60)

        button2.set_hexpand(True)
        button2.set_vexpand(True)
        button2.set_halign(Gtk.Align.FILL)
        button2.set_valign(Gtk.Align.FILL)
        button2.set_margin_start(20)
        button2.set_margin_end(20)
        button2.set_margin_top(60)
        button2.set_margin_bottom(60)

        logo.set_hexpand(True)
        logo.set_vexpand(True)
        logo.set_halign(Gtk.Align.FILL)
        logo.set_valign(Gtk.Align.FILL)

        grid.attach(label,1,0,1,1)
        grid.attach(button1, 0, 1, 1, 1)
        grid.attach(button2, 2, 1, 1, 1)
        grid.attach(logo, 1, 1, 1, 1)
        
        button1.connect("clicked", presenter.on_coctel_clicked,app,win1)
        button2.connect("clicked", presenter.on_ingrediente_clicked,app,win1)  

        win1.set_child(grid)
        win1.present()

    def build_dialogo_error(self, presenter, texto_fallo,tipoError,win):
        dialog = Gtk.MessageDialog(transient_for=win, modal=True)
        dialog.set_title(_("ERROR"))

        if(tipoError==2):
            ruta=os.path.join("imagenes","falloWifi.png")
            imagen_error = Gtk.Image.new_from_file(ruta)
        else:
            ruta=os.path.join("imagenes","lupa_mal.png")
            imagen_error = Gtk.Image.new_from_file(ruta)
        
        imagen_error.set_pixel_size(80)
        dialog.get_content_area().append(imagen_error)
        dialog.set_markup('<b>' + texto_fallo + '</b>')  
        boton_ok = dialog.add_button(_("OK"), Gtk.ResponseType.OK)
        boton_ok.connect("clicked", lambda btn: dialog.destroy())

    
        if dialog.present() == Gtk.ResponseType.OK:
            dialog.destroy()

    def build_menu_busqueda_coctel(self, button, presenter,app,win):
        win2 = Gtk.ApplicationWindow(title= (_("Busqueda Cocteles")), default_width = 600, default_height = 400)
        app.add_window(win2)
        win.destroy()

        grid = Gtk.Grid()

        ruta=os.path.join("imagenes","logo.jpeg")
        logo = Gtk.Image.new_from_file(ruta)
        logo.set_pixel_size(80)

        label = Gtk.Label()
        texto_aux = _("Buscador de cocteles")
        texto = '<b><span foreground="#DA720A" size="13000">' + texto_aux + '</span></b>'
        label.set_markup(texto)
        
        search_entry = Gtk.SearchEntry(placeholder_text=(_("Buscar...")), halign= Gtk.Align.CENTER)
        button1 = Gtk.Button(
            label=_("Menu principal"),
        )
        labelFalsa = Gtk.Label(
            label = "\t\t\t\t\t\t\t\t\t\t\t\t"
        )

        labelFalsa2 = Gtk.Label(
            label = "\t\t\t\t\t\t\t\t\t\t"
        )
        
        grid.attach(button1,0,0,1,1)
        grid.attach(label, 1, 0, 1, 1)
        grid.attach(labelFalsa2,0,1,1,1)
        grid.attach(search_entry, 1, 1, 1, 1)
        grid.attach(logo, 2, 0, 1, 1)
        grid.attach(labelFalsa,2,2,1,1)

        labelFalsa2.set_hexpand(True)
        labelFalsa2.set_vexpand(True)
        labelFalsa2.set_halign(Gtk.Align.FILL)
        labelFalsa2.set_valign(Gtk.Align.FILL)
        labelFalsa2.set_margin_start(20)
        labelFalsa2.set_margin_end(20)
        labelFalsa2.set_margin_top(100)
        labelFalsa2.set_margin_bottom(100)

        button1.set_hexpand(False)
        button1.set_vexpand(False)
        button1.set_halign(Gtk.Align.START)
        button1.set_valign(Gtk.Align.START)
        button1.set_margin_start(20)
        button1.set_margin_end(40)
        button1.set_margin_top(20)
        button1.set_margin_bottom(40)

        label.set_hexpand(True)
        label.set_vexpand(True)
        label.set_halign(Gtk.Align.FILL)
        label.set_valign(Gtk.Align.END)

        labelFalsa.set_hexpand(True)
        labelFalsa.set_vexpand(True)
        labelFalsa.set_halign(Gtk.Align.END)
        labelFalsa.set_valign(Gtk.Align.END)

        search_entry.set_hexpand(True)
        search_entry.set_vexpand(True)
        search_entry.set_halign(Gtk.Align.FILL)
        search_entry.set_valign(Gtk.Align.FILL)
        search_entry.set_margin_start(20)
        search_entry.set_margin_end(20)
        search_entry.set_margin_top(100)
        search_entry.set_margin_bottom(100)

        logo.set_hexpand(False)
        logo.set_vexpand(False)
        logo.set_halign(Gtk.Align.END)
        logo.set_valign(Gtk.Align.START)
        
        button1.connect("clicked", presenter.on_menu_principal_clicked,app,win2)
        search_entry.connect("activate", presenter.on_busqueda_changed,"",0,1,app,win2)


        win2.set_child(grid)
        win2.present() 

    def build_menu_busqueda_ingrediente(self, button, presenter,app,win):
        win3 = Gtk.ApplicationWindow(title= (_("Busqueda Ingredientes")), default_width = 600, default_height = 400)
        app.add_window(win3)
        win.destroy()

        grid = Gtk.Grid()

        ruta=os.path.join("imagenes","logo.jpeg")
        logo = Gtk.Image.new_from_file(ruta)
        logo.set_pixel_size(80)

        label = Gtk.Label()
        texto_aux = _("Buscador de ingredientes")
        texto = '<b><span foreground="#C10B58" size="13000">' + texto_aux + '</span></b>'
        label.set_markup(texto)

        search_entry = Gtk.SearchEntry(placeholder_text=(_("Buscar...")), halign= Gtk.Align.CENTER)
        button1 = Gtk.Button(
            label=_("Menu principal"),
        )
        labelFalsa = Gtk.Label(
            label = "\t\t\t\t\t\t\t\t\t\t\t\t"
        )
        labelFalsa2 = Gtk.Label(
            label = "\t\t\t\t\t\t\t\t\t\t"
        )
        
        grid.attach(button1,0,0,1,1)
        grid.attach(label, 1, 0, 1, 1)
        grid.attach(labelFalsa2,0,1,1,1)
        grid.attach(search_entry, 1, 1, 1, 1)
        grid.attach(logo, 2, 0, 1, 1)
        grid.attach(labelFalsa,2,2,1,1)

        labelFalsa2.set_hexpand(True)
        labelFalsa2.set_vexpand(True)
        labelFalsa2.set_halign(Gtk.Align.FILL)
        labelFalsa2.set_valign(Gtk.Align.FILL)
        labelFalsa2.set_margin_start(20)
        labelFalsa2.set_margin_end(20)
        labelFalsa2.set_margin_top(100)
        labelFalsa2.set_margin_bottom(100)

        button1.set_hexpand(False)
        button1.set_vexpand(False)
        button1.set_halign(Gtk.Align.START)
        button1.set_valign(Gtk.Align.START)
        button1.set_margin_start(20)
        button1.set_margin_end(100)
        button1.set_margin_top(20)
        button1.set_margin_bottom(100)

        label.set_hexpand(True)
        label.set_vexpand(True)
        label.set_halign(Gtk.Align.FILL)
        label.set_valign(Gtk.Align.END)

        labelFalsa.set_hexpand(True)
        labelFalsa.set_vexpand(True)
        labelFalsa.set_halign(Gtk.Align.END)
        labelFalsa.set_valign(Gtk.Align.END)

        search_entry.set_hexpand(True)
        search_entry.set_vexpand(True)
        search_entry.set_halign(Gtk.Align.FILL)
        search_entry.set_valign(Gtk.Align.FILL)
        search_entry.set_margin_start(20)
        search_entry.set_margin_end(20)
        search_entry.set_margin_top(100)
        search_entry.set_margin_bottom(100)

        logo.set_hexpand(False)
        logo.set_vexpand(False)
        logo.set_halign(Gtk.Align.END)
        logo.set_valign(Gtk.Align.START)

        button1.connect("clicked", presenter.on_menu_principal_clicked,app,win3)
        search_entry.connect("activate", presenter.on_busqueda_changed,"", 0,2,app,win3)

        win3.set_child(grid)
        win3.present()

    def build_menu_info_coctel(self, entry, presenter, nombre, imagen, ingredientes, medidas,app,win2):
        win4 = Gtk.ApplicationWindow(title= (_("Información sobre ") + nombre), default_width = 600, default_height = 400)
        app.add_window(win4)
        win2.destroy()

        grid = Gtk.Grid()

        ruta=os.path.join("imagenes","logo.jpeg")
        logo = Gtk.Image.new_from_file(ruta)
        logo.set_pixel_size(80)

        listbox = Gtk.ListBox()
        listbox.set_selection_mode(Gtk.SelectionMode.NONE)

        labelInfo = Gtk.Label()
        labelInfo.set_markup(_("<u>Ingredientes de este coctel</u>" + "\n"))

        listbox.append(labelInfo)

        i = 0

        for item in ingredientes:
            if(len(medidas) <= i):
                cantidad = ""
            else:
                cantidad = ": "+ medidas[i]

            button_ingrediente = Gtk.Button(label=item + cantidad)
            button_ingrediente.connect("clicked", presenter.on_busqueda_changed, item, 1, 2, app, win4)
            listbox.append(button_ingrediente)
            i=i+1

        scrolled_window = Gtk.ScrolledWindow()
        scrolled_window.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
        scrolled_window.set_child(listbox)

        image_widget = Gtk.Image.new_from_pixbuf(imagen)
        image_widget.set_size_request(300, 200)

        button1 = Gtk.Button(
            label=_("Menu principal"),
            halign= Gtk.Align.START
        )

        logo.set_hexpand(False)
        logo.set_vexpand(False)
        logo.set_halign(Gtk.Align.END)
        logo.set_valign(Gtk.Align.START)

        image_widget.set_hexpand(True)
        image_widget.set_vexpand(True)
        image_widget.set_halign(Gtk.Align.FILL)
        image_widget.set_valign(Gtk.Align.FILL)
        image_widget.set_margin_bottom(40)

        scrolled_window.set_margin_end(40)
        scrolled_window.set_hexpand(True)
        scrolled_window.set_vexpand(True)
        scrolled_window.set_margin_bottom(40)

        button1.set_hexpand(False)
        button1.set_vexpand(False)
        button1.set_halign(Gtk.Align.START)
        button1.set_valign(Gtk.Align.START) 
        button1.set_margin_start(20)
        button1.set_margin_end(40)
        button1.set_margin_top(20)
        button1.set_margin_bottom(40)

        grid.attach(button1,0,0,1,1)
        grid.attach(image_widget, 0, 1, 1, 1)
        grid.attach(scrolled_window, 1, 1, 1, 1)
        grid.attach(logo, 1, 0, 1, 1)
    
        button1.connect("clicked", presenter.on_menu_principal_clicked,app,win4)

        win4.set_child(grid)
        win4.present()

    def build_menu_info_ingrediente(self, entry, presenter, nombre,tipo_ing,alcohol_ing,cocteles,app,win3):
        win5 = Gtk.ApplicationWindow(title= (_("Información sobre ") + nombre), default_width = 600, default_height = 400)
        app.add_window(win5)
        win3.destroy()

        grid = Gtk.Grid()

        listbox = Gtk.ListBox()
        listbox.set_selection_mode(Gtk.SelectionMode.NONE)

        labelInfo = Gtk.Label()
        labelInfo.set_markup(_("<u>Cocteles con este ingrediente</u>"+ "\n"))

        listbox.append(labelInfo)
        
        for item in cocteles:
            button_coctel = Gtk.Button(label=item)
            button_coctel.connect("clicked", presenter.on_busqueda_changed, item, 1, 1, app, win5)
            listbox.append(button_coctel)

        scrolled_window = Gtk.ScrolledWindow()
        scrolled_window.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
        scrolled_window.set_child(listbox)

        ruta=os.path.join("imagenes","logo.jpeg")
        logo = Gtk.Image.new_from_file(ruta)
        logo.set_pixel_size(80)

        textoLabelT = _("Tipo: ") + tipo_ing
        textoLabelA = _("Alcohol?: ") + alcohol_ing
        textoLabel1 = '<b>' + nombre + '</b>' + "\n\n" + textoLabelT + "\n\n" + textoLabelA 
        label1 = Gtk.Label()
        label1.set_markup(textoLabel1)

        button1 = Gtk.Button(
            label=_("Menu principal"),
            halign= Gtk.Align.START
        )

        label1.set_hexpand(True)
        label1.set_vexpand(True)
        label1.set_halign(Gtk.Align.FILL)
        label1.set_valign(Gtk.Align.FILL)

        scrolled_window.set_hexpand(True)
        scrolled_window.set_vexpand(True)
        scrolled_window.set_halign(Gtk.Align.FILL)
        scrolled_window.set_valign(Gtk.Align.FILL)
        scrolled_window.set_margin_start(20)
        scrolled_window.set_margin_end(40)
        scrolled_window.set_margin_top(20)
        scrolled_window.set_margin_bottom(40)
        
        button1.set_hexpand(False)
        button1.set_vexpand(False)
        button1.set_halign(Gtk.Align.START)
        button1.set_valign(Gtk.Align.START)
        button1.set_margin_start(20)
        button1.set_margin_end(40)
        button1.set_margin_top(20)
        button1.set_margin_bottom(40)

        logo.set_hexpand(False)
        logo.set_vexpand(False)
        logo.set_halign(Gtk.Align.END)
        logo.set_valign(Gtk.Align.START)

        grid.attach(button1, 0,0,1,1)
        grid.attach(label1, 0, 1, 1, 1)
        grid.attach(logo, 2, 0, 1, 1)
        grid.attach(scrolled_window, 1, 1, 1, 1)
    

        button1.connect("clicked", presenter.on_menu_principal_clicked,app,win5)

        win5.set_child(grid)
        win5.present()

    def build_dialogo_espera(self,win):
        dialog = Gtk.MessageDialog(transient_for=win, modal=False)
        dialog.set_title(_("ESPERA"))
        dialog.set_markup(_('<b>Cargando...</b>'))
        dialog.set_destroy_with_parent(True)

        spinner = Gtk.Spinner()
        content_area = dialog.get_content_area()
        content_area.append(spinner)
        spinner.start()

        dialog.present()

        return dialog

    def hide_dialogo_espera(self, dialogo):
        if dialogo:
            dialogo.destroy()

        