
[Forma]
Clave=RM1200Sancionador
Icono=0
Modulos=(Todos)
Nombre=Sancionador

ListaCarpetas=FiltrosPersonal<BR>Movimientos<BR>Reporte
CarpetaPrincipal=FiltrosPersonal
PosicionInicialAlturaCliente=299
PosicionInicialAncho=516
PosicionInicialIzquierda=425
PosicionInicialArriba=215
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraAcciones=S
AccionesTamanoBoton=20x5
ListaAcciones=Mostrar
AccionesCentro=S
PosicionCol1=313
PosicionSec1=198
ExpresionesAlMostrar=Asigna(Mavi.RM1200Plazas,Nulo)<BR>Asigna(Mavi.RM1200Movimiento,Nulo)<BR>Asigna(Mavi.RM1200TipoCliente,Nulo)<BR>Asigna( Mavi.RM1200FechaFin,FechaDMA(sql(<T>SELECT GETDATE()-1<T>) ))<BR>Asigna( Mavi.RM1200FechaIni,FechaDMA(sql(<T>SELECT GETDATE()-1<T>) ))<BR>Asigna( Info.FechaD,FechaDMA(sql(<T>SELECT GETDATE()-1<T>) ))<BR>Asigna( Info.FechaA,FechaDMA(sql(<T>SELECT GETDATE()-1<T>) ))       <BR> Asigna( Mavi.RM1200Reporte, <T>Personal<T> )
[FiltrosPersonal]
Estilo=Ficha
Pestana=S
Clave=FiltrosPersonal
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.FechaD<BR>Info.FechaA<BR>Mavi.RM1200Plazas
CarpetaVisible=S

FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
PestanaOtroNombre=S
PestanaNombre=Personal
[FiltrosPersonal.Info.FechaD]
Carpeta=FiltrosPersonal
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[FiltrosPersonal.Info.FechaA]
Carpeta=FiltrosPersonal
Clave=Info.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


[Plazas.Columnas]
Descripcion=604
0=-2

[FiltrosPersonal.Mavi.RM1200Plazas]
Carpeta=FiltrosPersonal
Clave=Mavi.RM1200Plazas
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco



[Acciones.Mostrar]
Nombre=Mostrar
Boton=-1
NombreEnBoton=S
NombreDesplegar=Generar Reporte
Multiple=S
EnBarraAcciones=S
TipoAccion=Controles Captura
Activo=S
Visible=S

ListaAccionesMultiples=AsignarBn<BR>Reporte

[Acciones.Mostrar.Reporte]
Nombre=Reporte
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S



ConCondicion=S
Expresion=Si<BR>  (Mavi.RM1200Reporte=<T>Movimientos<T>)<BR>Entonces<BR>       Si (Mavi.RM1200FechaIni=nulo) o  (Mavi.RM1200FechaFin=nulo)<BR>    Entonces                                                           <BR>          informacion(<T>Falta indicar Fecha<T>)<BR>    Sino<BR>         Si (Mavi.RM1200TipoCliente=nulo) o  (Mavi.RM1200Movimiento=nulo)<BR>            Entonces<BR>            Informacion(<T>Falta Información por llenar<T>)<BR>        Sino<BR>              ReportePantalla(<T>RM1200MovimientosSancionesRep<T>)<BR>        Fin<BR><BR>    Fin<BR><BR>Sino<BR>    Si (Info.FechaA=nulo) o  (Info.FechaD=nulo)<BR>    Entonces<BR>          informacion(<T>Falta indicar Fecha<T>)<BR>    Sino<BR>      ReportePantalla(<T>RM1200SancionesPersonalRep<T>)<BR>    Fin<BR><BR>Fin
EjecucionCondicion=Si<BR>  (Mavi.RM1200Reporte=<T>Personal<T>)<BR>Entonces<BR>    Si<BR>        ConDatos(Info.FechaD) y ConDAtos(Info.FechaA) y ((Info.FechaA<Info.FechaD) o ((Info.FechaA>sql(<T>SELECT GETDATE()-1<T>))o (Info.FechaD>sql(<T>SELECT GETDATE()-1<T>))))<BR>    Entonces<BR>        Informacion(<T>Rango de Fecha Inválido<T>)<BR>        AbortarOperacion<BR>    sino<BR>        Si<BR>        Info.FechaA=nulo o Info.FechaD= nulo             <BR>    Entonces                                                                                                                                                                                       <BR>        Informacion(<T>Falta indicar fecha<T>)<BR>        Sino<BR>        Verdadero<BR>        Fin<BR>    Fin<BR>Sino<BR>  Si<BR>        ConDatos(Mavi.RM1200FechaIni) y ConDAtos(Mavi.RM1200FechaFin) y ((Mavi.RM1200FechaFin<Mavi.RM1200FechaIni) o ((Mavi.RM1200FechaIni>sql(<T>SELECT GETDATE()-1<T>))o (Mavi.RM1200FechaFin>sql(<T>SELECT GETDATE()-1<T>))))<BR>    Entonces<BR>        Informacion(<T>Rango de Fecha Inválido<T>)<BR>        AbortarOperacion<BR>    sino<BR>        Si<BR>        Mavi.RM1200FechaIni=nulo o Mavi.RM1200FechaFin= nulo<BR>    Entonces<BR>        Informacion(<T>Falta indicar fecha<T>)<BR>        Sino<BR>        Verdadero<BR>        Fin<BR>    Fin<BR>Fin
[Acciones.Mostrar.AsignarBn]
Nombre=AsignarBn
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


[Movimientos]
Estilo=Ficha
Pestana=S
Clave=Movimientos
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A2
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM1200FechaIni<BR>Mavi.RM1200FechaFin<BR>Mavi.RM1200Movimiento<BR>Mavi.RM1200TipoCliente
CarpetaVisible=S

PestanaOtroNombre=S
PestanaNombre=Movimientos
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S


[Movimientos.Mavi.RM1200Movimiento]
Carpeta=Movimientos
Clave=Mavi.RM1200Movimiento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Movimientos.Mavi.RM1200TipoCliente]
Carpeta=Movimientos
Clave=Mavi.RM1200TipoCliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Carpeta Abrir)]
Estilo=Ficha
Pestana=S
Clave=(Carpeta Abrir)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPaginaEsp=200
CampoColorLetras=Negro
CampoColorFondo=Negro
CarpetaVisible=S

[Acciones.Mostrar1]
Nombre=Mostrar1
Boton=0
NombreDesplegar=Generar Reporte
Multiple=S
EnMenu=S
Activo=S
Visible=S

ListaAccionesMultiples=Asignar
EspacioPrevio=S
TeclaFuncion=F1
[Acciones.Mostrar1.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S




[Movimientos.Mavi.RM1200FechaIni]
Carpeta=Movimientos
Clave=Mavi.RM1200FechaIni
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Movimientos.Mavi.RM1200FechaFin]
Carpeta=Movimientos
Clave=Mavi.RM1200FechaFin
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Reporte]
Estilo=Ficha
Clave=Reporte
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B2
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM1200Reporte
CarpetaVisible=S

FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
FichaAlineacion=Centrado
[Reporte.Mavi.RM1200Reporte]
Carpeta=Reporte
Clave=Mavi.RM1200Reporte
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco




