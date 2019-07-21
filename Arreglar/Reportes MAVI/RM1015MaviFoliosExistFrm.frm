[Forma]
Clave=RM1015MaviFoliosExistFrm
Nombre=RM1015 Consumo de Folios CFD
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=355
PosicionInicialArriba=221
PosicionInicialAlturaCliente=170
PosicionInicialAncho=175
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Sele<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=ASIGNA(Mavi.RM1015Sucursales,NULO)<BR>ASIGNA(Mavi.RM1015Series,NULO)<BR>ASIGNA(Mavi.RM1015TTipoMovs,NULO)
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
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
ListaEnCaptura=Mavi.RM1015Series<BR>Mavi.RM1015Sucursales<BR>Mavi.RM1015TTipoMovs
[(Variables).Mavi.RM1015Series]
Carpeta=(Variables)
Clave=Mavi.RM1015Series
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM1015Sucursales]
Carpeta=(Variables)
Clave=Mavi.RM1015Sucursales
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM1015TTipoMovs]
Carpeta=(Variables)
Clave=Mavi.RM1015TTipoMovs
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Sele]
Nombre=Sele
Boton=68
NombreEnBoton=S
NombreDesplegar=Preliminar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S


