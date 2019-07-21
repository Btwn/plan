[Forma]
Clave=RM0944AvtasTop100InstFrm
Icono=126
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=478
PosicionInicialArriba=404
PosicionInicialAlturaCliente=78
PosicionInicialAncho=311
VentanaTipoMarco=Chico
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
Nombre=RM0944A Ventas Top 100 de Instituciones
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar
ExpresionesAlMostrar=Asigna(Info.FechaD,nulo)<BR>Asigna(Info.FechaA,nulo)
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
ListaEnCaptura=Info.FechaD<BR>Info.FechaA
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
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
EspacioPrevio=N
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
[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=rm0944AvtasTop100InstRep
Activo=S
Visible=S
[Acciones.Preliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
ConCondicion=S
EjecucionCondicion=((Info.FechaD)<=(Info.FechaA))o (Vacio(Info.FechaD)y Vacio(Info.FechaA)) o (ConDatos(Info.FechaD) y Vacio(Info.FechaA))
EjecucionMensaje=<T>La Fecha Inicial es Mayor a la Final, Seleccione Correctamente sus Fechas<T>
EjecucionConError=S
Visible=S

