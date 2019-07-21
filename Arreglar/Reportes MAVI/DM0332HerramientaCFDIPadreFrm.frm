
[Forma]
Clave=DM0332HerramientaCFDIPadreFrm
Icono=401
Modulos=(Todos)

ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>aPDF<BR>aTxt<BR>Cerrar
PosicionInicialIzquierda=502
PosicionInicialArriba=322
PosicionInicialAlturaCliente=85
PosicionInicialAncho=362
Nombre=DM0332 Herramienta CFDI Padre
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Mavi.DM0332CFDPadreFechaIni,Nulo)<BR>Asigna(Mavi.DM0332CFDPadreFechaFin,Nulo)
[(Variables)]
Estilo=Ficha
Clave=(Variables)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S

FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata

ListaEnCaptura=Mavi.DM0332CFDPadreFechaIni<BR>Mavi.DM0332CFDPadreFechaFin
PermiteEditar=S
[Acciones.aTxt]
Nombre=aTxt
Boton=54
NombreEnBoton=S
NombreDesplegar=&TXT
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Reportes Impresora
ClaveAccion=DM0169CfdiEgrYPagRelRepTxt
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Asignar<BR>ExportarTxt
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S

NombreEnBoton=S
Visible=S
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Reportes Pantalla
ClaveAccion=DM0332HerramientaCFDIPadreRepPdf
Activo=S

Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>MostrarRep
Visible=S
[Acciones.aTxt.ExportarTxt]
Nombre=ExportarTxt
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=DM0332HerramientaCFDIPadreRepTxt
Activo=S
Visible=S


ConCondicion=S
EjecucionCondicion=SI ConDatos(Mavi.DM0332CFDPadreFechaFin) y ConDatos(Mavi.DM0332CFDPadreFechaIni)<BR>    y ((Mavi.DM0332CFDPadreFechaFin < Mavi.DM0332CFDPadreFechaIni) o (Mavi.DM0332CFDPadreFechaIni <<T>01-01-2018<T> ))<BR><BR>ENTONCES<BR>    INFORMACION(<T>Rango de fecha inválido.<T>)<BR>    Asigna(Mavi.DM0332CFDPadreFechaIni,Mavi.DM0332CFDPadreFechaFin)<BR>    AbortarOperacion<BR>FIN<BR><BR>VERDADERO
[Acciones.aPDF.ExportarPDF]
Nombre=ExportarPDF
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

ConCondicion=S
Expresion=ReportePDF(<T>DM0332HerramientaCFDIPadreRepPdf<T>,<T>(Especifico)<T>)
EjecucionCondicion=SI ConDatos(Mavi.DM0332CFDPadreFechaFin) y ConDatos(Mavi.DM0332CFDPadreFechaIni)<BR>    y ((Mavi.DM0332CFDPadreFechaFin < Mavi.DM0332CFDPadreFechaIni)o (Mavi.DM0332CFDPadreFechaIni <<T>01-01-2018<T> ))<BR><BR>ENTONCES<BR>    INFORMACION(<T>Rango de fecha inválido.<T>)<BR>    Asigna(Mavi.DM0332CFDPadreFechaIni,Mavi.DM0332CFDPadreFechaFin)<BR>    AbortarOperacion<BR>FIN<BR><BR>VERDADERO
[Acciones.aPDF]
Nombre=aPDF
Boton=97
NombreDesplegar=&PDF
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asignar<BR>ExportarPDF
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S



[(Variables).Mavi.DM0332CFDPadreFechaIni]
Carpeta=(Variables)
Clave=Mavi.DM0332CFDPadreFechaIni
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.DM0332CFDPadreFechaFin]
Carpeta=(Variables)
Clave=Mavi.DM0332CFDPadreFechaFin
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.Preliminar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Preliminar.MostrarRep]
Nombre=MostrarRep
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=DM0332HerramientaCFDIPadreRepPdf
Activo=S
Visible=S


ConCondicion=S
EjecucionCondicion=SI ConDatos(Mavi.DM0332CFDPadreFechaFin) y ConDatos(Mavi.DM0332CFDPadreFechaIni)<BR>        y ((Mavi.DM0332CFDPadreFechaFin < Mavi.DM0332CFDPadreFechaIni) o (Mavi.DM0332CFDPadreFechaIni <<T>01-01-2018<T> ))  <BR>ENTONCES<BR>    INFORMACION(<T>Rango de fecha inválido.<T>)<BR>    Asigna(Mavi.DM0332CFDPadreFechaIni,Mavi.DM0332CFDPadreFechaFin)<BR>    AbortarOperacion<BR>FIN<BR><BR>VERDADERO
[Acciones.aTxt.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.aPDF.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S




