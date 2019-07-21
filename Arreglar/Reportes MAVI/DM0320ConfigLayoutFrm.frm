
[Forma]
Clave=DM0320ConfigLayoutFrm
Icono=0
Modulos=(Todos)
Nombre=Configuración para Almacén
PosicionInicialAlturaCliente=144
PosicionInicialAncho=203

ListaCarpetas=Ubicacion
CarpetaPrincipal=Ubicacion
PosicionInicialIzquierda=538
PosicionInicialArriba=421
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Salir
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal

PosicionCol1=400
PosicionSec1=52
IniciarAgregando=S
VentanaSinIconosMarco=S
[Acciones.Salir]
Nombre=Salir
Boton=36
NombreDesplegar=&Salir
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
NombreEnBoton=S

BtnResaltado=S
EspacioPrevio=S

Multiple=S
ListaAccionesMultiples=Cancelar<BR>Abrir<BR>Cerrar
[Articulos.Columnas]
Articulo=124




[Articulo.Columnas]
Articulo=125




Descripcion1=604
[Acciones.Guardar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Guardar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
ConCondicion=S



[(Variables).Mavi.DM0320Articulo]
Carpeta=(Variables)
Clave=Mavi.DM0320Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[(Variables).Mavi.DM0320Descripcion]
Carpeta=(Variables)
Clave=Mavi.DM0320Descripcion
Editar=N
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco




LineaNueva=N

[Ubicacion]
Estilo=Ficha
Clave=Ubicacion
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0320ConfigLayoutVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DM0320ConfigLayoutTbl.Modulo<BR>DM0320ConfigLayoutTbl.Rack<BR>DM0320ConfigLayoutTbl.Nivel
CarpetaVisible=S

PermiteEditar=S



FichaEspacioEntreLineas=8
FichaEspacioNombres=85
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
FichaEspacioNombresAuto=S
[Ubicacion.Columnas]
Modulo=38
Rack=34
Nivel=34



Id=64
[Ubicacion.DM0320ConfigLayoutTbl.Modulo]
Carpeta=Ubicacion
Clave=DM0320ConfigLayoutTbl.Modulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Ubicacion.DM0320ConfigLayoutTbl.Rack]
Carpeta=Ubicacion
Clave=DM0320ConfigLayoutTbl.Rack
Editar=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

LineaNueva=S
[Ubicacion.DM0320ConfigLayoutTbl.Nivel]
Carpeta=Ubicacion
Clave=DM0320ConfigLayoutTbl.Nivel
Editar=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
LineaNueva=S



[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

ConCondicion=S
Multiple=S
ListaAccionesMultiples=Actualizar<BR>Abrir<BR>Cerrar
EjecucionCondicion=Si Vacio(DM0320ConfigLayoutVis:DM0320ConfigLayoutTbl.Modulo) y Vacio(DM0320ConfigLayoutVis:DM0320ConfigLayoutTbl.Rack) y Vacio(DM0320ConfigLayoutVis:DM0320ConfigLayoutTbl.Nivel)<BR>    Entonces<BR>        Informacion(<T>Campos vacíos.<T>)<BR>        AbortarOperacion<BR>Fin
[Acciones.Salir.Cancelar]
Nombre=Cancelar
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

[Acciones.Guardar.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S



[Acciones.Guardar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Guardar.Abrir]
Nombre=Abrir
Boton=0
TipoAccion=Formas
ClaveAccion=DM0320UbicacionFrm
Activo=S
Visible=S

[Acciones.Salir.Abrir]
Nombre=Abrir
Boton=0
TipoAccion=Formas
ClaveAccion=DM0320UbicacionFrm
Activo=S
Visible=S

