
[Forma]
Clave=RM1179ReporteRedistribucionFrm
Icono=375
Modulos=(Todos)
Nombre=<T>Reporte Redistribución Transitos<T>
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialIzquierda=481
PosicionInicialArriba=373
PosicionInicialAlturaCliente=240
PosicionInicialAncho=317

ListaCarpetas=Filtros
CarpetaPrincipal=Filtros
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaBloquearAjuste=S
BarraHerramientas=S
ListaAcciones=Preliminar<BR>cerrar
ExpresionesAlMostrar=Asigna(Mavi.RM1179Dias,NULO)<BR>Asigna(Mavi.RM1179Almacen,NULO)<BR>Asigna(Mavi.RM1179Familia,NULO)<BR>Asigna(Mavi.RM1179Linea,NULO)
[Filtros]
Estilo=Ficha
Clave=Filtros
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
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM1179Dias<BR>Mavi.RM1179Almacen<BR>Mavi.RM1179Familia<BR>Mavi.RM1179Linea
CarpetaVisible=S

[Filtros.Mavi.RM1179Dias]
Carpeta=Filtros
Clave=Mavi.RM1179Dias
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=6
ColorFondo=Blanco


[Acciones.cerrar]
Nombre=cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
Antes=S


[Familia.Columnas]
0=-2

[Filtros.Mavi.RM1179Almacen]
Carpeta=Filtros
Clave=Mavi.RM1179Almacen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Vista.Columnas]
0=88
1=246

[Filtros.Mavi.RM1179Familia]
Carpeta=Filtros
Clave=Mavi.RM1179Familia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Filtros.Mavi.RM1179Linea]
Carpeta=Filtros
Clave=Mavi.RM1179Linea
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Linea.Columnas]
0=-2

[(Carpeta Abrir)]
Estilo=Ficha
Pestana=S
Clave=(Carpeta Abrir)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPaginaEsp=200
CampoColorLetras=Negro
CampoColorFondo=Negro
CarpetaVisible=S



[Acciones.Preli.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Preli.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=Si<BR>    Vacio(Mavi.RM1179Dias)<BR>Entonces<BR>    Error(<T>Los filtros: Cantidad de días, Almacen y Familia, son obligatorios<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin



[Acciones.Preliminar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Preliminar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

ConCondicion=S
EjecucionCondicion=Si<BR>    (Vacio(Mavi.RM1179Dias)) o (Vacio(Mavi.RM1179Almacen)) o (Vacio(Mavi.RM1179Familia))<BR>Entonces<BR>    Error(<T>Los filtros: Cantidad de días, Almacen y Familia, son obligatorios<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin<BR><BR>Si<BR>     Contiene( Mavi.RM1179Familia, <T>,<T> ) = Verdadero<BR>Entonces<BR>    Si<BR>        ConDatos(Mavi.RM1179Linea)<BR>    Entonces<BR>        Informacion(<T>Si se seleccionaron 2 o mas familias la linea no es necesaria<T>)<BR>        AbortarOperacion<BR>    Sino<BR>        Verdadero<BR>    Fin<BR>Fin
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Variables Asignar<BR>Aceptar
Activo=S
Visible=S

