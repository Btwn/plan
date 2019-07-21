[Forma]
Clave=CtasCobrarCFD
Icono=0
Modulos=(Todos)
Nombre=Ctas Cobrar - Generar CFD
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialAlturaCliente=549
PosicionInicialAncho=755
PosicionInicialIzquierda=92
PosicionInicialArriba=54
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
EsMovimiento=S
TituloAuto=S
MovEspecificos=Todos
MovModulo=CXC
ListaAcciones=Cerrar<BR>SeleccionarTodo

[Lista]
Estilo=Iconos
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=CtasCobrarCFD
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
Filtros=S
MenuLocal=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
BusquedaRapidaControles=S
FiltroFechas=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroMonedas=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
FiltroMovs=S
FiltroMovsTodos=S
FiltroFechasCampo=v.FechaEmision
FiltroMovDefault=(Todos)
FiltroMonedasCampo=v.Moneda
FiltroSucursales=S
FiltroEstatusDefault=CONCLUIDO
FiltroUsuarioDefault=(Usuario)
IconosSubTitulo=<T>Movimiento<T>
FiltroListaEstatus=CONCLUIDO<BR>PENDIENTE<BR>CANCELADO
FiltroFechasDefault=(Todo)
BusquedaRapida=S
BusquedaEnLinea=S
BusquedaAncho=20
BusquedaRespetarFiltros=S
BusquedaInicializar=S
BusquedaRespetarControlesNum=S
ListaAcciones=GenerarCFD
ListaEnCaptura=v.FechaEmision<BR>v.Estatus<BR>v.Cliente<BR>v.Importe<BR>v.Impuestos
FiltroEstatus=S
FiltroUsuarios=S
IconosNombre=CtasCobrarCFD:v.Mov+<T> <T>+CtasCobrarCFD:v.MovID
FiltroGeneral=c.Sello IS NULL



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

[Acciones.GenerarCFD]
Nombre=GenerarCFD
Boton=0
NombreDesplegar=Generar CFD
EnMenu=S
TipoAccion=Expresion
Activo=S
RefrescarIconos=S
EnLote=S
ConCondicion=S
Antes=S
Expresion=CFD.Generar( <T>CXC<T>, CtasCobrarCFD:v.ID)
EjecucionCondicion=SQL(<T>spVerMovTipoCFD :tEmpresa, :tModulo, :tMov<T>, Empresa, <T>CXC<T>, CtasCobrarCFD:v.Mov)
AntesExpresiones=PuedeAfectar(Usuario.Afectar, Usuario.AfectarOtrosMovs, CtasCobrarCFD:v.Usuario)
VisibleCondicion=Usuario.AfectarLote y Empresa.CFD

[Lista.v.FechaEmision]
Carpeta=Lista
Clave=v.FechaEmision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Lista.v.Estatus]
Carpeta=Lista
Clave=v.Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro

[Lista.v.Cliente]
Carpeta=Lista
Clave=v.Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro

[Lista.v.Importe]
Carpeta=Lista
Clave=v.Importe
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Lista.v.Impuestos]
Carpeta=Lista
Clave=v.Impuestos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
