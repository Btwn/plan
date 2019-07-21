[Forma]
Clave=ArtAlmInstitucionesCategoriafrm
Nombre=Categorias en Instituciones
Icono=0
Modulos=(Todos)
ListaCarpetas=ArtAlmInstitucionesCategoriavis
CarpetaPrincipal=ArtAlmInstitucionesCategoriavis
PosicionInicialIzquierda=673
PosicionInicialArriba=63
PosicionInicialAlturaCliente=284
PosicionInicialAncho=365
AccionesTamanoBoton=30x5
AccionesDerecha=S
BarraHerramientas=S
ListaAcciones=Guardar Cambios<BR>Eliminar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlCerrar=EjecutarSQL(<T>Exec SP_MAVIDM0136EliminaDatosdePaso :tVal1, :nVal2<T>, Usuario, EstacionTrabajo)
[ArtAlmInstitucionesCategoriavis]
Estilo=Hoja
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Sucursales Instituciones
Clave=ArtAlmInstitucionesCategoriavis
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=ArtAlmInstitucionesCategoriavis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=DM0136INVCategoriasInstitucionespasoTBL.Sucursal<BR>DM0136INVCategoriasInstitucionespasoTBL.Maximo
PermiteEditar=S
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroTipo=Ninguno
RefrescarAlEntrar=S
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaVistaOmision=Automática
HojaIndicador=S
HojaAjustarColumnas=S
FiltroGeneral=DM0136INVCategoriasInstitucionespasoTBL.Equipo = {EstacionTrabajo} and<BR>DM0136INVCategoriasInstitucionespasoTBL.Trabajador  = {comillas(Usuario)}
[ArtAlmInstitucionesCategoriavis.Columnas]
Categoria=179
Maximo=64
0=29
1=178
2=117
Sucursal=64
[Acciones.Guardar Cambios]
Nombre=Guardar Cambios
Boton=3
NombreDesplegar=&Guardar Cambios
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Guarda<BR>Inserta<BR>Cerrar
NombreEnBoton=S
[ArtAlmInstitucionesCategoriavis.DM0136INVCategoriasInstitucionespasoTBL.Maximo]
Carpeta=ArtAlmInstitucionesCategoriavis
Clave=DM0136INVCategoriasInstitucionespasoTBL.Maximo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
IgnoraFlujo=N
[Acciones.Guardar Cambios.Guarda]
Nombre=Guarda
Boton=0
TipoAccion=Controles Captura
Activo=S
Visible=S
ClaveAccion=Guardar Cambios
[Acciones.Guardar Cambios.Inserta]
Nombre=Inserta
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=EjecutarSQL(<T>Exec SP_MAVIDM0136InsertaAlmacenesdeCategorias :tVal1, :nVal2, :tVal3<T>, Usuario, EstacionTrabajo, Info.Articulo)
[Acciones.Guardar Cambios.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Eliminar]
Nombre=Eliminar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Eliminar
EnBarraHerramientas=S
TipoAccion=Formas
Activo=S
Visible=S
EspacioPrevio=S
ClaveAccion=ArtAlmsoloCategoriasfrm
[ArtAlmInstitucionesCategoriavis.DM0136INVCategoriasInstitucionespasoTBL.Sucursal]
Carpeta=ArtAlmInstitucionesCategoriavis
Clave=DM0136INVCategoriasInstitucionespasoTBL.Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

