
[Forma]
Clave=RM1183FamiliaFrm
Icono=0
Modulos=(Todos)
Nombre=RM1183 Familia

ListaCarpetas=vista
CarpetaPrincipal=vista
PosicionInicialAlturaCliente=426
PosicionInicialAncho=320
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=selecc
PosicionInicialIzquierda=506
PosicionInicialArriba=131
[vista]
Estilo=Iconos
Clave=vista
BusquedaRapidaControles=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1183FamiliaVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Familia
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
CarpetaVisible=S

MenuLocal=S
ListaAcciones=selec<BR>quitar
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPaginaEsp=200
IconosSeleccionMultiple=S
[vista.Familia]
Carpeta=vista
Clave=Familia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[vista.Columnas]
0=-2

Familia=304
[Acciones.selec]
Nombre=selec
Boton=0
NombreDesplegar=&Seleccionar Todo
EnMenu=S
Activo=S
Visible=S

TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
[Acciones.selecc.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.selecc.regist]
Nombre=regist
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=RegistrarSeleccion(<T>Vista<T>)
[Acciones.selecc]
Nombre=selecc
Boton=23
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=asigna<BR>regist<BR>acepta
Activo=S
Visible=S

NombreEnBoton=S
[Acciones.selecc.acepta]
Nombre=acepta
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(Mavi.RM1183Fam,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)

[Acciones.quitar]
Nombre=quitar
Boton=0
NombreDesplegar=&Quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
