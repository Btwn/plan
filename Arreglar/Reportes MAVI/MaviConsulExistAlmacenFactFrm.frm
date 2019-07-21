[Forma]
Clave=MaviConsulExistAlmacenFactFrm
Nombre=RM0253 Consulta Existencias Almacen para Facturar
Icono=682
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar
PosicionInicialIzquierda=482
PosicionInicialArriba=436
PosicionInicialAlturaCliente=118
PosicionInicialAncho=315
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Mavi.RM0253OP,<T>Condensado<T>)<BR>Asigna(Mavi.FechaI,Nulo)<BR>Asigna(Mavi.FechaF,Nulo)
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
CarpetaVisible=S
ListaEnCaptura=Mavi.RM0253OP<BR>Mavi.FechaI<BR>Mavi.FechaF
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
[(Variables).Mavi.FechaF]
Carpeta=(Variables)
Clave=Mavi.FechaF
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
EjecucionCondicion=((Mavi.FechaI)<=(Mavi.FechaF))o (Vacio(Mavi.FechaI) y Vacio(Mavi.FechaF)) o (ConDatos(Mavi.FechaI) y Vacio(Mavi.FechaF))
EjecucionMensaje=<T>Proporcinar Correctamente las Fechas<T>
EjecucionConError=S
Visible=S
[(Variables).Mavi.RM0253OP]
Carpeta=(Variables)
Clave=Mavi.RM0253OP
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

