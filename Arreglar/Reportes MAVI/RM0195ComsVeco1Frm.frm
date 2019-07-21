[Forma]
Clave=RM0195ComsVeco1Frm
Nombre=RM0195 Reporte Auxiliar de VECO
Icono=95
CarpetaPrincipal=(Variables)
Modulos=(Todos)
ListaCarpetas=(Variables)<BR>TC
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialIzquierda=475
PosicionInicialArriba=208
PosicionInicialAlturaCliente=569
PosicionInicialAncho=329
ListaAcciones=Preliminar<BR>Cerrar<BR>Actualiza<BR>Generar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionSec1=371
VentanaEscCerrar=S
VentanaAjustarZonas=S
ExpresionesAlMostrar=Asigna(Mavi.PorcBonif,<T>Si<T>)<BR>Asigna(Mavi.AnalitConden,<T>Analitico<T>)<BR>Asigna(Mavi.Diaporvencer,<T>Tipo de Reporte:<T>)<BR>Asigna(Mavi.DiaVencimiento,<T>Sólo para VIU:<T>)<BR>Asigna(Mavi.ArtCatLigGrup,<T>VENTA<T>)<BR>Asigna(Mavi.ArtGrupLigFam,<T>MERCANCIA DE LINEA<T>)<BR>Asigna(Mavi.Tipoformato,<T>Muebles América y MAVI<T>)<BR>Asigna(Mavi.UEN,comillas(<T>MUEBLES AMERICA<T>)+<T>,<T>+comillas(<T>MAVI<T>))<BR>Asigna(Mavi.TCPU,Nulo)<BR>Asigna(Mavi.TCPD1,Nulo)<BR>Asigna(Mavi.TCPD2,Nulo)<BR>Asigna(Mavi.TCPUT,Nulo)<BR>Asigna(Mavi.TCPD1T,Nulo)<BR>Asigna(Mavi.TCPD2T,Nulo)<BR>Asigna(Info.FechaD, Nulo)<BR>Asigna(Info.FechaA, Nulo)<BR>Asigna(Mavi.ArtFamLigLin,Nulo)<BR>Asigna(Mavi.ArtLinLigLin,Nulo)<BR>Asigna(Mavi.TipoSucurAnalisis,Nulo)<BR>Asigna(Mavi.SucuAdeC,Nulo)<BR>Asigna(Mavi.Acumulado1,<CONTINUA>
ExpresionesAlMostrar002=<CONTINUA>Nulo)
[(Variables)]
Estilo=Ficha
Clave=(Variables)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=65
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.PorcBonif<BR>Mavi.DiaPorVencer<BR>Mavi.AnalitConden<BR>Mavi.ArtFamLigLin<BR>Mavi.ArtLinLigLin<BR>Info.FechaD<BR>Info.FechaA<BR>Mavi.RM0195TipoVecoRep<BR>Mavi.TipoFormato<BR>Mavi.TipoSucurAnalisis<BR>Mavi.SucuAdeC
CarpetaVisible=S
PermiteEditar=S
FichaAlineacionDerecha=S
FichaEspacioNombresAuto=S
MenuLocal=S
[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S
Efectos=[Negritas]
[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
GuardarAntes=S
Multiple=S
ListaAccionesMultiples=Asignar<BR>Asign1<BR>Aceptar
[(Variables).Mavi.ArtFamLigLin]
Carpeta=(Variables)
Clave=Mavi.ArtFamLigLin
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[(Variables).Mavi.ArtLinLigLin]
Carpeta=(Variables)
Clave=Mavi.ArtLinLigLin
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[Acciones.Actualiza]
Nombre=Actualiza
Boton=0
NombreDesplegar=&Actualizar
GuardarAntes=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Multiple=S
ListaAccionesMultiples=Asigna<BR>Refresh<BR>Asigna2
ConAutoEjecutar=S
AutoEjecutarExpresion=1
[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
ConCondicion=S
Visible=S
EjecucionConError=S
EjecucionCondicion=(ConDatos(Mavi.PorcBonif))y<BR>(ConDatos(Mavi.AnalitConden)) y (ConDatos(Mavi.TipoFormato)) y<BR>(Si((Info.FechaD=Nulo)y(ConDatos(Info.fechaA)),Falso,Verdadero))y<BR>((Info.fechaD<=Info.FechaA)o((Info.FechaD=Nulo)y(Info.FechaA=Nulo)))y<BR>(Si(Mavi.ArtFamLigLin<>Nulo,Si(SQL(<T>Select Familia From Art Where Familia = :tFam<T>,Mavi.ArtFamLigLin)<>Nulo,Verdadero,Falso),Verdadero))y<BR>(Si(Mavi.ArtLinLigLin<>Nulo,Si(SQL(<T>Select Linea From Art Where Linea = :tLin<T>,Mavi.ArtLinLigLin)<>Nulo,Verdadero,Falso),Verdadero))y<BR>(Si(Mavi.TipoSucurAnalisis<>Nulo,Si(SQL(<T>Select Tipo From Sucursal Where Tipo in (<T>+Mavi.TipoSucurAnalisis+<T>)<T>)<>Nulo,Verdadero,Falso),Verdadero))y<BR>(Si(ConDatos(Mavi.SucuAdeC),Si(SQL(<T>Select Sucursal From Sucursal Where Sucursal in (<T>+Mavi.SucuAdeC+<T>)<T>)<>N<CONTINUA>
EjecucionCondicion002=<CONTINUA>ulo,Verdadero,Falso),Verdadero))
EjecucionMensaje=Si(Mavi.ArtFamLigLin<>Nulo,<BR>        Si(SQL(<T>Select Familia From Art Where Familia = :tFam<T>,Mavi.ArtFamLigLin)=Nulo,<T>Familia de Articulo Incorrecta<T>,<BR>        Si(Mavi.PorcBonif=Nulo,<T>Seleccionar Opcion de % de Bonificacion<T>,               <BR>        Si(Mavi.AnalitConden=Nulo,<T>Capturar tipo de Reporte<T>,<BR>        Si(Mavi.TipoFormato=Nulo,<T>Capturar Tipo de Formato<T>,<BR>        Si((Mavi.TipoFormato=<T>Sólo VIU<T>)y((Mavi.TCPU=Nulo)o(Mavi.TCPD1=Nulo)o(Mavi.TCPD2=Nulo)),<T>Capturar Todos los Porcentajes de TC<T>,<BR>        Si((OpcionEnTexto(Mavi.TipoFormato,<T>Muebles América y MAVI<T>,<T>Sólo Crédito Muebles América<T>)<><T><T>)y((Mavi.TCPU<>Nulo)o(Mavi.TCPD1<>Nulo)o(Mavi.TCPD2<>Nulo)),<T>No Capturar Porcentaje de TC para Muebles América o MAVI<T>,<BR>        Si((Con<CONTINUA>
EjecucionMensaje002=<CONTINUA>Datos(Info.FechaA))y(Info.fechaD=Nulo),<T>Especificar Rango de Fechas<T>,<BR>        Si((ConDatos(Info.fechaD))y(Info.FechaA=Nulo),<T>Especificar Rango de Fechas<T>,<BR>        Si(Info.FechaD>Info.FechaA,<T>La Primer Fecha debe ser Menor a la Primera<T>,<BR>        Si(((Mavi.TCPU<0)y(Mavi.TCPU<>Nulo))o((Mavi.TCPD1<0)y(Mavi.TCPD1<>Nulo))o((Mavi.TCPD2<0)y(Mavi.TCPD2<>Nulo)),<T>No Capturar Porcentajes Negativos<T>,)))))))))),<BR>        //SiNo<BR>        Si(Mavi.PorcBonif=Nulo,<T>Seleccionar Opcion de % de Bonificacion<T>,<BR>        Si(Mavi.AnalitConden=Nulo,<T>Capturar tipo de Reporte<T>,<BR>        Si(Mavi.TipoFormato=Nulo,<T>Capturar Tipo de Formato<T>,<BR>        Si((Mavi.TipoFormato=<T>Sólo VIU<T>)y((Mavi.TCPU=Nulo)o(Mavi.TCPD1=Nulo)o(Mavi.TCPD2=Nulo)),<T>Capturar Todos los Porcentajes <CONTINUA>
EjecucionMensaje003=<CONTINUA>de TC<T>,<BR>        Si((OpcionEnTexto(Mavi.TipoFormato,<T>Muebles América y MAVI<T>,<T>Sólo Crédito Muebles América<T>)<><T><T>)y((Mavi.TCPU<>Nulo)o(Mavi.TCPD1<>Nulo)o(Mavi.TCPD2<>Nulo)),<T>No Capturar Porcentaje de TC para Muebles América o MAVI<T>,<BR>        Si((ConDatos(Info.FechaA))y(Info.fechaD=Nulo),<T>Especificar Rango de Fechas<T>,<BR>        Si((ConDatos(Info.fechaD))y(Info.FechaA=Nulo),<T>Especificar Rango de Fechas<T>,<BR>        Si(Info.FechaD>Info.FechaA,<T>La Primer Fecha debe ser Menor a la Primera<T>,<BR>        Si(((Mavi.TCPU<0)y(Mavi.TCPU<>Nulo))o((Mavi.TCPD1<0)y(Mavi.TCPD1<>Nulo))o((Mavi.TCPD2<0)y(Mavi.TCPD2<>Nulo)),<T>No Capturar Porcentajes Negativos<T>,  )))))))))<BR>        )<BR>Si(Mavi.ArtLinLigLin<>Nulo,Si(SQL(<T>Select Linea From Art Where Linea = :tFam<T>,Mavi.<CONTINUA>
EjecucionMensaje004=<CONTINUA>ArtLinLigLin)=Nulo,<T>Linea de Articulo Incorrecta<T>,<BR>        Si(Mavi.PorcBonif=Nulo,<T>Seleccionar Opcion de % de Bonificacion<T>,<BR>        Si(Mavi.AnalitConden=Nulo,<T>Capturar tipo de Reporte<T>,<BR>        Si(Mavi.TipoFormato=Nulo,<T>Capturar Tipo de Formato<T>,<BR>        Si((Mavi.TipoFormato=<T>Sólo VIU<T>)y((Mavi.TCPU=Nulo)o(Mavi.TCPD1=Nulo)o(Mavi.TCPD2=Nulo)),<T>Capturar Todos los Porcentajes de TC<T>,<BR>        Si((OpcionEnTexto(Mavi.TipoFormato,<T>Muebles América y MAVI<T>,<T>Sólo Crédito Muebles América<T>)<><T><T>)y((Mavi.TCPU<>Nulo)o(Mavi.TCPD1<>Nulo)o(Mavi.TCPD2<>Nulo)),<T>No Capturar Porcentaje de TC para Muebles América o MAVI<T>,<BR>        Si((ConDatos(Info.FechaA))y(Info.fechaD=Nulo),<T>Especificar Rango de Fechas<T>,<BR>        Si((ConDatos(Info.fechaD))y(Info.Fe<CONTINUA>
EjecucionMensaje005=<CONTINUA>chaA=Nulo),<T>Especificar Rango de Fechas<T>,<BR>        Si(Info.FechaD>Info.FechaA,<T>La Primer Fecha debe ser Menor a la Primera<T>,<BR>        Si(((Mavi.TCPU<0)y(Mavi.TCPU<>Nulo))o((Mavi.TCPD1<0)y(Mavi.TCPD1<>Nulo))o((Mavi.TCPD2<0)y(Mavi.TCPD2<>Nulo)),<T>No Capturar Porcentajes Negativos<T>,  )))))))))),<BR>        //SiNo<BR>        Si(Mavi.PorcBonif=Nulo,<T>Seleccionar Opcion de % de Bonificacion<T>,<BR>        Si(Mavi.AnalitConden=Nulo,<T>Capturar tipo de Reporte<T>,<BR>        Si(Mavi.TipoFormato=Nulo,<T>Capturar Tipo de Formato<T>,<BR>        Si((Mavi.TipoFormato=<T>Sólo VIU<T>)y((Mavi.TCPU=Nulo)o(Mavi.TCPD1=Nulo)o(Mavi.TCPD2=Nulo)),<T>Capturar Todos los Porcentajes de TC<T>,<BR>        Si((OpcionEnTexto(Mavi.TipoFormato,<T>Muebles América y MAVI<T>,<T>Sólo Crédito Muebles América<T<CONTINUA>
EjecucionMensaje006=<CONTINUA>>)<><T><T>)y((Mavi.TCPU<>Nulo)o(Mavi.TCPD1<>Nulo)o(Mavi.TCPD2<>Nulo)),<T>No Capturar Porcentaje de TC para Muebles América o MAVI<T>,<BR>        Si((ConDatos(Info.FechaA))y(Info.fechaD=Nulo),<T>Especificar Rango de Fechas<T>,<BR>        Si((ConDatos(Info.fechaD))y(Info.FechaA=Nulo),<T>Especificar Rango de Fechas<T>,<BR>        Si(Info.FechaD>Info.FechaA,<T>La Primer Fecha debe ser Menor a la Primera<T>,<BR>        Si(((Mavi.TCPU<0)y(Mavi.TCPU<>Nulo))o((Mavi.TCPD1<0)y(Mavi.TCPD1<>Nulo))o((Mavi.TCPD2<0)y(Mavi.TCPD2<>Nulo)),<T>No Capturar Porcentajes Negativos<T>,  )))))))))<BR>        )<BR>Si(Mavi.TipoSucurAnalisis<>Nulo,Si(SQL(<T>Select Tipo From Sucursal Where Tipo in (<T>+Mavi.TipoSucurAnalisis+<T>)<T>)=Nulo,<T>Se Capturó un Tipo de Sucursal Invalida<T>,<BR>        Si(Mavi.PorcBonif=Nulo,<CONTINUA>
EjecucionMensaje007=<CONTINUA><T>Seleccionar Opcion de % de Bonificacion<T>,<BR>        Si(Mavi.AnalitConden=Nulo,<T>Capturar tipo de Reporte<T>,<BR>        Si(Mavi.TipoFormato=Nulo,<T>Capturar Tipo de Formato<T>,<BR>        Si((Mavi.TipoFormato=<T>Sólo VIU<T>)y((Mavi.TCPU=Nulo)o(Mavi.TCPD1=Nulo)o(Mavi.TCPD2=Nulo)),<T>Capturar Todos los Porcentajes de TC<T>,<BR>        Si((OpcionEnTexto(Mavi.TipoFormato,<T>Muebles América y MAVI<T>,<T>Sólo Crédito Muebles América<T>)<><T><T>)y((Mavi.TCPU<>Nulo)o(Mavi.TCPD1<>Nulo)o(Mavi.TCPD2<>Nulo)),<T>No Capturar Porcentaje de TC para Muebles América o MAVI<T>,<BR>        Si((ConDatos(Info.FechaA))y(Info.fechaD=Nulo),<T>Especificar Rango de Fechas<T>,<BR>        Si((ConDatos(Info.fechaD))y(Info.FechaA=Nulo),<T>Especificar Rango de Fechas<T>,<BR>        Si(Info.FechaD>Info.FechaA,<T>La<CONTINUA>
EjecucionMensaje008=<CONTINUA> Primer Fecha debe ser Menor a la Primera<T>,<BR>        Si(((Mavi.TCPU<0)y(Mavi.TCPU<>Nulo))o((Mavi.TCPD1<0)y(Mavi.TCPD1<>Nulo))o((Mavi.TCPD2<0)y(Mavi.TCPD2<>Nulo)),<T>No Capturar Porcentajes Negativos<T>,  )))))))))),<BR>        //SiNo<BR>        Si(Mavi.PorcBonif=Nulo,<T>Seleccionar Opcion de % de Bonificacion<T>,<BR>        Si(Mavi.AnalitConden=Nulo,<T>Capturar tipo de Reporte<T>,<BR>        Si(Mavi.TipoFormato=Nulo,<T>Capturar Tipo de Formato<T>,<BR>        Si((Mavi.TipoFormato=<T>Sólo VIU<T>)y((Mavi.TCPU=Nulo)o(Mavi.TCPD1=Nulo)o(Mavi.TCPD2=Nulo)),<T>Capturar Todos los Porcentajes de TC<T>,<BR>        Si((OpcionEnTexto(Mavi.TipoFormato,<T>Muebles América y MAVI<T>,<T>Sólo Crédito Muebles América<T>)<><T><T>)y((Mavi.TCPU<>Nulo)o(Mavi.TCPD1<>Nulo)o(Mavi.TCPD2<>Nulo)),<T>No Capturar Porc<CONTINUA>
EjecucionMensaje009=<CONTINUA>entaje de TC para Muebles América o MAVI<T>,<BR>        Si((ConDatos(Info.FechaA))y(Info.fechaD=Nulo),<T>Especificar Rango de Fechas<T>,<BR>        Si((ConDatos(Info.fechaD))y(Info.FechaA=Nulo),<T>Especificar Rango de Fechas<T>,<BR>        Si(Info.FechaD>Info.FechaA,<T>La Primer Fecha debe ser Menor a la Primera<T>,<BR>        Si(((Mavi.TCPU<0)y(Mavi.TCPU<>Nulo))o((Mavi.TCPD1<0)y(Mavi.TCPD1<>Nulo))o((Mavi.TCPD2<0)y(Mavi.TCPD2<>Nulo)),<T>No Capturar Porcentajes Negativos<T>,  )))))))))<BR>        )<BR>Si(condatos(Mavi.SucuAdeC),Si(SQL(<T>Select Sucursal From Sucursal Where Sucursal in (<T>+Mavi.SucuAdeC+<T>)<T>)=Nulo,<T>Se Capturó una Sucursal Invalida<T>,<BR>        Si(Mavi.PorcBonif=Nulo,<T>Seleccionar Opcion de % de Bonificacion<T>,<BR>        Si(Mavi.AnalitConden=Nulo,<T>Capturar tipo d<CONTINUA>
EjecucionMensaje010=<CONTINUA>e Reporte<T>,<BR>        Si(Mavi.TipoFormato=Nulo,<T>Capturar Tipo de Formato<T>,<BR>        Si((Mavi.TipoFormato=<T>Sólo VIU<T>)y((Mavi.TCPU=Nulo)o(Mavi.TCPD1=Nulo)o(Mavi.TCPD2=Nulo)),<T>Capturar Todos los Porcentajes de TC<T>,<BR>        Si((OpcionEnTexto(Mavi.TipoFormato,<T>Muebles América y MAVI<T>,<T>Sólo Crédito Muebles América<T>)<><T><T>)y((Mavi.TCPU<>Nulo)o(Mavi.TCPD1<>Nulo)o(Mavi.TCPD2<>Nulo)),<T>No Capturar Porcentaje de TC para Muebles América o MAVI<T>,<BR>        Si((ConDatos(Info.FechaA))y(Info.fechaD=Nulo),<T>Especificar Rango de Fechas<T>,<BR>        Si((ConDatos(Info.fechaD))y(Info.FechaA=Nulo),<T>Especificar Rango de Fechas<T>,<BR>        Si(Info.FechaD>Info.FechaA,<T>La Primer Fecha debe ser Menor a la Primera<T>,<BR>        Si(((Mavi.TCPU<0)y(Mavi.TCPU<>Nulo))o((Mavi.T<CONTINUA>
EjecucionMensaje011=<CONTINUA>CPD1<0)y(Mavi.TCPD1<>Nulo))o((Mavi.TCPD2<0)y(Mavi.TCPD2<>Nulo)),<T>No Capturar Porcentajes Negativos<T>,<BR>        Si(Mavi.TipoSucurAnalisis<>Nulo,Si(SQL(<T>Select Tipo From Sucursal Where Tipo in (<T>+Mavi.TipoSucurAnalisis+<T>)<T>)=Nulo,<T>Se Capturó un Tipo de Sucursal Invalida<T>,), )<BR>        )))))))))),<BR>        //SiNo<BR>        Si(Mavi.PorcBonif=Nulo,<T>Seleccionar Opcion de % de Bonificacion<T>,<BR>        Si(Mavi.AnalitConden=Nulo,<T>Capturar tipo de Reporte<T>,<BR>        Si(Mavi.TipoFormato=Nulo,<T>Capturar Tipo de Formato<T>,<BR>        Si((Mavi.TipoFormato=<T>Sólo VIU<T>)y((Mavi.TCPU=Nulo)o(Mavi.TCPD1=Nulo)o(Mavi.TCPD2=Nulo)),<T>Capturar Todos los Porcentajes de TC<T>,<BR>        Si((OpcionEnTexto(Mavi.TipoFormato,<T>Muebles América y MAVI<T>,<T>Sólo Crédito Muebles Amér<CONTINUA>
EjecucionMensaje012=<CONTINUA>ica<T>)<><T><T>)y((Mavi.TCPU<>Nulo)o(Mavi.TCPD1<>Nulo)o(Mavi.TCPD2<>Nulo)),<T>No Capturar Porcentaje de TC para Muebles América o MAVI<T>,<BR>        Si((ConDatos(Info.FechaA))y(Info.fechaD=Nulo),<T>Especificar Rango de Fechas<T>,<BR>        Si((ConDatos(Info.fechaD))y(Info.FechaA=Nulo),<T>Especificar Rango de Fechas<T>,<BR>        Si(Info.FechaD>Info.FechaA,<T>La Primer Fecha debe ser Menor a la Primera<T>,<BR>        Si(((Mavi.TCPU<0)y(Mavi.TCPU<>Nulo))o((Mavi.TCPD1<0)y(Mavi.TCPD1<>Nulo))o((Mavi.TCPD2<0)y(Mavi.TCPD2<>Nulo)),<T>No Capturar Porcentajes Negativos<T>,<BR>        Si(Mavi.TipoSucurAnalisis<>Nulo,Si(SQL(<T>Select Tipo From Sucursal Where Tipo in (<T>+Mavi.TipoSucurAnalisis+<T>)<T>)=Nulo,<T>Se Capturó un Tipo de Sucursal Invalida<T>,), ))))))))))<BR>        )<BR>/*<BR>Si(Mavi.Po<CONTINUA>
EjecucionMensaje013=<CONTINUA>rcBonif=Nulo,<T>Seleccionar Opcion de % de Bonificacion<T>,Si(Mavi.AnalitConden=Nulo,<T>Capturar tipo de Reporte<T>,Si(Mavi.TipoFormato=Nulo,<T>Capturar Tipo de Formato<T>,Si((Mavi.TipoFormato=<T>Sólo VIU<T>)y((Mavi.TCPU=Nulo)o(Mavi.TCPD1=Nulo)o(Mavi.TCPD2=Nulo)),<T>Capturar Todos los Porcentajes de TC<T>,<BR>Si((OpcionEnTexto(Mavi.TipoFormato,<T>Muebles América y MAVI<T>,<T>Sólo Crédito Muebles América<T>)<><T><T>)y((Mavi.TCPU<>Nulo)o(Mavi.TCPD1<>Nulo)o(Mavi.TCPD2<>Nulo)),<T>No Capturar Porcentaje de TC para Muebles América o MAVI<T>,<BR>Si((ConDatos(Info.FechaA))y(Info.fechaD=Nulo),<T>Especificar Rango de Fechas<T>,Si((ConDatos(Info.fechaD))y(Info.FechaA=Nulo),<T>Especificar Rango de Fechas<T>,Si(Info.FechaD>Info.FechaA,<T>La Primer Fecha debe ser Menor a la Primera<T>,<BR><BR>Si(((Mavi.<CONTINUA>
EjecucionMensaje014=<CONTINUA>TCPU<0)y(Mavi.TCPU<>Nulo))o((Mavi.TCPD1<0)y(Mavi.TCPD1<>Nulo))o((Mavi.TCPD2<0)y(Mavi.TCPD2<>Nulo)),<T>No Capturar Porcentajes Negativos<T>,<BR>Si(Mavi.ArtFamLigLin<>Nulo,Si(SQL(<T>Select Familia From Art Where Familia = :tFam<T>,Mavi.ArtFamLigLin)=Nulo,<T>Familia de Articulo Incorrecta<T>,<BR>    Si(Mavi.ArtLinLigLin<>Nulo,Si(SQL(<T>Select Linea From Art Where Linea = :tFam<T>,Mavi.ArtLinLigLin)=Nulo,<T>Linea de Articulo Incorrecta<T>,),<BR>))))))))))))<BR>Si(Mavi.TipoSucurAnalisis<>Nulo,Si(SQL(<T>Select Tipo From Sucursal Where Tipo in (<T>+Mavi.TipoSucurAnalisis+<T>)<T>)=Nulo,<T>Se Capturó un Tipo de Sucursal Invalida<T>,Si(condatos(Mavi.SucuAdeC),Si(SQL(<T>Select Sucursal From Sucursal Where Sucursal in (<T>+Mavi.SucuAdeC+<T>)<T>)=Nulo,<T>Se Capturó una Sucursal Invalida<T>,))))<BR>Si(c<CONTINUA>
EjecucionMensaje015=<CONTINUA>ondatos(Mavi.SucuAdeC),Si(SQL(<T>Select Sucursal From Sucursal Where Sucursal in (<T>+Mavi.SucuAdeC+<T>)<T>)=Nulo,<T>Se Capturó una Sucursal Invalida<T>,Si(Mavi.TipoSucurAnalisis<>Nulo,Si(SQL(<T>Select Tipo From Sucursal Where Tipo in (<T>+Mavi.TipoSucurAnalisis+<T>)<T>)=Nulo,<T>Se Capturó un Tipo de Sucursal Invalida<T>,))))<BR>Si(((Mavi.TCPU<0)y(Mavi.TCPU<>Nulo))o((Mavi.TCPD1<0)y(Mavi.TCPD1<>Nulo))o((Mavi.TCPD2<0)y(Mavi.TCPD2<>Nulo)),<T>No Capturar Porcentajes Negativos<T>,)<BR>Si((OpcionEnTexto(Mavi.TipoFormato,<T>Muebles América y MAVI<T>,<T>Sólo Crédito Muebles América<T>)<><T><T>)y((Mavi.TCPU<>Nulo)o(Mavi.TCPD1<>Nulo)o(Mavi.TCPD2<>Nulo)),<T>No Capturar Porcentaje de TC para Muebles América o MAVI<T>,)<BR>Si((Mavi.TipoFormato=<T>Sólo VIU<T>)y((Mavi.TCPU=Nulo)o(Mavi.TCPD1=Nulo)o(Mavi.T<CONTINUA>
EjecucionMensaje016=<CONTINUA>CPD2=Nulo)),<T>Capturar Todos los Porcentajes de TC<T>,Si((OpcionEnTexto(Mavi.TipoFormato,<T>Muebles América y MAVI<T>,<T>Sólo Crédito Muebles América<T>)<><T><T>)y((Mavi.TCPU<>Nulo)o(Mavi.TCPD1<>Nulo)o(Mavi.TCPD2<>Nulo)),<T>No Capturar Porcentaje de TC para Muebles América o MAVI<T>,))<BR>*/<BR>/*<BR>Si(Mavi.ArtLinLigLin<>Nulo,Si(SQL(<T>Select Familia From Art Where Familia = :tFam<T>,Mavi.ArtLinLigLin)=Nulo,<T>Linea de Articulo Incorrecta<T>,),<BR>Si(Mavi.TipoSucurAnalisis<>Nulo,Si(SQL(<T>Select Tipo From Sucursal Where Tipo in (<T>+Mavi.TipoSucurAnalisis+<T>)<T>)=Nulo,<T>Se Capturó un Tipo de Sucursal Invalida<T>,)<BR>Si(condatos(Mavi.SucuAdeC),Si(SQL(<T>Select Sucursal From Sucursal Where Sucursal in (<T>+Mavi.SucuAdeC+<T>)<T>)=Nulo,<T>Se Capturó una Sucursal Invalida<T>,),),<BR>Si(con<CONTINUA>
EjecucionMensaje017=<CONTINUA>datos(Mavi.SucuAdeC),Si(SQL(<T>Select Sucursal From Sucursal Where Sucursal in (<T>+Mavi.SucuAdeC+<T>)<T>)=Nulo,<T>Se Capturó una Sucursal Invalida<T>,),<BR>))))))))))))))   */       <BR><BR>//Mavi.SucuAdeC<BR>//Si(Mavi.TipoSucurAnalisis<>Nulo,Si(SQL(<T>Select Tipo From Sucursal Where Tipo in (<T>+Mavi.TipoSucurAnalisis+<T>)<T>)=Nulo,<T>Tipo Sucursal Invalido<T>,),))))))))))))
[(Variables).Mavi.AnalitConden]
Carpeta=(Variables)
Clave=Mavi.AnalitConden
Editar=S
LineaNueva=S
ValidaNombre=N
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
OcultaNombre=S
Efectos=[Negritas]
[(Variables).Mavi.DiaPorVencer]
Carpeta=(Variables)
Clave=Mavi.DiaPorVencer
Editar=N
LineaNueva=S
ValidaNombre=N
3D=N
Tamano=20
ColorFondo=Plata
ColorFuente=Negro
OcultaNombre=S
Efectos=[Negritas]
IgnoraFlujo=S
[(Variables).Mavi.TipoFormato]
Carpeta=(Variables)
Clave=Mavi.TipoFormato
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
EspacioPrevio=N
[(Variables).Mavi.TipoSucurAnalisis]
Carpeta=(Variables)
Clave=Mavi.TipoSucurAnalisis
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[(Variables).Mavi.SucuAdeC]
Carpeta=(Variables)
Clave=Mavi.SucuAdeC
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[Acciones.Actualiza.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si Mavi.TipoFormato = <T>Muebles América y MAVI<T> Entonces Asigna(Mavi.UEN,comillas(<T>MUEBLES AMERICA<T>)+<T>,<T>+comillas(<T>MAVI<T>))<BR>sino Si Mavi.TipoFormato = <T>Sólo VIU<T> Entonces Asigna(Mavi.UEN,comillas(<T>VIU<T>))<BR>Sino Si Mavi.TipoFormato = <T>Sólo Crédito Muebles América<T> Entonces Asigna(Mavi.UEN,comillas(<T>MUEBLES AMERICA<T>))
[Acciones.Actualiza.Refresh]
Nombre=Refresh
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[TC]
Estilo=Ficha
Clave=TC
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
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
ListaEnCaptura=Mavi.DiaVencimiento<BR>Mavi.TCPUT<BR>Mavi.TCPD1T<BR>Mavi.TCPD2T
CarpetaVisible=S
[TC.Mavi.DiaVencimiento]
Carpeta=TC
Clave=Mavi.DiaVencimiento
Editar=N
LineaNueva=S
ValidaNombre=N
3D=N
Tamano=20
ColorFondo=Plata
ColorFuente=Azul
OcultaNombre=S
Efectos=[Negritas + Subrayado]
[(Variables).Mavi.PorcBonif]
Carpeta=(Variables)
Clave=Mavi.PorcBonif
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[TC.Mavi.TCPUT]
Carpeta=TC
Clave=Mavi.TCPUT
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[TC.Mavi.TCPD1T]
Carpeta=TC
Clave=Mavi.TCPD1T
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[TC.Mavi.TCPD2T]
Carpeta=TC
Clave=Mavi.TCPD2T
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Actualiza.Asigna2]
Nombre=Asigna2
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si(Mavi.TCPUT<>Nulo,Asigna(Mavi.TCPU,textoennum(Mavi.TCPUT)),Asigna(Mavi.TCPU,Nulo))<BR>Si(Mavi.TCPD1T<>Nulo,Asigna(Mavi.TCPD1,textoennum(Mavi.TCPD1T)),Asigna(Mavi.TCPD1,Nulo))<BR>Si(Mavi.TCPD2T<>Nulo,Asigna(Mavi.TCPD2,textoennum(Mavi.TCPD2T)),Asigna(Mavi.TCPD2,Nulo))<BR>//Asigna(Mavi.TCPD1T,textoennum(Mavi.TCPD1))<BR>//Asigna(Mavi.TCPD2T,textoennum(Mavi.TCPD2))
[Acciones.Preliminar.Asign1]
Nombre=Asign1
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.TCPU,Mavi.TCPUT)<BR>Asigna(Mavi.TCPD1,Mavi.TCPD1T)<BR>Asigna(Mavi.TCPD2T,Mavi.TCPD2T)
[(Variables).Mavi.RM0195TipoVecoRep]
Carpeta=(Variables)
Clave=Mavi.RM0195TipoVecoRep
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
EspacioPrevio=S
[Acciones.Generar]
Nombre=Generar
Boton=17
NombreEnBoton=S
NombreDesplegar=&Generar Txt
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=RM0195ReporteVecoTxtFRM
Activo=S
Visible=S

