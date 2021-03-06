[Forma]
Clave=DM0263DisSucGeoFrm
Nombre=Distribucion Geografica de Sucursales
Icono=455
Modulos=(Todos)
PosicionInicialAlturaCliente=460
PosicionInicialAncho=300
PosicionInicialIzquierda=490
PosicionInicialArriba=263
ListaCarpetas=Informacion
CarpetaPrincipal=Informacion
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraAcciones=S
AccionesTamanoBoton=25x5
ListaAcciones=Guardar<BR>Cancelar
AccionesCentro=S
PosicionSec1=104
PosicionSec2=198
VentanaSinIconosMarco=S
ExpresionesAlMostrar=Asigna(Temp.Numerico3,0)
[Informacion]
Estilo=Hoja
Clave=Informacion
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0263DisSucGeoVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DM0263DisSucGeo.IDSucursal<BR>DM0263DisSucGeo.Zona
CarpetaVisible=S
PestanaNombre=Nuevo
OtroOrden=S
ListaOrden=DM0263DisSucGeo.Zona<TAB>(Acendente)<BR>DM0263DisSucGeo.IDSucursal<TAB>(Acendente)
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Autom�tica
RefrescarAlEntrar=S
HojaConfirmarEliminar=S
[Informacion.DM0263DisSucGeo.IDSucursal]
Carpeta=Informacion
Clave=DM0263DisSucGeo.IDSucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S
Efectos=[Negritas]
EditarConBloqueo=S
[Informacion.DM0263DisSucGeo.Zona]
Carpeta=Informacion
Clave=DM0263DisSucGeo.Zona
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=N
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[Acciones.Guardar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
Activo=S
Visible=S
ClaveAccion=Guardar Cambios
ConCondicion=S
EjecucionCondicion=LONGITUD(DM0263DisSucGeoVis:DM0263DisSucGeo.IDSucursal)>0 Y LONGITUD(DM0263DisSucGeoVis:DM0263DisSucGeo.Zona)>0
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreDesplegar=&Guardar
Multiple=S
EnBarraAcciones=S
ListaAccionesMultiples=Asignar<BR>CamposNull<BR>ExitsSuc<BR>Aviso<BR>Guardar<BR>ActualizarForma
Activo=S
Visible=S
NombreEnBoton=S
[Acciones.Cancelar]
Nombre=Cancelar
Boton=21
NombreDesplegar=&Cerrar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
NombreEnBoton=S
Multiple=S
ListaAccionesMultiples=AVISO<BR>CONDICION<BR>CERRAR
[Acciones.Guardar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Guardar.Aviso]
Nombre=Aviso
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
ConCondicion=S
Expresion=SI (SQL(<T>SELECT COUNT(IDSucursal) FROM DM0263DisSucGeo C WHERE C.IDSucursal =:nSuc <T>,DM0263DisSucGeoVis:DM0263DisSucGeo.IDSucursal)<2)<BR>ENTONCES<BR>    Informacion(<T>Informacion Guardada<T>)<BR>    Asigna(Temp.Numerico3,0)<BR>SINO<BR>    Informacion(<T>La sucursal ya ha sido capturada con anterioridad<T>)<BR>    AbortarOperacion<BR>FIN
EjecucionCondicion=Longitud(DM0263DisSucGeoVis:DM0263DisSucGeo.IDSucursal)>0 y Longitud(DM0263DisSucGeoVis:DM0263DisSucGeo.Zona)>0 y<BR>SQL(<T>select COUNT(sucursal) from Sucursal where Sucursal = :nSuc<T>,DM0263DisSucGeoVis:DM0263DisSucGeo.IDSucursal)>0
EjecucionMensaje=<T>AQUI TRUENA<T>
[Acciones.Guardar.CamposNull]
Nombre=CamposNull
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=SI<BR>   no( Longitud(DM0263DisSucGeoVis:DM0263DisSucGeo.IDSucursal)>0 y Longitud(DM0263DisSucGeoVis:DM0263DisSucGeo.Zona)>0)<BR>ENTONCES<BR>    INFORMACION(<T>Existen Campos Vacios<T>)<BR>    AbortarOperacion<BR>FIN
[Acciones.Guardar.ExitsSuc]
Nombre=ExitsSuc
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=SI<BR>    SQL(<T>select COUNT(sucursal) from Sucursal where Sucursal = :nSuc<T>,DM0263DisSucGeoVis:DM0263DisSucGeo.IDSucursal)=0 y<BR>    Longitud(DM0263DisSucGeoVis:DM0263DisSucGeo.IDSucursal)>0 y<BR>    Longitud(DM0263DisSucGeoVis:DM0263DisSucGeo.Zona)>0<BR>ENTONCES<BR>    INFORMACION(<T>La sucursal no existe. Favor de revisar el dato capturado.<T>)<BR>    AbortarOperacion<BR>FIN
[Listado.DM0263DisSucGeo.IDSucursal]
Carpeta=Listado
Clave=DM0263DisSucGeo.IDSucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Listado.DM0263DisSucGeo.Zona]
Carpeta=Listado
Clave=DM0263DisSucGeo.Zona
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Informacion.Columnas]
IDSucursal=74
Zona=74
[ListaSucursales.DM0263DisSucGeo.IDSucursal]
Carpeta=ListaSucursales
Clave=DM0263DisSucGeo.IDSucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[ListaSucursales.DM0263DisSucGeo.Zona]
Carpeta=ListaSucursales
Clave=DM0263DisSucGeo.Zona
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[ListaSucursales.Columnas]
0=154
1=95
2=-2
[HojaVista.DM0263DisSucGeo.IDSucursal]
Carpeta=HojaVista
Clave=DM0263DisSucGeo.IDSucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[HojaVista.DM0263DisSucGeo.Zona]
Carpeta=HojaVista
Clave=DM0263DisSucGeo.Zona
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[HojaVista.Columnas]
IDSucursal=98
Zona=152
[Acciones.Guardar.ActualizarForma]
Nombre=ActualizarForma
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
[Acciones.Cancelar.AVISO]
Nombre=AVISO
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Temp.Numerico1,0)<BR>SI<BR>    Temp.Numerico3 > 0<BR>ENTONCES<BR>    SI<BR>        Confirmacion(<T>Cerrara sin guardar las �ltimas modificaciones realizadas.<T>+NuevaLinea+<T>�Esta de acuerdo?<T>,BotonSi,BotonNo) = BotonSi<BR>    Entonces<BR>        Asigna(Temp.Numerico1,25)<BR>    SINO<BR>        Asigna(Temp.Numerico1,556)<BR>        AbortarOperacion<BR>    FIN<BR>SINO<BR>    Asigna(Temp.Numerico1,25)<BR>FIN
[Acciones.Cancelar.CONDICION]
Nombre=CONDICION
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
ConCondicion=S
Visible=S
EjecucionCondicion=Temp.Numerico1 = 25
[Acciones.Cancelar.CERRAR]
Nombre=CERRAR
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

