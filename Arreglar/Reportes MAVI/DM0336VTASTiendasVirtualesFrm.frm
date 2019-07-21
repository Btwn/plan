
[Forma]
Clave=DM0336VTASTiendasVirtualesFrm
Icono=94
Modulos=(Todos)




ListaCarpetas=Principal<BR>Detalle<BR>Agrupado
CarpetaPrincipal=Principal
PosicionInicialAlturaCliente=961
PosicionInicialAncho=1296
PosicionInicialIzquierda=-8
PosicionInicialArriba=-8
Nombre=<T>Ventas Tiendas Virtuales<T>
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Actualizar<BR>Excel<BR>Cerrar<BR>Capturar<BR>Filtrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Maximizado
PosicionSec1=38
ExpresionesAlMostrar=Asigna(Mavi.DM0336Pedido,)<BR>Asigna(Mavi.DM0336TipoDeReporte,)
[Principal]
Estilo=Ficha
Clave=Principal
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
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
ListaEnCaptura=Info.FechaD<BR>Info.FechaA<BR>Mavi.DM0336Pedido<BR>Mavi.DM0336TipoDeReporte
CarpetaVisible=S

[Principal.Info.FechaD]
Carpeta=Principal
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

AccionAlEnter=
[Principal.Info.FechaA]
Carpeta=Principal
Clave=Info.FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

AccionAlEnter=
[Principal.Mavi.DM0336Pedido]
Carpeta=Principal
Clave=Mavi.DM0336Pedido
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

AccionAlEnter=
[Acciones.Actualizar]
Nombre=Actualizar
Boton=125
NombreEnBoton=S
NombreDesplegar=Actualizar
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Capturar<BR>ActualizarForma
ConCondicion=S
EjecucionCondicion=Forma.Accion(<T>Capturar<T>)<BR>Si(ConDatos(Info.FechaD),verdadero,informacion(<T>Debe llenar el campo <De La Fecha><T>) AbortarOperacion)<BR>Si(ConDatos(Info.FechaA),verdadero,informacion(<T>Debe llenar el campo <A La Fecha><T>) AbortarOperacion)<BR><BR>Si<BR>  (SQL(<T>SELECT DATEDIFF(dd,:fInicio,:fFin)<T>,Info.FechaD,Info.FechaA)) >= 0<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  Informacion(<T>El campo <De La Fecha> debe tener una fecha menor que el campo <A La Fecha><T>)<BR>  AbortarOperacion<BR>Fin                                                                         
[Acciones.Excel]
Nombre=Excel
Boton=115
NombreEnBoton=S
NombreDesplegar=Enviar A Excel
EnBarraHerramientas=S
Activo=S
Visible=S
EspacioPrevio=S

TipoAccion=Expresion
ConCondicion=S
Expresion=Si<BR>  Mavi.DM0336TipoDeReporte = <T>Detalle<T><BR>Entonces<BR>   ReporteExcel(<T>DM0336VTASReporteTVDetalleRepXls<T>)<BR>Sino<BR>   ReporteExcel(<T>DM0336VTASReporteTVAgrupadoRepXls<T>)<BR>Fin
EjecucionCondicion=Forma.Accion(<T>Capturar<T>)<BR>Si(ConDatos(Mavi.DM0336TipoDeReporte),verdadero,informacion(<T>Debe llenar el campo <Tipo De Reporte><T>) AbortarOperacion)<BR>Si(ConDatos(Info.FechaD),verdadero,informacion(<T>Debe llenar el campo <De La Fecha><T>) AbortarOperacion)<BR>Si(ConDatos(Info.FechaA),verdadero,informacion(<T>Debe llenar el campo <A La Fecha><T>) AbortarOperacion)<BR><BR>Si<BR>  (SQL(<T>SELECT DATEDIFF(dd,:fInicio,:fFin)<T>,Info.FechaD,Info.FechaA)) >= 0<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  Informacion(<T>El campo <De La Fecha> debe tener una fecha menor que el campo <A La Fecha><T>)<BR>  AbortarOperacion<BR>Fin                                                   

[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Detalle]
Estilo=Hoja
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Detalle
Clave=Detalle
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=DM0336VTASTiendasVirtualesDetalleVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=idecommerce<BR>FechaRequerida<BR>Mov<BR>MovID<BR>Articulo<BR>descripcion1<BR>Cantidad<BR>Precio<BR>PrecioTotal<BR>OrigenSucursal<BR>SucursalDestino<BR>Estatuspedido<BR>FormaCobro<BR>FacturaVenta<BR>estatusfactura<BR>Embarque<BR>EstadoEmbarque<BR>Vehiculo<BR>Descripcion<BR>devolucion<BR>articulodevuelto<BR>cantidaddevuelta<BR>importedevuelto<BR>Paqueteria<BR>Estatusenvio<BR>GuiaEstafeta
CarpetaVisible=S

HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaAjustarColumnas=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
[Detalle.idecommerce]
Carpeta=Detalle
Clave=idecommerce
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=0
ColorFondo=Blanco
























[Detalle.Columnas]
idecommerce=138
FechaRequerida=139
Mov=74
MovID=86
Articulo=85
descripcion1=448
Cantidad=51
Precio=64
PrecioTotal=64
OrigenSucursal=82
SucursalDestino=92
Estatuspedido=94
FormaCobro=255
FacturaVenta=262
estatusfactura=94
Embarque=262
EstadoEmbarque=174
Vehiculo=172
Devolucion=124
articulodevuelto=124
cantidaddevuelta=97
importedevuelto=100
Paqueteria=56
Estatusenvio=72

Descripcion=180
GuiaEstafeta=184
[Acciones.Actualizar.Capturar]
Nombre=Capturar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Actualizar.ActualizarForma]
Nombre=ActualizarForma
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=ActualizarVista(<T>DM0336VTASTiendasVirtualesDetalleVis<T>)<BR>ActualizarForma


[Agrupado]
Estilo=Hoja
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Agrupado
Clave=Agrupado
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=DM0336VTASTiendasVirtualesAgrupadoVis
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
ListaEnCaptura=idecommerce<BR>FechaRequerida<BR>Mov<BR>MovID<BR>Cantidad<BR>Importetotal<BR>OrigenSucursal<BR>SucursalDestino<BR>Estatuspedido<BR>FormaCobro<BR>FacturaVenta<BR>estatusfactura<BR>Embarque<BR>EstadoEmbarque<BR>Vehiculo<BR>Descripcion<BR>devolucion<BR>cantidaddevuelta<BR>importedevuelto<BR>Paqueteria<BR>Estatusenvio<BR>GuiaEstafeta
CarpetaVisible=S

HojaAjustarColumnas=S
[Agrupado.idecommerce]
Carpeta=Agrupado
Clave=idecommerce
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Agrupado.FechaRequerida]
Carpeta=Agrupado
Clave=FechaRequerida
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Agrupado.Mov]
Carpeta=Agrupado
Clave=Mov
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Agrupado.MovID]
Carpeta=Agrupado
Clave=MovID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Agrupado.Cantidad]
Carpeta=Agrupado
Clave=Cantidad
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Agrupado.Importetotal]
Carpeta=Agrupado
Clave=Importetotal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Agrupado.OrigenSucursal]
Carpeta=Agrupado
Clave=OrigenSucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Agrupado.SucursalDestino]
Carpeta=Agrupado
Clave=SucursalDestino
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Agrupado.Estatuspedido]
Carpeta=Agrupado
Clave=Estatuspedido
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Agrupado.FormaCobro]
Carpeta=Agrupado
Clave=FormaCobro
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Agrupado.FacturaVenta]
Carpeta=Agrupado
Clave=FacturaVenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=43
ColorFondo=Blanco

[Agrupado.Columnas]
idecommerce=139
FechaRequerida=149
Mov=124
MovID=124
Cantidad=64
Importetotal=64
OrigenSucursal=76
SucursalDestino=80
Estatuspedido=94
FormaCobro=176
FacturaVenta=262

estatusfactura=94
Embarque=262
EstadoEmbarque=304
Vehiculo=64
Descripcion=132
Devolucion=124
cantidaddevuelta=87
importedevuelto=82
Paqueteria=56
Estatusenvio=66
GuiaEstafeta=184
[Principal.Mavi.DM0336TipoDeReporte]
Carpeta=Principal
Clave=Mavi.DM0336TipoDeReporte
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.Capturar]
Nombre=Capturar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Detalle.FechaRequerida]
Carpeta=Detalle
Clave=FechaRequerida
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Detalle.Mov]
Carpeta=Detalle
Clave=Mov
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Detalle.MovID]
Carpeta=Detalle
Clave=MovID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Detalle.Articulo]
Carpeta=Detalle
Clave=Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Detalle.descripcion1]
Carpeta=Detalle
Clave=descripcion1
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco

[Detalle.Cantidad]
Carpeta=Detalle
Clave=Cantidad
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Detalle.Precio]
Carpeta=Detalle
Clave=Precio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Detalle.PrecioTotal]
Carpeta=Detalle
Clave=PrecioTotal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Detalle.OrigenSucursal]
Carpeta=Detalle
Clave=OrigenSucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Detalle.SucursalDestino]
Carpeta=Detalle
Clave=SucursalDestino
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Detalle.Estatuspedido]
Carpeta=Detalle
Clave=Estatuspedido
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Detalle.FormaCobro]
Carpeta=Detalle
Clave=FormaCobro
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Detalle.FacturaVenta]
Carpeta=Detalle
Clave=FacturaVenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=43
ColorFondo=Blanco

[Detalle.estatusfactura]
Carpeta=Detalle
Clave=estatusfactura
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Detalle.Embarque]
Carpeta=Detalle
Clave=Embarque
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=43
ColorFondo=Blanco

[Detalle.EstadoEmbarque]
Carpeta=Detalle
Clave=EstadoEmbarque
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Detalle.Vehiculo]
Carpeta=Detalle
Clave=Vehiculo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco

[Detalle.Descripcion]
Carpeta=Detalle
Clave=Descripcion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco

[Detalle.devolucion]
Carpeta=Detalle
Clave=devolucion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=43
ColorFondo=Blanco

[Detalle.articulodevuelto]
Carpeta=Detalle
Clave=articulodevuelto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Detalle.cantidaddevuelta]
Carpeta=Detalle
Clave=cantidaddevuelta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Detalle.importedevuelto]
Carpeta=Detalle
Clave=importedevuelto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Detalle.Paqueteria]
Carpeta=Detalle
Clave=Paqueteria
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=8
ColorFondo=Blanco

[Detalle.Estatusenvio]
Carpeta=Detalle
Clave=Estatusenvio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=1
ColorFondo=Blanco

[Agrupado.estatusfactura]
Carpeta=Agrupado
Clave=estatusfactura
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Agrupado.Embarque]
Carpeta=Agrupado
Clave=Embarque
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=43
ColorFondo=Blanco

[Agrupado.EstadoEmbarque]
Carpeta=Agrupado
Clave=EstadoEmbarque
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Agrupado.Vehiculo]
Carpeta=Agrupado
Clave=Vehiculo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco

[Agrupado.Descripcion]
Carpeta=Agrupado
Clave=Descripcion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco

[Agrupado.devolucion]
Carpeta=Agrupado
Clave=devolucion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=43
ColorFondo=Blanco

[Agrupado.cantidaddevuelta]
Carpeta=Agrupado
Clave=cantidaddevuelta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Agrupado.importedevuelto]
Carpeta=Agrupado
Clave=importedevuelto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Agrupado.Paqueteria]
Carpeta=Agrupado
Clave=Paqueteria
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=8
ColorFondo=Blanco

[Agrupado.Estatusenvio]
Carpeta=Agrupado
Clave=Estatusenvio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=1
ColorFondo=Blanco

[Acciones.Filtrar]
Nombre=Filtrar
Boton=107
NombreEnBoton=S
NombreDesplegar=Filtrar
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
EspacioPrevio=S

ConCondicion=S

Expresion=Forma.Accion(<T>Actualizar<T>)
EjecucionCondicion=Forma.Accion(<T>Capturar<T>)<BR>Si(ConDatos(Info.FechaD),verdadero,informacion(<T>Debe llenar el campo <De La Fecha><T>) AbortarOperacion)<BR>Si(ConDatos(Info.FechaA),verdadero,informacion(<T>Debe llenar el campo <A La Fecha><T>) AbortarOperacion)<BR><BR>Si<BR>  (SQL(<T>SELECT DATEDIFF(dd,:fInicio,:fFin)<T>,Info.FechaD,Info.FechaA)) >= 0<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  Informacion(<T>El campo <De La Fecha> debe tener una fecha menor que el campo <A La Fecha><T>)<BR>  AbortarOperacion<BR>Fin

[Detalle.GuiaEstafeta]
Carpeta=Detalle
Clave=GuiaEstafeta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco

[Agrupado.GuiaEstafeta]
Carpeta=Agrupado
Clave=GuiaEstafeta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco

