[Forma]
Clave=PropreListaSucursal
Nombre=Sucursales
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
ListaCarpetas=PropreListaSucursal
CarpetaPrincipal=PropreListaSucursal
PosicionInicialAlturaCliente=273
PosicionInicialAncho=421
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialIzquierda=429
PosicionInicialArriba=229
ListaAcciones=Cambios<BR>Eliminar<BR>Cerrar
Comentarios=Lista(Info.PropreLista,SQL(<T>SELECT Descripcion FROM PropreLista WHERE Lista = :tLista<T>, Info.PropreLista))
VentanaExclusiva=S
VentanaSinIconosMarco=S
SinTransacciones=S
[PropreListaSucursal]
Estilo=Hoja
Clave=PropreListaSucursal
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=PropreListaSucursal
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=PropreListaSucursal.Sucursal<BR>Sucursal.Nombre
OtroOrden=S
ListaOrden=PropreListaSucursal.Sucursal<TAB>(Acendente)
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
HojaMantenerSeleccion=S
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
HojaIndicador=S
RefrescarAlEntrar=S
FiltroGeneral=PropreListaSucursal.Lista = <T>{info.PropreLista}<T>
[PropreListaSucursal.PropreListaSucursal.Sucursal]
Carpeta=PropreListaSucursal
Clave=PropreListaSucursal.Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[PropreListaSucursal.Sucursal.Nombre]
Carpeta=PropreListaSucursal
Clave=Sucursal.Nombre
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[PropreListaSucursal.Columnas]
Sucursal=64
Nombre=304
0=-2
1=-2
Lista=124
[Acciones.Cambios]
Nombre=Cambios
Boton=3
NombreDesplegar=Guardar y Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
Activo=S
Visible=S
NombreEnBoton=S
GuardarAntes=S
ConCondicion=S
EjecucionConError=S
ClaveAccion=Cerrar
EjecucionCondicion=Asigna(Temp.Texto, ListaBuscarDuplicados(CampoEnLista(PropreListaSucursal:PropreListaSucursal.Sucursal)))<BR>Vacio(Temp.Texto)
EjecucionMensaje=<T>SUCURSAL: <T>+ Comillas(Temp.Texto)+<T> DUplicada<T>
[Acciones.Eliminar]
Nombre=Eliminar
Boton=5
NombreEnBoton=S
NombreDesplegar=Eliminar
EnBarraHerramientas=S
EspacioPrevio=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=63
NombreEnBoton=S
NombreDesplegar=Cerrar sin Guardar
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S
ConfirmarAntes=S
DialogoMensaje=EstaSeguroPrecaucion
Multiple=S
ListaAccionesMultiples=Cancelar<BR>Cerrar
[Acciones.Cerrar.Cancelar]
Nombre=Cancelar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S
[Acciones.Cerrar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

