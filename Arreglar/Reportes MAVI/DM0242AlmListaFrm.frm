[Forma]
Clave=DM0242AlmListaFrm
Nombre=Almacenes
Icono=44
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialIzquierda=258
PosicionInicialArriba=277
PosicionInicialAltura=360
PosicionInicialAncho=763
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar<BR>Personalizar
VentanaEscCerrar=S
VentanaExclusiva=S
EsConsultaExclusiva=S
PosicionInicialAlturaCliente=431

[Lista]
Estilo=Hoja
PestanaNombre=Almacen(es)
Clave=Lista
Filtros=S
AlineacionAutomatica=S
AcomodarTexto=S
Zona=A1
Vista=DM0242AlmVis
Fuente={MS Sans Serif, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
FiltroPredefinido=S
FiltroAplicaEn=Alm.Grupo
FiltroAutoCampo=Alm.Grupo
FiltroAutoValidar=Alm.Grupo
FiltroTipo=Arbol
FiltroTodo=S
FiltroEnOrden=S
FiltroTodoNombre=Almacenes
FiltroNullNombre=(sin clasificar)
FiltroRespetar=S
FiltroAncho=20
CarpetaVisible=S
ListaEnCaptura=Alm.Almacen<BR>Alm.Nombre<BR>Alm.Grupo<BR>Alm.Sucursal
FiltroGrupo1=(Validaciones Memoria)
FiltroValida1=AlmGrupo
FiltroAplicaEn1=Alm.Grupo
MenuLocal=S
ListaAcciones=Actualizar
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
FiltroArbolClave=Alm.Almacen
FiltroArbolValidar=Alm.Nombre
FiltroArbolRama=Alm.Rama
FiltroArbolAcumulativas=Alm.Tipo
FiltroArbolTipoEstructura=S
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
OtroOrden=S
ListaOrden=Alm.Almacen<TAB>(Acendente)
FiltroListaEstatus=(Todos)<BR>ALTA<BR>BLOQUEADO<BR>BAJA
FiltroEstatusDefault=ALTA
HojaAjustarColumnas=S

[Lista.Columnas]
0=87
1=171
2=77
3=53
Nombre=229
Grupo=100
Sucursal=46
Almacen=90

[Lista.Alm.Nombre]
Carpeta=Lista
Clave=Alm.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Alm.Grupo]
Carpeta=Lista
Clave=Alm.Grupo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S

[Acciones.Actualizar]
Nombre=Actualizar
Boton=0
NombreDesplegar=Actualizar
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=F5

[Lista.Alm.Sucursal]
Carpeta=Lista
Clave=Alm.Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.Personalizar]
Nombre=Personalizar
Boton=45
NombreDesplegar=Personalizar Vista
EnBarraHerramientas=S
EspacioPrevio=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Mostrar Campos
Activo=S
Visible=S

[Lista.Alm.Almacen]
Carpeta=Lista
Clave=Alm.Almacen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro

