[Forma]
Clave=PropreArtFam
Nombre=Configuración Lineas Propre
Icono=0
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>PropreArtFamUEN<BR>Preliminar
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialIzquierda=469
PosicionInicialArriba=229
PosicionInicialAlturaCliente=273
PosicionInicialAncho=342
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
[Acciones.Aceptar]
Nombre=Aceptar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar y cerrar
GuardarAntes=S
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
[Lista]
Estilo=Hoja
Clave=Lista
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=PropreArtFam
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=PropreArtFam.Familia
CarpetaVisible=S
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
[Lista.PropreArtFam.Familia]
Carpeta=Lista
Clave=PropreArtFam.Familia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Columnas]
Familia=304
FonaAmerica=74
FonaViu=64
FideAmerica=68
FideViu=64
C1America=64
C2America=64
C1Viu=64
C2Viu=64
[Acciones.PropreArtFamUEN]
Nombre=PropreArtFamUEN
Boton=45
NombreEnBoton=S
NombreDesplegar=&Configurar UEN<T>S
GuardarAntes=S
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=PropreArtFamUEN
Activo=S
Antes=S
Visible=S
AntesExpresiones=Asigna(Info.PropreArtFam,PropreArtFam:PropreArtFam.Familia)
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreDesplegar=Presentacion Preliminar
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Presentacion preliminar
Activo=S
Visible=S

