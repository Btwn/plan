[Forma]
Clave=RM1013InfoNPDFrm
Nombre=RM1013 Info NPD
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
ListaCarpetas=(Variables)<BR>textos
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=375
PosicionInicialArriba=362
PosicionInicialAlturaCliente=185
PosicionInicialAncho=477
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=InfoNPDRep
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
PosicionCol1=262
PosicionSec1=140
PosicionSec2=80
ExpresionesAlMostrar=Asigna(info.fechaA, nulo)<BR>Asigna(info.fechaD, nulo)<BR>Asigna(Mavi.RM0954Semana,  Semana(hoy))         <BR>Asigna(Info.clase,<T>Se corre cada lunes, semana actual<T>)<BR>Asigna(Info.clase1,<T>fecha inicio debe ser domingo de sem anterior<T>)<BR>Asigna(Info.clase2,<T>fecha final debe ser sabado anterior<T>)
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
ListaEnCaptura=Mavi.RM0954semana<BR>Info.FechaD<BR>Info.FechaA
CarpetaVisible=S
FichaEspacioEntreLineas=0
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
[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.RM1013GenerarTxt.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.RM1013GenerarTxt.exp]
Nombre=exp
Boton=0
TipoAccion=expresion
Expresion=ReporteImpresora(<T>RM1013InfoNPD<T>)
Activo=S
Visible=S
[Acciones.RM1013InfoNPD.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.RM1013InfoNPD.RM1013InfoNPD]
Nombre=RM1013InfoNPD
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM1013InfoNPD
Activo=S
Visible=S
[Acciones.RM1013InfoNPD.RM1013InfosemNPDRep]
Nombre=RM1013InfoNPDRep
Boton=0
TipoAccion=Expresion
Expresion=Si<BR>   ConDatos( Info.FechaD) y  ConDatos( Info.FechaA) y ConDatos(Mavi.RM0954Semana)<BR>    Entonces<BR>        Si<BR>          (Info.FechaD <= Info.FechaA) y Mavi.RM0954Semana > 0 <BR>            Entonces<BR>               ReporteImpresora( <T>RM1013InfoNPDRep<T>, Mavi.RM0954Semana,Info.FechaD,Info.FechaA )<BR>           Sino<BR>               Error( <T>Rango de Fechas Invalido!!!...<T> )<BR>        Fin<BR><BR>    Sino<BR>       Error( <T>Selecciona Rango de Fechas!!!...<T> )<BR>Fin
[Acciones.RM1013InfosemNPDRep.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[(Variables).Mavi.RM0954semana]
Carpeta=(Variables)
Clave=Mavi.RM0954semana
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.InfoNPDRep]
Nombre=InfoNPDRep
Boton=55
NombreEnBoton=S
NombreDesplegar=Generar Txt
Multiple=S
EnBarraHerramientas=S
TipoAccion=Reportes Impresora
ClaveAccion=RM1013InfoNPD
ListaAccionesMultiples=asignarVar<BR>Rm1013NPDrep
Activo=S
Visible=S
[Acciones.InfoNPDRep.Rm1013NPDrep]
Nombre=Rm1013NPDrep
Boton=0
TipoAccion=Reportes Impresora
ConCondicion=S
EjecucionConError=S
ClaveAccion=RM1013InfoSemNPDrep
EjecucionCondicion=ConDatos( Info.FechaD) y  ConDatos( Info.FechaA) y  Info.FechaD <= Info.FechaA
EjecucionMensaje=Error( <T>Selecciona Rango de Fechas!!!...<T> )
[Acciones.InfoNPDRep.asignarVar]
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



