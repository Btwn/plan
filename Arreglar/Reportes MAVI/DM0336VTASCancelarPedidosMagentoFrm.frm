
[Forma]
Clave=DM0336VTASCancelarPedidosMagentoFrm
Icono=484
Modulos=(Todos)
MovModulo=VTAS

ListaCarpetas=Motivo<BR>CampoMotivo
CarpetaPrincipal=Motivo
PosicionInicialIzquierda=421
PosicionInicialArriba=244
PosicionInicialAlturaCliente=240
PosicionInicialAncho=523
Nombre=<T>Cancelaciones De Pedidos<T>
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=Aceptar<BR>Capturar<BR>AutoEjecutar<BR>Inicializar
AccionesCentro=S
AccionesDivision=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaSinIconosMarco=S
PosicionSec1=106
PosicionSec2=173



BarraHerramientas=S
ExpresionesAlActivar=Forma.Accion(<T>Inicializar<T>)
[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreEnBoton=S
NombreDesplegar=Aceptar
EnBarraAcciones=S
Activo=S
Visible=S

ConCondicion=S
TipoAccion=Expresion

Multiple=S
ListaAccionesMultiples=Aceptar<BR>Cerrar
EjecucionCondicion=Forma.Accion(<T>Capturar<T>)<BR><BR>Si(ConDatos(Mavi.DM0336MotivoCancelacion),verdadero,Informacion(<T>Debe llenar el campo <Motivo De Cancelacion><T>) AbortarOperacion)<BR><BR>Si<BR>  SQL(<T>SELECT LEN(:tMotivo) AS LongitudCadena<T>,DM0336VTASMotivoCancelacionVis:Motivo) <= 150<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  Informacion(<T>El campo <Motivo De Cancelacion> no puede exceder los 150 caracteres<T>)<BR>  AbortarOperacion<BR>Fin
[Acciones.Capturar]
Nombre=Capturar
Boton=0
NombreDesplegar=Captura Datos
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S



[Acciones.Aceptar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S






Expresion=Si<BR>  SQL(<T>SELECT COUNT(ReferenciaOrdenCompra)<BR>       FROM Venta<BR>       WHERE ReferenciaOrdenCompra = :tReferencia<BR>       AND Mov = :tMovimiento<BR>       AND Estatus = :tEstatus<BR>       AND SucursalOrigen IN (41,90)<BR>       AND MovId = :tMovId<T>,<BR>       Mavi.DM0336NumeroPedidoEcommerce,<BR>       <T>Pedido<T>,<BR>       <T>PENDIENTE<T>,<BR>       Mavi.DM0336MovId)>0<BR><BR>Entonces<BR>  //Cancelar pedido en Intelisis<BR>  EjecutarSQL(<T>SpVTASGestionarPedidosFacturasDeMagento :nAccion, :tNumeroDePedido, :tUsuario, :tObservaciones<T>,<BR>              3,Mavi.DM0336NumeroPedidoEcommerce+<T>|<T>+Mavi.DM0336MovId,Usuario,Mavi.DM0336MotivoCancelacion)<BR><BR>  //Cancelar pedido en Magento<BR>  Ejecutar(<T>PlugIns\ActualizaEcommers.exe <T>+<T>VTASPEDIDO<T>+<T> <T>+ Mavi.DM0336NumeroPedidoEcommerce+<T> <T>+<T>CANCELADO<T>+<T> <T>+<T><T>+<T> <T>+<T><T>)<BR><BR>  Si<BR>    SQL(<T>SELECT COUNT(ReferenciaOrdenCompra)<BR>         FROM Venta<BR>         WHERE ReferenciaOrdenCompra = :tReferencia<BR>         AND Mov = :tMovimiento<BR>         AND Estatus = :tEstatus<BR>         AND SucursalOrigen IN (41,90)<BR>         AND MovId = :tMovId<T>,<BR>         Mavi.DM0336NumeroPedidoEcommerce,<BR>         <T>Pedido<T>,<BR>         <T>CANCELADO<T>,<BR>         Mavi.DM0336MovId)>0<BR>  Entonces<BR>    Informacion(<T>Pedido Cancelado Correctamente<T>)<BR>  Sino<BR>    Informacion(<T>No se pudo cancelar el pedido<T>)<BR>  Fin<BR><BR>Sino<BR>  Informacion(<T>No existe el pedido que desea cancelar<T>)<BR>Fin
[Motivo]
Estilo=Hoja
Clave=Motivo
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0336VTASMotivoCancelacionVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Motivo
CarpetaVisible=S

HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
[Motivo.Motivo]
Carpeta=Motivo
Clave=Motivo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=35
ColorFondo=Blanco

[Motivo.Columnas]
Motivo=475

[CampoMotivo]
Estilo=Ficha
Clave=CampoMotivo
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
ListaEnCaptura=Mavi.DM0336MotivoCancelacion<BR>Info.Menu



CondicionVisible=Si<BR>  Info.Conteo = 1<BR>Entonces<BR>  Verdadero<BR>Fin
[CampoMotivo.Mavi.DM0336MotivoCancelacion]
Carpeta=CampoMotivo
Clave=Mavi.DM0336MotivoCancelacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[CampoMotivo.Info.Menu]
Carpeta=CampoMotivo
Clave=Info.Menu
LineaNueva=S
Tamano=50
ColorFondo=Plata

[Acciones.AutoEjecutar]
Nombre=AutoEjecutar
Boton=0
TipoAccion=Expresion
Activo=S
ConAutoEjecutar=S
Antes=S

EnBarraHerramientas=S
RefrescarDespues=S
Expresion=Si<BR>  DM0336VTASMotivoCancelacionVis:Motivo <> <T>OTROS<T><BR>Entonces<BR>  Asigna(Mavi.DM0336MotivoCancelacion,DM0336VTASMotivoCancelacionVis:Motivo)<BR>Fin
AntesExpresiones=Si<BR>  DM0336VTASMotivoCancelacionVis:Motivo <> <T>OTROS<T><BR>Entonces<BR>  Asigna(Info.Conteo,0)<BR>  Verdadero<BR>Sino<BR>  Si<BR>    Info.Conteo = 0<BR>  Entonces<BR>    Asigna(Mavi.DM0336MotivoCancelacion,)<BR>    Asigna(Info.Conteo,1)<BR>    AbortarOperacion<BR>  Fin<BR>Fin
AutoEjecutarExpresion=1
[Acciones.Inicializar]
Nombre=Inicializar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S


Expresion=Asigna(Mavi.DM0336MotivoCancelacion,)<BR>Asigna(Info.Menu,<T>(*) Campo Obligatorio<T>)<BR>Asigna(Info.Mensaje,<T>Nota:  <Motivo De Cancelacion> debe usar cuando mucho 150 caracteres<T>) <BR>Asigna(Info.Conteo,0)

[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

