
[Forma]
Clave=RM1168ComprasNormaFotografiaFrm
Icono=170
Modulos=(Todos)
MovModulo=(Todos)
Nombre=RM1168ComprasNormaFotografiaFrm

ListaCarpetas=Principal<BR>NormaFotografias
CarpetaPrincipal=Principal
PosicionInicialAlturaCliente=546
PosicionInicialAncho=751
PosicionSec1=144
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialIzquierda=333
PosicionInicialArriba=100
ListaAcciones=AgregaNorma<BR>GuardaCambios
BarraHerramientas=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
ExpresionesAlMostrar= Asigna(Mavi.RM1168NormaFotografia,0)<BR>    Asigna(Info.ArtFam,<T><T>)<BR>    Asigna(Info.ArtLinea,<T><T>)
[Principal]
Estilo=Ficha
Clave=Principal
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM1168FamiliaNorma<BR>Mavi.RM1168LineaNorma<BR>Mavi.RM1168NormaFotografia
CarpetaVisible=S

FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S


[NormaFotografias]
Estilo=Hoja
Clave=NormaFotografias
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=RM1168ComprasNormaFotografiaVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S

Pestana=S
PestanaOtroNombre=S
PestanaNombre=Normas Actuales
PermiteEditar=S



HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
ListaEnCaptura=RM1168ComprasNormaFotografiaTbl.Familia<BR>RM1168ComprasNormaFotografiaTbl.Linea<BR>RM1168ComprasNormaFotografiaTbl.NormaFotografia
[NormaFotografias.Columnas]
Familia=304
Linea=304
NormaFotografia=85

[Principal.Mavi.RM1168NormaFotografia]
Carpeta=Principal
Clave=Mavi.RM1168NormaFotografia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.AgregaNorma]
Nombre=AgregaNorma
Boton=23
NombreEnBoton=S
NombreDesplegar=Agregar Norma
EspacioPrevio=S
TipoAccion=Expresion
Activo=S
Visible=S
EnBarraHerramientas=S

Multiple=S
ListaAccionesMultiples=Asigna<BR>Agrega
[Acciones.GuardaCambios]
Nombre=GuardaCambios
Boton=3
NombreEnBoton=S
NombreDesplegar=Guardar Cambios
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

Antes=S
[Lista.Columnas]
Linea=234
Familia=263

[Acciones.AgregaNorma.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.AgregaNorma.Agrega]
Nombre=Agrega
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S

Expresion=EjecutarSQL(<T>SPIRM1168_AgregaNormaFotografia :tFam, :tLin, :nNom<T>,Mavi.RM1168FamiliaNorma,Mavi.RM1168LineaNorma,Mavi.RM1168NormaFotografia)<BR>    ActualizarVista(<T>RM1168ComprasNormaFotografiaVisFrm<T>)<BR>    Asigna(Mavi.RM1168NormaFotografia,0)<BR>    Asigna(Mavi.RM1168FamiliaNorma,<T><T>)<BR>    Asigna(Mavi.RM1168LineaNorma,<T><T>)
EjecucionCondicion=Si<BR>    ConDatos(Mavi.RM1168FamiliaNorma) y ConDatos(Mavi.RM1168LineaNorma) y ConDatos(Mavi.RM1168NormaFotografia)<BR>Entonces<BR>   Si<BR>        Mavi.RM1168NormaFotografia = 0 o Vacio(Mavi.RM1168NormaFotografia)<BR>    Entonces<BR>        Error(<T>Error al agregar la exclusion, verifica los campos...<T>)<BR>        AbortarOperacion<BR>    Sino<BR>        Verdadero<BR>    Fin<BR>Sino<BR>    Informacion(<T>Ingresa una Familia, una Linea y un valor de Norma valido<T>)<BR>Fin
[NormaFotografias.RM1168ComprasNormaFotografiaTbl.Familia]
Carpeta=NormaFotografias
Clave=RM1168ComprasNormaFotografiaTbl.Familia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[NormaFotografias.RM1168ComprasNormaFotografiaTbl.Linea]
Carpeta=NormaFotografias
Clave=RM1168ComprasNormaFotografiaTbl.Linea
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[NormaFotografias.RM1168ComprasNormaFotografiaTbl.NormaFotografia]
Carpeta=NormaFotografias
Clave=RM1168ComprasNormaFotografiaTbl.NormaFotografia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Principal.Mavi.RM1168FamiliaNorma]
Carpeta=Principal
Clave=Mavi.RM1168FamiliaNorma
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Principal.Mavi.RM1168LineaNorma]
Carpeta=Principal
Clave=Mavi.RM1168LineaNorma
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[principal.Columnas]
Linea=304
Familia=304


