
[Forma]
Clave=RM1107UENfrm
Icono=0
Modulos=(Todos)
Nombre=RM1107UENfrm

ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialAlturaCliente=172
PosicionInicialAncho=202
PosicionSec1=104
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccion
[Lista]
Estilo=Iconos
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1107UENVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=Nombre


MenuLocal=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=RM1107UENVis:UEN
ElementosPorPagina=200
ListaAcciones=(Lista)

IconosSeleccionMultiple=S
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
IconosNombre=RM1107UENVis:UEN
[Lista.Columnas]
UEN=64
Nombre=604


0=20
1=-2
[Lista.Nombre]
Carpeta=Lista
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro



[Lista.ListaEnCaptura]
(Inicio)=UEN
UEN=Nombre
Nombre=(Fin)

[Acciones.Seleccionartodo]
Nombre=Seleccionartodo
Boton=0
NombreDesplegar=Seleccionar &todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.QuitarSeleccion]
Nombre=QuitarSeleccion
Boton=0
NombreDesplegar=Quitar selección
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S


[Acciones.Seleccion.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Seleccion.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Lista<T>)
Activo=S
Visible=S

[Acciones.Seleccion.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(Mavi.RM1107UEN,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
Activo=S
Visible=S

[Acciones.Seleccion]
Nombre=Seleccion
Boton=35
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
BtnResaltado=S
ListaAccionesMultiples=(Lista)

Activo=S
Visible=S
[Acciones.Seleccion.ListaAccionesMultiples]
(Inicio)=Asignar
Asignar=Expresion
Expresion=Seleccionar
Seleccionar=(Fin)









[Lista.ListaAcciones]
(Inicio)=Seleccionartodo
Seleccionartodo=QuitarSeleccion
QuitarSeleccion=(Fin)
