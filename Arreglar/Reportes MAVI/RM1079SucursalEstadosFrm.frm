[Forma]
Clave=RM1079SucursalEstadosFrm
Nombre=<T>RM1079 Sucursales por Estado<T>
Icono=0
Modulos=(Todos)
ListaCarpetas=Sucursales
CarpetaPrincipal=Sucursales
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialAlturaCliente=273
PosicionInicialAncho=500
ListaAcciones=guardar<BR>cerr
[Sucursales]
Estilo=Hoja
Pestana=S
Clave=Sucursales
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1079SucursalEstadosVis
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
ListaEnCaptura=RM1079SucursalEstadoTbl.Sucursal<BR>RM1079SucursalEstadoTbl.Estado
CarpetaVisible=S
[Sucursales.RM1079SucursalEstadoTbl.Sucursal]
Carpeta=Sucursales
Clave=RM1079SucursalEstadoTbl.Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Sucursales.RM1079SucursalEstadoTbl.Estado]
Carpeta=Sucursales
Clave=RM1079SucursalEstadoTbl.Estado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[Sucursales.Columnas]
Sucursal=64
Estado=184
[Acciones.guardar.guardar]
Nombre=guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=GuardarCambios<BR> SI<BR>    SQL(<T>Select count(Sucursal) from RM1079Sucursal group by Sucursal having count(sucursal) > 1<T> ) > 1<BR>    Entonces<BR>         Error(<T>Sucursal Duplicada<T>)<BR>         AbortarOperacion<BR>      Sino<BR>          Verdadero<BR>Fin
[Acciones.guardar]
Nombre=guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar Cambios
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.cerr]
Nombre=cerr
Boton=36
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
NombreEnBoton=S
