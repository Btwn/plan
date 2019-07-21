[Forma]
Clave=RM0141cobXEmbvisFRM
Nombre=Forma de Envio
Icono=0
Modulos=(Todos)
ListaCarpetas=Envio
CarpetaPrincipal=Envio
PosicionInicialAlturaCliente=273
PosicionInicialAncho=224
MovModulo=(Todos)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar2
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
[Envio]
Estilo=Iconos
Clave=Envio
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0141cobXEmbFpagoVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
BusquedaRapidaControles=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
ListaEnCaptura=FORMAENVIO
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosConRejilla=S
IconosSeleccionMultiple=S
MenuLocal=S
ListaAcciones=SelTodo<BR>QuitarSel
[Envio.FORMAENVIO]
Carpeta=Envio
Clave=FORMAENVIO
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Envio.Columnas]
FORMAENVIO=304
0=-2
[Acciones.Seleccionar2.Asig]
Nombre=Asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccionar2.Registra]
Nombre=Registra
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>vista<T>)
[Acciones.Seleccionar2.select]
Nombre=select
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=asigna(Mavi.FormaEnvia,sql(<T>exec sp_mavicuentaestacionuen <T>+ EstacionTrabajo +<T>,1<T>))<BR>sql(<T>exec sp_mavicuentaestacionuen <T>+ estaciontrabajo +<T>,1<T>)
[Acciones.Seleccionar2]
Nombre=Seleccionar2
Boton=23
NombreEnBoton=S
NombreDesplegar=Selecci&onar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asig<BR>Registra<BR>select
Activo=S
Visible=S
[Acciones.SelTodo]
Nombre=SelTodo
Boton=0
NombreDesplegar=Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.QuitarSel]
Nombre=QuitarSel
Boton=0
NombreDesplegar=Quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

