[Forma]
Clave=MAVIExploradorCalificacion
Nombre=Calificación
Icono=0
BarraHerramientas=S
EsConsultaExclusiva=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
ListaCarpetas=MAVIVentaC
CarpetaPrincipal=MAVIVentaC
PosicionInicialIzquierda=117
PosicionInicialArriba=178
PosicionInicialAlturaCliente=412
PosicionInicialAncho=964
ListaAcciones=(Lista)
Totalizadores=S
PosicionSec1=333
PosicionSec2=134
Comentarios=<T>Calificacion Global: <T>& MAVIVentaC:CalificacionGlobal & <T> ADJ / INC: <T> & MAVIVentaC:PonderacionGlobal
VentanaRepetir=S
[MAVIVentaC]
Estilo=Iconos
Clave=MAVIVentaC
Filtros=S
BusquedaRapidaControles=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=MAVIVentaC
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNombre=&Vencimiento
CarpetaVisible=S
ListaEnCaptura=(Lista)
IconosSubTitulo=Movimiento
FiltroFechas=S
BusquedaRapida=S
BusquedaEnLinea=S
FiltroListaEstatus=(Lista)
FiltroEstatusDefault=CONCLUIDO
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaAncho=20
FiltroEditarFueraPeriodo=S
FiltroFechasCampo=Cxc.Vencimiento
FiltroFechasVencimiento=S
FiltroFechasDefault=(Todo)
FiltroEstatus=S
IconosNombre=MAVIVentaC:Cxc.Mov + <T> <T> + MAVIVentaC:Cxc.MovID
FiltroGeneral={<BR><T>Cxc.Cliente =<T>+Comillas(Info.Cliente)<BR>}
[MAVIVentaC.Columnas]
0=97
1=81
2=85
3=92
4=77
5=60
6=65
7=81
8=79
9=67
10=77
11=-2
[Acciones.Cerrar]
Nombre=Cerrar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.ResumenFactura]
Nombre=ResumenFactura
Boton=9
NombreEnBoton=S
NombreDesplegar=&Resumen por Factura
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Seleccionar<BR>Expresion<BR>Asignar<BR>Forma
Antes=S
AntesExpresiones=Asigna(Info.ID, MAVIVentaC:Cxc.ID)

[MAVIVentaC.AbonoMAVI]
Carpeta=MAVIVentaC
Clave=AbonoMAVI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[MAVIVentaC.%AbonoMAVI]
Carpeta=MAVIVentaC
Clave=%AbonoMAVI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[MAVIVentaC.SaldoMAVI]
Carpeta=MAVIVentaC
Clave=SaldoMAVI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[MAVIVentaC.SaldoVencidoMAVI]
Carpeta=MAVIVentaC
Clave=SaldoVencidoMAVI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[MAVIVentaC.%SaldoVencidoMAVI]
Carpeta=MAVIVentaC
Clave=%SaldoVencidoMAVI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[MAVIVentaC.Calificacion]
Carpeta=MAVIVentaC
Clave=Calificacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[MAVIVentaC.%Calificacion]
Carpeta=MAVIVentaC
Clave=%Calificacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Totalizadores)]
Clave=(Carpeta Totalizadores)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Derecha
FichaColorFondo=Plata
FichaAlineacionDerecha=S
Totalizadores1=Importe<BR>Abono<BR>Saldo Capital<BR>Saldo Vencido
Totalizadores2=Suma(MAVIVentaC:Cxc.Importe + MAVIVentaC:Cxc.Impuestos)<BR>Suma(MAVIVentaC:AbonoMAVI)<BR>Suma(MAVIVentaC:SaldoMAVI)<BR>Suma(MAVIVentaC:SaldoVencidoMAVI)
Totalizadores=S
TotCarpetaRenglones=MAVIVentaC
CampoColorLetras=Negro
CampoColorFondo=Plata
CarpetaVisible=S
Totalizadores3=(Monetario)<BR>(Monetario)<BR>(Monetario)<BR>(Monetario)
ListaEnCaptura=Importe<BR>Abono<BR>Saldo Capital<BR>Saldo Vencido
[(Carpeta Totalizadores).Importe]
Carpeta=(Carpeta Totalizadores)
Clave=Importe
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Plata
ColorFuente=Negro
[(Carpeta Totalizadores).Abono]
Carpeta=(Carpeta Totalizadores)
Clave=Abono
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Plata
ColorFuente=Negro
[(Carpeta Totalizadores).Saldo Capital]
Carpeta=(Carpeta Totalizadores)
Clave=Saldo Capital
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Plata
ColorFuente=Negro
[(Carpeta Totalizadores).Saldo Vencido]
Carpeta=(Carpeta Totalizadores)
Clave=Saldo Vencido
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Plata
ColorFuente=Negro
[Acciones.ResumenFactura.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
[Acciones.ResumenFactura.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Mov, MAVIVentaC:Cxc.Mov)<BR>Asigna(Info.MovID, MAVIVentaC:Cxc.MovID)
[Acciones.ResumenFactura.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.ResumenFactura.Forma]
Nombre=Forma
Boton=0
;TipoAccion=Formas
TipoAccion=Expresion
;SQL=spRFCte {Info.RFcliente},<BR><T>{EstacionTrabajo}<T>,<BR>Info.RFCadena
;Expresion=Asigna(Info.RFCliente, SQL(<T>SELECT Cxc.Cliente From CXC Where Cxc.ID = :tCteCx<T>, MAVIVentaC:Cxc.ID))<BR>EjecutarSQL(<T>spRFCte :tCte, :tEst, :nbit<T>, Info.RFCliente, EstacionTrabajo, 1)<BR>Ejecutar(<T>PlugIns\ResumenFactura.exe<T>)
;Expresion=EjecutarSQL(<T>spRFCte :tCte, :tEst, :nbit<T>, Info.Cliente, EstacionTrabajo, 1)<BR>Ejecutar(<T>PlugIns\ResumenFactura.exe<T>)
Expresion=Ejecutar(<T>PlugIns\ResumenFactura.exe <T>+Info.Cliente+'|'+EstacionTrabajo)
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=ConDatos(Info.MovID)
EjecucionMensaje=<T>No tiene datos..<T>

[Acciones.TableroMOP]
Nombre=TableroMOP
Boton=88
NombreEnBoton=S
NombreDesplegar=Tablero MOP
EnBarraHerramientas=S
TipoAccion=Reportes Pantalla
ClaveAccion=RepMOPMAVI
Activo=S
Visible=S
EspacioPrevio=S
Antes=S
Multiple=S
ListaAccionesMultiples=Seleccionar<BR>Expresion<BR>RepMOPMAVI
AntesExpresiones=Asigna(Info.ID,SQL(<T>SELECT dbo.fnIDFactCXCMAVI(:nID)<T>,MAVIVentaC:Cxc.ID))<BR>Asigna(Info.Mov, MAVIVentaC:Cxc.Mov)<BR>Asigna(Info.MovID, MAVIVentaC:Cxc.MovID)
[MAVIVentaC.TotalVenta]
Carpeta=MAVIVentaC
Clave=TotalVenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.TableroMOP.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
[Acciones.TableroMOP.RepMOPMAVI]
Nombre=RepMOPMAVI
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=RepMOPMAVI
Activo=S
ConCondicion=S
EjecucionConError=S
Visible=S
EjecucionCondicion=ConDatos( Info.MovId)
EjecucionMensaje=<T>No tiene Datos..<T>
[Acciones.TableroMOP.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Mov, MAVIVentaC:Cxc.Mov)<BR>Asigna(Info.MovID, MAVIVentaC:Cxc.MovID)<BR>Asigna(Info.ID, MAVIVentaC:Cxc.ID)
[MAVIVentaC.Cxc.FechaEmision]
Carpeta=MAVIVentaC
Clave=Cxc.FechaEmision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[MAVIVentaC.Cxc.Condicion]
Carpeta=MAVIVentaC
Clave=Cxc.Condicion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[MAVIVentaC.Cxc.Estatus]
Carpeta=MAVIVentaC
Clave=Cxc.Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro

[MAVIVentaC.ListaEnCaptura]
(Inicio)=Cxc.FechaEmision
Cxc.FechaEmision=Cxc.Condicion
Cxc.Condicion=TotalVenta
TotalVenta=AbonoMAVI
AbonoMAVI=%AbonoMAVI
%AbonoMAVI=SaldoMAVI
SaldoMAVI=SaldoVencidoMAVI
SaldoVencidoMAVI=%SaldoVencidoMAVI
%SaldoVencidoMAVI=%Calificacion
%Calificacion=Calificacion
Calificacion=Cxc.Estatus
Cxc.Estatus=(Fin)

[MAVIVentaC.FiltroListaEstatus]
(Inicio)=(Todos)
(Todos)=PENDIENTE
PENDIENTE=CONCLUIDO
CONCLUIDO=CANCELADO
CANCELADO=SINAFECTAR
SINAFECTAR=(Fin)







[Forma.ListaAcciones]
(Inicio)=Cerrar
Cerrar=ResumenFactura
ResumenFactura=TableroMOP
TableroMOP=(Fin)

