
[Forma]
Clave=DM0336VTASCancelacionesServiCasaFrm
Icono=8
CarpetaPrincipal=Motivo
Modulos=(Todos)

ListaCarpetas=Motivo<BR>CampoMotivo
PosicionInicialAlturaCliente=232
PosicionInicialAncho=400
Nombre=<T>Motivo De Cancelacion Del Pedido<T>
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=483
PosicionInicialArriba=248
AccionesTamanoBoton=15x5
BarraAcciones=S
ListaAcciones=Aceptar<BR>Capturar<BR>AutoEjecutar
AccionesCentro=S


PosicionSec1=103
BarraHerramientas=S
VentanaSinIconosMarco=S
ExpresionesAlMostrar=Asigna(Mavi.DM0336MotivoCancelacion,)<BR>Asigna(Info.Menu,<T>(*) Campo Obligatorio<T>)<BR>Asigna(Info.Conteo,0)
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
ListaAccionesMultiples=Actualizar<BR>Cerrar
EjecucionCondicion=Forma.Accion(<T>Capturar<T>)<BR><BR>Si(Vacio(Mavi.DM0336MotivoCancelacion), Informacion(<T>Debe llenar el campo <Motivo De Cancelacion><T>) AbortarOperacion, Verdadero)<BR><BR>Si<BR>  SQL(<T>SELECT LEN(:tMotivo)<T>,Mavi.DM0336MotivoCancelacion) > 150<BR>Entonces<BR>  Informacion(<T>El campo <Motivo De Cancelacion> no debe exceder los 150 caracteres<T>)<BR>  AbortarOperacion<BR>Sino<BR>  Verdadero<BR>Fin
[Acciones.Capturar]
Nombre=Capturar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


[Acciones.Aceptar.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=EjecutarSQL(<T>SpVTASGestionarPedidosFacturasDeMagento :nAccion, :tNumeroDePedido, :tUsuario, :tObservaciones<T>,<BR>             4,Mavi.DM0336NumeroPedidoEcommerce,Usuario,Mavi.DM0336MotivoCancelacion)<BR><BR>Asigna(Mavi.DM0336NumeroPedidoEcommerce,)
[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

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
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
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



[AyudaCaptura.Columnas]
Motivo=478

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
Motivo=353



[CampoMotivo.Info.Menu]
Carpeta=CampoMotivo
Clave=Info.Menu
LineaNueva=S
Tamano=20
ColorFondo=Plata

[Acciones.AutoEjecutar]
Nombre=AutoEjecutar
Boton=0
Activo=S
EnBarraHerramientas=S
TipoAccion=Expresion
Antes=S
ConAutoEjecutar=S
RefrescarDespues=S
Expresion=Si<BR>  DM0336VTASMotivoCancelacionVis:Motivo <> <T>OTROS<T><BR>Entonces<BR>  Asigna(Mavi.DM0336MotivoCancelacion,DM0336VTASMotivoCancelacionVis:Motivo)<BR>Fin
AntesExpresiones=Si<BR>  DM0336VTASMotivoCancelacionVis:Motivo <> <T>OTROS<T><BR>Entonces<BR>  Asigna(Info.Conteo,0)<BR>  Verdadero<BR>Sino<BR>  Si<BR>    Info.Conteo = 0<BR>  Entonces<BR>    Asigna(Mavi.DM0336MotivoCancelacion,)<BR>    Asigna(Info.Conteo,1)<BR>    AbortarOperacion<BR>  Fin<BR>Fin
AutoEjecutarExpresion=1


