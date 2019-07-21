[Forma]
Clave=RM1160CategoriaFiltroFrm
Nombre=Categoria Filtro
Icono=622
Modulos=(Todos)
ListaCarpetas=Categoria Filtro
CarpetaPrincipal=Categoria Filtro
PosicionInicialIzquierda=678
PosicionInicialArriba=214
PosicionInicialAlturaCliente=267
PosicionInicialAncho=277
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
EsConsultaExclusiva=S
ListaAcciones=Seleccionar<BR>Cancelar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
VentanaBloquearAjuste=S
[Categoria Filtro]
Estilo=Iconos
Clave=Categoria Filtro
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1160CategoriaFiltroVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
ListaEnCaptura=Categoria
[Categoria Filtro .Categoria]
Carpeta=Categoria Filtro 
Clave=Categoria
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Categoria Filtro.Columnas]
Categoria=304
0=185
[Categoria Filtro.]
Carpeta=Categoria Filtro
ColorFondo=Negro
[Categoria Filtro.Categoria]
Carpeta=Categoria Filtro
Clave=Categoria
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
[Acciones.Seleccionar.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=asigna<BR>regis<BR>Selec
Activo=S
Visible=S
NombreEnBoton=S
[Acciones.Seleccionar.regis]
Nombre=regis
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Categoria<T>)
Activo=S
Visible=S
[Acciones.Seleccionar.Selec]
Nombre=Selec
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(Mavi.RM1160Categoria,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,2<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,2<T>)
[Acciones.Cancelar]
Nombre=Cancelar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cancelar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cancelar
Activo=S
Visible=S

