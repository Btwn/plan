[Forma]
Clave=RM0238AMovidFrm
Nombre=Movimientos de Salida Traspaso
Icono=401
Modulos=(Todos)
ListaCarpetas=IDMovs
CarpetaPrincipal=IDMovs
PosicionInicialAlturaCliente=566
PosicionInicialAncho=462
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
EsConsultaExclusiva=S
PosicionInicialIzquierda=333
PosicionInicialArriba=145
BarraHerramientas=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Dise�o
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
[rama.Columnas]
0=-2
[Acciones.Seleccionar.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccionar.Registra]
Nombre=Registra
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>IDMovs<T>)
[Acciones.Seleccionar.selecciona]
Nombre=selecciona
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,2<T>)
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreDesplegar=&Seleccionar
Activo=S
Visible=S
NombreEnBoton=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
EnBarraHerramientas=S
[IDMovs]
Estilo=Hoja
Clave=IDMovs
PermiteLocalizar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0238AMovIDvis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mov<BR>MovID<BR>FechaEmision<BR>Estatus
CarpetaVisible=S
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Autom�tica
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
HojaIndicador=S
FiltroFechas=S
FiltroFechasCampo=FechaEmision
FiltroFechasDefault=Este Mes
[IDMovs.MovID]
Carpeta=IDMovs
Clave=MovID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[IDMovs.Columnas]
MovID=98
Mov=117
FechaEmision=98
Estatus=103
[IDMovs.Mov]
Carpeta=IDMovs
Clave=Mov
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[IDMovs.FechaEmision]
Carpeta=IDMovs
Clave=FechaEmision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[IDMovs.Estatus]
Carpeta=IDMovs
Clave=Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro

