[Forma]
Clave=DM0207CategoriasVentaFrm
Nombre=DM0207CategoriasVentaFrm
Icono=0
Modulos=(Todos)
ListaCarpetas=grid
CarpetaPrincipal=grid
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialIzquierda=212
PosicionInicialArriba=162
PosicionInicialAlturaCliente=360
PosicionInicialAncho=751
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Dise�o
VentanaEstadoInicial=Normal
ListaAcciones=Guardar<BR>Eliminar
[grid]
Estilo=Hoja
Clave=grid
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0207CategoriasVentaVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaConfirmarEliminar=S
HojaVistaOmision=Autom�tica
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DM0207CategoriasVentaTbl.IdCat<BR>DM0207CategoriasVentaTbl.CategoriaVenta<BR>DM0207CategoriasVentaTbl.CategoriaEtiqueta<BR>DM0207CategoriasVentaTbl.FechaRegistro
CarpetaVisible=S
GuardarPorRegistro=S
HojaIndicador=S
OtroOrden=S
ListaOrden=DM0207CategoriasVentaTbl.IdCat<TAB>(Acendente)
[grid.DM0207CategoriasVentaTbl.IdCat]
Carpeta=grid
Clave=DM0207CategoriasVentaTbl.IdCat
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Editar=S
[grid.DM0207CategoriasVentaTbl.CategoriaVenta]
Carpeta=grid
Clave=DM0207CategoriasVentaTbl.CategoriaVenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[grid.DM0207CategoriasVentaTbl.CategoriaEtiqueta]
Carpeta=grid
Clave=DM0207CategoriasVentaTbl.CategoriaEtiqueta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[grid.DM0207CategoriasVentaTbl.FechaRegistro]
Carpeta=grid
Clave=DM0207CategoriasVentaTbl.FechaRegistro
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[grid.Columnas]
ID=32
IdCat=43
CategoriaVenta=244
CategoriaEtiqueta=240
FechaRegistro=135
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=Guardar Cambios&
EnBarraHerramientas=S
TipoAccion=Controles Captura
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
ClaveAccion=Cancelar Cambios
EjecucionCondicion=ConDatos(DM0207CategoriasVentaVis:DM0207CategoriasVentaTbl.IdCat)<BR>o ConDatos(DM0207CategoriasVentaVis:DM0207CategoriasVentaTbl.CategoriaVenta)<BR>o ConDatos(DM0207CategoriasVentaVis:DM0207CategoriasVentaTbl.CategoriaEtiqueta)
EjecucionMensaje=<T>No puede haber campos vacios<T>
[Acciones.Eliminar]
Nombre=Eliminar
Boton=5
NombreEnBoton=S
NombreDesplegar=Eliminar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=borrar<BR>reload
ConfirmarAntes=S
DialogoMensaje=EstaSeguroEliminar
[Acciones.Eliminar.borrar]
Nombre=borrar
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S
[Acciones.Eliminar.reload]
Nombre=reload
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

