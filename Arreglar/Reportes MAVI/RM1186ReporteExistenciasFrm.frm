
[Forma]
Clave=RM1186ReporteExistenciasFrm
Icono=0
Modulos=(Todos)
Nombre=<T>Reporte de Existencias<T>
PosicionInicialAlturaCliente=160
PosicionInicialAncho=470


ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=448
PosicionInicialArriba=285
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Reporte<BR>Cerrar
Menus=S
PosicionSec1=153
ExpresionesAlMostrar=Asigna(Mavi.RM1186Categoria,<T>VENTA<T>)<BR>Asigna(Mavi.RM1186Grupo,<T>MERCANCIA DE LINEA<T>)<BR>Asigna(Mavi.RM1186Familia,<T><T>)<BR>Asigna(Mavi.RM1186Linea,<T><T>)<BR>Asigna(Mavi.RM1186Almacen,<T><T>)
[RM1186ReporteExistenciasVis.Art.Categoria]
Carpeta=RM1186ReporteExistenciasVis
Clave=Art.Categoria
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco





[RM1186VarCategoriaVis.Columnas]
Categoria=233


[(Variables).Mavi.RM1186Categoria]
Carpeta=(Variables)
Clave=Mavi.RM1186Categoria
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.RM1186Grupo]
Carpeta=(Variables)
Clave=Mavi.RM1186Grupo
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[RM1186CategoriaVis.Columnas]
Categoria=304

[RM1186GrupoVis.Columnas]
Grupo=304

[(Variables).Mavi.RM1186Familia]
Carpeta=(Variables)
Clave=Mavi.RM1186Familia
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.RM1186Linea]
Carpeta=(Variables)
Clave=Mavi.RM1186Linea
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[RM1186FamiliaVis.Columnas]
Familia=304

0=-2
[RM1186LineaVis.Columnas]
Linea=304


0=-2
[rama.RM1186COMSArtCat.Categoria]
Carpeta=rama
Clave=RM1186COMSArtCat.Categoria
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco








[RM1186ReporteExistenciasVis.RM1186COMSArt.Categoria]
Carpeta=RM1186ReporteExistenciasVis
Clave=RM1186COMSArt.Categoria
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

Tamano=50
Pegado=N
[RM1186ReporteExistenciasVis.RM1186COMSArt.Grupo]
Carpeta=RM1186ReporteExistenciasVis
Clave=RM1186COMSArt.Grupo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

Tamano=50
[RM1186ReporteExistenciasVis.RM1186COMSArt.Familia]
Carpeta=RM1186ReporteExistenciasVis
Clave=RM1186COMSArt.Familia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[RM1186ReporteExistenciasVis.RM1186COMSArt.Linea]
Carpeta=RM1186ReporteExistenciasVis
Clave=RM1186COMSArt.Linea
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[(Carpeta Abrir)]
Estilo=Iconos
Pestana=S
Clave=(Carpeta Abrir)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Vista=RM1186ReporteExistenciasVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPaginaEsp=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S






[(Variables)]
Estilo=Ficha
Clave=(Variables)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=24
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM1186Categoria<BR>Mavi.RM1186Grupo<BR>Mavi.RM1186Familia<BR>Mavi.RM1186Linea<BR>Mavi.RM1186Almacen
CarpetaVisible=S
PermiteEditar=S

[(Variables).Mavi.RM1186Almacen]
Carpeta=(Variables)
Clave=Mavi.RM1186Almacen
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[RM1186AlmacenVis.Columnas]
Almacen=164

0=-2

[RM1186ReporteExistenciasVis.Columnas]
Articulo=179
Descripcion1=362
Transito=45
Estatus=129
Familia=101
Linea=304
Almacen=64
Disponibles=64
Totales=94

Descripcion=347
Renglon=64
[Acciones.Reporte.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


[RM1186ReporteExistenciasVis.Articulo]
Carpeta=RM1186ReporteExistenciasVis
Clave=Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


[RM1186ReporteExistenciasVis.Transito]
Carpeta=RM1186ReporteExistenciasVis
Clave=Transito
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[RM1186ReporteExistenciasVis.Estatus]
Carpeta=RM1186ReporteExistenciasVis
Clave=Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[RM1186ReporteExistenciasVis.Familia]
Carpeta=RM1186ReporteExistenciasVis
Clave=Familia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[RM1186ReporteExistenciasVis.Linea]
Carpeta=RM1186ReporteExistenciasVis
Clave=Linea
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[RM1186ReporteExistenciasVis.Almacen]
Carpeta=RM1186ReporteExistenciasVis
Clave=Almacen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco

[RM1186ReporteExistenciasVis.Disponibles]
Carpeta=RM1186ReporteExistenciasVis
Clave=Disponibles
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[RM1186ReporteExistenciasVis.Totales]
Carpeta=RM1186ReporteExistenciasVis
Clave=Totales
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco


[RM1186ReporteExistenciasVis.Descripcion]
Carpeta=RM1186ReporteExistenciasVis
Clave=Descripcion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco




[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Reporte]
Nombre=Reporte
Boton=108
NombreEnBoton=S
NombreDesplegar=&Reporte
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Si<BR>  ConDatos(MAVI.RM1186Categoria) && ConDatos(MAVI.RM1186Grupo)<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  Falso<BR>Fin<BR><BR>Si<BR> ConDatos(MAVI.RM1186Familia) && ConDatos(MAVI.RM1186Linea) && ConDatos(MAVI.RM1186Almacen)<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  Falso<BR>Fin
EjecucionMensaje=<T>¡Es necesario llenar todos los filtros!<T>

