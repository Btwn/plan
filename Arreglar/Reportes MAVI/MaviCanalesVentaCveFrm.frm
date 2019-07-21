[Forma]
Clave=MaviCanalesVentaCveFrm
Nombre=Canales de Venta
Icono=0
Modulos=(Todos)
ListaCarpetas=(Lista)
CarpetaPrincipal=(Lista)
PosicionInicialAlturaCliente=216
PosicionInicialAncho=315
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=361
PosicionInicialArriba=282
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
ExpresionesAlMostrar=si vacio(Mavi.CategoCanalesVenta)<BR>entonces<BR>sI(precaucion(<T>Debe seleccionar una Categoría<T>, BotonAceptar)=BotonAceptar,AbortarOperacion,AbortarOperacion)<BR>Fin

[(Vista).Columnas]
Canal=64
Clave=64
Cadena=304

[(Lista)]
Estilo=Hoja
Clave=(Lista)
PermiteLocalizar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=MaviCanalesVentaCveVis
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
ListaEnCaptura=Canal<BR>Clave<BR>Cadena
CarpetaVisible=S
ValidarCampos=S

[(Lista).Cadena]
Carpeta=(Lista)
Clave=Cadena
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

[(Lista).Columnas]
Cadena=175
Canal=35
Clave=72

[(Lista).Canal]
Carpeta=(Lista)
Clave=Canal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[(Lista).Clave]
Carpeta=(Lista)
Clave=Clave
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
GuardarAntes=S
RefrescarDespues=S
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S

