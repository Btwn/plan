[Forma]
Clave=RM1106CRFrm
Icono=0
Modulos=(Todos)
Nombre=RM1106 RECUPERACION CAJAS
PosicionInicialAlturaCliente=79
PosicionInicialAncho=463
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=408
PosicionInicialArriba=453
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Cerr<BR>Actual<BR>ActualCond<BR>CondHist
ListaCarpetas=Var
CarpetaPrincipal=Var
[(Variables).Mavi.Quincena]
Carpeta=(Variables)
Clave=Mavi.Quincena
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=8
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.Ejercicio]
Carpeta=(Variables)
Clave=Info.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=8
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Cerr]
Nombre=Cerr
Boton=5
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Acp.Asig]
Nombre=Asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Acp.Rep]
Nombre=Rep
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=ReportePantalla(<T>RM1092TASRep<T>)
[Acciones.Det.As]
Nombre=As
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Det.DetTit]
Nombre=DetTit
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=RM1092DETALLETASRep
Activo=S
Visible=S
[Acciones.Det.DetRot]
Nombre=DetRot
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=RM1092DETALLETASROTRep
Activo=S
Visible=S
[Acciones.Ac.ASIGNA]
Nombre=ASIGNA
Boton=0
TipoAccion=EXpresion
Activo=S
Visible=S
Expresion=Asigna( Mavi.Quincena, SQL(<T>SELECT (MONTH(GETDATE())+1)*2<T>) )<BR>Asigna( Info.Ejercicio, Año(Hoy) )
[Acciones.Ac.REPORTILLO]
Nombre=REPORTILLO
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=RM1092TASCajRep
Activo=S
Visible=S
[Acciones.Actual]
Nombre=Actual
Boton=25
NombreEnBoton=S
NombreDesplegar=Detalle Actual
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=ASignacion<BR>Rep
[Acciones.Actual.ASignacion]
Nombre=ASignacion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.RM1092Periodo, <T>ACTUAL<T>)<BR>Asigna(Info.ABC, Usuario)
[Acciones.Actual.Rep]
Nombre=Rep
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=RM1106CR_CajRep
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=//informacion(sql(<T>SELECT Nombre FROM tablastd  WHERE tablast = <T>+comillas(<T>RM1106ACCESO<T>)))<BR>SI<BR>  (sql(<T>SELECT count(*) FROM TablaStd WHERE tablast = <T>+comillas(<T>RM1106ACCESO<T>)+<T> and<BR>  Nombre = (<T>+ <T>SELECT Acceso FROM Usuario WHERE Usuario = <T>+ comillas(<T>DIREC00001<T>)+<T>)<T>)) <> 0<BR>ENTONCES<BR>    VERDADERO<BR>SINO<BR>    FALSO<BR>FIN
EjecucionMensaje=<T>NO TIENE EL PERFIL<T>
[Acciones.Anterior.AsignacionVar]
Nombre=AsignacionVar
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Mavi.RM1092Periodo, <T>ANTERIOR<T>)
Activo=S
Visible=S
[Acciones.Anterior.Reportillo]
Nombre=Reportillo
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=RM1092TASCajRep
Activo=S
Visible=S
[Acciones.DetalleAct.Asg]
Nombre=Asg
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Mavi.RM1092Periodo, <T>ACTUAL<T>)
Activo=S
Visible=S
[Acciones.DetalleAct.Repte]
Nombre=Repte
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=ReportePantalla(<T>RM1092DETALLETASRep<T>)<BR> ReportePantalla(<T>RM1092DETALLETASROTRep<T>)
[Acciones.AnteriorDet.Asgnar]
Nombre=Asgnar
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Mavi.RM1092Periodo, <T>ANTERIOR<T>)
Activo=S
Visible=S
[Acciones.AnteriorDet.Rpte]
Nombre=Rpte
Boton=0
TipoAccion=Expresion
Expresion=ReportePantalla(<T>RM1092DETALLETASRep<T>)<BR>ReportePantalla(<T>RM1092DETALLETASROTRep<T>)
Activo=S
Visible=S
[Var]
Estilo=Ficha
Clave=Var
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM1092Periodo
[Var.Mavi.RM1092Periodo]
Carpeta=Var
Clave=Mavi.RM1092Periodo
Editar=S
Tamano=0
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.ActualCond]
Nombre=ActualCond
Boton=25
NombreEnBoton=S
NombreDesplegar=Condensado Actual
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=Exp<BR>COnd
Activo=S
Visible=S
[Acciones.ActualCond.COnd]
Nombre=COnd
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=RM1106CondensadoRCRep
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=SI<BR>  (sql(<T>SELECT count(*) FROM TablaStd WHERE tablast = <T>+comillas(<T>RM1106ACCESO<T>)+<T> and<BR>  Nombre = (<T>+ <T>SELECT Acceso FROM Usuario WHERE Usuario = <T>+ comillas(Info.ABC)+<T>)<T>)) <> 0<BR>ENTONCES<BR>    VERDADERO<BR>SINO<BR>    FALSO<BR>FIN
EjecucionMensaje=<T>NO TIENE EL PERFIL<T>
[Acciones.ActualCond.Exp]
Nombre=Exp
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Mavi.RM1092Periodo, <T>ACTUAL<T>)<BR>Asigna(Info.ABC, Usuario)
[Acciones.CondHist]
Nombre=CondHist
Boton=35
NombreEnBoton=S
NombreDesplegar=&Rep. Historico Condensado
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=RM1106CondensadoHistFrm
Activo=S
EspacioPrevio=S
VisibleCondicion=SQL(<T>Select Valor from TablaStD<BR>     Where TablaSt = <T>+Comillas(<T>RM1106ACCESO<T>)+<T><BR>     AND Nombre = (Select Acceso From Usuario u Where u.Usuario = :tUsr)<T>,Usuario) = 1


