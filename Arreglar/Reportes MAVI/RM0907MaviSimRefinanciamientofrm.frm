[Forma]
Clave=RM0907MaviSimRefinanciamientofrm
Nombre=Simulador de Refinanciamiento
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=679
PosicionInicialArriba=272
PosicionInicialAlturaCliente=78
PosicionInicialAncho=297
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar
PosicionSec1=60
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=EjecutarSQL(<T>SP_MAVIRM0907EliminaTemp :Nid<T>,0)
ExpresionesAlCerrar=EjecutarSQL(<T>SP_MAVIRM0907EliminaTemp :Nid<T>,1)
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
ListaEnCaptura=Mavi.SimCliente
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
[(Variables).Mavi.SimCliente]
Carpeta=(Variables)
Clave=Mavi.SimCliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=35
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=formas
ClaveAccion=RM0907MaviSimRefinanciamientoMovFrm
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asignar<BR>Ejecutar
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.Ejecutar]
Nombre=Ejecutar
Boton=0
TipoAccion=Formas
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
ClaveAccion=RM0907MaviSimRefinanciamientoMovFrm
EjecucionCondicion=cONDATOS(Mavi.SimCliente)
EjecucionMensaje=<T>Favor de Colocar Una Cuenta<T>
[FACT.Columnas]
0=274


