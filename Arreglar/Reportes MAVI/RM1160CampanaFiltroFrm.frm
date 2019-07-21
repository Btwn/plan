
[Forma]
Clave=RM1160CampanaFiltroFrm
Icono=0
Modulos=(Todos)
Nombre=Campaña

ListaCarpetas=Campana
CarpetaPrincipal=Campana
PosicionInicialAlturaCliente=398
PosicionInicialAncho=500
AccionesTamanoBoton=15x5
AccionesDerecha=S
EsConsultaExclusiva=S
BarraHerramientas=S
ListaAcciones=Seleccionar<BR>Cerrar
[Campana]
Estilo=Hoja
Clave=Campana
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1160CampanaFiltroVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S


BusquedaRapidaControles=S
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
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
ListaEnCaptura=id<BR>Titulo
[Campana.Columnas]
0=-2



Titulo=94
id=64
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
Activo=S
Visible=S

TipoAccion=Ventana
ClaveAccion=Seleccionar
Multiple=S
ListaAccionesMultiples=Seleccion<BR>GuardarId
[Acciones.Seleccionar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Seleccionar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=RegistrarSeleccion(<T>Titulo<T>)
[Acciones.Seleccionar.Selecciona]
Nombre=Selecciona
Boton=0
TipoAccion=Ventana
Activo=S
Visible=S
ClaveAccion=Seleccionar/Resultado
Expresion=SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)

[Campana.Titulo]
Carpeta=Campana
Clave=Titulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Campana.id]
Carpeta=Campana
Clave=id
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco


[Acciones.Seleccionar.Seleccion]
Nombre=Seleccion
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S

[Acciones.Seleccionar.GuardarId]
Nombre=GuardarId
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.dialogo,RM1160CampanaFiltroVis:id )
