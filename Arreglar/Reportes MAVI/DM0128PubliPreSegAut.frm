[Forma]
Clave=DM0128PubliPreSegAut
Nombre=DM0128 Publicacion de precios de seguros de auto
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)<BR>condiciones<BR>precio
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=262
PosicionInicialAncho=406
PosicionInicialIzquierda=437
PosicionInicialArriba=332
PosicionSec1=65
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=Guarda<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaSinIconosMarco=S
PosicionCol2=237
AccionesDerecha=S
VentanaBloquearAjuste=S
ExpresionesAlMostrar=asigna(Mavi.DM0128Precio,0)<BR>asigna(Mavi.DM0128ListaArt,<T><T>)
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
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
ListaEnCaptura=Mavi.DM0128ListaArt
PermiteEditar=S
[(Variables).Mavi.DM0128ListaArt]
Carpeta=(Variables)
Clave=Mavi.DM0128ListaArt
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.Articulo]
Carpeta=Detalle
Clave=Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.Precio]
Carpeta=Detalle
Clave=Precio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.Condicion]
Carpeta=Detalle
Clave=Condicion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.Columnas]
0=77
1=97
2=136
3=-2
4=-2
5=-2
6=-2
7=-2
8=-2
9=-2
10=-2
11=-2
12=-2
13=-2
[Acciones.Guarda]
Nombre=Guarda
Boton=-1
NombreDesplegar=&Actualiza
EnBarraAcciones=S
TipoAccion=Expresion
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=GuardaVal<BR>Ejecuta
[Acciones.Guarda.GuardaVal]
Nombre=GuardaVal
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Guarda.Ejecuta]
Nombre=Ejecuta
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=informacion(SQL(<T>EXEC sp_MaviDM0128Guarda :tart,:nprecio <T>,Mavi.DM0128ListaArt,Mavi.DM0128Precio))
[Acciones.Cerrar]
Nombre=Cerrar
Boton=0
NombreDesplegar=Cerrar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[condiciones]
Estilo=Iconos
Pestana=S
Clave=condiciones
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=DM0128PreUniCon
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=Condiciones
PestanaOtroNombre=S
PestanaNombre=Precio unico para las siguientes condiciones:
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
[condiciones.Condiciones]
Carpeta=condiciones
Clave=Condiciones
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[condiciones.Columnas]
0=210
Condiciones=304
[precio]
Estilo=Ficha
Clave=precio
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B2
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.DM0128Precio
CarpetaVisible=S
[precio.Mavi.DM0128Precio]
Carpeta=precio
Clave=Mavi.DM0128Precio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro


