[Forma]
Clave=MAVIDineroDepositosAnticipados
Icono=6
Modulos=(Todos)
Nombre=<T>Depósitos Anticipados Pendientes<T>
ListaCarpetas=Lista
CarpetaPrincipal=Lista
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
VentanaEscCerrar=S
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialIzquierda=201
PosicionInicialArriba=257
PosicionInicialAltura=300
PosicionInicialAncho=917
PosicionInicialAlturaCliente=273
ListaAcciones=Seleccionar

[Lista]
Estilo=Iconos
PestanaOtroNombre=S
PestanaNombre=Pendientes
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=MAVIDineroPendiente
Fuente={MS Sans Serif, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Movimiento<T>
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DineroPendiente.FechaEmision<BR>DineroPendiente.CtaDinero<BR>DineroPendiente.Importe<BR>DineroPendiente.Saldo<BR>Concepto<BR>Observaciones
CarpetaVisible=S
Filtros=S
FiltroPredefinido=S
FiltroAncho=30
FiltroEnOrden=S
FiltroTodoNombre=Todo
FiltroNullNombre=(sin clasificar)
FiltroRespetar=S
FiltroTipo=General
IconosSeleccionPorLlave=S
IconosNombre=MAVIDineroPendiente:DineroPendiente.Mov+<T> <T>+<BR>MAVIDineroPendiente:DineroPendiente.MovID
FiltroGeneral=DineroPendiente.Empresa=<T>{Empresa}<T> AND<BR>DineroPendiente.MovTipo=<T>{DIN.DA}<T>

[Lista.DineroPendiente.FechaEmision]
Carpeta=Lista
Clave=DineroPendiente.FechaEmision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro




[Lista.Columnas]
0=164
1=81
2=113
3=105
4=93
5=141
6=203
[Lista.DineroPendiente.Importe]
Carpeta=Lista
Clave=DineroPendiente.Importe
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Lista.DineroPendiente.CtaDinero]
Carpeta=Lista
Clave=DineroPendiente.CtaDinero
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Lista.DineroPendiente.Saldo]
Carpeta=Lista
Clave=DineroPendiente.Saldo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreDesplegar=&Seleccionar
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Antes=S
Visible=S
NombreEnBoton=S
EnBarraHerramientas=S
AntesExpresiones=Asigna(Info.MAVIMov,MAVIDineroPendiente:DineroPendiente.Mov)<BR>Asigna(Info.MAVIMovId,MAVIDineroPendiente:DineroPendiente.MovID)<BR>Asigna(Info.DepositoAnticipadoMAVI, MAVIDineroPendiente:MovimientoMAVI)<BR>Asigna(Info.ImporteMAVI,MAVIDineroPendiente:DineroPendiente.Importe)<BR>Asigna(Info.SaldoMAVI,MAVIDineroPendiente:DineroPendiente.Saldo)
[Lista.Concepto]
Carpeta=Lista
Clave=Concepto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Observaciones]
Carpeta=Lista
Clave=Observaciones
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
