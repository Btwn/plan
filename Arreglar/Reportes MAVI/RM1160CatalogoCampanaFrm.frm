
[Forma]
Clave=RM1160CatalogoCampanaFrm
Icono=0
Modulos=(Todos)
Nombre=Catálogo Campaña

ListaCarpetas=LeyendaC<BR>IngresarDatos<BR>MostrarMensaje
CarpetaPrincipal=MostrarMensaje
PosicionInicialAlturaCliente=439
PosicionInicialAncho=1100
PosicionInicialIzquierda=66
PosicionInicialArriba=204
PosicionCol1=293
PosicionSec1=172
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=AgregarMensaje<BR>Eliminar<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
VentanaSinIconosMarco=S
[LeyendaC]
Estilo=Hoja
Pestana=S
Clave=LeyendaC
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
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
Vista=RM1160LeyendaCamposVis
ListaEnCaptura=Identificador<BR>Campos a Presentar

PestanaOtroNombre=S
PestanaNombre=LEYENDA


[LeyendaC.Columnas]
IDENTIFICADOR=80
CAMPOS A PRESENTAR=160



Campana=94
Mensaje=604
[IngresarDatos]
Estilo=Ficha
Pestana=S
Clave=IngresarDatos
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A2
Vista=RM1160IngreCatMensajeVist
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco

FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S

PermiteEditar=S

ListaEnCaptura=RM1160TConfMensajeTbl.Nombre<BR>RM1160TConfMensajeTbl.Mensaje
PestanaOtroNombre=S
PestanaNombre=Ingresa datos
CarpetaVisible=S
[IngresarDatos.Columnas]
TipoCampana=304
Mensaje=604



[Listado.Columnas]
TipoCampana=230
Mensaje=770

Titulo=94
Nombre=118
MinimoDV=57
MaximoDV=59
Uen=32
TextoMensaje=434
TextoSalida=313
Usuario=76
Fecha=76
Campana=94
[Acciones.AgregarMensaje]
Nombre=AgregarMensaje
Boton=3
NombreEnBoton=S
NombreDesplegar=&Agregar Mensaje
EnBarraHerramientas=S
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Siguiente<BR>Verificar<BR>Asigna<BR>Guardar<BR>Expre
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Si<BR>  ConDatos( RM1160IngreCatMensajeVist:RM1160TConfMensajeTbl.Nombre)<BR>Entonces<BR>  verdadero<BR>Sino<BR>  falso<BR>Fin
EjecucionMensaje=<T>Debe ingresar un Campaña<T>
[Acciones.Eliminar]
Nombre=Eliminar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Eliminar Mensaje
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S

ListaAccionesMultiples=seleccion<BR>RegistroEliminar<BR>EliminarVista
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


Multiple=S
ListaAccionesMultiples=NoGuardar<BR>cerrar
[Acciones.AgregarMensaje.Siguiente]
Nombre=Siguiente
Boton=0
TipoAccion=Controles Captura
Activo=S
Visible=S
Carpeta=IngresarDatos
ClaveAccion=Registro Siguiente

[Acciones.AgregarMensaje.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S


[Campana.Columnas]
0=-2

Titulo=124
id=64
[Acciones.Eliminar.RegistroEliminar]
Nombre=RegistroEliminar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S


Expresion=EjecutarSQL(<T>EXEC SPCXcEliminarMensaje :nPARA1<T>,RM1160ListadoMsjConfig:RM1160TConfMensajeEliminarTbl.IdMensaje )
[IngresarDatos.RM1160TConfMensajeTbl.Mensaje]
Carpeta=IngresarDatos
Clave=RM1160TConfMensajeTbl.Mensaje
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco


[Leyenda.Columnas]
IDENTIFICADOR=65
CAMPOS A PRESENTAR=158








[Acciones.AgregarMensaje.Expre]
Nombre=Expre
Boton=0
TipoAccion=expresion
Activo=S
Visible=S


Expresion=Asigna(RM1160IngreCatMensajeVist:RM1160TConfMensajeTbl.IdMensaje ,nulo )<BR>Asigna(RM1160IngreCatMensajeVist:RM1160TConfMensajeTbl.IdCamp ,nulo )<BR>Asigna( RM1160IngreCatMensajeVist:RM1160TConfMensajeTbl.Nombre,nulo )<BR>Asigna( RM1160IngreCatMensajeVist:RM1160TConfMensajeTbl.Mensaje,nulo )       <BR>Forma.ActualizarVista(<T>MostrarMensaje<T>)
[Acciones.GuardarPrueba.Expre]
Nombre=Expre
Boton=0
TipoAccion=expresion
Expresion=Asigna(RM1160IngreCatMensajeVist:RM1160TConfMensajeTbl.IdCampana,info.dialogo )     
Activo=S
Visible=S

[Acciones.GuardarPrueba.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.GuardarPrueba.sh]
Nombre=sh
Boton=0
Carpeta=IngresarDatos
TipoAccion=Controles Captura
ClaveAccion=Registro Insertar
Activo=S
Visible=S


[MostrarMensaje]
Estilo=Hoja
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Mensajes
Clave=MostrarMensaje
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=RM1160ListadoMsjConfig
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
ListaEnCaptura=RM1160TConfMensajeEliminarTbl.Nombre<BR>RM1160TConfMensajeEliminarTbl.Mensaje
CarpetaVisible=S



PermiteEditar=S
[MostrarMensaje.Columnas]
Campana=148
Mensaje=604




Nombre=304
[LeyendaC.Identificador]
Carpeta=LeyendaC
Clave=Identificador
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=2
ColorFondo=Blanco

[LeyendaC.Campos a Presentar]
Carpeta=LeyendaC
Clave=Campos a Presentar
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.AgregarMensaje.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S



Expresion=Asigna(RM1160IngreCatMensajeVist:RM1160TConfMensajeTbl.IdCamp,info.dialogo )
[Acciones.AgregarMensaje.Verificar]
Nombre=Verificar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Si<BR>  ConDatos(RM1160IngreCatMensajeVist:RM1160TConfMensajeTbl.Nombre )  y ConDatos( RM1160IngreCatMensajeVist:RM1160TConfMensajeTbl.Mensaje)<BR>Entonces<BR>  verdadero<BR>Sino<BR>  <T>Debe llenar el campo de campaña y  mensaje<T><BR>Fin
[Acciones.Cerrar.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Cerrar.NoGuardar]
Nombre=NoGuardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S



[Acciones.Eliminar.seleccion]
Nombre=seleccion
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S




[MostrarMensaje.RM1160TConfMensajeEliminarTbl.Mensaje]
Carpeta=MostrarMensaje
Clave=RM1160TConfMensajeEliminarTbl.Mensaje
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco




[Acciones.Eliminar.EliminarVista]
Nombre=EliminarVista
Boton=0
Carpeta=MostrarMensaje
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S

[IngresarDatos.RM1160TConfMensajeTbl.Nombre]
Carpeta=IngresarDatos
Clave=RM1160TConfMensajeTbl.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[MostrarMensaje.RM1160TConfMensajeEliminarTbl.Nombre]
Carpeta=MostrarMensaje
Clave=RM1160TConfMensajeEliminarTbl.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

