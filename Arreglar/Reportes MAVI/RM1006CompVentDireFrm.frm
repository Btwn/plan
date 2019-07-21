[Forma]
Clave=RM1006CompVentDireFrm
Nombre=RM1006 Comparativo Ventas Direccion
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
ListaCarpetas=(Variables)<BR>textos
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=215
PosicionInicialArriba=335
PosicionInicialAlturaCliente=139
PosicionInicialAncho=514
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=RM1006CompVentDireRep
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionCol1=302
ExpresionesAlMostrar=Asigna(info.fechaA, nulo)<BR>Asigna(info.fechaD, nulo)<BR>Asigna(info.clase, <T>de la Fecha:  es el inicio de quincena<T>)<BR>Asigna(info.clase1, nulo)<BR>Asigna(info.clase2, <T>a la Fecha:  es el dia de ayer<T>)
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
ListaEnCaptura=Info.FechaD<BR>Info.FechaA
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
[Acciones.RM1006GenerarTxt.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.RM1006GenerarTxt.exp]
Nombre=exp
Boton=0
TipoAccion=expresion
Expresion=ReporteImpresora(<T>RM1006CompVentDira<T>)
Activo=S
Visible=S
[Acciones.RM1006CompVentDire.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.RM1006CompVentDire.RM1006CompVentDire]
Nombre=RM1006CompVentDire
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM1006CompVentDire
Activo=S
Visible=S
[Acciones.RM1006CompVentDireRep.RM1006CompVentDireRep]
Nombre=RM1006CompVentDireRep
Boton=0
TipoAccion=Expresion
Expresion=Si<BR>   ConDatos( Info.FechaD) y  ConDatos( Info.FechaA)<BR>    Entonces<BR>        Si<BR>          Info.FechaD <= Info.FechaA<BR>            Entonces<BR>               ReporteImpresora( <T>RM1006ContadoresXSucursalRep<T>, Info.FechaD,Info.FechaA )<BR>               ReporteImpresora( <T>RM1006VentasXSucursalRep<T>, Info.FechaD,Info.FechaA )<BR>               ReporteImpresora( <T>RM1006VentasInstitucionesRep<T>, Info.FechaD,Info.FechaA )<BR>               ReporteImpresora( <T>RM1006VentasXPlazoRep<T>, Info.FechaD,Info.FechaA )<BR>               ReporteImpresora( <T>RM1006PrestamosRep<T>, Info.FechaD,Info.FechaA )<BR>               ReporteImpresora( <T>RM1006InventariosRep<T>)<BR>               ReporteImpresora( <T>RM1006MonederoRep<T>, Info.FechaD,Info.FechaA )<BR>            Sino<BR>     <CONTINUA>
Expresion002=<CONTINUA>          Error( <T>Rango de Fechas Invalido!!!...<T> )<BR>        Fin<BR><BR>    Sino<BR>       Error( <T>Selecciona Rango de Fechas!!!...<T> )<BR>Fin
[Acciones.RM1006CompVentDireRep]
Nombre=RM1006CompVentDireRep
Boton=55
NombreEnBoton=S
NombreDesplegar=Generar Txt
Multiple=S
EnBarraHerramientas=S
TipoAccion=Reportes Impresora
ClaveAccion=RM1006CompVentDire
ListaAccionesMultiples=Variables Asignar<BR>RM1006CompVentDireRep
Activo=S
Visible=S
[Acciones.RM1006CompVentDireRep.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[textos]
Estilo=Ficha
Clave=textos
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Plata
CarpetaVisible=S
PestanaOtroNombre=S
FichaEspacioEntreLineas=0
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
Tamano=30
ColorFondo=Plata
ColorFuente=Negro
[textos.Info.Clase2]
Carpeta=textos
Clave=Info.Clase2
Editar=S
LineaNueva=S
ValidaNombre=N
3D=N
Tamano=30
ColorFondo=Plata
ColorFuente=Negro
EspacioPrevio=S
[textos.Info.Clase1]
Carpeta=textos
Clave=Info.Clase1
Editar=S
LineaNueva=S
Tamano=30
ColorFondo=Plata
ColorFuente=Negro



