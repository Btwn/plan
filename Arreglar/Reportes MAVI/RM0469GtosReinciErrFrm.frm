[Forma]
Clave=RM0469GtosReinciErrFrm
Nombre=RM469 Reincidencias de Errores
Icono=574
Modulos=(Todos)
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialIzquierda=484
PosicionInicialArriba=380
PosicionInicialAlturaCliente=230
PosicionInicialAncho=312
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
ListaAcciones=Preliminar<BR>Cerrar
VentanaEscCerrar=S
ExpresionesAlMostrar=Asigna(mavi.gasto,<T>Fecha de Gastos<T>)<BR>Asigna(mavi.revision,<T>Fecha de Revisi�n<T>)<BR>Asigna(Info.FechaD,nulo)<BR>Asigna(Info.FechaA,nulo)<BR>Asigna(Mavi.FechaI,nulo)<BR>Asigna(Mavi.FechaF,nulo)<BR>Asigna(Mavi.Acreedor,nulo)
[(Variables)]
Estilo=Ficha
Clave=(Variables)
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
CampoColorLetras=Azul marino
CampoColorFondo=Plata
ListaEnCaptura=Mavi.Gasto<BR>Info.FechaD<BR>Info.FechaA<BR>Mavi.Revision<BR>Mavi.FechaI<BR>Mavi.FechaF<BR>Mavi.Acreedor
CarpetaVisible=S
PermiteEditar=S
[(Variables).Mavi.Gasto]
Carpeta=(Variables)
Clave=Mavi.Gasto
Editar=N
LineaNueva=S
ValidaNombre=N
3D=N
Tamano=20
ColorFondo=Plata
ColorFuente=Azul marino
OcultaNombre=S
Efectos=[Negritas]
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
[(Variables).Mavi.Revision]
Carpeta=(Variables)
Clave=Mavi.Revision
Editar=N
LineaNueva=S
ValidaNombre=N
3D=N
Tamano=20
ColorFondo=Plata
ColorFuente=Azul marino
OcultaNombre=S
Efectos=[Negritas]
EspacioPrevio=S
[(Variables).Mavi.FechaF]
Carpeta=(Variables)
Clave=Mavi.FechaF
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.FechaI]
Carpeta=(Variables)
Clave=Mavi.FechaI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.Acreedor]
Carpeta=(Variables)
Clave=Mavi.Acreedor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S
[Acciones.Preliminar]
Nombre=Preliminar
Boton=68
NombreDesplegar=&Preliminar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
NombreEnBoton=S
ListaAccionesMultiples=Aisgnar<BR>Cerrar
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
[Acciones.Preliminar.Aisgnar]
Nombre=Aisgnar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=((Info.FechaD)<=(Info.FechaA) o Vacio(Info.FechaA)) y ((Mavi.FechaI)<=(Mavi.FechaF) o Vacio(Mavi.FechaF))
EjecucionMensaje=Si ((Info.FechaA)<(Info.FechaD)) o ((Mavi.FechaF)<(Mavi.FechaI))<BR>    Entonces <T>La Fecha Final debe ser Mayor o Igual que la Inicial<T><BR>Fin

