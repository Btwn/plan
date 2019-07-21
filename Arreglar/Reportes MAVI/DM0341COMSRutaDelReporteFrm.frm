
[Forma]
Clave=DM0341COMSRutaDelReporteFrm
Icono=0
Modulos=(Todos)

ListaCarpetas=Principal
CarpetaPrincipal=Principal
Nombre=<T>Ruta Del Reporte Unificado Para Actualizacion De Macros<T>
PosicionInicialIzquierda=372
PosicionInicialArriba=374
PosicionInicialAlturaCliente=130
PosicionInicialAncho=431
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Eliminar<BR>Salir
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaSinIconosMarco=S
VentanaEstadoInicial=Normal
[Principal]
Estilo=Hoja
Clave=Principal
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0341COMSRutaDelReporteVis
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
ListaEnCaptura=DM0341COMSRutaDelReporteTbl.Nombre
CarpetaVisible=S

HojaConfirmarEliminar=S
[Principal.DM0341COMSRutaDelReporteTbl.Nombre]
Carpeta=Principal
Clave=DM0341COMSRutaDelReporteTbl.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=250
ColorFondo=Blanco

[Principal.Columnas]
Nombre=392

TablaSt=304
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=Guardar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S

ListaAccionesMultiples=Registro Siguiente<BR>Guardar Cambios<BR>Actualizar Forma
ConCondicion=S
EjecucionCondicion=Si<BR>  SQL(<T>Select COUNT(*) FROM TablaStD WITH(NOLOCK) WHERE TablaSt = :tRuta<T>,<T>RUTA REPORTE UNIFICADO PARA MACRO<T>) = 1<BR>Entonces<BR>  Informacion(<T>Solo puede existir una ruta definida<T>)<BR>  AbortarOperacion<BR>Sino<BR>  Verdadero<BR>Fin
[Acciones.Eliminar]
Nombre=Eliminar
Boton=36
NombreEnBoton=S
NombreDesplegar=Eliminar
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Registro Eliminar<BR>Guardar Cambios<BR>Actualizar Forma
[Acciones.Salir]
Nombre=Salir
Boton=23
NombreEnBoton=S
NombreDesplegar=Salir
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
EspacioPrevio=S

ListaAccionesMultiples=Cancelar Cambios<BR>Cerrar
[Acciones.Salir.Cancelar Cambios]
Nombre=Cancelar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S

[Acciones.Salir.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


[Acciones.Guardar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S


[Acciones.Eliminar.Registro Eliminar]
Nombre=Registro Eliminar
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S

[Acciones.Eliminar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S




[Acciones.Eliminar.Actualizar Forma]
Nombre=Actualizar Forma
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S

[Acciones.Guardar.Actualizar Forma]
Nombre=Actualizar Forma
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S

[Acciones.Guardar.Registro Siguiente]
Nombre=Registro Siguiente
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Siguiente
Activo=S
Visible=S

