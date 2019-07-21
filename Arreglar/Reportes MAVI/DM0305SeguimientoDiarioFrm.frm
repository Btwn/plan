
[Forma]
Clave=DM0305SeguimientoDiarioFrm
Icono=733
Modulos=(Todos)
PosicionInicialAlturaCliente=84
PosicionInicialAncho=319

ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
Nombre=DM0305 Seguimiento Diario
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=523
PosicionInicialArriba=323
VentanaEscCerrar=S
VentanaAvanzaTab=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=aExcel<BR>aTxt<BR>Cerrar<BR>Preliminar
BarraHerramientas=S
ExpresionesAlMostrar=Asigna(Mavi.DM0305SegDiaFechaIni,Nulo)<BR>Asigna(Mavi.DM0305SegDiaFechaFin,Nulo)
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
ListaEnCaptura=Mavi.DM0305SegDiaFechaIni<BR>Mavi.DM0305SegDiaFechaFin
CarpetaVisible=S

PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
[(Variables).Mavi.DM0305SegDiaFechaIni]
Carpeta=(Variables)
Clave=Mavi.DM0305SegDiaFechaIni
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.DM0305SegDiaFechaFin]
Carpeta=(Variables)
Clave=Mavi.DM0305SegDiaFechaFin
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


[Acciones.aExcel]
Nombre=aExcel
Boton=115
NombreDesplegar=&Excel
EnBarraHerramientas=S
TipoAccion=Reportes Excel
ClaveAccion=DM0305SeguimientoDiarioRepXls
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S


Multiple=S
ListaAccionesMultiples=Asigna<BR>ExportarExcel
[Acciones.Preliminar]
Nombre=Preliminar
Boton=68
EnBarraHerramientas=S
Activo=S

NombreEnBoton=S
NombreDesplegar=&Preliminar
Multiple=S
ListaAccionesMultiples=Asignar<BR>ExportarExcel<BR>Cerrar
EspacioPrevio=S
[Acciones.aExcel.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.aExcel.ExportarExcel]
Nombre=ExportarExcel
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=DM0305SeguimientoDiarioRepXls
Activo=S
ConCondicion=S
Visible=S


EjecucionCondicion=SI ConDatos(Mavi.DM0305SegDiaFechaFin) y ConDatos(Mavi.DM0305SegDiaFechaIni) y (Mavi.DM0305SegDiaFechaFin < Mavi.DM0305SegDiaFechaIni) ENTONCES<BR>    INFORMACION(<T>Rango de fecha inválido.<T>)<BR>    Asigna(Mavi.DM0305SegDiaFechaIni,Mavi.DM0305SegDiaFechaFin)<BR>    AbortarOperacion<BR>FIN<BR><BR><BR>SI Vacio(Mavi.DM0305SegDiaFechaFin) y Vacio(Mavi.DM0305SegDiaFechaIni) ENTONCES<BR>    ReporteImpresora(<T>DM0305SeguimientoDiarioRepTxt<T>)<BR>    AbortarOperacion<BR>SINO<BR>    VERDADERO<BR>FIN
[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


[Acciones.aTxt]
Nombre=aTxt
Boton=54
NombreEnBoton=S
NombreDesplegar=&TXT
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Reportes Impresora
ClaveAccion=DM0305SeguimientoDiarioRepTxt
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Asigna<BR>ExportarTxt
[Acciones.aTxt.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


[Acciones.aTxt.ExportarTxt]
Nombre=ExportarTxt
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=DM0305SeguimientoDiarioRepTxt
Activo=S
Visible=S

ConCondicion=S
EjecucionCondicion=SI ConDatos(Mavi.DM0305SegDiaFechaFin) y ConDatos(Mavi.DM0305SegDiaFechaIni) y (Mavi.DM0305SegDiaFechaFin < Mavi.DM0305SegDiaFechaIni) ENTONCES<BR>    INFORMACION(<T>Rango de fecha inválido.<T>)<BR>    Asigna(Mavi.DM0305SegDiaFechaIni,Mavi.DM0305SegDiaFechaFin)<BR>    AbortarOperacion<BR>FIN<BR><BR>VERDADERO

[Acciones.Preliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


[Acciones.Preliminar.ExportarExcel]
Nombre=ExportarExcel
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=DM0305SeguimientoDiarioRepXls
Activo=S
ConCondicion=S
Visible=S




EjecucionCondicion=SI ConDatos(Mavi.DM0305SegDiaFechaFin) y ConDatos(Mavi.DM0305SegDiaFechaIni) y (Mavi.DM0305SegDiaFechaFin < Mavi.DM0305SegDiaFechaIni) ENTONCES<BR>    INFORMACION(<T>Rango de fecha inválido.<T>)<BR>    Asigna(Mavi.DM0305SegDiaFechaIni,Mavi.DM0305SegDiaFechaFin)<BR>    AbortarOperacion<BR>FIN<BR><BR><BR>SI Vacio(Mavi.DM0305SegDiaFechaFin) y Vacio(Mavi.DM0305SegDiaFechaIni) ENTONCES<BR>    ReporteImpresora(<T>DM0305SeguimientoDiarioRepTxt<T>)<BR>    Forma.Accion(<T>Cerrar<T>)<BR>    FALSO<BR>SINO<BR>    VERDADERO<BR>FIN
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EnBarraAcciones=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


