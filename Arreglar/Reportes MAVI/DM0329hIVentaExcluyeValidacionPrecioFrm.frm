
[Forma]
Clave=DM0329hIVentaExcluyeValidacionPrecioFrm
Icono=0
Modulos=(Todos)
Nombre=Seguros de envio

ListaCarpetas=DM0329hIExcluyeValidacionPrecioFicha
CarpetaPrincipal=DM0329hIExcluyeValidacionPrecioFicha
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Elinminar
PosicionInicialIzquierda=662
PosicionInicialArriba=226
PosicionInicialAlturaCliente=273
PosicionInicialAncho=277
[DM0329hIExcluyeValidacionPrecioFicha]
Estilo=Hoja
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Detalle Seguro
Clave=DM0329hIExcluyeValidacionPrecioFicha
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0329hIVentaLineaVTASCExcluyeValidacionPrecioVis
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
CarpetaVisible=S

ListaEnCaptura=DM0329hIVentaLineaVTASCExcluyeValidacionPrecioTbl.Articulo
PermiteEditar=S
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Guardar Cambios<BR>Actualizar Vista
[Acciones.Elinminar]
Nombre=Elinminar
Boton=36
NombreDesplegar=&Eliminar
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S
NombreEnBoton=S

Multiple=S
ListaAccionesMultiples=Registro Eliminar<BR>Guardar Cambios<BR>Actualizar Vista
[DM0329hIExcluyeValidacionPrecioFicha.DM0329hIVentaLineaVTASCExcluyeValidacionPrecioTbl.Articulo]
Carpeta=DM0329hIExcluyeValidacionPrecioFicha
Clave=DM0329hIVentaLineaVTASCExcluyeValidacionPrecioTbl.Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[DM0329hIExcluyeValidacionPrecioFicha.Columnas]
Articulo=94

[Acciones.Elinminar.Registro Eliminar]
Nombre=Registro Eliminar
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S

[Acciones.Elinminar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Elinminar.Actualizar Vista]
Nombre=Actualizar Vista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

[Acciones.Guardar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Guardar.Actualizar Vista]
Nombre=Actualizar Vista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
