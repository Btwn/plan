[Forma]
Clave=RM0254MaviRelExiYVenNetFrm
Nombre=RM0254 Relación de Existencias y Ventas Netas
Icono=0
Modulos=(Todos)
FiltrarFechasSinHora=S
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=TEXT<BR>Cerrar
PosicionInicialAlturaCliente=262
PosicionInicialAncho=335
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
PosicionSec1=58
PosicionInicialIzquierda=501
PosicionInicialArriba=214
VentanaBloquearAjuste=S
VentanaExclusiva=S
VentanaEscCerrar=S
VentanaExclusivaOpcion=0
ExpresionesAlMostrar=Asigna(Mavi.RM0254FamArt,<T><T>)<BR>Asigna(Mavi.RM0254GrupoArt,<T><T> )<BR>Asigna(Mavi.RM0254LineaArt,<T><T>)<BR>Asigna(Mavi.RM0254Poblaciones, <T><T>)<BR>Asigna(Mavi.RM0254Sucursales,<T><T>)
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
FichaEspacioNombres=84
FichaColorFondo=Plata
ListaEnCaptura=Info.FechaD<BR>Info.FechaA<BR>Mavi.RM0254Sucursales<BR>Mavi.RM0254GrupoArt<BR>Mavi.RM0254FamArt<BR>Mavi.RM0254LineaArt<BR>Mavi.RM0254Poblaciones
FichaNombres=Arriba
FichaAlineacion=Izquierda
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[(Variables).Mavi.RM0254FamArt]
Carpeta=(Variables)
Clave=Mavi.RM0254FamArt
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[(Variables).Mavi.RM0254GrupoArt]
Carpeta=(Variables)
Clave=Mavi.RM0254GrupoArt
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Acciones.Preliminar.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
ConCondicion=S
EjecucionConError=S
Visible=S
EjecucionCondicion=((Info.FechaD)<=(Info.FechaA))o (Vacio(Info.FechaD) y Vacio(Info.FechaA)) o (ConDatos(Info.FechaD) y Vacio(Info.FechaA))
EjecucionMensaje=<T>Proporcione los Rangos De Fecha Correctamente<T>
[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=controles Captura
ClaveAccion=variables Asignar
Activo=S
Visible=S
[Acciones.Act.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Act.Act]
Nombre=Act
Boton=0
TipoAccion=controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[(Variables).Mavi.RM0254Sucursales]
Carpeta=(Variables)
Clave=Mavi.RM0254Sucursales
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Acciones.TEXT]
Nombre=TEXT
Boton=88
NombreEnBoton=S
NombreDesplegar=&Txt
Multiple=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
ListaAccionesMultiples=Variable<BR>acept
[(Variables).Mavi.RM0254LineaArt]
Carpeta=(Variables)
Clave=Mavi.RM0254LineaArt
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Acciones.TEXT.Variable]
Nombre=Variable
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.TEXT.acept]
Nombre=acept
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=Info.FechaA >= Info.FechaD
EjecucionMensaje=<T>La fecha de fin debe ser mayo a la de inicio<T>
EjecucionConError=S

[(Variables).Mavi.RM0254Poblaciones]
Carpeta=(Variables)
Clave=Mavi.RM0254Poblaciones
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Columnas]
0=-2
1=-2

[poblaciones.Columnas]
0=-2


