
[Forma]
Clave=RM1196ReporteAuditoriaCFDIFrm
Icono=0
Modulos=(Todos)
Nombre=Reportes de Auditoria en CFDI
PosicionInicialAlturaCliente=97
PosicionInicialAncho=366

ListaCarpetas=Reporte
CarpetaPrincipal=Reporte
PosicionInicialIzquierda=576
PosicionInicialArriba=183
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=(Lista)
AccionesCentro=S
PosicionSec1=104
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Por diseño
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
VentanaExclusiva=S
VentanaExclusivaOpcion=1
VentanaColor=Plata
ExpresionesAlMostrar=Asigna( Mavi.RM1196ReporteAuditoriaCFDI, NULO )
[Reporte]
Estilo=Ficha
Clave=Reporte
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM1196ReporteAuditoriaCFDI
CarpetaVisible=S

FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
[Reporte.Mavi.RM1196ReporteAuditoriaCFDI]
Carpeta=Reporte
Clave=Mavi.RM1196ReporteAuditoriaCFDI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=45
ColorFondo=Blanco

[Acciones.Auditar]
Nombre=Auditar
Boton=0
NombreDesplegar=Auditar
EnBarraAcciones=S
TipoAccion=Expresion
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Asiganar<BR>Auditar
[Acciones.Cancelar]
Nombre=Cancelar
Boton=0
NombreDesplegar=&Cancelar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cancelar
Activo=S
Visible=S




[Acciones.Auditar.Auditar]
Nombre=Auditar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Si<BR>   ConDatos( Mavi.RM1196ReporteAuditoriaCFDI) y (Mavi.RM1196ReporteAuditoriaCFDI=<T>Facturas de Crédito sin CFDI<T>)<BR>Entonces<BR>  ReportePantalla(<T>RM1196AuditoriaCFDI1Rep<T>)<BR>Sino<BR>   Si<BR>     ConDatos( Mavi.RM1196ReporteAuditoriaCFDI) y (Mavi.RM1196ReporteAuditoriaCFDI=<T>CFDI Timbrados de Facturas Canceladas<T>)<BR>   Entonces<BR>     ReportePantalla(<T>RM1196AuditoriaCFDI2Rep<T>)<BR>Sino<BR>   Si<BR>     ConDatos( Mavi.RM1196ReporteAuditoriaCFDI) y (Mavi.RM1196ReporteAuditoriaCFDI=<T>Intentos de Timbrado Fallidos<T>)<BR>     Entonces<BR>     ReportePantalla(<T>RM1196AuditoriaCFDI3Rep<T>)<BR>Sino<BR>   Si<BR>     ConDatos( Mavi.RM1196ReporteAuditoriaCFDI) y (Mavi.RM1196ReporteAuditoriaCFDI=<T>CFDI de Egreso inexistentes por Retimbrados<T>)<BR>     Entonces<BR>     ReportePantalla(<T>RM1196AuditoriaCFDI4Rep<T>)<BR>Sino<BR>   Si<BR>     ConDatos( Mavi.RM1196ReporteAuditoriaCFDI) y (Mavi.RM1196ReporteAuditoriaCFDI=<T>CFDI Solicitados Vía Web<T>)<BR>     Entonces<BR>     ReportePantalla(<T>RM1196AuditoriaCFDI5Rep<T>)<BR><BR>Fin<BR>Fin<BR>Fin<BR>Fin
[Acciones.Auditar.Asiganar]
Nombre=Asiganar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S







[Forma.ListaAcciones]
(Inicio)=Auditar
Auditar=Cancelar
Cancelar=(Fin)
