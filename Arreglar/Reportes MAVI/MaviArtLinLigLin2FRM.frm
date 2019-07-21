[Forma]
Clave=MaviArtLinLigLin2FRM
Nombre=LINEAS DE ARTICULOS
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
ExpresionesAlMostrar=Asigna(Mavi.ArtLinLigLin,<T><T>)
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
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
ListaEnCaptura=Mavi.ArtLinLigLin
[(Variables).Mavi.ArtLinLigLin]
Carpeta=(Variables)
Clave=Mavi.ArtLinLigLin
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreDesplegar=&Aceptar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Aceptar<BR>Almacenes
Activo=S
Visible=S
NombreEnBoton=S
[Acciones.Aceptar.Almacenes]
Nombre=Almacenes
Boton=0
TipoAccion=Formas
ClaveAccion=MaviTodosAlmacenes2FRM
Activo=S
Visible=S


