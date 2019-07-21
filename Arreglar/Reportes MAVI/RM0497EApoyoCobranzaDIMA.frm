
[Forma]
Clave=RM0497EApoyoCobranzaDIMA
Icono=552
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
Nombre=RM0497 Apoyo DIMA

ListaAcciones=Preliminar<BR>Excel<BR>Txt<BR>Cerrar
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=600
PosicionInicialArriba=366
PosicionInicialAlturaCliente=233
PosicionInicialAncho=283
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Info.Ejercicio, Año(hoy))<BR>Asigna(Mavi.Quincena,si  Año(Hoy) > 15 entonces Mes(Hoy)*2 sino (Mes(Hoy)*2)-1 fin)<BR>Asigna(Mavi.RM0497EDivision,Nulo)<BR>Asigna(Mavi.RM0497EZona,Nulo)<BR>Asigna(Mavi.RM0497ENivelCobranza,Nulo)<BR>Asigna(Mavi.RM0497EEquipo,Nulo)<BR>Asigna(Mavi.RM0497ETipo,Nulo)
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
Activo=S
Visible=S
NombreEnBoton=S
Multiple=S

ListaAccionesMultiples=Asignar<BR>Expresion
[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=controles Captura
Activo=S
Visible=S
ClaveAccion=Variables Asignar

[Acciones.Preliminar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Si<BR>  condatos(Info.Ejercicio) y condatos(Mavi.Quincena) y condatos(Mavi.RM0497ETipo)<BR>Entonces<BR>  verdadero<BR>Sino<BR>  informacion(<T>Ingrese Ejercicio, Quincena y Tipo son campos obligatorios<T>)<BR>Fin<BR><BR>Si<BR>  Mavi.RM0497ETipo = <T>DETALLADO<T><BR>Entonces<BR>    ReportePantalla(<T>RM0497EDetalladoCteFinalesRep<T>)   <BR>Sino<BR>  Si<BR>    Mavi.RM0497ETipo = <T>GENERAL<T><BR>Entonces<BR>    ReportePantalla(<T>RM0497EGeneralCteFinalesRep<T>)<BR>     Sino<BR>     Si<BR>  Mavi.RM0497ETipo = <T>CONCENTRADO<T><BR>Entonces<BR> ReportePantalla(<T>RM0497EConcentradoCteFinalesRep<T>)<BR>Fin<BR>Fin<BR>Fin
[(Variables)]
Estilo=Ficha
Clave=(Variables)
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
ListaEnCaptura=Info.Ejercicio<BR>Mavi.Quincena<BR>Mavi.RM0497EDivision<BR>Mavi.RM0497EZona<BR>Mavi.RM0497ENivelCobranza<BR>Mavi.RM0497EEquipo<BR>Mavi.RM0497ETipo
CarpetaVisible=S

[(Variables).Info.Ejercicio]
Carpeta=(Variables)
Clave=Info.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.Quincena]
Carpeta=(Variables)
Clave=Mavi.Quincena
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.RM0497EDivision]
Carpeta=(Variables)
Clave=Mavi.RM0497EDivision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.RM0497EZona]
Carpeta=(Variables)
Clave=Mavi.RM0497EZona
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.RM0497ENivelCobranza]
Carpeta=(Variables)
Clave=Mavi.RM0497ENivelCobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.RM0497EEquipo]
Carpeta=(Variables)
Clave=Mavi.RM0497EEquipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.RM0497ETipo]
Carpeta=(Variables)
Clave=Mavi.RM0497ETipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.Excel]
Nombre=Excel
Boton=115
NombreEnBoton=S
NombreDesplegar=&Excel
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S

ListaAccionesMultiples=Asignar<BR>Expresion
[Acciones.Txt]
Nombre=Txt
Boton=54
NombreEnBoton=S
NombreDesplegar=&Txt
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S

ListaAccionesMultiples=Asignar<BR>Expresion
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Excel.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Txt.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=controles Captura
ClaveAccion=variables Asignar
Activo=S
Visible=S

[Vista.Columnas]
Division=184
Zona=94
Nombre=604

[Seleccionar.Columnas]
Equipo=94

[Acciones.Txt.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Si<BR>  condatos(Info.Ejercicio) y condatos(Mavi.Quincena) y condatos(Mavi.RM0497ETipo)<BR>Entonces<BR>  verdadero<BR>Sino<BR>  informacion(<T>Ingrese Ejercicio, Quincena y Tipo son campos obligatorios<T>)<BR>Fin<BR><BR>Si<BR>  Mavi.RM0497ETipo = <T>DETALLADO<T><BR>Entonces<BR>    Reporteimpresora(<T>RM0497EDetalladoCteFinalesRepTxt<T>)<BR>Sino<BR>  Si<BR>    Mavi.RM0497ETipo = <T>GENERAL<T><BR>Entonces<BR>    informacion(<T>SOLO ESTA DISPONIBLE EN PRELIMINAR Y EXCEL<T>)<BR>     Sino<BR>     Si<BR>  Mavi.RM0497ETipo = <T>CONCENTRADO<T><BR>Entonces<BR> informacion(<T>SOLO ESTA DISPONIBLE EN PRELIMINAR Y EXCEL<T>)<BR>Fin<BR>Fin<BR>Fin
[Acciones.Excel.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=expresion
Activo=S
Visible=S



Expresion=Si<BR>  condatos(Info.Ejercicio) y condatos(Mavi.Quincena) y condatos(Mavi.RM0497ETipo)<BR>Entonces<BR>  verdadero<BR>Sino<BR>  informacion(<T>Ingrese Ejercicio, Quincena y Tipo son campos obligatorios<T>)<BR>Fin<BR><BR>Si<BR>  Mavi.RM0497ETipo = <T>DETALLADO<T><BR>Entonces<BR>   Informacion(<T>Reporte solo disponible en PRELIMINAR Y TXT<T>)   <BR>Sino<BR>  Si<BR>    Mavi.RM0497ETipo = <T>GENERAL<T><BR>Entonces<BR>    ReporteExcel(<T>RM0497EGeneralCteFinalesRepXls<T>)<BR>     Sino<BR>     Si<BR>  Mavi.RM0497ETipo = <T>CONCENTRADO<T><BR>Entonces<BR> ReporteExcel(<T>RM0497EConcentradoCteFinalesRepXls<T>)<BR>Fin<BR>Fin<BR>Fin

