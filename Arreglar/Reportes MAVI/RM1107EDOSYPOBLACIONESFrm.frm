
[Forma]
Clave=RM1107EDOSYPOBLACIONESFrm
Icono=0
Modulos=(Todos)
Nombre=RM1107 Estados y Poblaciones Frm

ListaCarpetas=Poblaciones
CarpetaPrincipal=Poblaciones
PosicionInicialAlturaCliente=638
PosicionInicialAncho=239
PosicionInicialIzquierda=153
PosicionInicialArriba=95
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionSec1=0
ListaAcciones=Seleccionar

[Estados.Mavi.RM1107ESTADOS]
Carpeta=Estados
Clave=Mavi.RM1107ESTADOS
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro



[Lista.Columnas]
0=-2
1=-2

[Estados.ListaEnCaptura]
(Inicio)=Mavi.RM1107ESTADOS
Mavi.RM1107ESTADOS=Mavi.RM1107POBLACIONES
Mavi.RM1107POBLACIONES=Mavi.RM1107UEN
Mavi.RM1107UEN=(Fin)

[Poblaciones]
Estilo=Iconos
Clave=Poblaciones
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1107EDOSYPOBLACIONESVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
















ListaEnCaptura=Poblacion
MenuLocal=S
ListaAcciones=(Lista)
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S

IconosNombre=Poblacion
[Poblaciones.Columnas]
Estado=184
Poblacion=184


0=19
1=131

2=112
3=-2
[Acciones.Buscar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S




[Acciones.Buscar.Refrescar]
Nombre=Refrescar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S








[Acciones.Seleccionar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Seleccionar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=RegistrarSeleccion(<T>Poblaciones<T>)
[Acciones.Seleccionar.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S

Expresion=Asigna(Mavi.RM1107POBLACIONES,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=35
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=(Lista)

Activo=S
Visible=S
NombreEnBoton=S
BtnResaltado=S























EspacioPrevio=S
[Acciones.SeleccionarTodo]
Nombre=SeleccionarTodo
Boton=0
NombreDesplegar=&Seleccionar todo
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
TipoAccion=controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S










[Poblaciones.Poblacion]
Carpeta=Poblaciones
Clave=Poblacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro













































[Poblaciones.ListaEnCaptura]
(Inicio)=Poblacion
Poblacion=Estado
Estado=(Fin)



[Acciones.Buscar.ListaAccionesMultiples]
(Inicio)=Asignar
Asignar=Refrescar
Refrescar=(Fin)








[FiltroEdos.Mavi.RM1107ESTADOS]
Carpeta=FiltroEdos
Clave=Mavi.RM1107ESTADOS
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro













[Forma.ListaCarpetas]
(Inicio)=FiltroEdos
FiltroEdos=Poblaciones
Poblaciones=(Fin)



[Forma.ListaAcciones]
(Inicio)=Buscar
Buscar=Seleccionar
Seleccionar=(Fin)





[Poblaciones.ListaAcciones]
(Inicio)=SeleccionarTodo
SeleccionarTodo=QuitarSeleccion
QuitarSeleccion=(Fin)

[Acciones.Seleccionar.ListaAccionesMultiples]
(Inicio)=Asignar
Asignar=Expresion
Expresion=Seleccionar
Seleccionar=(Fin)
