[Forma]
Clave=RM1054aFiltrosMonederofrm
Nombre=Filtros Monedero/Tarjetas
Icono=35
Modulos=(Todos)
ListaCarpetas=(Variables)<BR>textosayuda
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=256
PosicionInicialAncho=371
PosicionInicialIzquierda=454
PosicionInicialArriba=365
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=Aceptar<BR>Cerrar
VentanaTipoMarco=Chico (Variable)
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaEscCerrar=S
VentanaConIcono=S
PosicionCol1=158
PosicionSec1=54
VentanaAjustarZonas=S
AccionesDerecha=S
AccionesDivision=S
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(Mavi.RM1044Suc,Nulo)<BR>Asigna(Mavi.RM1044UEN,Nulo)<BR>Asigna(Mavi.RM1054CategCanal,Nulo)<BR>Asigna(info.fechaA, nulo)<BR>Asigna(info.fechaD, nulo)<BR>Asigna(Info.clase, <T>Seleccione de que periodo: <T>)<BR>Asigna(Mavi.CategoCanaldeVenta,nulo)
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
ListaEnCaptura=Info.FechaD<BR>Info.FechaA<BR>Mavi.RM1054CategCanal<BR>Mavi.RM1044Suc<BR>Mavi.RM1044UEN
CarpetaVisible=S
FichaEspacioEntreLineas=3
FichaEspacioNombres=47
FichaColorFondo=Plata
PermiteEditar=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
[(Variables).Mavi.RM1044Suc]
Carpeta=(Variables)
Clave=Mavi.RM1044Suc
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=N
[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreDesplegar=&Aceptar
Multiple=S
EnBarraAcciones=S
ListaAccionesMultiples=Variables Asignar<BR>Aceptar
Activo=S
Visible=S
[(Variables).Mavi.RM1044UEN]
Carpeta=(Variables)
Clave=Mavi.RM1044UEN
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Cerrar]
Nombre=Cerrar
Boton=0
NombreDesplegar=&Cerrar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Aceptar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=ConDatos( Info.FechaD) y  ConDatos( Info.FechaA) y  Info.FechaD <= Info.FechaA
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
EspacioPrevio=S
OcultaNombre=N
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
[(Variables).Mavi.RM1054CategCanal]
Carpeta=(Variables)
Clave=Mavi.RM1054CategCanal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[textosayuda]
Estilo=Ficha
Clave=textosayuda
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.Clase
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
[textosayuda.Info.Clase]
Carpeta=textosayuda
Clave=Info.Clase
Editar=S
LineaNueva=S
ValidaNombre=N
3D=N
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Cursiva]

