[Forma]
Clave=RM0771ArtXOrdenXProveedorFrm
Nombre=Articulos de la  Orden
Icono=0
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=Articulos
CarpetaPrincipal=Articulos
PosicionInicialAlturaCliente=273
PosicionInicialAncho=555
ListaAcciones=sel<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=362
PosicionInicialArriba=356
[Articulos]
Estilo=Iconos
Clave=Articulos
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0771ArtXOrdenXProveedorVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosConRejilla=S
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
IconosSubTitulo=Articulos
MenuLocal=S
ListaAcciones=all<BR>quitar
IconosNombre=RM0771ArtXOrdenXProveedorVis:Articulo
[Articulos.Columnas]
0=-2
1=347
2=-2
3=306
[Acciones.sel.Reg]
Nombre=Reg
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Articulos<T>)
Activo=S
Visible=S
[Acciones.sel.Sel]
Nombre=Sel
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=SQL(<T>EXEC SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,2<T>)
[Acciones.sel]
Nombre=sel
Boton=7
NombreEnBoton=S
NombreDesplegar=&Seleccionar
GuardarAntes=S
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Reg<BR>Sel
Activo=S
Visible=S
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
[Acciones.all]
Nombre=all
Boton=0
NombreDesplegar=Seleccionar &Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.quitar]
Nombre=quitar
Boton=0
NombreDesplegar=&Quitar Selección
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

