
[Forma]
Clave=DM0169VTASFormasPagoFrm
Icono=35
Modulos=(Todos)
Nombre=Formas de Pago

ListaCarpetas=Vista
CarpetaPrincipal=Vista
PosicionInicialIzquierda=732
PosicionInicialArriba=270
PosicionInicialAlturaCliente=352
PosicionInicialAncho=259
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
[Vista]
Estilo=Iconos
Clave=Vista
BusquedaRapidaControles=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0169FormaPagoVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosNombre=DM0169FormaPagoVis:IDFormaPago
IconosSubTitulo=<T>ID<T>
IconosSeleccionMultiple=S
ElementosPorPaginaEsp=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=FormaPago
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
CarpetaVisible=S

[Vista.FormaPago]
Carpeta=Vista
Clave=FormaPago
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Vista.Columnas]
0=-2
1=-2

[Acciones.Seleccionar.VariablesAsigna]
Nombre=VariablesAsigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Seleccionar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Vista<T>)
Activo=S
Visible=S

[Acciones.Seleccionar.Selecciones]
Nombre=Selecciones
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(Mavi.DM0169CondicionFormaPago,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,2<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,2<T>)<BR><BR>/*----------------------------------Aqui va el sp que se va a crear--------------------------------------*/<BR><BR>EjecutarSQL(<T>Exec SpVTASInsertaVTASDRelacionCondicionYTipoPago :tAR,:tEr<T>,<BR> {Si(ConDatos(Mavi.DM0169CondicionFormaPago),Reemplaza( Comillas(<T>,<T>), <T>,<T>, Mavi.DM0169CondicionFormaPago ),Comillas(<T><T>))},<BR> {Si(ConDatos(Info.Dialogo),Reemplaza( Comillas(<T>,<T>),<T>,<T>, Info.Dialogo ),Comillas(<T><T>))})
Activo=S
Visible=S

[Acciones.Seleccionar.Exito]
Nombre=Exito
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreDesplegar=Aceptar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=VariablesAsigna<BR>Expresion<BR>Selecciones<BR>Exito
Activo=S
Visible=S
NombreEnBoton=S
