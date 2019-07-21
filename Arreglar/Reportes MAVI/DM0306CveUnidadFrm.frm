
[Forma]
Clave=DM0306CveUnidadFrm
Icono=0
Modulos=(Todos)
Nombre=Unidades

ListaCarpetas=demandaPendiente
CarpetaPrincipal=demandaPendiente
PosicionInicialIzquierda=403
PosicionInicialArriba=309
PosicionInicialAlturaCliente=347
PosicionInicialAncho=590
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Eliminar<BR>Importar
[demandaPendiente]
Estilo=Hoja
Clave=demandaPendiente
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0306CveUnidadVist
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
ListaEnCaptura=DM0306CveUnidadTbl.ClaveUnidad<BR>DM0306CveUnidadTbl.Nombre
CarpetaVisible=S

PermiteEditar=S
BusquedaRapidaControles=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaEnLinea=S
[demandaPendiente.DM0306CveUnidadTbl.ClaveUnidad]
Carpeta=demandaPendiente
Clave=DM0306CveUnidadTbl.ClaveUnidad
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=5
ColorFondo=Blanco

[demandaPendiente.DM0306CveUnidadTbl.Nombre]
Carpeta=demandaPendiente
Clave=DM0306CveUnidadTbl.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco

[demandaPendiente.Columnas]
ClaveUnidad=74
Nombre=465

[Acciones.Eliminar]
Nombre=Eliminar
Boton=36
NombreEnBoton=S
NombreDesplegar=E&liminar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S
Carpeta=(Carpeta principal)

Multiple=S
ListaAccionesMultiples=Eliminar<BR>actuaizar
[Acciones.Importar]
Nombre=Importar
Boton=2
NombreDesplegar=I&mportar
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Enviar/Recibir Excel
Activo=S
Visible=S
NombreEnBoton=S

Multiple=S
ListaAccionesMultiples=expresion<BR>Enviar/Recibir Excel<BR>actualizar
[Acciones.Guardar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Guardar.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreDesplegar=G&uardar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=refrescar Controles<BR>Guardar<BR>Actualizar
Activo=S
Visible=S
NombreEnBoton=S

[Acciones.Modificar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Modificar.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S



[Acciones.Guardar.refrescar Controles]
Nombre=refrescar Controles
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Siguiente
Activo=S
Visible=S


[Acciones.Eliminar.actuaizar]
Nombre=actuaizar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

[Acciones.Eliminar.Eliminar]
Nombre=Eliminar
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S



[Acciones.Importar.expresion]
Nombre=expresion
Boton=0
TipoAccion=expresion
Activo=S
Visible=S

Expresion=Ejecutarsql(<T>EXEC SpIDM0306_Truncate :NOption<T>, 2)
[Acciones.Importar.Enviar/Recibir Excel]
Nombre=Enviar/Recibir Excel
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Enviar/Recibir Excel
Activo=S
Visible=S


[Acciones.Importar.actualizar]
Nombre=actualizar
Boton=0
TipoAccion=controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
