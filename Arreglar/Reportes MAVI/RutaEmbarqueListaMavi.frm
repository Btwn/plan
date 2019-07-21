[Forma]
Clave=RutaEmbarqueListaMavi
Nombre=Rutas Embarque
Icono=0
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
PosicionInicialIzquierda=216
PosicionInicialArriba=157
PosicionInicialAltura=350
PosicionInicialAncho=848
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
PosicionInicialAlturaCliente=459
VentanaExclusiva=S
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
EsConsultaExclusiva=S
ExpresionesAlCerrar=Asigna(Info.Ruta, Nulo)

[Lista]
Estilo=Hoja
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=Ruta
Fuente={MS Sans Serif, 8, Negro, []}
CampoColorLetras=Negro
CampoFondoColor=Blanco
ListaEnCaptura=Ruta.Ruta<BR>Ruta.Zona<BR>Ruta.TiempoEntrega<BR>Ruta.TiempoEntregaUnidad<BR>Ruta.Kms<BR>Ruta.Costo
CarpetaVisible=S
CampoColorFondo=Blanco
OtroOrden=S
ListaOrden=Ruta.Zona<TAB>(Acendente)<BR>Ruta.Ruta<TAB>(Acendente)
PermiteLocalizar=S
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
MenuLocal=S
ListaAcciones=Todo<BR>Quitar
BusquedaRapidaControles=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaInicializar=S
BusquedaAncho=20
BusquedaEnLinea=S



[Lista.Columnas]
Ruta=210
OrdenEmbarque=86
Zona=177
TiempoEntrega=79
TiempoEntregaUnidad=64
Kms=54
Costo=106
0=137
1=133
2=123
3=107
4=87
5=89

[Lista.Ruta.Zona]
Carpeta=Lista
Clave=Ruta.Zona
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro


[Lista.Ruta.TiempoEntrega]
Carpeta=Lista
Clave=Ruta.TiempoEntrega
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Ruta.TiempoEntregaUnidad]
Carpeta=Lista
Clave=Ruta.TiempoEntregaUnidad
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro


[Lista.Ruta.Kms]
Carpeta=Lista
Clave=Ruta.Kms
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Ruta.Costo]
Carpeta=Lista
Clave=Ruta.Costo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
EnBarraHerramientas=S
Activo=S
Visible=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
NombreEnBoton=S
NombreDesplegar=&Seleccionar
[Lista.Ruta.Ruta]
Carpeta=Lista
Clave=Ruta.Ruta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Todo]
Nombre=Todo
Boton=0
NombreDesplegar=Seleccionar &Todo
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
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

