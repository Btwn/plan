[Forma]
Clave=MaviServicredCredFrm
Nombre=Info.UENMAVI+<T> SERVICRED CRÉDITO<T>+<T> SUCURSAL <T>+Sucursal+<T><T>+Ahora
Icono=746
Menus=S
BarraHerramientas=S
Modulos=VTAS
MovModulo=VTAS
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=Sucursal<BR>Filtros<BR>ServicredCred<BR>Detalle
CarpetaPrincipal=ServicredCred
PosicionInicialIzquierda=-8
PosicionInicialArriba=-8
PosicionInicialAlturaCliente=750
PosicionInicialAncho=1296
ListaAcciones=AbrirMovSCR<BR>NuevoSCR<BR>InfoCteSCR<BR>CteCtoSCR<BR>Cohincidenciass<BR>CalificacionSCR<BR>Kardex<BR>MovPosSCR<BR>MovBitacoraSCR<BR>MovTiempoSCR<BR>AgregarEventoSCR<BR>RelacionCteSCR<BR>InfoCteRelacionadoSCR<BR>RepHistorialCteSCR<BR>RegistroCte<BR>ReporteServicred<BR>NotasCobranzatelefonica<BR>NotasCobranza<BR>ServicasaCred<BR>Excel<BR>ActualizarSCR<BR>PersonalizarSCR<BR>AcercadeSCR<BR>Cerrar<BR>RepCredAnua<BR>RM0855A<BR>RM1124<BR>RM1127<BR>ConsultaINTL<BR>ACD00017VisorMavi<BR>ACD00019EvaluacionCalidad
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
PosicionSec1=95
PosicionSec2=500
AccionesDivision=S
Comentarios=Usuario
PosicionCol2=100
VentanaAjustarZonas=S
VentanaAvanzaTab=S
EsMovimiento=S
TituloAuto=S
MovEspecificos=Especificos
MovimientosValidos=Solicitud Credito<BR>Analisis Credito<BR>Solicitud Devolucion<BR>Sol Dev Unicaja<BR>Factura<BR>Factura VIU<BR>Credilana<BR>Prestamo Personal<BR>Seguro Vida<BR>Seguro Auto<BR>Pedido
EsConsultaExclusiva=S
FiltrarFechasSinHora=S
CarpetasMultilinea=S
PosicionCol1=750
ExpresionesAlMostrar=Asigna(Mavi.DM0112Mov,<T>Solicitud Credito<T>)<BR>Asigna(Mavi.DM0112Estatus,<T>PENDIENTE<T>)<BR>Asigna(Mavi.DM0112Situacion,nulo)<BR>Asigna(Mavi.FechaI,FechaDMA(SQL(<T>Select GetDate()<T>)))<BR>Asigna(Mavi.FechaF,FechaDMA(SQL(<T>Select GetDate()<T>)))<BR>Asigna(Mavi.DM0112Busqueda,nulo)<BR>Asigna(Mavi.ServicasaMayExplora,0)<BR>Si(Sql(<T>Exec sp_MaviDM0112IniUs :tusu <T>,usuario) <> <T>Error<T>,<T><T>,informacion(<T>Error al inicializar usuario<T>))<BR>Asigna(Mavi.Sucursal, SQL(<T>Select Sucursal from Usuario Where Usuario = :tUsu<T>, Usuario))<BR>Asigna(Mavi.DM0112ComboBusqueda, <T>MovID<T>)

MenuPrincipal=&Archivo<BR>&Exploradores<BR>&Edicion<BR>&Ver<BR>&Reportes<BR>&Ayuda
[ServicredCred]
Estilo=Iconos
Clave=ServicredCred
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=MaviServicredCredVis
Fuente={Tahoma, 8, Rojo obscuro, [Negritas]}
IconosCampo=(Situación)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=500
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
IconosSubTitulo=<T>Movimiento<T>
ListaAcciones=AbrirMovDSCR<BR>NuevoDSCR<BR>InfoCteDSCR<BR>CteCtoDSCR<BR>MovPosDSCR<BR>MovBitacoraDSCR<BR>MovTiempoDSCR<BR>Tiempo Total<BR>AgregarEventoDSCR<BR>RelacionCteDSCR<BR>PersonalizarDSCR<BR>CitaSup<BR>Monedero<BR>HojaV<BR>Reanalisis<BR>ctefinal<BR>ConsultaBC<BR>InvesTelefonica<BR>VisorSA<BR>VisorSC<BR>VisorBA<BR>VisorBC<BR>VisorIA<BR>VisorIC
ConFuenteEspecial=S
ConFuenteEspecial=S
FiltroPredefinido1=Solicitud Crédito<BR>Analisis Crédito
FiltroPredefinido2=Mov=<T>Solicitud Credito<T><BR>Mov=<T>Analisis Credito<T>
FiltroPredefinido3=ID Desc<BR>ID Desc
ListaEnCaptura=IDEcommerce<BR>SucursalOrigen<BR>Cliente<BR>Nombre<BR>TextoAmostrar<BR>VTACambaceo<BR>CanalVenta<BR>Autorizacion<BR>EstatusConvenio<BR>Relacionado<BR>CrLib<BR>TiempoTotalTranscurrido<BR>Estatus<BR>Situacion<BR>%Supervision<BR>Reactivacion<BR>Grupo<BR>Condicion<BR>ImporteTotal<BR>Monedero<BR>ReferenciaAnterior<BR>FechaAlta<BR>FUM<BR>Agente<BR>Seguimiento<BR>Calificacion<BR>Observaciones<BR>Fech. Alta. a Fech. Ult. Mod.<BR>Fech. Ult. Mod. a Fech. Act.
IconosConRejilla=S





IconosNombre=MaviServicredCredVis:Mov+<T> <T>+MaviServicredCredVis:MovID
[ServicredCred.Columnas]
0=168
1=165
2=218
3=231
4=-2
5=119
6=117
7=67
8=143
9=-2
10=346
11=92
12=144
13=-2
14=178
15=-2
16=393
17=-2
18=91
19=-2
20=-2
21=127
22=87
23=101
24=-2
25=-2
26=-2
27=98
28=-2
29=-2
[Acciones.ServicasaCred]
Nombre=ServicasaCred
Boton=2
NombreDesplegar=Servicasa Crédito
TipoAccion=Formas
Activo=S
Visible=S
NombreEnBoton=S
ClaveAccion=MaviServicasaCredFrm
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
Fuente={Tahoma, 8, Rojo obscuro, [Negritas]}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
Detalle=S
Vista=MaviServicredTCVis
VistaMaestra=MaviServicredCredVis
LlaveLocal=ID
LlaveMaestra=ID
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSubTitulo=<T>Fecha<T>
ListaEnCaptura=CALIFICACION<BR>Observaciones<BR>USUARIO
IconosConRejilla=S
ConFuenteEspecial=S
OtroOrden=S
ListaOrden=FECHA<TAB>(Decendente)
IconosNombre=MaviServicredTCVis:FECHA
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
TipoAccion=expresion
ConCondicion=S
EjecucionConError=S
Expresion=Asigna(Info.ID,MaviServicredCredVis:Id)<BR>Asigna(Info.Mov,MaviServicredCredVis:Mov)<BR>Asigna(Info.Movid,MaviServicredCredVis:Movid)<BR>Asigna(Info.Situacion,MaviServicredCredVis:Situacion)<BR>Asigna(Mavi.TipoCliente,MaviServicredCredVis:MaviTipoVenta)<BR>Asigna(Info.Estatus,MaviServicredCredVis:Estatus)
EjecucionCondicion=Condatos(MaviServicredCredVis:Id)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
[Acciones.AbrirMovSCR.FrmAbrirMovSCR]
Nombre=FrmAbrirMovSCR
Boton=0
Activo=S
Visible=S
TipoAccion=expresion
ConCondicion=S
EjecucionConError=S
Expresion=Asigna(Mavi.ServicasaModulo,4)<BR>Si sql(<T>select count(*) from MaviDM0112USCA where usuario = :tUsuario<T>, Usuario)=0<BR>    entonces<BR>        FormaPos(<T>Venta<T>,Vacio(Info.ID,0))<BR>        sql(<T>Exec sp_MaviDM0112BUSC :tUsuario<T>,Usuario)<BR>        sql(<T>Exec sp_MaviDM0112GUSC :tusu,:tmov,:tmovid,:nid <T>,usuario,MaviServicredCredVis:Mov,MaviServicredCredVis:Movid,MaviServicredCredVis:Id)<BR>    sino<BR>        Si sql(<T>select Folio from MaviDM0112usca where Usuario = :tUsuario <T>, Usuario)=(MaviServicredCredVis:Mov+<T> <T>+MaviServicredCredVis:Movid)<BR>            Entonces<BR>                FormaPos(<T>Venta<T>,Vacio(Info.ID,0))<BR>            Sino<BR>                Error(<T>Existe un Movimiento abierto por este Usuario<T>)<BR>                FormaPos(<T>Venta<T>,Vacio(I<CONTINUA>
Expresion002=<CONTINUA>nfo.ID,0))<BR>        Fin<BR>Fin
EjecucionCondicion=(sql(<T>Exec sp_MaviDM0112CUSC :tmov,:tmovid,:nid <T>,MaviServicredCredVis:Mov,MaviServicredCredVis:Movid,MaviServicredCredVis:Id) = <T>Disponible<T><BR>y Condatos(Info.ID))<BR>o (sql(<T>select Usuario from MaviDM0112usca where Mov = :tMov and MovID = :tMovid <T>, MaviServicredCredVis:Mov,MaviServicredCredVis:Movid)=Usuario)
EjecucionMensaje=<T>Movimiento ocupado por otro usuario<T>
[Acciones.AbrirMovSCR]
Nombre=AbrirMovSCR
Boton=2
NombreDesplegar=&Abrir
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=AsigAbrirMovSCR<BR>FrmAbrirMovSCR
Visible=S
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Ctrl+A
EnMenu=S
Antes=S
Activo=S
AntesExpresiones=//Limpiamos todas las variables antes de cargar el movimiento<BR>ASigna(Info.ID,nulo)<BR>Asigna(Info.Mov,nulo)<BR>Asigna(Info.MovID,nulo)<BR>Asigna(Info.Situacion,nulo)<BR>Asigna(Mavi.TipoCliente,nulo)<BR>Asigna(Info.Estatus,nulo)
[Acciones.InfoCteSCR.AsigInfoCteSCR]
Nombre=AsigInfoCteSCR
Boton=0
Activo=S
Visible=S
TipoAccion=expresion
Expresion=Asigna(Info.ClienteD,MaviServicredCredVis:Cliente)<BR>Asigna(Info.Cliente,MaviServicredCredVis:Cliente)
[Acciones.InfoCteSCR.FrmInfoCteSCR]
Nombre=FrmInfoCteSCR
Boton=0
Activo=S
Visible=S
TipoAccion=Formas
ClaveAccion=CteInfo
[Acciones.InfoCteSCR]
Nombre=InfoCteSCR
Boton=34
NombreDesplegar=&Información del Cliente
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=AsigInfoCteSCR<BR>FrmInfoCteSCR
Activo=S
Visible=S
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=Ctrl+I
EnMenu=S
ConCondicion=S
EjecucionConError=S
Antes=S
EjecucionCondicion=Condatos(MaviServicredCredVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
AntesExpresiones=Asigna(Info.Cliente,nulo)
[Acciones.CteCtoSCR.AsigCteCtoSCR]
Nombre=AsigCteCtoSCR
Boton=0
Activo=S
Visible=S
TipoAccion=Expresion
Expresion=Asigna(Info.Cliente,MaviServicredCredVis:CLIENTE)<BR>Asigna(Info.ClienteD,MaviServicredCredVis:Cliente)
[Acciones.CteCtoSCR.FrmCteCtoSCR]
Nombre=FrmCteCtoSCR
Boton=0
Activo=S
Visible=S
TipoAccion=Formas
ClaveAccion=MaviServicasaCteCtoFrm
[Acciones.CteCtoSCR]
Nombre=CteCtoSCR
Boton=60
NombreDesplegar=&Contactos
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=AsigCteCtoSCR<BR>FrmCteCtoSCR
Activo=S
Visible=S
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=Ctrl+C
EnMenu=S
ConCondicion=S
EjecucionConError=S
Antes=S
EjecucionCondicion=Condatos(MaviServicredCredVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
AntesExpresiones=Asigna(Info.Cliente,nulo)
[Acciones.MovPosSCR.AsigMovPosSCR]
Nombre=AsigMovPosSCR
Boton=0
Activo=S
Visible=S
TipoAccion=Expresion
Expresion=Asigna(Info.ID,MaviServicredCredVis:ID)<BR>Asigna(Info.Modulo,<T>VTAS<T>)
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
EjecucionConError=S
Antes=S
EjecucionCondicion=Condatos(MaviServicredCredVis:Id)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
AntesExpresiones=Asigna(Info.ID,nulo)<BR>Asigna(Info.Modulo,nulo)
[Acciones.MovBitacoraSCR.AsigMovBitacoraSCR]
Nombre=AsigMovBitacoraSCR
Boton=0
Activo=S
Visible=S
TipoAccion=Expresion
Expresion=Asigna(Info.Modulo, <T>VTAS<T>)<BR>Asigna(Info.ID, MaviServicredCredVis:ID)
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
EjecucionConError=S
Antes=S
EjecucionCondicion=Condatos(MaviServicredCredVis:Id)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
AntesExpresiones=Asigna(Info.Modulo,nulo)<BR>Asigna(Info.ID, nulo)
[Acciones.MovTiempoSCR.AsigMovTiempoSCR]
Nombre=AsigMovTiempoSCR
Boton=0
Activo=S
Visible=S
TipoAccion=Expresion
Expresion=Asigna(Info.Modulo, <T>VTAS<T>)<BR>Asigna(Info.ID, MaviServicredCredVis:ID)<BR>Asigna(Info.Mov,MaviServicredCredVis:Mov)<BR>Asigna(Info.MovID,MaviServicredCredVis:MovID)
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
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=Ctrl+T
EnMenu=S
ConCondicion=S
EjecucionConError=S
Antes=S
EjecucionCondicion=Condatos(MaviServicredCredVis:Id)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
AntesExpresiones=Asigna(Info.Modulo, nulo)<BR>Asigna(Info.ID, nulo)<BR>Asigna(Info.Mov,nulo)<BR>Asigna(Info.MovID,nulo)
[Acciones.AgregarEventoSCR.AsigAgregarEventoSCR]
Nombre=AsigAgregarEventoSCR
Boton=0
Activo=S
Visible=S
TipoAccion=Expresion
ConCondicion=S
EjecucionConError=S
Expresion=Asigna(Info.Mov,MaviServicredCredVis:Mov)<BR>Asigna(Info.MovID,MaviServicredCredVis:MovID)<BR>Asigna(Info.ID,MaviServicredCredVis:ID)<BR>Asigna(Info.Modulo, <T>VTAS<T>)
EjecucionCondicion=1=1<BR>/*Asigna(Mavi.ServicasaConfigUsr1,SQL(<T>SELECT ACCESO FROM USUARIO WHERE USUARIO=:tval1<T>,Usuario))<BR>Asigna(Mavi.ServicasaGrupoCalif,(SQL(<T>EXEC SP_MAVIULTIMACALIFICACION :nval1,:tval2<T>,MaviServicredCredVis:Id,<T>Vtas<T>)))<BR>((MaviServicredCredVis:Estatus<>EstatusCancelado) y ((Mavi.ServicasaConfigUsr1=<T>CREDI_GERA<T>) o (Mavi.ServicasaConfigUsr1=<T>CREDI_GERB<T>) o (Mavi.ServicasaConfigUsr1=<T>CREDI_USRA<T>) o (Mavi.ServicasaConfigUsr1=<T>COBMA_GERA<T>) o (Mavi.ServicasaConfigUsr1=<T>COBMA_USRA<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTR_GERA<T>) y (Mavi.ServicasaGrupoCalif=<T>D<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTP_GERA<T>) y (Mavi.ServicasaGrupoCalif=<T>C<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTP_SUPA<T>) y (Mavi.ServicasaGrupoCalif=<T>C<T>)) o ((Mavi.ServicasaConf<CONTINUA>
EjecucionCondicion002=<CONTINUA>igUsr1=<T>VENTI_GERA<T>) y (Mavi.ServicasaGrupoCalif=<T>C<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTC_GERA<T>) y (Mavi.ServicasaGrupoCalif=<T>C<T>)) o (Mavi.ServicasaConfigUsr1=<T>VENTC_USRA<T>) o (Mavi.ServicasaConfigUsr1 =<T>MAVI<T>) o (Mavi.ServicasaConfigUsr1 en (<T>COBMA_GERA<T>,<T>COBMA_USRA<T>))))<BR>*/
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
EjecucionCondicion=Condatos(MaviServicredCredVis:Id)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
AntesExpresiones=Asigna(Info.Modulo, <T>VTAS<T>)<BR>Asigna(Info.Mov,nulo)<BR>Asigna(Info.MovID,nulo)<BR>Asigna(Info.ID,nulo)
[Acciones.RelacionCteSCR.AsigRelacionCteSCR]
Nombre=AsigRelacionCteSCR
Boton=0
Activo=S
Visible=S
TipoAccion=Expresion
Expresion=Asigna(Info.Cliente,MaviServicredCredVis:CLIENTE)<BR>Asigna(Info.ClienteD,MaviServicredCredVis:Cliente)
[Acciones.RelacionCteSCR.FrmRelacionCteSCR]
Nombre=FrmRelacionCteSCR
Boton=0
Activo=S
Visible=S
TipoAccion=Formas
ClaveAccion=CteRelacion
[Acciones.RelacionCteSCR]
Nombre=RelacionCteSCR
Boton=90
NombreDesplegar=&Relaciones
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=AsigRelacionCteSCR<BR>FrmRelacionCteSCR
Activo=S
Visible=S
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=Ctrl+R
EnMenu=S
ConCondicion=S
EjecucionConError=S
Antes=S
EjecucionCondicion=Condatos(MaviServicredCredVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
AntesExpresiones=Asigna(Info.Cliente,nulo)
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
ListaAccionesMultiples=Variables Asignar<BR>Expresion
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
TipoAccion=expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Asigna(Info.ID,MaviServicredCredVis:Id)<BR>Asigna(Info.Mov,MaviServicredCredVis:Mov)<BR>Asigna(Info.Movid,MaviServicredCredVis:Movid)<BR>Asigna(Info.Situacion,MaviServicredCredVis:Situacion)<BR>Asigna(Mavi.TipoCliente,MaviServicredCredVis:MaviTipoVenta)<BR>Asigna(Info.Estatus,MaviServicredCredVis:Estatus)
EjecucionCondicion=Condatos(MaviServicredCredVis:Id)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
[Acciones.AbrirMovDSCR.FrmAbrirMovDSCR]
Nombre=FrmAbrirMovDSCR
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Asigna(Mavi.ServicasaModulo,4)<BR>Si sql(<T>select count(*) from MaviDM0112USCA where usuario = :tUsuario<T>, Usuario)=0<BR>    entonces<BR>        FormaPos(<T>Venta<T>,Vacio(Info.ID,0))<BR>        sql(<T>Exec sp_MaviDM0112BUSC :tUsuario<T>,Usuario)<BR>        sql(<T>Exec sp_MaviDM0112GUSC :tusu,:tmov,:tmovid,:nid <T>,usuario,MaviServicredCredVis:Mov,MaviServicredCredVis:Movid,MaviServicredCredVis:Id)<BR>    sino<BR>        Si sql(<T>select Folio from MaviDM0112usca where Usuario = :tUsuario <T>, Usuario)=(MaviServicredCredVis:Mov+<T> <T>+MaviServicredCredVis:Movid)<BR>            Entonces<BR>                FormaPos(<T>Venta<T>,Vacio(Info.ID,0))<BR>            Sino<BR>                Error(<T>Existe un Movimiento abierto por este Usuario<T>)<BR>                FormaPos(<T>Venta<T>,Vacio(I<CONTINUA>
Expresion002=<CONTINUA>nfo.ID,0))<BR>        Fin<BR>Fin
EjecucionCondicion=(sql(<T>Exec sp_MaviDM0112CUSC :tmov,:tmovid,:nid <T>,MaviServicredCredVis:Mov,MaviServicredCredVis:Movid,MaviServicredCredVis:Id) = <T>Disponible<T><BR>y Condatos(Info.ID))<BR>o (sql(<T>select Usuario from MaviDM0112usca where Mov = :tMov and MovID = :tMovid <T>, MaviServicredCredVis:Mov,MaviServicredCredVis:Movid)=Usuario)
EjecucionMensaje=<T>Movimiento ocupado por otro usuario<T>
[Acciones.AbrirMovDSCR]
Nombre=AbrirMovDSCR
Boton=0
NombreDesplegar=&Abrir
Multiple=S
ListaAccionesMultiples=AsigAbrirMovDSCR<BR>FrmAbrirMovDSCR
Visible=S
EnMenu=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+A
Antes=S
Activo=S
AntesExpresiones=Asigna(Info.ID,nulo)<BR>Asigna(Info.Mov,nulo)<BR>Asigna(Info.MovID,nulo)<BR>Asigna(Info.Situacion,nulo)<BR>Asigna(Mavi.TipoCliente,nulo)<BR>Asigna(Info.Estatus,nulo)
[Acciones.InfoCteDSCR]
Nombre=InfoCteDSCR
Boton=0
EnMenu=S
Activo=S
Visible=S
NombreDesplegar=&Información del Cliente
Multiple=S
ListaAccionesMultiples=AsigInfoCteDSC<BR>FrmInfoCteDSC
UsaTeclaRapida=S
TeclaRapida=Ctrl+I
ConCondicion=S
EjecucionCondicion=Condatos(MaviServicredCredVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
EjecucionConError=S
Antes=S
AntesExpresiones=Asigna(Info.Cliente,nulo)
[Acciones.InfoCteDSCR.AsigInfoCteDSC]
Nombre=AsigInfoCteDSC
Boton=0
TipoAccion=expresion
Expresion=Asigna(Info.Cliente,MaviServicredCredVis:CLIENTE)
Activo=S
Visible=S
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
Expresion=Asigna(Info.Cliente,MaviServicredCredVis:CLIENTE)
[Acciones.CteCtoDSCR.FrmCteCtoDSCR]
Nombre=FrmCteCtoDSCR
Boton=0
TipoAccion=Formas
ClaveAccion=MaviServicasaCteCtoFrm
Activo=S
Visible=S
[Acciones.CteCtoDSCR]
Nombre=CteCtoDSCR
Boton=0
NombreDesplegar=&Contactos
Multiple=S
EnMenu=S
ListaAccionesMultiples=AsigCteCtoDSCR<BR>FrmCteCtoDSCR
Activo=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+C
ConCondicion=S
EjecucionCondicion=Condatos(MaviServicredCredVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
EjecucionConError=S
Antes=S
AntesExpresiones=Asigna(Info.Cliente,nulo)
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
Activo=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+S
ConCondicion=S
EjecucionConError=S
Antes=S
ListaAccionesMultiples=AsigMovPosDSCR<BR>FrmMovPosDSCR
EjecucionCondicion=Condatos(MaviServicredCredVis:Id)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
AntesExpresiones=Asigna(Info.ID,nulo)<BR>Asigna(Info.Modulo,nulo)
[Acciones.MovBitacoraDSCR.AsigMovBitacoraDSCR]
Nombre=AsigMovBitacoraDSCR
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Info.Modulo, <T>VTAS<T>)<BR>Asigna(Info.ID, MaviServicredCredVis:ID)
Activo=S
Visible=S
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
EjecucionCondicion=Condatos(MaviServicredCredVis:Id)
EjecucionMensaje=Asigna(Info.Modulo, <T>VTAS<T>)<BR>Asigna(Info.ID, MaviServicredCredVis:ID)
EjecucionConError=S
Antes=S
AntesExpresiones=Asigna(Info.Modulo,nulo)<BR>Asigna(Info.ID, nulo)
[Acciones.MovTiempoDSCR.AsigMovTiempoDSCR]
Nombre=AsigMovTiempoDSCR
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Info.Modulo, <T>VTAS<T>)<BR>Asigna(Info.ID,MaviServicredCredVis:ID)
Activo=S
Visible=S
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
EjecucionCondicion=Condatos(MaviServicredCredVis:Id)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
EjecucionConError=S
Antes=S
AntesExpresiones=Asigna(Info.Modulo,nulo)<BR>Asigna(Info.ID,nulo)
[Acciones.AgregarEventoDSCR.AsigAgregarEventoDSCR]
Nombre=AsigAgregarEventoDSCR
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Asigna(Info.Mov,MaviServicredCredVis:Mov)<BR>Asigna(Info.MovID,MaviServicredCredVis:MovID)<BR>Asigna(Info.ID,MaviServicredCredVis:ID)<BR>Asigna(Info.Modulo,<T>VTAS<T>)
EjecucionCondicion=Asigna(Mavi.ServicasaConfigUsr1,SQL(<T>SELECT ACCESO FROM USUARIO WHERE USUARIO=:tval1<T>,Usuario))<BR>Asigna(Mavi.ServicasaGrupoCalif,(SQL(<T>EXEC SP_MAVIULTIMACALIFICACION :nval1,:tval2<T>,MaviServicredCredVis:Id,<T>Vtas<T>)))<BR>((MaviServicredCredVis:Estatus<>EstatusCancelado) y ((Mavi.ServicasaConfigUsr1=<T>CREDI_GERA<T>) o (Mavi.ServicasaConfigUsr1=<T>CREDI_GERB<T>) o (Mavi.ServicasaConfigUsr1=<T>CREDI_USRA<T>) o (Mavi.ServicasaConfigUsr1=<T>COBMA_GERA<T>) o (Mavi.ServicasaConfigUsr1=<T>COBMA_USRA<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTR_GERA<T>) y (Mavi.ServicasaGrupoCalif=<T>D<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTP_GERA<T>) y (Mavi.ServicasaGrupoCalif=<T>C<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTP_SUPA<T>) y (Mavi.ServicasaGrupoCalif=<T>C<T>)) o ((Mavi.ServicasaConfigUsr1=<T<CONTINUA>
EjecucionCondicion002=<CONTINUA>>VENTP_GECO<T>) y (Mavi.ServicasaGrupoCalif=<T>C<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTI_GERA<T>) y (Mavi.ServicasaGrupoCalif=<T>C<T>)) o ((Mavi.ServicasaConfigUsr1=<T>VENTC_GERA<T>) y (Mavi.ServicasaGrupoCalif=<T>C<T>)) o (Mavi.ServicasaConfigUsr1=<T>VENTC_USRA<T>) o (Mavi.ServicasaConfigUsr1 =<T>MAVI<T>) o (Mavi.ServicasaConfigUsr1 en (<T>COBMA_GERA<T>,<T>COBMA_USRA<T>))))
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
EjecucionCondicion=Condatos(MaviServicredCredVis:Id)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
AntesExpresiones=Asigna(Info.Mov,nulo)<BR>Asigna(Info.MovID,nulo)<BR>Asigna(Info.ID,nulo)<BR>Asigna(Info.Modulo,<T>VTAS<T>)
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
EjecucionCondicion=Condatos(MaviServicredCredVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
EjecucionConError=S
Antes=S
AntesExpresiones=Asigna(Info.Cliente,nulo)
[Acciones.RelacionCteDSCR.AsigRelacionCteDSCR]
Nombre=AsigRelacionCteDSCR
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Info.Cliente,MaviServicredCredVis:CLIENTE)
Activo=S
Visible=S
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
Carpeta=(Carpeta principal)
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
[Detalle.CALIFICACION]
Carpeta=Detalle
Clave=CALIFICACION
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco
[Detalle.USUARIO]
Carpeta=Detalle
Clave=USUARIO
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
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
0=286
1=335
[Acciones.Cohincidenciass]
Nombre=Cohincidenciass
Boton=80
NombreDesplegar=C&oincidencias
EnBarraHerramientas=S
TipoAccion=Formas
Activo=S
Visible=S
ClaveAccion=EspecificarClienteMAVI
Multiple=S
ListaAccionesMultiples=AsignaValorCoinSCR<BR>LlamaFormaCoinCSCR
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=Ctrl+O
EnMenu=S
ConCondicion=S
EjecucionConError=S
Antes=S
EjecucionCondicion=Condatos(MaviServicredCredVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
AntesExpresiones=Asigna(Info.ClienteD,nulo)
[Acciones.Kardex]
Nombre=Kardex
Boton=0
NombreDesplegar=RM855 Kardex por Cliente
EnMenu=S
TipoAccion=expresion
Activo=S
Visible=S
Menu=&Reportes
UsaTeclaRapida=S
TeclaRapida=F11
ConCondicion=S
EjecucionConError=S
Antes=S
Expresion=Ejecutar(<T>PlugIns\KardexXCliente.exe <T>+Usuario+<T> <T>+EstacionTrabajo+<T> <T>+MaviServicredCredVis:Cliente+<T> <T>+MaviServicredCredVis:ID_Direccionado)
EjecucionCondicion=Condatos(MaviServicredCredVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
AntesExpresiones=Asigna(Info.Cliente,nulo)<BR>Asigna(Info.Numero,0)
[Acciones.Kardex.AsignaValSC]
Nombre=AsignaValSC
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Cliente,MaviServicredCredVis:CLIENTE)<BR>Asigna(Info.ClienteD,MaviServicredCredVis:Cliente)<BR>Asigna(Info.ID,MaviServicredCredVis:ID_Direccionado)
[Acciones.Cohincidenciass.AsignaValorCoinSCR]
Nombre=AsignaValorCoinSCR
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.ClienteD,MaviServicredCredVis:CLIENTE)<BR>Asigna(Info.Cliente,MaviServicredCredVis:Cliente)
[Acciones.Cohincidenciass.LlamaFormaCoinCSCR]
Nombre=LlamaFormaCoinCSCR
Boton=0
TipoAccion=Formas
ClaveAccion=CteRelacionMavi
Activo=S
Visible=S
[Acciones.RepHistorialCteSCR]
Nombre=RepHistorialCteSCR
Boton=0
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=F3
NombreDesplegar=Historial Solicitudes
EnMenu=S
TipoAccion=Reportes Pantalla
ClaveAccion=MaviServicasaServiCredCreditoVentaAnalisisMovDetalleRep
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=AsignaCteHSSCR<BR>FormaHSSCR
ConCondicion=S
EjecucionConError=S
Antes=S
EjecucionCondicion=Condatos(MaviServicredCredVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
AntesExpresiones=Asigna(Info.cliente,nulo)<BR>Asigna(Mavi.TipoCliente,nulo)
[Acciones.InfoCteRelacionadoSCR]
Nombre=InfoCteRelacionadoSCR
Boton=108
NombreDesplegar=In&formación Relacionado
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=CteInfo
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=AsignaRelacionadoSCR<BR>FormaInfoCteRelacionado
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=Ctrl+F
EnMenu=S
ConCondicion=S
EjecucionConError=S
Antes=S
EjecucionCondicion=Condatos(MaviServicredCredVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
AntesExpresiones=Asigna(Info.Cliente,nulo)
[Acciones.InfoCteRelacionadoSCR.AsignaRelacionadoSCR]
Nombre=AsignaRelacionadoSCR
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Asigna(Info.Cliente,MaviServicredCredVis:Relacionado)<BR>Asigna(Info.ClienteD,MaviServicredCredVis:Relacionado)
EjecucionCondicion=Condatos(MaviServicredCredVis:Relacionado)
EjecucionMensaje=<T>El ciente del movimiento seleccionado no tiene un relacionado registrado<T>
[Acciones.InfoCteRelacionadoSCR.FormaInfoCteRelacionado]
Nombre=FormaInfoCteRelacionado
Boton=0
TipoAccion=Formas
ClaveAccion=CteInfo
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=1=1//(condatos((SQL(<T>Select Cliente from Cte where Cliente=:tval1<T>,Info.cliente))))
EjecucionMensaje=<T>El prospecto: <T>+MaviServicredCredVis:CLIENTE+<T> no tiene registrado un relacionado valido<T>
[Detalle.Observaciones]
Carpeta=Detalle
Clave=Observaciones
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco
[Acciones.CalificacionSCR]
Nombre=CalificacionSCR
Boton=41
NombreDesplegar=Calificación
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=Variables Asignar SCR<BR>ExpresionCalifSCR<BR>ExploradorCalifSCR
Antes=S
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=F7
EnMenu=S
AntesExpresiones=Asigna(Info.Cliente,MaviServicredCredVis:Cliente)
[Acciones.RepHistorialCteSCR.AsignaCteHSSCR]
Nombre=AsignaCteHSSCR
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Cliente,MaviServicredCredVis:Cliente)<BR>Asigna(Info.ClienteD,MaviServicredCredVis:Cliente)<BR>Asigna(Mavi.TipoCliente,MaviServicredCredVis:MaviTipoVenta)
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
ConCondicion=S
EjecucionCondicion=Condatos(MaviServicredCredVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
EjecucionConError=S
[Acciones.CalificacionSCR.ExpresionCalifSCR]
Nombre=ExpresionCalifSCR
Boton=0
TipoAccion=Expresion
Expresion=EjecutarSQL(<T>spCalificaCtesxFacturaMAVI  :tCte<T>,Info.Cliente)
Activo=S
Visible=S
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
[Acciones.ReporteServicred]
Nombre=ReporteServicred
Boton=0
Menu=&Reportes
NombreDesplegar=Reporte Servicred
EnMenu=S
TipoAccion=Reportes Pantalla
ClaveAccion=MaviServicredCredReporteServicredRep
Activo=S
Visible=S
[Acciones.NuevoSCR]
Nombre=NuevoSCR
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
Expresion=Asigna(Mavi.ServicasaCapDetallVentas,0)<BR>Asigna(Mavi.ServicasaMovNvo,1020)<BR>Forma(<T>Venta<T>)
[Acciones.NuevoDSCR]
Nombre=NuevoDSCR
Boton=0
NombreDesplegar=&Nuevo
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+N
Expresion=Asigna(Mavi.ServicasaCapDetallVentas,0)<BR>Asigna(Mavi.ServicasaMovNvo,1020)<BR>Forma(<T>Venta<T>)
[ServicredCred.Condicion]
Carpeta=ServicredCred
Clave=Condicion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
[ServicredCred.Situacion]
Carpeta=ServicredCred
Clave=Situacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
[ServicredCred.Estatus]
Carpeta=ServicredCred
Clave=Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=
ColorFondo=Blanco
[ServicredCred.Cliente]
Carpeta=ServicredCred
Clave=Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
[ServicredCred.Nombre]
Carpeta=ServicredCred
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
[ServicredCred.Relacionado]
Carpeta=ServicredCred
Clave=Relacionado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
[ServicredCred.Agente]
Carpeta=ServicredCred
Clave=Agente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
[ServicredCred.Fech. Alta. a Fech. Ult. Mod.]
Carpeta=ServicredCred
Clave=Fech. Alta. a Fech. Ult. Mod.
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[ServicredCred.Fech. Ult. Mod. a Fech. Act.]
Carpeta=ServicredCred
Clave=Fech. Ult. Mod. a Fech. Act.
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[ServicredCred.Calificacion]
Carpeta=ServicredCred
Clave=Calificacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco
[ServicredCred.Reactivacion]
Carpeta=ServicredCred
Clave=Reactivacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=
ColorFondo=Blanco
[ServicredCred.Observaciones]
Carpeta=ServicredCred
Clave=Observaciones
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco
[ServicredCred.Grupo]
Carpeta=ServicredCred
Clave=Grupo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=2
ColorFondo=Blanco
[ServicredCred.CanalVenta]
Carpeta=ServicredCred
Clave=CanalVenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
[ServicredCred.SucursalOrigen]
Carpeta=ServicredCred
Clave=SucursalOrigen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
[ServicredCred.ReferenciaAnterior]
Carpeta=ServicredCred
Clave=ReferenciaAnterior
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=82
ColorFondo=Blanco
[ServicredCred.ImporteTotal]
Carpeta=ServicredCred
Clave=ImporteTotal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
Totalizador=1
[ServicredCred.FUM]
Carpeta=ServicredCred
Clave=FUM
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=38
ColorFondo=Blanco
[ServicredCred.Seguimiento]
Carpeta=ServicredCred
Clave=Seguimiento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco
[Acciones.RegistroCte]
Nombre=RegistroCte
Boton=31
NombreDesplegar=Registro Huellas
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Formas
ClaveAccion=ExpRegistroCte
Activo=S
Visible=S
Menu=&Exploradores
UsaTeclaRapida=S
TeclaRapida=F4
Antes=S
AntesExpresiones=Asigna(Info.Cliente,MaviServicredCredVis:Cliente)
[Acciones.AcercadeSCR]
Nombre=AcercadeSCR
Boton=0
NombreEnBoton=S
Menu=&Ayuda
NombreDesplegar=Acerca de...
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Vermensaje(<T>Acerca de Servicred Crédito<T>,<T>Comercializadora de Muebles America S.A. de C.V.<T>+Nuevalinea+<T>______________________________________________________<T>+NuevaLinea+Nuevalinea+<T>                                         Servicred Crédito<T>+Nuevalinea+Nuevalinea+<T>Versión: V.2010.06.15<T>+NuevaLinea+<T>Fecha de Versión: 15 de Junio de 2010<T>+NuevaLinea+Nuevalinea+<T>______________________________________________________<T>+NuevaLinea+Nuevalinea+Nuevalinea+<T>www.mueblesamerica.com.mx<T>+NuevaLinea+<T>www.viu.com.mx<T>+Nuevalinea+<T>www.mavi.mx<T>+NuevaLinea+Nuevalinea+NuevaLinea+<T>______________________________________________________<T>+Nuevalinea+Nuevalinea+<T>Copyright(c) 2010 Comercializadora de Muebles America S.A. de C.V.<T>+NuevaLinea+<T>Derechos Reservados<T>)
[Acciones.NotasCobranzatelefonica]
Nombre=NotasCobranzatelefonica
Boton=0
Menu=&Ver
NombreDesplegar=Notas Cobranza Telefónica
EnMenu=S
TipoAccion=Formas
Activo=S
Visible=S
ClaveAccion=MAviServicasaServicredCredNotasCobranzaFrm
Antes=S
UsaTeclaRapida=S
TeclaRapida=F8
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Condatos(MaviServicredCredVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
AntesExpresiones=Asigna(Info.cliente,MaviServicredCredVis:Cliente)
[Acciones.NotasCobranza]
Nombre=NotasCobranza
Boton=0
NombreDesplegar=Notas Cobranza
EnMenu=S
TipoAccion=Formas
Activo=S
Antes=S
Visible=S
Menu=&Ver
ClaveAccion=CtaBitacora
ConCondicion=S
EjecucionCondicion=Condatos(MaviServicredCredVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
EjecucionConError=S
AntesExpresiones=Asigna(Info.Modulo, <T>CXC<T>)<BR>Asigna(Info.Tipo, SQL(<T>Select Tipo From Cte Where Cliente=:tval1<T>,MaviServicredCredVis:Cliente))<BR>Asigna(Info.Cuenta, MaviServicredCredVis:Cliente)<BR>Asigna(Info.Descripcion, MaviServicredCredVis:Nombre)<BR>Asigna(Info.PuedeEditar, Falso)
[SupervisionesContactosCte.Columnas]
0=-2
1=-2
2=-2
3=-2
4=-2
5=-2
[SupervisionesContactosCte.Supervision]
Carpeta=SupervisionesContactosCte
Clave=Supervision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=41
ColorFondo=Blanco
ColorFuente=Negro
[SupervisionesContactosCte.FechaRegistro]
Carpeta=SupervisionesContactosCte
Clave=FechaRegistro
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[SupervisionesContactosCte.Estatus]
Carpeta=SupervisionesContactosCte
Clave=Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.MovPosDSCR.AsigMovPosDSCR]
Nombre=AsigMovPosDSCR
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Info.ID,MaviServicredCredVis:ID)<BR>Asigna(Info.Modulo,<T>VTAS<T>)
Activo=S
Visible=S
[Acciones.MovPosDSCR.FrmMovPosDSCR]
Nombre=FrmMovPosDSCR
Boton=0
TipoAccion=Formas
ClaveAccion=movpos
Activo=S
Visible=S
[Acciones.RepCredAnua]
Nombre=RepCredAnua
Boton=0
NombreDesplegar=RM0301 Servicasa - Anuales
Multiple=S
EnBarraHerramientas=S
EnMenu=S
Activo=S
Visible=S
Menu=&Reportes
UsaTeclaRapida=S
TeclaRapida=F12
Antes=S
ListaAccionesMultiples=RepPan
AntesExpresiones=Asigna(Info.cliente,MaviServicredCredVis:Cliente)
[Acciones.RepCredAnua.RepPan]
Nombre=RepPan
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=RM0301ServCasaAnuaRep
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=ConDatos(MaviServicredCredVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
EjecucionConError=S
[ServicredCred.CrLib]
Carpeta=ServicredCred
Clave=CrLib
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=1
ColorFondo=Blanco
[Acciones.Excel]
Nombre=Excel
Boton=115
NombreDesplegar=<T>Excel<T>
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Enviar a Excel
Activo=S
Visible=S
Antes=S
Menu=&Edicion
EnMenu=S
Carpeta=ServicredCred
AntesExpresiones=Asigna(Info.Mov,MaviServicredCredVis:Mov)<BR>Asigna(Info.Estado,MaviServicredCredVis:Estatus)<BR>Asigna(Info.abc,MaviServicredCredVis:SucursalOrigen)
[Acciones.RM0855A]
Nombre=RM0855A
Boton=0
Menu=&Reportes
NombreDesplegar=RM0855A &Formato de Cliente Express
EnMenu=S
TipoAccion=Reportes Pantalla
ClaveAccion=RM0855AHojaVerdeRep
Activo=S
Visible=S
Antes=S
AntesExpresiones=Asigna(Mavi.RM0855ACte,MaviServicredCredVis:Cliente)
[ServicredCred.TiempoTotalTranscurrido]
Carpeta=ServicredCred
Clave=TiempoTotalTranscurrido
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[ServicredCred.%Supervision]
Carpeta=ServicredCred
Clave=%Supervision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
[ServicredCred.FechaAlta]
Carpeta=ServicredCred
Clave=FechaAlta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=38
ColorFondo=Blanco
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
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.DM0112Mov<BR>Mavi.DM0112Situacion<BR>Mavi.DM0112Estatus<BR>Mavi.FechaI<BR>Mavi.FechaF<BR>Mavi.DM0112Busqueda<BR>Mavi.DM0112ComboBusqueda
CarpetaVisible=S
[Filtros.Mavi.DM0112Mov]
Carpeta=Filtros
Clave=Mavi.DM0112Mov
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Filtros.Mavi.DM0112Situacion]
Carpeta=Filtros
Clave=Mavi.DM0112Situacion
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Filtros.Mavi.DM0112Estatus]
Carpeta=Filtros
Clave=Mavi.DM0112Estatus
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Filtros.Mavi.FechaI]
Carpeta=Filtros
Clave=Mavi.FechaI
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Filtros.Mavi.FechaF]
Carpeta=Filtros
Clave=Mavi.FechaF
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Acciones.ActualizarSCR.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.ActualizarSCR.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
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
[Acciones.CitaSup.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Asigna(Info.ID,MaviServicredCredVis:Id)<BR>/*SQL(<T>Select ID From Venta Where Mov = :tMov and MovID = :tMoID<T>, CampoEnTexto(MaviServicredCredVis:MovOrigen), CampoEnTexto(MaviServicredCredVis:IDMovOrigen))*/
EjecucionCondicion=Condatos(MaviServicredCredVis:Cliente)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
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
[Filtros.Mavi.DM0112ComboBusqueda]
Carpeta=Filtros
Clave=Mavi.DM0112ComboBusqueda
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Acciones.Tiempo Total.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.ID, MaviServicredCredVis:Id)<BR>Asigna(Info.Mov,MaviServicredCredVis:Mov)
[Acciones.Tiempo Total.mapeoArtFamiliaLista]
Nombre=mapeoArtFamiliaLista
Boton=0
TipoAccion=Formas
ClaveAccion=DM0112MaviServicasacredTiempoSolFRM
Activo=S
Visible=S
[Acciones.Tiempo Total]
Nombre=Tiempo Total
Boton=0
UsaTeclaRapida=S
TeclaRapida=Ctrl+M
NombreDesplegar=Tiempo Total
Multiple=S
EnMenu=S
ListaAccionesMultiples=Expresion<BR>mapeoArtFamiliaLista
Activo=S
Visible=S
[ServicredCred.Monedero]
Carpeta=ServicredCred
Clave=Monedero
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=2
ColorFondo=Blanco
[Acciones.Monedero.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.ID,MaviServicredCredVis:Id)
[Acciones.Monedero.FRM]
Nombre=FRM
Boton=0
TipoAccion=Formas
ClaveAccion=DM0112MonederoRemidirVisFRM
Activo=S
ConCondicion=S
Visible=S
EjecucionCondicion=SI (SQL(<T>SELECT Redimeptos FROM venta WHERE ID = :nID <T>,Info.Id))=0<BR>ENTONCES<BR>    ERROR(<T>Sin Informacion en Monedero<T>)<BR>SINO<BR>    VERDADERO<BR>FIN
[Acciones.Monedero]
Nombre=Monedero
Boton=0
UsaTeclaRapida=S
TeclaRapida=Ctrl+D
NombreDesplegar=Monedero por Redimir
Multiple=S
EnMenu=S
ListaAccionesMultiples=Asigna<BR>FRM
Activo=S
Visible=S
[Acciones.HojaV]
Nombre=HojaV
Boton=0
UsaTeclaRapida=S
TeclaRapida=Ctrl+J
NombreDesplegar=&Ver Actualizacion de datos
EnMenu=S
TipoAccion=Expresion
Activo=S
ConCondicion=S
Visible=S
Expresion=SI MaviServicredCredVis:Mov en (<T>Solicitud Credito<T>,<T>Analisis Credito<T>,<T>Pedido<T>)<BR>ENTONCES<BR>        Ejecutar(<T>PlugIns\SHM\SHM.exe MOSTRARHOJAVERDE <T>+MaviServicredCredVis:Cliente)<BR>    Fin<BR>SINO                   <BR>    Verdadero<BR>FIN
EjecucionCondicion=MaviServicredCredVis:Estatus noen (EstatusSinAfectar)
[ServicredCred.EstatusConvenio]
Carpeta=ServicredCred
Clave=EstatusConvenio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
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
Expresion=Ejecutar(<T>C:\AppsMavi\SHM\SHM.exe <T>+<T>CLIENTEFINALKARDEX <T>+<T> <T>+ MaviServicredCredVis:Id+<T> <T>+ Usuario)

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
EspacioPrevio=S
TipoAccion=Reportes Pantalla
Activo=S
Visible=S
ClaveAccion=RM1127ClientesAsociadosValeraRep



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
TipoAccion=Expresion
Expresion=Ejecutar(<T>PlugIns\IntL603.exe <T>+MaviServicredCredVis:Cliente+<T> <T>+Usuario+<T> N <T>+MaviServicredCredVis:ID)
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
Expresion=Asigna(Info.UsuarioGD,SQL(<T>SELECT Propiedad FROM Prop WITH(NOLOCK) WHERE RAMA=<T>+comillas(<T>USR<T>)+<T> AND TIPO=<T>+comillas(<T>GIRO<T>)+<T> AND Cuenta= :tUsu<T>,Usuario))<BR>si<BR>condatos(MaviServicredCredVis:Cliente)<BR>entonces<BR>Ejecutar(<T>PlugIns\ALCHEMY\AlchemyII.exe <T>+Info.UsuarioGD+<T> <T>+MaviServicredCredVis:Cliente+<T> <T>+<T>CLIENTE<T>+<T> <T>+<T>N<T>)<BR>sino<BR>Ejecutar(<T>PlugIns\ALCHEMY\AlchemyII.exe <T>+Info.UsuarioGD+<T> <T>+<T>VACIO<T>+<T> <T>+<T>CLIENTE<T>+<T> <T>+<T>N<T>)<BR>fin

[Acciones.ACD00019EvaluacionCalidad]
Nombre=ACD00019EvaluacionCalidad
Boton=129
NombreDesplegar=Calidad Captura
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
NombreEnBoton=S
UsaTeclaRapida=S
TeclaRapida=F10
Expresion=Ejecutar(<T>PlugIns\EvaluacionCalidad.exe <T>+MaviServicredCredVis:Cliente+<T> <T>+Usuario+<T> <T>+MaviServicredCredVis:Agente)

[Acciones.VisorSA]
Nombre=VisorSA
Boton=0
NombreDesplegar=Visor Socioeconomico Aval
EnMenu=S
Activo=S
TipoAccion=expresion
Visible=S
ClaveAccion=AndroidServicred
Expresion=Asigna(Info.UsuarioGD,SQL(<T>SELECT Propiedad FROM Prop WITH(NOLOCK) WHERE RAMA=<T>+comillas(<T>USR<T>)+<T> AND TIPO=<T>+comillas(<T>GIRO<T>)+<T> AND Cuenta= :tUsu<T>,Usuario))<BR> si<BR>condatos(MaviServicredCredVis:Cliente)<BR>entonces<BR>Ejecutar(<T>PlugIns\ALCHEMY\AlchemyII.exe <T>+Info.UsuarioGD+<T> <T>+MaviServicredCredVis:Cliente+<T> <T>+<T>CLIENTE<T>+<T> <T>+<T>SA<T>)<BR>sino<BR>informacion(<T>No se pudo obtener la cuenta del cliente, intente nuevamente<T>)<BR>fin


[Acciones.VisorSC]
Nombre=VisorSC
Boton=0
NombreDesplegar=Visor Socioeconomico Cliente
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
Antes=S
Expresion=Asigna(Info.UsuarioGD,SQL(<T>SELECT Propiedad FROM Prop WITH(NOLOCK) WHERE RAMA=<T>+comillas(<T>USR<T>)+<T> AND TIPO=<T>+comillas(<T>GIRO<T>)+<T> AND Cuenta= :tUsu<T>,Usuario))<BR> si<BR>condatos(MaviServicredCredVis:Cliente)<BR>entonces<BR>Ejecutar(<T>PlugIns\ALCHEMY\AlchemyII.exe <T>+Info.UsuarioGD+<T> <T>+MaviServicredCredVis:Cliente+<T> <T>+<T>CLIENTE<T>+<T> <T>+<T>SC<T>)<BR>sino<BR>informacion(<T>No se pudo obtener la cuenta del cliente, intente nuevamente<T>)<BR>fin

[Acciones.VisorBA]
Nombre=VisorBA
Boton=0
EnMenu=S
NombreDesplegar=Visor Buro Aval
TipoAccion=Expresion
Activo=S
Visible=S
Antes=S
Expresion=Asigna(Info.UsuarioGD,SQL(<T>SELECT Propiedad FROM Prop WITH(NOLOCK) WHERE RAMA=<T>+comillas(<T>USR<T>)+<T> AND TIPO=<T>+comillas(<T>GIRO<T>)+<T> AND Cuenta= :tUsu<T>,Usuario))<BR> si<BR>condatos(MaviServicredCredVis:Cliente)<BR>entonces<BR>Ejecutar(<T>PlugIns\ALCHEMY\AlchemyII.exe <T>+Info.UsuarioGD+<T> <T>+MaviServicredCredVis:Cliente+<T> <T>+<T>CLIENTE<T>+<T> <T>+<T>BA<T>)<BR>sino<BR>informacion(<T>No se pudo obtener la cuenta del cliente, intente nuevamente<T>)<BR>fin

[Acciones.VisorBC]
Nombre=VisorBC
Boton=0
EnMenu=S
NombreDesplegar=Visor Buro Cliente
TipoAccion=Expresion
Activo=S
Visible=S
Antes=S
Expresion=Asigna(Info.UsuarioGD,SQL(<T>SELECT Propiedad FROM Prop WITH(NOLOCK) WHERE RAMA=<T>+comillas(<T>USR<T>)+<T> AND TIPO=<T>+comillas(<T>GIRO<T>)+<T> AND Cuenta= :tUsu<T>,Usuario))<BR> si<BR>condatos(MaviServicredCredVis:Cliente)<BR>entonces<BR>Ejecutar(<T>PlugIns\ALCHEMY\AlchemyII.exe <T>+Info.UsuarioGD+<T> <T>+MaviServicredCredVis:Cliente+<T> <T>+<T>CLIENTE<T>+<T> <T>+<T>BC<T>)<BR>sino<BR>informacion(<T>No se pudo obtener la cuenta del cliente, intente nuevamente<T>)<BR>fin

[Acciones.VisorIA]
Nombre=VisorIA
EnMenu=S
Boton=0
NombreDesplegar=Visor Indentificación Aval
TipoAccion=Expresion
Activo=S
Visible=S
Antes=S
Expresion=Asigna(Info.UsuarioGD,SQL(<T>SELECT Propiedad FROM Prop WITH(NOLOCK) WHERE RAMA=<T>+comillas(<T>USR<T>)+<T> AND TIPO=<T>+comillas(<T>GIRO<T>)+<T> AND Cuenta= :tUsu<T>,Usuario))<BR> si<BR>condatos(MaviServicredCredVis:Cliente)<BR>entonces<BR>Ejecutar(<T>PlugIns\ALCHEMY\AlchemyII.exe <T>+Info.UsuarioGD+<T> <T>+MaviServicredCredVis:Cliente+<T> <T>+<T>CLIENTE<T>+<T> <T>+<T>IA<T>)<BR>sino<BR>informacion(<T>No se pudo obtener la cuenta del cliente, intente nuevamente<T>)<BR>fin

[Acciones.VisorIC]
Nombre=VisorIC
EnMenu=S
Boton=0
NombreDesplegar=Visor Indentificación Cliente
TipoAccion=Expresion
Activo=S
Visible=S
Antes=S
Expresion=Asigna(Info.UsuarioGD,SQL(<T>SELECT Propiedad FROM Prop WITH(NOLOCK) WHERE RAMA=<T>+comillas(<T>USR<T>)+<T> AND TIPO=<T>+comillas(<T>GIRO<T>)+<T> AND Cuenta= :tUsu<T>,Usuario))<BR> si<BR>condatos(MaviServicredCredVis:Cliente)<BR>entonces<BR>Ejecutar(<T>PlugIns\ALCHEMY\AlchemyII.exe <T>+Info.UsuarioGD+<T> <T>+MaviServicredCredVis:Cliente+<T> <T>+<T>CLIENTE<T>+<T> <T>+<T>IC<T>)<BR>sino<BR>informacion(<T>No se pudo obtener la cuenta del cliente, intente nuevamente<T>)<BR>fin


[Acciones.ConsultaBC]
Nombre=ConsultaBC
Boton=0
UsaTeclaRapida=S
TeclaRapida=Ctrl+U
NombreDesplegar=Consultar Buró
EnMenu=S
EspacioPrevio=S
TipoAccion=expresion
Expresion=si<BR>    (MaviServicredCredVis:Mov = <T>Solicitud Credito<T>)<BR>entonces<BR>    Ejecutar(<T>C:\AppsMavi\SHM\SHM.exe <T>+<T>CONSULTAR <T>+Usuario+<T> <T>+MaviServicredCredVis:Cliente+<T> <T>+<T>Solicitud_Credito<T>+<T> <T>+MaviServicredCredVis:Movid+<T> <T>+ 1)<BR>sino<BR>    si<BR>        (MaviServicredCredVis:Mov = <T>Analisis Credito<T>)<BR>    entonces<BR>        Ejecutar(<T>C:\AppsMavi\SHM\SHM.exe <T>+<T>CONSULTAR <T>+Usuario+<T> <T>+MaviServicredCredVis:Cliente+<T> <T>+<T>Analisis_Credito<T>+<T> <T>+MaviServicredCredVis:Movid+<T> <T>+ 1)<BR>    sino<BR>        falso<BR>    fin<BR>fin
Activo=S
VisibleCondicion=si<BR>(<T>CREDI<T> en Medio(Usuario,1,5))<BR>entonces<BR>    verdadero<BR>sino<BR>    falso<BR>fin


[Acciones.ConsultaBC]
Nombre=ConsultaBC
Boton=0
UsaTeclaRapida=S
TeclaRapida=Ctrl+U
NombreDesplegar=Consultar Buró
EnMenu=S
EspacioPrevio=S
TipoAccion=expresion
Expresion=si<BR>    (MaviServicredCredVis:Mov = <T>Solicitud Credito<T>)<BR>entonces<BR>    Ejecutar(<T>C:\AppsMavi\SHM\SHM.exe <T>+<T>CONSULTAR <T>+Usuario+<T> <T>+MaviServicredCredVis:Cliente+<T> <T>+<T>Solicitud_Credito<T>+<T> <T>+MaviServicredCredVis:Movid+<T> <T>+ 1)<BR>sino<BR>    si<BR>        (MaviServicredCredVis:Mov = <T>Analisis Credito<T>)<BR>    entonces<BR>        Ejecutar(<T>C:\AppsMavi\SHM\SHM.exe <T>+<T>CONSULTAR <T>+Usuario+<T> <T>+MaviServicredCredVis:Cliente+<T> <T>+<T>Analisis_Credito<T>+<T> <T>+MaviServicredCredVis:Movid+<T> <T>+ 1)<BR>    sino<BR>        falso<BR>    fin<BR>fin
Activo=S
VisibleCondicion=si<BR>(<T>CREDI<T> en Medio(Usuario,1,5))<BR>entonces<BR>    verdadero<BR>sino<BR>    falso<BR>fin
[ServicredCred.]
Carpeta=ServicredCred
ColorFondo=Negro
[ServicredCred.TextoAmostrar]
Carpeta=ServicredCred
Clave=TextoAmostrar
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
[Acciones.InvesTelefonica]
Nombre=InvesTelefonica
Boton=0
NombreDesplegar=Investigación Telefónica
Multiple=S
EnMenu=S
Visible=S
ListaAccionesMultiples=Expresion<BR>Traer Forma
Activo=S
[Acciones.InvesTelefonica.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(MAVI.RM1148Cliente,MaviServicredCredVis:Cliente)<BR>Asigna(MAVI.RM1148IDMov,MaviServicredCredVis:Id)
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

Expresion=Asigna(Info.Numero, MaviServicredCredVis:Id)<BR>Asigna(Info.Usuario, Usuario )<BR>Forma(<T>RM1154TipReanalisisFrm<T>)
VisibleCondicion=MaviServicredCredVis:Mov = <T>Analisis Credito<T>


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

