[Forma]
Clave=PonderacionxTipoFacturaMAVI
Nombre=Ponderación por Tipo de Factura
Icono=0
Modulos=(Todos)
ListaCarpetas=PonderacionxTipoFacturaMAVI
CarpetaPrincipal=PonderacionxTipoFacturaMAVI
PosicionInicialAlturaCliente=472
PosicionInicialAncho=541
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=409
PosicionInicialArriba=129
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=(Lista)
[PonderacionxTipoFacturaMAVI]
Estilo=Hoja
Clave=PonderacionxTipoFacturaMAVI
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=PonderacionxTipoFacturaMAVI
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
ListaEnCaptura=(Lista)
CarpetaVisible=S
[PonderacionxTipoFacturaMAVI.PonderacionxTipoFacturaMAVI.UEN]
Carpeta=PonderacionxTipoFacturaMAVI
Clave=PonderacionxTipoFacturaMAVI.UEN
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[PonderacionxTipoFacturaMAVI.PonderacionxTipoFacturaMAVI.TipoFactura]
Carpeta=PonderacionxTipoFacturaMAVI
Clave=PonderacionxTipoFacturaMAVI.TipoFactura
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[PonderacionxTipoFacturaMAVI.PonderacionxTipoFacturaMAVI.RangoInicial]
Carpeta=PonderacionxTipoFacturaMAVI
Clave=PonderacionxTipoFacturaMAVI.RangoInicial
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[PonderacionxTipoFacturaMAVI.PonderacionxTipoFacturaMAVI.RangoFinal]
Carpeta=PonderacionxTipoFacturaMAVI
Clave=PonderacionxTipoFacturaMAVI.RangoFinal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[PonderacionxTipoFacturaMAVI.PonderacionxTipoFacturaMAVI.Ponderacion]
Carpeta=PonderacionxTipoFacturaMAVI
Clave=PonderacionxTipoFacturaMAVI.Ponderacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[PonderacionxTipoFacturaMAVI.Columnas]
UEN=32
TipoFactura=115
RangoInicial=71
RangoFinal=65
Ponderacion=69
Categoria=106
NDE=38
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreDesplegar=&Guardar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
NombreEnBoton=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
NombreEnBoton=S

[PonderacionxTipoFacturaMAVI.ListaEnCaptura]
(Inicio)=PonderacionxTipoFacturaMAVI.UEN
PonderacionxTipoFacturaMAVI.UEN=PonderacionxTipoFacturaMAVI.Categoria
PonderacionxTipoFacturaMAVI.Categoria=PonderacionxTipoFacturaMAVI.TipoFactura
PonderacionxTipoFacturaMAVI.TipoFactura=PonderacionxTipoFacturaMAVI.RangoInicial
PonderacionxTipoFacturaMAVI.RangoInicial=PonderacionxTipoFacturaMAVI.RangoFinal
PonderacionxTipoFacturaMAVI.RangoFinal=PonderacionxTipoFacturaMAVI.Ponderacion
PonderacionxTipoFacturaMAVI.Ponderacion=PonderacionxTipoFacturaMAVI.NDE
PonderacionxTipoFacturaMAVI.NDE=(Fin)

[PonderacionxTipoFacturaMAVI.PonderacionxTipoFacturaMAVI.Categoria]
Carpeta=PonderacionxTipoFacturaMAVI
Clave=PonderacionxTipoFacturaMAVI.Categoria
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

[PonderacionxTipoFacturaMAVI.PonderacionxTipoFacturaMAVI.NDE]
Carpeta=PonderacionxTipoFacturaMAVI
Clave=PonderacionxTipoFacturaMAVI.NDE
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro



























[Forma.ListaAcciones]
(Inicio)=Cerrar
Cerrar=Guardar
Guardar=(Fin)

