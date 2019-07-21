[Forma]
Clave=MAVIExplorarCxp
Nombre=<T>Explorando - Cuentas por Pagar<T>
Icono=47
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialIzquierda=122
PosicionInicialArriba=140
PosicionInicialAltura=508
PosicionInicialAncho=1035
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Cerrar<BR>Seleccionar<BR>Campos
EsMovimiento=S
TituloAuto=S
MovModulo=CXP
MovEspecificos=Todos
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
EsConsultaExclusiva=S
PosicionInicialAlturaCliente=485
VentanaExclusiva=S

[Lista]
Estilo=Iconos
Clave=Lista
Filtros=S
BusquedaRapidaControles=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=Cxp
Fuente={MS Sans Serif, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Movimiento<T>
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Cxp.Proveedor<BR>Prov.Nombre<BR>Cxp.FechaEmision<BR>Cxp.Vencimiento<BR>Cxp.Referencia<BR>Cxp.Concepto<BR>Cxp.Importe<BR>Cxp.Impuestos<BR>ImporteTotal<BR>SaldoF
FiltroPredefinido=S
FiltroAutoCampo=(Validaciones Memoria)
FiltroAutoValidar=Mon
FiltroNullNombre=(sin clasificar)
FiltroTodoNombre=Todo
FiltroAncho=20
FiltroAplicaEn=Cxp.Moneda
FiltroRespetar=S
FiltroTipo=General
FiltroEstatus=S
FiltroFechas=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroSituacion=S
FiltroSituacionTodo=S
FiltroListaEstatus=(Todos)<BR>PENDIENTE<BR>CONCLUIDO<BR>CANCELADO<BR>SINAFECTAR
FiltroEstatusDefault=PENDIENTE
FiltroFechasCampo=Cxp.FechaEmision
FiltroFechasDefault=Este Mes
FiltroFechasNormal=S
BusquedaRapida=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaAncho=20
BusquedaEnLinea=S
CarpetaVisible=S
PestanaOtroNombre=S
PestanaNombre=Movimientos
FiltroMovs=S
FiltroMovsTodos=S
FiltroMovDefault=(Todos)
FiltroMonedasCampo=Cxp.Moneda
FiltroSucursales=S
FiltroMonedas=S
FiltroProyectos=S
FiltroUENs=S
FiltroUENsCampo=Cxp.UEN
IconosNombre=Cxp:Cxp.Mov+<T> <T>+Cxp:Cxp.MovID
FiltroGeneral=Cxp.Empresa=<T>{Empresa}<T>

[Lista.Cxp.Proveedor]
Carpeta=Lista
Clave=Cxp.Proveedor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Prov.Nombre]
Carpeta=Lista
Clave=Prov.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Cxp.FechaEmision]
Carpeta=Lista
Clave=Cxp.FechaEmision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Cxp.Referencia]
Carpeta=Lista
Clave=Cxp.Referencia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Cxp.Concepto]
Carpeta=Lista
Clave=Cxp.Concepto
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
0=127
1=83
2=146
3=81
4=71
5=75
6=64
7=78
8=88
9=86
10=87

[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Lista.Cxp.Vencimiento]
Carpeta=Lista
Clave=Cxp.Vencimiento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Cxp.Importe]
Carpeta=Lista
Clave=Cxp.Importe
Editar=S
Totalizador=1
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Cxp.Impuestos]
Carpeta=Lista
Clave=Cxp.Impuestos
Editar=S
Totalizador=1
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro




[Acciones.Campos]
Nombre=Campos
Boton=45
NombreDesplegar=Personalizar &Vista
EnBarraHerramientas=S
EspacioPrevio=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Mostrar Campos
Activo=S
Visible=S



[Lista.SaldoF]
Carpeta=Lista
Clave=SaldoF
Editar=S
Totalizador=1
LineaNueva=S
ValidaNombre=S
3D=S
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
EspacioPrevio=S

