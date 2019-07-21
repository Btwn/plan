[Forma]
Clave=RM0239AlmListaFrm
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
PosicionInicialAlturaCliente=431

EsConsultaExclusiva=S
[Lista]
Estilo=Iconos
PestanaNombre=Almacen(es)
Clave=Lista
Filtros=S
AlineacionAutomatica=S
AcomodarTexto=S
Zona=A1
Vista=RM0239AlmVis
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
ListaAcciones=Actualizar<BR>SeleccionarTodo<BR>QuitarTodo
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
FiltroListaEstatus=(Todos)<BR>ALTA<BR>BLOQUEADO<BR>BAJA
FiltroEstatusDefault=ALTA

IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSeleccionMultiple=S
ElementosPorPaginaEsp=200
[Lista.Columnas]
0=122
1=171
2=172
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

[Lista.Alm.Grupo]
Carpeta=Lista
Clave=Alm.Grupo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

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

Multiple=S
ListaAccionesMultiples=Registrar<BR>Asignar
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

[Acciones.SeleccionarTodo]
Nombre=SeleccionarTodo
Boton=0
NombreDesplegar=Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.QuitarTodo]
Nombre=QuitarTodo
Boton=0
NombreDesplegar=Quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

[Acciones.Seleccionar.Registrar]
Nombre=Registrar
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion
Activo=S
Visible=S

[Acciones.Seleccionar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(Mavi.RM0239TodosAlmacenes,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
Activo=S
Visible=S

