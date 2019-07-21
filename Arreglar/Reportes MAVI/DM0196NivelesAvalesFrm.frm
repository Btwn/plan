[Forma]
Clave=DM0196NivelesAvalesFrm
Nombre=DM0196NivelesAvalesFrm
Icono=0
Modulos=(Todos)
ListaCarpetas=DM0196NivelesAvalesvis
CarpetaPrincipal=DM0196NivelesAvalesvis
PosicionInicialIzquierda=286
PosicionInicialArriba=154
PosicionInicialAlturaCliente=273
PosicionInicialAncho=279
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Nuevo<BR>Eliminar<BR>Guardar<BR>Cerrar
[DM0196NivelesAvalesvis]
Estilo=Hoja
Pestana=S
Clave=DM0196NivelesAvalesvis
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0196NivelesAvalesVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DM0196NivelesAvalesTbl.NIVEL<BR>DM0196NivelesAvalesTbl.DI<BR>DM0196NivelesAvalesTbl.DV
CarpetaVisible=S
PermiteEditar=S
[DM0196NivelesAvalesvis.DM0196NivelesAvalesTbl.NIVEL]
Carpeta=DM0196NivelesAvalesvis
Clave=DM0196NivelesAvalesTbl.NIVEL
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
IgnoraFlujo=N
[DM0196NivelesAvalesvis.DM0196NivelesAvalesTbl.DV]
Carpeta=DM0196NivelesAvalesvis
Clave=DM0196NivelesAvalesTbl.DV
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[DM0196NivelesAvalesvis.DM0196NivelesAvalesTbl.DI]
Carpeta=DM0196NivelesAvalesvis
Clave=DM0196NivelesAvalesTbl.DI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[DM0196NivelesAvalesvis.Columnas]
NIVEL=100
DV=64
DI=64
[Acciones.Nuevo]
Nombre=Nuevo
Boton=1
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Agregar
Activo=S
Visible=S
NombreDesplegar=Nuevo
NombreEnBoton=S
[Acciones.Eliminar]
Nombre=Eliminar
Boton=36
NombreDesplegar=Eliminar
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S
ConCondicion=S
EjecucionCondicion=Si confirmacion(<T>Desea eliminar el registro ?<T>,BotonSI,BotonNO)=6<BR>entonces<BR>verdadero<BR>sino<BR>Falso
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreDesplegar=Guardar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
EspacioPrevio=S

