[Forma]
Clave=MaviFinCtlTelFaxFrm
Nombre=RM288 Control de Aparatos Telefónicos y Faxes
Icono=550
Modulos=(Todos)
ListaCarpetas=(variables)
CarpetaPrincipal=(variables)
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialAlturaCliente=135
PosicionInicialAncho=361
PosicionInicialIzquierda=459
PosicionInicialArriba=427
ListaAcciones=Preliminar<BR>Cerrar
BarraHerramientas=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaEscCerrar=S
VentanaAvanzaTab=S
ExpresionesAlMostrar=Asigna(Info.Articulo,<T><T>)<BR>Asigna(Mavi.Sucursales, Nulo)<BR>Asigna(Mavi.FGaraVenciD,Nulo)<BR>Asigna(Mavi.FGaraVenciA,Nulo)<BR>Asigna(Info.FechaD,Nulo)<BR>Asigna(Info.FechaA,Nulo)
[(variables)]
Estilo=Ficha
Clave=(variables)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
FichaEspacioEntreLineas=12
FichaEspacioNombres=0
FichaColorFondo=Plata
ListaEnCaptura=Mavi.ArtActivFijo<BR>Mavi.Sucursales<BR>Info.FechaD<BR>Info.FechaA
PermiteEditar=S
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asigna<BR>Acepta
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
EspacioPrevio=S
[(variables).Info.FechaD]
Carpeta=(variables)
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[(variables).Info.FechaA]
Carpeta=(variables)
Clave=Info.FechaA
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[(variables).Mavi.ArtActivFijo]
Carpeta=(variables)
Clave=Mavi.ArtActivFijo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[(variables).Mavi.Sucursales]
Carpeta=(variables)
Clave=Mavi.Sucursales
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[Acciones.Preliminar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.Acepta]
Nombre=Acepta
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=(Si(ConDatos(Mavi.ArtActivFijo),Si(SQL(<T>Select Articulo From Art Where Categoria=<T>+Comillas(<T>ACTIVOS FIJOS<T>)+<T> And Articulo = :tArt<T>,Mavi.ArtActivFijo)<>Nulo,Verdadero,Falso),Verdadero))y<BR>(Si(ConDatos(Mavi.Sucursales),Si(SQL(<T>Select Sucursal From Sucursal Where Sucursal = :nSuc<T>,Mavi.Sucursales)<>Nulo,Verdadero,Falso),Verdadero))y<BR>(Info.FechaD<=Info.FechaA)
EjecucionMensaje=Si(ConDatos(Mavi.ArtActivFijo),Si(SQL(<T>Select Articulo From Art Where Categoria=<T>+Comillas(<T>ACTIVOS FIJOS<T>)+<T> And Articulo = :tArt<T>,Mavi.ArtActivFijo)=Nulo,<T>El Activo Fijo <T>+Mavi.ArtActivFijo+<T> No Existe<T>,<BR>Si(ConDatos(Mavi.Sucursales),Si(SQL(<T>Select Sucursal From Sucursal Where Sucursal = :nSuc<T>,Mavi.Sucursales)=Nulo,<T>La Sucursal <T>+Mavi.Sucursales+<T> No Existe<T>,<BR>Si(Info.FechaD>Info.FechaA,<T>La Primer Fecha no Puede que ser Mayor que la Primera<T>,)))),<BR>Si(ConDatos(Mavi.Sucursales),Si(SQL(<T>Select Sucursal From Sucursal Where Sucursal = :nSuc<T>,Mavi.Sucursales)=Nulo,<T>La Sucursal <T>+Mavi.Sucursales+<T> No Existe<T>,<BR>Si(Info.FechaD>Info.FechaA,<T>La Primer Fecha no Puede que ser Mayor que la Primera<T>,)),<BR>Si(Info.FechaD>Info.FechaA,<T>La Pr<CONTINUA>
EjecucionMensaje002=<CONTINUA>imer Fecha no Puede que ser Mayor que la Primera<T>,)<BR>)<BR>)<BR> /*<BR>(Si(ConDatos(Mavi.ArtActivFijo),Si(SQL(<T>Select Articulo From Activofijo Where Articulo = :tArt<T>,Mavi.ArtActivFijo)<>Nulo,Verdadero,Falso),Verdadero))y<BR>(Si(ConDatos(Mavi.Sucursales),Si(SQL(<T>Select Sucursal From Sucursal Where Sucursal = :nSuc<T>,Mavi.Sucursales)<>Nulo,Verdadero,Falso),Verdadero))y<BR>(Info.FechaD<=Info.FechaA)*/


