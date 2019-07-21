[Forma]
Clave=MAVIExplorarDineroModulo
Icono=47
Modulos=(Todos)
Nombre=<T>Explorando - Tesoreria<T>
MovModulo=DIN
PosicionInicialAlturaCliente=473
PosicionInicialAncho=859
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialIzquierda=210
PosicionInicialArriba=146
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Cerrar<BR>Seleccionar<BR>Personalizar
EsMovimiento=S
TituloAuto=S
MovEspecificos=Todos
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado


[Lista]
Estilo=Iconos
PestanaOtroNombre=S
PestanaNombre=Movimientos
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DineroA
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Movimiento<T>
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Dinero.FechaEmision<BR>Dinero.Concepto<BR>Dinero.CtaDinero<BR>Dinero.CtaDineroDestino<BR>Dinero.Referencia<BR>ImporteTotal
CarpetaVisible=S
Filtros=S
OtroOrden=S
BusquedaRapidaControles=S
PermiteLocalizar=S
ListaOrden=Dinero.ID<TAB>(Decendente)
FiltroAplicaO=Dinero.CtaDineroDestino
FiltroAplicaEn=Dinero.CtaDinero
FiltroPredefinido=S
FiltroAutoCampo=(Validaciones Memoria)
FiltroAutoValidar=CtaDinero
FiltroNullNombre=(sin clasificar)
FiltroTodo=S
FiltroEnOrden=S
FiltroTodoNombre=(Todas)
FiltroAncho=15
FiltroRespetar=S
FiltroTipo=Múltiple (por Grupos)
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
FiltroEstatus=S
FiltroUsuarios=S
FiltroFechas=S
FiltroSituacion=S
FiltroProyectos=S
FiltroSucursales=S
FiltroListaEstatus=(Todos)<BR>SINAFECTAR<BR>BORRADOR<BR>PENDIENTE<BR>CONCLUIDO<BR>CANCELADO
FiltroEstatusDefault=CONCLUIDO
FiltroUsuarioDefault=(Todos)
FiltroFechasCampo=Dinero.FechaEmision
FiltroFechasDefault=Este Mes
FiltroFechasCancelacion=Dinero.FechaCancelacion
BusquedaRapida=S
BusquedaRespetarFiltros=S
BusquedaRespetarControles=S
BusquedaEnLinea=S
BusquedaAncho=20
FiltroSituacionTodo=S
FiltroMonedas=S
FiltroMonedasCampo=Dinero.Moneda
BusquedaInicializar=S
FiltroMovsTodos=S
FiltroMovDefault=Cheque
FiltroUENs=S
FiltroUENsCampo=Dinero.UEN
FiltroGrupo1=(Validaciones Memoria)
FiltroValida1=CtaDineroCat
FiltroGrupo2=(Validaciones Memoria)
FiltroValida2=CtaDineroGrupo
FiltroGrupo3=(Validaciones Memoria)
FiltroValida3=CtaDineroFam
FiltroAplicaEn1=CtaDinero.Categoria
FiltroAplicaEn2=CtaDinero.Grupo
FiltroAplicaEn3=CtaDinero.Familia
FiltroListas=S
FiltroListasRama=DIN
FiltroListasAplicaEn=Dinero.CtaDinero
IconosNombre=DineroA:Dinero.Mov+<T> <T>+DineroA:Dinero.MovID
FiltroGeneral=Dinero.Empresa=<T>{Empresa}<T> AND Dinero.Mov=<T>Cheque<T>

[Lista.Dinero.FechaEmision]
Carpeta=Lista
Clave=Dinero.FechaEmision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Dinero.Referencia]
Carpeta=Lista
Clave=Dinero.Referencia
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
0=128
1=83
2=88
3=86
4=95
5=88
6=100
7=77

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

[Lista.Dinero.CtaDinero]
Carpeta=Lista
Clave=Dinero.CtaDinero
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Dinero.CtaDineroDestino]
Carpeta=Lista
Clave=Dinero.CtaDineroDestino
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Dinero.Concepto]
Carpeta=Lista
Clave=Dinero.Concepto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
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

[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S

