
[Forma]
Clave=RM1154ConfigurarTipoRespuestaFrm
Icono=17
Modulos=(Todos)
Nombre=Configuracion de Tipos de Respuesta

ListaCarpetas=VISTA
CarpetaPrincipal=VISTA
PosicionInicialAlturaCliente=148
PosicionInicialAncho=387
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Eliminar
PosicionInicialIzquierda=446
PosicionInicialArriba=418
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal



[Rama.Columnas]
TablaSt=179
Nombre=125
Valor=84

[Acciones.Guardar.Registro siguiente]
Nombre=Registro siguiente
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Siguiente
Activo=S
Visible=S

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
NombreDesplegar=&Guardar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Registro siguiente<BR>Guardar<BR>Actualizar
Activo=S
Visible=S
NombreEnBoton=S

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


[Vista.Columnas]
TablaSt=191
Nombre=350





Valor=604
[Vista.RM1154ConfigTipRespTbl.Nombre]
Carpeta=VISTA
Clave=RM1154ConfigTipRespTbl.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=250
ColorFondo=Blanco




[VISTA1.Columnas]
TablaSt=304
Nombre=604

[VISTA]
Estilo=Hoja
Clave=VISTA
Filtros=S
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1154ConfigTipRespVis
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
ListaEnCaptura=RM1154ConfigTipRespTbl.Nombre
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
CarpetaVisible=S


FiltroGeneral=RM1154ConfigTipRespTbl.TablaSt=<T>TIPOS RESPUESTA REANALISIS<T>

