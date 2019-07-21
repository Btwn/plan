[Forma]
Clave=MaviArtCatLigGrup2FRM
Nombre=CATEGORIA DE ARTICULOS
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=552
PosicionInicialArriba=412
PosicionInicialAlturaCliente=90
PosicionInicialAncho=236
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaExclusiva=S
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Mavi.ArtCatLigGrup,<T><T>)
[(Variables)]
Estilo=Ficha
Clave=(Variables)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
ListaEnCaptura=Mavi.ArtCatLigGrup
PermiteEditar=S
[(Variables).Mavi.ArtCatLigGrup]
Carpeta=(Variables)
Clave=Mavi.ArtCatLigGrup
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreDesplegar=&Aceptar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
NombreEnBoton=S
Multiple=S
ListaAccionesMultiples=Aceptar<BR>Grupos
[Acciones.Aceptar.Grupos]
Nombre=Grupos
Boton=0
TipoAccion=Formas
ClaveAccion=MaviArtGrupLigFam2FRM
Activo=S
Visible=S
[Acciones.Aceptar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S


