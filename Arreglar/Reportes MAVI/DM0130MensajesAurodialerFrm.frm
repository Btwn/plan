[Forma]
Clave=DM0130MensajesAurodialerFrm
Nombre=Mensajes Aurodialer
Icono=58
Modulos=(Todos)
ListaCarpetas=Mensajes
CarpetaPrincipal=Mensajes
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialIzquierda=254
PosicionInicialArriba=194
PosicionInicialAlturaCliente=341
PosicionInicialAncho=857
ListaAcciones=SALIR<BR>eliminar<BR>Categoria
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
[Mensajes]
Estilo=Hoja
Clave=Mensajes
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0130MensajesAurodialerVis
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
ListaEnCaptura=DM0130MensajesAurodialerTbl.CODIGO<BR>DM0130MensajesAurodialerTbl.DESCRIPCION<BR>DM0130MensajesAurodialerTbl.RUTA<BR>DM0130MensajesAurodialerTbl.ALTA<BR>DM0130MensajesAurodialerTbl.FU_CAMBIO<BR>DM0130MensajesAurodialerTbl.USUARIO<BR>DM0130MensajesAurodialerTbl.CATEGORIA
CarpetaVisible=S
PermiteEditar=S
IgnorarControlesEdicion=S
HojaIndicador=S
HojaAjustarColumnas=S
[Mensajes.Columnas]
CODIGO=64
DESCRIPCION=197
RUTA=128
ALTA=94
FU_CAMBIO=94
USUARIO=100
CATEGORIA=124
[Acciones.SALIR]
Nombre=SALIR
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar y Salir
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
[Acciones.eliminar]
Nombre=eliminar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Eliminar Registro
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S
[Mensajes.DM0130MensajesAurodialerTbl.DESCRIPCION]
Carpeta=Mensajes
Clave=DM0130MensajesAurodialerTbl.DESCRIPCION
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco
[Mensajes.DM0130MensajesAurodialerTbl.RUTA]
Carpeta=Mensajes
Clave=DM0130MensajesAurodialerTbl.RUTA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco
[Mensajes.DM0130MensajesAurodialerTbl.ALTA]
Carpeta=Mensajes
Clave=DM0130MensajesAurodialerTbl.ALTA
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
[Mensajes.DM0130MensajesAurodialerTbl.FU_CAMBIO]
Carpeta=Mensajes
Clave=DM0130MensajesAurodialerTbl.FU_CAMBIO
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
[Mensajes.DM0130MensajesAurodialerTbl.USUARIO]
Carpeta=Mensajes
Clave=DM0130MensajesAurodialerTbl.USUARIO
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco
[Mensajes.DM0130MensajesAurodialerTbl.CODIGO]
Carpeta=Mensajes
Clave=DM0130MensajesAurodialerTbl.CODIGO
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Mensajes.DM0130MensajesAurodialerTbl.CATEGORIA]
Carpeta=Mensajes
Clave=DM0130MensajesAurodialerTbl.CATEGORIA
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

Editar=S
[Acciones.Categoria]
Nombre=Categoria
Boton=75
NombreEnBoton=S
NombreDesplegar=Categorías
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S

ListaAccionesMultiples=Categorias
[Acciones.Categoria.Categorias]
Nombre=Categorias
Boton=0
TipoAccion=Formas
ClaveAccion=DM0130CategoriasFrm
Activo=S
Visible=S








