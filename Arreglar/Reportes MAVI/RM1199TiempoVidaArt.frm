
[Forma]
Clave=RM1199TiempoVidaArt
Icono=585
Modulos=(Todos)
Nombre=<T>RM1199 Tiempo de Vida de Artículos<T>
PosicionInicialAlturaCliente=143
PosicionInicialAncho=333


CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=486
PosicionInicialArriba=59
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ListaAcciones=EnviarTXT<BR>Cerrar
ListaCarpetas=(Variables)
ExpresionesAlMostrar=asigna(Mavi.RM1199FamArt,Nulo)<BR>asigna(Mavi.RM1199LineaArt,Nulo)
[rama.ArtFam.Familia]
Carpeta=rama
Clave=ArtFam.Familia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[rama.Columnas]
Familia=304


[Vista.Columnas]
0=-2

[RM0000LineaArtVis.Columnas]
0=647



[Acciones.TXT.Variable]
Nombre=Variable
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

ConCondicion=S
EjecucionCondicion=Si<BR>  ConDatos(Mavi.RM0254FamArt)<BR>Entonces<BR>  Verdadero<BR>Fin<BR><BR>Si<BR>  ConDatos(Mavi.RM0254FamArt)<BR>Entonces<BR>  Verdadero<BR>Fin
[Acciones.TXT.acept]
Nombre=acept
Boton=0
TipoAccion=Reportes Impresora
Activo=S
Visible=S
ClaveAccion=RM1199TiempoVidaArtRepTXT



[Acciones.EnviarTXT]
Nombre=EnviarTXT
Boton=54
NombreEnBoton=S
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S

ListaAccionesMultiples=Asignar<BR>Reporte Txt
NombreDesplegar=&Enviar a TXT
[Acciones.Cerrar]
Nombre=Cerrar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
Activo=S
Visible=S
ClaveAccion=Cerrar

[Acciones.EnviarTXT.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


[Acciones.EnviarTXT.Reporte Txt]
Nombre=Reporte Txt
Boton=0
TipoAccion=Reportes Impresora
Activo=S
Visible=S
ClaveAccion=RM1199TiempoVidaArtRepTXT








[(Variables).familia]
Carpeta=(Variables)
Clave=familia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

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
ListaEnCaptura=Mavi.RM1199FamArt<BR>Mavi.RM1199LineaArt

PermiteEditar=S
[(Variables).Mavi.RM1199FamArt]
Carpeta=(Variables)
Clave=Mavi.RM1199FamArt
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.RM1199LineaArt]
Carpeta=(Variables)
Clave=Mavi.RM1199LineaArt
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


