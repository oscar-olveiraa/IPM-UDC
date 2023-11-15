# Diseño software

## Documentación
El diseño sigue el patrón Modelo-Presentador-Vista; el Modelo es el encargado de realizar las operaciones sobre la base de datos (búsquedas),
la Vista se encarga de todo lo relacionado con la parte visual de la interfaz, y el Presentador trabaja como intermediario entre estas dos clases.

## Diagrama estático

```mermaid
classDiagram
    class Modelo {
	+search_cocktail(self, presenter : Presenter, tipo : int, nombre_coctel: string)  list
	+search_ingredient(self,nombre_ingrediente: string)  list
	+filter_by_ingredient(self, nombre: string)  list
	+get_image(self, url_imagen: string)  GdkPixbuf
	}
    class Presenter {
	+on_activate(self, app: GtkAplication)
	+on_cocktail_clicked(self, button: GtkButton, app: GtkAplication, win: ApplicationWindow)
	+on_ingredient_clicked(self, button: GtkButton, app: GtkApplication, win: ApplicationWindow)
	+on_menu_principal_clicked(self, button: GtkButton, app: GtkApplication, win: ApplicationWindow)
	+thread_busqueda(self, busqueda: string, response_cola: Queue, win: ApplicationWindow, app: GtkApplication, dialogo_espera: MessageDialog ,tipo : int)
	+on_thread_coctel_responded(self, response: list, win: ApplicationWindow, busqueda: string,app: GtkApplication)
	+on_thread_ingrediente_responded(self, response: list, win: ApplicationWindow, busqueda: string,app: GtkApplication)
	+on_busqueda_changed(self, entry: SearchEntry, manualEntry: String, isManualEntry: boolean, tipo: int, app: GtkApplication, win: ApplicationWIndow)
	}
    class Vista {
	+build_menu_principal(self, button: GtkButton, presenter: Presenter, app: GtkApplication, win: ApplicationWindow)
	+build_dialogo_error(self, presenter: Presenter, texto_fallo: string, win: ApplicationWindow)
	+build_menu_busqueda_coctel(self, button: GtkButton, presenter: Presenter, app: GtkApplication, win: ApplicationWindow)
	+build_menu_busqueda_ingrediente(self, button: GtkButton, presenter: Presenter, app: GtkApplication, win: ApplicationWindow)
	+build_menu_info_coctel(self, entry: SearchEntry, presenter: Presenter, nombre: string, imagen: GtdPixbuf, ingredientes: list, medidas: list, app: GtkApplication, win2: ApplicationWindow)
	+build_menu_info_ingrediente(self, entry: SearchEntry, presenter: Presenter, nombre: string, tipo_ing: string, alcohol_ing: string, cocteles: list, app: GtkApplication, win3: ApplicationWindow)
	+build_dialogo_espera(self,win: ApplicationWindow)
	+hide_dialogo_espera(self, dialogo: MessageDialog)
	}
    Presenter --> Modelo
    Presenter --> Vista


```


## Diagrama dinámico
### Buscar un cóctel

```mermaid
sequenceDiagram
	Main ->>+ Presenter: run
	Presenter ->> Presenter: on_activate
	Presenter ->>- Vista: build_menu_principal
	activate Vista
	Vista ->>+ Presenter: on_coctel_clicked
	deactivate Vista
	Presenter ->>- Vista: build_menu_busqueda_coctel
	activate Vista
	Vista ->>+ Presenter: on_busqueda_changed
	deactivate Vista
	Presenter ->> Presenter: thread_busqueda
	Presenter ->>- Modelo: search_cocktail
	activate Modelo
	Modelo ->>+ Presenter: return resultadoFinal
	deactivate Modelo
	Presenter ->> Presenter: on_thread_coctel_responded
	Presenter ->>- Vista: build_menu_info_coctel
```
### Buscar un ingrediente
```mermaid
sequenceDiagram
	Main ->>+ Presenter: run
	Presenter ->> Presenter: on_activate
	Presenter ->>- Vista: build_menu_principal
	activate Vista
	Vista ->>+ Presenter: on_ingrediente_clicked
	deactivate Vista
	Presenter ->>- Vista: build_menu_busqueda_ingrediente
	activate Vista
	Vista ->>+ Presenter: on_busqueda_changed
	deactivate Vista
	Presenter ->> Presenter: thread_busqueda
	Presenter ->>- Modelo: search_ingredient
	activate Modelo
	Modelo ->> Modelo: filter_by_ingredient
	Modelo ->> Modelo: return resultadoFinal
	Modelo ->>+ Presenter: return listaFinal
	deactivate Modelo
	Presenter ->> Presenter: on_thread_ingrediente_responded
	Presenter ->>- Vista: build_menu_info_ingrediente
```
### Buscar un cóctel (Error - Búsqueda vacia)

```mermaid
sequenceDiagram
	Main ->>+ Presenter: run
	Presenter ->> Presenter: on_activate
	Presenter ->>- Vista: build_menu_principal
	activate Vista
	Vista ->>+ Presenter: on_coctel_clicked
	deactivate Vista
	Presenter ->>- Vista: build_menu_busqueda_coctel
	activate Vista
	Vista ->>+ Presenter: on_busqueda_changed
	deactivate Vista
	Presenter ->>- Vista: build_dialogo_error
```
### Buscar un cóctel (Error - Fallo en la búsqueda / Error - Fallo de conexión)

```mermaid
sequenceDiagram
	Main ->>+ Presenter: run
	Presenter ->> Presenter: on_activate
	Presenter ->>- Vista: build_menu_principal
	activate Vista
	Vista ->>+ Presenter: on_coctel_clicked
	deactivate Vista
	Presenter ->>- Vista: build_menu_busqueda_coctel
	activate Vista
	Vista ->>+ Presenter: on_busqueda_changed
	deactivate Vista
	Presenter ->> Presenter: thread_busqueda
	Presenter ->>- Modelo: search_cocktail
	activate Modelo
	Modelo ->>+ Presenter: return resultadoFinal
	deactivate Modelo
	Presenter ->> Presenter: on_thread_coctel_responded
	Presenter ->>- Vista: build_dialogo_error
```
