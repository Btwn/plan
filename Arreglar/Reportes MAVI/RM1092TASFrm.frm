[Forma]
Clave=RM1092TASFrm
Icono=0
Modulos=(Todos)
Nombre=RM1092  BONO DE TIEMPO AIRE Y SERVICIOS CAJAS
PosicionInicialAlturaCliente=79
PosicionInicialAncho=395
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=442
PosicionInicialArriba=453
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Cerr<BR>Anterior<BR>Actual<BR>AnteriorDet<BR>DetalleAct
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
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
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
ListaEnCaptura=Mavi.RM1092Periodo
[Acciones.Actual]
Nombre=Actual
Boton=25
NombreEnBoton=S
NombreDesplegar=Actual
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=ASignacion<BR>Rep
[Acciones.Anterior]
Nombre=Anterior
Boton=24
NombreEnBoton=S
NombreDesplegar=Anterior
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=AsignacionVar<BR>Reportillo
[Acciones.AnteriorDet]
Nombre=AnteriorDet
Boton=24
NombreEnBoton=S
NombreDesplegar=Detalle Anterior
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Multiple=S
ListaAccionesMultiples=Asgnar<BR>Rpte
VisibleCondicion=SQL(<T>Select Valor from TablaStD<BR>     Where TablaSt = <T>+Comillas(<T>RM1092ACCESOS<T>)+<T><BR>     AND Nombre = (Select Acceso From Usuario u Where u.Usuario = :tUsr)<T>,Usuario) = 1
[Acciones.DetalleAct]
Nombre=DetalleAct
Boton=25
NombreEnBoton=S
NombreDesplegar=Detalle Actual
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Multiple=S
ListaAccionesMultiples=Asg<BR>Repte
VisibleCondicion=SQL(<T>Select Valor from TablaStD<BR>     Where TablaSt = <T>+Comillas(<T>RM1092ACCESOS<T>)+<T><BR>     AND Nombre = (Select Acceso From Usuario u Where u.Usuario = :tUsr)<T>,Usuario) = 1
[(Variables).Mavi.RM1092Periodo]
Carpeta=(Variables)
Clave=Mavi.RM1092Periodo
Editar=S
Tamano=0
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Actual.ASignacion]
Nombre=ASignacion
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Mavi.RM1092Periodo, <T>ACTUAL<T>)
Activo=S
Visible=S
[Acciones.Actual.Rep]
Nombre=Rep
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=RM1092TASCajRep
Activo=S
Visible=S
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


