[Forma]
Clave=MaviServicredCrMayFrm
Nombre=Info.UENMAVI+Si(Mavi.ServicredMayExplora=1,<T> EXPLORA SERVICRED MAYOREO<T>,<T> SERVICRED MAYOREO <T>)+<T> SUCURSAL <T>+Sucursal+<T><T>+Ahora
Icono=747
Menus=S
BarraHerramientas=S
Modulos=VTAS
MovModulo=VTAS
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=Filtros<BR>ServicredCrMay<BR>Detalle
CarpetaPrincipal=ServicredCrMay
PosicionInicialIzquierda=10
PosicionInicialArriba=10
PosicionInicialAlturaCliente=750
PosicionInicialAncho=1260
ListaAcciones=AbrirMovSCR<BR>NuevoSRVP<BR>InfoCteSCR<BR>CteCtoScrCrMy<BR>MovPosSCR<BR>MovBitacoraSCR<BR>MovTiempoSCR<BR>AgregarEventoSCR<BR>NotasCobranzatelefonica<BR>NotasCobranza<BR>RegistroCte<BR>ExploraSCRVP<BR>ServicasaCrMY<BR>ActualizarSCR<BR>PersonalizarSCR<BR>AcercadeSCRMY<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Dise�o
VentanaEstadoInicial=Normal
PosicionSec1=70
PosicionSec2=500
AccionesDivision=S
Comentarios=Usuario
PosicionCol2=642
VentanaAjustarZonas=S
VentanaAvanzaTab=S
EsMovimiento=S
MovimientosValidos=Solicitud Mayoreo<BR>Analisis Mayoreo<BR>Pedido Mayoreo<BR>Factura Mayoreo<BR>Devolucion Mayoreo<BR>Bonificacion Mayoreo<BR>Sol Dev Mayoreo<BR>Sol Dev Unicaja
TituloAuto=S
MovEspecificos=Especificos
FiltrarFechasSinHora=S
CarpetasMultilinea=S
ExpresionesAlMostrar=Asigna(Mavi.DM0112Mov,<T>Solicitud Mayoreo<T>)<BR>Asigna(Mavi.DM0112Estatus,<T>PENDIENTE<T>)<BR>Asigna(Mavi.FechaI,FechaDMA(SQL(<T>Select GetDate()<T>)))<BR>Asigna(Mavi.FechaF,FechaDMA(SQL(<T>Select GetDate()<T>)))<BR>Asigna(Mavi.DM0112Busqueda,nulo)<BR>Asigna(Mavi.ServicredMayExplora,0)<BR>//Asigna(Info.UEN,SQL(<T>Select UEN from Usuario Where Usuario=:tval1<T>,Usuario))<BR>//<BR>//Si(Info.UEN=1,Asigna(Mavi.CategoriaVenta,<T>CREDITO MENUDEO<T>))<BR>//Si(Info.UEN=1,Asigna(Mavi.CategoriaVenta,<T>CREDITO MENUDEO<T>))<BR>//Si(Info.UEN=3,Asigna(Mavi.CategoriaVenta,<T>CREDITO MENUDEO<T>))<BR>//Mavi.CanalUEN<BR>Asigna(Mavi.DM0112ComboBusquedaMay, <T>Cliente<T>)
ExpresionesAlCerrar=Asigna(Mavi.ServicredMayExplora,0)
MenuPrincipal=&Archivo<BR>&Exploradores<BR>&Edicion<BR>&Ver<BR>&Reportes<BR>&Ayuda
[ServicredCred.Columnas]
0=-2
1=-2
2=228
3=194
4=-2
5=-2
6=97
7=67
8=143
9=-2
10=346
11=89
12=108
13=-2
14=-2
15=-2
16=-2
17=-2
18=-2
19=-2
20=-2
21=-2
22=-2
23=-2
24=-2
25=-2
26=-2
27=-2
28=-2
29=-2
[Detalle]
Estilo=Iconos
Clave=Detalle
AlineacionAutomatica=S
AcomodarTexto=S
Zona=C1
Fuente={Tahoma, 8, Rojo obscuro, [Negritas]}
CampoColorLetras=Negro
CampoColorFondo=Blanco
Detalle=S
Vista=MaviServicredCrMayTCVis
VistaMaestra=MaviServicredCrMayVis
LlaveLocal=ID
LlaveMaestra=ID
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSubTitulo=<T>Fecha<T>
CarpetaVisible=S
ListaEnCaptura=CALIFICACION<BR>Observaciones<BR>SUCURSAL
IconosConRejilla=S
ConFuenteEspecial=S
OtroOrden=S
ListaOrden=FECHA<TAB>(Decendente)
IconosNombre=MaviServicredCrMayTCVis:FECHA
[Detalle.Columnas]
0=136
1=-2
2=492
3=530
4=75
[Acciones.AbrirMovSCR.AsigAbrirMovSCR]
Nombre=AsigAbrirMovSCR
Boton=0
Activo=S
Visible=S
TipoAccion=Expresion
Expresion=Asigna(Info.ID,MaviServicredCrMayVis:Id)<BR>Asigna(Info.Mov,MaviServicredCrMayVis:Mov)<BR>Asigna(Info.Movid,MaviServicredCrMayVis:Movid)<BR>Asigna(Info.Situacion,MaviServicredCrMayVis:Situacion)<BR>Asigna(Mavi.TipoCliente,MaviServicredCrMayVis:MaviTipoVenta)<BR>Asigna(Info.Estatus,MaviServicredCrMayVis:Estatus)
ConCondicion=S
EjecucionCondicion=ConDatos(MaviServicredCrMayVis:Id)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
EjecucionConError=S
[Acciones.AbrirMovSCR.FrmAbrirMovSCR]
Nombre=FrmAbrirMovSCR
Boton=0
Activo=S
Visible=S
TipoAccion=Expresion
ConCondicion=S
EjecucionConError=S
Expresion=Asigna(Mavi.ServicasaModulo,6)<BR>Si sql(<T>select count(*) from MaviDM0112USCA where usuario = :tUsuario<T>, Usuario)=0<BR>    entonces<BR>        FormaPos(<T>Venta<T>,Vacio(Info.ID,0)))<BR>        sql(<T>Exec sp_MaviDM0112BUSC :tUsuario<T>,Usuario)<BR>        sql(<T>Exec sp_MaviDM0112GUSC :tusu,:tmov,:tmovid,:nid <T>,usuario,MaviServicredCrMayVis:Mov,MaviServicredCrMayVis:Movid,MaviServicredCrMayVis:Id)<BR>    sino<BR>        Si sql(<T>select Folio from MaviDM0112usca where Usuario = :tUsuario <T>, Usuario)=(MaviServicredCrMayVis:Mov+<T> <T>+MaviServicredCrMayVis:Movid)<BR>            Entonces<BR>                FormaPos(<T>Venta<T>,Vacio(Info.ID,0))<BR>            Sino<BR>                Error(<T>Existe un Movimiento abierto por este Usuario<T>)<BR>                FormaPos(<T>Venta<T>,V<CONTINUA>
Expresion002=<CONTINUA>acio(Info.ID,0))<BR>        Fin<BR>Fin
EjecucionCondicion=(sql(<T>Exec sp_MaviDM0112CUSC :tmov,:tmovid,:nid <T>,MaviServicredCrMayVis:Mov,MaviServicredCrMayVis:Movid,MaviServicredCrMayVis:Id) = <T>Disponible<T><BR>y Condatos(Info.ID))<BR>o (sql(<T>select Usuario from MaviDM0112usca where Mov = :tMov and MovID = :tMovid <T>, MaviServicredCrMayVis:Mov,MaviServicredCrMayVis:Movid)=Usuario)
EjecucionMensaje=<T>Movimiento ocupado por otro usuario<T>
[Acciones.AbrirMovSCR]
Nombre=AbrirMovSCR
Boton=2
NombreEnBoton=S
NombreDesplegar=&Abrir
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=AsigAbrirMovSCR<BR>FrmAbrirMovSCR
Activo=S
Visible=S
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Ctrl+A
EnMenu=S
Antes=S
AntesExpresiones=Asigna(Info.ID,nulo)<BR>Asigna(Info.Mov,nulo)<BR>Asigna(Info.MovID,nulo)<BR>Asigna(Info.Situacion,nulo)<BR>Asigna(Mavi.TipoCliente,nulo)<BR>Asigna(Info.Estatus,nulo)
[Acciones.InfoCteSCR.AsigInfoCteSCR]
Nombre=AsigInfoCteSCR
Boton=0
Activo=S
Visible=S
TipoAccion=expresion
Expresion=Asigna(Info.Cliente,MaviServicredCrMayVis:Cliente)
[Acciones.InfoCteSCR.FrmInfoCteSCR]
Nombre=FrmInfoCteSCR
Boton=0
Activo=S
Visible=S
TipoAccion=formas
ClaveAccion=CteInfo
[Acciones.InfoCteSCR]
Nombre=InfoCteSCR
Boton=34
NombreDesplegar=&Informaci�n del Cliente
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=AsigInfoCteSCR<BR>FrmInfoCteSCR
Activo=S
Visible=S
NombreEnBoton=S
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=Ctrl+I
EnMenu=S
ConCondicion=S
EjecucionCondicion=Condatos(MaviServicredCrMayVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
EjecucionConError=S
Antes=S
AntesExpresiones=Asigna(Info.Cliente,nulo)
[Acciones.CteCtoSCR.AsigCteCtoSCR]
Nombre=AsigCteCtoSCR
Boton=0
Activo=S
Visible=S
TipoAccion=Expresion
Expresion=Asigna(Info.Cliente,MaviServicredVtasPisoVis:Cliente)
[Acciones.CteCtoSCR.FrmCteCtoSCR]
Nombre=FrmCteCtoSCR
Boton=0
Activo=S
Visible=S
TipoAccion=Formas
ClaveAccion=MaviServicasaCteCtoFrm
[Acciones.MovPosSCR.AsigMovPosSCR]
Nombre=AsigMovPosSCR
Boton=0
Activo=S
Visible=S
TipoAccion=Expresion
Expresion=Asigna(Info.ID,MaviServicredCrMayVis:Id)<BR>Asigna(Info.Modulo,<T>VTAS<T>)
[Acciones.MovPosSCR.FrmMovPosSCR]
Nombre=FrmMovPosSCR
Boton=0
Activo=S
Visible=S
TipoAccion=Formas
ClaveAccion=movpos
[Acciones.MovPosSCR]
Nombre=MovPosSCR
Boton=24
NombreEnBoton=S
NombreDesplegar=Po&sicion Mov
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=AsigMovPosSCR<BR>FrmMovPosSCR
Activo=S
Visible=S
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=Ctrl+S
EnMenu=S
ConCondicion=S
EjecucionCondicion=Condatos(MaviServicredCrMayVis:Id)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
EjecucionConError=S
Antes=S
AntesExpresiones=Asigna(Info.ID,nulo)<BR>Asigna(Info.Modulo,nulo)
[Acciones.MovBitacoraSCR.AsigMovBitacoraSCR]
Nombre=AsigMovBitacoraSCR
Boton=0
Activo=S
Visible=S
TipoAccion=Expresion
Expresion=Asigna(Info.Modulo, <T>VTAS<T>)<BR>Asigna(Info.ID, MaviServicredCrMayVis:Id)
[Acciones.MovBitacoraSCR.FrmMovBitacoraSCR]
Nombre=FrmMovBitacoraSCR
Boton=0
Activo=S
Visible=S
TipoAccion=Formas
ClaveAccion=MovBitacora
[Acciones.MovBitacoraSCR]
Nombre=MovBitacoraSCR
Boton=38
NombreEnBoton=S
NombreDesplegar=&Bitacora
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=AsigMovBitacoraSCR<BR>FrmMovBitacoraSCR
Activo=S
Visible=S
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=Ctrl+B
EnMenu=S
ConCondicion=S
EjecucionCondicion=Condatos(MaviServicredCrMayVis:Id)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
EjecucionConError=S
Antes=S
AntesExpresiones=Asigna(Info.Modulo, nulo)<BR>Asigna(Info.ID, nulo)
[Acciones.MovTiempoSCR.AsigMovTiempoSCR]
Nombre=AsigMovTiempoSCR
Boton=0
Activo=S
Visible=S
TipoAccion=Expresion
Expresion=Asigna(Info.Modulo, <T>VTAS<T>)<BR>Asigna(Info.ID, MaviServicredCrMayVis:Id)<BR>Asigna(Info.Mov,MaviServicredCrMayVis:Mov)<BR>Asigna(Info.MovID,MaviServicredCrMayVis:Movid)
[Acciones.MovTiempoSCR.FrmMovTiempoSCR]
Nombre=FrmMovTiempoSCR
Boton=0
Activo=S
Visible=S
TipoAccion=Formas
ClaveAccion=VerMovTiempo
[Acciones.MovTiempoSCR]
Nombre=MovTiempoSCR
Boton=15
NombreDesplegar=&Tiempo
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=AsigMovTiempoSCR<BR>FrmMovTiempoSCR
Activo=S
Visible=S
NombreEnBoton=S
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=Ctrl+T
EnMenu=S
ConCondicion=S
EjecucionCondicion=Condatos(MaviServicredCrMayVis:Id)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
EjecucionConError=S
Antes=S
AntesExpresiones=Asigna(Info.Modulo, nulo)<BR>Asigna(Info.ID, nulo)<BR>Asigna(Info.Mov,nulo)<BR>Asigna(Info.MovID,nulo)
[Acciones.AgregarEventoSCR.AsigAgregarEventoSCR]
Nombre=AsigAgregarEventoSCR
Boton=0
Activo=S
Visible=S
TipoAccion=Expresion
ConCondicion=S
EjecucionConError=S
Expresion=Asigna(Info.Mov,MaviServicredCrMayVis:Mov)<BR>Asigna(Info.MovID,MaviServicredCrMayVis:Movid)<BR>Asigna(Info.ID,MaviServicredCrMayVis:Id)
EjecucionCondicion=1=1<BR>/*Asigna(Mavi.ServicasaConfigUsr1,SQL(<T>SELECT ACCESO FROM USUARIO WHERE USUARIO=:tval1<T>,Usuario))<BR>Asigna(Mavi.ServicasaGrupoCalif,(SQL(<T>EXEC SP_MAVIULTIMACALIFICACION :nval1,:tval2<T>,MaviServicredCrMayVis:Id,<T>Vtas<T>)))<BR>((MaviServicredCrMayVis:Estatus<>EstatusCancelado) y ((Mavi.ServicasaConfigUsr1=<T>CREDI_GERA<T>) o (Mavi.ServicasaConfigUsr1=<T>CREDI_USRA<T>) o (Mavi.ServicasaConfigUsr1=<T>COBMA_GERA<T>) o (Mavi.ServicasaConfigUsr1=<T>COBMA_USRA<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTR_GERA<T>) y (Mavi.ServicasaGrupoCalif=<T>D<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTP_GERA<T>) y (Mavi.ServicasaGrupoCalif=<T>C<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTP_SUPA<T>) y (Mavi.ServicasaGrupoCalif=<T>C<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTI_GERA<T>) y (Mavi.ServicasaGr<CONTINUA>
EjecucionCondicion002=<CONTINUA>upoCalif=<T>C<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTC_GERA<T>) y (Mavi.ServicasaGrupoCalif=<T>C<T>)) o (Mavi.ServicasaConfigUsr1=<T>VENTC_USRA<T>) o (Mavi.ServicasaConfigUsr1 =<T>MAVI<T>) o (Mavi.ServicasaConfigUsr1 en (<T>COBMA_GERA<T>,<T>COBMA_USRA<T>))))<BR>*/
EjecucionMensaje=<T>El estado actual del movimiento o los permisos de usuario <T>+nuevalinea+<T>no permiten agregar un evento, por favor verifique..<T>
[Acciones.AgregarEventoSCR.FrmAgregarEventoSCR]
Nombre=FrmAgregarEventoSCR
Boton=0
Activo=S
Visible=S
TipoAccion=Formas
ClaveAccion=MovBitacoraAgregar
[Acciones.AgregarEventoSCR]
Nombre=AgregarEventoSCR
Boton=17
NombreEnBoton=S
NombreDesplegar=Agregar Evento
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=AsigAgregarEventoSCR<BR>FrmAgregarEventoSCR
Visible=S
Antes=S
Menu=&Edicion
UsaTeclaRapida=S
TeclaRapida=F6
EnMenu=S
Activo=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Condatos(MaviServicredCrMayVis:Id)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
AntesExpresiones=Asigna(Info.Modulo, <T>VTAS<T>)  <BR>Asigna(Info.Mov,nulo)<BR>Asigna(Info.MovID,nulo)<BR>Asigna(Info.ID,nulo)
[Acciones.RelacionCteSCR.AsigRelacionCteSCR]
Nombre=AsigRelacionCteSCR
Boton=0
Activo=S
Visible=S
TipoAccion=Expresion
Expresion=Asigna(Info.Cliente,MaviServicredCrMayVis:Cliente)
[Acciones.RelacionCteSCR.FrmRelacionCteSCR]
Nombre=FrmRelacionCteSCR
Boton=0
Activo=S
Visible=S
TipoAccion=Formas
ClaveAccion=CteRelacion
[Acciones.ActualizarSCR.AsigActualizarSCR]
Nombre=AsigActualizarSCR
Boton=0
Activo=S
Visible=S
[Acciones.ActualizarSCR.FrmActualizarSCR]
Nombre=FrmActualizarSCR
Boton=0
Activo=S
Visible=S
[Acciones.ActualizarSCR]
Nombre=ActualizarSCR
Boton=82
NombreDesplegar=Actualizar
EnBarraHerramientas=S
Activo=S
Visible=S
Menu=&Exploradores
UsaTeclaRapida=S
TeclaRapida=F5
EnMenu=S
Multiple=S
ListaAccionesMultiples=Asignar<BR>Exp
[Acciones.PersonalizarSCR]
Nombre=PersonalizarSCR
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
[Acciones.AbrirMovDSCR.AsigAbrirMovDSCR]
Nombre=AsigAbrirMovDSCR
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Asigna(Info.ID,MaviServicredCrMayVis:Id)<BR>Asigna(Info.Mov,MaviServicredCrMayVis:Mov)<BR>Asigna(Info.Movid,MaviServicredCrMayVis:Movid)<BR>Asigna(Info.Situacion,MaviServicredCrMayVis:Situacion)<BR>Asigna(Mavi.TipoCliente,MaviServicredCrMayVis:MaviTipoVenta)<BR>Asigna(Info.Estatus,MaviServicredCrMayVis:Estatus)
EjecucionCondicion=Condatos(MaviServicredCrMayVis:Id)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
[Acciones.AbrirMovDSCR.FrmAbrirMovDSCR]
Nombre=FrmAbrirMovDSCR
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Asigna(Mavi.ServicasaModulo,6)<BR>Si sql(<T>select count(*) from MaviDM0112USCA where usuario = :tUsuario<T>, Usuario)=0<BR>    entonces<BR>        FormaPos(<T>Venta<T>,Vacio(Info.ID,0))<BR>        sql(<T>Exec sp_MaviDM0112BUSC :tUsuario<T>,Usuario)<BR>        sql(<T>Exec sp_MaviDM0112GUSC :tusu,:tmov,:tmovid,:nid <T>,usuario,MaviServicredCrMayVis:Mov,MaviServicredCrMayVis:Movid,MaviServicredCrMayVis:Id)<BR>    sino<BR>        Si sql(<T>select Folio from MaviDM0112usca where Usuario = :tUsuario <T>, Usuario)=(MaviServicredCrMayVis:Mov+<T> <T>+MaviServicredCrMayVis:Movid)<BR>            Entonces<BR>                FormaPos(<T>Venta<T>,Vacio(Info.ID,0))<BR>            Sino<BR>                Error(<T>Existe un Movimiento abierto por este Usuario<T>)<BR>                FormaPos(<T>Venta<T>,Va<CONTINUA>
Expresion002=<CONTINUA>cio(Info.ID,0))<BR>        Fin<BR>Fin
EjecucionCondicion=(sql(<T>Exec sp_MaviDM0112CUSC :tmov,:tmovid,:nid <T>,MaviServicredCrMayVis:Mov,MaviServicredCrMayVis:Movid,MaviServicredCrMayVis:Id) = <T>Disponible<T><BR>y Condatos(Info.ID))<BR>o (sql(<T>select Usuario from MaviDM0112usca where Mov = :tMov and MovID = :tMovid <T>, MaviServicredCrMayVis:Mov,MaviServicredCrMayVis:Movid)=Usuario)
EjecucionMensaje=<T>Movimiento ocupado por otro usuario<T>
[Acciones.AbrirMovDSCR]
Nombre=AbrirMovDSCR
Boton=0
NombreDesplegar=&Abrir
Multiple=S
ListaAccionesMultiples=AsigAbrirMovDSCR<BR>FrmAbrirMovDSCR
Activo=S
Visible=S
EnMenu=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+A
Antes=S
AntesExpresiones=Asigna(Info.ID,nulo)<BR>Asigna(Info.Mov,nulo)<BR>Asigna(Info.MovID,nulo)<BR>Asigna(Info.Situacion,nulo)<BR>Asigna(Mavi.TipoCliente,nulo)<BR>Asigna(Info.Estatus,nulo)
[Acciones.InfoCteDSCR]
Nombre=InfoCteDSCR
Boton=0
EnMenu=S
Activo=S
Visible=S
NombreDesplegar=&Informaci�n del Cliente
Multiple=S
ListaAccionesMultiples=AsigInfoCteDSC<BR>FrmInfoCteDSC
UsaTeclaRapida=S
TeclaRapida=Ctrl+I
ConCondicion=S
EjecucionCondicion=Condatos(MaviServicredCrMayVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
EjecucionConError=S
Antes=S
AntesExpresiones=Asigna(Info.Cliente,nulo)
[Acciones.InfoCteDSCR.AsigInfoCteDSC]
Nombre=AsigInfoCteDSC
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Cliente,MaviServicredCrMayVis:Cliente)
[Acciones.InfoCteDSCR.FrmInfoCteDSC]
Nombre=FrmInfoCteDSC
Boton=0
TipoAccion=Formas
ClaveAccion=CteInfo
Activo=S
Visible=S
[Acciones.CteCtoDSCR.AsigCteCtoDSCR]
Nombre=AsigCteCtoDSCR
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Cliente,MaviServicredVtasPisoVis:Cliente)
[Acciones.CteCtoDSCR.FrmCteCtoDSCR]
Nombre=FrmCteCtoDSCR
Boton=0
TipoAccion=Formas
ClaveAccion=MaviServicasaCteCtoFrm
Activo=S
Visible=S
[Acciones.FrmMovPosDSCR.AsigMovPosDSCR]
Nombre=AsigMovPosDSCR
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Info.ID,MaviServicredCredVis:ID)<BR>Asigna(Info.Modulo,<T>VTAS<T>)
Activo=S
Visible=S
[Acciones.FrmMovPosDSCR.FrmMovPosDSCR]
Nombre=FrmMovPosDSCR
Boton=0
TipoAccion=Formas
ClaveAccion=movpos
Activo=S
Visible=S
[Acciones.MovPosDSCR]
Nombre=MovPosDSCR
Boton=0
NombreDesplegar=Po&sicion Mov
Multiple=S
EnMenu=S
ListaAccionesMultiples=AsigMovPosDSCR<BR>FrmMovPosDSCR
Activo=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+S
ConCondicion=S
EjecucionCondicion=Condatos(MaviServicredCrMayVis:Id)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
EjecucionConError=S
Antes=S
AntesExpresiones=Asigna(Info.ID,nulo)<BR>Asigna(Info.Modulo,nulo)
[Acciones.MovBitacoraDSCR.AsigMovBitacoraDSCR]
Nombre=AsigMovBitacoraDSCR
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Modulo, <T>VTAS<T>)<BR>Asigna(Info.ID, MaviServicredCrMayVis:Id)
[Acciones.MovBitacoraDSCR.FrmMovBitacoraDSCR]
Nombre=FrmMovBitacoraDSCR
Boton=0
TipoAccion=Formas
ClaveAccion=MovBitacora
Activo=S
Visible=S
[Acciones.MovBitacoraDSCR]
Nombre=MovBitacoraDSCR
Boton=0
NombreDesplegar=&Bitacora
Multiple=S
EnMenu=S
ListaAccionesMultiples=AsigMovBitacoraDSCR<BR>FrmMovBitacoraDSCR
Activo=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+B
ConCondicion=S
EjecucionCondicion=Condatos(MaviServicredCrMayVis:Id)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
EjecucionConError=S
Antes=S
AntesExpresiones=Asigna(Info.Modulo,nulo)<BR>Asigna(Info.ID, nulo)
[Acciones.MovTiempoDSCR.AsigMovTiempoDSCR]
Nombre=AsigMovTiempoDSCR
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Modulo, <T>VTAS<T>)<BR>Asigna(Info.ID,MaviServicredCrMayVis:Id)
[Acciones.MovTiempoDSCR.FrmMovTiempoDSCR]
Nombre=FrmMovTiempoDSCR
Boton=0
TipoAccion=Formas
ClaveAccion=VerMovTiempo
Activo=S
Visible=S
[Acciones.MovTiempoDSCR]
Nombre=MovTiempoDSCR
Boton=0
NombreDesplegar=&Tiempo
Multiple=S
EnMenu=S
ListaAccionesMultiples=AsigMovTiempoDSCR<BR>FrmMovTiempoDSCR
Activo=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+T
ConCondicion=S
EjecucionCondicion=Condatos(MaviServicredCrMayVis:Id)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
EjecucionConError=S
Antes=S
AntesExpresiones=Asigna(Info.Modulo, nulo)<BR>Asigna(Info.ID,nulo)
[Acciones.AgregarEventoDSCR.AsigAgregarEventoDSCR]
Nombre=AsigAgregarEventoDSCR
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Asigna(Info.Mov,MaviServicredCrMayVis:Mov)<BR>Asigna(Info.MovID,MaviServicredCrMayVis:Movid)<BR>Asigna(Info.ID,MaviServicredCrMayVis:Id)
EjecucionCondicion=Asigna(Mavi.ServicasaConfigUsr1,SQL(<T>SELECT ACCESO FROM USUARIO WHERE USUARIO=:tval1<T>,Usuario))<BR>Asigna(Mavi.ServicasaGrupoCalif,(SQL(<T>EXEC SP_MAVIULTIMACALIFICACION :nval1,:tval2<T>,MaviServicredCrMayVis:Id,<T>Vtas<T>)))<BR>((MaviServicredCrMayVis:Estatus<>EstatusCancelado) y ((Mavi.ServicasaConfigUsr1=<T>CREDI_GERA<T>) o (Mavi.ServicasaConfigUsr1=<T>CREDI_USRA<T>) o (Mavi.ServicasaConfigUsr1=<T>COBMA_GERA<T>) o (Mavi.ServicasaConfigUsr1=<T>COBMA_USRA<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTR_GERA<T>) y (Mavi.ServicasaGrupoCalif=<T>D<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTP_GERA<T>) y (Mavi.ServicasaGrupoCalif=<T>C<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTP_SUPA<T>) y (Mavi.ServicasaGrupoCalif=<T>C<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTP_GECO<T>) y (Mavi.ServicasaGrupoCalif=<CONTINUA>
EjecucionCondicion002=<CONTINUA><T>C<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTI_GERA<T>) y (Mavi.ServicasaGrupoCalif=<T>C<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTC_GERA<T>) y (Mavi.ServicasaGrupoCalif=<T>C<T>)) o (Mavi.ServicasaConfigUsr1=<T>VENTC_USRA<T>) o (Mavi.ServicasaConfigUsr1 =<T>MAVI<T>) o (Mavi.ServicasaConfigUsr1 en (<T>COBMA_GERA<T>,<T>COBMA_USRA<T>))))
EjecucionMensaje=<T>El estado actual del movimiento o los permisos de usuario <T>+nuevalinea+<T>no permiten agregar un evento, por favor verifique..<T>
[Acciones.AgregarEventoDSCR]
Nombre=AgregarEventoDSCR
Boton=0
NombreDesplegar=Agregar Evento
Multiple=S
EnMenu=S
ListaAccionesMultiples=AsigAgregarEventoDSCR<BR>FrmAgregarEventoDSCR
Visible=S
Antes=S
UsaTeclaRapida=S
TeclaRapida=F6
Activo=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Condatos(MaviServicredCrMayVis:Id)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
AntesExpresiones=Asigna(Info.Modulo, <T>VTAS<T>)<BR>Asigna(Info.Mov,nulo)<BR>Asigna(Info.MovID,nulo)<BR>Asigna(Info.ID,nulo)
[Acciones.AgregarEventoDSCR.FrmAgregarEventoDSCR]
Nombre=FrmAgregarEventoDSCR
Boton=0
TipoAccion=Formas
ClaveAccion=MovBitacoraAgregar
Activo=S
Visible=S
[Acciones.RelacionCteDSCR]
Nombre=RelacionCteDSCR
Boton=0
NombreDesplegar=&Relaciones
EnMenu=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=AsigRelacionCteDSCR<BR>FrmRelacionCteDSCR
UsaTeclaRapida=S
TeclaRapida=Ctrl+R
ConCondicion=S
EjecucionCondicion=Condatos(MaviServicredCrMayVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
EjecucionConError=S
Antes=S
AntesExpresiones=Asigna(Info.Cliente,nulo)
[Acciones.RelacionCteDSCR.AsigRelacionCteDSCR]
Nombre=AsigRelacionCteDSCR
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Cliente,MaviServicredCrMayVis:Cliente)
[Acciones.RelacionCteDSCR.FrmRelacionCteDSCR]
Nombre=FrmRelacionCteDSCR
Boton=0
TipoAccion=Formas
ClaveAccion=CteRelacion
Activo=S
Visible=S
[Acciones.PersonalizarDSCR]
Nombre=PersonalizarDSCR
Boton=0
NombreDesplegar=Personalizar Vista
EnMenu=S
Carpeta=ServicredCrMay
TipoAccion=Controles Captura
ClaveAccion=Mostrar Campos
Activo=S
VisibleCondicion=Asigna(Mavi.ServicasaConfigUsr1,SQL(<T>SELECT ACCESO FROM USUARIO WHERE USUARIO=:tval1<T>,Usuario))<BR>Mavi.ServicasaConfigUsr1 =<T>MAVI<T>
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=Cerrar
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
EnMenu=S
Menu=&Exploradores
[AvanceCohincidencias.Columnas]
0=286
1=335
[Acciones.Kardex.AsignaValSC]
Nombre=AsignaValSC
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Cliente,MaviServicredCrMayVis:Cliente)
[Acciones.Cohincidenciass.AsignaValorCoinSCR]
Nombre=AsignaValorCoinSCR
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.ClienteD,MaviServicredCrMayVis:Cliente)
[Acciones.Cohincidenciass.LlamaFormaCoinCSCR]
Nombre=LlamaFormaCoinCSCR
Boton=0
TipoAccion=Formas
ClaveAccion=CteRelacionMavi
Activo=S
Visible=S
[Acciones.InfoCteRelacionadoSCR.AsignaRelacionadoSCR]
Nombre=AsignaRelacionadoSCR
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Cliente,MaviServicredCrMayVis:Relacionado)
[Acciones.InfoCteRelacionadoSCR.FormaInfoCteRelacionado]
Nombre=FormaInfoCteRelacionado
Boton=0
TipoAccion=Formas
ClaveAccion=CteInfo
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=(condatos((SQL(<T>Select Cliente from Cte where Cliente=:tval1<T>,Info.cliente))))
EjecucionMensaje=<T>El prospecto: <T>+MaviServicredCrMayVis:Cliente+<T> no tiene registrado un relacionado valido<T>
[Acciones.RepHistorialCteSCR.AsignaCteHSSCR]
Nombre=AsignaCteHSSCR
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.cliente,MaviServicredCrMayVis:Cliente)
[Acciones.RepHistorialCteSCR.FormaHSSCR]
Nombre=FormaHSSCR
Boton=0
TipoAccion=Formas
ClaveAccion=MaviServiCasaCredHistoricoSolicitudesFrm
Activo=S
Visible=S
[Acciones.CalificacionSCR.Variables Asignar SCR]
Nombre=Variables Asignar SCR
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.CalificacionSCR.ExpresionCalifSCR]
Nombre=ExpresionCalifSCR
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=EjecutarSQL(<T>spCalificaCtesxFacturaMAVI  :tCte<T>,Info.Cliente)
[Acciones.CalificacionSCR.ExploradorCalifSCR]
Nombre=ExploradorCalifSCR
Boton=0
TipoAccion=Formas
ClaveAccion=MAVIExploradorCalificacion
Activo=S
Visible=S
[Acciones.Kardex.FormaSC]
Nombre=FormaSC
Boton=0
TipoAccion=Formas
ClaveAccion=MaviServicasaCredKardexporClienteFrm
Activo=S
Visible=S
[Acciones.NuevoSCRVP]
Nombre=NuevoSCRVP
Boton=0
NombreDesplegar=&Nuevo
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+N
Expresion=Asigna(Mavi.ServicasaCapDetallVentas,0)<BR>Asigna(Mavi.ServicasaMovNvo,1020)<BR>Forma(<T>Venta<T>)
[Acciones.MovPosDSCR.AsigMovPosDSCR]
Nombre=AsigMovPosDSCR
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Info.ID,MaviServicredCrMayVis:Id)<BR>Asigna(Info.Modulo,<T>VTAS<T>)
[Acciones.MovPosDSCR.FrmMovPosDSCR]
Nombre=FrmMovPosDSCR
Boton=0
TipoAccion=Formas
ClaveAccion=movpos
[Acciones.NuevoSRVP]
Nombre=NuevoSRVP
Boton=1
NombreDesplegar=&Nuevo
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
NombreEnBoton=S
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Ctrl+N
Expresion=Asigna(Mavi.ServicasaCapDetallVentas,0)<BR>Asigna(Mavi.ServicasaMovNvo,1020)<BR>Forma(<T>Venta<T>)
[ServicredVtasPiso.Columnas]
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
12=-2
13=-2
14=-2
15=-2
16=-2
17=-2
18=-2
19=-2
20=-2
21=-2
22=-2
23=-2
24=-2
25=-2
26=-2
27=-2
28=-2
29=-2
30=-2
[AvanceCoincidencias.Columnas]
0=-2
1=-2
[Acciones.ExploraSCRVP]
Nombre=ExploraSCRVP
Boton=66
NombreDesplegar=&Explora Servicred Cr�dito Mayoreo
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
NombreEnBoton=S
Menu=&Exploradores
UsaTeclaRapida=S
TeclaRapida=Ctrl+E
Expresion=Si(Mavi.ServicredMayExplora=1,Asigna(Mavi.ServicredMayExplora,0),Asigna(Mavi.ServicredMayExplora,1))<BR>ActualizarForma<BR>ActualizarVista
[Acciones.RegistroCte]
Nombre=RegistroCte
Boton=19
NombreDesplegar=Registro Huellas
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Formas
ClaveAccion=ExpRegistroCte
Activo=S
Visible=S
Menu=&Exploradores
NombreEnBoton=S
UsaTeclaRapida=S
TeclaRapida=F4
[ServicredCrMay]
Estilo=Iconos
Clave=ServicredCrMay
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=MaviServicredCrMayVis
ConFuenteEspecial=S
Fuente={Tahoma, 8, Rojo obscuro, [Negritas]}
IconosCampo=(Situaci�n)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Movimiento<T>
IconosConPaginas=N
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Cliente<BR>Nombre<BR>Poblacion<BR>ImporteTotal<BR>Agente<BR>Estatus<BR>Situacion<BR>FechaAlta<BR>FUM<BR>Seguimiento
FiltroPredefinido1=Solicitud Mayoreo<BR>Analisis Mayoreo<BR>Pedido Mayoreo<BR>Factura Mayoreo<BR>Devolucion Mayoreo<BR>Bonificacion Mayoreo<BR>Sol Dev Mayoreo
FiltroPredefinido2=Venta.Mov=<T>Solicitud Mayoreo<T><BR>Venta.Mov=<T>Analisis Mayoreo<T><BR>Venta.Mov=<T>Pedido Mayoreo<T><BR>Venta.Mov=<T>Factura Mayoreo<T><BR>Venta.Mov=<T>Devolucion Mayoreo<T><BR>Venta.Mov=<T>Bonificacion Mayoreo<T><BR>Venta.Mov=<T>Sol Dev Mayoreo<T>
FiltroPredefinido3=ID Desc<BR>ID Desc<BR>ID Desc<BR>ID Desc<BR>ID Desc<BR>ID Desc<BR>ID Desc
ListaAcciones=AbrirMovDSCR<BR>NuevoSCRVP<BR>InfoCteDSCR<BR>MovPosDSCR<BR>MovBitacoraDSCR<BR>MovTiempoDSCR<BR>AgregarEventoDSCR<BR>RelacionCteDSCR<BR>PersonalizarDSCR
CarpetaVisible=S
IconosConRejilla=S
PestanaOtroNombre=S
PestanaNombre=Movimientos
IconosNombre=MaviServicredCrMayVis:Mov+<T> <T>+MaviServicredCrMayVis:Movid
[ServicredCrMay.Situacion]
Carpeta=ServicredCrMay
Clave=Situacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[ServicredCrMay.Estatus]
Carpeta=ServicredCrMay
Clave=Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[ServicredCrMay.Agente]
Carpeta=ServicredCrMay
Clave=Agente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[ServicredCrMay.ImporteTotal]
Carpeta=ServicredCrMay
Clave=ImporteTotal
Editar=S
Totalizador=1
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[ServicredCrMay.Cliente]
Carpeta=ServicredCrMay
Clave=Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[ServicredCrMay.Nombre]
Carpeta=ServicredCrMay
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[ServicredCrMay.FUM]
Carpeta=ServicredCrMay
Clave=FUM
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=38
ColorFondo=Blanco
ColorFuente=Negro
[ServicredCrMay.Columnas]
0=193
1=80
2=289
3=98
4=101
5=91
6=89
7=96
8=205
9=134
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
20=-2
21=-2
22=-2
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
[Detalle.SUCURSAL]
Carpeta=Detalle
Clave=SUCURSAL
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[AvanceCoincidencias.USUARIO]
Carpeta=AvanceCoincidencias
Clave=USUARIO
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=111
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.CteCtoScrCrMy.AsignaCteCtos]
Nombre=AsignaCteCtos
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Cliente,MaviServicredCrMayVis:Cliente)<BR>Asigna(Info.ClienteD,MaviServicredCrMayVis:Cliente)
[Acciones.CteCtoScrCrMy.FrmCteCtoScrCrMy]
Nombre=FrmCteCtoScrCrMy
Boton=0
TipoAccion=Formas
ClaveAccion=MaviServicasaCteCtoFrm
Activo=S
Visible=S
[Acciones.CteCtoScrCrMy]
Nombre=CteCtoScrCrMy
Boton=60
NombreEnBoton=S
NombreDesplegar=&Contactos
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=AsignaCteCtos<BR>FrmCteCtoScrCrMy
Activo=S
Visible=S
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=Ctrl+C
EnMenu=S
ConCondicion=S
EjecucionConError=S
Antes=S
EjecucionCondicion=Condatos(MaviServicredCrMayVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
AntesExpresiones=Asigna(Info.Cliente,nulo)
[Acciones.AcercadeSCRMY]
Nombre=AcercadeSCRMY
Boton=0
NombreDesplegar=Acerca de...
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
Menu=&Ayuda
Expresion=Vermensaje(<T>Acerca de Servicred Cr�dito Mayoreo<T>,<T>Comercializadora de Muebles America S.A. de C.V.<T>+Nuevalinea+<T>______________________________________________________<T>+NuevaLinea+Nuevalinea+<T>                               Servicred Cr�dito Mayoreo<T>+Nuevalinea+Nuevalinea+<T>Versi�n: V.2010.06.15<T>+NuevaLinea+<T>Fecha de Versi�n: 15 de Junio de 2010<T>+NuevaLinea+Nuevalinea+<T>______________________________________________________<T>+NuevaLinea+Nuevalinea+Nuevalinea+<T>www.mueblesamerica.com.mx<T>+NuevaLinea+<T>www.viu.com.mx<T>+Nuevalinea+<T>www.mavi.mx<T>+NuevaLinea+Nuevalinea+NuevaLinea+<T>______________________________________________________<T>+Nuevalinea+Nuevalinea+<T>Copyright(c) 2010 Comercializadora de Muebles America S.A. de C.V.<T>+NuevaLinea+<T>Derechos Reservado<CONTINUA>
Expresion002=<CONTINUA>s<T>)
[Acciones.ServicasaCrMY]
Nombre=ServicasaCrMY
Boton=0
NombreDesplegar=Servicasa Cr�dito Mayoreo
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Formas
ClaveAccion=MaviServicasaCrMayFrm
Activo=S
Visible=S
Menu=&Exploradores
UsaTeclaRapida=S
TeclaRapida=Ctrl+F9
Antes=S
AntesExpresiones=Asigna(Mavi.ServicredMayExplora,0)
[Acciones.NotasCobranzatelefonica]
Nombre=NotasCobranzatelefonica
Boton=0
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=F8
NombreDesplegar=Notas Cobranza Telefonica
EnMenu=S
TipoAccion=Formas
ClaveAccion=MAviServicasaServicredCredNotasCobranzaFrm
Activo=S
Antes=S
Visible=S
ConCondicion=S
EjecucionCondicion=Condatos(MaviServicredCrMayVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
EjecucionConError=S
AntesExpresiones=Asigna(Info.cliente,MaviServicredCrMayVis:Cliente)
[Acciones.NotasCobranza]
Nombre=NotasCobranza
Boton=0
Menu=&Ver
NombreDesplegar=Notas Cobranza
EnMenu=S
TipoAccion=Formas
ClaveAccion=CtaBitacora
Activo=S
Antes=S
Visible=S
ConCondicion=S
EjecucionCondicion=Condatos(MaviServicredCrMayVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
EjecucionConError=S
AntesExpresiones=Asigna(Info.Modulo, <T>CXC<T>)<BR>Asigna(Info.Tipo, SQL(<T>Select Tipo From Cte Where Cliente=:tval1<T>,MaviServicredCrMayVis:Cliente))<BR>Asigna(Info.Cuenta, MaviServicredCrMayVis:Cliente)<BR>Asigna(Info.Descripcion, MaviServicredCrMayVis:Nombre)<BR>Asigna(Info.PuedeEditar, Falso)
[ServicredCrMay.Poblacion]
Carpeta=ServicredCrMay
Clave=Poblacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[ServicredCrMay.FechaAlta]
Carpeta=ServicredCrMay
Clave=FechaAlta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=38
ColorFondo=Blanco
ColorFuente=Negro
[ServicredCrMay.Seguimiento]
Carpeta=ServicredCrMay
Clave=Seguimiento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.ActualizarSCR.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.ActualizarSCR.Exp]
Nombre=Exp
Boton=0
TipoAccion=Expresion
Expresion=ActualizarVista(<T>MaviServicredCrMayVis<T>)
Activo=S
Visible=S
[Filtros]
Estilo=Ficha
Clave=Filtros
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.DM0112Mov<BR>Mavi.DM0112Situacion<BR>Mavi.DM0112Estatus<BR>Mavi.FechaI<BR>Mavi.FechaF<BR>Mavi.DM0112Busqueda<BR>Mavi.DM0112ComboBusquedaMay
CarpetaVisible=S
[Filtros.Mavi.DM0112Mov]
Carpeta=Filtros
Clave=Mavi.DM0112Mov
Editar=S
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
[Filtros.Mavi.DM0112ComboBusquedaMay]
Carpeta=Filtros
Clave=Mavi.DM0112ComboBusquedaMay
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

