
[Forma]
Clave=DM0134MaviVentaEmbEnLoteFrm
Icono=0
Modulos=(Todos)
Nombre=Ventas - Embarque En Lote

ListaCarpetas=VentaEmbEnLotex
CarpetaPrincipal=VentaEmbEnLotex
PosicionInicialAlturaCliente=549
PosicionInicialAncho=755
PosicionInicialIzquierda=264
PosicionInicialArriba=224
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
EsMovimiento=S
TituloAuto=S
MovEspecificos=Todos
MovModulo=VTAS
ListaAcciones=Seleccionar Todo<BR>Quitar Seleccion<BR>Cerra
[Lista.Columnas]
0=172
1=120
2=95

3=93
4=94
5=97



[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.SeleccionarTodo]
Nombre=SeleccionarTodo
Boton=55
NombreDesplegar=Seleccionar &Todo
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S







[Lista.v.ID]
Carpeta=Lista
Clave=v.ID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Lista.v.Empresa]
Carpeta=Lista
Clave=v.Empresa
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=5
ColorFondo=Blanco

[Lista.v.Mov]
Carpeta=Lista
Clave=v.Mov
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Lista.v.MovID]
Carpeta=Lista
Clave=v.MovID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Lista.v.FechaEmision]
Carpeta=Lista
Clave=v.FechaEmision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco



[Lista.ListaEnCaptura]
(Inicio)=v.ID
v.ID=v.Empresa
v.Empresa=v.Mov
v.Mov=v.MovID
v.MovID=v.FechaEmision
v.FechaEmision=(Fin)

[Lista.FiltroListaEstatus]
(Inicio)=CONCLUIDO
CONCLUIDO=CANCELADO
CANCELADO=(Fin)

[Forma.ListaAcciones]
(Inicio)=Cerrar
Cerrar=SeleccionarTodo
SeleccionarTodo=(Fin)
[Acciones.Embarcar]
Nombre=Embarcar
Boton=0
NombreDesplegar=E&mbarcar...
GuardarAntes=S
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
EnLote=S
RefrescarIconos=S
Expresion=Asigna(Info.ID,DM0134MaviVentaEmbEnLoteVis:ID)<BR>Asigna(Info.Mov,DM0134MaviVentaEmbEnLoteVis:Mov)<BR>Asigna(Info.MovID,DM0134MaviVentaEmbEnLoteVis:MovID)<BR>Asigna(Info.Modulo,<T>VTAS<T>)<BR>Asigna(Info.Estatus,DM0134MaviVentaEmbEnLoteVis:Estatus)<BR>ProcesarSQL(<T>spEmbarqueManual :tEmpresa, :tModulo, :nID, :tMov, :tMovID, :tEstatus, 0<T>, Empresa, Info.Modulo, Info.ID, Info.Mov, Info.MovID, Info.Estatus)
[Lista.]
Carpeta=Lista
ColorFondo=Negro
[VentaEmbEnLotex]
Estilo=Iconos
Clave=VentaEmbEnLotex
Filtros=S
BusquedaRapidaControles=S
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0134MaviVentaEmbEnLoteVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Movimiento<T>
ElementosPorPagina=200
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
FiltroMovsTodos=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroEstatusDefault=CONCLUIDO
FiltroUsuarioDefault=(Usuario)
FiltroFechasCampo=FechaEmision
FiltroFechasDefault=(Todo)
FiltroMovDefault=(Todos)
FiltroFechasNormal=S
FiltroMonedasCampo=Moneda
FiltroFechasCancelacion=FechaCancelacion
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaRespetarFiltros=S
BusquedaInicializar=S
BusquedaAncho=20
BusquedaEnLinea=S
BusquedaRespetarControlesNum=S
ListaAcciones=Embarcar
CarpetaVisible=S
FiltroModificarEstatus=S
BusquedaActualizacionManual=S
ListaEnCaptura=Almacen<BR>Estatus<BR>EmbarqueEstado
IconosNombre=Mov+<T> <T>+MovID
FiltroGeneral=Sello IS NOT NULL
[VentaEmbEnLotex.Columnas]
0=-2
1=95
2=109
3=453
4=-2
5=-2
6=-2
7=-2
8=-2
9=-2
10=-2
11=-2
12=-2
13=-2
14=-2
15=-2
16=-2
17=-2
18=-2
19=-2
[Acciones.Seleccionar Todo]
Nombre=Seleccionar Todo
Boton=38
NombreEnBoton=S
NombreDesplegar=Seleccionar &Todo
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=controles Captura
ClaveAccion=seleccionar Todo
Activo=S
Visible=S
[Acciones.Quitar Seleccion]
Nombre=Quitar Seleccion
Boton=35
NombreEnBoton=S
NombreDesplegar=Quiar &Seleccion
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[Acciones.Cerra]
Nombre=Cerra
Boton=5
NombreDesplegar=C&errar
EnBarraHerramientas=S
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S
TipoAccion=ventana
ClaveAccion=Cerrar
[VentaEmbEnLotex.Almacen]
Carpeta=VentaEmbEnLotex
Clave=Almacen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[VentaEmbEnLotex.Estatus]
Carpeta=VentaEmbEnLotex
Clave=Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[VentaEmbEnLotex.EmbarqueEstado]
Carpeta=VentaEmbEnLotex
Clave=EmbarqueEstado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
