[Forma]
Clave=RM1062ClientesFrm
Nombre=Clientes
Icono=0
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=RM1062clientesVis
CarpetaPrincipal=RM1062clientesVis
ListaAcciones=Selecionar
PosicionInicialIzquierda=226
PosicionInicialArriba=88
PosicionInicialAlturaCliente=273
PosicionInicialAncho=500
BarraHerramientas=S
[Acciones.Selecionar]
Nombre=Selecionar
Boton=23
NombreDesplegar=&Seleccionar
EnBarraAcciones=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asigna<BR>Regis<BR>sele
NombreEnBoton=S
EnBarraHerramientas=S
[Acciones.SelTodo]
Nombre=SelTodo
Boton=0
NombreDesplegar=&Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.QuitSel]
Nombre=QuitSel
Boton=0
NombreDesplegar=&Quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[Acciones.Selecionar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Selecionar.Regis]
Nombre=Regis
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>RM1062clientesVis<T>)
[Acciones.Selecionar.sele]
Nombre=sele
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(Mavi.RM1062ClientesFiltro,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
Activo=S
Visible=S
[Vista.Columnas]
0=-2
1=-2
[RM1062clientesVis]
Estilo=Iconos
PestanaOtroNombre=S
Clave=RM1062clientesVis
BusquedaRapidaControles=S
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1062clientesVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=CLIENTE
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
ListaAcciones=SelTodo<BR>QuitSel
CarpetaVisible=S
[RM1062clientesVis.CLIENTE]
Carpeta=RM1062clientesVis
Clave=CLIENTE
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[RM1062clientesVis.Columnas]
0=-2
