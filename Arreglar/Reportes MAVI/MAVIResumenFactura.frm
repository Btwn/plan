[Forma]
Clave=MAVIResumenFactura
Nombre=Resumen Factura
Icono=0
Modulos=(Todos)
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
ListaCarpetas=MAVIVentaF
CarpetaPrincipal=MAVIVentaF
PosicionInicialIzquierda=287
PosicionInicialArriba=150
PosicionInicialAlturaCliente=466
PosicionInicialAncho=705
AccionesTamanoBoton=15x5
AccionesDerecha=S
BarraHerramientas=S
[MAVIVentaF]
Estilo=Ficha
Clave=MAVIVentaF
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=MAVIVentaF
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Derecha
FichaColorFondo=Plata
FichaAlineacionDerecha=S
ListaEnCaptura=(Lista)
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
FiltroGeneral={Si<BR>  ConDatos(Info.Mov) y ConDatos(Info.MovID)<BR>Entonces<BR>  <T>Cxc.Mov=<T>+Comillas(Info.Mov)+<T> AND Cxc.MovID=<T>+Comillas(Info.MovID)<BR>Sino<BR>  <T><T><BR>Fin<BR>}
[MAVIVentaF.MAVIFactura]
Carpeta=MAVIVentaF
Clave=MAVIFactura
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFuente=Negro
ColorFondo=Blanco
[MAVIVentaF.MAVIFecha1Abono]
Carpeta=MAVIVentaF
Clave=MAVIFecha1Abono
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFuente=Negro
ColorFondo=Blanco
[MAVIVentaF.MAVICliente]
Carpeta=MAVIVentaF
Clave=MAVICliente
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=N

[MAVIVentaF.MAVIMaxDiasV]
Carpeta=MAVIVentaF
Clave=MAVIMaxDiasV
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=20
[MAVIVentaF.MAVIMaxDiasI]
Carpeta=MAVIVentaF
Clave=MAVIMaxDiasI
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=20
[MAVIVentaF.MAVIDiasVencidos]
Carpeta=MAVIVentaF
Clave=MAVIDiasVencidos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=20
[MAVIVentaF.MAVIImporteUA]
Carpeta=MAVIVentaF
Clave=MAVIImporteUA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=20
[MAVIVentaF.MAVIHMaxDiasV]
Carpeta=MAVIVentaF
Clave=MAVIHMaxDiasV
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=20
[MAVIVentaF.MAVIHMaxDiasI]
Carpeta=MAVIVentaF
Clave=MAVIHMaxDiasI
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=20
[MAVIVentaF.MAVIFechaTermina]
Carpeta=MAVIVentaF
Clave=MAVIFechaTermina
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[MAVIVentaF.MAVIAbono]
Carpeta=MAVIVentaF
Clave=MAVIAbono
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[MAVIVentaF.MAVIFechaUltimoA]
Carpeta=MAVIVentaF
Clave=MAVIFechaUltimoA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[MAVIVentaF.MaviVentaTotal]
Carpeta=MAVIVentaF
Clave=MaviVentaTotal
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=20
[MAVIVentaF.MAVIDiasInactividad]
Carpeta=MAVIVentaF
Clave=MAVIDiasInactividad
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=20
[MAVIVentaF.MAVISaldoCapital]
Carpeta=MAVIVentaF
Clave=MAVISaldoCapital
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[MAVIVentaF.MAVI%TiempoDevengado]
Carpeta=MAVIVentaF
Clave=MAVI%TiempoDevengado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=8
[MAVIVentaF.MAVI%PorcTiempoPagado]
Carpeta=MAVIVentaF
Clave=MAVI%PorcTiempoPagado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=8
[MAVIVentaF.MAVI%AtrasoAdelanto]
Carpeta=MAVIVentaF
Clave=MAVI%AtrasoAdelanto
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=N
[MAVIVentaF.MAVI%TiempoUtilPagar]
Carpeta=MAVIVentaF
Clave=MAVI%TiempoUtilPagar
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=8
ColorFondo=Blanco
ColorFuente=Negro
[MAVIVentaF.MAVIImpAtrasoAdelanto]
Carpeta=MAVIVentaF
Clave=MAVIImpAtrasoAdelanto
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[MAVIVentaF.MAVI%PromGeneralAbono]
Carpeta=MAVIVentaF
Clave=MAVI%PromGeneralAbono
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[MAVIVentaF.MAVIPromAbono4UltMeses]
Carpeta=MAVIVentaF
Clave=MAVIPromAbono4UltMeses
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[MAVIVentaF.MAVICapPagoPromGeneral]
Carpeta=MAVIVentaF
Clave=MAVICapPagoPromGeneral
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[MAVIVentaF.MAVICapPagoProm4UltMeses]
Carpeta=MAVIVentaF
Clave=MAVICapPagoProm4UltMeses
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[MAVIVentaF.MAVINotaCredCancDev]
Carpeta=MAVIVentaF
Clave=MAVINotaCredCancDev
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=20
[MAVIVentaF.MAVINotaCredBoniAbon]
Carpeta=MAVIVentaF
Clave=MAVINotaCredBoniAbon
Editar=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=20
[MAVIVentaF.MAVINotaCredAdjudicaciones]
Carpeta=MAVIVentaF
Clave=MAVINotaCredAdjudicaciones
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=20
[MAVIVentaF.MAVIMesesDevengados]
Carpeta=MAVIVentaF
Clave=MAVIMesesDevengados
Editar=S
3D=S
Pegado=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=5

ValidaNombre=S
[MAVIVentaF.MAVIMesesUtilPagar]
Carpeta=MAVIVentaF
Clave=MAVIMesesUtilPagar
Editar=S
3D=S
Pegado=S
Tamano=5
ColorFondo=Blanco
ColorFuente=Negro
ValidaNombre=S
[MAVIVentaF.Cxc.FechaEmision]
Carpeta=MAVIVentaF
Clave=Cxc.FechaEmision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro






Tamano=20
[MAVIVentaF.MAVIMesesPagados]
Carpeta=MAVIVentaF
Clave=MAVIMesesPagados
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro









Tamano=5


Pegado=S

















[MAVIVentaF.MAVIPlazo]
Carpeta=MAVIVentaF
Clave=MAVIPlazo
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

Pegado=N






[MAVIVentaF.ListaEnCaptura]
(Inicio)=MAVIFactura
MAVIFactura=MAVICliente
MAVICliente=Cxc.FechaEmision
Cxc.FechaEmision=MAVIPlazo
MAVIPlazo=MAVIFecha1Abono
MAVIFecha1Abono=MaviVentaTotal
MaviVentaTotal=MAVIFechaTermina
MAVIFechaTermina=MAVIAbono
MAVIAbono=MAVIFechaUltimoA
MAVIFechaUltimoA=MAVIImporteUA
MAVIImporteUA=MAVIDiasVencidos
MAVIDiasVencidos=MAVIHMaxDiasV
MAVIHMaxDiasV=MAVIDiasInactividad
MAVIDiasInactividad=MAVIHMaxDiasI
MAVIHMaxDiasI=MAVIMaxDiasV
MAVIMaxDiasV=MAVIMaxDiasI
MAVIMaxDiasI=MAVI%TiempoDevengado
MAVI%TiempoDevengado=MAVIMesesDevengados
MAVIMesesDevengados=MAVISaldoCapital
MAVISaldoCapital=MAVI%PorcTiempoPagado
MAVI%PorcTiempoPagado=MAVIMesesPagados
MAVIMesesPagados=MAVI%AtrasoAdelanto
MAVI%AtrasoAdelanto=MAVI%TiempoUtilPagar
MAVI%TiempoUtilPagar=MAVIMesesUtilPagar
MAVIMesesUtilPagar=MAVIImpAtrasoAdelanto
MAVIImpAtrasoAdelanto=MAVI%PromGeneralAbono
MAVI%PromGeneralAbono=MAVICapPagoPromGeneral
MAVICapPagoPromGeneral=MAVIPromAbono4UltMeses
MAVIPromAbono4UltMeses=MAVICapPagoProm4UltMeses
MAVICapPagoProm4UltMeses=MAVINotaCredCancDev
MAVINotaCredCancDev=MAVINotaCredBoniAbon
MAVINotaCredBoniAbon=MAVINotaCredAdjudicaciones
MAVINotaCredAdjudicaciones=(Fin)

