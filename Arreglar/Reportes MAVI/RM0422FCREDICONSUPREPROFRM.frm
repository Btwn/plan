[Forma]
Clave=RM0422FCREDICONSUPREPROFRM
Nombre=RM0422F Consecutivo de Supervisiones Reprogramadas
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
ListaCarpetas=Rama
CarpetaPrincipal=Rama
PosicionInicialAlturaCliente=130
PosicionInicialAncho=422
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=RepPantalla
PosicionInicialIzquierda=416
PosicionInicialArriba=377
PosicionSec1=124
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Mavi.TipoSupervision,<T><T>)<BR>Asigna(Mavi.RM0422FAGENTE,<T><T>)<BR>Asigna(Mavi.RM0422FSUPERVISION,<T><T>)<BR>Asigna(Info.Cliente,<T><T>)
[Rama]
Estilo=Ficha
Clave=Rama
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM0422FTIPOSUPER<BR>Mavi.RM0422FSUPERVISION<BR>Info.Cliente<BR>Mavi.RM0422FAGENTE
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
[Rama.Mavi.RM0422FAGENTE]
Carpeta=Rama
Clave=Mavi.RM0422FAGENTE
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=27
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.RepXls.asign]
Nombre=asign
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.RepXls.exl]
Nombre=exl
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si Mavi.RM0422FTIPOSUPER=<T>Supervision<T>  <BR>  entonces<BR>    ReporteExcel(<T>RM0422FCREDICONSUPREPROREPXLS<T>, Mavi.RM0422FAGENTE, Info.Cliente, Mavi.RM0422FSUPERVISION, Mavi.RM0422FTIPOSUPER)<BR>  Sino<BR>    Si Mavi.RM0422FTIPOSUPER=<T>Orden Supervision<T><BR>      entonces<BR>        ReporteExcel(<T>RM0422FCREDICONSUPREPROORDREPXLS<T>, Mavi.RM0422FAGENTE,Info.Cliente, Mavi.RM0422FSUPERVISION, Mavi.RM0422FTIPOSUPER)<BR>    fin<BR>fin
[Acciones.RepPantalla]
Nombre=RepPantalla
Boton=18
NombreDesplegar=Preliminar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
NombreEnBoton=S
Multiple=S
ListaAccionesMultiples=asinf<BR>crearep<BR>Cerrar
[Acciones.RepPantalla.asinf]
Nombre=asinf
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.RepPantalla.crearep]
Nombre=crearep
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si Mavi.RM0422FTIPOSUPER=<T>Supervision<T><BR>  entonces<BR>    ReportePantalla(<T>RM0422FCREDICONSUPREPROREP<T>, Mavi.RM0422FAGENTE, Info.Cliente, Mavi.RM0422FSUPERVISION, Mavi.RM0422FTIPOSUPER)<BR>  Sino<BR>    Si Mavi.RM0422FTIPOSUPER=<T>Orden Supervision<T><BR>      entonces<BR>        ReportePantalla(<T>RM0422FCREDICONSUPREPROORDREP<T>, Mavi.RM0422FAGENTE,Info.Cliente, Mavi.RM0422FSUPERVISION, Mavi.RM0422FTIPOSUPER)<BR>    fin<BR>fin
[Cliente.Info.Cliente]
Carpeta=Cliente
Clave=Info.Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Rama.Info.Cliente]
Carpeta=Rama
Clave=Info.Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=27
ColorFondo=Blanco
ColorFuente=Negro
[Rama.Mavi.RM0422FTIPOSUPER]
Carpeta=Rama
Clave=Mavi.RM0422FTIPOSUPER
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=27
ColorFondo=Blanco
ColorFuente=Negro
[Rama.Mavi.RM0422FSUPERVISION]
Carpeta=Rama
Clave=Mavi.RM0422FSUPERVISION
Editar=S
ValidaNombre=S
3D=S
Tamano=27
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.RepPantalla.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


