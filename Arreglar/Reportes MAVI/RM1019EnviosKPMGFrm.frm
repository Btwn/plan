[Forma]
Clave=RM1019EnviosKPMGFrm
Nombre=RM1019 Envios KPMG
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
ListaCarpetas=(Variables)<BR>textos
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=410
PosicionInicialArriba=395
PosicionInicialAlturaCliente=196
PosicionInicialAncho=460
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=EnviosKPMGRep
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionCol1=262
PosicionSec1=140
PosicionSec2=80
ExpresionesAlMostrar=Asigna(info.fechaA, SI((Mes(hoy)-1)=0,(UltimoDiaMes(12,año(hoy)-1)),UltimoDiaMes((Mes(hoy)-1),año(hoy))))<BR>Asigna(Mavi.TipoMov,  nulo)         <BR>Asigna(Mavi.AnalitConden, <T>Condensado<T>)         <BR>Asigna(Info.clase,<T>Se corre al cierre de cada MES<T>)<BR>Asigna(Info.clase1,<T>fecha final debe ser el ultimo del mes anterior<T>)<BR>Asigna(Info.clase2,<T>Se corre con Facturas y con Prestamos<T>)
[(Variables)]
Estilo=Ficha
Clave=(Variables)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A2
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.FechaA<BR>Mavi.RM1019TipoMovto
CarpetaVisible=S
FichaEspacioEntreLineas=12
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
FichaNombres=Arriba
FichaAlineacion=Centrado
PestanaOtroNombre=S
PestanaNombre=filtros
[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.RM1019GenerarTxt.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.RM1019GenerarTxt.exp]
Nombre=exp
Boton=0
TipoAccion=expresion
Expresion=ReporteImpresora(<T>RM1019EnviosKPMG<T>)
Activo=S
Visible=S
[Acciones.RM1019EnviosKPMG.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.RM1019EnviosKPMG.RM1019EnviosKPMG]
Nombre=RM1019EnviosKPMG
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM1019EnviosKPMG
Activo=S
Visible=S
[Acciones.RM1019EnviosKPMG.RM1019EnviosKPMGRep]
Nombre=RM1019EnviosKPMGRep
Boton=0
TipoAccion=Expresion
Expresion=Si<BR>   ConDatos( Info.FechaD) y  ConDatos( Info.FechaA) y ConDatos(Mavi.RM0954Semana)<BR>    Entonces<BR>        Si<BR>          (Info.FechaD <= Info.FechaA) y Mavi.RM0954Semana > 0 <BR>            Entonces<BR>               ReporteImpresora( <T>RM1019EnviosKPMGRep<T>, Mavi.RM0954Semana,Info.FechaD,Info.FechaA )<BR>           Sino<BR>               Error( <T>Rango de Fechas Invalido!!!...<T> )<BR>        Fin<BR><BR>    Sino<BR>       Error( <T>Selecciona Rango de Fechas!!!...<T> )<BR>Fin
[Acciones.RM1019EnviosKPMGRep.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.EnviosKPMGRep]
Nombre=EnviosKPMGRep
Boton=55
NombreEnBoton=S
NombreDesplegar=Generar Txt
Multiple=S
EnBarraHerramientas=S
TipoAccion=Reportes Impresora
ClaveAccion=RM1019EnviosKPMG
ListaAccionesMultiples=Asignavar<BR>GrabarTxt<BR>Cierra
Activo=S
Visible=S
[Acciones.EnvioKPMGRep.RM1019EnviosKPMGrep]
Nombre=RM1019EnviosKPMGrep
Boton=0
TipoAccion=Reportes Impresora
ConCondicion=S
EjecucionConError=S
ClaveAccion=RM1019EnviosKPMGrep
EjecucionCondicion=ConDatos( Info.FechaD) y  ConDatos( Info.FechaA) y  Info.FechaD <= Info.FechaA
EjecucionMensaje=Error( <T>Selecciona Rango de Fechas!!!...<T> )
[Acciones.EnvioKPMGRep.asignarVar]
Nombre=asignarVar
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
[textos]
Estilo=Ficha
Clave=textos
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Plata
CarpetaVisible=S
Vista=(Variables)
FichaEspacioEntreLineas=21
FichaEspacioNombres=0
FichaColorFondo=Plata
ListaEnCaptura=Info.Clase<BR>Info.Clase1<BR>Info.Clase2
[textos.Info.Clase]
Carpeta=textos
Clave=Info.Clase
Editar=S
LineaNueva=S
ValidaNombre=N
3D=N
Tamano=35
ColorFondo=Plata
ColorFuente=Negro
EspacioPrevio=N
[textos.Info.Clase1]
Carpeta=textos
Clave=Info.Clase1
Editar=S
LineaNueva=S
ValidaNombre=N
3D=N
Tamano=35
ColorFondo=Plata
ColorFuente=Negro
EspacioPrevio=N
[textos.Info.Clase2]
Carpeta=textos
Clave=Info.Clase2
Editar=S
LineaNueva=S
ValidaNombre=N
3D=N
Tamano=35
ColorFondo=Plata
ColorFuente=Negro
EspacioPrevio=N
[(Variables).Mavi.RM1019TipoMovto]
Carpeta=(Variables)
Clave=Mavi.RM1019TipoMovto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.EnviosKPMGRep.Asignavar]
Nombre=Asignavar
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
[Acciones.EnviosKPMGRep.GrabarTxt]
Nombre=GrabarTxt
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM1019EnviosKPMGrep
[Acciones.EnviosKPMGRep.Cierra]
Nombre=Cierra
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=1=2



