[Forma]
Clave=DM0269DestinosEntregaFrm
Icono=0
ListaCarpetas=Poblacion entrega
CarpetaPrincipal=Poblacion entrega
PosicionInicialIzquierda=446
PosicionInicialAlturaCliente=327
PosicionInicialAncho=375
PosicionInicialArriba=283
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar Cambios
ExpresionesAlMostrar=EjecutarSQL(<T>EXEC SP_MaviDM0269OrdenadorRutaReparto :tEstatus, :tTipoEmbarque, :tFecha, :tVehiculo, :tRuta, :tID, :tBandera  <T>,<BR>Mavi.Rm0229EstatusRutaEmb, Mavi.RM0229EmbMovTipo, FechaAMD(Info.Fecha),Mavi.RM0229Vehiculos,Mavi.Rm0229RutaDestinos,Mavi.RM0229IdRuta,<T>Destinos<T>)
[Poblacion entrega]
Estilo=Hoja
Clave=Poblacion entrega
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0269DestinosEntregaVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=DM0269DestinosEntregaTbl.PoblacionEntrega<BR>DM0269DestinosEntregaTbl.OrdenEntrega
PermiteEditar=S
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
[Poblacion entrega.Columnas]
PoblacionEntrega=253
OrdenEntrega=72
[Acciones.Guardar Cambios]
Nombre=Guardar Cambios
Boton=23
NombreDesplegar=Aceptar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S
Multiple=S
ListaAccionesMultiples=guardar<BR>Variables Asignar<BR>Seleccionar/Aceptar
[Acciones.Guardar Cambios.guardar]
Nombre=guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Guardar Cambios.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Guardar Cambios.Seleccionar/Aceptar]
Nombre=Seleccionar/Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Aceptar
Activo=S
Visible=S
[Poblacion entrega.DM0269DestinosEntregaTbl.PoblacionEntrega]
Carpeta=Poblacion entrega
Clave=DM0269DestinosEntregaTbl.PoblacionEntrega
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=50
[Poblacion entrega.DM0269DestinosEntregaTbl.OrdenEntrega]
Carpeta=Poblacion entrega
Clave=DM0269DestinosEntregaTbl.OrdenEntrega
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

