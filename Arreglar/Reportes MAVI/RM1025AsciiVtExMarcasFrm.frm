[Forma]
Clave=RM1025AsciiVtExMarcasFrm
Nombre=RM1025 Ascii VtaExist x Marcas
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
ListaCarpetas=(Variables)<BR>textos
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=435
PosicionInicialArriba=334
PosicionInicialAlturaCliente=177
PosicionInicialAncho=521
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
PosicionCol1=267
PosicionSec1=140
PosicionSec2=80
ListaAcciones=VtasExMarcas
ExpresionesAlMostrar=Asigna(info.fechaA,NULO)<BR>Asigna(info.fechaD,NULO)<BR>Asigna(Info.clase,<T>Seleccione una o varias marcas que desea<T>)<BR>Asigna(Info.clase1,<T>Seleccione una Fecha Inicial<T>)<BR>Asigna(Info.clase2,<T>Seleccione una Fecha Final<T>)
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
ListaEnCaptura=Mavi.RM1025PrefijoArticulos<BR>Info.FechaD<BR>Info.FechaA
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

[Acciones.VtasExMarcas]
Nombre=VtasExMarcas
Boton=88
NombreEnBoton=S
NombreDesplegar=Generar &Ascii
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=AsignarVar<BR>RM1025VtasEx
[Acciones.VtasExMarcas.AsignarVar]
Nombre=AsignarVar
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.VtasExMarcas.RM1025VtasEx]
Nombre=RM1025VtasEx
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM1025AsciiVtExisMarcasrep
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=ConDatos(Info.FechaD) y ConDatos(Info.FechaA) y Info.FechaD <= Info.FechaA
EjecucionMensaje=Error(<T>Selecciona Rango de Fechas !!!....<T>)
EjecucionConError=S
[(Variables).Mavi.RM1025PrefijoArticulos]
Carpeta=(Variables)
Clave=Mavi.RM1025PrefijoArticulos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro



