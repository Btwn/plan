
[Forma]
Clave=RM1179AlmacenFrm
Icono=558
Modulos=(Todos)

ListaCarpetas=Vista
CarpetaPrincipal=Vista
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=381
PosicionInicialArriba=236
PosicionInicialAlturaCliente=513
PosicionInicialAncho=518
Nombre=RM1179AlmacenVis:AlmacenPrincipal
BarraHerramientas=S
ListaAcciones=seleccion
AccionesTamanoBoton=15x5
AccionesDerecha=S
[Vista]
Estilo=Iconos
Clave=Vista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1179AlmacenVis
Fuente={Tahoma, 8, Negro, []}
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
BusquedaRespetarFiltros=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaRespetarUsuario=S
BusquedaEnLinea=S
FiltroIgnorarEmpresas=S
ListaEnCaptura=NombreAlm
MenuLocal=S
ListaAcciones=Seleccionar Todo<BR>Quitar Seleccion
IconosCampo=(Situación)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSeleccionMultiple=S
ElementosPorPaginaEsp=200
IconosNombre=RM1179AlmacenVis:Almacen
[Vista.Columnas]
AlmacenPrincipal=83
Nombre=315
0=88
1=246



2=-2

[Acciones.seleccion.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


[Acciones.seleccion.regis]
Nombre=regis
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=RegistrarSeleccion(<T>Vista<T>)
[Acciones.seleccion]
Nombre=seleccion
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Controles Captura
ListaAccionesMultiples=asigna<BR>regis<BR>selec
Activo=S
Visible=S





[Acciones.seleccion.selec]
Nombre=selec
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S










Expresion=Asigna(Mavi.RM1179Almacen,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Vista.NombreAlm]
Carpeta=Vista
Clave=NombreAlm
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco

[Acciones.Seleccionar Todo]
Nombre=Seleccionar Todo
Boton=0
NombreDesplegar=&Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

Antes=S
AntesExpresiones=Asigna(Info.Numero,1)
[Acciones.Quitar Seleccion]
Nombre=Quitar Seleccion
Boton=0
NombreDesplegar=&Quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
Antes=S
AntesExpresiones=Asigna(Info.Numero,0)

