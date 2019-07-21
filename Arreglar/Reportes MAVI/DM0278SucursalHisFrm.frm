[Forma]
Clave=DM0278SucursalHisFrm
Nombre=DM0278SucursalHisFrm
Icono=747
Modulos=(Todos)
ListaCarpetas=Sucursal
CarpetaPrincipal=Sucursal
PosicionInicialAlturaCliente=384
PosicionInicialAncho=292
PosicionInicialIzquierda=494
PosicionInicialArriba=313
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
[Sucursal]
Estilo=Iconos
Clave=Sucursal
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0278SucursalHisVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Sucursal<T>
ElementosPorPagina=200
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
BusquedaRapidaControles=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaAncho=20
BusquedaEnLinea=S
MenuLocal=S
ListaAcciones=selectAll<BR>QuitarSelecion

IconosNombre=DM0278SucursalHisVis:Sucursal
ListaEnCaptura=Nombre
[Sucursal.Columnas]
0=69
1=209
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
ListaAccionesMultiples=Asignar<BR>regis<BR>select
[Acciones.Seleccionar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccionar.regis]
Nombre=regis
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Sucursal<T>)
Activo=S
Visible=S
[Acciones.Seleccionar.select]
Nombre=select
Boton=0
TipoAccion=ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,2<T>)
[Acciones.selectAll]
Nombre=selectAll
Boton=0
NombreDesplegar=Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.QuitarSelecion]
Nombre=QuitarSelecion
Boton=0
NombreDesplegar=Quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S



[Sucursal.Nombre]
Carpeta=Sucursal
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco

