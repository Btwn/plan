[Forma]
Clave=DM0194PrincipalExigiblesFrm
Nombre=Explorador de Exigibles
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=500
PosicionInicialArriba=200
PosicionInicialAlturaCliente=220
PosicionInicialAncho=280
BarraHerramientas=S
AccionesTamanoBoton=15x5
ListaAcciones=(Lista)
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
AccionesCentro=S
ExpresionesAlMostrar=Asigna(Mavi.Mes,Nulo)<BR>Asigna(Info.Ejercicio,Nulo)<BR>Asigna(Mavi.InstitucionMavi_A,Nulo)<BR>Asigna(Mavi.DM0194SeccCob,Nulo)<BR>Asigna(Mavi.DM0500BCuotasPer,<T>CONCENTRADO<T>)
PosicionSec1=248

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
ListaEnCaptura=(Lista)
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=4
FichaEspacioNombres=0
FichaColorFondo=Plata
FichaAlineacion=Izquierda
FichaNombres=Izquierda
FichaEspacioNombresAuto=S
[(Variables).Mavi.InstitucionMavi_A]
Carpeta=(Variables)
Clave=Mavi.InstitucionMavi_A
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
NombreEnBoton=S
[Acciones.Aceptar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Si<BR>    Mavi.DM0500BCuotasPer=<T>DETALLE<T><BR>Entonces<BR>     condatos(Mavi.InstitucionMavi_A) y condatos(Mavi.DM0169FiltroPeriodo) y ConDatos(Mavi.DM0169FiltroQuincena) y ConDatos(Info.Ejercicio)<BR>Sino<BR>     condatos(Mavi.DM0169FiltroPeriodo) y ConDatos(Mavi.DM0169FiltroQuincena) y ConDatos(Info.Ejercicio)<BR>FIN
EjecucionMensaje=Si<BR>    Mavi.DM0500BCuotasPer=<T>DETALLE<T><BR>Entonces<BR>     <T>Seleccione Institucion,  Año, Mes y Quincena<T><BR>Sino<BR>     <T>Seleccione Año, Mes y Quincena<T><BR>FIN
[Acciones.Aceptar.Ver]
Nombre=Ver
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si<BR>    Mavi.DM0500BCuotasPer=<T>DETALLE<T><BR>Entonces<BR>     Forma(<T>DM0194ExigiblesFrm<T>)<BR>Sino<BR>     Forma(<T>DM0194ConExigFrm<T>)<BR>FIN
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreDesplegar=&Aceptar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=(Lista)
Activo=S
Visible=S
NombreEnBoton=S

[Acciones.Envio.asi]
Nombre=asi
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Envio.expre]
Nombre=expre
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=EJECUTARSQL(<T>SP_DM0194ExpExigibles :tId,:nMes, :nQui, :tCred,1<T>,<BR>    Mavi.InstitucionMavi_A,<BR>    Reemplaza(ASCII(39),<T> <T>,Mavi.DM0169FiltroPeriodo),<BR>    Reemplaza(ASCII(39),<T> <T>,Mavi.DM0169FiltroQuincena),<BR>    Mavi.DM0194SeccCob)<BR>Asigna(Info.Numero,sql(<T>SELECT COUNT(*) FROM RM0194MovsFueraRangoHist WHERE MES = :tMes AND ClienteEnviarA=:tID AND EJERCICIO = :nAno<T>,SQL(<T>Select dbo.fnMesNumeroNombre(:nPer)<T>,Reemplaza(ASCII(39),<T> <T>,Mavi.DM0169FiltroPeriodo)), Mavi.InstitucionMavi_A,SQL(<T>SELECT YEAR(GETDATE())<T>)))<BR>Informacion(<T>Proceso Terminado...<T> +NuevaLinea+ <T>Se Generon: <T>&si(condatos(Info.Numero),Info.Numero,<T>0<T>)&<T> Movimietos<T>)
EjecucionCondicion=SQL(<T>SELECT dbo.FN_RM0194ExigValidaEnvio( :tMes ,:tId,:tFch)<T>,Mavi.Mes,Mavi.InstitucionMavi_A,sql(<T>select YEAR(getdate())<T>)) = 0
EjecucionMensaje=<T>El Envio ya fue Realizado y NO se podra volver a Afectar<T>
[(Variables).Mavi.DM0169FiltroPeriodo]
Carpeta=(Variables)
Clave=Mavi.DM0169FiltroPeriodo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.DM0169FiltroQuincena]
Carpeta=(Variables)
Clave=Mavi.DM0169FiltroQuincena
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


[(Variables).Mavi.DM0500BCuotasPer]
Carpeta=(Variables)
Clave=Mavi.DM0500BCuotasPer
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).Mavi.DM0194TipoExigible]
Carpeta=(Variables)
Clave=Mavi.DM0194TipoExigible
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro









[(Variables).Info.Ejercicio]
Carpeta=(Variables)
Clave=Info.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro








[ListaInstitucionesMAVI.Columnas]
ID=64
Cadena=304





[SQL.Columnas]
0=148
1=202
2=79
3=113
4=-2
5=76
6=78


[(Variables).ListaEnCaptura]
(Inicio)=Mavi.InstitucionMavi_A
Mavi.InstitucionMavi_A=Mavi.DM0169FiltroPeriodo
Mavi.DM0169FiltroPeriodo=Mavi.DM0169FiltroQuincena
Mavi.DM0169FiltroQuincena=Info.Ejercicio
Info.Ejercicio=Mavi.DM0500BCuotasPer
Mavi.DM0500BCuotasPer=Mavi.DM0194TipoExigible
Mavi.DM0194TipoExigible=(Fin)








[Acciones.Aceptar.ListaAccionesMultiples]
(Inicio)=Asigna
Asigna=Cerrar
Cerrar=Ver
Ver=(Fin)

[Forma.ListaAcciones]
(Inicio)=Aceptar
Aceptar=Cerrar
Cerrar=(Fin)


