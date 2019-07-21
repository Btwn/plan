
[Forma]
Clave=DM0207ApoyoCobDimaFrm
Icono=0
Modulos=(Todos)
Nombre=Apoyo Cobranza Dimas
PosicionInicialIzquierda=435
PosicionInicialArriba=222
PosicionInicialAlturaCliente=199
PosicionInicialAncho=356
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S

ListaAcciones=Guardar<BR>Cerrar
ListaCarpetas=CC<BR>NC
CarpetaPrincipal=CC
PosicionCol1=367
PosicionSec1=181
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar
EnBarraHerramientas=S
Activo=S
Visible=S

TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios

[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
Activo=S
Visible=S

TipoAccion=Ventana
ClaveAccion=Cerrar

[CC]
Estilo=Hoja
Pestana=S
Clave=CC
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0207CaracCuentaVis
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
ListaEnCaptura=TablaStD.Valor<BR>TablaStD.Nombre
CarpetaVisible=S

BusquedaRapidaControles=S
FiltroModificarEstatus=S
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
PestanaOtroNombre=S
PestanaNombre=Características de la Cuenta
PermiteEditar=S
GuardarPorRegistro=S
[CC.TablaStD.Valor]
Carpeta=CC
Clave=TablaStD.Valor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=250
ColorFondo=Blanco

[CC.TablaStD.Nombre]
Carpeta=CC
Clave=TablaStD.Nombre
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=250
ColorFondo=Blanco

[CC.Columnas]
Valor=57
Nombre=192


[NC]
Estilo=Hoja
Pestana=S
Clave=NC
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0207JerarquiaNivCobCteFVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=TCIDM0207_JerarquiaNivCobCteF.Orden<BR>TCIDM0207_JerarquiaNivCobCteF.NivelCobranza<BR>TCIDM0207_JerarquiaNivCobCteF.Maximo
CarpetaVisible=S

BusquedaRapidaControles=S
FiltroModificarEstatus=S
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
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
PestanaOtroNombre=S
PestanaNombre=Nivel de Cobranza
PermiteEditar=S
GuardarPorRegistro=S
[NC.TCIDM0207_JerarquiaNivCobCteF.Orden]
Carpeta=NC
Clave=TCIDM0207_JerarquiaNivCobCteF.Orden
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[NC.TCIDM0207_JerarquiaNivCobCteF.NivelCobranza]
Carpeta=NC
Clave=TCIDM0207_JerarquiaNivCobCteF.NivelCobranza
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[NC.TCIDM0207_JerarquiaNivCobCteF.Maximo]
Carpeta=NC
Clave=TCIDM0207_JerarquiaNivCobCteF.Maximo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[NC.Columnas]
Orden=64
NivelCobranza=124
Maximo=64

[(Carpeta Abrir)]
Estilo=Iconos
Pestana=S
Clave=(Carpeta Abrir)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Vista=DM0207CaracCuentaVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPaginaEsp=200
CampoColorLetras=Negro
CampoColorFondo=Negro
CarpetaVisible=S
