[Forma]
Clave=MaviBonificacionCxctest
Icono=4
Modulos=(Todos)
Nombre=<T>Movimientos - Cuentas por Cobrar<T>
MovModulo=CXC
PosicionInicialAlturaCliente=576
PosicionInicialAncho=981
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialIzquierda=149
PosicionInicialArriba=95
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
EsMovimiento=S
TituloAuto=S
MovEspecificos=Todos
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
EsConsultaExclusiva=S
Comentarios=Lista(Info.Mov, Info.Estatus, Info.Situacion)
AutoGuardar=S
ListaAcciones=Cerrar<BR>Bonificaciones<BR>Documento

[Lista]
Estilo=Iconos
PestanaOtroNombre=S
PestanaNombre=Movimientos
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=CxcATest
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(Situación)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Movimiento<T>
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Cxc.FechaEmision<BR>Cxc.Cliente<BR>Cte.Nombre<BR>Cxc.Referencia<BR>Cxc.Concepto<BR>ImporteTotal<BR>Cxc.Saldo
CarpetaVisible=S
OtroOrden=S
BusquedaRapidaControles=S
PermiteLocalizar=S
ListaOrden=Cxc.ID<TAB>(Decendente)
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
FiltroFechas=S
FiltroSucursales=S
FiltroListaEstatus=(Todos)<BR>SINAFECTAR<BR>PENDIENTE<BR>CONCLUIDO<BR>CANCELADO
FiltroEstatusDefault=(Todos)
FiltroUsuarioDefault=(Todos)
FiltroFechasCampo=Cxc.FechaEmision
FiltroFechasDefault=Este Mes
FiltroFechasCancelacion=Cxc.FechaCancelacion
BusquedaRapida=S
BusquedaRespetarFiltros=S
BusquedaRespetarControles=S
BusquedaEnLinea=S
BusquedaAncho=20
FiltroSituacionTodo=S
FiltroMonedas=S
FiltroMonedasCampo=Cxc.Moneda
BusquedaInicializar=S
FiltroMovsTodos=S
FiltroMovDefault=(Todos)
FiltroUsuarios=S
FiltroEstatus=S
FiltroMovs=S
IconosNombre=CxcATest:Cxc.Mov+<T> <T>+CxcATest:Cxc.MovID

[Lista.Cxc.FechaEmision]
Carpeta=Lista
Clave=Cxc.FechaEmision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Cxc.Referencia]
Carpeta=Lista
Clave=Cxc.Referencia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

[Lista.ImporteTotal]
Carpeta=Lista
Clave=ImporteTotal
Editar=S
Totalizador=1
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Columnas]
0=159
1=85
2=95
3=152
4=221
5=88
6=100
7=77

[Lista.Cxc.Concepto]
Carpeta=Lista
Clave=Cxc.Concepto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro







[Lista.Cxc.Cliente]
Carpeta=Lista
Clave=Cxc.Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Cte.Nombre]
Carpeta=Lista
Clave=Cte.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Cxc.Saldo]
Carpeta=Lista
Clave=Cxc.Saldo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
NombreEnBoton=S
[Acciones.Bonificaciones]
Nombre=Bonificaciones
Boton=20
NombreDesplegar=Bonif. Pago Total
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
EspacioPrevio=S
Antes=S
NombreEnBoton=S
Expresion=EjecutarSQLAnimado(<T>spBonificacionesCalculaTabla :nidcxc,:nestacion,:tTodos, :nCobro<T>,CxcATest:Cxc.ID,EstacionTrabajo, <T>Total<T>,0 )<BR> FormaModal(<T>MaviBonificacionTest<T>)
AntesExpresiones=Asigna(Info.ID,CxcATest:Cxc.ID)<BR>Asigna(Info.Origen,CxcATest:Cxc.Origen)<BR>Asigna(Info.OrigenID,CxcATest:Cxc.OrigenID)
[Acciones.Documento]
Nombre=Documento
Boton=1
NombreDesplegar=Bonif. Pago Parcial
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S
Expresion=EjecutarSQLAnimado(<T>spBonificacionesCalculaTabla :nidcxc,:nestacion,:tTodos,:nCobro<T>,CxcATest:Cxc.ID,EstacionTrabajo, <T>Documento<T>,0 )<BR> FormaModal(<T>MaviBonificacionTest<T>)

