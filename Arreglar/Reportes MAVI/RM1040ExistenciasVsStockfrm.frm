[Forma]
Clave=RM1040ExistenciasVsStockFrm
Nombre=RM1040 Existencias VS Stock
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
ListaCarpetas=(Variables)<BR>textos
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=417
PosicionInicialArriba=361
PosicionInicialAlturaCliente=115
PosicionInicialAncho=456
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
PosicionCol1=267
PosicionSec1=140
PosicionSec2=80
ExpresionesAlMostrar=Asigna(Info.clase,NULO)<BR>Asigna(Info.clase1,NULO)    <BR>Asigna(Info.clase,<T>Almacen del Stock de Tecnologias de Informacion<T>)
ListaAcciones=Preliminar<BR>Cerrar
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
ListaEnCaptura=Mavi.RM1040AlmSTOCK
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
FichaNombres=Arriba
FichaAlineacion=Centrado
PestanaOtroNombre=S
PestanaNombre=filtros


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
ListaEnCaptura=Info.Clase<BR>Info.Clase1
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

[(Variables).Mavi.RM1040AlmSTOCK]
Carpeta=(Variables)
Clave=Mavi.RM1040AlmSTOCK
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar]
Nombre=Preliminar
Boton=68
NombreEnBoton=S
NombreDesplegar=&Preliminar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=Variables Asignar<BR>Aceptar<BR>RM1040ExistvsStockrep
[Acciones.Preliminar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=-1
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Preliminar.RM1040ExistvsStockrep]
Nombre=RM1040ExistvsStockrep
Boton=0
TipoAccion=reportes Pantalla
ClaveAccion=RM1040ExistenciasVsStockRep
Activo=S
Visible=S



