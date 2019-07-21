[Forma]
Clave=RM1133AReporteRedDIMAFrm
Icono=136
Modulos=(Todos)
ListaCarpetas=rama
CarpetaPrincipal=rama
PosicionInicialIzquierda=331
PosicionInicialArriba=437
PosicionInicialAlturaCliente=165
PosicionInicialAncho=286
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
AccionesTamanoBoton=15x5
ListaAcciones=Aceptar<BR>Cerrar
AccionesCentro=S
Nombre=Estructura Red DIMA
BarraHerramientas=S
ExpresionesAlMostrar=Asigna( Mavi.RM1133FechaFin, Hoy ),<BR>Asigna( Mavi.RM1133FechaIni,Hoy ),<BR>Asigna(Mavi.RM1133DimaR, <T><T>)
[rama]
Estilo=Ficha
Clave=rama
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Microsoft Sans Serif, 8, Negro, []}
FichaEspacioEntreLineas=9
FichaEspacioNombres=52
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=$FFFFFFFF
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM1133DimaR<BR>Mavi.RM1133FechaIni<BR>Mavi.RM1133FechaFin
CarpetaVisible=S
PestanaNombre=Selección de filtros
PestanaOtroNombre=S
[rama.Mavi.RM1133DimaR]
Carpeta=rama
Clave=Mavi.RM1133DimaR
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=$FFFFFFFF
EspacioPrevio=N
Efectos=[Negritas]
[Acciones.Aceptar]
Nombre=Aceptar
Boton=108
NombreDesplegar=&Mostrar Reporte
Activo=S
Visible=S
NombreEnBoton=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Multiple=S
ListaAccionesMultiples=Aceptar<BR>Mensaje
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
EnBarraHerramientas=S

[Acciones.Aceptar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=ReportePantalla(<T>RM1133AReporteRedDIMARep<T>)
EjecucionCondicion=(ConDatos(Mavi.RM1133DimaR)) y (ConDatos(Mavi.RM1133Ejercicio)) y (ConDatos(Mavi.RM1133Quincena))
EjecucionMensaje=<T>Favor de especificar el DimaR, Ejercicio y Quincena.<T>
[Acciones.Aceptar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.Mensaje]
Nombre=Mensaje
Boton=0
TipoAccion=Ventana
Activo=S
ConCondicion=S
EjecucionConError=S
Visible=S
ClaveAccion=Seleccionar/Aceptar

EjecucionCondicion=(ConDatos(Mavi.RM1133DimaR)) y (ConDatos(Mavi.RM1133FechaIni)) y (ConDatos(Mavi.RM1133FechaFin))
EjecucionMensaje=<T>Favor de especificar la Cuenta y las fechas a consultar<T>
[rama.Columnas]
DimaR=94
Nombre=604

[rama.Mavi.RM1133FechaIni]
Carpeta=rama
Clave=Mavi.RM1133FechaIni
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[rama.Mavi.RM1133FechaFin]
Carpeta=rama
Clave=Mavi.RM1133FechaFin
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

