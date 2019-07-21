[Forma]
Clave=DM0266CalendarioDistribucionCD
Icono=0
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=VisualizarCalendario<BR>CrearCalendario<BR>ModificarCalendario<BR>CerrarForma
ListaCarpetas=Principal
CarpetaPrincipal=Principal
PosicionInicialIzquierda=389
PosicionInicialArriba=479
PosicionInicialAlturaCliente=27
PosicionInicialAncho=501
Nombre=Calendario de Distribucion
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaEscCerrar=S
VentanaSinIconosMarco=S
[Acciones.VisualizarCalendario]
Nombre=VisualizarCalendario
Boton=73
NombreEnBoton=S
NombreDesplegar=Visualizar Calendario   .     
EnBarraHerramientas=S
TipoAccion=Formas
Activo=S
Visible=S
ClaveAccion=DM0266ListaCalendariosMostrar
EspacioPrevio=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=SQL(<T>select distinct COUNT(Titulo) from DM0266CalendarioDistribucionActual<T>)>0
EjecucionMensaje=<T>No existen Calendarios Creados<T>
[Acciones.CrearCalendario]
Nombre=CrearCalendario
Boton=41
NombreEnBoton=S
NombreDesplegar=Crear Calendario   .     
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=DM0266CrearCalendario
Visible=S
EspacioPrevio=S
ActivoCondicion=SQL(<T>Select dbo.FN_DM0266VerAcceso (<T>+comillas(Usuario)+<T>)<T>)=1
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=SQL(<T>select distinct COUNT(Titulo) from DM0266CalendarioDistribucionActual<T>)<1
EjecucionMensaje=<T>Ya existe un calendario creado<T>
[Principal]
Estilo=Ficha
Clave=Principal
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
CampoColorFondo=Negro
CarpetaVisible=S
[Acciones.ModificarCalendario]
Nombre=ModificarCalendario
Boton=78
NombreEnBoton=S
NombreDesplegar=Modificar Calendario   .      
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=DM0266ListaCalendariosModificar
Visible=S
EspacioPrevio=S
ConCondicion=S
EjecucionConError=S
ActivoCondicion=SQL(<T>Select dbo.FN_DM0266VerAcceso (<T>+comillas(Usuario)+<T>)<T>)=1
EjecucionCondicion=SQL(<T>select distinct COUNT(Titulo) from DM0266CalendarioDistribucionActual<T>)>0
EjecucionMensaje=<T>No existen Calendarios Creados<T>
[Acciones.ModificarCalendario.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.ModificarCalendario.abrir forma]
Nombre=abrir forma
Boton=0
TipoAccion=Formas
ClaveAccion=DM0266ModificarCalendario
Activo=S
Visible=S
[Acciones.CerrarForma]
Nombre=CerrarForma
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar      .
EnBarraHerramientas=S
EnMenu=S
EnBarraAcciones=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


