[Forma]
Clave=MaviFacturasEntregadasXQnaFrm
Nombre=RM259 Facturas Entregadas por Quincena
Icono=0
Modulos=(Todos)
ListaCarpetas=Variables
CarpetaPrincipal=Variables
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar
PosicionInicialIzquierda=495
PosicionInicialArriba=314
PosicionInicialAlturaCliente=113
PosicionInicialAncho=370
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
ExpresionesAlMostrar=Asigna(Info.Ejercicio,EjercicioTrabajo)<BR>Asigna(Info.Periodo,PeriodoTrabajo )<BR>Asigna(Mavi.Quincena2,<T>1 Quincena<T>)<BR>Asigna(Mavi.TipoMovVenInv,<T>Facturas<T>)
[Variables]
Estilo=Ficha
Clave=Variables
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
ListaEnCaptura=Info.Periodo<BR>Info.Ejercicio<BR>Mavi.Quincena2<BR>Mavi.TipoMovVenInv
PermiteEditar=S
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
[Variables.Info.Ejercicio]
Carpeta=Variables
Clave=Info.Ejercicio
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Variables.Info.Periodo]
Carpeta=Variables
Clave=Info.Periodo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Variables.Mavi.Quincena2]
Carpeta=Variables
Clave=Mavi.Quincena2
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Variables.Mavi.TipoMovVenInv]
Carpeta=Variables
Clave=Mavi.TipoMovVenInv
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
EjecucionCondicion=Condatos(Mavi.TipoMovVenInv)
EjecucionMensaje=<T>Seleccionar el Tipo de Movimiento<T>


