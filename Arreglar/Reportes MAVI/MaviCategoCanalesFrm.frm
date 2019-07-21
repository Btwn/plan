[Forma]
Clave=MaviCategoCanalesFrm
Nombre=Categoría de Canales de Venta
Icono=0
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialIzquierda=504
PosicionInicialArriba=278
PosicionInicialAlturaCliente=172
PosicionInicialAncho=352
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
ExpresionesAlMostrar=si vacio(Mavi.UenNum)<BR>entonces<BR>sI(precaucion(<T>Debe seleccionar una UEN<T>, BotonAceptar)=BotonAceptar,AbortarOperacion,AbortarOperacion)<BR>Fin

[Lista]
Estilo=Hoja
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=MaviCategoCanalesVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
ListaEnCaptura=Categoria

[Lista.Columnas]
Canal_de_Venta=196
Categoria=304

[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
BtnResaltado=S
GuardarAntes=S
RefrescarDespues=S
Multiple=S
ListaAccionesMultiples=seleccion<BR>asigna


[Acciones.Seleccionar.Sel]
Nombre=Sel
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S

[Acciones.Seleccionar.Cierra]
Nombre=Cierra
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
[Lista.Categoria]
Carpeta=Lista
Clave=Categoria
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Seleccionar.seleccion]
Nombre=seleccion
Boton=0
TipoAccion=ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
[Acciones.Seleccionar.asigna]
Nombre=asigna
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=Asigna( Mavi.CategoCanalesVenta,MaviCategoCanalesVis:Categoria )

