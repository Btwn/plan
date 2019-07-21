
[Forma]
Clave=RM1187UENFrm
Icono=44
Modulos=(Todos)
Nombre=Listado UEN

ListaCarpetas=RM1187ListadoUENFrm
CarpetaPrincipal=RM1187ListadoUENFrm
PosicionInicialAlturaCliente=161
PosicionInicialAncho=220
VentanaSiempreAlFrente=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=530
PosicionInicialArriba=412
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar

[RM1187ListadoUEN.Columnas]
0=-2
1=162


[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=126
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S
BtnResaltado=S

ListaAccionesMultiples=Asigna<BR>Registrar<BR>Seleccion
[Acciones.SeleccionarTodo]
Nombre=SeleccionarTodo
Boton=0
NombreDesplegar=&Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.QuitarTodo]
Nombre=QuitarTodo
Boton=0
NombreDesplegar=&Quitar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

[Acciones.Seleccionar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Seleccionar.Registrar]
Nombre=Registrar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=RegistrarSeleccion(<T>RM1187UEN<T>)
[Acciones.Seleccionar.Seleccion]
Nombre=Seleccion
Boton=0
TipoAccion=Ventana
Activo=S
Visible=S

ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(Mavi.RM1187UEN,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)

[RM1187ListadoUENFrm]
Estilo=Iconos
PestanaOtroNombre=S
PestanaNombre=Listado UEN
Clave=RM1187ListadoUENFrm
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1187UENVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosConRejilla=S
IconosSeleccionMultiple=S
ElementosPorPaginaEsp=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Nombre
ListaAcciones=SeleccionarTodo<BR>QuitarTodo
CarpetaVisible=S

IconosNombre=RM1187UENVis:UEN
IconosSubTitulo=UEN
[RM1187ListadoUENFrm.Nombre]
Carpeta=RM1187ListadoUENFrm
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco

[RM1187ListadoUENFrm.Columnas]
0=-2
1=-2

