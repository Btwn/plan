[Forma]
Clave=DM0211GenPagChequesFrm
Nombre=DM0211 Generacion de Pagos y Cheques por Lote
Icono=0
ListaCarpetas=FICHAS<BR>DETALLE
CarpetaPrincipal=FICHAS
PosicionInicialIzquierda=64
PosicionInicialArriba=106
PosicionInicialAncho=1071
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
PosicionSeccion1=60
PosicionSeccion2=93
MovModulo=CXP
PosicionColumna3=50
BarraAyudaBold=S
BarraAyuda=S
PosicionInicialAlturaCliente=550
PosicionSec1=116
PosicionSec2=520
VentanaEstadoInicial=Normal
Modulos=CXP
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Actualiza<BR>Sin Afectar<BR>Excell<BR>Imprimir_PDF<BR>CERRA
PosicionCol1=1058
ExpresionesAlMostrar=asigna(Mavi.DM0211Vacio,0)<BR>asigna(Mavi.DM0211Movimiento,<T><T>)<BR>asigna(Mavi.DM0211Estatus,<T><T>)<BR>asigna(Mavi.DM0211Situacion,<T><T>)<BR>asigna(Mavi.DM0211Usuario,<T><T>)<BR>asigna(Mavi.DM0211Situacion,<T><T>)<BR>asigna(Mavi.DM0211TipoCheque,<T><T>)<BR>asigna(info.fechad,nulo)<BR>asigna(info.fechaa,nulo)














[(Carpeta Abrir)]
Estilo=Iconos
Clave=(Carpeta Abrir)
OtroOrden=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Vista=DM0211PagoVIS
Fuente={MS Sans Serif, 8, Negro, []}
IconosCampo=(Situación)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>MOVIMIENTO<T>
IconosConPaginas=S
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaOrden=FECHAEMISION<TAB>(Acendente)
CarpetaVisible=S
BusquedaRapidaControles=S
FiltroFechas=S
FiltroMovs=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
BusquedaRapida=S
BusquedaInicializar=S
BusquedaAncho=20
FiltroListaEstatus=(Todos)<BR>SINAFECTAR<BR>CONFIRMAR<BR>BORRADOR<BR>PENDIENTE<BR>SINCRO<BR>CONCLUIDO<BR>CANCELADO
FiltroEstatusDefault=(Todos)
PestanaOtroNombre=S
PestanaNombre=movimientos
FiltroUsuarioDefault=(Todos)
BusquedaRespetarControlesNum=S
BusquedaActualizacionManual=S
BusquedaRespetarFiltros=S
MenuLocal=S
BusquedaEnLinea=S
FiltroFechasNombre=&Fecha
FiltroFechasCambiar=S
FiltroIgnorarEmpresas=S
ListaEnCaptura=ORIGEN<BR>ORIGENID<BR>ESTATUS<BR>FECHAEMISION<BR>SITUACION<BR>USUARIO<BR>PROVEEDOR<BR>NOMBRE<BR>MOV<BR>MOVID
FiltroFechasNormal=S
FiltroMovsTodos=S
IconosSeleccionMultiple=S
FiltroSituacionTodo=S
FiltroUsuarioSituacion=S
FiltroModificarEstatus=S
FiltroMovDefault=(Todos)
IconosNombre=DM0211PagoVIS:MOV+<T> <T>+DM0211PagoVIS:MOVID

[(Carpeta Abrir).Columnas]
0=148
1=86
2=62
3=71
4=81
5=81
6=78
7=93
8=123
9=123
10=117
11=73
12=113
13=70



[Acciones.Abrir]
Nombre=Abrir
Boton=2
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Ctrl+A
NombreDesplegar=&Abrir...
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Documento Abrir
Visible=S
Activo=S

[Acciones.Guardar]
Nombre=Guardar
Boton=3
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Ctrl+G
NombreDesplegar=&Guardar cambios
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Visible=S
Activo=S
ConCondicion=S
EjecucionCondicion=//Si(General.MovConcurrente y ConDatos(Cxc:Cxc.ID) y (Cxc:Cxc.UltimoCambio<>SQL(<T>spMovInfoVerUltimoCambio :nID, :tModulo<T>, Cxc:Cxc.ID, <T>CXC<T>)), Dialogo(<T>MovConcurrente<T>) AbortarOperacion)<BR>//Verdadero

[Acciones.Cerrar]
Nombre=Cerrar
Boton=0
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Alt+F4
NombreDesplegar=Cerrar
EnMenu=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Visible=S
Activo=S



[Acciones.Navegador]
Nombre=Navegador
Boton=0
NombreDesplegar=Navegador
EnBarraHerramientas=S
TipoAccion=Herramientas Captura
ClaveAccion=Navegador (Documentos)
Visible=S
Activo=S
EspacioPrevio=S



[Detalle.CxcD.Importe]
Carpeta=Detalle
Clave=CxcD.Importe
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
EditarConBloqueo=N
ColorFondo=Blanco
ColorFuente=Negro

[Detalle.CxcD.Aplica]
Carpeta=Detalle
Clave=CxcD.Aplica
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
EditarConBloqueo=N
ColorFondo=Blanco
ColorFuente=Negro

[Detalle.CxcD.AplicaID]
Carpeta=Detalle
Clave=CxcD.AplicaID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
EditarConBloqueo=N
ColorFondo=Blanco
ColorFuente=Negro

[Detalle.Columnas]
Importe=83
Aplica=117
AplicaID=66
Fecha=94
UsarProntoPago=89
DescuentoProntoPago=119
AplicaProntoPago=99
DiferenciaNeta=80
SaldoNeto=81
Referencia=79
Vencimiento=94
ProntoPago=117
DiferenciaPorcentaje=38
DescuentoRecargos=104
DescuentoRecargosSugerido=64
DescuentoRecargosPorcentaje=38
ImporteIVAFiscal=64
ProporcionRetencion=53
ImporteIEPSFiscal=64
InteresesOrdinarios=69
InteresesMoratorios=75
InteresesOrdinariosQuita=47
InteresesMoratoriosQuita=44
ImpuestoAdicionalNeto=94
Retencion=64
ID=64
MOV=124
MOVID=124
FECHAEMISION=94
SITUACION=304
PROVEEDOR=65
ESTATUS=94
MOVIMIENTO=256
USUARIO=115
NOMBRE=604
ORIGEN=124
ORIGENID=124
0=151
1=50
2=122
3=125
4=131
5=113
6=137
7=155
8=78
9=91
10=341
11=-2
12=-2

[(Carpeta Totalizadores)]
Clave=(Carpeta Totalizadores)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=C1
Fuente={MS Sans Serif, 8, Negro, []}
FichaEspacioEntreLineas=4
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
Totalizadores1=
Totalizadores2=
Totalizadores3=
Totalizadores=S
TotCarpetaRenglones=Detalle
CampoColorLetras=Negro
CampoColorFondo=Plata
CondicionVisible=/*ConDatos(Cxc:Cxc.Mov) y<BR>((MovTipo(<T>CXC<T>, Cxc:Cxc.Mov) noen (CXC.F, CXC.A, CXC.DFA, CXC.AR, CXC.FA, CXC.AF, CXC.CA, CXC.CAD, CXC.CAP, CXC.VV, CXC.OV, CXC.AV, CXC.CD, CXC.DE, CXC.DI, CXC.AJE, CXC.AJR, CXC.NCP, CXC.SD, CXC.SCH)) y<BR>(Cxc:Cxc.AplicaManual o ((Cxc:Cxc.Estatus noen (EstatusSinAfectar, EstatusPorConfirmar)) y (MovTipo(<T>CXC<T>, Cxc:Cxc.Mov) noen (CXC.NC, CXC.NCD, CXC.NCF, CXC.DV, CXC.RA, CXC.PR)))) o<BR>(MovTipoEn(<T>CXC<T>, Cxc:Cxc.Mov, (CXC.IM, CXC.RM))))<BR>*/



[Acciones.Afectar]
Nombre=Afectar
Boton=7
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=F12
NombreDesplegar=<T>A&fectar<T>
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Expresion
Visible=S
RefrescarDespues=S
ConCondicion=S
EspacioPrevio=S
Antes=S
GuardarAntes=S
EjecucionConError=S
Expresion=/*<BR>SI(((Cxc:Cxc.Estatus <> <T>CONCLUIDO<T>)y (Cxc:Cxc.Mov  en (<T>Cobro<T>,<T>Cobro Instituciones<T>)) y (Vacio(Cxc:Cxc.MovID))), (EjecutarSQL( <T>EXEC spConsecutivoGral :nID, :tMod, :bApl<T> ,Cxc:Cxc.ID, <T>CXC<T>, Cxc:Cxc.AplicaManual)))Asigna(Afectar.Modulo, <T>CXC<T>)<BR>Asigna(Afectar.ID, Cxc:Cxc.ID)<BR>Asigna(Afectar.Mov, Cxc:Cxc.Mov)<BR>Asigna(Afectar.MovID, Cxc:Cxc.MovID)<BR>Asigna(Info.MovTipo, MovTipo(<T>CXC<T>, Cxc:Cxc.Mov))<BR>Asigna(Info.Cliente, Cxc:Cxc.Cliente)<BR>Asigna(Info.EnviarA, Cxc:Cxc.ClienteEnviarA)<BR>Asigna(Info.Agente, Cxc:Cte.Agente)                                           <BR>Asigna(Info.Referencia, Cxc:Cxc.Referencia)<BR>Asigna(Info.Saldo, Suma(CxcD:ImporteNeto)-Cxc:ImporteTotal)//ARC redondea <BR>Si<BR>  Cxc:Cxc.Estatus en (EstatusSinAfectar, EstatusPorC<CONTINUA>
Expresion002=<CONTINUA>onfirmar)                                  <BR>Entonces<BR>  Si<BR>    (Info.MovTipo en (CXC.C, CXC.D, CXC.DM, CXC.NC, CXC.NCD, CXC.NCF, CXC.ANC, CXC.ACA, CXC.AE)) y Cxc:Cxc.AplicaManual y (ABS(Info.Saldo) > Config.CxcAutoAjuste)<BR>  Entonces<BR>    Si(no Forma(<T>CxcAplicaDif<T>), AbortarOperacion)<BR>  Fin<BR>  Afectar(<T>CXC<T>, Cxc:Cxc.ID, Cxc:Cxc.Mov, Cxc:Cxc.MovID, <T>Todo<T>, <T><T>, <T>Cxc<T>)<BR>Sino<BR>  Asigna(Info.Modulo, <T>CXC<T>)<BR>  Asigna(Info.Mov, Cxc:Cxc.Mov)<BR>  Asigna(Info.MovID, Cxc:Cxc.MovID)<BR>  Asigna(Afectar.Modulo, <T>CXC<T>)<BR>  Asigna(Afectar.ID, Cxc:Cxc.ID)<BR>  Asigna(Afectar.Mov, Cxc:Cxc.Mov)<BR>  Asigna(Afectar.MovID, Cxc:Cxc.MovID)<BR>  Asigna(Afectar.FormaCaptura, <T>Cxc<T>)<BR>  Asigna(Info.TituloDialogo, Afectar.Mov+<T> <T>+Afectar.MovID)<BR><BR> /<CONTINUA>
Expresion003=<CONTINUA>* Si<BR>    Empresa.CFD y SQL(<T>spVerMovTipoCFD :tEmpresa, :tModulo, :tMov<T>, Empresa, Afectar.Modulo, Afectar.Mov)<BR>  Entonces<BR>    EjecutarSQL(<T>spAfectar :tModulo, :nID, :tAccion<T>, Afectar.Modulo, Afectar.ID, <T>CONSECUTIVO<T>)<BR>    Si(no CFD.Generar(Afectar.Modulo, Afectar.ID), Forma.ActualizarForma AbortarOperacion)<BR>    Asigna(Afectar.EnviarCFD, SQL(<T>SELECT EnviarAlAfectar FROM EmpresaCFD WHERE Empresa=:tEmpresa<T>, Empresa))<BR>  Fin*/<BR><BR>/*<BR>Si<BR>    ConfigModulo(Info.Modulo, <T>FlujoAbierto<T>) = <T>Si<T><BR>  Entonces<BR>    Si<BR>      Forma(<T>GenerarMovFlujo<T>)<BR>    Entonces<BR>      Asigna(Afectar.GenerarMov, Info.MovGenerar)<BR>      Generar(Afectar.Modulo, Afectar.ID, Afectar.Mov, Afectar.MovID, <T>Todo<T>, Afectar.GenerarMov, Afectar.FormaCaptura)<<CONTINUA>
Expresion004=<CONTINUA>BR>    Fin<BR>  Sino<BR><BR>    Asigna(Mavi.MonederoRedimeMensaje,SQL(<T>EXEC dbo.SP_MensajeDevMonedero :tFac,:tFacId,:nOp<T>,Cxc:Cxc.Mov,Cxc:Cxc.MovID,3))<BR>    SI ConDatos(Mavi.MonederoRedimeMensaje)<BR>    ENTONCES<BR>        Precaucion(Mavi.MonederoRedimeMensaje)<BR>    SINO<BR>        1=1<BR>    FIN<BR>    Caso Info.MovTipo<BR>      Es CXC.A   Entonces Dialogo(<T>GenerarCxcAnticipo<T>)<BR>      Es CXC.AR  Entonces Dialogo(<T>GenerarCxcAnticipo<T>)<BR>      Es CXC.DA  Entonces Dialogo(<T>GenerarCxcDocumentoAnticipo<T>)<BR>      Es CXC.NC  Entonces Dialogo(<T>GenerarCxcNCredito<T>)<BR>      Es CXC.DAC Entonces Dialogo(<T>GenerarCxcNCredito<T>)<BR>      Es CXC.NCD Entonces Dialogo(<T>GenerarCxcNCredito<T>)<BR>      Es CXC.NCF Entonces Dialogo(<T>GenerarCxcNCredito<T>)<BR>      Es CXC.DV<CONTINUA>
Expresion005=<CONTINUA> Entonces Dialogo(<T>GenerarCxcNCredito<T>)<BR>      Es CXC.NCP Entonces Asigna(Afectar.GenerarMov, ConfigMov.CxcAplicacion) Dialogo(<T>GenerarAplicacionCredito<T>)<BR>      Es CXC.DP  Entonces Dialogo(<T>GenerarCxcCobroPosfechado<T>)<BR>      Es CXC.EST Entonces EjecutarSQL(<T>EXEC SpRefRefinMavi :nID<T>,Afectar.ID) Asigna(Afectar.GenerarMov, <T>Refinanciamiento<T>) Generar(Afectar.Modulo, Afectar.ID, Afectar.Mov, Afectar.MovID, <T>Todo<T>, Afectar.GenerarMov, Afectar.FormaCaptura)<BR>      Sino Dialogo(<T>GenerarCxcCobro<T>)<BR>    Fin<BR>  Fin<BR>/*<BR>  Si(Afectar.EnviarCFD, CFD.Enviar(Afectar.Modulo, Afectar.ID))*/<BR>/*Fin*/
ActivoCondicion=/*<BR>PuedeAfectar(Usuario.Afectar, Usuario.AfectarOtrosMovs, Cxc:Cxc.Usuario)<BR>y ((Cxc:Cxc.Estatus en (EstatusSinAfectar, EstatusPorConfirmar))<BR>o ((Cxc:Cxc.Estatus=EstatusPendiente)<BR>y MovTipoEn(<T>CXC<T>, Cxc:Cxc.Mov, (CXC.F, CXC.FA, CXC.AF, CXC.CA, CXC.CAD, CXC.CAP, CXC.VV, CXC.OV, CXC.IM, CXC.RM, CXC.D, CXC.DM, CXC.DP, CXC.CD, CXC.A, CXC.AR, CXC.DA, CXC.NC, CXC.NCD, CXC.NCF, CXC.DV, CXC.NCP, CXC.FAC, CXC.DAC, CXC.EST))))<BR>y PuedeAvanzarEstatus(<T>CXC<T>, Cxc:Cxc.Mov, Cxc:Cxc.Estatus, FormaSituacion)<BR>*/
EjecucionCondicion=/*<BR>SI SQL(<T>SELECT Tipo FROM Cte WITH(NOLOCK) WHERE Cliente=:tUsuario<T>,Cxc:Cxc.Cliente)<><T>Prospecto<T><BR>ENTONCES<BR>    SI SQL(<T>SELECT COUNT(Mov) FROM MovTipo WHERE Clave=<T>+Comillas(<T>CXC.AA<T>)+<T> AND Modulo = <T>+Comillas(<T>CXC<T>)+<T> AND Mov= :tMov<T>,Cxc:Cxc.Mov)>0<BR>    ENTONCES<BR>        Cxc:Cxc.Importe>0<BR>    SINO<BR>        (Caso 1=1<BR>            Es (Cxc:Cxc.Mov=<T>Devolucion<T>) y (sql(<T>Select acceso From Usuario Where Usuario=:tUsu<T>,Usuario) en (<T>VENTP_GERA<T>,<T>VENTP_USRB<T>))<BR>            Entonces<BR>                (sql(<T>select venta.Mov from cxc inner join cxcd on cxc.id=cxcd.id inner join MovFlujo mf on mf.DMov=cxcd.Aplica and mf.DMovid=cxcd.Aplicaid inner join Venta on Venta.Id=mf.Oid where cxc.id=:nId<T>,Cxc:Cxc.ID) en (<T>Devolucion Vent<CONTINUA>
EjecucionCondicion002=<CONTINUA>a<T>,<T>Devolucion VIU<T>))y<BR>                (Cxc:Cxc.Importe<=Sql(<T>exec Sp_MaviDM0124AbonosCliente :nId,:tCte<T>,Cxc:Cxc.ID,Cxc:Cxc.Cliente))<BR>            Sino<BR>                (ConDatos(Cxc:Cxc.Mov))                                          <BR>                y (Cxc:Cxc.Mov=<T>Anticipo Contado<T>)<BR>                y ((SQL(<T>Exec SP_MaviVentasCxCPuedeGenerarAnticipo :tval1,:nval2,:nval3<T>,Cxc:Cxc.Referencia,2,0)=0)<BR>                y ((Medio(Cxc:Cxc.Referencia,1,11)<><T>Seguro Auto<T>)<BR>                y (Medio(Cxc:Cxc.Referencia,1,11)<><T>Seguro Vida<T>)))<BR>                o ((ConDatos(Cxc:Cxc.Mov)) y (Cxc:Cxc.Mov<><T>Anticipo Contado<T>)))<BR>            Fin)<BR>    FIN<BR>SINO<BR>    1=0<BR>FIN<BR>*/
EjecucionMensaje=/*<BR>SI SQL(<T>SELECT Tipo FROM Cte WITH(NOLOCK) WHERE Cliente=:tUsuario<T>,Cxc:Cxc.Cliente)<><T>Prospecto<T><BR>ENTONCES<BR>    SI (SQL(<T>SELECT COUNT(Mov) FROM MovTipo WHERE Clave=<T>+Comillas(<T>CXC.AA<T>)+<T> AND Modulo = <T>+Comillas(<T>CXC<T>)+<T> AND Mov= :tMov<T>,Cxc:Cxc.Mov)>0) y (Cxc:Cxc.Importe<=0)<BR>    ENTONCES<BR>        <T>El importe debe ser Mayo a 0 pesos<T><BR>    SINO<BR>        (Si ((Cxc:Cxc.Mov=<T>Devolucion<T>) y (sql(<T>Select acceso From Usuario Where Usuario=:tUsu<T>,Usuario) en (<T>VENTP_GERA<T>,<T>VENTP_USRB<T>)))<BR>        Entonces<BR>            si (sql(<T>select venta.Mov from cxc inner join cxcd on cxc.id=cxcd.id inner join MovFlujo mf on mf.DMov=cxcd.Aplica and mf.DMovid=cxcd.Aplicaid inner join Venta on Venta.Id=mf.Oid where cxc.id=:nId<T>,Cxc:Cxc.ID) n<CONTINUA>
EjecucionMensaje002=<CONTINUA>oen (<T>Devolucion Venta<T>,<T>Devolucion VIU<T>))<BR>            entonces<BR>                <T>La Nota De Credito No Proviene de Una Devolucion De Mercancia<T><BR>            sino<BR>                si (Cxc:Cxc.Importe>Sql(<T>exec Sp_MaviDM0124AbonosCliente :nId,:tCte<T>,Cxc:Cxc.ID,Cxc:Cxc.Cliente))<BR>                entonces<BR>                    <T>El Monto de abonos es Menor que el Importe de la Devolución<T><BR>                fin<BR>            fin<BR>        Sino<BR>            Si ((ConDatos(Cxc:Cxc.Mov))<BR>            y (Cxc:Cxc.Mov=<T>Anticipo Contado<T>)<BR>            y ((SQL(<T>Exec SP_MaviVentasCxCPuedeGenerarAnticipo :tval1,:nval2,:nval3<T>,Cxc:Cxc.Referencia,2,0)=0))<BR>            y (Medio(Cxc:Cxc.Referencia,1,11)<><T>Seguro Auto<T>)<BR>            y (Medio(Cxc:Cxc.Refe<CONTINUA>
EjecucionMensaje003=<CONTINUA>rencia,1,11)<><T>Seguro Vida<T>) )<BR>            o ((ConDatos(Cxc:Cxc.Mov)) y  (Cxc:Cxc.Mov<><T>Anticipo Contado<T>))<BR>            entonces<BR>                <T>No se puede generar Apartado o Anticipo Contado para<T>+NuevaLinea+<BR>                <T>referencias que contienen Seguros de Auto o Seguros de Vida como<T>+Nuevalinea+<BR>                <T>articulo en la referencia o como tipo de movimiento<T><BR>            Fin<BR>       FIN)<BR>    FIN<BR>SINO<BR>    <T>El Cliente no debe ser de Tipo Prospecto<T><BR>FIN<BR>*/
AntesExpresiones=/*<BR>GuardarCambios<BR>Asigna(Info.IDMAVI, Cxc:Cxc.ID)<BR>Si<BR>    Cxc:Cxc.Importe<=0<BR>Entonces<BR>    Si(Precaucion(<T>El Importe debe ser Mayor a 0...<T>, BotonAceptar)=BotonAceptar, AbortarOperacion)<BR>Fin<BR>Si<BR>    ((Cxc:Cxc.Mov en(<T>Nota Credito<T>,<T>Nota Credito Mayoreo<T>,<T>Nota Credito VIU<T>)))<BR>Entonces<BR>    Si Vacio(Cxc:Cxc.ClienteEnviarA)<BR>    Entonces<BR>        Si(Precaucion(<T>Capturar un Canal de Venta Valido...<T>, BotonAceptar)=BotonAceptar, AbortarOperacion)<BR>    Fin<BR>Fin<BR>Si<BR>    ((Cxc:Cxc.Mov=<T>Cobro Div Deudores<T>) o ((Cxc:Cxc.Mov=<T>Cobro<T>)y(Cxc:Cte.Tipo=<T>Deudor<T>)))<BR>Entonces<BR>    Si Vacio(Cxc:Cxc.CtaDinero)<BR>    Entonces<BR>        Si(Precaucion(<T>Falta capturar una Cuenta de Banco...<T>, BotonAceptar)=BotonAceptar, AbortarOpe<CONTINUA>
AntesExpresiones002=<CONTINUA>racion)<BR>    Fin<BR>Fin<BR>Si<BR>    General.CamposExtras=<T>Campos Extras<T> y (Cxc:Cxc.Estatus en (EstatusSinAfectar, EstatusPorConfirmar, EstatusBorrador)) y SQL(<T>SELECT CEAntesAfectar FROM MovTipo WHERE Modulo=:tModulo AND Mov=:tMov AND CE=1<T>, <T>CXC<T>, Cxc:Cxc.Mov)<BR>Entonces<BR>    Si(no CamposExtrasMovimiento(<T>CXC<T>, Cxc:Cxc.Mov, Cxc:Cxc.ID, Verdadero, Cxc:Cxc.Estatus noen (EstatusSinAfectar, EstatusPorConfirmar, EstatusBorrador)), AbortarOperacion)<BR>Fin<BR>Si<BR>    Cxc:Cxc.Mov =<T>Cobro<T><BR>Entonces<BR>    EjecutarSQL(<T>spValorAfectar :nid<T>,Cxc:Cxc.ID )<BR>Fin*/




[Acciones.Copiar]
Nombre=Copiar
Boton=0
UsaTeclaRapida=S
TeclaRapida=F5
NombreDesplegar=Copiar
EnMenu=S
TipoAccion=Expresion
Visible=S
Expresion=Asigna( CxcD:CxcD.Importe, CxcD:SaldoNeto)<BR>Asigna( CxcD:CxcD.DescuentoRecargos, CxcD:DescuentoRecargosSugerido)
ActivoCondicion=Cxc:Cxc.Estatus en (EstatusSinAfectar, EstatusPorConfirmar)



[Acciones.Eliminar]
Nombre=Eliminar
Boton=5
Menu=&Archivo
NombreDesplegar=E&liminar
EnBarraHerramientas=S
EnMenu=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Documento Eliminar
Visible=S
ConCondicion=S
EjecucionConError=S
ActivoCondicion=/*Vacio(Cxc:Cxc.MovID) y (Cxc:Cxc.Estatus en (EstatusSinAfectar, EstatusPorConfirmar)) y PuedeAfectar(Verdadero, Usuario.ModificarOtrosMovs, Cxc:Cxc.Usuario)*/
EjecucionCondicion=//Vacio(SQL(<T>SELECT MovID FROM Cxc WHERE ID=:nID<T>, Cxc:Cxc.ID))
EjecucionMensaje=/*Forma.ActualizarForma<BR><T>El movimiento ya fue afectado por otro usuario<T>*/



[Acciones.Imprimir]
Nombre=Imprimir
Boton=4
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Ctrl+P
NombreDesplegar=&Imprimir...
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Expresion
ListaParametros1=Cxc:Cxc.ID
Visible=S
EspacioPrevio=S
GuardarAntes=S
Antes=S
ConCondicion=S
EjecucionConError=S
Expresion=/*<BR>Si (Cxc:Cxc.Mov en(<T>Cobro<T>,<T>Cobro Instituciones<T>,<T>Cobro Div Deudores<T>,<T>Apartado<T>,<T>Anticipo Contado<T>, <T>Anticipo Mayoreo<T>,<T>Enganche<T>)) y (Cxc:Cxc.Estatus=<T>CONCLUIDO<T>)<BR>Entonces<BR>    SI SQL(<T>SELECT COUNT(Numero) FROM dbo.TablaNumD WHERE TablaNum=:tTB AND CAST(Numero AS INT)=:nSuc<T>,<T>SUCURSALES RDP<T>,Sucursal)=1<BR>    ENTONCES<BR>        Ejecutar(<T>PlugIns\Cobro.exe <T>+Cxc:Cxc.ID+<T> <T>+Usuario+<T> <T>+1)<BR>    SINO<BR>        Ejecutar(<T>C:\AppsMavi\Cobro.exe <T>+Cxc:Cxc.ID+<T> <T>+Usuario+<T> <T>+1)<BR>    FIN<BR>Sino<BR>    Si (Cxc:Cxc.Mov=<T>Cheque Posfechado<T>) y (Cxc:Cxc.Estatus=<T>PENDIENTE<T>)<BR>    Entonces<BR>        ReporteImpresora(ReporteMovImpresora(<T>RM0937ReciboChequePFRep<T>,Cxc:Cxc.ID),Cxc:Cxc.ID)<BR>    Sino<BR>        <CONTINUA>
Expresion002=<CONTINUA>Si (Cxc:Cxc.Mov=<T>Cheque Devuelto<T>) y (Cxc:Cxc.Estatus=<T>PENDIENTE<T>)<BR>        Entonces<BR>           ReporteImpresora(ReporteMovImpresora(<T>RM0961CxcFormCheqDevRep<T>,Cxc:Cxc.ID),Cxc:Cxc.ID)<BR>        Sino<BR>            ReporteImpresora(ReporteMovImpresora(<T>CXC<T>, Cxc:Cxc.Mov, Cxc:Cxc.Estatus), Cxc:Cxc.ID)<BR>        Fin<BR>   Fin<BR>Fin<BR>*/
ActivoCondicion=/*(Usuario.ImprimirMovs)y(MAVI.DM0116FaseC<>1)*/
EjecucionCondicion=/*((Cxc:Cxc.Mov en(<T>Cobro<T>,<T>Cobro Instituciones<T>,<T>Cobro Div Deudores<T>,<T>Apartado<T>,<T>Anticipo Contado<T>, <T>Anticipo Mayoreo<T>,<T>Enganche<T>))<BR>y (Cxc:Cxc.Estatus=<T>CONCLUIDO<T>)) o (Cxc:Cxc.Mov en (<T>Cheque Posfechado<T>,<T>Cheque Devuelto<T>) y (Cxc:Cxc.Estatus=<T>PENDIENTE<T>))*/
EjecucionMensaje=/*<T>El movimiento debe estar Concluido...<T>*/
AntesExpresiones=/*<BR>Asigna(Info.ID,Cxc:Cxc.ID)<BR>Asigna(Info.ABC,Cxc:Cxc.Mov)<BR>Asigna(Info.Concepto,Cxc:Cxc.MovID)<BR>Asigna(Info.Cliente,Cxc:Cxc.Cliente)<BR>*/














[Aplica.Cxc.MovAplica]
Carpeta=Aplica
Clave=Cxc.MovAplica
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=17
ColorFondo=Blanco
ColorFuente=Negro

[Aplica.Cxc.MovAplicaID]
Carpeta=Aplica
Clave=Cxc.MovAplicaID
Editar=S
LineaNueva=N
ValidaNombre=N
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.Localizar]
Nombre=Localizar
Boton=0
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Shift+F3
NombreDesplegar=L&ocalizar...
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Documento Localizar
Activo=S
Visible=S

[Aplica.Cxc.Cliente]
Carpeta=Aplica
Clave=Cxc.Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=17
ColorFondo=Blanco
ColorFuente=Negro

[Aplica.Cte.Nombre]
Carpeta=Aplica
Clave=Cte.Nombre
Editar=S
3D=S
Tamano=55
ColorFondo=Plata
Efectos=[Negritas]
ColorFuente=Negro




[Detalle.CxcD.Fecha]
Carpeta=Detalle
Clave=CxcD.Fecha
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro


[Desglose.Cxc.Importe1]
Carpeta=Desglose
Clave=Cxc.Importe1
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Desglose.Cxc.FormaCobro1]
Carpeta=Desglose
Clave=Cxc.FormaCobro1
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Desglose.Cxc.Referencia1]
Carpeta=Desglose
Clave=Cxc.Referencia1
Editar=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro

[Desglose.Cxc.Importe2]
Carpeta=Desglose
Clave=Cxc.Importe2
Editar=S
LineaNueva=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Desglose.Cxc.FormaCobro2]
Carpeta=Desglose
Clave=Cxc.FormaCobro2
Editar=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Desglose.Cxc.Referencia2]
Carpeta=Desglose
Clave=Cxc.Referencia2
Editar=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro

[Desglose.Cxc.Importe3]
Carpeta=Desglose
Clave=Cxc.Importe3
Editar=S
LineaNueva=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Desglose.Cxc.FormaCobro3]
Carpeta=Desglose
Clave=Cxc.FormaCobro3
Editar=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Desglose.Cxc.Referencia3]
Carpeta=Desglose
Clave=Cxc.Referencia3
Editar=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro

[Desglose.Cxc.Importe4]
Carpeta=Desglose
Clave=Cxc.Importe4
Editar=S
LineaNueva=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Desglose.Cxc.FormaCobro4]
Carpeta=Desglose
Clave=Cxc.FormaCobro4
Editar=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Desglose.Cxc.Referencia4]
Carpeta=Desglose
Clave=Cxc.Referencia4
Editar=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro

[Desglose.Cxc.Importe5]
Carpeta=Desglose
Clave=Cxc.Importe5
Editar=S
LineaNueva=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Desglose.Cxc.FormaCobro5]
Carpeta=Desglose
Clave=Cxc.FormaCobro5
Editar=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Desglose.Cxc.Referencia5]
Carpeta=Desglose
Clave=Cxc.Referencia5
Editar=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro

[Desglose.Cxc.Cambio]
Carpeta=Desglose
Clave=Cxc.Cambio
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
EspacioPrevio=N
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Desglose.CobroTotal]
Carpeta=Desglose
Clave=CobroTotal
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Plata
Efectos=[Negritas]
ColorFuente=Negro

[Desglose.Cxc.DelEfectivo]
Carpeta=Desglose
Clave=Cxc.DelEfectivo
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.Situacion]
Nombre=Situacion
Boton=71
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Ctrl+F12
NombreDesplegar=&Situación
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Cambiar Situacion
Antes=S
Visible=S
ActivoCondicion=/*(ConfigModulo(<T>CXP<T>,<T>Situaciones<T>)=<T>Si<T>) y Usuario.ModificarSituacion y<BR>PuedeAvanzarSituacion(<T>CXP<T>, DM0211Pago:MOV, DM0211Pago:ESTATUS, FormaSituacion)*/
AntesExpresiones=//Si(Vacio(Cxc:Cxc.ID),GuardarCambios)

















[Detalle.DiferenciaNeta]
Carpeta=Detalle
Clave=DiferenciaNeta
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Gris


[Acciones.MovExpress.Agregar]
Nombre=Agregar
Boton=0
Carpeta=Detalle
TipoAccion=Controles Captura
ClaveAccion=Registro Agregar
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=Info.Copiar

[Acciones.MovExpress.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
Expresion=Asigna(CxcD:CxcD.Aplica, Info.Mov)<BR>Asigna(CxcD:CxcD.AplicaID, Info.MovID)
EjecucionCondicion=Info.Copiar

[Acciones.MovExpress.CxcExpress]
Nombre=CxcExpress
Boton=0
TipoAccion=Formas
ClaveAccion=CxcExpress
Activo=S
Visible=S


[Ficha.CteEnviarA.Nombre]
Carpeta=Ficha
Clave=CteEnviarA.Nombre
Editar=S
3D=S
Tamano=29
ColorFondo=Plata
ColorFuente=Negro
Pegado=N




















[Detalle.DiferenciaPorcentaje]
Carpeta=Detalle
Clave=DiferenciaPorcentaje
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Gris

[Detalle.CxcD.DescuentoRecargos]
Carpeta=Detalle
Clave=CxcD.DescuentoRecargos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Detalle.DescuentoRecargosSugerido]
Carpeta=Detalle
Clave=DescuentoRecargosSugerido
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Gris

[Detalle.DescuentoRecargosPorcentaje]
Carpeta=Detalle
Clave=DescuentoRecargosPorcentaje
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Gris

[Acciones.Totalizar.TotalizarCopiar]
Nombre=TotalizarCopiar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si<BR>  Cxc:Cxc.AplicaManual y MovTipoEn(<T>CXC<T>, Cxc:Cxc.Mov, (CXC.C, CXC.CD, CXC.D, CXC.DM, CXC.NC, CXC.CA)) y Config.CxcCobroImpuestos<BR>Entonces<BR>  Asigna(Cxc:Cxc.Importe, Suma(CxcD:ImporteNeto)-Suma(CxcD:ImporteIVAFiscal))<BR>  Asigna(Cxc:Cxc.Impuestos, Suma(CxcD:ImporteIVAFiscal))<BR>Sino<BR>   Asigna(Cxc:Cxc.Importe, Suma(CxcD:ImporteNeto) / (1+(Si(MovTipoEn(<T>CXC<T>, Cxc:Cxc.Mov, (CXC.F,CXC.FA,CXC.AF,CXC.NC,CXC.CA,CXC.IM,CXC.RM)), (ImpuestoZona(General.DefImpuesto, Cxc:Cte.ZonaImpuesto, Cxc:Cxc.ClienteEnviarA, Cxc:CteEnviarA.ZonaImpuesto)/100), 0))))<BR>Fin

[Acciones.Totalizar.TotalizarPost]
Nombre=TotalizarPost
Boton=0
Carpeta=Detalle
TipoAccion=Controles Captura
ClaveAccion=Registro Afectar
Activo=S
Visible=S




[Aplica.CxcPendiente.Referencia]
Carpeta=Aplica
Clave=CxcPendiente.Referencia
Editar=S
LineaNueva=N
ValidaNombre=N
3D=S
Tamano=20
ColorFondo=Plata
ColorFuente=Negro

[Aplica.CxcPendiente.FechaEmision]
Carpeta=Aplica
Clave=CxcPendiente.FechaEmision
Editar=S
LineaNueva=N
ValidaNombre=N
3D=S
ColorFondo=Plata
ColorFuente=Negro
Tamano=12
Pegado=S

[Aplica.CxcPendiente.Vencimiento]
Carpeta=Aplica
Clave=CxcPendiente.Vencimiento
Editar=S
LineaNueva=N
ValidaNombre=N
3D=S
ColorFondo=Plata
ColorFuente=Negro
Tamano=12
Pegado=S

[Detalle.ImporteIVAFiscal]
Carpeta=Detalle
Clave=ImporteIVAFiscal
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Gris




[Detalle.ProporcionRetencion]
Carpeta=Detalle
Clave=ProporcionRetencion
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Gris






[Detalle.ImporteIEPSFiscal]
Carpeta=Detalle
Clave=ImporteIEPSFiscal
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Gris



[Comentarios.Cxc.Comentarios]
Carpeta=Comentarios
Clave=Cxc.Comentarios
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=89x12
ColorFondo=Blanco
ColorFuente=Negro

[Comentarios.Cxc.Nota]
Carpeta=Comentarios
Clave=Cxc.Nota
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=47
ColorFondo=Blanco
ColorFuente=Negro





[AC.Cxc.LineaCredito]
Carpeta=AC
Clave=Cxc.LineaCredito
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[AC.LC.Descripcion]
Carpeta=AC
Clave=LC.Descripcion
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=36
ColorFondo=Plata
ColorFuente=Negro

[AC.LC.VigenciaHasta]
Carpeta=AC
Clave=LC.VigenciaHasta
Editar=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Plata
ColorFuente=Negro

[AC.Cxc.TipoAmortizacion]
Carpeta=AC
Clave=Cxc.TipoAmortizacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[AC.TipoAmortizacion.Descripcion]
Carpeta=AC
Clave=TipoAmortizacion.Descripcion
Editar=S
ValidaNombre=S
3D=S
Tamano=36
ColorFondo=Plata
ColorFuente=Negro

[AC.Cxc.TipoTasa]
Carpeta=AC
Clave=Cxc.TipoTasa
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[AC.TipoTasa.Descripcion]
Carpeta=AC
Clave=TipoTasa.Descripcion
Editar=S
ValidaNombre=S
3D=S
Tamano=36
ColorFondo=Plata
ColorFuente=Negro

[AC.Cxc.Condicion]
Carpeta=AC
Clave=Cxc.Condicion
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro

[AC.Cxc.Vencimiento]
Carpeta=AC
Clave=Cxc.Vencimiento
Editar=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro




[Detalle.CxcD.InteresesOrdinarios]
Carpeta=Detalle
Clave=CxcD.InteresesOrdinarios
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Detalle.CxcD.InteresesMoratorios]
Carpeta=Detalle
Clave=CxcD.InteresesMoratorios
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Detalle.CxcD.InteresesOrdinariosQuita]
Carpeta=Detalle
Clave=CxcD.InteresesOrdinariosQuita
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Detalle.CxcD.InteresesMoratoriosQuita]
Carpeta=Detalle
Clave=CxcD.InteresesMoratoriosQuita
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[AC.Cxc.Comisiones]
Carpeta=AC
Clave=Cxc.Comisiones
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S

[AC.Cxc.ComisionesIVA]
Carpeta=AC
Clave=Cxc.ComisionesIVA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro

[AC.TotalComisiones]
Carpeta=AC
Clave=TotalComisiones
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Plata
ColorFuente=Negro

[AC.LC.VigenciaDesde]
Carpeta=AC
Clave=LC.VigenciaDesde
Editar=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Plata
ColorFuente=Negro


[VIN.Cxc.VIN]
Carpeta=VIN
Clave=Cxc.VIN
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Comentarios.Cxc.VIN]
Carpeta=Comentarios
Clave=Cxc.VIN
Editar=S
ValidaNombre=S
3D=S
Pegado=N
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Comentarios.Cxc.ContUso]
Carpeta=Comentarios
Clave=Cxc.ContUso
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


[AC.Cxc.TieneTasaEsp]
Carpeta=AC
Clave=Cxc.TieneTasaEsp
Editar=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[AC.Cxc.TasaEsp]
Carpeta=AC
Clave=Cxc.TasaEsp
Editar=S
ValidaNombre=S
3D=S
Tamano=9
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.ImpuestoAdicionalNeto]
Carpeta=Detalle
Clave=ImpuestoAdicionalNeto
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Gris


[FormaExtraValor.VerCampo]
Carpeta=FormaExtraValor
Clave=VerCampo
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFuente=Negro
ColorFondo=Plata
IgnoraFlujo=N
[FormaExtraValor.VerValor]
Carpeta=FormaExtraValor
Clave=VerValor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFuente=Negro
ColorFondo=Blanco
Efectos=[Negritas]
[FormaExtraValor.Columnas]
VerCampo=310
VerValor=310
[Detalle.CxcD.Retencion]
Carpeta=Detalle
Clave=CxcD.Retencion
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Imp]
Nombre=Imp
Boton=127
NombreEnBoton=S
NombreDesplegar=&Imprime2
EnBarraHerramientas=S
TipoAccion=Reportes Impresora
ClaveAccion=RM0906FormatoCobro2
Activo=S
Visible=S
ListaParametros1=Info.Id
ListaParametros=S
Antes=S
AntesExpresiones=Asigna(Info.Id,Cxc:Cxc.ID)<BR>Asigna(Info.Abc,Cxc:Cxc.Mov)<BR>Asigna(Info.Concepto,Cxc:Cxc.MovID)
[Acciones.RptePan]
Nombre=RptePan
Boton=6
EnBarraHerramientas=S
TipoAccion=Reportes Pantalla
ClaveAccion=RM0906FormatoCobro2
ListaParametros=S
Activo=S
Visible=S
ListaParametros1=Cxc:Cxc.ID









[Comentarios.Cxc.FacDesgloseIVA]
Carpeta=Comentarios
Clave=Cxc.FacDesgloseIva
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro


[Acciones.Refinanciamiento.Formas]
Nombre=Formas
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si Cxc:Cxc.Mov=<T>Refinanciamiento<T><BR>Entonces Forma(<T>MaviCxcRefinanciaInfo2<T>)<BR>sino Si Cxc:Cxc.Estatus en (EstatusPorConfirmar,EstatusConcluido,EstatusPendiente,EstatusCancelado)<BR>  Entonces<BR>    Forma(<T>MaviCxcRefinanciaInfo<T>)<BR>  Sino<BR>    Forma(<T>MaviCxcRefinancia<T>)<BR>    ActualizarForma(<T>CXC<T>)<BR>Fin<BR>Fin

[(Carpeta Abrir).ORIGEN]
Carpeta=(Carpeta Abrir)
Clave=ORIGEN
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).ORIGENID]
Carpeta=(Carpeta Abrir)
Clave=ORIGENID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).ESTATUS]
Carpeta=(Carpeta Abrir)
Clave=ESTATUS
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).FECHAEMISION]
Carpeta=(Carpeta Abrir)
Clave=FECHAEMISION
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).USUARIO]
Carpeta=(Carpeta Abrir)
Clave=USUARIO
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).PROVEEDOR]
Carpeta=(Carpeta Abrir)
Clave=PROVEEDOR
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).nombre]
Carpeta=(Carpeta Abrir)
Clave=NOMBRE
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.Columnas]
MOV=124
MOVID=124
0=-2
1=168
2=-2
3=-2
4=98
5=113
6=-2
7=60
8=-2
ORIGEN=124
ORIGENID=124
ESTATUS=94
FECHAEMISION=94
SITUACION=304
USUARIO=92
PROVEEDOR=65
NOMBRE=604
MOVIMIENTO=256
9=-2
10=-2
11=-2
[(Carpeta Abrir).SITUACION]
Carpeta=(Carpeta Abrir)
Clave=SITUACION
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=50
[Ficha.ORIGEN]
Carpeta=Ficha
Clave=ORIGEN
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.ORIGENID]
Carpeta=Ficha
Clave=ORIGENID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.ESTATUS]
Carpeta=Ficha
Clave=ESTATUS
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.FECHAEMISION]
Carpeta=Ficha
Clave=FECHAEMISION
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.SITUACION]
Carpeta=Ficha
Clave=SITUACION
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.USUARIO]
Carpeta=Ficha
Clave=USUARIO
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.PROVEEDOR]
Carpeta=Ficha
Clave=PROVEEDOR
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.NOMBRE]
Carpeta=Ficha
Clave=NOMBRE
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).MOV]
Carpeta=(Carpeta Abrir)
Clave=MOV
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).MOVID]
Carpeta=(Carpeta Abrir)
Clave=MOVID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.refresh]
Nombre=refresh
Boton=0
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=F5
NombreDesplegar=Refresca
EnMenu=S
TipoAccion=expresion
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Variables Asignar / Ventana Aceptar<BR>as
[Acciones.refresh.Variables Asignar / Ventana Aceptar]
Nombre=Variables Asignar / Ventana Aceptar
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.refresh.as]
Nombre=as
Boton=0
TipoAccion=controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Actualizar]
Nombre=Actualizar
Boton=82
NombreEnBoton=S
NombreDesplegar=&Actualizar
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asignar<BR>Actualizar
[Acciones.Actualizar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Actualizar.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Forma.IrCarpeta(<T>Ficha<T>)<BR>ActualizarForma(<T>DM0211GenPagChequesFrm<T>)
[Ficha.MOV]
Carpeta=Ficha
Clave=MOV
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.MOVID]
Carpeta=Ficha
Clave=MOVID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Afecta Lote.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Afecta Lote.registro]
Nombre=registro
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=registrarseleccion(<T>Ficha<T>)
[Acciones.Afecta Lote.seleccion]
Nombre=seleccion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.DM0211MovGrid,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)<BR><BR>INFORMACION(Mavi.DM0211MovGrid)
[Acciones.Afecta Lote]
Nombre=Afecta Lote
Boton=0
NombreDesplegar=&Afectar
Multiple=S
EnMenu=S
TipoAccion=Expresion
ListaAccionesMultiples=asigna<BR>registro<BR>seleccion<BR>EjecutarAfectacion
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=DM0211PagoVIS:ESTATUs en(EstatusPendiente) y (Usuario.Acceso=<T>TESOM_GERA<T>)<BR><BR>//(ComisionesChoferesMAVI:ComisionesChoferesMAVI.Estatus en(EstatusPendiente) y (Usuario.Acceso=<T>COMIS_GERA<T>)
[Acciones.CERRA]
Nombre=CERRA
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.SeleccionarTodo]
Nombre=SeleccionarTodo
Boton=0
NombreDesplegar=&SeleccionarTodo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.QuitarSeleccion]
Nombre=QuitarSeleccion
Boton=0
NombreDesplegar=&QuitarSeleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.ID]
Carpeta=Ficha
Clave=ID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Afecta Lote.EjecutarAfectacion]
Nombre=EjecutarAfectacion
Boton=0
TipoAccion=Expresion
Expresion=EXEC SP_DM0211GenPagCheq<BR>{si(condatos(Mavi.DM0211MovGrid), Reemplaza( comillas(<T>,<T>), <T>,<T>,(Mavi.DM0211MovGrid)),comillas(<T><T>))}
Activo=S
Visible=S
[FICHAS]
Estilo=Ficha
Clave=FICHAS
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
ListaEnCaptura=Mavi.DM0211Movimiento<BR>Info.FechaD<BR>Info.FechaA<BR>Mavi.DM0211Estatus<BR>Mavi.DM0211Usuario<BR>Mavi.DM0211Situacion
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Pagos
ExpAntesRefrescar=//Si(Mavi.DM0211Movimiento<><T>Solicitud Cheque<T>,Asigna(Mavi.DM0211TipoCheque,nulo),1=1)
[FICHAS.Mavi.DM0211Movimiento]
Carpeta=FICHAS
Clave=Mavi.DM0211Movimiento
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[FICHAS.Info.FechaD]
Carpeta=FICHAS
Clave=Info.FechaD
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[FICHAS.Info.FechaA]
Carpeta=FICHAS
Clave=Info.FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[FICHAS.Mavi.DM0211Estatus]
Carpeta=FICHAS
Clave=Mavi.DM0211Estatus
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[DETALLE]
Estilo=Iconos
Clave=DETALLE
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=DM0211PagoVIS
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=ID<BR>ORIGEN<BR>ORIGENID<BR>MOV<BR>MOVID<BR>FECHAEMISION<BR>SITUACION<BR>ESTATUS<BR>USUARIO<BR>NOMBRE<BR>MOVIMIENTO
MenuLocal=S
ListaAcciones=AFECTARLOTA<BR>SELECTODO<BR>QUITARSELEC
BusquedaRapidaControles=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaAncho=20
BusquedaEnLinea=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
IconosNombre=DM0211PagoVIS:MOVIMIENTO
CondicionVisible=Si<BR>  Mavi.DM0211Movimiento = <T>Pago<T><BR>Entonces<BR>  1=0<BR>sino<BR>1=1<BR>Fin<BR><BR>//(USUARIO.ACCESO)=<T>Tesom_Gera<T>
[DETALLE.ID]
Carpeta=DETALLE
Clave=ID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[DETALLE.MOV]
Carpeta=DETALLE
Clave=MOV
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[DETALLE.MOVID]
Carpeta=DETALLE
Clave=MOVID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[DETALLE.FECHAEMISION]
Carpeta=DETALLE
Clave=FECHAEMISION
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[DETALLE.SITUACION]
Carpeta=DETALLE
Clave=SITUACION
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[DETALLE.ESTATUS]
Carpeta=DETALLE
Clave=ESTATUS
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[DETALLE.MOVIMIENTO]
Carpeta=DETALLE
Clave=MOVIMIENTO
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=42
ColorFondo=Blanco
ColorFuente=Negro
[DETALLE.USUARIO]
Carpeta=DETALLE
Clave=USUARIO
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[DETALLE.NOMBRE]
Carpeta=DETALLE
Clave=NOMBRE
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[DETALLE.ORIGEN]
Carpeta=DETALLE
Clave=ORIGEN
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[DETALLE.ORIGENID]
Carpeta=DETALLE
Clave=ORIGENID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[FICHAS.Mavi.DM0211Situacion]
Carpeta=FICHAS
Clave=Mavi.DM0211Situacion
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[FICHAS.Mavi.DM0211Usuario]
Carpeta=FICHAS
Clave=Mavi.DM0211Usuario
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Actualizar.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Actualizar.asinaruno]
Nombre=asinaruno
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=asigna(Mavi.DM0211Vacio,1)
[Acciones.Actualizar.ActualizaVista]
Nombre=ActualizaVista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
[Acciones.Actualiza]
Nombre=Actualiza
Boton=82
NombreEnBoton=S
NombreDesplegar=&Actualizar
Multiple=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ListaAccionesMultiples=asig<BR>asignaruno<BR>Expresion<BR>actvista
Activo=S
Visible=S
RefrescarDespues=S
[Acciones.Actualiza.asig]
Nombre=asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
[Acciones.Actualiza.asignaruno]
Nombre=asignaruno
Boton=0
TipoAccion=Expresion
Expresion=asigna(Mavi.DM0211Vacio,1)<BR>
[Acciones.Actualiza.actvista]
Nombre=actvista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
[Acciones.afectalotes]
Nombre=afectalotes
Boton=0
NombreDesplegar=&afectalotes
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=asigna<BR>registro<BR>seleccion<BR>EjecutarAfecta
[Acciones.afectalotes.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.afectalotes.registro]
Nombre=registro
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=registrarseleccion(<T>FICHAS<T>)
[Acciones.afectalotes.seleccion]
Nombre=seleccion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.DM0211MovGrid,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)<BR><BR>INFORMACION(Mavi.DM0211MovGrid)
[Acciones.afectalotes.EjecutarAfecta]
Nombre=EjecutarAfecta
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=EXEC SP_DM0211GenPagCheq<BR>{si(condatos(Mavi.DM0211MovGrid), Reemplaza( comillas(<T>,<T>), <T>,<T>,(Mavi.DM0211MovGrid)),comillas(<T><T>))}
[Acciones.selTodo]
Nombre=selTodo
Boton=0
NombreDesplegar=&selTodo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.quitarSel]
Nombre=quitarSel
Boton=0
NombreDesplegar=&quitarSel
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[Acciones.AFECTARLOTA]
Nombre=AFECTARLOTA
Boton=0
NombreDesplegar=&AFECTARLOTE
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Multiple=S
ListaAccionesMultiples=ASIGNA<BR>SEL<BR>SELECT<BR>AFECTA
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=(USUARIO.ACCESO=<T>TESOM_GERA<T>)  o (USUARIO.ACCESO=<T>DEMO<T>)
EjecucionMensaje=<T>Usuario no tiene Permisos para Afectar<T>
VisibleCondicion=Si<BR>  Mavi.DM0211Movimiento en (<T>Pago<T> , <T>Cheque<T> , <T>Cheque Electronico<T>) <BR>Entonces<BR>  1=0<BR>sino<BR>1=1<BR>Fin
[Acciones.AFECTARLOTA.ASIGNA]
Nombre=ASIGNA
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.AFECTARLOTA.SEL]
Nombre=SEL
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=registrarseleccion(<T>DETALLE<T>)
[Acciones.AFECTARLOTA.SELECT]
Nombre=SELECT
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.DM0211MovGrid,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,0<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,0<T>)
[Acciones.AFECTARLOTA.AFECTA]
Nombre=AFECTA
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si<BR>       VACIO(Mavi.DM0211MovGrid) Entonces INFORMACION(<T> No Tiene Seleccionado Ningun Registro . . . !<T>)<BR>Sino<BR>                 SI Mavi.DM0211Movimiento en (<T>Prestamo<T>,<T>Gasto<T>,<T>Documento<T>,<T>Entrada Compra<T>) ENTONCES Forma(<T>DM0211DinPrincipalFrm<T>)<BR>       sino<BR>                 Si Mavi.DM0211Movimiento en (<T>Solicitud Cheque<T>) Entonces Forma(<T>DM0211ChequeFrm<T>)<BR>       SINO<BR><BR>     SI<BR>   (SQL(<T>EXEC SP_DM0211GenPagCheq :TMOV, :TCHEQUE, :TUSUARIO, :TCTA, :TMOVIMIENTO<T>,Mavi.DM0211MovGrid,Mavi.DM0211TipoCheque,USUARIO,<T><T>,Mavi.DM0211Movimiento))>0<BR>        informacion(<T> Ocurrio un problema con algunos Mov ver Detalle ... ! <T>)<BR>        REPORTEPANTALLA(<T>DM0211SinAfectar1Rep<T>)<BR>     sino<BR>        informacion(<T> Sus Registr<CONTINUA>
Expresion002=<CONTINUA>os fueron Actualizados ... ! <T>)<BR>      fin<BR>        FIN<BR>     FIN<BR>     FIN
[Acciones.SELECTODO]
Nombre=SELECTODO
Boton=0
NombreDesplegar=&SELECTODO
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
VisibleCondicion=Si<BR>  Mavi.DM0211Movimiento en (<T>Pago<T> , <T>Cheque<T> , <T>Cheque Electronico<T>) <BR>Entonces<BR>  1=0<BR>sino<BR>1=1<BR>Fin
[Acciones.QUITARSELEC]
Nombre=QUITARSELEC
Boton=0
NombreDesplegar=&QUITARSEL
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
VisibleCondicion=Si<BR>  Mavi.DM0211Movimiento en (<T>Pago<T> , <T>Cheque<T> , <T>Cheque Electronico<T>) <BR>Entonces<BR>  1=0<BR>sino<BR>1=1<BR>Fin
[SOLICITUDES.Mavi.DM0211Estatus]
Carpeta=SOLICITUDES
Clave=Mavi.DM0211Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[SOLICITUDES.Mavi.DM0211GenPagosMov]
Carpeta=SOLICITUDES
Clave=Mavi.DM0211GenPagosMov
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[SOLICITUDES.Mavi.DM0211Movimiento]
Carpeta=SOLICITUDES
Clave=Mavi.DM0211Movimiento
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[SOLICITUDES.Mavi.DM0211Situacion]
Carpeta=SOLICITUDES
Clave=Mavi.DM0211Situacion
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[SOLICITUDES.Mavi.DM0211Usuario]
Carpeta=SOLICITUDES
Clave=Mavi.DM0211Usuario
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[SOLICITUDES.Afectar.Accion]
Carpeta=SOLICITUDES
Clave=Afectar.Accion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Actualiza.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
ConCondicion=S
EjecucionCondicion=Si vacio(Mavi.DM0211Movimiento)<BR><BR> ENTONCES<BR>         Informacion(<T>Seleccione un Tipo de Movimiento ...! <T>)<BR>               AbortarOperacion<BR><BR>     sino si<BR>            (INFO.FECHAD > INFO.FECHAA) //o (vacio(INFO.FECHAD)) o (vacio(INFO.FECHA))<BR> ENTONCES<BR>          INFORMACION(<T>Fechas Incorrectas o Vacias ... !  <T>)<BR>               AbortarOperacion<BR>               SINO<BR>               1=1<BR>    FIN<BR>  FIN
EjecucionMensaje=<T> Seleccione un Movimiento ... ! <T>
[CHEQUE TIPO.CHEQUE]
Carpeta=CHEQUE TIPO
Clave=CHEQUE
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=18
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Imprimir_PDF]
Nombre=Imprimir_PDF
Boton=4
NombreEnBoton=S
NombreDesplegar=Imprimir
TipoAccion=Expresion
Activo=S
Visible=S
EnBarraHerramientas=S
Expresion=Forma.Imprimir(<T>DETALLE<T>)
[Acciones.Excell]
Nombre=Excell
Boton=67
NombreDesplegar=Excell
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
NombreEnBoton=S
Expresion=Forma.EnviarExcel(<T>DETALLE<T>)
[Acciones.Sin Afectar]
Nombre=Sin Afectar
Boton=18
NombreEnBoton=S
NombreDesplegar=&Sin Afectar
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=reportepantalla(<T>DM0211SinAfectar1Rep<T>)


