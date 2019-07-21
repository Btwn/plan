[Forma]
Clave=MaviArtLBFRM
Nombre=Articulos por Proveedor de Linea Blanca
Icono=152
Modulos=(Todos)
ListaCarpetas=Articulos
CarpetaPrincipal=Articulos
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Sel
PosicionInicialIzquierda=208
PosicionInicialArriba=136
PosicionInicialAlturaCliente=469
PosicionInicialAncho=607
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
VentanaEstadoInicial=Normal
[Acciones.SelAll]
Nombre=SelAll
Boton=0
NombreDesplegar=Seleccionar &Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.quitAl]
Nombre=quitAl
Boton=0
NombreDesplegar=&Quitar Seleccion 
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[Articulos]
Estilo=Iconos
Clave=Articulos
MenuLocal=S
RefrescarAlEntrar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=MaviArtLBVIS
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=Linea
ElementosPorPagina=200
IconosConRejilla=S
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Categoria<BR>Grupo<BR>Familia
ListaAcciones=SelAll<BR>quitAl
CarpetaVisible=S
PestanaOtroNombre=S
PestanaNombre=Lineas
IconosNombre=MaviArtLBVIS:Linea
[Acciones.Sel.ASIG]
Nombre=ASIG
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Sel.Reg]
Nombre=Reg
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Articulos<T>)
Activo=S
Visible=S
[Acciones.Sel.sel]
Nombre=sel
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,2<T>)
Activo=S
Visible=S
[Acciones.Sel]
Nombre=Sel
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=ASIG<BR>Reg<BR>sel
Activo=S
Visible=S
[Articulos.Columnas]
0=171
1=107
2=138
3=174
[Articulos.Categoria]
Carpeta=Articulos
Clave=Categoria
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Articulos.Grupo]
Carpeta=Articulos
Clave=Grupo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Articulos.Familia]
Carpeta=Articulos
Clave=Familia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

