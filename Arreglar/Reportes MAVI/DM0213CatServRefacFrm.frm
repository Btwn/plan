[Forma]
Clave=DM0213CatServRefacFrm
Nombre=DM0213 Catalogo Servicio Refacciones
Icono=0
Modulos=(Todos)
ListaCarpetas=DM0213CatServRefacFrm
CarpetaPrincipal=DM0213CatServRefacFrm
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Eliminar
PosicionInicialIzquierda=86
PosicionInicialArriba=451
PosicionInicialAlturaCliente=328
PosicionInicialAncho=1099
BarraHerramientas=S
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreDesplegar=&Guardar / Cerrar
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
NombreEnBoton=S
EnBarraHerramientas=S
Multiple=S
ListaAccionesMultiples=Guardar<BR>Cerrar
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=//((USUARIO.ACCESO)=<T>GEROP_GERA<T>) o ((USUARIO.ACCESO)=<T>GERAD_GERA<T>) o ((USUARIO.ACCESO)=<T>VEHIC_GERA<T>)
EjecucionMensaje=//<T>Usted NO tiene permisos para realizar esta Accion ...!<T>
[DM0213CatalogoVehiculoFrm.Columnas]
0=19
1=37
2=-2
TipoUnidadVehicular=604
[Acciones.Guardar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Guardar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Eliminar]
Nombre=Eliminar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Eliminar
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S
[DM0213CatServRefacFrm]
Estilo=Hoja
Clave=DM0213CatServRefacFrm
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0213CatServRefacVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DM0213CatServRefacTbl.ServicioRefaccion<BR>DM0213CatServRefacTbl.Descripcion
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
[DM0213CatServRefacFrm.DM0213CatServRefacTbl.ServicioRefaccion]
Carpeta=DM0213CatServRefacFrm
Clave=DM0213CatServRefacTbl.ServicioRefaccion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=200
ColorFondo=Blanco
ColorFuente=Negro
[DM0213CatServRefacFrm.Columnas]
ServicioRefaccion=475
Descripcion=604
[DM0213CatServRefacFrm.DM0213CatServRefacTbl.Descripcion]
Carpeta=DM0213CatServRefacFrm
Clave=DM0213CatServRefacTbl.Descripcion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=200
ColorFondo=Blanco
ColorFuente=Negro
