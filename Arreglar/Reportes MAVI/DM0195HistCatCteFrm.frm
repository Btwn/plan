[Forma]
Clave=DM0195HistCatCteFrm
Nombre=DM0195Historico del Catalogo de Cliente
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)<BR>ListaModif
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=485
PosicionInicialAncho=1007
PosicionSec1=78
PosicionInicialIzquierda=134
PosicionInicialArriba=13
Menus=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
BarraHerramientas=S
EsMovimiento=S
TituloAuto=S
MovEspecificos=Todos
ListaAcciones=cerrar<BR>ACTUALIZA<BR>excel
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Dise�o
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Info.FechaD,Hoy)<BR>Asigna(Info.FechaA,Hoy)<BR>Asigna(Mavi.DM0195Cuenta,nulo)<BR>Asigna( Mavi.DM0195Usuario,nulo)
[ListaModif]
Estilo=Iconos
Clave=ListaModif
AlineacionAutomatica=S
AcomodarTexto=S
Zona=B1
Vista=DM0195HistCatCteVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=NOMBRE<BR>CUENTA<BR>CAMPO<BR>ANTES<BR>DESPUES<BR>FECHAMODIF<BR>HORA
CarpetaVisible=S
MostrarConteoRegistros=S
Detalle=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>USUARIO<T>
ElementosPorPagina=200
IconosConRejilla=S
IconosNombre=DM0195HistCatCteVis:USUARIO
[ListaModif.CUENTA]
Carpeta=ListaModif
Clave=CUENTA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[ListaModif.CAMPO]
Carpeta=ListaModif
Clave=CAMPO
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[ListaModif.ANTES]
Carpeta=ListaModif
Clave=ANTES
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[ListaModif.DESPUES]
Carpeta=ListaModif
Clave=DESPUES
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[ListaModif.FECHAMODIF]
Carpeta=ListaModif
Clave=FECHAMODIF
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[ListaModif.Columnas]
0=-2
1=203
2=83
3=66
4=159
5=-2
6=-2
7=-2
[ListaModif.NOMBRE]
Carpeta=ListaModif
Clave=NOMBRE
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=
ColorFondo=Blanco
ColorFuente=Negro
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
ListaEnCaptura=Info.FechaD<BR>Info.FechaA<BR>Mavi.DM0195Usuario<BR>Mavi.DM0195Cuenta
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=4
FichaEspacioNombres=21
FichaColorFondo=Plata
MenuLocal=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.cerrar]
Nombre=cerrar
Boton=36
EnBarraHerramientas=S
Activo=S
Visible=S
TipoAccion=Ventana
ClaveAccion=Cerrar
NombreEnBoton=S
NombreDesplegar=Cerrar
[Acciones.ACTUALIZA]
Nombre=ACTUALIZA
Boton=125
NombreDesplegar=ACTUALIZA
EnBarraHerramientas=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=asigna<BR>exp
NombreEnBoton=S
[Acciones.ACTUALIZA.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.ACTUALIZA.exp]
Nombre=exp
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=ActualizarForma(<T>DM0195HistCatCteFrm<T>)
[(Variables).Mavi.DM0195Usuario]
Carpeta=(Variables)
Clave=Mavi.DM0195Usuario
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.DM0195Cuenta]
Carpeta=(Variables)
Clave=Mavi.DM0195Cuenta
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[ListaModif.HORA]
Carpeta=ListaModif
Clave=HORA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=8
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.excel]
Nombre=excel
Boton=115
NombreDesplegar=Enviar a E&xcel
EnBarraHerramientas=S
Carpeta=ListaModif
TipoAccion=Controles Captura
ClaveAccion=Enviar a Excel
Activo=S
Visible=S
NombreEnBoton=S


