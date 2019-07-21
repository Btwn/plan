[Forma]
Clave=OrdenarTiposCoberturaMAVI
Nombre=Coberturas
Icono=0
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialAlturaCliente=131
PosicionInicialAncho=371
PosicionCol1=228
PosicionInicialIzquierda=452
PosicionInicialArriba=479
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar Cambios
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaExclusiva=S
VentanaEstadoInicial=Normal
Comentarios=<T>Utilice arrastrar y soltar para cambiar el orden<T>
[TiposCoberturaMAVI.TiposCoberturaMAVI.Orden]
Carpeta=TiposCoberturaMAVI
Clave=TiposCoberturaMAVI.Orden
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[TiposCoberturaMAVI.TiposCoberturaMAVI.Cobertura]
Carpeta=TiposCoberturaMAVI
Clave=TiposCoberturaMAVI.Cobertura
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[TiposCoberturaMAVI.Columnas]
Orden=64
Cobertura=304
[Lista]
Estilo=Iconos
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=TiposCoberturaMAVI
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=TiposCoberturaMAVI.Cobertura
PestanaOtroNombre=S
PestanaNombre=Cobertura
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Orden<T>
ElementosPorPagina=200
OtroOrden=S
ListaOrden=TiposCoberturaMAVI.Orden<TAB>(Acendente)
IconosNombre=TiposCoberturaMAVI:TiposCoberturaMAVI.Orden
IconosCambiarOrden=S
[Lista.Columnas]
Cobertura=141
Orden=54
0=-2
1=317
[Acciones.Guardar Cambios]
Nombre=Guardar Cambios
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar Ordenación
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
Antes=S
AntesExpresiones=RegistrarListaSt(<T>Lista<T>, <T>TiposCoberturaMAVI.Cobertura<T>)<BR>EjecutarSQL(<T>spOrdenarMaestro :nEstacion, :tTabla<T>, EstacionTrabajo, <T>TiposCoberturaMAVI<T>)
[Lista.TiposCoberturaMAVI.Cobertura]
Carpeta=Lista
Clave=TiposCoberturaMAVI.Cobertura
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

