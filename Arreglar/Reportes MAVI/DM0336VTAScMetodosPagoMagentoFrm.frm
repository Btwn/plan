
[Forma]
Clave=DM0336VTAScMetodosPagoMagentoFrm
Icono=0
Modulos=(Todos)
Nombre=DM0336VTAScMetodosPagoMagentoFrm

BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=abrir<BR>nuevo<BR>guardar<BR>eliminar
DialogoAbrir=S
PosicionInicialAlturaCliente=273
PosicionInicialAncho=500
PosicionInicialIzquierda=707
PosicionInicialArriba=240
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
PosicionSec1=104

ListaCarpetas=campos
CarpetaPrincipal=campos
[Acciones.guardar]
Nombre=guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=Guardar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

RefrescarDespues=S
[(Carpeta Abrir)]
Estilo=Iconos
Pestana=S
Clave=(Carpeta Abrir)
BusquedaRapidaControles=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Vista=DM0336VTAScMetodosPagoMagentoVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPaginaEsp=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
CarpetaVisible=S

BusquedaRapida=S
BusquedaEnLinea=S




ListaEnCaptura=DM0336VTASCMetodosPagoMagentoTbl.CodigoMagento<BR>DM0336VTASCMetodosPagoMagentoTbl.Descripcion<BR>DM0336FormaPagoVistaTbl.FormaPago<BR>DM0336VTASCMetodosPagoMagentoTbl.Pagos
OtroOrden=S
ListaOrden=DM0336VTASCMetodosPagoMagentoTbl.CodigoMagento<TAB>(Acendente)
[vista.Columnas]
CodigoMagento=184
Descripcion=154
IDFormaPago=69
Pagos=64

FormaPago=304
0=-2
1=-2
[(Carpeta Abrir).Columnas]
0=131
1=226
2=175
3=42





[Acciones.abrir]
Nombre=abrir
Boton=2
NombreEnBoton=S
NombreDesplegar=Abrir
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Documento Abrir
Activo=S
Visible=S

[Acciones.nuevo]
Nombre=nuevo
Boton=1
NombreEnBoton=S
NombreDesplegar=Nuevo
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Documento Nuevo
Activo=S
Visible=S

[Acciones.eliminar]
Nombre=eliminar
Boton=36
NombreEnBoton=S
NombreDesplegar=Eliminar
EnBarraHerramientas=S
TipoAccion=controles Captura
ClaveAccion=Documento Eliminar
Activo=S
Visible=S










[Acciones.guardar.actuali]
Nombre=actuali
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Insertar
Activo=S
Visible=S


[vasriables.Info.Descripcion]
Carpeta=vasriables
Clave=Info.Descripcion
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco






[vista.DM0336VTAScMetodosPagoMagentoTbl.CodigoMagento]
Carpeta=vista
Clave=DM0336VTAScMetodosPagoMagentoTbl.CodigoMagento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco

[vista.DM0336VTAScMetodosPagoMagentoTbl.Descripcion]
Carpeta=vista
Clave=DM0336VTAScMetodosPagoMagentoTbl.Descripcion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco

[vista.DM0336VTAScMetodosPagoMagentoTbl.IdFormaPago]
Carpeta=vista
Clave=DM0336VTAScMetodosPagoMagentoTbl.IdFormaPago
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco


[vista.DM0336VTAScMetodosPagoMagentoTbl.Pagos]
Carpeta=vista
Clave=DM0336VTAScMetodosPagoMagentoTbl.Pagos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco




[vista.DM0336FormaPagoVistaTbl.FormaPago]
Carpeta=vista
Clave=DM0336FormaPagoVistaTbl.FormaPago
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco


[campos]
Estilo=Ficha
Pestana=S
Clave=campos
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0336VTAScMetodosPagoMagentoVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=DM0336VTASCMetodosPagoMagentoTbl.CodigoMagento<BR>DM0336VTASCMetodosPagoMagentoTbl.Descripcion<BR>DM0336VTASCMetodosPagoMagentoTbl.IdFormaPago<BR>DM0336FormaPagoVistaTbl.FormaPago<BR>DM0336VTASCMetodosPagoMagentoTbl.Pagos

PermiteEditar=S
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
[campos.DM0336VTASCMetodosPagoMagentoTbl.CodigoMagento]
Carpeta=campos
Clave=DM0336VTASCMetodosPagoMagentoTbl.CodigoMagento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=
ColorFondo=Blanco

[campos.DM0336VTASCMetodosPagoMagentoTbl.Descripcion]
Carpeta=campos
Clave=DM0336VTASCMetodosPagoMagentoTbl.Descripcion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco

[campos.DM0336VTASCMetodosPagoMagentoTbl.IdFormaPago]
Carpeta=campos
Clave=DM0336VTASCMetodosPagoMagentoTbl.IdFormaPago
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[campos.DM0336FormaPagoVistaTbl.FormaPago]
Carpeta=campos
Clave=DM0336FormaPagoVistaTbl.FormaPago
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[campos.DM0336VTASCMetodosPagoMagentoTbl.Pagos]
Carpeta=campos
Clave=DM0336VTASCMetodosPagoMagentoTbl.Pagos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[campos.Columnas]
CodigoMagento=184
Descripcion=154
IdFormaPago=68
FormaPago=304
Pagos=64

[(Carpeta Abrir).DM0336VTASCMetodosPagoMagentoTbl.CodigoMagento]
Carpeta=(Carpeta Abrir)
Clave=DM0336VTASCMetodosPagoMagentoTbl.CodigoMagento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco

[(Carpeta Abrir).DM0336VTASCMetodosPagoMagentoTbl.Descripcion]
Carpeta=(Carpeta Abrir)
Clave=DM0336VTASCMetodosPagoMagentoTbl.Descripcion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco

[(Carpeta Abrir).DM0336FormaPagoVistaTbl.FormaPago]
Carpeta=(Carpeta Abrir)
Clave=DM0336FormaPagoVistaTbl.FormaPago
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[(Carpeta Abrir).DM0336VTASCMetodosPagoMagentoTbl.Pagos]
Carpeta=(Carpeta Abrir)
Clave=DM0336VTASCMetodosPagoMagentoTbl.Pagos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[DM0336FormaPagoVis.Columnas]
0=-2
1=-2

