[Forma]
Clave=RM1049DifInventariosInstFrm
Nombre=RM1049DifInventariosInst
Icono=11
BarraHerramientas=S
Modulos=(Todos)
MovModulo=VTAS
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar
PosicionInicialAlturaCliente=101
PosicionInicialAncho=265
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaAjustarZonas=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=443
PosicionInicialArriba=364
CarpetaPrincipal=Filtro
PosicionSec1=104
ListaCarpetas=Filtro
ExpresionesAlMostrar=ASIGNA(Mavi.RM1049Inventarios,NULO)
[Mavi.RM1049Inventarios.Mavi.RM1049Inventarios]
Carpeta=Mavi.RM1049Inventarios
Clave=Mavi.RM1049Inventarios
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Totalizadores)]
Pestana=S
Clave=(Carpeta Totalizadores)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
Totalizadores=S
CampoColorLetras=Negro
CampoColorFondo=Negro
CarpetaVisible=S
[Filtro]
Estilo=Ficha
Clave=Filtro
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM1049Inventarios
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
FichaNombres=Izquierda
FichaEspacioNombresAuto=S
[Filtro.Mavi.RM1049Inventarios]
Carpeta=Filtro
Clave=Mavi.RM1049Inventarios
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=Aceptar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Aceptar<BR>Cerrar
Activo=S
Visible=S
[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S


