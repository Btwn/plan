
[Forma]
Clave=RM0254PoblacionesFrm
Icono=0
Modulos=(Todos)

ListaCarpetas=poblaciones
CarpetaPrincipal=poblaciones
PosicionInicialAlturaCliente=273
PosicionInicialAncho=500
PosicionInicialIzquierda=218
PosicionInicialArriba=113
Nombre=RM0254 Poblaciones
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=seleccion
BarraHerramientas=S
[poblaciones]
Estilo=Iconos
Clave=poblaciones
BusquedaRapidaControles=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0254PoblacionesVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSeleccionMultiple=S
ElementosPorPaginaEsp=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Poblacion
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
ListaAcciones=Todo<BR>Quitar
[poblaciones.Poblacion]
Carpeta=poblaciones
Clave=Poblacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco

[poblaciones.Columnas]
0=-2

[Acciones.seleccion]
Nombre=seleccion
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraAcciones=S
Activo=S
Visible=S

ListaAccionesMultiples=asign<BR>regist<BR>sel
EnBarraHerramientas=S
[Acciones.seleccion.asign]
Nombre=asign
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.seleccion.regist]
Nombre=regist
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>poblaciones<T>)

[Acciones.seleccion.sel]
Nombre=sel
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Asigna(Mavi.RM0254Poblaciones,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
EjecucionCondicion=Vacio(Mavi.RM0254Sucursales)
EjecucionMensaje=<T>No se puede seleccionar poblaciones, al seleccionar sucursales<T>

[Acciones.Todo]
Nombre=Todo
Boton=0
NombreDesplegar=&Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.Quitar]
Nombre=Quitar
Boton=0
NombreDesplegar=&Quitar Seleccion
EnMenu=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
