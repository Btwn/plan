
[Forma]
Clave=RM1179FamiliaFrm
Icono=0
CarpetaPrincipal=Familia
Modulos=(Todos)
Nombre=Familias de articulos

ListaCarpetas=Familia
AccionesTamanoBoton=15x5
AccionesDerecha=S
BarraHerramientas=S
ListaAcciones=seleccion
PosicionInicialIzquierda=470
PosicionInicialArriba=79
PosicionInicialAlturaCliente=614
PosicionInicialAncho=311
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
[Familia]
Estilo=Iconos
Clave=Familia
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1179FamiliaVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(Situación)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosSeleccionMultiple=S
ElementosPorPaginaEsp=200
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
BusquedaAncho=20
BusquedaEnLinea=S
FiltroIgnorarEmpresas=S
MenuLocal=S
ListaAcciones=Seleccionar Todo<BR>Quitar Todo
IconosConSenales=S
IconosSubTitulo=Familias
IconosNombre=RM1179FamiliaVis:Familia

[Acciones.seleccion]
Nombre=seleccion
Boton=23
NombreDesplegar=&Seleccionar
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

NombreEnBoton=S
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=asigna<BR>regis<BR>selec
EspacioPrevio=S
[Acciones.seleccion.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Familia.Columnas]
0=-2

1=-2
[Acciones.seleccion.selec]
Nombre=selec
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S

Expresion=Asigna(Mavi.RM1179Familia,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Acciones.seleccion.regis]
Nombre=regis
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=RegistrarSeleccion(<T>Familia<T>)
[Acciones.Seleccionar Todo]
Nombre=Seleccionar Todo
Boton=0
NombreDesplegar=&Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.Quitar Todo]
Nombre=Quitar Todo
Boton=0
NombreDesplegar=&Quitar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

