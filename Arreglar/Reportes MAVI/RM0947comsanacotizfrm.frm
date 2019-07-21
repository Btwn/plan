[Forma]
Clave=RM0947Comsanacotizfrm
Nombre=RM0947 Analisis de Cotizaciones
Icono=0
Modulos=(Todos)
CarpetaPrincipal=(variables)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar<BR>autorefresca
ListaCarpetas=(variables)
PosicionInicialIzquierda=496
PosicionInicialArriba=406
PosicionInicialAlturaCliente=153
PosicionInicialAncho=313
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
VentanaEscCerrar=S
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(Info.FechaD,hoy)<BR>Asigna(Info.FechaA,hoy)            <BR>asigna(mavi.rm0947concepto,nulo)<BR>asigna(mavi.rm0947movimiento,nulo)
[Acciones.preliminar.asignar]
Nombre=Asignar
Boton=0
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
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
ListaAccionesMultiples=Asignar<BR>CERRAR
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=condatos(mavi.rm0947movimiento)
EjecucionMensaje=<T>Debe seleccionar un movimiento<T>
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
NombreEnBoton=S

[(variables)]
Estilo=Ficha
Clave=(variables)
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=mavi.RM0947concepto<BR>Info.FechaD<BR>Info.FechaA<BR>mavi.RM0947movimiento
CarpetaVisible=S
[(variables).mavi.RM0947concepto]
Carpeta=(variables)
Clave=mavi.RM0947concepto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(variables).Info.FechaA]
Carpeta=(variables)
Clave=Info.FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(variables).Info.FechaD]
Carpeta=(variables)
Clave=Info.FechaD
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S
[(variables).mavi.RM0947movimiento]
Carpeta=(variables)
Clave=mavi.RM0947movimiento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.autorefresca]
Nombre=autorefresca
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
ConAutoEjecutar=S
Multiple=S
ListaAccionesMultiples=asigna<BR>autorefresca
RefrescarDespues=S
GuardarAntes=S
Visible=S
NombreDesplegar=&auto
EnBarraHerramientas=S
AutoEjecutarExpresion=1
[Acciones.Preliminar.CERRAR]
Nombre=CERRAR
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
[Acciones.autorefresca.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.autorefresca.autorefresca]
Nombre=autorefresca
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>UEN<T>)<BR>Asigna(Mavi.UENs,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))
Activo=S
Visible=S


