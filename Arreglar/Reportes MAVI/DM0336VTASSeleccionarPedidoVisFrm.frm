
[Forma]
Clave=DM0336VTASSeleccionarPedidoVisFrm
Icono=64
Modulos=(Todos)


ListaCarpetas=Pedido
CarpetaPrincipal=Pedido
PosicionInicialIzquierda=401
PosicionInicialArriba=355
PosicionInicialAlturaCliente=228
PosicionInicialAncho=395
Nombre=<T>Seleccionar Pedido A Cancelar<T>
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar



[FacturaCancelar.Columnas]
NumeroPedido=166
NumeroDeFactura=165

[Acciones.Seleccionar.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar
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
ListaAccionesMultiples=Seleccionar<BR>Expresion<BR>Cerrar<BR>CancelarPedido
Activo=S
Visible=S




[Factura.Columnas]
NumeroPedido=151
NumeroDeFactura=204



[Acciones.Seleccionar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Asigna(Mavi.DM0336MovId,DM0336VTASElegirPedidoVis:MovID)
[Pedido]
Estilo=Hoja
Clave=Pedido
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0336VTASElegirPedidoVis
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
ListaEnCaptura=NumeroPedido<BR>NumeroDeFactura
CarpetaVisible=S

[Pedido.NumeroPedido]
Carpeta=Pedido
Clave=NumeroPedido
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Pedido.NumeroDeFactura]
Carpeta=Pedido
Clave=NumeroDeFactura
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=41
ColorFondo=Blanco

[Pedido.Columnas]
NumeroPedido=162
NumeroDeFactura=192

[Acciones.Seleccionar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


[Acciones.Seleccionar.CancelarPedido]
Nombre=CancelarPedido
Boton=0
TipoAccion=Formas
ClaveAccion=DM0336VTASCancelarPedidosMagentoFrm
Activo=S
Visible=S
