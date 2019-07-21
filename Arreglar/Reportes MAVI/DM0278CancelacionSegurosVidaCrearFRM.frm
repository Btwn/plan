[Forma]
Clave=DM0278CancelacionSegurosVidaCrearFRM
Icono=604
Modulos=(Todos)
ListaCarpetas=Uno
CarpetaPrincipal=Uno
IniciarAgregando=S
PosicionInicialAlturaCliente=213
PosicionInicialAncho=1027
PosicionInicialIzquierda=126
PosicionInicialArriba=383
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Generar Formato<BR>Abrir Reporte<BR>Adjuntar<BR>REIMPRESION<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
Nombre=SOLICITUD DE CANCELACIÓN DE SEGUROS DE VIDA
VentanaBloquearAjuste=S
VentanaSinIconosMarco=S
ExpresionesAlMostrar=Asigna(Mavi.DM0278FacturaMovID,NULO)
[Uno]
Estilo=Ficha
Clave=Uno
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0278HistCancelacionSegurosVidaVIS
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
CarpetaVisible=S
ListaEnCaptura=DM0278HistCancelacionSegurosVidaTBL.MovID<BR>DM0278HistCancelacionSegurosVidaTBL.Saldo<BR>DM0278HistCancelacionSegurosVidaTBL.Motivos<BR>DM0278HistCancelacionSegurosVidaTBL.Cliente<BR>DM0278HistCancelacionSegurosVidaTBL.NombreCliente<BR>DM0278HistCancelacionSegurosVidaTBL.Telefono<BR>DM0278HistCancelacionSegurosVidaTBL.ImporteCancelacion<BR>DM0278HistCancelacionSegurosVidaTBL.NombreSolicitante<BR>DM0278HistCancelacionSegurosVidaTBL.NominaSolicitante<BR>DM0278HistCancelacionSegurosVidaTBL.ComentarioVentas
[Uno.DM0278HistCancelacionSegurosVidaTBL.MovID]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.MovID
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Uno.DM0278HistCancelacionSegurosVidaTBL.Saldo]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.Saldo
Editar=N
LineaNueva=N
ValidaNombre=S
3D=S
ColorFondo=Blanco
Tamano=20
[Uno.DM0278HistCancelacionSegurosVidaTBL.Motivos]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.Motivos
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco
[Uno.DM0278HistCancelacionSegurosVidaTBL.Cliente]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.Cliente
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Uno.DM0278HistCancelacionSegurosVidaTBL.NombreCliente]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.NombreCliente
Editar=N
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco
[Uno.DM0278HistCancelacionSegurosVidaTBL.Telefono]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.Telefono
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Uno.DM0278HistCancelacionSegurosVidaTBL.ImporteCancelacion]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.ImporteCancelacion
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
Tamano=20
[Uno.DM0278HistCancelacionSegurosVidaTBL.NominaSolicitante]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.NominaSolicitante
Editar=N
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Uno.DM0278HistCancelacionSegurosVidaTBL.NombreSolicitante]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.NombreSolicitante
Editar=N
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco
[Uno.DM0278HistCancelacionSegurosVidaTBL.ComentarioVentas]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.ComentarioVentas
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=125x2
ColorFondo=Blanco
[Acciones.Generar Formato]
Nombre=Generar Formato
Boton=59
NombreEnBoton=S
NombreDesplegar=Generar Formato
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=AvanzaCaptura<BR>Guardar<BR>Asigna<BR>Ejecutar SP
[Acciones.Abrir Reporte]
Nombre=Abrir Reporte
Boton=57
NombreEnBoton=S
NombreDesplegar=Abrir Reportes
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=DM0278ExploradorCancelacionSegurosVidaFRM
Activo=S
Visible=S
[Acciones.Generar Formato.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.DM0278FacturaMovID,DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.ID)
[Acciones.Generar Formato.Ejecutar SP]
Nombre=Ejecutar SP
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=ASIGNA(Info.Dialogo,SQL(<T>EXEC SP_MaviDM0278NotaCargoCancelacionSeguroVida :tUsuario, :tMovID, :tCliente, :nImporte,:nIDHist<T>,<BR>Usuario,DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.MovID,DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.Cliente,DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.ImporteCancelacion,DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.ID))<BR><BR>Si<BR>  (Info.Dialogo=<T>SOLICITUD REALIZADA CORRECTAMENTE<T>)<BR>Entonces<BR>  Informacion(Info.Dialogo)<BR>  ReportePantalla(<T>DM0278CancelacionSegurosVidaREP<T>)<BR>    ActualizarForma<BR>Sino                                                    <BR>  Informacion(Info.Dialogo)  <BR>Fin
[Acciones.Generar Formato.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=CONDATOS(DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.MovID) y SQL(<T>select COUNT(MovID) from DM0278HistCancelacionSegurosVida where MovID=<T>+comillas(DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.MovID)+<T> and Estatus=<T>+comillas(<T>PENDIENTE<T>))=0
EjecucionMensaje=<T>El campo MovID esta vacío o ya ha sido generada la nota de cargo<T>
[Acciones.Adjuntar]
Nombre=Adjuntar
Boton=78
NombreEnBoton=S
NombreDesplegar=Adjuntar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Expresion
Visible=S
ConCondicion=S
Activo=S
EjecucionConError=S
Expresion=SI SQL(<T>SELECT COUNT(Numero) FROM dbo.TablaNumD WHERE TablaNum=:tTab AND CAST(Numero AS INT)=:nSuc<T>, <T>SUCURSALES RDP<T>, Sucursal)=1<BR>    Entonces<BR>    Asigna(Info.MovID,DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.MovID)<BR>    Asigna(Info.Cliente,DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.Cliente)<BR>    Ejecutar(<T>PlugIns\RutaTicket.exe <T>+<T>SHM5<T>+<T> <T>+Info.MovID+<T> <T>+Info.Cliente+<T> <T>+Usuario+<T> <T>+1+<T> <T>+0)<BR>Sino<BR>    Asigna(Info.MovID,DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.MovID)<BR>    Asigna(Info.Cliente,DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.Cliente)<BR>    Ejecutar(<T>C:\AppsMavi\SHM\SHM.exe <T>+<T>CANCELASEGURO<T>+<T> <T>+Info.MovID+<T><CONTINUA>
Expresion002=<CONTINUA> <T>+Info.Cliente+<T> <T>+Usuario+<T> <T>+1)<BR>Fin
EjecucionCondicion=ASIGNA(INFO.DIALOGO, SQL(<T>select Estatus from DM0278HistCancelacionSegurosVida where movID=<T>+comillas(DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.MovID)))<BR>Si<BR>  (Condatos(DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.MovID) y Condatos(DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.Cliente)y (Info.Dialogo=<T>PENDIENTE<T>))<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  FALSO<BR>Fin
EjecucionMensaje=<T>EL TRAMITE PARA ESTA FACTURA A CONCLUIDO<T>
[Acciones.Generar Formato.AvanzaCaptura]
Nombre=AvanzaCaptura
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Accion=Expresion
Activo=S
Visible=S


Expresion=AvanzarCaptura
[Acciones.REIMPRESION]
Nombre=REIMPRESION
Boton=59
NombreDesplegar=Reimpresion de Fomato
EnBarraHerramientas=S
TipoAccion=expresion
Activo=S
Visible=S

NombreEnBoton=S

Expresion=ReportePantalla(<T>DM0278CancelacionSegurosVidaREP<T>)
[Acciones.prueba2.avanzar]
Nombre=avanzar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=AvanzarCaptura
[Acciones.prueba2.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.prueba2.asigne]
Nombre=asigne
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Asigna(Mavi.DM0278FacturaMovID,DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.ID)
[Acciones.prueba2.otra]
Nombre=otra
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=ASIGNA(Info.Dialogo,SQL(<T>EXEC SP_MaviDM0278NotaCargoCancelacionSeguroVida :tUsuario, :tMovID, :tCliente, :nImporte,:nIDHist<T>,<BR>Usuario,DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.MovID,DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.Cliente,DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.ImporteCancelacion,DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.ID))<BR><BR>Si<BR>  (Info.Dialogo=<T>SOLICITUD REALIZADA CORRECTAMENTE<T>)<BR>Entonces<BR>  Informacion(Info.Dialogo)<BR>   ReportePantalla(<T>DM0278CancelacionSegurosVidaREP<T>)<BR><BR>Sino                                                    <BR>  Informacion(Info.Dialogo)  <BR>Fin





[Acciones.Cerrar.Cancelar Cambios]
Nombre=Cancelar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S

[Acciones.Cerrar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Cancelar Cambios<BR>Cerrar
Activo=S
Visible=S

