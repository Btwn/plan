[Forma]
Clave=DM0266ListaCalendariosModificar
Nombre=Calendarios para Modificar
Icono=0
Modulos=(Todos)
ListaCarpetas=ListarModificar
CarpetaPrincipal=ListarModificar
PosicionInicialAlturaCliente=434
PosicionInicialAncho=295
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Dise�o
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=947
PosicionInicialArriba=297
ExpresionesAlMostrar=Asigna(Mavi.DM0266seleccionCalendario,<T><T>)
[ListarModificar]
Estilo=Iconos
Clave=ListarModificar
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0266Calendario
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
IconosSubTitulo=Calendarios Disponibles
ListaEnCaptura=Titulo
[ListarModificar.Titulo]
Carpeta=ListarModificar
Clave=Titulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=200
ColorFondo=Blanco
ColorFuente=Negro
[ListarModificar.Columnas]
0=178
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=Seleccionar Calendario
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asigna<BR>Seleccionar<BR>AbrirForma<BR>Cerrar
[Acciones.Seleccionar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.DM0266seleccionCalendario,DM0266Calendario:Titulo)
[Acciones.Seleccionar.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
[Acciones.Seleccionar.AbrirForma]
Nombre=AbrirForma
Boton=0
TipoAccion=Formas
ClaveAccion=DM0266ModificarCalendario
Activo=S
Visible=S
[Acciones.Seleccionar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

