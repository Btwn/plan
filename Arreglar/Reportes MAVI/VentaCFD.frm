[Forma]
Clave=VentaCFD
Icono=0
Modulos=(Todos)
Nombre=Ventas - Generar CFD
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
MovModulo=VTAS
ListaAcciones=Cerrar<BR>SeleccionarTodo

[Lista]
Estilo=Iconos
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=VentaCFD
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
ListaEnCaptura=v.FechaEmision<BR>v.Estatus<BR>v.Cliente<BR>c.Importe<BR>v.Impuestos
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
FiltroEstatus=S
FiltroUsuarios=S
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
IconosNombre=VentaCFD:v.Mov+<T> <T>+VentaCFD:v.MovID
FiltroGeneral=c.Sello IS NULL

[Lista.v.FechaEmision]
Carpeta=Lista
Clave=v.FechaEmision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
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

[Lista.Columnas]
0=172
1=120
2=95
3=93
4=94
5=97

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

[Lista.c.Importe]
Carpeta=Lista
Clave=c.Importe
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
Expresion=Si<BR>VentaCFD:v.Estatus=EstatusSinAfectar<BR>Entonces<BR>  EjecutarSQL(<T>spAfectar :tModulo, :nID, :tAccion<T>, <T>VTAS<T>, VentaCFD:v.ID, <T>CONSECUTIVO<T>)<BR>  Si(no CFD.Generar(<T>VTAS<T>, VentaCFD:v.ID), AbortarOperacion)<BR>  Afectar(<T>VTAS<T>, VentaCFD:v.ID, VentaCFD:v.Mov, VentaCFD:v.MovID, <T>Todo<T>, <T><T>, <T>ProcesarVenta<T>)<BR>Sino<BR>  Si(no CFD.Generar(<T>VTAS<T>, VentaCFD:v.ID), AbortarOperacion)<BR>Fin<BR>Asigna(Afectar.EnviarCFD, SQL(<T>SELECT EnviarAlAfectar FROM EmpresaCFD WHERE Empresa=:tEmpresa<T>, Empresa))<BR>Si(Afectar.EnviarCFD, CFD.Enviar(<T>VTAS<T>, VentaP:ID))
EjecucionCondicion=SQL(<T>spVerMovTipoCFD :tEmpresa, :tModulo, :tMov<T>, Empresa, <T>VTAS<T>, VentaCFD:v.Mov)
AntesExpresiones=PuedeAfectar(Usuario.Afectar, Usuario.AfectarOtrosMovs, VentaCFD:v.Usuario)
VisibleCondicion=Usuario.AfectarLote y Empresa.CFD
