
[Forma]
Clave=DM0237HerramientaReportaAFrm
Icono=0
Modulos=(Todos)

ListaCarpetas=(Lista)
CarpetaPrincipal=filtros
PosicionInicialIzquierda=303
PosicionInicialArriba=275
PosicionInicialAlturaCliente=369
PosicionInicialAncho=669
PosicionSec1=73
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=(Lista)
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
PosicionSec2=291
Nombre=DM0237 Herramienta Reporta A
ExpresionesAlMostrar=Asigna( Info.Ejercicio, Año( Hoy )  )<BR>Asigna( Mavi.Quincena, Mes(Hoy)  )<BR>Asigna(Mavi.DM0237Agente, nulo)     <BR>Asigna(Mavi.RM1037PersonalEmp, nulo)
[filtros]
Estilo=Ficha
Clave=filtros
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

CarpetaVisible=S





ListaEnCaptura=(Lista)



[filtros.Mavi.Quincena]
Carpeta=filtros
Clave=Mavi.Quincena
Editar=S
ValidaNombre=S
3D=S
Tamano=5
ColorFondo=Blanco
ColorFuente=Negro

[filtros.Info.Ejercicio]
Carpeta=filtros
Clave=Info.Ejercicio
Editar=S
ValidaNombre=S
3D=S
Tamano=8
ColorFondo=Blanco
ColorFuente=Negro

[ArtPersonal.Columnas]
PERSONAL=64
Estatus=94
NOMBRE=303
PUESTO=53
DEPARTAMENTO=91
FECHAALTA=70

[lista]
Estilo=Hoja
Clave=lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=DM0237HerramientaReportaAVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco

CarpetaVisible=S




ListaEnCaptura=(Lista)
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
[lista.Columnas]
Agente=120
ReportaA=162
Fecha=213


UsrMod=120
0=105
1=247
agente=64
[lista_equipos.Columnas]
agente=64




[Acciones.buscar]
Nombre=buscar
Boton=6
EnBarraHerramientas=S
Activo=S
Visible=S



NombreDesplegar=Buscar
Multiple=S
ListaAccionesMultiples=(Lista)

NombreEnBoton=S
BtnResaltado=S
[Acciones.buscar.asignar]
Nombre=asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S




[Acciones.buscar.refrescar]
Nombre=refrescar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S


[(Variables)]
Estilo=Ficha
Clave=(Variables)
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=C1
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
ListaEnCaptura=Mavi.RM1037PersonalEmp
CarpetaVisible=S


[Acciones.modificar]
Nombre=modificar
Boton=0
NombreDesplegar=Modificar
EnBarraHerramientas=S
Activo=S
Visible=S



NombreEnBoton=S
Multiple=S
BtnResaltado=S
EspacioPrevio=S
ListaAccionesMultiples=(Lista)


[Acciones.modificar.asignar]
Nombre=asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.modificar.modificar]
Nombre=modificar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

ConCondicion=S
EjecucionConError=S
Expresion=//Fecha Final del periodo seleccionado<BR>Asigna( Info.FechaD, SQL(<T>select dbo.fnFinNominaRealMavi(:nper,:neje)<T>,Mavi.Quincena, Info.Ejercicio))<BR>Asigna( Info.FechaD, SQL(<T>select DATEADD(second,59,DATEADD(minute,59,DATEADD(hour,23,:ffec)))<T>, Info.FechaD) )<BR>//Ultimo Equipo del Reporta A<BR>Asigna( Info.Nombre, SQL(<T>select top 1 Agente from AgenteReportaHistMAVI where ReportaA= :trep AND Fecha <= :ffin order by Fecha desc<T>, Mavi.RM1037PersonalEmp, Info.FechaD) )<BR>Asigna( Info.IDMAVI, SQL(<T>EXEC Sp_DM0237HERRAMIENTAREPORTAA2 :nper,:nejr,:teq,:tagt,:tusr,:nopc,:tcob<T>,Mavi.Quincena,Info.Ejercicio,Mavi.DM0237Agente,Mavi.RM1037PersonalEmp,Usuario,2,Mavi.DM0237Cobranza ) )<BR><BR><BR>Caso Info.IDMAVI<BR>  Es 0 Entonces Informacion(<T>Reporta A guardado correctamente<T>)<BR>  Es 1 Entonces Precaucion(<T>Asegurate de sacar al Agente: <T>+ Mavi.RM1037PersonalEmp  +<T> del Equipo: <T>+Info.Nombre+<T> y meterlo al: <T>+Mavi.DM0237Agente)<BR>  ES 2 Entonces Precaucion(<T>Asegurate de meter al Agente: <T>+ Mavi.RM1037PersonalEmp  +<T> al Equipo: <T>+Mavi.DM0237Agente)<BR>  ES 3 Entonces Precaucion(<T>Asegurate de sacar al Agente: <T>+ Mavi.RM1037PersonalEmp  +<T> del Equipo: <T>+Info.Nombre+)<BR>  ES 4 Entonces Verdadero<BR>Fin<BR><BR><BR>/*<BR>SI Info.IDMAVI = 0<BR>ENTONCES<BR>    Informacion(<T>Datos registrados correctamente<T>)<BR>SINO<BR>    SI Info.IDMAVI = 2<BR>    ENTONCES<BR>        Precaucion(<T>Asegurate de sacar al Agente: <T>+ Mavi.RM1037PersonalEmp  +<T> del Equipo: <T>+Info.Nombre+<T> y meterlo al: <T>+Mavi.DM0237Agente)<BR>    SINO<BR>        Error(<T>Tipo de Reporta A para Cobranza no es válido<T>)<BR>FIN<BR>*/
EjecucionCondicion=ConDatos( Mavi.Quincena) y ConDatos(Info.Ejercicio) y ConDatos(Mavi.RM1037PersonalEmp) y ConDatos(Mavi.DM0237Agente)
EjecucionMensaje=<T>Complete todos los campos<T>
[Acciones.modificar.refrescar]
Nombre=refrescar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S












[(Variables).ListaEnCaptura]
(Inicio)=Mavi.DM0237Agente
Mavi.DM0237Agente=Info.Agente
Info.Agente=(Fin)















[lista.Agente]
Carpeta=lista
Clave=Agente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro

[lista.ReportaA]
Carpeta=lista
Clave=ReportaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro

[lista.Fecha]
Carpeta=lista
Clave=Fecha
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[lista.UsrMod]
Carpeta=lista
Clave=UsrMod
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro


































[(Variables).Mavi.RM1037PersonalEmp]
Carpeta=(Variables)
Clave=Mavi.RM1037PersonalEmp
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro



[lista.ListaEnCaptura]
(Inicio)=Agente
Agente=ReportaA
ReportaA=Fecha
Fecha=UsrMod
UsrMod=(Fin)










































[filtros.Mavi.DM0237Agente]
Carpeta=filtros
Clave=Mavi.DM0237Agente
Editar=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro








[filtros.Mavi.DM0237Cobranza]
Carpeta=filtros
Clave=Mavi.DM0237Cobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=5
ColorFondo=Blanco
ColorFuente=Negro






[filtros.ListaEnCaptura]
(Inicio)=Mavi.DM0237Agente
Mavi.DM0237Agente=Mavi.Quincena
Mavi.Quincena=Info.Ejercicio
Info.Ejercicio=Mavi.DM0237Cobranza
Mavi.DM0237Cobranza=(Fin)
















[Acciones.buscar.ListaAccionesMultiples]
(Inicio)=asignar
asignar=refrescar
refrescar=(Fin)

















































































[Acciones.modificar.ListaAccionesMultiples]
(Inicio)=asignar
asignar=modificar
modificar=refrescar
refrescar=(Fin)

[Forma.ListaCarpetas]
(Inicio)=filtros
filtros=lista
lista=(Variables)
(Variables)=(Fin)

[Forma.ListaAcciones]
(Inicio)=buscar
buscar=modificar
modificar=(Fin)

