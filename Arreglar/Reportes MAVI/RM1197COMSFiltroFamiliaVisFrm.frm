
[Forma]
Clave=RM1197COMSFiltroFamiliaVisFrm
Icono=411
Modulos=(Todos)

ListaCarpetas=Principal
CarpetaPrincipal=Principal
PosicionInicialAlturaCliente=410
PosicionInicialAncho=409
Nombre=<T>Filtro De Familias<T>
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
VentanaSiempreAlFrente=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=435
PosicionInicialArriba=287
[Principal]
Estilo=Iconos
Clave=Principal
BusquedaRapidaControles=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1197COMSFiltroFamiliaVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaRespetarFiltros=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaAncho=20
BusquedaEnLinea=S
BusquedaRespetarControlesNum=S
CarpetaVisible=S


MenuLocal=S
ListaAcciones=SeleccionarTodo<BR>QuitarTodo
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPaginaEsp=0
IconosNombre=RM1197COMSFiltroFamiliaVis:Familia
IconosSeleccionMultiple=S
[Principal.Columnas]
0=367
1=-2



[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=Seleccionar
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=RegistrarSeleccion<BR>Expresion


[Acciones.Seleccionar.RegistrarSeleccion]
Nombre=RegistrarSeleccion
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion
Activo=S
Visible=S

[Acciones.Seleccionar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S

Expresion=Asigna(Mavi.RM1197Familia,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Acciones.SeleccionarTodo]
Nombre=SeleccionarTodo
Boton=0
NombreDesplegar=Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.QuitarTodo]
Nombre=QuitarTodo
Boton=0
NombreDesplegar=Deseleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S



