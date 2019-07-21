[Forma]
Clave=DM0278CancelacionSegurosVidaConsultaFRM
Icono=553
Modulos=(Todos)
ListaCarpetas=Uno
CarpetaPrincipal=Uno
PosicionInicialAlturaCliente=251
PosicionInicialAncho=1093
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=93
PosicionInicialArriba=364
BarraAcciones=S
AccionesTamanoBoton=15x5
AccionesCentro=S
AccionesDivision=S
ListaAcciones=Aceptar<BR>Rechazar<BR>Historico<BR>ValidarDoc<BR>cerrar
BarraHerramientas=S
Nombre=CANCELACIÓN DE SEGUROS DE VIDA
VentanaSinIconosMarco=S
[Uno]
Estilo=Ficha
Clave=Uno
Filtros=S
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0278HistCancelacionSegurosVidaVIS
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
CarpetaVisible=S
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
ListaEnCaptura=DM0278HistCancelacionSegurosVidaTBL.MovID<BR>DM0278HistCancelacionSegurosVidaTBL.Saldo<BR>DM0278HistCancelacionSegurosVidaTBL.Motivos<BR>DM0278HistCancelacionSegurosVidaTBL.Cliente<BR>DM0278HistCancelacionSegurosVidaTBL.NombreCliente<BR>DM0278HistCancelacionSegurosVidaTBL.Telefono<BR>DM0278HistCancelacionSegurosVidaTBL.ImporteCancelacion<BR>DM0278HistCancelacionSegurosVidaTBL.NombreSolicitante<BR>DM0278HistCancelacionSegurosVidaTBL.NominaSolicitante<BR>DM0278HistCancelacionSegurosVidaTBL.ComentarioVentas<BR>DM0278HistCancelacionSegurosVidaTBL.ComentarioCobranza
FiltroGeneral={si(condatos(Mavi.DM0278FacturaMovID),<T>DM0278HistCancelacionSegurosVidaTBL.ID=<T>+comillas(Mavi.DM0278FacturaMovID),<T>1=0<T>)}
[Uno.DM0278HistCancelacionSegurosVidaTBL.MovID]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.MovID
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Uno.DM0278HistCancelacionSegurosVidaTBL.Saldo]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.Saldo
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Uno.DM0278HistCancelacionSegurosVidaTBL.Motivos]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.Motivos
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco
[Uno.DM0278HistCancelacionSegurosVidaTBL.Cliente]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.Cliente
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Uno.DM0278HistCancelacionSegurosVidaTBL.NombreCliente]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.NombreCliente
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco
[Uno.DM0278HistCancelacionSegurosVidaTBL.Telefono]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.Telefono
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Uno.DM0278HistCancelacionSegurosVidaTBL.ImporteCancelacion]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.ImporteCancelacion
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Uno.DM0278HistCancelacionSegurosVidaTBL.NombreSolicitante]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.NombreSolicitante
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco
[Uno.DM0278HistCancelacionSegurosVidaTBL.NominaSolicitante]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.NominaSolicitante
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
[Uno.DM0278HistCancelacionSegurosVidaTBL.ComentarioCobranza]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.ComentarioCobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=125x2
ColorFondo=Blanco
[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreEnBoton=S
NombreDesplegar=Aceptar
EnBarraAcciones=S
Activo=S
Visible=S
TipoAccion=Expresion
Multiple=S
ListaAccionesMultiples=expresion<BR>guardar Cambios<BR>Cerrar
[Acciones.Rechazar]
Nombre=Rechazar
Boton=0
NombreEnBoton=S
NombreDesplegar=Rechazar
EnBarraAcciones=S
Activo=S
Visible=S
TipoAccion=Expresion
Multiple=S
ListaAccionesMultiples=Guardar Cambios<BR>rechaza<BR>cerrar
[Acciones.ValidarDoc]
Nombre=ValidarDoc
Boton=70
NombreEnBoton=S
NombreDesplegar=Validar Docs.
TipoAccion=Expresion
Activo=S
Visible=S
EnBarraHerramientas=S
ConCondicion=S
Expresion=SI SQL(<T>SELECT COUNT(Numero) FROM dbo.TablaNumD WHERE TablaNum=:tTab AND CAST(Numero AS INT)=:nSuc<T>, <T>SUCURSALES RDP<T>, Sucursal)=1<BR>Entonces<BR>    Asigna(Info.Cliente,DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.Cliente)<BR>    Ejecutar(<T>PlugIns\RutaTicket.exe <T>+<T>SHM6<T>+<T> <T>+Info.Cliente+<T> <T>+1)<BR>Sino<BR>    Asigna(Info.Cliente,DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.Cliente)<BR>    Ejecutar(<T>C:\AppsMavi\SHM\SHM.exe <T>+<T>VISORDOCSEGURO<T>+<T> <T>+Info.Cliente+<T> <T>+1)<BR>Fin
EjecucionCondicion=Si<BR>  Condatos(DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.Cliente)<BR>Entonces<BR>  verdadero<BR>Sino<BR>  falso<BR>Fin
[Acciones.Historico]
Nombre=Historico
Boton=18
NombreEnBoton=S
NombreDesplegar=Abrir Historico de Solicitudes Concluidas
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=DM0278HistoricoCancelacionesSegurosVidaFRM
Activo=S
Visible=S
[Uno.DM0278HistCancelacionSegurosVidaTBL.ComentarioVentas]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.ComentarioVentas
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=125x2
ColorFondo=Blanco



[Acciones.Rechazar.rechaza]
Nombre=rechaza
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Si   SQL(<T>SELECT ESTATUS FROM  DM0278HistCancelacionSegurosVida WHERE Pagado=1 and ID=<T>+COMILLAS(Mavi.DM0278FacturaMovID))=<T>PENDIENTE<T><BR>Entonces<BR>  Ejecutarsql(<T>EXEC SPIDM0278_HistoricoEstatusRechazado :nID, :nOption, :tUno, :tDos, :tTres, :nCuartro<T>,DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.ID,1,0,0,0,0 )<BR>  Informacion(<T>SOLICITUD RECHAZADA, CONTACTE AL CLIENTE PARA VERIFICAR LA INFORMACIÓN ENTREGADA <T>)<BR>  Forma.ActualizarForma<BR>  guardarCambios<BR>Sino<BR>  Informacion(<T>SOLO PUEDES RECHAZAR SOLICITUDES PENDIENTES Y QUE TENGAN PAGO EN NOTA DE CARGO<T>)<BR>Fin
[Acciones.Rechazar.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=ventana
ClaveAccion=cerrar
Activo=S
Visible=S

[Acciones.Aceptar.expresion]
Nombre=expresion
Boton=0
TipoAccion=expresion
Expresion=Asigna(Info.Cliente,DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.Cliente)<BR>Asigna(Info.MovID,DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.MovID)<BR>ASIGNA(Info.Nomina,DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.NominaSolicitante)<BR>Si<BR>  (SQL(<T>select COUNT(Factura) from DM0278HistoricoCancelacionesSeguroVida where Factura =:tMovID and Estatus=:tEstatus<T>,Info.MovID,<T>CONCLUIDO<T>)<>0)<BR>Entonces<BR>  Informacion(<T>Ya ha sido concluida esta solicitud <T>)<BR>Sino<BR>  Si<BR>     (DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.Pagado)<>VERDADERO<BR>Entonces<BR>  Informacion(<T>La Nota de Cargo <T>+DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.MovIDCXC+<T>no ha sido pagada<T>)<BR>Sino<BR>  Si<BR>     (SQL(<T>SET ANSI_WARNINGS ON SET ANSI_NULLS ON Select dbo.FN_DM0278VerificarCargaDocumentos(:tmov)<T>,DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.MovID)<>VERDADERO)<BR>Entonces<BR>  Informacion(<T>No han sido validado los documentos<T>)<BR>Sino<BR>  Asigna(Info.Saldo,SQL(<T>select Saldo from dbo.FN_DM0278DatosClienteCancelacionSeguroVida(:tMovID)<T>,DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.MovID))<BR><BR>Asigna(Info.Sucursal,SQL(<T>select SucursalTrabajo from dbo.FN_DM0278DatosPersonalCancelacionSeguroVida(<T>+comillas(Usuario)+<T>)<T>))<BR><BR>GuardarCambios<BR><BR>ASIGNA(Info.Dialogo,SQL(<T>EXEC SP_MaviDM0278NotaCreditoCancelacionSeguroVida :tUsuario, :tMovID, :tCliente, :nImporte,:nSucursal,:tNomina<T>,Usuario,Info.MovID,Info.cliente,Info.saldo,Info.Sucursal,Info.Nomina))<BR><BR>Si<BR>  (Info.Dialogo=<T>SOLICITUD REALIZADA CORRECTAMENTE<T>)<BR>Entonces<BR>  Informacion(Info.Dialogo)<BR><BR>  OtraForma(<T>DM0278ExploradorCancelacionSegurosVidaFRM<T>,  ActualizarVista)<BR>Sino<BR>  Informacion(Info.Dialogo)<BR>Fin<BR>Fin<BR>Fin<BR>Fin<BR>Fin
Activo=S
Visible=S

[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Rechazar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Aceptar.guardar Cambios]
Nombre=guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.cerrar.cancelar]
Nombre=cancelar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S

[Acciones.cerrar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.cerrar]
Nombre=cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=cancelar<BR>Cerrar
Activo=S
Visible=S

