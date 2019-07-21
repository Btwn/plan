
[Forma]
Clave=DM0239AgregaLineaFrm
Icono=6
Modulos=(Todos)
Nombre=Linea de Articulos

ListaCarpetas=AgregarLinea<BR>DM0239Filtros
CarpetaPrincipal=AgregarLinea
PosicionInicialIzquierda=368
PosicionInicialArriba=222
PosicionInicialAlturaCliente=542
PosicionInicialAncho=544
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar<BR>Actualizar Vista
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionSec1=56
SinTransacciones=S

VentanaAjustarZonas=S
VentanaRepetir=S
ExpresionesAlMostrar=Asigna(Mavi.DM0239Filtros,NULO)
ExpresionesAlCerrar=Forma(<T>DM0239AgreQuitLineaFrm<T>)
[Acciones.Seleccionar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Seleccionar.Select]
Nombre=Select
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S

Expresion=Asigna(Mavi.DM0239Linea,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asignar<BR>regis<BR>Select<BR>Mostrar<BR>Cerrar
Activo=S
Visible=S

NombreEnBoton=S
EspacioPrevio=S
[Acciones.Seleccionar.regis]
Nombre=regis
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S




Expresion=RegistrarSeleccion(<T>AgregarQuitarLinea<T>)
[AgregarQuitarLinea.Columnas]
0=180
1=158
2=-2

3=-2







Estatus=124
Segmento=304
[Acciones.Seleccionar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S



[Acciones.Seleccionar.Mostrar]
Nombre=Mostrar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S



ConCondicion=S
Expresion=Forma(<T>DM0239ContraSegFrm<T>)
EjecucionCondicion=ConDatos(Mavi.DM0239Linea)
EjecucionMensaje=<T>Seleccione una linea<T>
EjecucionConError=S
[Acciones.Actualizar Vista]
Nombre=Actualizar Vista
Boton=125
NombreEnBoton=S
NombreDesplegar=Actualizar Vista
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>Actualizar Vista
[Acciones.Actualizar Vista.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Actualizar Vista.Actualizar Vista]
Nombre=Actualizar Vista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

[DM0239Filtros]
Estilo=Ficha
Clave=DM0239Filtros
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S


ListaEnCaptura=Mavi.DM0239Filtros

FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
[DM0239Filtros.Mavi.DM0239Filtros]
Carpeta=DM0239Filtros
Clave=Mavi.DM0239Filtros
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[AgregarLinea]
Estilo=Iconos
Clave=AgregarLinea
BusquedaRapidaControles=S
Zona=B1
Vista=DM0239MuestraArticulosVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(Situación)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=Linea
IconosConRejilla=S
IconosSeleccionMultiple=S
ElementosPorPaginaEsp=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Estatus<BR>Segmento
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
BusquedaActualizacionManual=S
CarpetaVisible=S

IconosNombre=DM0239MuestraArticulosVis:Linea
[AgregarLinea.Estatus]
Carpeta=AgregarLinea
Clave=Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[AgregarLinea.Segmento]
Carpeta=AgregarLinea
Clave=Segmento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[AgregarLinea.Columnas]
0=-2
1=-2
2=-2


