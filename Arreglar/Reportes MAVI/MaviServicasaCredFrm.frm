[Forma] 
Clave=MaviServicasaCredFrm
Nombre=Info.UENMAVI+<T> SERVICASA CRÉDITO<T>+<T> SUCURSAL <T>+Sucursal+<T><T>+Ahora
Icono=746
Menus=S
BarraHerramientas=S
Modulos=VTAS
MovModulo=VTAS
AccionesTamanoBoton=15x5
ListaCarpetas=Sucursal<BR>Filtros<BR>Servicasa<BR>Detalle
CarpetaPrincipal=Servicasa
PosicionInicialIzquierda=14
PosicionInicialArriba=34
PosicionInicialAlturaCliente=745
PosicionInicialAncho=1260
VentanaTipoMarco=Normal
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ListaAcciones=AbrirMovSC<BR>NuevoSC<BR>InfoCteSC<BR>CteCtoSC<BR>Coincidencias<BR>ServicasaUnicajaSC<BR>Kardex<BR>MovPosSC<BR>MovBitacoraSC<BR>MovTiempoSC<BR>AgregarEventoSC<BR>RelacionCteSC<BR>HistoricoSolicitudes<BR>Registro<BR>RecomendadosServicasaSC<BR>ReporteServicasa<BR>NotasCobranza<BR>NotasAreaCobranza<BR>ServicredCred<BR>HistoricoUnicajaSC<BR>ExcelSC<BR>ActualizarSC<BR>copiar<BR>Consulta<BR>ClienteF<BR>PersonalizarSC<BR>Acercade<BR>Cerrar<BR>ReporteRM0855A<BR>ReporteServicred<BR>ReporteAnuelesSC<BR>RM1124<BR>RM1127<BR>ConsultaINTL<BR>ACD00017VisorMavi<BR>RM1121
PosicionSec1=95
PosicionSec2=500
AccionesDivision=S
Comentarios=Usuario,
PosicionCol2=100
VentanaAvanzaTab=S
VentanaAjustarZonas=S
AccionesDerecha=S
CarpetasMultilinea=S
EsMovimiento=S
TituloAuto=S

MovimientosValidos=Solicitud Credito<BR>Analisis Credito<BR>Sol Dev Unicaja<BR>Solicitud Devolucion<BR>Factura<BR>Factura VIU<BR>Credilana<BR>Seguro Vida<BR>Seguro Auto<BR>Prestamo Personal<BR>Pedido
MovEspecificos=Especificos
FiltrarFechasSinHora=S
PosicionCol1=750
ExpresionesAlMostrar=Asigna(Mavi.DM0112Mov,<T>Solicitud Credito<T>)<BR>Asigna(Mavi.DM0112Estatus,<T>PENDIENTE<T>)<BR>Asigna(Mavi.DM0112Situacion,nulo)<BR>Asigna(Mavi.FechaI,FechaDMA(SQL(<T>Select GetDate()<T>)))<BR>Asigna(Mavi.FechaF,FechaDMA(SQL(<T>Select GetDate()<T>)))<BR>Asigna(Mavi.DM0112Busqueda,nulo)<BR>CopiarArchivo(<T>PlugIns\Copiar.exe<T>,<T>C:\Temp\Intelisis\Copiar.exe<T>)<BR>Asigna(Info.Copiar, Falso)<BR>Asigna(Info.Positivos, Verdadero)<BR>Asigna(Info.Paquete, Nulo)<BR>Asigna(Info.RefrescandoPrecio, Falso)<BR>Si(Sql(<T>Exec sp_MaviDM0112IniUs :tusu <T>,usuario) <> <T>Error<T>,<T><T>,informacion(<T>Error al inicializar usuario<T>))<BR>Asigna(Mavi.Sucursal, SQL(<T>Select Sucursal from Usuario Where Usuario = :tUsu<T>, Usuario))<BR>Asigna(Mavi.DM0112ComboBusqueda, <T>MovID<T>)
ExpresionesAlCerrar=Asigna(Filtro.Cliente, Nulo)<BR>Asigna(Filtro.Proyecto, Nulo)<BR>Asigna(Filtro.Aseguradora, Nulo)           <BR>Asigna(Filtro.Mov, Nulo)<BR>Asigna(Filtro.Proyecto, Nulo)<BR>Asigna(Filtro.Actividad, Nulo)
ExpresionesAlActivar=CopiarArchivo(<T>PlugIns\Copiar.exe<T>,<T>C:\Temp\Intelisis\Copiar.exe<T>)
MenuPrincipal=&Archivo<BR>&Exploradores<BR>&Edicion<BR>&Ver<BR>&Reportes<BR>&Ayuda

[Servicasa]
Estilo=Iconos
Clave=Servicasa
Zona=B1
Fuente={Tahoma, 8, Azul marino, [Negritas]}
CampoColorLetras=Negro
CampoColorFondo=Blanco
MenuLocal=S
ListaAcciones=AbrirMovDSC<BR>NuevoDSC<BR>InfoCteDSC<BR>CteCtoDSC<BR>MovPosDSC<BR>MovBitacoraDCS<BR>MovTiempoDSC<BR>Tiempo Total<BR>AgregarEventoDSC<BR>RelacionCteDSC<BR>PersonalizarDSC<BR>CopiarDSC<BR>CitaSup<BR>Monedero<BR>HojaV<BR>Reanalisis<BR>ctefinal<BR>ConsultaBC<BR>InvesTelefonica<BR>VisorSA<BR>VisorSC<BR>VisorBA<BR>VisorBC<BR>VisorIA<BR>VisorIC
ConFuenteEspecial=S
MostrarConteoRegistros=S
AlineacionAutomatica=S
AcomodarTexto=S
Vista=MaviServiCasaCredVis
ListaEnCaptura=IDEcommerce<BR>SucursalOrigen<BR>Cliente<BR>Nombre<BR>TextoAmostrar<BR>VTACambaceo<BR>CANALVENTA<BR>EstatusConvenio<BR>Condicion<BR>SolRefinanciamiento<BR>ImporteTotal<BR>Monedero<BR>TiempoTotalTranscurrido<BR>Estatus<BR>Situacion<BR>Reactivacion<BR>Grupo<BR>Relacionado<BR>%Supervision<BR>ReferenciaAnterior<BR>FechaAlta<BR>FUM<BR>Agente<BR>Seguimiento<BR>Calificacion<BR>Observaciones<BR>Fech. Alta. a Fech. Ult. Mod.<BR>Fech. Ult. Mod. a Fech. Act.
FiltroPredefinido1=Solicitud Crédito<BR>Analisis Crédito
FiltroPredefinido2=Mov=<T>Solicitud Credito<T><BR>Mov=<T>Analisis Credito<T>
FiltroPredefinido3=ID Desc<BR>ID Desc
PestanaOtroNombre=S
PestanaNombre=Movimientos
IconosCampo=(Situación)
IconosEstilo=Detalles
IconosAlineacion=de Izquierda a Derecha
IconosConSenales=S
IconosSubTitulo=<T>Movimiento<T>
IconosConPaginas=N
ElementosPorPagina=500
IconosConRejilla=S
IconosNombreNumerico=S
CarpetaVisible=S
IconosNombre=MaviServiCasaCredVis:Mov+<T> <T>+MaviServiCasaCredVis:MovID
[Servicasa.Columnas]
0=231
1=119
2=124
3=219
4=154
5=171
6=130
7=80
8=125
9=108
10=104
11=106
12=117
13=98
14=143
15=177
16=302
17=172
18=106
19=153
20=-2
21=136
22=-2
23=-2
24=137
25=-2
26=97
27=-2
28=-2
SucursalOrigen=79
Cliente=64
Nombre=604
CanalVenta=64
Condicion=304
SolRefinanciamiento=100
ImporteTotal=69
TiempoTotalTranscurrido=128
Estatus=94
Reactivacion=76
Grupo=33
RELACIONADO=70
%Supervision=125
ReferenciaAnterior=496
FechaAlta=94
FF=94
FUM=232
Agente=64
CategoriaVenta=304
Seguimiento=64
Calificacion=604
Observaciones=604
SucursalVenta=75
SucursalDestino=83
Fech. Alta. a Fech. Ult. Mod.=196
Fech. Ult. Mod. a Fech. Act.=196
[Acciones.ServicredCred]
Nombre=ServicredCred
Boton=2
NombreEnBoton=S
NombreDesplegar=Servicred Crédito 
TipoAccion=Formas
ClaveAccion=MaviServicredCredFrm
Activo=S
Visible=S
Menu=&Exploradores
UsaTeclaRapida=S
TeclaRapida=Ctrl+F9
EnMenu=S
[Detalle]
Estilo=Iconos
Clave=Detalle
AlineacionAutomatica=S
AcomodarTexto=S
Zona=C1
Fuente={Tahoma, 8, Azul marino, [Negritas]}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
Vista=MaviServicasaTCVis
ListaEnCaptura=CALIFICACION<BR>Observaciones<BR>USUARIO
Detalle=S
VistaMaestra=MaviServiCasaCredVis
LlaveLocal=ID
LlaveMaestra=ID
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSubTitulo=<T>Fecha<T>
IconosConRejilla=S
ConFuenteEspecial=S
OtroOrden=S
ListaOrden=FECHA<TAB>(Decendente)
IconosNombre=MaviServicasaTCVis:FECHA
[Detalle.Columnas]
0=154
1=419
2=226
3=81
4=76
[Acciones.AbrirMovSC.AsigAbrirMovSC]
Nombre=AsigAbrirMovSC
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Asigna(Info.ID,MaviServiCasaCredVis:ID)<BR> Asigna(Info.Mov,MaviServiCasaCredVis:Mov)<BR> Asigna(Info.Movid,MaviServiCasaCredVis:Movid)<BR> Asigna(Info.Situacion,MaviServiCasaCredVis:Situacion)<BR> Asigna(Mavi.TipoCliente,MaviServiCasaCredVis:MaviTipoVenta)<BR> Asigna(Info.Estatus,MaviServiCasaCredVis:Estatus)
EjecucionCondicion=Condatos(MaviServiCasaCredVis:Id)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
[Acciones.AbrirMovSC.FrmAbrirMovSC]
Nombre=FrmAbrirMovSC
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Asigna(Mavi.ServicasaModulo,3)<BR>Si sql(<T>select count(*) from MaviDM0112USCA where usuario = :tUsuario<T>, Usuario)=0<BR>    entonces<BR>        FormaPos(<T>Venta<T>,Vacio(Info.ID,0))<BR>        sql(<T>Exec sp_MaviDM0112BUSC :tUsuario<T>,Usuario)<BR>        sql(<T>Exec sp_MaviDM0112GUSC :tusu,:tmov,:tmovid,:nid <T>,usuario,MaviServiCasaCredVis:Mov,MaviServiCasaCredVis:Movid,MaviServiCasaCredVis:Id)<BR>    sino<BR>        Si sql(<T>select Folio from MaviDM0112usca where Usuario = :tUsuario <T>, Usuario)=(MaviServiCasaCredVis:Mov+<T> <T>+MaviServiCasaCredVis:Movid)<BR>            Entonces<BR>                FormaPos(<T>Venta<T>,Vacio(Info.ID,0))<BR>            Sino<BR>                Error(<T>Existe un Movimiento abierto por este Usuario<T>)<BR>                FormaPos(<T>Venta<T>,Vacio(I<CONTINUA>
Expresion002=<CONTINUA>nfo.ID,0))<BR>        Fin<BR>Fin
EjecucionCondicion=(sql(<T>Exec sp_MaviDM0112CUSC :tmov,:tmovid,:nid <T>,MaviServiCasaCredVis:Mov,MaviServiCasaCredVis:Movid,MaviServiCasaCredVis:Id) = <T>Disponible<T><BR>y Condatos(Info.ID))<BR>o (sql(<T>select Usuario from MaviDM0112usca where Mov = :tMov and MovID = :tMovid <T>, MaviServiCasaCredVis:Mov,MaviServiCasaCredVis:Movid)=Usuario)
EjecucionMensaje=<T>Movimiento ocupado por otro usuario<T>
[Acciones.AbrirMovSC]
Nombre=AbrirMovSC
Boton=2
NombreDesplegar=&Abrir 
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=AsigAbrirMovSC<BR>FrmAbrirMovSC
Visible=S
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Ctrl+A
EnMenu=S
Activo=S
Antes=S
AntesExpresiones=//Limpiamos todas las variables antes de cargar el movimiento<BR>ASigna(Info.ID,nulo)<BR>Asigna(Info.Mov,nulo)<BR>Asigna(Info.Situacion,nulo)<BR>Asigna(Mavi.TipoCliente,nulo)<BR>Asigna(Info.Estatus,nulo)
[Acciones.AbrirMovDSC.AsigAbrirMovDSC]
Nombre=AsigAbrirMovDSC
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=Asigna(Info.ID,MaviServiCasaCredVis:ID)<BR> Asigna(Info.Mov,MaviServiCasaCredVis:Mov)<BR> Asigna(Info.Movid,MaviServiCasaCredVis:Movid)<BR> Asigna(Info.Situacion,MaviServiCasaCredVis:Situacion)<BR> Asigna(Mavi.TipoCliente,MaviServiCasaCredVis:MaviTipoVenta)<BR> Asigna(Info.Estatus,MaviServiCasaCredVis:Estatus)
[Acciones.AbrirMovDSC.FrmAbrirMovDSC]
Nombre=FrmAbrirMovDSC
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Asigna(Mavi.ServicasaModulo,3)<BR>Si sql(<T>select count(*) from MaviDM0112USCA where usuario = :tUsuario<T>, Usuario)=0<BR>    entonces<BR>        FormaPos(<T>Venta<T>,Vacio(Info.ID,0))<BR>        sql(<T>Exec sp_MaviDM0112BUSC :tUsuario<T>,Usuario)<BR>        sql(<T>Exec sp_MaviDM0112GUSC :tusu,:tmov,:tmovid,:nid <T>,usuario,MaviServiCasaCredVis:Mov,MaviServiCasaCredVis:Movid,MaviServiCasaCredVis:Id)<BR>    sino<BR>        Si sql(<T>select Folio from MaviDM0112usca where Usuario = :tUsuario <T>, Usuario)=(MaviServiCasaCredVis:Mov+<T> <T>+MaviServiCasaCredVis:Movid)<BR>            Entonces<BR>                FormaPos(<T>Venta<T>,Vacio(Info.ID,0))<BR>            Sino<BR>                Error(<T>Existe un Movimiento abierto por este Usuario<T>)<BR>                FormaPos(<T>Venta<T>,Vacio(I<CONTINUA>
Expresion002=<CONTINUA>nfo.ID,0))<BR>        Fin<BR>Fin
EjecucionCondicion=(sql(<T>Exec sp_MaviDM0112CUSC :tmov,:tmovid,:nid <T>,MaviServiCasaCredVis:Mov,MaviServiCasaCredVis:Movid,MaviServiCasaCredVis:Id) = <T>Disponible<T><BR>y Condatos(Info.ID))<BR>o (sql(<T>select Usuario from MaviDM0112usca where Mov = :tMov and MovID = :tMovid <T>, MaviServiCasaCredVis:Mov,MaviServiCasaCredVis:Movid)=Usuario)
EjecucionMensaje=<T>Movimiento ocupado por otro usuario<T>
[Acciones.AbrirMovDSC]
Nombre=AbrirMovDSC
Boton=0
NombreDesplegar=&Abrir
Multiple=S
EnMenu=S
ListaAccionesMultiples=AsigAbrirMovDSC<BR>FrmAbrirMovDSC
Visible=S
ConCondicion=S
EjecucionConError=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+A
Activo=S
EjecucionCondicion=Condatos(MaviServiCasaCredVis:Id)<BR>//Vacio(SQL(<T>Select IDMov from MaviAccessMovServicasaServicred where IDMov=:nval1<T>,MaviServiCasaCredVis:Id))
EjecucionMensaje=<T>Debe seleccionar un movimiento<T><BR>//Informacion(<T>Movimiento abierto por: <T>+NuevaLinea+NuevaLinea+<T>Usuario: <T>+SQL(<T>Select Usuario from MaviAccessMovServicasaServicred where IDMov=:nval1<T>,MaviServiCasaCredVis:Id))
[Acciones.InfoCteSC.AsigInfoCteSC]
Nombre=AsigInfoCteSC
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Asigna(Info.Cliente,MaviServiCasaCredVis:CLIENTE)
EjecucionCondicion=Condatos(MaviServiCasaCredVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
[Acciones.InfoCteSC.FrmInfoCteSC]
Nombre=FrmInfoCteSC
Boton=0
TipoAccion=formas
ClaveAccion=CteInfo
Activo=S
Visible=S
[Acciones.InfoCteSC]
Nombre=InfoCteSC
Boton=34
NombreDesplegar=&Información del Cliente 
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=AsigInfoCteSC<BR>FrmInfoCteSC
Activo=S
Visible=S
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=Ctrl+I
EnMenu=S
Antes=S
AntesExpresiones=Asigna(Info.Cliente,Nulo)
[Acciones.InfoCteDSC.AsigInfoCteDSC]
Nombre=AsigInfoCteDSC
Boton=0
TipoAccion=expresion
Expresion=Asigna(Info.Cliente,MaviServiCasaCredVis:CLIENTE)
Activo=S
Visible=S
[Acciones.InfoCteDSC.FrmInfoCteDSC]
Nombre=FrmInfoCteDSC
Boton=0
TipoAccion=formas
ClaveAccion=CteInfo
Activo=S
Visible=S
[Acciones.InfoCteDSC]
Nombre=InfoCteDSC
Boton=0
NombreDesplegar=&Información del Cliente
Multiple=S
EnMenu=S
ListaAccionesMultiples=AsigInfoCteDSC<BR>FrmInfoCteDSC
Activo=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+I
ConCondicion=S
EjecucionCondicion=Condatos(MaviServiCasaCredVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
EjecucionConError=S
Antes=S
AntesExpresiones=Asigna(Info.Cliente,nulo)
[Acciones.CteCtoSC.AsigCteCtoSC]
Nombre=AsigCteCtoSC
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Asigna(Info.Cliente,MaviServiCasaCredVis:CLIENTE)<BR>Asigna(Info.ClienteD,MaviServiCasaCredVis:Cliente)
EjecucionCondicion=Condatos(MaviServiCasaCredVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
[Acciones.CteCtoSC.FrmCteCtoSC]
Nombre=FrmCteCtoSC
Boton=0
TipoAccion=formas
ClaveAccion=MaviServicasaCteCtoFrm
Activo=S
Visible=S
[Acciones.CteCtoSC]
Nombre=CteCtoSC
Boton=60
NombreDesplegar=&Contactos
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=AsigCteCtoSC<BR>FrmCteCtoSC
Activo=S
Visible=S
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=Ctrl+C
EnMenu=S
Antes=S
AntesExpresiones=Asigna(Info.Cliente,Nulo)
[Acciones.CteCtoDSC.AsigCteCtoDSC]
Nombre=AsigCteCtoDSC
Boton=0
TipoAccion=expresion
Expresion=Asigna(Info.Cliente,MaviServiCasaCredVis:CLIENTE)
Activo=S
Visible=S
[Acciones.CteCtoDSC.FrmCteCtoDSC]
Nombre=FrmCteCtoDSC
Boton=0
TipoAccion=Formas
ClaveAccion=MaviServicasaCteCtoFrm
Activo=S
Visible=S
[Acciones.CteCtoDSC]
Nombre=CteCtoDSC
Boton=0
NombreDesplegar=&Contactos
Multiple=S
EnMenu=S
ListaAccionesMultiples=AsigCteCtoDSC<BR>FrmCteCtoDSC
Activo=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+Q
ConCondicion=S
EjecucionConError=S
Antes=S
EjecucionCondicion=Condatos(MaviServiCasaCredVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
AntesExpresiones=Asigna(Info.Cliente,nulo)
[Acciones.MovPosSC]
Nombre=MovPosSC
Boton=24
NombreDesplegar=Po&sicion Mov
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=AsigMovPosSC<BR>FrmMovPosSC
Menu=&Ver
UsaTeclaRapida=S
EnMenu=S
TeclaRapida=Ctrl+S
ConCondicion=S
EjecucionConError=S
Antes=S
EjecucionCondicion=Condatos(MaviServiCasaCredVis:Id)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
AntesExpresiones=Asigna(Info.ID,nulo)<BR>Asigna(Info.Modulo,nulo)
[Acciones.MovPosSC.AsigMovPosSC]
Nombre=AsigMovPosSC
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=Asigna(Info.ID,MaviServiCasaCredVis:ID)<BR>Asigna(Info.Modulo,<T>VTAS<T>)
[Acciones.MovPosSC.FrmMovPosSC]
Nombre=FrmMovPosSC
Boton=0
TipoAccion=formas
ClaveAccion=movpos
Activo=S
Visible=S
[Acciones.MovPosDSC.AsigMovPosDSC]
Nombre=AsigMovPosDSC
Boton=0
TipoAccion=expresion
Expresion=Asigna(Info.ID, MaviServiCasaCredVis:ID)<BR>Asigna(Info.Modulo,<T>VTAS<T>)
Activo=S
Visible=S
[Acciones.MovPosDSC.FrmMovPosDSC]
Nombre=FrmMovPosDSC
Boton=0
TipoAccion=formas
ClaveAccion=MovPos
Activo=S
Visible=S
[Acciones.MovPosDSC]
Nombre=MovPosDSC
Boton=0
NombreDesplegar=Po&sicion Mov
Multiple=S
EnMenu=S
ListaAccionesMultiples=AsigMovPosDSC<BR>FrmMovPosDSC
Activo=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+S
ConCondicion=S
EjecucionCondicion=Condatos(MaviServiCasaCredVis:Id)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
EjecucionConError=S
Antes=S
AntesExpresiones=Asigna(Info.ID,nulo)
[Acciones.MovBitacoraSC.AsigMovBitacoraSC]
Nombre=AsigMovBitacoraSC
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Asigna(Info.Modulo, <T>VTAS<T>)<BR>Asigna(Info.ID, MaviServiCasaCredVis:ID)
EjecucionCondicion=Condatos(MaviServiCasaCredVis:Id)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
[Acciones.MovBitacoraSC.FrmMovBitacoraSC]
Nombre=FrmMovBitacoraSC
Boton=0
TipoAccion=formas
ClaveAccion=MovBitacora
Activo=S
Visible=S
[Acciones.MovBitacoraSC]
Nombre=MovBitacoraSC
Boton=38
NombreDesplegar=&Bitacora
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=AsigMovBitacoraSC<BR>FrmMovBitacoraSC
Activo=S
Visible=S
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=Ctrl+B
EnMenu=S
Antes=S
AntesExpresiones=Asigna(Info.Modulo,nulo)<BR>Asigna(Info.ID,nulo)
[Acciones.MovBitacoraDCS.AsigMovBitacoraDSC]
Nombre=AsigMovBitacoraDSC
Boton=0
TipoAccion=expresion
Expresion=Asigna(Info.Modulo, <T>VTAS<T>)<BR>Asigna(Info.ID,MaviServiCasaCredVis:ID)
Activo=S
Visible=S
[Acciones.MovBitacoraDCS.FrmMovBitacoraDSC]
Nombre=FrmMovBitacoraDSC
Boton=0
TipoAccion=formas
ClaveAccion=MovBitacora
Activo=S
Visible=S
[Acciones.MovBitacoraDCS]
Nombre=MovBitacoraDCS
Boton=0
NombreDesplegar=&Bitacora
Multiple=S
EnMenu=S
ListaAccionesMultiples=AsigMovBitacoraDSC<BR>FrmMovBitacoraDSC
Activo=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+B
ConCondicion=S
EjecucionCondicion=Condatos(MaviServiCasaCredVis:Id)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
EjecucionConError=S
Antes=S
AntesExpresiones=Asigna(Info.ID,nulo)
[Acciones.MovTiempo.AsigMovTiempoSC]
Nombre=AsigMovTiempoSC
Boton=0
Activo=S
Visible=S
[Acciones.MovTiempoSC.AsigMovTiempoSC]
Nombre=AsigMovTiempoSC
Boton=0
TipoAccion=expresion
Expresion=Asigna(Info.Modulo, <T>VTAS<T>)<BR>Asigna(Info.ID, MaviServiCasaCredVis:ID)<BR>Asigna(Info.Mov,MaviServiCasaCredVis:Mov)<BR>Asigna(Info.MovID,MaviServiCasaCredVis:MovID)
[Acciones.MovTiempoSC]
Nombre=MovTiempoSC
Boton=15
NombreDesplegar=&Tiempo
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=AsigMovTiempoSC<BR>FrmMovTiempoSC
Activo=S
Visible=S
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=Ctrl+T
EnMenu=S
ConCondicion=S
EjecucionConError=S
Antes=S
EjecucionCondicion=Condatos(MaviServiCasaCredVis:Id)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
AntesExpresiones=Asigna(Info.Modulo,nulo)<BR>Asigna(Info.ID, nulo)<BR>Asigna(Info.Mov,nulo)<BR>Asigna(Info.MovID,nulo)
[Acciones.MovTiempoSC.FrmMovTiempoSC]
Nombre=FrmMovTiempoSC
Boton=0
TipoAccion=formas
ClaveAccion=VerMovTiempo
Activo=S
Visible=S
[Acciones.MovTiempoDSC.AsigMovTiempoDSC]
Nombre=AsigMovTiempoDSC
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Modulo, <T>VTAS<T>)<BR>Asigna(Info.ID, MaviServiCasaCredVis:ID)<BR>Asigna(Info.Mov,MaviServiCasaCredVis:Mov)<BR>Asigna(Info.MovID,MaviServiCasaCredVis:MovID)
[Acciones.MovTiempoDSC.FrmMovTiempoDSC]
Nombre=FrmMovTiempoDSC
Boton=0
TipoAccion=formas
ClaveAccion=VerMovTiempo
Activo=S
Visible=S
[Acciones.MovTiempoDSC]
Nombre=MovTiempoDSC
Boton=0
NombreDesplegar=&Tiempo
Multiple=S
EnMenu=S
ListaAccionesMultiples=AsigMovTiempoDSC<BR>FrmMovTiempoDSC
Activo=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+T
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Condatos(MaviServiCasaCredVis:Id)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
[Acciones.AgregarEvento.AsigAgregarEventoSC]
Nombre=AsigAgregarEventoSC
Boton=0
TipoAccion=expresion
Expresion=Asigna(Info.Mov, MaviServiCasaCredVis:Mov)<BR>Asigna(Info.MovID,MaviServiCasaCredVis:MovID)
Activo=S
Visible=S
[Acciones.AgregarEvento.FrmAgregarEventoSC]
Nombre=FrmAgregarEventoSC
Boton=0
TipoAccion=formas
ClaveAccion=MovBitacoraAgregar
Activo=S
Visible=S
[Acciones.AgregarEventoDSC]
Nombre=AgregarEventoDSC
Boton=0
EnMenu=S
Visible=S
Multiple=S
ListaAccionesMultiples=AsigAgregarEventoDSC<BR>FrmAgregarEventoDSC
NombreDesplegar=Agregar &Evento
Antes=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+E
Activo=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Condatos(MaviServiCasaCredVis:Id)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
AntesExpresiones=Asigna(Info.Mov,nulo)<BR>Asigna(Info.MovID,nulo)<BR>Asigna(Info.ID,nulo)<BR>Asigna(Info.Modulo,nulo)
[Acciones.AgregarEventoSC]
Nombre=AgregarEventoSC
Boton=17
NombreDesplegar=Agregar Evento
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=AsigAgregarEventoSC<BR>FrmAgregarEventoSC
Visible=S
Menu=&Edicion
UsaTeclaRapida=S
TeclaRapida=F6
EnMenu=S
Antes=S
ConCondicion=S
EjecucionConError=S
Activo=S
EjecucionCondicion=Condatos(MaviServiCasaCredVis:Id)<BR><BR>//Asigna(Mavi.ServicasaConfigUsr1,(SQL(<T>SELECT ACCESO FROM USUARIO WHERE USUARIO=:tval1<T>,usuario)))<BR>//Asigna(Mavi.ServicasaGrupoCalif,(SQL(<T>EXEC SP_MAVIULTIMACALIFICACION :nval1,:tval2<T>,MaviServiCasaCredVis:Id,<T>Vtas<T>)))<BR>//((MaviServiCasaCredVis:Estatus<>EstatusCancelado) y ((Mavi.ServicasaConfigUsr1=<T>CREDI_GERA<T>) o (Mavi.ServicasaConfigUsr1=<T>CREDI_GERB<T>) o (Mavi.ServicasaConfigUsr1=<T>CREDI_USRA<T>) o (Mavi.ServicasaConfigUsr1=<T>COBMA_GERA<T>) o (Mavi.ServicasaConfigUsr1=<T>COBMA_USRA<T>) o (Mavi.ServicasaConfigUsr1=<T>VENTC_USRA<T>) o (Mavi.ServicasaConfigUsr1 =<T>MAVI<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTR_GERA<T>) y (Mavi.ServicasaGrupoCalif=<T>D<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTP_GERA<T>) y (Mavi.ServicasaGrupoCalif=<T>C<T>)) o ((Mavi.ServicasaConfigUs<CONTINUA>
EjecucionCondicion002=<CONTINUA>r1=<T>VENTP_SUPA<T>) y (Mavi.ServicasaGrupoCalif=<T>C<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTI_GERA<T>) y (Mavi.ServicasaGrupoCalif=<T>C<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTC_GERA<T>) y (Mavi.ServicasaGrupoCalif=<T>C<T>)))
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
AntesExpresiones=Asigna(Info.Mov,nulo)<BR>Asigna(Info.MovID,nulo)<BR>Asigna(Info.ID,nulo)<BR>Asigna(Info.Modulo,nulo)
[Acciones.AgregarEventoDSC.AsigAgregarEventoDSC]
Nombre=AsigAgregarEventoDSC
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Asigna(Info.Mov,MaviServiCasaCredVis:Mov)<BR>Asigna(Info.MovID,MaviServiCasaCredVis:MovID)<BR>Asigna(Info.ID,MaviServiCasaCredVis:ID)<BR>Asigna(Info.Modulo,<T>VTAS<T>)
EjecucionCondicion=Asigna(Mavi.ServicasaConfigUsr1,SQL(<T>SELECT ACCESO FROM USUARIO WHERE USUARIO=:tval1<T>,Usuario))<BR>Asigna(Mavi.ServicasaGrupoCalif,(SQL(<T>EXEC SP_MAVIULTIMACALIFICACION :nval1,:tval2<T>,MaviServiCasaCredVis:Id,<T>Vtas<T>)))<BR>((MaviServiCasaCredVis:Estatus<>EstatusCancelado) y ((Mavi.ServicasaConfigUsr1=<T>CREDI_GERA<T>) o (Mavi.ServicasaConfigUsr1=<T>CREDI_GERB<T>) o (Mavi.ServicasaConfigUsr1=<T>CREDI_USRA<T>) o (Mavi.ServicasaConfigUsr1=<T>COBMA_GERA<T>) o (Mavi.ServicasaConfigUsr1=<T>COBMA_USRA<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTR_GERA<T>) y (Mavi.ServicasaGrupoCalif=<T>D<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTP_GERA<T>) y (Mavi.ServicasaGrupoCalif=<T>C<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTP_SUPA<T>) y (Mavi.ServicasaGrupoCalif=<T>C<T>)) o ((Mavi.ServicasaConfigUsr1=<T<CONTINUA>
EjecucionCondicion002=<CONTINUA>>VENTP_GECO<T>) y (Mavi.ServicasaGrupoCalif=<T>C<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTI_GERA<T>) y (Mavi.ServicasaGrupoCalif=<T>C<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTC_GERA<T>) y (Mavi.ServicasaGrupoCalif=<T>C<T>)) o (Mavi.ServicasaConfigUsr1=<T>VENTC_USRA<T>) o (Mavi.ServicasaConfigUsr1 =<T>MAVI<T>) o (Mavi.ServicasaConfigUsr1 en (<T>COBMA_GERA<T>,<T>COBMA_USRA<T>))))
EjecucionMensaje=<T>El estado actual del movimiento o los permisos de usuario <T>+nuevalinea+<T>no permiten agregar un evento, por favor verifique..<T>
[Acciones.AgregarEventoDSC.FrmAgregarEventoDSC]
Nombre=FrmAgregarEventoDSCegarEventoDSC]
Nombre=FrmAgregarEventoDSC
Boton=0
TipoAccion=formas
ClaveAccion=MovBitacoraAgregar
Activo=S
Visible=S
[Acciones.AgregarEventoSC.FrmAgregarEventoSC]
Nombre=FrmAgregarEventoSC
Boton=0
TipoAccion=Formas
ClaveAccion=MovBitacoraAgregar
[Acciones.AgregarEventoSC.AsigAgregarEventoSC]
Nombre=AsigAgregarEventoSC
Boton=0
TipoAccion=expresion
ConCondicion=S
EjecucionConError=S
Expresion=Asigna(Info.Mov,MaviServiCasaCredVis:Mov)<BR>Asigna(Info.MovID,MaviServiCasaCredVis:MovID)<BR>Asigna(Info.ID,MaviServiCasaCredVis:ID)<BR>Asigna(Info.Modulo,<T>VTAS<T>)
EjecucionCondicion=1=1<BR>/*Asigna(Mavi.ServicasaConfigUsr1,(SQL(<T>SELECT ACCESO FROM USUARIO WHERE USUARIO=:tval1<T>,usuario)))<BR>Asigna(Mavi.ServicasaGrupoCalif,(SQL(<T>EXEC SP_MAVIULTIMACALIFICACION :nval1,:tval2<T>,MaviServiCasaCredVis:Id,<T>Vtas<T>)))<BR>((MaviServiCasaCredVis:Estatus<>EstatusCancelado) y ((Mavi.ServicasaConfigUsr1=<T>CREDI_GERA<T>) o (Mavi.ServicasaConfigUsr1=<T>CREDI_GERB<T>) o (Mavi.ServicasaConfigUsr1=<T>CREDI_USRA<T>) o (Mavi.ServicasaConfigUsr1=<T>COBMA_GERA<T>) o (Mavi.ServicasaConfigUsr1=<T>COBMA_USRA<T>) o (Mavi.ServicasaConfigUsr1=<T>VENTC_USRA<T>) o (Mavi.ServicasaConfigUsr1 =<T>MAVI<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTR_GERA<T>) y (Mavi.ServicasaGrupoCalif=<T>D<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTP_GERA<T>) y (Mavi.ServicasaGrupoCalif=<T>C<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTP_SUPA<T>) y (Mavi.Servicasa<CONTINUA>
EjecucionCondicion002=<CONTINUA>GrupoCalif=<T>C<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTI_GERA<T>) y (Mavi.ServicasaGrupoCalif=<T>C<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTC_GERA<T>) y (Mavi.ServicasaGrupoCalif=<T>C<T>)))<BR>*/
EjecucionMensaje=<T>El estado actual del movimiento o los permisos de usuario <T>+nuevalinea+<T>no permiten agregar un evento, por favor verifique..<T>
[Acciones.RelacionCteSC.AsigRelacionCteSC]
Nombre=AsigRelacionCteSC
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Cliente,MaviServiCasaCredVis:CLIENTE)<BR>Asigna(Info.ClienteD,MaviServiCasaCredVis:Cliente)
[Acciones.RelacionCteSC.FrmRelacionCteSC]
Nombre=FrmRelacionCteSC
Boton=0
TipoAccion=Formas
ClaveAccion=CteRelacion
Activo=S
Visible=S
[Acciones.RelacionCteSC]
Nombre=RelacionCteSC
Boton=90
NombreDesplegar=&Relaciones
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=AsigRelacionCteSC<BR>FrmRelacionCteSC
Activo=S
Visible=S
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=Ctrl+R
EnMenu=S
ConCondicion=S
EjecucionConError=S
Antes=S
EjecucionCondicion=Condatos(MaviServiCasaCredVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
AntesExpresiones=Asigna(Info.Cliente,nulo)
[Acciones.RelacionCteDSC.AsigRelacionCteDSC]
Nombre=AsigRelacionCteDSC
Boton=0
TipoAccion=expresion
Expresion=Asigna(Info.Cliente,MaviServiCasaCredVis:CLIENTE)
Activo=S
Visible=S
[Acciones.RelacionCteDSC.FrmRelacionCteDSC]
Nombre=FrmRelacionCteDSC
Boton=0
TipoAccion=formas
ClaveAccion=CteRelacion
Activo=S
Visible=S
[Acciones.RelacionCteDSC]
Nombre=RelacionCteDSC
Boton=0
NombreDesplegar=&Relaciones
Multiple=S
EnMenu=S
ListaAccionesMultiples=AsigRelacionCteDSC<BR>FrmRelacionCteDSC
Activo=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+R
ConCondicion=S
EjecucionCondicion=Condatos(MaviServiCasaCredVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
EjecucionConError=S
Antes=S
AntesExpresiones=Asigna(Info.Cliente,nulo)

[Acciones.ActualizarSC]
Nombre=ActualizarSC
Boton=82
NombreDesplegar=Actualizar
EnBarraHerramientas=S
TipoAccion=expresion
Activo=S
Visible=S
Menu=&Exploradores
EnMenu=S
UsaTeclaRapida=S
TeclaRapida=F5
Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>expresion

[Acciones.PersonalizarSC]
Nombre=PersonalizarSC
Boton=45
NombreDesplegar=Personalizar Vista
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Mostrar Campos
Activo=S
Menu=&Exploradores
EnMenu=S
VisibleCondicion=Asigna(Mavi.ServicasaConfigUsr1,SQL(<T>SELECT ACCESO FROM USUARIO WHERE USUARIO=:tval1<T>,Usuario))<BR>Mavi.ServicasaConfigUsr1 =<T>MAVI<T>

[Acciones.PersonalizarDSC]
Nombre=PersonalizarDSC
Boton=0
NombreDesplegar=Pesonalizar Vista
EnMenu=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Mostrar Campos
Activo=S
VisibleCondicion=Asigna(Mavi.ServicasaConfigUsr1,SQL(<T>SELECT ACCESO FROM USUARIO WHERE USUARIO=:tval1<T>,Usuario))<BR>Mavi.ServicasaConfigUsr1 =<T>MAVI<T>
[Detalle.CALIFICACION]
Carpeta=Detalle
Clave=CALIFICACION
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco
ColorFuente=Negro
[Servicasa.]
Carpeta=Servicasa
ColorFondo=Negro
[Detalle.USUARIO]
Carpeta=Detalle
Clave=USUARIO
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[AvanceCohincidencias.USUARIO]
Carpeta=AvanceCohincidencias
Clave=USUARIO
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=111
ColorFondo=Blanco
ColorFuente=Negro
[AvanceCohincidencias.Columnas]
0=188
1=279
[Acciones.Kardex]
Nombre=Kardex
Boton=0
NombreEnBoton=S
Menu=&Reportes
UsaTeclaRapida=S
TeclaRapida=F11
NombreDesplegar=<T>RM855 Kardex por Cliente<T>
EnMenu=S
TipoAccion=expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Antes=S
Expresion=Ejecutar(<T>PlugIns\KardexXCliente.exe <T>+Usuario+<T> <T>+EstacionTrabajo+<T> <T>+MaviServiCasaCredVis:Cliente+<T> <T>+MaviServiCasaCredVis:ID_Direccionado )
EjecucionCondicion=Condatos(MaviServiCasaCredVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
AntesExpresiones=Asigna(Info.Cliente,nulo)<BR>Asigna(Info.Numero,0)
[Acciones.Cohincidencias.FormaInicial]
Nombre=FormaInicial
Boton=0
TipoAccion=Expresion
Expresion=Forma(<T>EspecificarClienteMAVI<T>)
Activo=S
Visible=S
[Acciones.Coincidencias]
Nombre=Coincidencias
Boton=80
NombreDesplegar=<T>C&oincidencias<T>
EnBarraHerramientas=S
TipoAccion=Formas
Activo=S
Visible=S
ClaveAccion=EspecificarClienteMAVI
Multiple=S
ListaAccionesMultiples=AsignaValorCoin<BR>LlamaCoincidencias
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=Ctrl+O
EnMenu=S
Antes=S
AntesExpresiones=Asigna(Info.ClienteD,Nulo)
[Acciones.Kardex.AsignaVal]
Nombre=AsignaVal
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.cliente,MaviServiCasaCredVis:CLIENTE)<BR>Asigna(Info.ClienteD,MaviServiCasaCredVis:Cliente)<BR>Asigna(Info.ID,MaviServiCasaCredVis:ID_Direccionado)
[Acciones.Coincidencias.AsignaValorCoin]
Nombre=AsignaValorCoin
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Asigna(Info.ClienteD,MaviServiCasaCredVis:CLIENTE)<BR>Asigna(Info.Cliente,MaviServiCasaCredVis:Cliente)
EjecucionCondicion=Condatos(MaviServiCasaCredVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
[Acciones.Coincidencias.LlamaCoincidencias]
Nombre=LlamaCoincidencias
Boton=0
TipoAccion=Formas
ClaveAccion=CteRelacionMavi
Activo=S
Visible=S
[Acciones.RecomendadosServicasaSC]
Nombre=RecomendadosServicasaSC
Boton=74
NombreDesplegar=&Recomendados
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=MaviServicasaRecomendadosFrm
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=AsignaCteRecomenSC<BR>FormaRecomenSC
Menu=&Ver
EnMenu=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+R
ConCondicion=S
EjecucionConError=S
Antes=S
EjecucionCondicion=Condatos(MaviServiCasaCredVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
AntesExpresiones=Asigna(Info.Cliente,nulo)
[Acciones.RecomendadosServicasaSC.AsignaCteRecomenSC]
Nombre=AsignaCteRecomenSC
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Info.Cliente,MaviServiCasaCredVis:CLIENTE)
Activo=S
Visible=S
[Acciones.RecomendadosServicasaSC.FormaRecomenSC]
Nombre=FormaRecomenSC
Boton=0
TipoAccion=Formas
ClaveAccion=MaviServicasaRecomendadosFrm
Activo=S
Visible=S
[Acciones.PreguntasSeguridadSC.Expresiones]
Nombre=Expresiones
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Cliente,MaviServiCasaCredVis:CLIENTE)<BR>Asigna(Info.Sucursal,MaviServiCasaCredVis:SUCURSAL)<BR>Asigna(Info.Fecha,MaviServiCasaCredVis:FECHAREGISTRO)
[Acciones.RegistrCteSC.AsignaRegistroSC]
Nombre=AsignaRegistroSC
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Cliente,MaviServiCasaCredVis:CLIENTE)<BR>Asigna(Info.Fecha,MaviServiCasaCredVis:FECHAREGISTRO)<BR>Asigna(Info.Sucursal,MaviServiCasaCredVis:SUCURSAL)
[Acciones.PreguntasSeguridadSC.FormaPreguntasSC]
Nombre=FormaPreguntasSC
Boton=0
TipoAccion=Formas
ClaveAccion=MaviServicasaPreguntasSeguridadCteFrm
Activo=S
Visible=S
[Acciones.ReporteAnuelesSC]
Nombre=ReporteAnuelesSC
Boton=0
Menu=&Reportes
NombreDesplegar=RM0301 Servicasa - Anuales
TipoAccion=Reportes Pantalla
ClaveAccion=MaviServCasaAnuaRep
Activo=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=F12
Multiple=S
ListaAccionesMultiples=FormaAnualSC
Antes=S
EnMenu=S
AntesExpresiones=Asigna(Info.cliente,MaviServiCasaCredVis:Cliente)
[Acciones.ReporteAnuelesSC.FormaAnualSC]
Nombre=FormaAnualSC
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=RM0301ServCasaAnuaRep
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Condatos(MaviServiCasaCredVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
[Acciones.ReporteHistorialCteSC.AsignaCteHist]
Nombre=AsignaCteHist
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Info.Cliente,MaviServiCasaCredVis:CLIENTE)
Activo=S
Visible=S
[Acciones.ReporteHistorialCteSC.FormaHistorCte]
Nombre=FormaHistorCte
Boton=0
TipoAccion=Formas
ClaveAccion=MaviServiCasaCredHistoricoSolicitudesFrm
Activo=S
Visible=S
[Detalle.Observaciones]
Carpeta=Detalle
Clave=Observaciones
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.HistoricoSolicitudes.AsgnaCteHS]
Nombre=AsgnaCteHS
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Cliente,MaviServiCasaCredVis:Cliente)<BR>Asigna(Mavi.TipoCliente,MaviServiCasaCredVis:MaviTipoVenta)
[Acciones.HistoricoSolicitudes.FormaHS]
Nombre=FormaHS
Boton=0
TipoAccion=Formas
ClaveAccion=MaviServiCasaCredHistoricoSolicitudesFrm
Activo=S
Visible=S
[Acciones.HistoricoSolicitudes]
Nombre=HistoricoSolicitudes
Boton=0
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=F3
NombreDesplegar=Historial Solicitudes
Multiple=S
EnMenu=S
ListaAccionesMultiples=AsgnaCteHS<BR>FormaHS
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Antes=S
EjecucionCondicion=Condatos(MaviServiCasaCredVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
AntesExpresiones=Asigna(Info.Cliente,nulo)  <BR>Asigna(Mavi.TipoCliente,nulo)
[Acciones.Cerrar]
Nombre=Cerrar
Boton=0
NombreEnBoton=S
Menu=&Exploradores
NombreDesplegar=Cerrar
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
EnMenu=S

;[Acciones.CalificacionesSC]
;Nombre=CalificacionesSC
;Boton=41
;NombreEnBoton=S
;NombreDesplegar=<T>Calificaciones<T>
;Multiple=S
;EnBarraHerramientas=S
;Activo=S
;Visible=S


[Acciones.CalificacionesSC.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


[Acciones.CalificacionesSC.Calificacion.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Expresion=EjecutarSQL(<T>spCalificaCtesxFacturaMAVI  :tCte<T>,Info.Cliente)
Activo=S
Visible=S

[Acciones.CalificacionesSC.Calificacion.Explorador]
Nombre=Explorador
Boton=0
TipoAccion=Formas
ClaveAccion=MAVIExploradorCalificacion
Activo=S
Visible=S

[Acciones.Calificacion.ExpresionCalif]
Nombre=ExpresionCalif
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Info.Cliente,MaviServiCasaCredVis:Cliente)<BR>EjecutarSQL(<T>spCalificaCtesxFacturaMAVI  :tCte<T>,Info.Cliente)
[Acciones.Calificacion.Variables AsignarCalif]
Nombre=Variables AsignarCalif
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
[Acciones.Calificacion.ExploradorCalif]
Nombre=ExploradorCalif
Boton=0
TipoAccion=Formas
ClaveAccion=MAVIExploradorCalificacion
[Acciones.Kardex.FormaKCSC]
Nombre=FormaKCSC
Boton=0
TipoAccion=Formas
ClaveAccion=MaviServicasaCredKardexporClienteFrm
Activo=S
Visible=S
[Acciones.ReporteServicasa]
Nombre=ReporteServicasa
Boton=0
Menu=&Reportes
NombreDesplegar=RM0430 Reporte Servicasa
EnMenu=S
TipoAccion=Reportes Pantalla
ClaveAccion=RM0430MaviServicasaCredReporteServicasaRep
Activo=S
Visible=S
[Acciones.Nuevo.FormaPos]
Nombre=FormaPos
Boton=0
TipoAccion=Expresion
Expresion=Forma(<T>Venta<T>)
Activo=S
Visible=S
[Acciones.NuevoSC]
Nombre=NuevoSC
Boton=1
NombreDesplegar=&Nuevo
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Ctrl+N
Antes=S
RefrescarDespues=S
DocNuevo=S
Expresion=Asigna(Mavi.ServicasaCapDetallVentas,0)<BR>Asigna(Mavi.ServicasaMovNvo,1020)<BR>Forma(<T>Venta<T>)
AntesExpresiones=Asigna(Info.Modulo, <T>VTAS<T>)//Especificamos el modulo en cual estamos trabajando
[Acciones.NuevoDSC]
Nombre=NuevoDSC
Boton=0
NombreDesplegar=&Nuevo
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+N
Expresion=Asigna(Mavi.ServicasaCapDetallVentas,0)<BR>Asigna(Mavi.ServicasaMovNvo,1020)<BR>Forma(<T>Venta<T>)
[Servicasa.Reactivacion]
Carpeta=Servicasa
Clave=Reactivacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=12
ColorFondo=Blanco
ColorFuente=Negro
[Servicasa.Grupo]
Carpeta=Servicasa
Clave=Grupo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=2
ColorFondo=Blanco
ColorFuente=Negro
[Servicasa.Condicion]
Carpeta=Servicasa
Clave=Condicion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Servicasa.Situacion]
Carpeta=Servicasa
Clave=Situacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Servicasa.Estatus]
Carpeta=Servicasa
Clave=Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[Servicasa.Cliente]
Carpeta=Servicasa
Clave=Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Servicasa.Nombre]
Carpeta=Servicasa
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Servicasa.Relacionado]
Carpeta=Servicasa
Clave=Relacionado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Servicasa.Agente]
Carpeta=Servicasa
Clave=Agente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Servicasa.Calificacion]
Carpeta=Servicasa
Clave=Calificacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco
ColorFuente=Negro
[Servicasa.Fech. Alta. a Fech. Ult. Mod.]
Carpeta=Servicasa
Clave=Fech. Alta. a Fech. Ult. Mod.
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Servicasa.Fech. Ult. Mod. a Fech. Act.]
Carpeta=Servicasa
Clave=Fech. Ult. Mod. a Fech. Act.
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Servicasa.Observaciones]
Carpeta=Servicasa
Clave=Observaciones
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco
ColorFuente=Negro
[Servicasa.CANALVENTA]
Carpeta=Servicasa
Clave=CANALVENTA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Servicasa.SucursalOrigen]
Carpeta=Servicasa
Clave=SucursalOrigen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Servicasa.ReferenciaAnterior]
Carpeta=Servicasa
Clave=ReferenciaAnterior
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=82
ColorFondo=Blanco
ColorFuente=Negro
[Servicasa.ImporteTotal]
Carpeta=Servicasa
Clave=ImporteTotal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Totalizador=1
[Servicasa.FUM]
Carpeta=Servicasa
Clave=FUM
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=38
ColorFondo=Blanco
ColorFuente=Negro
[Servicasa.Seguimiento]
Carpeta=Servicasa
Clave=Seguimiento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.NotasCobranza]
Nombre=NotasCobranza
Boton=0
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=F8
NombreDesplegar=Notas Cobranza Telefónica
EnMenu=S
TipoAccion=Formas
ClaveAccion=MAviServicasaServicredCredNotasCobranzaFrm
Activo=S
Visible=S
Antes=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Condatos(MaviServiCasaCredVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
AntesExpresiones=Asigna(Info.cliente,MaviServiCasaCredVis:Cliente)
[Acciones.Registro]
Nombre=Registro
Boton=31
Menu=&Exploradores
UsaTeclaRapida=S
TeclaRapida=F4
NombreDesplegar=Registro Huellas
Multiple=S
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Formas
Activo=S
Visible=S
ListaAccionesMultiples=FormaRegistroSCC
Antes=S
AntesExpresiones=Asigna(Info.Cliente,MaviServiCasaCredVis:Cliente)
[Acciones.Registro.FormaRegistroSCC]
Nombre=FormaRegistroSCC
Boton=0
TipoAccion=Formas
ClaveAccion=ExpRegistroCte
Activo=S
Visible=S
[(Carpeta Totalizadores)]
Pestana=S
Clave=(Carpeta Totalizadores)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=C1
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
Totalizadores1=Importe Total<BR>Movimientos
Totalizadores2=Suma(MaviServiCasaCredVis:ImporteTotal)<BR>ConteoTotal(MaviServiCasaCredVis:Id)
Totalizadores=S
CampoColorLetras=Negro
CampoColorFondo=Negro
CarpetaVisible=S
Totalizadores3=(Monetario)
[Servicasa.%Supervision]
Carpeta=Servicasa
Clave=%Supervision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Acercade]
Nombre=Acercade
Boton=0
NombreDesplegar=Acerca de...
TipoAccion=Expresion
Activo=S
Visible=S
Menu=&Ayuda
EnMenu=S
Expresion=Vermensaje(<T>Acerca de Servicasa Crédito<T>,<T>Comercializadora de Muebles America S.A. de C.V.<T>+Nuevalinea+<T>______________________________________________________<T>+NuevaLinea+Nuevalinea+<T>                                         Servicasa Crédito<T>+Nuevalinea+Nuevalinea+<T>Versión: V.2010.06.15<T>+NuevaLinea+<T>Fecha de Versión: 15 de Junio de 2010<T>+NuevaLinea+Nuevalinea+<T>______________________________________________________<T>+NuevaLinea+Nuevalinea+Nuevalinea+<T>www.mueblesamerica.com.mx<T>+NuevaLinea+<T>www.viu.com.mx<T>+Nuevalinea+<T>www.mavi.mx<T>+NuevaLinea+Nuevalinea+NuevaLinea+<T>______________________________________________________<T>+Nuevalinea+Nuevalinea+<T>Copyright(c) 2010 Comercializadora de Muebles America S.A. de C.V.<T>+NuevaLinea+<T>Derechos Reservados<T>)
[Acciones.NotasAreaCobranza]
Nombre=NotasAreaCobranza
Boton=56
NombreDesplegar=Notas Cobranza
EnMenu=S
TipoAccion=Formas
ClaveAccion=CtaBitacora
Activo=S
Visible=S
NombreEnBoton=S
Menu=&Ver
Antes=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Condatos(MaviServiCasaCredVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
AntesExpresiones=Asigna(Info.Modulo, <T>CXC<T>)<BR>Asigna(Info.Tipo, SQL(<T>Select Tipo From Cte Where Cliente=:tval1<T>,MaviServiCasaCredVis:Cliente))<BR>Asigna(Info.Cuenta, MaviServiCasaCredVis:Cliente) <BR>Asigna(Info.Descripcion, MaviServiCasaCredVis:Nombre)<BR>Asigna(Info.PuedeEditar, Falso)
[SupervisionesContactos.Columnas]
0=251
1=70
2=-2
3=-2
4=-2
5=-2
[SupervisionesContactos.Supervision]
Carpeta=SupervisionesContactos
Clave=Supervision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=41
ColorFondo=Blanco
ColorFuente=Negro
[SupervisionesContactos.FechaRegistro]
Carpeta=SupervisionesContactos
Clave=FechaRegistro
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[SupervisionesContactos.Estatus]
Carpeta=SupervisionesContactos
Clave=Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir)]
Estilo=Iconos
Pestana=S
Clave=(Carpeta Abrir)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Vista=MaviServiCasaCredVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Movimiento<T>
ElementosPorPagina=10
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Condicion<BR>Situacion<BR>Estatus<BR>Cliente<BR>Nombre<BR>Relacionado<BR>Agente<BR>Calificacion<BR>Fech. Alta. a Fech. Ult. Mod.<BR>Fech. Ult. Mod. a Fech. Act.<BR>Observaciones
CarpetaVisible=S
IconosNombre=MaviServiCasaCredVis:Mov+<T> <T>+MaviServiCasaCredVis:Movid
IconosConPaginas=N
[(Carpeta Abrir).Condicion]
Carpeta=(Carpeta Abrir)
Clave=Condicion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).Situacion]
Carpeta=(Carpeta Abrir)
Clave=Situacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).Estatus]
Carpeta=(Carpeta Abrir)
Clave=Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).Cliente]
Carpeta=(Carpeta Abrir)
Clave=Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).Nombre]
Carpeta=(Carpeta Abrir)
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).Relacionado]
Carpeta=(Carpeta Abrir)
Clave=Relacionado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).Agente]
Carpeta=(Carpeta Abrir)
Clave=Agente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).Calificacion]
Carpeta=(Carpeta Abrir)
Clave=Calificacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).Fech. Alta. a Fech. Ult. Mod.]
Carpeta=(Carpeta Abrir)
Clave=Fech. Alta. a Fech. Ult. Mod.
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).Fech. Ult. Mod. a Fech. Act.]
Carpeta=(Carpeta Abrir)
Clave=Fech. Ult. Mod. a Fech. Act.
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).Observaciones]
Carpeta=(Carpeta Abrir)
Clave=Observaciones
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).Columnas]
0=-2
1=-2
2=-2
3=-2
4=-2
5=-2
6=-2
7=-2
8=-2
9=-2
10=-2
11=-2
[Acciones.ReporteRM0855A]
Nombre=ReporteRM0855A
Boton=0
Menu=&Reportes
NombreDesplegar=RM0855A &Formato de Cliente Express
TipoAccion=Reportes Pantalla
ClaveAccion=RM0855AHojaVerdeRep
Activo=S
Visible=S
EnMenu=S
Antes=S
AntesExpresiones=Asigna(Mavi.RM0855ACte,MaviServiCasaCredVis:Cliente)
[Acciones.ReporteServicred]
Nombre=ReporteServicred
Boton=0
Menu=&Reportes
NombreDesplegar=Reporte Servicred
TipoAccion=Reportes Pantalla
ClaveAccion=MaviServicredCredReporteServicredRep
Activo=S
Visible=S
EnMenu=S
[Servicasa.TiempoTotalTranscurrido]
Carpeta=Servicasa
Clave=TiempoTotalTranscurrido
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.ServicasaUnicaja.AsignaVal]
Nombre=AsignaVal
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Info.Cliente,MaviServiCasaCredVis:Cliente)
Activo=S
Visible=S
[Acciones.ServicasaUnicaja.LLamaVent]
Nombre=LLamaVent
Boton=0
TipoAccion=Formas
ClaveAccion=DM127ExplRechServicasaUnicajaFrm
Activo=S
Visible=S
[Acciones.ServicasaUnicajaSC]
Nombre=ServicasaUnicajaSC
Boton=79
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=Ctrl+U
NombreDesplegar=S&ervicasa Unicaja
Multiple=S
EnBarraHerramientas=S
EnMenu=S
ListaAccionesMultiples=AsignaVal<BR>LLamaVent
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=MaviServiCasaCredVis:Cliente <> nulo
EjecucionMensaje=<T>Debe Seleccionar un movimiento<T>
[Acciones.ExcelSC]
Nombre=ExcelSC
Boton=115
Menu=&Edicion
NombreDesplegar=<T>Excel<T>
EnBarraHerramientas=S
EnMenu=S
Carpeta=Servicasa
TipoAccion=Controles Captura
ClaveAccion=Enviar a Excel
Activo=S
Antes=S
AntesExpresiones=Asigna(Info.Mov,MaviServiCasaCredVis:Mov)<BR>Asigna(Info.Estado,MaviServiCasaCredVis:Estatus)<BR>Asigna(Info.abc,MaviServiCasaCredVis:SucursalOrigen)
Visible=S
[Acciones.ServicasaUnicajaSC.AsignaVal]
Nombre=AsignaVal
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Info.Cliente,MaviServiCasaCredVis:Cliente)
[Acciones.ServicasaUnicajaSC.LLamaVent]
Nombre=LLamaVent
Boton=0
TipoAccion=Formas
ClaveAccion=DM127ExplRechServicasaUnicajaFrm
[Acciones.HistoricoUnicajaSC]
Nombre=HistoricoUnicajaSC
Boton=48
Menu=&Ver
NombreDesplegar=Historico Unicaja
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Ejecutar(<T>PlugIns\Inte601\Inte601.exe <T>+MaviServiCasaCredVis:Cliente+<T> N<T>)
[Servicasa.SolRefinanciamiento]
Carpeta=Servicasa
Clave=SolRefinanciamiento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=2
ColorFondo=Blanco
ColorFuente=Negro
[Servicasa.FechaAlta]
Carpeta=Servicasa
Clave=FechaAlta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=38
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Consulta]
Nombre=Consulta
Boton=128
NombreDesplegar=Resumen Factura
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
NombreEnBoton=S
UsaTeclaRapida=S
TeclaRapida=F7
Expresion=Ejecutar(<T>PlugIns\Inte602.exe <T>+MaviServiCasaCredVis:Cliente+<T> <T>+Usuario+<T> N<T>)
[Acciones.ClienteF]
Nombre=Consulta
Boton=128
NombreDesplegar=Consulta Cte Final
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
NombreEnBoton=S
UsaTeclaRapida=S
TeclaRapida=F10
Expresion=Ejecutar(<T>PlugIns\Inte606.exe <T>+MaviServiCasaCredVis:Cliente+<T> <T>+Usuario+<T> N<T>)
[Acciones.copiar]
Nombre=copiar
Boton=54
NombreDesplegar=Copiar Cliente
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion<BR>Asigna(Mavi.NombreCliente,MaviServiCasaCredVis:Cliente)<BR>Ejecutar(<T>C:\Temp\Intelisis\Copiar.exe <T>+Mavi.NombreCliente)
[Acciones.CopiarDSC]
Nombre=CopiarDSC
Boton=0
UsaTeclaRapida=S
TeclaRapida=Ctrl+C
NombreDesplegar=Copiar Cliente
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion<BR>Asigna(Mavi.NombreCliente,MaviServiCasaCredVis:Cliente)<BR>Ejecutar(<T>C:\Temp\Intelisis\Copiar.exe <T>+Mavi.NombreCliente)

[Filtros]
Estilo=Ficha
Clave=Filtros
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.DM0112Mov<BR>Mavi.DM0112Situacion<BR>Mavi.DM0112Estatus<BR>Mavi.FechaI<BR>Mavi.FechaF<BR>Mavi.DM0112Busqueda<BR>Mavi.DM0112ComboBusqueda
CarpetaVisible=S
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
PermiteEditar=S

[Filtros.Columnas]
Mov=124
Situacion=304
Estatus=94
[Filtros.Mavi.DM0112Mov]
Carpeta=Filtros
Clave=Mavi.DM0112Mov
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Filtros.Mavi.DM0112Situacion]
Carpeta=Filtros
Clave=Mavi.DM0112Situacion
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Filtros.Mavi.DM0112Estatus]
Carpeta=Filtros
Clave=Mavi.DM0112Estatus
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Filtros.Mavi.FechaI]
Carpeta=Filtros
Clave=Mavi.FechaI
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Filtros.Mavi.FechaF]
Carpeta=Filtros
Clave=Mavi.FechaF
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.ActualizarSC.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.ActualizarSC.expresion]
Nombre=expresion
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=//ActualizarVista(<T>MaviServiCasaCredVis<T>)<BR>ActualizarVista(<T>Filtros<T>)
[Filtros.Mavi.DM0112Busqueda]
Carpeta=Filtros
Clave=Mavi.DM0112Busqueda
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.CitaSup]
Nombre=CitaSup
Boton=0
UsaTeclaRapida=S
TeclaRapida=Ctrl+P
NombreDesplegar=Ver Cita Supervisión
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asigna<BR>Forma
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Condatos(MaviServiCasaCredVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
[Acciones.CitaSup.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.ID,MaviServiCasaCredVis:Id)<BR>/*SQL(<T>Select ID From Venta Where Mov = :tMov and MovID = :tMoID<T>, CampoEnTexto(MaviServiCasaCredVis:MovOrigen), CampoEnTexto(MaviServiCasaCredVis:IDMovOrigen))*/
ConCondicion=S
EjecucionCondicion=condatos(MaviServiCasaCredVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
EjecucionConError=S
[Acciones.CitaSup.Forma]
Nombre=Forma
Boton=0
TipoAccion=Formas
ClaveAccion=DM0112CitaSupervisionFrm
Activo=S
Visible=S
[Sucursal]
Estilo=Ficha
Clave=Sucursal
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A2
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.Sucursal
CondicionVisible=1=2
[Sucursal.Mavi.Sucursal]
Carpeta=Sucursal
Clave=Mavi.Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Filtros.Mavi.DM0112ComboBusqueda]
Carpeta=Filtros
Clave=Mavi.DM0112ComboBusqueda
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Tiempo Total.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.ID, MaviServiCasaCredVis:ID)<BR>Asigna(Info.Mov,MaviServiCasaCredVis:Mov)
[Acciones.Tiempo Total]
Nombre=Tiempo Total
Boton=0
UsaTeclaRapida=S
TeclaRapida=Ctrl+M
NombreDesplegar=Tiempo Total
Multiple=S
EnMenu=S
ListaAccionesMultiples=Asigna<BR>Forma
Activo=S
Visible=S
[Acciones.Tiempo Total.Forma]
Nombre=Forma
Boton=0
TipoAccion=Formas
ClaveAccion=DM0112MaviServicasacredTiempoSolFRM
Activo=S
Visible=S
[Acciones.Monedero]
Nombre=Monedero
Boton=0
UsaTeclaRapida=S
TeclaRapida=Ctrl+D
NombreDesplegar=Monedero por Redimir
EnMenu=S
Visible=S
Activo=S
Multiple=S
ListaAccionesMultiples=Asigna<BR>FRM
[Servicasa.Monedero]
Carpeta=Servicasa
Clave=Monedero
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Monedero.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.ID,MaviServiCasaCredVis:Id)
[Acciones.Monedero.FRM]
Nombre=FRM
Boton=0
TipoAccion=Formas
ClaveAccion=DM0112MonederoRemidirVisFRM
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=SI (SQL(<T>SELECT Redimeptos FROM venta WHERE ID = :nID <T>,Info.Id))=0<BR>ENTONCES      <BR>    ERROR(<T>Sin Informacion en Monedero<T>)<BR>SINO<BR>    VERDADERO<BR>FIN
[Acciones.HojaV]
Nombre=HojaV
Boton=0
UsaTeclaRapida=S
TeclaRapida=Ctrl+J
NombreDesplegar=&Ver Actualizacion de Datos
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
Expresion=SI MaviServiCasaCredVis:Mov en (<T>Solicitud Credito<T>,<T>Analisis Credito<T>,<T>Pedido<T>)<BR>ENTONCES<BR>        Ejecutar(<T>PlugIns\SHM\SHM.exe MOSTRARHOJAVERDE <T>+MaviServiCasaCredVis:Cliente)<BR>    Fin<BR>SINO                   <BR>    Verdadero<BR>FIN
EjecucionCondicion=MaviServiCasaCredVis:Estatus noen (EstatusSinAfectar)
[Servicasa.EstatusConvenio]
Carpeta=Servicasa
Clave=EstatusConvenio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.ctefinal]
Nombre=ctefinal
Boton=0
UsaTeclaRapida=S
TeclaRapida=Ctrl+K
NombreDesplegar=&Kardex Cliente Final
EnMenu=S
EspacioPrevio=S
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Ejecutar(<T>C:\AppsMavi\SHM\SHM.exe <T>+<T>CLIENTEFINALKARDEX <T>+<T> <T>+ MaviServiCasaCredVis:Id+<T> <T>+ Usuario)

[Acciones.RM1124]
Nombre=RM1124
Boton=0
Menu=&Reportes
NombreDesplegar=RM1124 Reporte Canal 76
EnMenu=S
TipoAccion=Reportes Pantalla
ClaveAccion=RM1124AnalisisAsociadoRep
Activo=S
Visible=S
[Acciones.RM1127]
Nombre=RM1127
Boton=0
NombreEnBoton=S
Menu=&Reportes
NombreDesplegar=RM1127 Reporte de Clientes DIMA
EnMenu=S
TipoAccion=Reportes Pantalla
ClaveAccion=RM1127ClientesAsociadosValeraRep
Activo=S
Visible=S
EspacioPrevio=S



[Acciones.ConsultaINTL]
Nombre=ConsultaINTL
Boton=18
NombreEnBoton=S
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=F7
NombreDesplegar=Consulta &INTL BURO
EnBarraHerramientas=S
EnMenu=S
TipoAccion=expresion
Expresion=Ejecutar(<T>PlugIns\IntL603.exe <T>+MaviServiCasaCredVis:Cliente+<T> <T>+Usuario+<T> N <T>+MaviServiCasaCredVis:Id)
Activo=S
VisibleCondicion=si<BR>(<T>CREDI<T> en Medio(Usuario,1,5))<BR>entonces<BR>    verdadero<BR>sino<BR>    falso<BR>fin


[Acciones.ACD00017VisorMavi]
Nombre=Consulta
Boton=128
NombreDesplegar=visor MAVI
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
NombreEnBoton=S
UsaTeclaRapida=S
TeclaRapida=F7
Expresion=Asigna(Mavi.ServicasaConfigUsr1,SQL(<T>SELECT Propiedad FROM Prop WITH(NOLOCK) WHERE RAMA=<T>+comillas(<T>USR<T>)+<T> AND TIPO=<T>+comillas(<T>GIRO<T>)+<T> AND Cuenta= :tUsu<T>,Usuario))<BR>si<BR>condatos(MaviServiCasaCredVis:Cliente)<BR>entonces<BR>Ejecutar(<T>PlugIns\ALCHEMY\AlchemyII.exe <T>+Mavi.ServicasaConfigUsr1+<T> <T>+MaviServiCasaCredVis:Cliente+<T> <T>+<T>CLIENTE<T>+<T> <T>+<T>N<T>)<BR>sino<BR>Ejecutar(<T>PlugIns\ALCHEMY\AlchemyII.exe <T>+Mavi.ServicasaConfigUsr1+<T> <T>+<T>VACIO<T>+<T> <T>+<T>CLIENTE<T>+<T> <T>+<T>N<T>)<BR>fin

[Acciones.VisorSA]
Nombre=VisorSA
Boton=0
NombreDesplegar=Visor Socioeconomico Aval
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
Antes=S
Expresion=Asigna(Info.UsuarioGD,SQL(<T>SELECT Propiedad FROM Prop WITH(NOLOCK) WHERE RAMA=<T>+comillas(<T>USR<T>)+<T> AND TIPO=<T>+comillas(<T>GIRO<T>)+<T> AND Cuenta= :tUsu<T>,Usuario))<BR> si<BR>condatos(MaviServiCasaCredVis:Cliente)<BR>entonces<BR>Ejecutar(<T>PlugIns\ALCHEMY\AlchemyII.exe <T>+Info.UsuarioGD+<T> <T>+MaviServiCasaCredVis:Cliente+<T> <T>+<T>CLIENTE<T>+<T> <T>+<T>SA<T>)<BR>sino<BR>informacion(<T>No se pudo obtener la cuenta del cliente, intente nuevamente<T>)<BR>fin

[Acciones.VisorSC]
Nombre=VisorSC
Boton=0
NombreDesplegar=Visor Socioeconomico Cliente
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
Antes=S
Expresion=Asigna(Info.UsuarioGD,SQL(<T>SELECT Propiedad FROM Prop WITH(NOLOCK) WHERE RAMA=<T>+comillas(<T>USR<T>)+<T> AND TIPO=<T>+comillas(<T>GIRO<T>)+<T> AND Cuenta= :tUsu<T>,Usuario))<BR> si<BR>condatos(MaviServiCasaCredVis:Cliente)<BR>entonces<BR>Ejecutar(<T>PlugIns\ALCHEMY\AlchemyII.exe <T>+Info.UsuarioGD+<T> <T>+MaviServiCasaCredVis:Cliente+<T> <T>+<T>CLIENTE<T>+<T> <T>+<T>SC<T>)<BR>sino<BR>informacion(<T>No se pudo obtener la cuenta del cliente, intente nuevamente<T>)<BR>fin

[Acciones.VisorBA]
Nombre=VisorBA
EnMenu=S
Boton=0
NombreDesplegar=Visor Buro Aval
TipoAccion=Expresion
Activo=S
Visible=S
Antes=S
Expresion=Asigna(Info.UsuarioGD,SQL(<T>SELECT Propiedad FROM Prop WITH(NOLOCK) WHERE RAMA=<T>+comillas(<T>USR<T>)+<T> AND TIPO=<T>+comillas(<T>GIRO<T>)+<T> AND Cuenta= :tUsu<T>,Usuario))<BR> si<BR>condatos(MaviServiCasaCredVis:Cliente)<BR>entonces<BR>Ejecutar(<T>PlugIns\ALCHEMY\AlchemyII.exe <T>+Info.UsuarioGD+<T> <T>+MaviServiCasaCredVis:Cliente+<T> <T>+<T>CLIENTE<T>+<T> <T>+<T>BA<T>)<BR>sino<BR>informacion(<T>No se pudo obtener la cuenta del cliente, intente nuevamente<T>)<BR>fin

[Acciones.VisorBC]
Nombre=VisorBC
EnMenu=S
Boton=0
NombreDesplegar=Visor Buro Cliente
TipoAccion=Expresion
Activo=S
Visible=S
Antes=S
Expresion=Asigna(Info.UsuarioGD,SQL(<T>SELECT Propiedad FROM Prop WITH(NOLOCK) WHERE RAMA=<T>+comillas(<T>USR<T>)+<T> AND TIPO=<T>+comillas(<T>GIRO<T>)+<T> AND Cuenta= :tUsu<T>,Usuario))<BR> si<BR>condatos(MaviServiCasaCredVis:Cliente)<BR>entonces<BR>Ejecutar(<T>PlugIns\ALCHEMY\AlchemyII.exe <T>+Info.UsuarioGD+<T> <T>+MaviServiCasaCredVis:Cliente+<T> <T>+<T>CLIENTE<T>+<T> <T>+<T>BC<T>)<BR>sino<BR>informacion(<T>No se pudo obtener la cuenta del cliente, intente nuevamente<T>)<BR>fin

[Acciones.VisorIA]
Nombre=VisorIA
Boton=0
EnMenu=S
NombreDesplegar=Visor Indentificación Aval
TipoAccion=Expresion
Activo=S
Visible=S
Antes=S
Expresion=Asigna(Info.UsuarioGD,SQL(<T>SELECT Propiedad FROM Prop WITH(NOLOCK) WHERE RAMA=<T>+comillas(<T>USR<T>)+<T> AND TIPO=<T>+comillas(<T>GIRO<T>)+<T> AND Cuenta= :tUsu<T>,Usuario))<BR> si<BR>condatos(MaviServiCasaCredVis:Cliente)<BR>entonces<BR>Ejecutar(<T>PlugIns\ALCHEMY\AlchemyII.exe <T>+Info.UsuarioGD+<T> <T>+MaviServiCasaCredVis:Cliente+<T> <T>+<T>CLIENTE<T>+<T> <T>+<T>IA<T>)<BR>sino<BR>informacion(<T>No se pudo obtener la cuenta del cliente, intente nuevamente<T>)<BR>fin

[Acciones.VisorIC]
Nombre=VisorIC
EnMenu=S
Boton=0
NombreDesplegar=Visor Indentificación Cliente
TipoAccion=Expresion
Activo=S
Visible=S
Antes=S
Expresion=Asigna(Info.UsuarioGD,SQL(<T>SELECT Propiedad FROM Prop WITH(NOLOCK) WHERE RAMA=<T>+comillas(<T>USR<T>)+<T> AND TIPO=<T>+comillas(<T>GIRO<T>)+<T> AND Cuenta= :tUsu<T>,Usuario))<BR> si<BR>condatos(MaviServiCasaCredVis:Cliente)<BR>entonces<BR>Ejecutar(<T>PlugIns\ALCHEMY\AlchemyII.exe <T>+Info.UsuarioGD+<T> <T>+MaviServiCasaCredVis:Cliente+<T> <T>+<T>CLIENTE<T>+<T> <T>+<T>IC<T>)<BR>sino<BR>informacion(<T>No se pudo obtener la cuenta del cliente, intente nuevamente<T>)<BR>fin


[Acciones.ConsultaBC]
Nombre=ConsultaBC
Boton=0
UsaTeclaRapida=S
TeclaRapida=Ctrl+U
NombreDesplegar=Consultar Buró
EnMenu=S
EspacioPrevio=S
TipoAccion=expresion
Activo=S
Expresion=si<BR>    (MaviServiCasaCredVis:Mov = <T>Solicitud Credito<T>)<BR>entonces<BR>    Ejecutar(<T>C:\AppsMavi\SHM\SHM.exe <T>+<T>CONSULTAR <T>+Usuario+<T> <T>+MaviServiCasaCredVis:Cliente+<T> <T>+<T>Solicitud_Credito<T>+<T> <T>+MaviServiCasaCredVis:Movid+<T> <T>+ 1)<BR>sino<BR>    si<BR>        (MaviServiCasaCredVis:Mov = <T>Analisis Credito<T>)<BR>    entonces<BR>        Ejecutar(<T>C:\AppsMavi\SHM\SHM.exe <T>+<T>CONSULTAR <T>+Usuario+<T> <T>+MaviServiCasaCredVis:Cliente+<T> <T>+<T>Analisis_Credito<T>+<T> <T>+MaviServiCasaCredVis:Movid+<T> <T>+ 1)<BR>    sino<BR>        falso<BR>    fin<BR>fin
VisibleCondicion=si<BR>(<T>CREDI<T> en Medio(Usuario,1,5))<BR>entonces<BR>    verdadero<BR>sino<BR>    falso<BR>fin

[Servicasa.ListaEnCaptura]
(Inicio)=SucursalOrigen
SucursalOrigen=Cliente
Cliente=Nombre
Nombre=Tipo_de_Cliente
Tipo_de_Cliente=CANALVENTA
CANALVENTA=EstatusConvenio
EstatusConvenio=Condicion
Condicion=SolRefinanciamiento
SolRefinanciamiento=ImporteTotal
ImporteTotal=Monedero
Monedero=TiempoTotalTranscurrido
TiempoTotalTranscurrido=Estatus
Estatus=Situacion
Situacion=Reactivacion
Reactivacion=Grupo
Grupo=Relacionado
Relacionado=%Supervision
%Supervision=ReferenciaAnterior
ReferenciaAnterior=FechaAlta
FechaAlta=FUM
FUM=Agente
Agente=Seguimiento
Seguimiento=Calificacion
Calificacion=Observaciones
Observaciones=Fech. Alta. a Fech. Ult. Mod.
Fech. Alta. a Fech. Ult. Mod.=Fech. Ult. Mod. a Fech. Act.
Fech. Ult. Mod. a Fech. Act.=(Fin)

[Servicasa.ListaAcciones]
(Inicio)=AbrirMovDSC
AbrirMovDSC=NuevoDSC
NuevoDSC=InfoCteDSC
InfoCteDSC=CteCtoDSC
CteCtoDSC=MovPosDSC
MovPosDSC=MovBitacoraDCS
MovBitacoraDCS=MovTiempoDSC
MovTiempoDSC=Tiempo Total
Tiempo Total=AgregarEventoDSC
AgregarEventoDSC=RelacionCteDSC
RelacionCteDSC=PersonalizarDSC
PersonalizarDSC=CopiarDSC
CopiarDSC=CitaSup
CitaSup=Monedero
Monedero=HojaV
HojaV=ctefinal
ctefinal=ConsultaBC
ConsultaBC=(Fin)

[Forma.ListaCarpetas]
(Inicio)=Sucursal
Sucursal=Filtros
Filtros=Servicasa
Servicasa=Detalle
Detalle=(Fin)

[Forma.MovimientosValidos]
(Inicio)=Solicitud Credito
Solicitud Credito=Analisis Credito
Analisis Credito=Sol Dev Unicaja
Sol Dev Unicaja=Solicitud Devolucion
Solicitud Devolucion=Factura
Factura=Factura VIU
Factura VIU=Credilana
Credilana=Seguro Vida
Seguro Vida=Seguro Auto
Seguro Auto=Prestamo Personal
Prestamo Personal=Pedido
Pedido=(Fin)

[Forma.ListaAcciones]
(Inicio)=AbrirMovSC
AbrirMovSC=NuevoSC
NuevoSC=InfoCteSC
InfoCteSC=CteCtoSC
CteCtoSC=Coincidencias
Coincidencias=ServicasaUnicajaSC
ServicasaUnicajaSC=Kardex
Kardex=MovPosSC
MovPosSC=MovBitacoraSC
MovBitacoraSC=MovTiempoSC
MovTiempoSC=AgregarEventoSC
AgregarEventoSC=RelacionCteSC
RelacionCteSC=HistoricoSolicitudes
HistoricoSolicitudes=Registro
Registro=RecomendadosServicasaSC
RecomendadosServicasaSC=ReporteServicasa
ReporteServicasa=NotasCobranza
NotasCobranza=NotasAreaCobranza
NotasAreaCobranza=ServicredCred
ServicredCred=HistoricoUnicajaSC
HistoricoUnicajaSC=ExcelSC
ExcelSC=ActualizarSC
ActualizarSC=copiar
copiar=Consulta
Consulta=PersonalizarSC
PersonalizarSC=Acercade
Acercade=Cerrar
Cerrar=ReporteRM0855A
ReporteRM0855A=ReporteServicred
ReporteServicred=ReporteAnuelesSC
ReporteAnuelesSC=RM1124
RM1124=RM1127
RM1127=ConsultaINTL
ConsultaINTL=ACD00017VisorMavi
ACD00017VisorMavi=(Fin)

[Forma.MenuPrincipal]
(Inicio)=&Archivo
&Archivo=&Exploradores
&Exploradores=&Edicion
&Edicion=&Ver
&Ver=&Reportes
&Reportes=&Ayuda
&Ayuda=(Fin)

[Acciones.RM1121]
Nombre=RM1121
Boton=127
NombreEnBoton=S
NombreDesplegar=&Cliente-Aval
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=SI (MaviServiCasaCredVis:Cliente = NULO) o (MaviServiCasaCredVis:Cliente = <T> <T>)<BR>ENTONCES<BR>       FORMA(<T>RM1121ClienteAval<T>)<BR>SINO<BR>    Asigna(Info.ClienteD,MaviServiCasaCredVis:Cliente)<BR>    EjecutarSQL(<T>EXEC SP_MAVIRM1121ReporteCuentasAvaladas :tCliente,:tAccion<T>,Info.ClienteD , <T>DELETE<T>)<BR>    FORMA(<T>RM1121MuestreoClienteAvalFrm<T>)<BR>FIN
[Servicasa.TextoAmostrar]
Carpeta=Servicasa
Clave=TextoAmostrar
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.InvesTelefonica]
Nombre=InvesTelefonica
Boton=0
NombreDesplegar=Investigación Telefónica
EnMenu=S
TipoAccion=Formas
ClaveAccion=RM1148ContactosFrm
Visible=S
Multiple=S
ListaAccionesMultiples=Expresion<BR>Traer Forma
Activo=S
[Acciones.InvesTelefonica.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(MAVI.RM1148Cliente,MaviServiCasaCredVis:Cliente)<BR>Asigna(MAVI.RM1148IDMov,MaviServiCasaCredVis:Id)
[Acciones.InvesTelefonica.Traer Forma]
Nombre=Traer Forma
Boton=0
TipoAccion=Formas
ClaveAccion=RM1148ContactosFrm
Activo=S
Visible=S

[ServicredCred.VTACambaceo]
Carpeta=ServicredCred
Clave=VTACambaceo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Acciones.Reanalisis]
Nombre=Reanalisis
Boton=0
NombreDesplegar=&Reanálisis
EnMenu=S
TipoAccion=Expresion
Activo=S

Expresion=Asigna(Info.Numero, MaviServicasaCredVis:Id)<BR>Asigna(Info.Usuario, Usuario )<BR>Forma(<T>RM1154TipReanalisisFrm<T>)
VisibleCondicion=MaviServicasaCredVis:Mov = <T>Analisis Credito<T>

[DM0112SituacionFiltroVis.Columnas]
Situacion=228

[ServicredCred.IDEcommerce]
Carpeta=ServicredCred
Clave=IDEcommerce
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
