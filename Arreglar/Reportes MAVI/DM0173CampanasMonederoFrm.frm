[Forma]
Clave=DM0173CAMPANASMONEDEROFrm
Icono=0
Menus=S
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=VARIABLES<BR>maviDM0173CAMPANASMONEDERO<BR>MAVIDM0173DATOSCAMPANAS
CarpetaPrincipal=maviDM0173CAMPANASMONEDERO
PosicionInicialIzquierda=141
PosicionInicialArriba=9
PosicionInicialAlturaCliente=655
PosicionInicialAncho=1132
PosicionSec1=70
PosicionCol2=752
ListaAcciones=Actualiza<BR>Excel<BR>cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
[maviDM0173CAMPANASMONEDERO]
Estilo=Hoja
Clave=maviDM0173CAMPANASMONEDERO
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=MAVIDM0173CAMPANASMONEDERO
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=MAVIDM0173CAMPANASMONEDERO.Id<BR>MAVIDM0173CAMPANASMONEDERO.Nombre<BR>MAVIDM0173CAMPANASMONEDERO.FechaD<BR>MAVIDM0173CAMPANASMONEDERO.FechaA
ListaAcciones=AltaCampaña
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
RefrescarAlEntrar=S
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
HojaAjustarColumnas=S
HojaTitulosEnBold=S
HojaIndicador=S
HojaSinBorde=S
HojaFondoGris=S
HojaFondoGrisAuto=S
FiltroGeneral={Si((ConDatos(Mavi.FechaI)) y (ConDatos(Mavi.FechaF)), Comillas(FechaFormatoServidor(Mavi.FechaI))+<T> >= fechaD AND <T>+Comillas(FechaFormatoServidor(Mavi.FechaF))+<T> <= FechaA <T>,<T><T>)}<BR>{Si((condatos(Info.Uen)) y (Info.Uen > 0),<T> and Uen=<T>+comillas(Info.Uen),<T><T>)}<BR>{Si(condatos(Mavi.FamiliaArtVenta),<T> and FamiliaArt=<T>+comillas(Mavi.FamiliaArtVenta),<T><T>)}<BR>{Si(condatos(Mavi.LineaArtVenta),<T> and LineaArt=<T>+comillas(Mavi.LineaArtVenta),<T><T>)}<BR>{Si(condatos(Mavi.TipoClienteVenta),<T> and MaviTipoVenta=<T>+comillas(Mavi.TipoClienteVenta),<T><T>)}<BR>{Si(condatos(Mavi.CategoCanaldeVenta),<T> and CategoriaCV=<T>+comillas(Mavi.CategoCanaldeVenta),<T><T>)}
[maviDM0173CAMPANASMONEDERO.MAVIDM0173CAMPANASMONEDERO.Id]
Carpeta=maviDM0173CAMPANASMONEDERO
Clave=MAVIDM0173CAMPANASMONEDERO.Id
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[maviDM0173CAMPANASMONEDERO.MAVIDM0173CAMPANASMONEDERO.FechaD]
Carpeta=maviDM0173CAMPANASMONEDERO
Clave=MAVIDM0173CAMPANASMONEDERO.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[maviDM0173CAMPANASMONEDERO.Columnas]
Id=41
FechaD=94
Nombre=476
FechaA=94
Movimiento=124

[maviDM0173CAMPANASMONEDERO.MAVIDM0173CAMPANASMONEDERO.Nombre]
Carpeta=maviDM0173CAMPANASMONEDERO
Clave=MAVIDM0173CAMPANASMONEDERO.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[maviDM0173CAMPANASMONEDERO.MAVIDM0173CAMPANASMONEDERO.FechaA]
Carpeta=maviDM0173CAMPANASMONEDERO
Clave=MAVIDM0173CAMPANASMONEDERO.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[VARIABLES]
Estilo=Ficha
Clave=VARIABLES
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.FechaI<BR>Info.UEN<BR>Mavi.CategoCanaldeVenta<BR>Mavi.TipoClienteVenta<BR>Mavi.FechaF<BR>Mavi.FamiliaArtVenta<BR>Mavi.LineaArtVenta
CarpetaVisible=S
InicializarVariables=S
[VARIABLES.Mavi.FechaI]
Carpeta=VARIABLES
Clave=Mavi.FechaI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[VARIABLES.Info.UEN]
Carpeta=VARIABLES
Clave=Info.UEN
Editar=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[VARIABLES.Mavi.CategoCanaldeVenta]
Carpeta=VARIABLES
Clave=Mavi.CategoCanaldeVenta
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[VARIABLES.Mavi.TipoClienteVenta]
Carpeta=VARIABLES
Clave=Mavi.TipoClienteVenta
Editar=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[VARIABLES.Mavi.FechaF]
Carpeta=VARIABLES
Clave=Mavi.FechaF
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[MAVIDM0173DATOSCAMPANAS]
Estilo=Ficha
Clave=MAVIDM0173DATOSCAMPANAS
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B2
Vista=MAVIDM0173CAMPANASMONEDERO
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=MAVIDM0173CAMPANASMONEDERO.Id<BR>MAVIDM0173CAMPANASMONEDERO.Movimiento<BR>MAVIDM0173CAMPANASMONEDERO.Uen<BR>MAVIDM0173CAMPANASMONEDERO.Sucursal<BR>MAVIDM0173CAMPANASMONEDERO.CanalVenta<BR>MAVIDM0173CAMPANASMONEDERO.TipoSuc<BR>MAVIDM0173CAMPANASMONEDERO.CategoriaCV<BR>MAVIDM0173CAMPANASMONEDERO.GpoPropreCond<BR>MAVIDM0173CAMPANASMONEDERO.Condicion<BR>MAVIDM0173CAMPANASMONEDERO.CategoriaArt<BR>MAVIDM0173CAMPANASMONEDERO.GrupoArt<BR>MAVIDM0173CAMPANASMONEDERO.FamiliaArt<BR>MAVIDM0173CAMPANASMONEDERO.LineaArt<BR>MAVIDM0173CAMPANASMONEDERO.Marca<BR>MAVIDM0173CAMPANASMONEDERO.Articulo<BR>MAVIDM0173CAMPANASMONEDERO.PorcMonedero<BR>MAVIDM0173CAMPANASMONEDERO.Cliente<BR>MAVIDM0173CAMPANASMONEDERO.MaviTipoVenta<BR>MAVIDM0173CAMPANASMONEDERO.Acumulable<BR>MAVIDM0173CAMPANASMONEDERO.Estatus
CarpetaVisible=S
ListaEnCaptura002=<CONTINUA>AMPANASMONEDERO.Condicion<BR>MAVIDM0173CAMPANASMONEDERO.CanalVenta<BR>MAVIDM0173CAMPANASMONEDERO.Uen
[MAVIDM0173DATOSCAMPANAS.MAVIDM0173CAMPANASMONEDERO.Movimiento]
Carpeta=MAVIDM0173DATOSCAMPANAS
Clave=MAVIDM0173CAMPANASMONEDERO.Movimiento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[MAVIDM0173DATOSCAMPANAS.MAVIDM0173CAMPANASMONEDERO.TipoSuc]
Carpeta=MAVIDM0173DATOSCAMPANAS
Clave=MAVIDM0173CAMPANASMONEDERO.TipoSuc
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[MAVIDM0173DATOSCAMPANAS.MAVIDM0173CAMPANASMONEDERO.CategoriaCV]
Carpeta=MAVIDM0173DATOSCAMPANAS
Clave=MAVIDM0173CAMPANASMONEDERO.CategoriaCV
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[MAVIDM0173DATOSCAMPANAS.MAVIDM0173CAMPANASMONEDERO.GpoPropreCond]
Carpeta=MAVIDM0173DATOSCAMPANAS
Clave=MAVIDM0173CAMPANASMONEDERO.GpoPropreCond
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[MAVIDM0173DATOSCAMPANAS.MAVIDM0173CAMPANASMONEDERO.Articulo]
Carpeta=MAVIDM0173DATOSCAMPANAS
Clave=MAVIDM0173CAMPANASMONEDERO.Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[MAVIDM0173DATOSCAMPANAS.MAVIDM0173CAMPANASMONEDERO.CategoriaArt]
Carpeta=MAVIDM0173DATOSCAMPANAS
Clave=MAVIDM0173CAMPANASMONEDERO.CategoriaArt
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[MAVIDM0173DATOSCAMPANAS.MAVIDM0173CAMPANASMONEDERO.FamiliaArt]
Carpeta=MAVIDM0173DATOSCAMPANAS
Clave=MAVIDM0173CAMPANASMONEDERO.FamiliaArt
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[MAVIDM0173DATOSCAMPANAS.MAVIDM0173CAMPANASMONEDERO.PorcMonedero]
Carpeta=MAVIDM0173DATOSCAMPANAS
Clave=MAVIDM0173CAMPANASMONEDERO.PorcMonedero
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[MAVIDM0173DATOSCAMPANAS.MAVIDM0173CAMPANASMONEDERO.Estatus]
Carpeta=MAVIDM0173DATOSCAMPANAS
Clave=MAVIDM0173CAMPANASMONEDERO.Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[MAVIDM0173DATOSCAMPANAS.MAVIDM0173CAMPANASMONEDERO.Cliente]
Carpeta=MAVIDM0173DATOSCAMPANAS
Clave=MAVIDM0173CAMPANASMONEDERO.Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[MAVIDM0173DATOSCAMPANAS.MAVIDM0173CAMPANASMONEDERO.MaviTipoVenta]
Carpeta=MAVIDM0173DATOSCAMPANAS
Clave=MAVIDM0173CAMPANASMONEDERO.MaviTipoVenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[MAVIDM0173DATOSCAMPANAS.MAVIDM0173CAMPANASMONEDERO.Acumulable]
Carpeta=MAVIDM0173DATOSCAMPANAS
Clave=MAVIDM0173CAMPANASMONEDERO.Acumulable
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[MAVIDM0173DATOSCAMPANAS.MAVIDM0173CAMPANASMONEDERO.LineaArt]
Carpeta=MAVIDM0173DATOSCAMPANAS
Clave=MAVIDM0173CAMPANASMONEDERO.LineaArt
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[MAVIDM0173DATOSCAMPANAS.MAVIDM0173CAMPANASMONEDERO.GrupoArt]
Carpeta=MAVIDM0173DATOSCAMPANAS
Clave=MAVIDM0173CAMPANASMONEDERO.GrupoArt
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[MAVIDM0173DATOSCAMPANAS.MAVIDM0173CAMPANASMONEDERO.Marca]
Carpeta=MAVIDM0173DATOSCAMPANAS
Clave=MAVIDM0173CAMPANASMONEDERO.Marca
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[MAVIDM0173DATOSCAMPANAS.MAVIDM0173CAMPANASMONEDERO.Condicion]
Carpeta=MAVIDM0173DATOSCAMPANAS
Clave=MAVIDM0173CAMPANASMONEDERO.Condicion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[MAVIDM0173DATOSCAMPANAS.MAVIDM0173CAMPANASMONEDERO.CanalVenta]
Carpeta=MAVIDM0173DATOSCAMPANAS
Clave=MAVIDM0173CAMPANASMONEDERO.CanalVenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=5
[MAVIDM0173DATOSCAMPANAS.MAVIDM0173CAMPANASMONEDERO.Uen]
Carpeta=MAVIDM0173DATOSCAMPANAS
Clave=MAVIDM0173CAMPANASMONEDERO.Uen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=5
[MAVIDM0173DATOSCAMPANAS.MAVIDM0173CAMPANASMONEDERO.Sucursal]
Carpeta=MAVIDM0173DATOSCAMPANAS
Clave=MAVIDM0173CAMPANASMONEDERO.Sucursal
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=5
[Acciones.AltaCampaña.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.AltaCampaña.ponerforma]
Nombre=ponerforma
Boton=0
TipoAccion=formas
Activo=S
Visible=S
ClaveAccion=dm0173CAMPANASMONEDEROALTAFrm
[Acciones.AltaCampaña.actuforma]
Nombre=actuforma
Boton=0
TipoAccion=controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
[Acciones.AltaCampaña]
Nombre=AltaCampaña
Boton=0
UsaTeclaRapida=S
TeclaRapida=F11
NombreDesplegar=&Nueva Campaña Refacturacion
Multiple=S
EnMenu=S
ListaAccionesMultiples=Asigna<BR>ponerforma<BR>actuforma
Activo=S
Antes=S
Visible=S
AntesExpresiones=Asigna(Info.IdMavi,MAVIDM0173CAMPANASMONEDERO:MAVIDM0173CAMPANASMONEDERO.Id)
[Acciones.Actualiza.asig]
Nombre=asig
Boton=0
TipoAccion=controles Captura
ClaveAccion=variables Asignar
Activo=S
Visible=S
[Acciones.Actualiza.actualiz]
Nombre=actualiz
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=Si<BR>   ConDatos( Mavi.FechaI) y  ConDatos( Mavi.FechaF)<BR>    Entonces                    <BR>        Si<BR>          Mavi.FechaI <= Mavi.FechaF<BR>            Entonces<BR>                ActualizarVista<BR>            Sino<BR>               Error( <T>Rango de Fechas Invalido!!!...<T> )<BR>        Fin<BR><BR>    Sino<BR>       Error( <T>Selecciona Rango de Fechas!!!...<T> )<BR>Fin
[Acciones.Actualiza]
Nombre=Actualiza
Boton=82
NombreEnBoton=S
UsaTeclaRapida=S
TeclaRapida=F5
TeclaFuncion=F5
NombreDesplegar=&Actualizar
Multiple=S
EnBarraHerramientas=S
EnMenu=S
ListaAccionesMultiples=asig<BR>actualiz
Activo=S
Visible=S
[Acciones.Excel]
Nombre=Excel
Boton=115
NombreEnBoton=S
NombreDesplegar=Enviar a &Excel
EnBarraHerramientas=S
EnMenu=S
Carpeta=(Carpeta principal)
TipoAccion=controles Captura
ClaveAccion=Enviar a Excel
Activo=S
Visible=S
[Acciones.cerrar]
Nombre=cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EnMenu=S
TipoAccion=ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[VARIABLES.Mavi.FamiliaArtVenta]
Carpeta=VARIABLES
Clave=Mavi.FamiliaArtVenta
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[VARIABLES.Mavi.LineaArtVenta]
Carpeta=VARIABLES
Clave=Mavi.LineaArtVenta
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[MAVIDM0173DATOSCAMPANAS.MAVIDM0173CAMPANASMONEDERO.Id]
Carpeta=MAVIDM0173DATOSCAMPANAS
Clave=MAVIDM0173CAMPANASMONEDERO.Id
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

