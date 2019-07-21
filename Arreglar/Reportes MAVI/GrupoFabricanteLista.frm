[Forma]
Clave=GrupoFabricanteLista
Nombre=Grupo de Fabricante
Icono=0
Modulos=INV
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=Lista
PosicionInicialIzquierda=421
PosicionInicialArriba=243
PosicionInicialAltura=366
PosicionInicialAncho=310
CarpetaPrincipal=Lista
ListaAcciones=Seleccionar
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=Centrado
ExpresionesAlMostrar=
ExpresionesAlCerrar=
BarraHerramientas=S
VentanaBloquearAjuste=N
PosicionInicialAlturaCliente=339

[Fabricante.Columnas]
Fabricante=109
Nombre=304

[Detalle.Fabricante.Fabricante]
Carpeta=Detalle
Clave=Fabricante.Fabricante
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=33

[Detalle.Fabricante.Telefonos]
Carpeta=Detalle
Clave=Fabricante.Telefonos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=33

[Detalle.Fabricante.DirInternet]
Carpeta=Detalle
Clave=Fabricante.DirInternet
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=33

[Detalle.Fabricante.Notas]
Carpeta=Detalle
Clave=Fabricante.Notas
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=33x12

[Lista]
Estilo=Hoja
PestanaNombre=Lista
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=GrupoFabricante
Fuente={MS Sans Serif, 8, Negro, []}
HojaMostrarRenglones=S
HojaAjustarColumnas=S
HojaColoresPorEstatus=S
HojaMantenerSeleccion=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=grupo
CarpetaVisible=S


[Lista.Columnas]
Fabricante=282
Nombre=316
grupo=304

[Acciones.Editar]
Nombre=Editar
Boton=0
Icono=0
NombreDesplegar=&Editar
EnBarraAcciones=Si
Carpeta=Detalle
TipoAccion=Controles Captura
ClaveAccion=Ir a la Carpeta
Expresion=
SQL=
ListaParametros=Si
VisibleCondicion=FormaNormal
Activo=Si
ActivoCondicion=
EjecucionCondicion=
EjecucionMensaje=
AntesExpresiones=

[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
[Lista.grupo]
Carpeta=Lista
Clave=grupo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
