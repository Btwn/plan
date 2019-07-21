
[Forma]
Clave=RM1185COMSInvTablaInvMinimoRequeridoPorLineaFrm
Icono=744
Modulos=(Todos)

CarpetaPrincipal=Principal


PosicionInicialAlturaCliente=511
PosicionInicialAncho=694
PosicionCol1=347

ListaCarpetas=Principal<BR>Seleccionar
PosicionInicialIzquierda=203
PosicionInicialArriba=251
Nombre=Tabla De Inventario Minimo Requerido Por Linea
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Eliminar
BarraHerramientas=S
[Seleccionar.Linea]
Carpeta=Seleccionar
Clave=Linea
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Campana.Columnas]
0=-2

[Seleccionar.Columnas]
0=290

[Seleccionar]
Estilo=Iconos
Clave=Seleccionar
BusquedaRapidaControles=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A2
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSeleccionMultiple=S
ElementosPorPaginaEsp=200
CampoColorLetras=Negro
CampoColorFondo=Negro
CarpetaVisible=S
Vista=RM1185COMSSeleccionarLineaVis
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaEnLinea=S

Pestana=S
PestanaOtroNombre=S
PestanaNombre=Lineas Seleccionada(s)
IconosNombre=RM1185COMSSeleccionarLineaVis:Linea
BusquedaRespetarFiltros=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaRespetarUsuario=S
BusquedaRespetarControlesNum=S
[Principal]
Estilo=Hoja
Pestana=S
Clave=Principal
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1185COMSTablaInvMinimoRequeridoPorLineaVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=RM1185COMSTablaInvMinimoRequeridoPorLineaTbl.LineaValida
CarpetaVisible=S

PestanaOtroNombre=S
PestanaNombre=Lineas De Articulos Almacenados
BusquedaRapidaControles=S
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
BusquedaRespetarUsuario=S
BusquedaAncho=20
BusquedaEnLinea=S
BusquedaRespetarControlesNum=S
[Principal.RM1185COMSTablaInvMinimoRequeridoPorLineaTbl.LineaValida]
Carpeta=Principal
Clave=RM1185COMSTablaInvMinimoRequeridoPorLineaTbl.LineaValida
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Principal.Columnas]
LineaValida=304

[Acciones.Guardar]
Nombre=Guardar
Boton=23
NombreEnBoton=S
NombreDesplegar=Guardar
EnBarraAcciones=S
Activo=S
Visible=S
EnBarraHerramientas=S

TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Seleccionar<T>)<BR>EjecutarSQL(<T>EXEC SpCOMSRM1185AnalisisDeInventario :nOpcion, t:Variable, :nEstacion<T>,6,,EstacionTrabajo)<BR>ActualizarForma
[Acciones.Eliminar]
Nombre=Eliminar
Boton=36
NombreEnBoton=S
NombreDesplegar=Eliminar
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S

TipoAccion=Expresion
Multiple=S
ListaAccionesMultiples=Seleccionar<BR>Expresion
[Acciones.Guardar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S





[Acciones.Eliminar.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S

[Acciones.Eliminar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Nombre,RM1185COMSTablaInvMinimoRequeridoPorLineaVis:RM1185COMSTablaInvMinimoRequeridoPorLineaTbl.LineaValida)<BR>EjecutarSQL(<T>EXEC SpCOMSRM1185AnalisisDeInventario :nOpcion, <T>+Comillas(Info.Nombre)+<T>, :nEstacion<T>,<BR>             7,<BR>             EstacionTrabajo)<BR>ActualizarForma
