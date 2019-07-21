
[Forma]
Clave=RM1186LineaFrm
Icono=0
Modulos=(Todos)
Nombre=Líneas

ListaCarpetas=RM1186LineaVis
CarpetaPrincipal=RM1186LineaVis
PosicionInicialIzquierda=509
PosicionInicialArriba=169
PosicionInicialAlturaCliente=392
PosicionInicialAncho=347
VentanaSiempreAlFrente=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
[RM1186LineaVis]
Estilo=Iconos
Clave=RM1186LineaVis
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1186LineaVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=Linea


BusquedaRapidaControles=S
MenuLocal=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
ListaAcciones=Seleccionar Todo<BR>Quitar Seleccion
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPaginaEsp=200
IconosConRejilla=S
IconosSeleccionMultiple=S
[RM1186LineaVis.Columnas]
Linea=304

0=-2
1=-2
[RM1186LineaVis.Linea]
Carpeta=RM1186LineaVis
Clave=Linea
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Acciones.Seleccionar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Seleccionar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Vista<T>)
Activo=S
Visible=S

[Acciones.Seleccionar.Preliminar]
Nombre=Preliminar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(MAVI.RM1186Linea,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
Activo=S
Visible=S


[Acciones.Seleccionar Todo]
Nombre=Seleccionar Todo
Boton=0
NombreDesplegar=Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.Quitar Seleccion]
Nombre=Quitar Seleccion
Boton=0
NombreDesplegar=Quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

[Acciones.Seleccionar.Asignar1]
Nombre=Asignar1
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=Seleccionar
Multiple=S
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
ListaAccionesMultiples=Asignar1<BR>Expresion1<BR>Preliminar1
Activo=S
Visible=S

GuardarAntes=S

[Acciones.Seleccionar.Preliminar1]
Nombre=Preliminar1
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S


Expresion=Asigna(MAVI.RM1186Linea,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[RM1186FamiliaVis.Familia]
Carpeta=RM1186FamiliaVis
Clave=Familia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[RM1186FamiliaVis.Columnas]
Familia=304

[Acciones.Seleccionar.Expresion1]
Nombre=Expresion1
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>RM1186LineaVis<T>)
Activo=S
Visible=S





