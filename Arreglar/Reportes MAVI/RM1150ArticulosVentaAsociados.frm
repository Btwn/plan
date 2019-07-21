[Forma]
Clave=RM1150ArticulosVentaAsociados
Nombre=Reporte: Articulo de Venta Asociados
Icono=0
Modulos=(Todos)
ListaCarpetas=variables
CarpetaPrincipal=variables
PosicionInicialAlturaCliente=150
PosicionInicialAncho=421
PosicionInicialIzquierda=369
PosicionInicialArriba=337
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=CONSULTAR<BR>cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=ASIGNA(Mavi.RM1150FamsArt,<T><T>)<BR>ASIGNA(Mavi.RM1150LineasArt,<T><T>)
[variables]
Estilo=Ficha
Clave=variables
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
FichaEspacioEntreLineas=11
FichaEspacioNombres=94
FichaColorFondo=Plata
PermiteEditar=S
ListaEnCaptura=Mavi.RM1150FamsArt<BR>Mavi.RM1150LineasArt
FichaNombres=Izquierda
FichaAlineacion=Centrado
[variables.Mavi.RM1150LineasArt]
Carpeta=variables
Clave=Mavi.RM1150LineasArt
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[variables.Mavi.RM1150FamsArt]
Carpeta=variables
Clave=Mavi.RM1150FamsArt
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.CONSULTAR]
Nombre=CONSULTAR
Boton=0
NombreEnBoton=S
NombreDesplegar=&CONSULTAR
EnBarraHerramientas=S
TipoAccion=Reportes Pantalla
Activo=S
Visible=S
ClaveAccion=RM1150ArticulosdeVentaAsociadosRep
Multiple=S
ListaAccionesMultiples=Variables Asignar
[Acciones.cerrar]
Nombre=cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=CERRAR
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.CONSULTAR.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S


