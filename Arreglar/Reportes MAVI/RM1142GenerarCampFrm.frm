[Forma]
Clave=RM1142GenerarCampFrm
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=145
PosicionInicialAncho=206
PosicionInicialIzquierda=537
PosicionInicialArriba=420
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=Preliminar<BR>ConfSem<BR>Cerrar<BR>Aceptar
AccionesCentro=S
BarraHerramientas=S
ExpresionesAlMostrar=Asigna(Mavi.RM1142Campa,<T><T>)<BR>Asigna(Mavi.RM1142Check,<T>No<T>)
Nombre=RM1142GenerarCampFrm
PosicionSec1=-32
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
ListaEnCaptura=Mavi.RM1142Campa<BR>Mavi.RM1142Check
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
[(Variables).Mavi.RM1142Campa]
Carpeta=(Variables)
Clave=Mavi.RM1142Campa
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=22
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar]
Nombre=Preliminar
Boton=68
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraAcciones=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asigna<BR>Acepta
[Acciones.ConfSem]
Nombre=ConfSem
Boton=57
NombreEnBoton=S
NombreDesplegar=CONF. SEMBRADOS
EnBarraHerramientas=S
Activo=S
Visible=S
TipoAccion=Formas
ClaveAccion=RM1142DatosPlantadosFrm
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Preliminar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.Acepta]
Nombre=Acepta
Boton=0
TipoAccion=expresion
Activo=S
ConCondicion=S
Visible=S
Expresion=Forma.Accion(<T>Aceptar<T>)
EjecucionCondicion=Si ConDatos(Mavi.RM1142Campa)<BR>    Entonces<BR>    Verdadero<BR>Sino<BR>    Error(<T>Seleccione una campa�a<T>)<BR>    AbortarOperacion<BR>Fin<BR><BR>Si Mavi.RM1142Check = <T>No<T><BR>    Entonces<BR>    Verdadero<BR>Sino<BR>    Forma(<T>RM1142ImportarSembrados<T>)<BR>Fin
[(Variables).Mavi.RM1142Check]
Carpeta=(Variables)
Clave=Mavi.RM1142Check
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=7
ColorFondo=Blanco
ColorFuente=Negro
[sembrado.RM1142ImportarSembradosTbl.telefono]
Carpeta=sembrado
Clave=RM1142ImportarSembradosTbl.telefono
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[sembrado.RM1142ImportarSembradosTbl.Nombre]
Carpeta=sembrado
Clave=RM1142ImportarSembradosTbl.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[sembrado.Columnas]
telefono=94
Nombre=604


[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreDesplegar=&Aceptar
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Ventana<BR>Aceptar
[camp.Columnas]
Nombre=304

[importar.Columnas]
telefono=94
Nombre=604

[Acciones.Aceptar.Ventana]
Nombre=Ventana
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Asigna(Info.Numero,SQL(<T>EXEC Sp_MaviRM1142CartPubSms :nDv, :nMhDv, :tCv, :tSal, :nFecCum, :tMed, :tFam, :tlin, :fultVe, :tSalmon, :fultcomp, :fFechaExpD, :fFechaExpA, :tEst, :tcvin, :tcvex, :fFechai, :fFechafi, :nuen, :nsaldominimo, :nsaldomonminimo,:tcampa,:tcheck<T>,  Mavi.RM1142DV,Mavi.RM1142MHDV,Reemplaza(ASCII(39),<T><T>,Mavi.RM1142CV),Mavi.RM1142Saldo,Mavi.RM1142Cumple, Mavi.RM1142Medios,Reemplaza(ASCII(39),<T><T>,Mavi.RM1142FamArt),Reemplaza(ASCII(39),<T><T>,Mavi.RM1142lineaArt), Mavi.RM1142UltVta,Mavi.RM1142SaldoMon, Mavi.RM1142Ultcom, Mavi.RM1142ExpiD,Mavi.RM1142ExpiA, Reemplaza(ASCII(39),<T><T>,Mavi.RM1142Estados),Reemplaza(ASCII(39),<T><T>,Mavi.RM1142CCVInc),Reemplaza(ASCII(39),<T><T>,Mavi.RM1142CCVIgn), Mavi.RM1142LiqIni,Mavi.RM1142LiqFin,Mavi.RM1142UEN,Mavi.RM1142Salmin,Mavi.RM1142Salminmon,Mavi.RM1142Campa,Mavi.RM1142Check))<BR>Si Info.Numero = 0<BR>    Entonces<BR>    ReportePantalla(<T>RM1142CarteraReporteSmsRep<T>)<BR>Sino<BR>    Forma(<T>RM1142AgregarclientesFrm<T>)<BR>Fin
[Acciones.Aceptar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=aceptar
Activo=S
Visible=S

[Agregar.Columnas]
cliente=94
Mensaje=844
smsenviados=65
mostrar=64


