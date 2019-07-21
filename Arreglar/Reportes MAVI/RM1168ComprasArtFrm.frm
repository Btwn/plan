
[Forma]
Clave=RM1168ComprasArtFrm
Icono=0
Modulos=(Todos)
Nombre=RM1168ComprasArtFrm

ListaCarpetas=principal
CarpetaPrincipal=principal
PosicionInicialAlturaCliente=329
PosicionInicialAncho=409
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
MovModulo=(Todos)
PosicionInicialIzquierda=462
PosicionInicialArriba=157
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
VentanaBloquearAjuste=S
[principal]
Estilo=Hoja
Clave=principal
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1168ComprasArtVis
Fuente={Tahoma, 8, Negro, []}
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
BusquedaRespetarFiltros=S
BusquedaRespetarUsuario=S
FiltroIgnorarEmpresas=S
PermiteLocalizar=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
BusquedaRespetarControlesNum=S
ListaEnCaptura=Articulo<BR>Descripcion1
HojaAjustarColumnas=S
HojaIndicador=S
[principal.Columnas]
Articulo=124


0=-2
Descripcion1=604
[Acciones.Seleccionar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Seleccionar.Exp]
Nombre=Exp
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Art<T>)
Activo=S
Visible=S

[Acciones.Seleccionar.Ult]
Nombre=Ult
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(Mavi.RM1168Articulo,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
Activo=S
Visible=S

[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=Seleccionar
Multiple=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
ListaAccionesMultiples=Asigna<BR>Exp<BR>Ult
Activo=S
Visible=S







[principal.Articulo]
Carpeta=principal
Clave=Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[principal.Descripcion1]
Carpeta=principal
Clave=Descripcion1
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco

