[Forma]
Clave=MaviVtasInstPedenBodFrm
Nombre=RM165 Pedidos en Bodega
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=506
PosicionInicialArriba=347
PosicionInicialAlturaCliente=302
PosicionInicialAncho=267
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaEscCerrar=S
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(Mavi.SUCURSALVE,<T><T> )<BR>Asigna(Mavi.CelulaVI,<T><T> )<BR>Asigna(Mavi.DivisionVI,<T><T>)<BR>Asigna(Info.Almacen,<T><T>)<BR>Asigna(mavi.EquipoVI,<T><T>)<BR>Asigna(Mavi.SituacionVI,<T><T>)<BR>Asigna(Mavi.GerenciaVI,<T><T>)
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
ListaEnCaptura=Mavi.SucursalVE<BR>Info.Almacen<BR>Mavi.SituacionVI<BR>Mavi.GerenciaVI<BR>Mavi.DivisionVI<BR>Mavi.CelulaVI<BR>Mavi.EquipoVI
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
[(Variables).Info.Almacen]
Carpeta=(Variables)
Clave=Info.Almacen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[(Variables).Mavi.SucursalVE]
Carpeta=(Variables)
Clave=Mavi.SucursalVE
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.SituacionVI]
Carpeta=(Variables)
Clave=Mavi.SituacionVI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.GerenciaVI]
Carpeta=(Variables)
Clave=Mavi.GerenciaVI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.DivisionVI]
Carpeta=(Variables)
Clave=Mavi.DivisionVI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.CelulaVI]
Carpeta=(Variables)
Clave=Mavi.CelulaVI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.EquipoVI]
Carpeta=(Variables)
Clave=Mavi.EquipoVI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


