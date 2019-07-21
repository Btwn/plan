
[Forma]
Clave=DM0306ProdServFrm
Icono=0
Modulos=(Todos)
Nombre=Productos SAT

ListaCarpetas=DM0306ProdServVist
CarpetaPrincipal=DM0306ProdServVist
PosicionInicialIzquierda=390
PosicionInicialArriba=353
PosicionInicialAlturaCliente=273
PosicionInicialAncho=500
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Eliminar<BR>Importar<BR>cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaSinIconosMarco=S
VentanaEstadoInicial=Normal
[DM0306ProdServVist]
Estilo=Hoja
Clave=DM0306ProdServVist
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0306ProdServVist
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


ListaEnCaptura=DM0306ProdSeTbl.CveProdServ<BR>DM0306ProdSeTbl.Descripcion
[DM0306ProdServVist.Columnas]
CveProdServ=77
Descripcion=373

[Acciones.Eliminar]
Nombre=Eliminar
Boton=36
NombreEnBoton=S
NombreDesplegar=E&liminar
EnBarraHerramientas=S
Activo=S
Visible=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar

Multiple=S
ListaAccionesMultiples=eliminar<BR>actualizar Titulos
[Acciones.Importar]
Nombre=Importar
Boton=2
NombreEnBoton=S
NombreDesplegar=I&mportar
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Enviar/Recibir Excel
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=expresion<BR>Enviar/Recibir Excel<BR>actualizar
[Acciones.Guardar.Save]
Nombre=Save
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S


[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=G&uardar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Registro Siguiente<BR>Save<BR>actualiza
Activo=S
Visible=S

[Acciones.Modificar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
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


[Acciones.cerrar]
Nombre=cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=C&errar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Cancelar<BR>Cerrar

[Acciones.cerrar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


[Acciones.Eliminar.eliminar]
Nombre=eliminar
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S




[DM0306ProdServVist.DM0306ProdSeTbl.CveProdServ]
Carpeta=DM0306ProdServVist
Clave=DM0306ProdSeTbl.CveProdServ
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco

[DM0306ProdServVist.DM0306ProdSeTbl.Descripcion]
Carpeta=DM0306ProdServVist
Clave=DM0306ProdSeTbl.Descripcion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=150
ColorFondo=Blanco

[Acciones.cerrar.Cancelar]
Nombre=Cancelar
Boton=0
TipoAccion=controles Captura
ClaveAccion=Cancelar Cambios
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


[Acciones.Eliminar.actualizar Titulos]
Nombre=actualizar Titulos
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

[Acciones.Guardar.actualiza]
Nombre=actualiza
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S




[Acciones.Importar.expresion]
Nombre=expresion
Boton=0
TipoAccion=expresion
Activo=S
Visible=S

Expresion=Ejecutarsql(<T>EXEC SpIDM0306_Truncate :NOption<T>, 1)
[Acciones.Importar.Enviar/Recibir Excel]
Nombre=Enviar/Recibir Excel
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=controles Captura
ClaveAccion=Enviar/Recibir Excel
Activo=S
Visible=S


[Acciones.Importar.actualizar]
Nombre=actualizar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

