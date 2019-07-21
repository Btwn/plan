[Forma]
Clave=ArtAlmsoloCategoriasfrm
Nombre=Categorias en Instituciones
Icono=0
Modulos=(Todos)
ListaCarpetas=ArtAlmsoloCategoriasvis
CarpetaPrincipal=ArtAlmsoloCategoriasvis
PosicionInicialIzquierda=572
PosicionInicialArriba=46
PosicionInicialAlturaCliente=278
PosicionInicialAncho=206
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
[ArtAlmsoloCategoriasvis]
Estilo=Iconos
Pestana=S
Clave=ArtAlmsoloCategoriasvis
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=ArtAlmsoloCategoriasvis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
ListaEnCaptura=Sucursal
IconosConRejilla=S
IconosSeleccionMultiple=S
PestanaOtroNombre=S
PestanaNombre=Sucursales  Instituciones
[ArtAlmsoloCategoriasvis.Columnas]
0=171
1=-2
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar y eliminar
EnBarraHerramientas=S
TipoAccion=expresion
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Selec<BR>Regis<BR>Asig<BR>Acciones<BR>Cerrar
[Acciones.Seleccionar.Selec]
Nombre=Selec
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccionar.Regis]
Nombre=Regis
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Vista<T>)
[Acciones.Seleccionar.Asig]
Nombre=Asig
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(Mavi.ArtAlmCategorias,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T> + EstacionTrabajo + <T>, 2<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T> + EstacionTrabajo + <T>, 2<T>)
[Acciones.Seleccionar.Acciones]
Nombre=Acciones
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=Si<BR>    ConDatos(Mavi.ArtAlmCategorias)<BR>Entonces<BR>    EjecutarSQL(<T>Exec SP_MAVIDM0136EliminaAlmacenesXCategorias :tVal1, :tVal2, :tVal3<T>, Empresa, Info.Articulo,Mavi.ArtAlmCategorias)<BR><BR>Fin
[Acciones.Seleccionar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[ArtAlmsoloCategoriasvis.Sucursal]
Carpeta=ArtAlmsoloCategoriasvis
Clave=Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

