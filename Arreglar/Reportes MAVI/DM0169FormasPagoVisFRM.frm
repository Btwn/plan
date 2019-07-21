
[Forma]
Clave=DM0169FormasPagoVisFRM
Icono=86
Modulos=(Todos)
Nombre=Formas de Pago

ListaCarpetas=DM0169FormasPagoVis
CarpetaPrincipal=DM0169FormasPagoVis
PosicionInicialIzquierda=735
PosicionInicialArriba=313
PosicionInicialAlturaCliente=273
PosicionInicialAncho=368
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Eliminar
[DM0169FormasPagoVis]
Estilo=Hoja
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Formas de pago
Clave=DM0169FormasPagoVis
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0169FormasPagoVistaVis
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
ListaEnCaptura=FormaPago
CarpetaVisible=S

[DM0169FormasPagoVis.FormaPago]
Carpeta=DM0169FormasPagoVis
Clave=FormaPago
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[DM0169FormasPagoVis.Columnas]
FormaPago=304

[Acciones.Eliminar.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S

[Acciones.Eliminar.Elim]
Nombre=Elim
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S


Expresion=EjecutarSQL(<T>EXEC SpVTASEliminarRelacionCondicionTipoPago :tCondicion, :nFormaPago<T>,Info.Dialogo,DM0169FormasPagoVistaVis:IdFormaPago)<BR><BR><BR>//informacion(Info.Dialogo)<BR>//Informacion(DM0169FormasPagoVistaVis:IdFormaPago)
[Acciones.Eliminar]
Nombre=Eliminar
Boton=5
NombreDesplegar=Eliminar FormaPago
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Seleccionar<BR>Elim<BR>act
Activo=S
Visible=S
NombreEnBoton=S

[Acciones.Eliminar.act]
Nombre=act
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
