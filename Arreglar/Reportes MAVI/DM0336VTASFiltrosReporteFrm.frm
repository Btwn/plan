
[Forma]
Clave=DM0336VTASFiltrosReporteFrm
Icono=134
Modulos=(Todos)
Nombre=<T>Generador De Reporte<T>
PosicionInicialAlturaCliente=273
PosicionInicialAncho=338

ListaCarpetas=Filtros<BR>TipoReporte
CarpetaPrincipal=Filtros
PosicionInicialIzquierda=497
PosicionInicialArriba=251
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Mavi.DM0336Sucursal,)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=GenerarReporte




PosicionSec1=141
[Acciones.GenerarReporte.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.GenerarReporte.Reporte]
Nombre=Reporte
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=DM0336VTASCancelacionesMagentoRep
Activo=S
Visible=S


[Acciones.GenerarReporte]
Nombre=GenerarReporte
Boton=9
NombreEnBoton=S
NombreDesplegar=Generar Reporte
EnBarraHerramientas=S
Activo=S
Visible=S


Multiple=S
ListaAccionesMultiples=Asignar<BR>Expresion
[Filtros]
Estilo=Ficha
Clave=Filtros
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.FechaD<BR>Info.FechaA<BR>Mavi.DM0336Sucursal
CarpetaVisible=S

[Filtros.Info.FechaD]
Carpeta=Filtros
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco

[Filtros.Info.FechaA]
Carpeta=Filtros
Clave=Info.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco

[Filtros.Mavi.DM0336Sucursal]
Carpeta=Filtros
Clave=Mavi.DM0336Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco

[TipoReporte]
Estilo=Hoja
Clave=TipoReporte
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0336VTASTipoReporteVis
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
ListaEnCaptura=Reporte
CarpetaVisible=S

[TipoReporte.Reporte]
Carpeta=TipoReporte
Clave=Reporte
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco

[TipoReporte.Columnas]
Reporte=290

[Acciones.GenerarReporte.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.GenerarReporte.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Caso DM0336VTASTipoReporteVis:Reporte<BR>  Es <T>PEDIDOS CANCELADOS - REPORTE DE PANTALLA<T> Entonces  ReportePantalla(<T>DM0336VTASCancelacionesMagentoRep<T>)<BR>  Es <T>PEDIDOS CANCELADOS - REPORTE DE TEXTO<T> Entonces  ReporteImpresora(<T>DM0336VTASCancelacionesMagentoRepTxt<T>)<BR>Sino<BR>  Informacion(<T>Seleccione un tipo de reporte a generarse<T>)<BR>Fin

