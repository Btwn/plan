[Forma]
Clave=MaviOrdenXProveedorFrm
Nombre=Ordenes de Compra X Proveedor
Icono=0
CarpetaPrincipal=Ordenes
Modulos=(Todos)
ListaCarpetas=Ordenes
PosicionInicialAlturaCliente=273
PosicionInicialAncho=312
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=484
PosicionInicialArriba=358
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar<BR>Cerrar
[Ordenes]
Estilo=Iconos
Clave=Ordenes
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=MaviOrdenesXProveedorVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Proveedor<BR>Mov
CarpetaVisible=S
IconosConRejilla=S
IconosSeleccionMultiple=S
IconosSubTitulo=Orden
MenuLocal=S
ListaAcciones=all<BR>Quitar
IconosNombre=MaviOrdenesXProveedorVis:Movid
[Ordenes.Proveedor]
Carpeta=Ordenes
Clave=Proveedor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Ordenes.Columnas]
0=64
1=-2
2=109
3=-2
[Acciones.Seleccionar.Registrar]
Nombre=Registrar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion (<T>Ordenes<T>)
[Acciones.Seleccionar.Sel]
Nombre=Sel
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+ <T> ,2<T>)
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=7
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Registrar<BR>Sel
Activo=S
Visible=S
NombreEnBoton=S
NombreDesplegar=&Seleccionar
GuardarAntes=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Ordenes.Mov]
Carpeta=Ordenes
Clave=Mov
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.all]
Nombre=all
Boton=0
NombreDesplegar=Seleccionar &Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.Quitar]
Nombre=Quitar
Boton=0
NombreDesplegar=&Quitar Selección
EnMenu=S
TipoAccion=controles Captura
ClaveAccion=quitar Seleccion
Activo=S
Visible=S

