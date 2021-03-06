[Forma]
Clave=RM0074VehiRelParqVehiFrm
Nombre=<T>RM0074 Relación del Parque Vehicular<T>
Icono=624
Modulos=(Todos)
PosicionInicialIzquierda=522
PosicionInicialArriba=139
PosicionInicialAlturaCliente=455
PosicionInicialAncho=315
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
VentanaEstadoInicial=Normal
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar
ExpresionesAlMostrar=Asigna(Mavi.RM0074CapaD,Nulo)<BR>Asigna(Mavi.RM0074CapaA,Nulo)<BR>Asigna(Mavi.RM0074GrupoVehiculo,Nulo)<BR>Asigna(Mavi.RM0074PuntoReunionVehicular,Nulo)<BR>Asigna(Mavi.RM0074ModeloVehiculo,Nulo)<BR>Asigna(Mavi.RM0074MarcaVehiculo,Nulo)<BR>Asigna(Mavi.RM0074TipoUnidadVehiculo,Nulo)<BR>Asigna(Mavi.RM0074UsoVehicular,Nulo)<BR>Asigna(Mavi.RM0074NumUnidadVehicular,Nulo)<BR>Asigna(Mavi.RM0074FechaAdqAsig,Nulo)<BR>Asigna(Info.FechaD,PrimerDiaAño(Ahora)),<T><T>)<BR>Asigna(Info.FechaA,UltimoDiaAño(Ahora)),<T><T>)<BR>Asigna(Mavi.RM0074LocalidadEdo,Nulo)<BR>Asigna(Info.CentroCostos, Nulo)<BR>Asigna(Mavi.RM0074Estatus, Nulo)
[(Variables)]
Estilo=Ficha
Clave=(Variables)
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
ListaEnCaptura=Mavi.RM0074CapaD<BR>Mavi.RM0074CapaA<BR>Mavi.RM0074GrupoVehiculo<BR>Mavi.RM0074PuntoReunionVehicular<BR>Mavi.RM0074ModeloVehiculo<BR>Mavi.RM0074MarcaVehiculo<BR>Mavi.RM0074TipoUnidadVehiculo<BR>Mavi.RM0074UsoVehicular<BR>Mavi.RM0074NumUnidadVehicular<BR>Mavi.RM0074FechaAdqAsig<BR>Info.FechaD<BR>Info.FechaA<BR>Mavi.RM0074LocalidadEdo<BR>Info.CentroCostos<BR>Mavi.RM0074Estatus
CarpetaVisible=S
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asignar<BR>Cerrar
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
Efectos=[Negritas]
EspacioPrevio=S
[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[(Variables).Info.CentroCostos]
Carpeta=(Variables)
Clave=Info.CentroCostos
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar.Asignar]
Nombre=Asignar
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
Activo=S
ConCondicion=S
EjecucionConError=S
Visible=S
EjecucionCondicion=(((Info.FechaD)<=(Info.FechaA)) o (Vacio(Info.FechaD) y Vacio(Info.FechaA)) o (ConDatos(Info.FechaD) y Vacio(Info.FechaA))) y<BR>(((Mavi.RM0074CapaD)<=(Mavi.RM0074CapaA)) o (Vacio(Mavi.RM0074CapaD) y Vacio(Mavi.RM0074CapaA)) o (ConDatos(Mavi.RM0074CapaD) y Vacio(Mavi.RM0074CapaA)))
EjecucionMensaje=<T>Algunos de los Rangos de Fin son Mayores a los de Inicio<T>
[(Variables).Mavi.RM0074CapaD]
Carpeta=(Variables)
Clave=Mavi.RM0074CapaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0074CapaA]
Carpeta=(Variables)
Clave=Mavi.RM0074CapaA
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0074GrupoVehiculo]
Carpeta=(Variables)
Clave=Mavi.RM0074GrupoVehiculo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0074PuntoReunionVehicular]
Carpeta=(Variables)
Clave=Mavi.RM0074PuntoReunionVehicular
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0074ModeloVehiculo]
Carpeta=(Variables)
Clave=Mavi.RM0074ModeloVehiculo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S
[(Variables).Mavi.RM0074MarcaVehiculo]
Carpeta=(Variables)
Clave=Mavi.RM0074MarcaVehiculo
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0074TipoUnidadVehiculo]
Carpeta=(Variables)
Clave=Mavi.RM0074TipoUnidadVehiculo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S
[(Variables).Mavi.RM0074UsoVehicular]
Carpeta=(Variables)
Clave=Mavi.RM0074UsoVehicular
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0074NumUnidadVehicular]
Carpeta=(Variables)
Clave=Mavi.RM0074NumUnidadVehicular
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0074FechaAdqAsig]
Carpeta=(Variables)
Clave=Mavi.RM0074FechaAdqAsig
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0074LocalidadEdo]
Carpeta=(Variables)
Clave=Mavi.RM0074LocalidadEdo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S
[(Variables).Mavi.RM0074Estatus]
Carpeta=(Variables)
Clave=Mavi.RM0074Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S

