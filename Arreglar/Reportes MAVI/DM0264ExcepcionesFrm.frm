
[Forma]
Clave=DM0264ExcepcionesFrm
Icono=0
Modulos=(Todos)
Nombre=DM0264Excepciones

ListaCarpetas=Excep
CarpetaPrincipal=Excep
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialIzquierda=191
PosicionInicialArriba=12
PosicionInicialAlturaCliente=705
PosicionInicialAncho=984
ListaAcciones=Guardar<BR>Importar Datos<BR>Eliminar<BR>Cerrar<BR>Actualizar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
[Excep]
Estilo=Hoja
Clave=Excep
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0264ExcepecionesVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DM0264ExcepcionesTbl.Articulo
CarpetaVisible=S

PermiteEditar=S
[Excep.DM0264ExcepcionesTbl.Articulo]
Carpeta=Excep
Clave=DM0264ExcepcionesTbl.Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

IgnoraFlujo=N
[Articulos.Columnas]
Articulo=124
Descripcion1=604

[Excep.Columnas]
Articulo=124

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

[Acciones.Importar Datos]
Nombre=Importar Datos
Boton=54
NombreEnBoton=S
NombreDesplegar=Agregar
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=DM0264VeriExecpcionesfrm
Activo=S
Visible=S

[Acciones.Eliminar]
Nombre=Eliminar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Eliminar
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S

[Acciones.Actualizar]
Nombre=Actualizar
Boton=0
NombreDesplegar=Actualizar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S

