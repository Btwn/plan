
[Forma]
Clave=RM1093COMISCAJASBONOEMAILTMPFRM
Icono=0
Modulos=(Todos)
Nombre=RM1093 COMISION CAJAS EMAIL

ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialAlturaCliente=123
PosicionInicialAncho=1016
ListaAcciones=REP<BR>REPACT<BR>REPANT<BR>DETALLADO<BR>ACTUAL<BR>CERRAR
PosicionInicialIzquierda=220
PosicionInicialArriba=261
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
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
CampoColorFondo=Negro

CarpetaVisible=S


[Acciones.REP]
Nombre=REP
Boton=6
NombreEnBoton=S
NombreDesplegar=REPORTE CONDENSADO ANTERIOR
Multiple=S
EnBarraHerramientas=S
Activo=S

ListaAccionesMultiples=ASIG<BR>asignavar
Visible=S
[Acciones.DETALLADO]
Nombre=DETALLADO
Boton=51
NombreEnBoton=S
NombreDesplegar=REPORTE DETALLADO ANTERIOR
Multiple=S
EnBarraHerramientas=S
Activo=S



EspacioPrevio=S





ListaAccionesMultiples=varasign<BR>rep
VisibleCondicion=SQL(<T>select COUNT(*) from TablaStD d inner join Usuario u on u.Acceso=d.Nombre where d.TablaSt=:ttable and d.Valor=1 and u.Usuario=:tus  <T>,<T>RM1093ACCESOS<T>,usuario) =1
[Acciones.REP.asignavar]
Nombre=asignavar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S


[Acciones.DETALLADO.varasign]
Nombre=varasign
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S








Expresion=Asigna( Mavi.Quincena, SQL(<T>SELECT DBO.Fn_MaviNumQuincena(GETDATE())<T> ) )<BR>Asigna( Info.Ejercicio,  Año(   SQL( <T>SELECT GETDATE()<T> )   ) )
[Acciones.DETALLADO.rep]
Nombre=rep
Boton=0
TipoAccion=Reportes Pantalla
Activo=S
Visible=S


ClaveAccion=RM1093COMISCAJASEMAILDETALLEREP

[Acciones.CERRAR]
Nombre=CERRAR
Boton=5
NombreEnBoton=S
NombreDesplegar=CERRAR
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


















[Acciones.ACEPTAR.ASIGNA]
Nombre=ASIGNA
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Asigna( Mavi.Quincena, SQL(<T>SELECT (MONTH(GETDATE())+1)*2<T>) )<BR>Asigna( Info.Ejercicio, Año(Hoy) )

[Acciones.ACEPTAR.rep]
Nombre=rep
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=RM1093REPORTECOMISCAJASCEMAILREP
Activo=S
Visible=S












[Acciones.ACEPTAR.ListaAccionesMultiples]
(Inicio)=ASIGNA
ASIGNA=rep
rep=(Fin)
























[Acciones.REP.ASIG]
Nombre=ASIG
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna( Mavi.Quincena, SQL(<T>SELECT  case When MONTH(GETDATE()) = 1 Then 12 Else Month(GETDATE())-1 End<T> ) )<BR>Asigna( Info.Ejercicio,  Año(SQL( <T>SELECT case When MONTH(GETDATE()) = 1 Then DateAdd(YY,-1,GETDATE())  Else GETDATE() end<T> )   ) )


[Acciones.REPACT]
Nombre=REPACT
Boton=6
NombreEnBoton=S
NombreDesplegar=REPORTE CONDENSADO ACTUAL
EnBarraHerramientas=S
TipoAccion=Reportes Pantalla
ClaveAccion=RM1093REPORTECOMISCAJASCEMAILREP
Activo=S
Visible=S




Multiple=S
ListaAccionesMultiples=ASIG<BR>REP

[Acciones.REPACT.ASIG]
Nombre=ASIG
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S











Expresion=Asigna( Mavi.Quincena,( SQL(<T>SELECT DBO.Fn_MaviNumQuincena(GETDATE())<T> )) )<BR> Asigna( Info.Ejercicio,  Año(  SQL( <T>SELECT GETDATE()<T> )   ) )
[Acciones.REPACT.REP]
Nombre=REP
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=RM1093REPORTECOMISCAJASCEMAILREP
Activo=S
Visible=S




[Acciones.ACTUAL]
Nombre=ACTUAL
Boton=51
NombreEnBoton=S
NombreDesplegar=REPORTE DETALLADO ACTUAL
EnBarraHerramientas=S
TipoAccion=Reportes Pantalla
ClaveAccion=RM1093COMISCAJASEMAILDETALLEREP
Activo=S











Multiple=S
ListaAccionesMultiples=Expresion<BR>REP


VisibleCondicion=SQL(<T>select COUNT(*) from TablaStD d inner join Usuario u on u.Acceso=d.Nombre where d.TablaSt=:ttable and d.Valor=1 and u.Usuario=:tus  <T>,<T>RM1093ACCESOS<T>,usuario) =1
[Acciones.ACTUAL.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Asigna( Mavi.Quincena,( SQL(<T>SELECT DBO.Fn_MaviNumQuincena(GETDATE()) +2<T> )) )<BR> Asigna( Info.Ejercicio,  Año(  SQL( <T>SELECT GETDATE()<T> )   ) )
[Acciones.ACTUAL.REP]
Nombre=REP
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=RM1093COMISCAJASEMAILDETALLEREP
Activo=S
Visible=S





[Acciones.REPANT.ASIG]
Nombre=ASIG
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna( Mavi.Quincena,( SQL(<T>SELECT DBO.Fn_MaviNumQuincena(GETDATE())<T> )) )<BR> Asigna( Info.Ejercicio,  Año(  SQL( <T>SELECT GETDATE()<T> )   ) )

[Acciones.REPANT]
Nombre=REPANT
Boton=6
NombreEnBoton=S
NombreDesplegar=REPORTE CONDENSADO ANTERIOR POR USUARIO&
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=ASIG<BR>REP
Activo=S
Visible=S
















[Acciones.REPANT.REP]
Nombre=REP
Boton=0
TipoAccion=Reportes Pantalla
Activo=S
Visible=S

ClaveAccion=RM1093REPORTECOMISCAJASCEMAILANTREP
[(Variables).]
Carpeta=(Variables)
ColorFondo=Negro

