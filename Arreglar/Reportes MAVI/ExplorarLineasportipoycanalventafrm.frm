[Forma]
Clave=ExplorarLineasportipoycanalventafrm
Icono=47
Modulos=(Todos)
Nombre=Lineas por Tipo y Canal VTA
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
ListaCarpetas=Vista<BR>Variables
CarpetaPrincipal=Variables
PosicionInicialIzquierda=275
PosicionInicialArriba=145
PosicionInicialAlturaCliente=438
PosicionInicialAncho=815
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Cerrar<BR>Imprimir<BR>Presentacion preliminar<BR>Enviar a Excel<BR>Actualizar<BR>Limpiar
PosicionSec1=56
VentanaRepetir=S
ExpresionesAlMostrar=Asigna(Mavi.DM0175BLineaFiltro,<T><T>)<BR>Asigna(Mavi.DM0175BCanalVentaFiltro,<T><T>)<BR>Asigna(Mavi.DM0175BArtTipoFiltro,<T><T>)
[Vista]
Estilo=Hoja
Clave=Vista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=ExplorarLineasportipoycanalventavis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Linea<BR>ArtTipo<BR>CanalVenta<BR>Cadena
CarpetaVisible=S
OtroOrden=S
ListaOrden=ArtTipo<TAB>(Acendente)<BR>Linea<TAB>(Acendente)
FiltroPredefinido1=
FiltroPredefinido2=
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
[Vista.Linea]
Carpeta=Vista
Clave=Linea
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Vista.ArtTipo]
Carpeta=Vista
Clave=ArtTipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Vista.CanalVenta]
Carpeta=Vista
Clave=CanalVenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Vista.Cadena]
Carpeta=Vista
Clave=Cadena
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Vista.Columnas]
Linea=210
ArtTipo=147
CanalVenta=84
Cadena=322
0=-2
1=-2
2=-2
3=-2
4=-2
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Imprimir]
Nombre=Imprimir
Boton=4
NombreDesplegar=Imprimir
EnBarraHerramientas=S
Carpeta=Vista
TipoAccion=Controles Captura
ClaveAccion=Imprimir
Activo=S
Visible=S
EspacioPrevio=S
[Acciones.Presentacion preliminar]
Nombre=Presentacion preliminar
Boton=68
NombreDesplegar=Presentacion preliminar
EnBarraHerramientas=S
Carpeta=Vista
TipoAccion=Controles Captura
ClaveAccion=Presentacion preliminar
Activo=S
Visible=S
[Acciones.Enviar a Excel]
Nombre=Enviar a Excel
Boton=67
NombreDesplegar=Enviar a Excel
EnBarraHerramientas=S
EspacioPrevio=S
Carpeta=Vista
TipoAccion=Controles Captura
ClaveAccion=Enviar a Excel
Activo=S
Visible=S
[Variables]
Estilo=Ficha
Clave=Variables
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.DM0175BLineaFiltro<BR>Mavi.DM0175BArtTipoFiltro<BR>Mavi.DM0175BCanalVentaFiltro
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
[Variables.Mavi.DM0175BLineaFiltro]
Carpeta=Variables
Clave=Mavi.DM0175BLineaFiltro
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Variables.Mavi.DM0175BCanalVentaFiltro]
Carpeta=Variables
Clave=Mavi.DM0175BCanalVentaFiltro
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Variables.Mavi.DM0175BArtTipoFiltro]
Carpeta=Variables
Clave=Mavi.DM0175BArtTipoFiltro
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Actualizar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Actualizar.Actualizar Vista]
Nombre=Actualizar Vista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Actualizar]
Nombre=Actualizar
Boton=125
NombreEnBoton=S
NombreDesplegar=Actualizar
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=Variables Asignar<BR>Actualizar Vista
Activo=S
Visible=S
[Acciones.Limpiar]
Nombre=Limpiar
Boton=21
NombreDesplegar=Cancelar
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Expresion<BR>Act<BR>EjemploRS
NombreEnBoton=S
EspacioPrevio=S
[Acciones.Limpiar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.DM0175BLineaFiltro,<T><T>)<BR>Asigna(Mavi.DM0175BCanalVentaFiltro,<T><T>)<BR>Asigna(Mavi.DM0175BArtTipoFiltro,<T><T>)
[Acciones.Limpiar.Act]
Nombre=Act
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Limpiar.EjemploRS]
Nombre=EjemploRS
Boton=0
TipoAccion=Formas
ClaveAccion=Explorarlineasportipoycanalventafrm
Activo=S
Visible=S


