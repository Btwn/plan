
[Forma]
Clave=DM0345COMSFamiliasEImagenesAppDimaFrm
Icono=0
Modulos=(Todos)
Nombre=<T>Familias Y Nombres De Imagenes Para La App DIMA<T>

ListaCarpetas=Principal
CarpetaPrincipal=Principal
PosicionInicialIzquierda=228
PosicionInicialArriba=349
PosicionInicialAlturaCliente=273
PosicionInicialAncho=783
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
Vista=DM0345COMSFamiliasEImagenesAppDimaVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DM0345COMSFamiliasEImagenesAppDimaTbl.Familia<BR>DM0345COMSFamiliasEImagenesAppDimaTbl.NombreImagen
CarpetaVisible=S

[Principal.DM0345COMSFamiliasEImagenesAppDimaTbl.Familia]
Carpeta=Principal
Clave=DM0345COMSFamiliasEImagenesAppDimaTbl.Familia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Principal.DM0345COMSFamiliasEImagenesAppDimaTbl.NombreImagen]
Carpeta=Principal
Clave=DM0345COMSFamiliasEImagenesAppDimaTbl.NombreImagen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco

[Principal.Columnas]
Familia=304
NombreImagen=435


[Acciones.Guardar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Guardar.Actualizar Forma]
Nombre=Actualizar Forma
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S

[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=Guardar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Guardar Cambios<BR>Actualizar Forma<BR>Expresion
Activo=S
Visible=S

ConCondicion=S
EjecucionCondicion=Forma.RegistroSiguiente<BR><BR>Si(ConDatos(DM0345COMSFamiliasEImagenesAppDimaVis:DM0345COMSFamiliasEImagenesAppDimaTbl.Familia),<BR>   verdadero,<BR>   Informacion(<T>Debe de llenar el campo <Familia><T>) AbortarOperacion)<BR><BR>Si(ConDatos(DM0345COMSFamiliasEImagenesAppDimaVis:DM0345COMSFamiliasEImagenesAppDimaTbl.NombreImagen),<BR>   verdadero,<BR>   Informacion(<T>Debe de llenar el campo <Nombre De La Imagen><T>) AbortarOperacion)                    
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

[Acciones.Eliminar]
Nombre=Eliminar
Boton=36
NombreEnBoton=S
NombreDesplegar=Eliminar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Registro Eliminar<BR>Guardar Cambios<BR>Actualizar Forma<BR>Expresion
Activo=S
Visible=S
EspacioPrevio=S


[Acciones.Salir.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Salir]
Nombre=Salir
Boton=23
NombreEnBoton=S
NombreDesplegar=Salir
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Cerrar
Activo=S
Visible=S
EspacioPrevio=S

[Acciones.Eliminar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Expresion=Informacion(<T>Registro Eliminado<T>)
Activo=S
Visible=S

[Acciones.Guardar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Expresion=Informacion(<T>Datos Guardados<T>)
Activo=S
Visible=S

