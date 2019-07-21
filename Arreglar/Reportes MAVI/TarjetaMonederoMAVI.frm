
[Forma]
Clave=TarjetaMonederoMAVI
Icono=67
Modulos=(Todos)
Nombre=Monedero Electrónico
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S

ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialIzquierda=406
PosicionInicialArriba=276
PosicionInicialAlturaCliente=178
PosicionInicialAncho=553
BarraAyuda=S
BarraAyudaBold=S
DialogoAbrir=S
Menus=S
ListaAcciones=Nuevo<BR>Por Rango<BR>Abrir<BR>Guardar<BR>Eliminar<BR>Navegador<BR>Cerrar
MenuPrincipal=&Archivo
[Lista]
Estilo=Ficha
Clave=Lista
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=TarjetaMonederoMAVI
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=TarjetaMonederoMAVI.Serie<BR>TarjetaMonederoMAVI.FechaAlta<BR>TarjetaMonederoMAVI.FechaActivacion<BR>TarjetaMonederoMAVI.FechaBaja
CarpetaVisible=S

CondicionEdicion=no TarjetaMonederoMAVI:TarjetaMonederoMAVI.TieneMovimientos
[Lista.TarjetaMonederoMAVI.Serie]
Carpeta=Lista
Clave=TarjetaMonederoMAVI.Serie
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro

[Lista.TarjetaMonederoMAVI.FechaAlta]
Carpeta=Lista
Clave=TarjetaMonederoMAVI.FechaAlta
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

Tamano=20
ColorFuente=Negro
[Lista.TarjetaMonederoMAVI.FechaActivacion]
Carpeta=Lista
Clave=TarjetaMonederoMAVI.FechaActivacion
LineaNueva=N
ValidaNombre=S
3D=S
ColorFondo=Blanco

Tamano=20
ColorFuente=Negro
[Lista.TarjetaMonederoMAVI.FechaBaja]
Carpeta=Lista
Clave=TarjetaMonederoMAVI.FechaBaja
LineaNueva=N
ValidaNombre=S
3D=S
ColorFondo=Blanco
Tamano=20
ColorFuente=Negro

[(Carpeta Abrir)]
Estilo=Iconos
PestanaOtroNombre=S
PestanaNombre=Monedero Electrónico
Clave=(Carpeta Abrir)
OtroOrden=S
BusquedaRapidaControles=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Vista=TarjetaMonederoMAVIA
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Monedero Electrónico<T>
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Negro
ListaOrden=TarjetaMonederoMAVI.Serie<TAB>(Acendente)<BR>TarjetaMonederoMAVI.FechaAlta<TAB>(Acendente)
FiltroEstatus=S
FiltroUsuarios=S
FiltroFechas=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroListaEstatus=(Todos)<BR>ALTA<BR>ACTIVA<BR>BAJA
FiltroEstatusDefault=ALTA
FiltroUsuarioDefault=(Todos)
FiltroFechasCampo=TarjetaMonederoMAVI.FechaAlta
FiltroFechasDefault=(Todo)
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaAncho=20
BusquedaEnLinea=S
CarpetaVisible=S

RefrescarAlEntrar=S
IconosNombre=TarjetaMonederoMAVIA:TarjetaMonederoMAVI.Serie
[(Carpeta Abrir).Columnas]
0=-2

[Acciones.Nuevo]
Nombre=Nuevo
Boton=1
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Ctrl+N
NombreDesplegar=&Nuevo
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Documento Nuevo
Activo=S
Visible=S

[Acciones.Abrir]
Nombre=Abrir
Boton=2
UsaTeclaRapida=S
TeclaRapida=Ctrl+A
NombreDesplegar=&Abrir...
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Documento Abrir
Activo=S
Visible=S

Menu=&Archivo
[Acciones.Guardar]
Nombre=Guardar
Boton=3
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Ctrl+G
NombreDesplegar=Guardar
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Eliminar]
Nombre=Eliminar
Boton=5
NombreDesplegar=Eliminar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Documento Eliminar
ActivoCondicion=No TarjetaMonederoMAVI:TarjetaMonederoMAVI.TieneMovimientos
Visible=S

[Acciones.Navegador]
Nombre=Navegador
Boton=0
NombreDesplegar=Navegador
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Herramientas Captura
ClaveAccion=Navegador (Documentos)
Activo=S
Visible=S

[Acciones.Cerrar]
Nombre=Cerrar
Boton=0
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Ctrl+F4
NombreDesplegar=&Cerrar
EnMenu=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Por Rango]
Nombre=Por Rango
Boton=109
NombreDesplegar=&Por Rango
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Formas
ClaveAccion=MonederoRangoFrm
Activo=S
Visible=S
NombreEnBoton=S

