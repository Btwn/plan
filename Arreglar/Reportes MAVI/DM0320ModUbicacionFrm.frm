
[Forma]
Clave=DM0320ModUbicacionFrm
Icono=0
BarraHerramientas=S
Modulos=(Todos)
Nombre=Eliminar Ubicación
AccionesTamanoBoton=15x5
AccionesDerecha=S

ListaCarpetas=DM0320ModUbicacion
CarpetaPrincipal=DM0320ModUbicacion
PosicionInicialIzquierda=175
PosicionInicialArriba=127
PosicionInicialAlturaCliente=745
PosicionInicialAncho=907
ListaAcciones=Eliminar<BR>Salir
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaSinIconosMarco=S
VentanaEstadoInicial=Normal
[DM0320ModUbicacion]
Estilo=Hoja
Clave=DM0320ModUbicacion
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0320UbicacionVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DM0320UbicacionTbl.Articulo<BR>DM0320UbicacionTbl.Descripcion<BR>DM0320UbicacionTbl.Modulo<BR>DM0320UbicacionTbl.Rack<BR>DM0320UbicacionTbl.Nivel<BR>DM0320UbicacionTbl.Otros<BR>DM0320UbicacionTbl.Ubicacion
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
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaAncho=20
BusquedaEnLinea=S
[DM0320ModUbicacion.DM0320UbicacionTbl.Articulo]
Carpeta=DM0320ModUbicacion
Clave=DM0320UbicacionTbl.Articulo
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco

[DM0320ModUbicacion.DM0320UbicacionTbl.Descripcion]
Carpeta=DM0320ModUbicacion
Clave=DM0320UbicacionTbl.Descripcion
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[DM0320ModUbicacion.DM0320UbicacionTbl.Modulo]
Carpeta=DM0320ModUbicacion
Clave=DM0320UbicacionTbl.Modulo
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=5
ColorFondo=Blanco

[DM0320ModUbicacion.DM0320UbicacionTbl.Rack]
Carpeta=DM0320ModUbicacion
Clave=DM0320UbicacionTbl.Rack
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=5
ColorFondo=Blanco

[DM0320ModUbicacion.DM0320UbicacionTbl.Nivel]
Carpeta=DM0320ModUbicacion
Clave=DM0320UbicacionTbl.Nivel
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=5
ColorFondo=Blanco

[DM0320ModUbicacion.DM0320UbicacionTbl.Otros]
Carpeta=DM0320ModUbicacion
Clave=DM0320UbicacionTbl.Otros
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[DM0320ModUbicacion.DM0320UbicacionTbl.Ubicacion]
Carpeta=DM0320ModUbicacion
Clave=DM0320UbicacionTbl.Ubicacion
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[DM0320ModUbicacion.Columnas]
Articulo=64
Descripcion=304
Modulo=38
Rack=34
Nivel=34
Otros=94
Ubicacion=304


[Acciones.Guardar.Eliminar]
Nombre=Eliminar
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S

[Acciones.Guardar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S


[Acciones.Salir]
Nombre=Salir
Boton=36
NombreEnBoton=S
NombreDesplegar=&Salir
EnBarraHerramientas=S
BtnResaltado=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Eliminar]
Nombre=Eliminar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Eliminar Ubicación
EnBarraHerramientas=S
BtnResaltado=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S

