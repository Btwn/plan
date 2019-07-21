[Forma]
Clave=DM0263EmpleadoZonaFrm
Icono=104
Modulos=(Todos)
PosicionInicialAlturaCliente=340
PosicionInicialAncho=482
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaConIcono=S
VentanaEstadoInicial=Normal
CarpetaPrincipal=DM0263EmpleadoZonaVis
ListaCarpetas=DM0263EmpleadoZonaVis
PosicionSec1=104
Nombre=<T>Agentes por Zona<T>
PosicionInicialIzquierda=399
PosicionInicialArriba=323
BarraAcciones=S
AccionesTamanoBoton=25x5
ListaAcciones=Guardar<BR>Cerrar
AccionesCentro=S
AccionesDivision=S
VentanaSinIconosMarco=S
ExpresionesAlMostrar=Asigna(Temp.Numerico3,0)
[DM0263EmpleadoZonaVis]
Estilo=Hoja
Pestana=S
Clave=DM0263EmpleadoZonaVis
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0263EmpleadoZonaVis
Fuente={Tahoma, 8, Negro, []}
CarpetaVisible=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
RefrescarAlEntrar=S
ListaEnCaptura=DM0263EmpleadoZona.Zona<BR>DM0263EmpleadoZona.Personal
PestanaOtroNombre=S
PestanaNombre=Empleados por Zona
AlinearTodaCarpeta=S
PermiteEditar=S
HojaTitulos=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Normal
OtroOrden=S
ListaOrden=DM0263EmpleadoZona.Zona<TAB>(Acendente)<BR>DM0263EmpleadoZona.Personal<TAB>(Acendente)
HojaConfirmarEliminar=S
HojaMostrarColumnas=S
[DM0263EmpleadoZonaVis.DM0263EmpleadoZona.Zona]
Carpeta=DM0263EmpleadoZonaVis
Clave=DM0263EmpleadoZona.Zona
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=N
Efectos=[Negritas]
[DM0263EmpleadoZonaVisP.DM0263EmpleadoZona.Personal]
Carpeta=DM0263EmpleadoZonaVisP
Clave=DM0263EmpleadoZona.Personal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[DM0263EmpleadoZonaVisP.Columnas]
Personal=124
[DM0263EmpleadoZonaVis.DM0263EmpleadoZona.Personal]
Carpeta=DM0263EmpleadoZonaVis
Clave=DM0263EmpleadoZona.Personal
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[Acciones.Guardar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar
Multiple=S
EnBarraAcciones=S
TipoAccion=Controles Captura
ListaAccionesMultiples=Asigna<BR>CamposNull<BR>Aviso<BR>Continue<BR>Guarda<BR>Limpiar
Activo=S
Visible=S
EspacioPrevio=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=21
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraAcciones=S
TipoAccion=Ventana
Activo=S
Visible=S
ClaveAccion=Cerrar
Multiple=S
ListaAccionesMultiples=Aviso<BR>Cancelar<BR>Cerrar
[Acciones.Guardar.Guarda]
Nombre=Guarda
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
[Acciones.Guardar.Limpiar]
Nombre=Limpiar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
[Acciones.Guardar.Aviso]
Nombre=Aviso
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=SI<BR>(SQL(<T>SELECT COUNT(Zona) FROM DM0263EmpleadoZona WITH (NOLOCK) WHERE Zona LIKE <T>+COMILLAS(DM0263EmpleadoZonaVis:DM0263EmpleadoZona.Zona)+<T> and Personal like <T>+ comillas(DM0263EmpleadoZonaVis:DM0263EmpleadoZona.Personal))>1) y<BR>(Longitud( Recorta(DM0263EmpleadoZonaVis:DM0263EmpleadoZona.Personal))>0) y  (Longitud( Recorta(DM0263EmpleadoZonaVis:DM0263EmpleadoZona.Zona))>0)<BR>ENTONCES<BR>     Informacion(<T>Ya se ha asignado la zona con anterioridad. Favor de verificar<T>)<BR>     Informacion(SQL(<T>SELECT COUNT(Zona) FROM DM0263EmpleadoZona WITH (NOLOCK) WHERE Zona LIKE <T>+COMILLAS(DM0263EmpleadoZonaVis:DM0263EmpleadoZona.Zona)+<T><T>))<BR>     AbortarOperacion<BR>SINO<BR>     Informacion(<T>Informacion guardada<T>)<BR>FIN
EjecucionCondicion=SQL(<T>SELECT COUNT(Zona) FROM DM0263EmpleadoZona WITH (NOLOCK) WHERE Zona LIKE <T>+COMILLAS(DM0263EmpleadoZonaVis:DM0263EmpleadoZona.Zona)+<T> and Personal like <T>+ comillas(DM0263EmpleadoZonaVis:DM0263EmpleadoZona.Personal))<2)<BR>y SQL(<T>SELECT COUNT(Zona) FROM DM0263EmpleadoZona WITH (NOLOCK) WHERE Zona LIKE <T>+COMILLAS(DM0263EmpleadoZonaVis:DM0263EmpleadoZona.Zona)+<T> and Personal not like <T>+ comillas(DM0263EmpleadoZonaVis:DM0263EmpleadoZona.Personal))<2)
EjecucionMensaje=<T>Se ha asignado dos veces la misma ZONA. Favor de verificar<T>
[Acciones.Guardar.CamposNull]
Nombre=CamposNull
Boton=0
TipoAccion=Expresion
ConCondicion=S
EjecucionConError=S
Expresion=ASIGNA(Temp.Numerico3,0)
EjecucionCondicion=(Longitud( Recorta(DM0263EmpleadoZonaVis:DM0263EmpleadoZona.Personal))>0) y  (Longitud( Recorta(DM0263EmpleadoZonaVis:DM0263EmpleadoZona.Zona))>0)
EjecucionMensaje=<T>Campos Vacios<T>
[Acciones.Guardar.Continue]
Nombre=Continue
Boton=0
TipoAccion=expresion
Activo=S
ConCondicion=S
Visible=S
EjecucionCondicion=Longitud(DM0263EmpleadoZonaVis:DM0263EmpleadoZona.Personal)>0 y Longitud(DM0263EmpleadoZonaVis:DM0263EmpleadoZona.Zona)>0
EjecucionMensaje=<T>NO ES 1<T>
[ListaEmpleados.Columnas]
0=-2
1=-2
[HojaListado.DM0263EmpleadoZona.Personal]
Carpeta=HojaListado
Clave=DM0263EmpleadoZona.Personal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[HojaListado.DM0263EmpleadoZona.Zona]
Carpeta=HojaListado
Clave=DM0263EmpleadoZona.Zona
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[HojaListado.Columnas]
0=-2
1=-2
[DM0263EmpleadoZonaVis.Columnas]
Personal=144
Zona=74
[Acciones.Cerrar.Aviso]
Nombre=Aviso
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=Asigna(Temp.Numerico1,0)<BR>SI<BR>    Temp.Numerico3>0<BR>ENTONCES<BR>    SI<BR>        Confirmacion(<T>Cerrara sin guardar las últimas modificaciones realizadas.<T>+NuevaLinea+<T>¿Esta de acuerdo?<T>,BotonSi,BotonNo) = BotonSi<BR>    Entonces<BR>        Asigna(Temp.Numerico1,25)<BR>    SINO<BR>        Asigna(Temp.Numerico1,556)<BR>        AbortarOperacion<BR>    FIN<BR>SINO<BR>    Asigna(Temp.Numerico1,25)<BR>FIN
[Acciones.Cerrar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=ventana
ClaveAccion=cerrar
Activo=S
Visible=S
[Acciones.Cerrar.Cancelar]
Nombre=Cancelar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=Temp.Numerico1 = 25

