[Forma]
Clave=RM0935CtesCatInstFrm
Icono=93
Modulos=(Todos)
ListaCarpetas=Instituciones<BR>CreditoMenudeo
CarpetaPrincipal=Instituciones
PosicionInicialAlturaCliente=704
PosicionInicialAncho=1177
PosicionInicialIzquierda=51
PosicionInicialArriba=143
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Filtr<BR>Actualizar<BR>Excel<BR>Cerrar<BR>Acercade
Nombre=RM0935 Explorador de Clientes Instituciones
Menus=S
PosicionSec1=768
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
Comentarios=Lista(<T>USUARIO: <T> + Usuario + <T> - <T> +Usuario.Nombre,FechaEnTexto(ahora,<T>dd-mmmm-aaaa<T>))
ExpresionesAlMostrar=Asigna(Mavi.NumCanalVenta,Nulo)
MenuPrincipal=Explorador<BR>Ayuda
[Explorador.Nombre]
Carpeta=Explorador
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Explorador.SeccionCobranza]
Carpeta=Explorador
Clave=SeccionCobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Explorador.Columnas]
0=94
1=255
2=109
3=182
4=-2
5=176
Cliente=64
Nombre=604
SeccionCobranza=304
UltimaModificacion=94
FechaUltimaModificacion=126
[Acciones.Excel]
Nombre=Excel
Boton=67
NombreEnBoton=S
NombreDesplegar=Enviar a E&xcel
EnBarraHerramientas=S
TipoAccion=Reportes Excel
ClaveAccion=RM0935CtesCatInstRep
Menu=Explorador
EnMenu=S
Visible=S
ActivoCondicion=Usuario.EnviarExcel
[Explorador.UltimaModificacion]
Carpeta=Explorador
Clave=UltimaModificacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Explorador.FechaUltimaModificacion]
Carpeta=Explorador
Clave=FechaUltimaModificacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Actualizar]
Nombre=Actualizar
Boton=82
NombreEnBoton=S
NombreDesplegar=&Actualizar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=F5
EnMenu=S
Menu=Explorador
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
Menu=Explorador
UsaTeclaRapida=S
TeclaRapida=Alt+F4
EnMenu=S
[DetalleCanales.Clave]
Carpeta=DetalleCanales
Clave=Clave
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[DetalleCanales.Columnas]
0=629
1=-2
[Explorador.Cliente]
Carpeta=Explorador
Clave=Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Acercade]
Nombre=Acercade
Boton=34
NombreEnBoton=S
NombreDesplegar=Acerca de..
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
Menu=Ayuda
UsaTeclaRapida=S
TeclaRapida=F1
TeclaFuncion=F1
Expresion=Vermensaje(<T>Acerca de Explorador de Clientes Instituciones<T>,<T>              Comercializadora de Muebles Am�rica S.A. de C.V.<T>+Nuevalinea+<T>__________________________________________________________<T>+NuevaLinea+NuevaLinea+<T>                        Explorador de Clientes Instituciones<T>+Nuevalinea+Nuevalinea+<T>Versi�n: V.2010.08.26<T>+NuevaLinea+<T>Autor: Moises Garcia. 12 de Enero de 2010<T>+NuevaLinea+<T>�ltima Modificaci�n por: Faustino L. Raygoza<T>+NuevaLinea+<T>__________________________________________________________<T>+NuevaLinea+Nuevalinea+<T>Descripci�n: El  explorador  de clientes  instituciones  muestra los  clientes<T>+NuevaLinea+<T>cuya  categor�a  de canal de  venta  sea  Instituciones,  filtrando en cada<T>+NuevaLinea+<T>pesta�a  por  la  secci�n  de  cobranza  <CONTINUA>
Expresion002=<CONTINUA>seg�n  sea  instituciones o cr�dito<T>+NuevaLinea+<T>menudeo. En la pesta�a de  cr�dito  menudeo solo se  muestran  aquellos<T>+NuevaLinea+<T>clientes que  hayan  pasado de la secci�n de  cobranza Instituciones a la<T>+Nuevalinea+<T>de cr�dito menudeo.<T>+NuevaLinea+NuevaLinea+<T> <T>+NuevaLinea+NuevaLinea+<T>______________________________________________________<T>+Nuevalinea+Nuevalinea+<T>Copyright � 2010 Comercializadora de Muebles Am�rica S.A. de C.V.<T>+NuevaLinea+<T>Derechos Reservados<T>+NuevaLinea+NuevaLinea+<T>El campo de b�squeda es por el No. de Cliente o el Nombre.<T>)
[Instituciones]
Estilo=Hoja
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Instituciones
Clave=Instituciones
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0935CtesCatInstVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Autom�tica
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Cliente<BR>Nombre<BR>CanalVenta<BR>SeccionCobranza<BR>Reg<BR>UltimaModificacion<BR>FechaUltimaModificacion
BusquedaRapidaControles=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaRespetarFiltros=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaAncho=20
BusquedaEnLinea=S
FiltroIgnorarEmpresas=S
HojaTitulosEnBold=S
ValidarCampos=S
ListaCamposAValidar=Clave<BR>NombreCanal
CarpetaVisible=S
[Instituciones.Cliente]
Carpeta=Instituciones
Clave=Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Instituciones.Nombre]
Carpeta=Instituciones
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Instituciones.SeccionCobranza]
Carpeta=Instituciones
Clave=SeccionCobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Instituciones.UltimaModificacion]
Carpeta=Instituciones
Clave=UltimaModificacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Instituciones.FechaUltimaModificacion]
Carpeta=Instituciones
Clave=FechaUltimaModificacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Instituciones.Columnas]
Cliente=64
Nombre=309
SeccionCobranza=303
UltimaModificacion=121
FechaUltimaModificacion=167
CEA.Cliente=64
CanalVenta=88
Reg=72
[CreditoMenudeo]
Estilo=Hoja
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Cr�dito Menudeo
Clave=CreditoMenudeo
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0935CtesCatInstCMVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Autom�tica
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Cliente<BR>Nombre<BR>CanalVenta<BR>SeccionCobranza<BR>Reg<BR>UltimaModificacion<BR>FechaUltimaModificacion
CarpetaVisible=S
BusquedaRapidaControles=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaRespetarFiltros=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaAncho=20
BusquedaEnLinea=S
FiltroIgnorarEmpresas=S
HojaTitulosEnBold=S
ValidarCampos=S
ListaCamposAValidar=Clave<BR>NombreCanal
[CreditoMenudeo.Cliente]
Carpeta=CreditoMenudeo
Clave=Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[CreditoMenudeo.Nombre]
Carpeta=CreditoMenudeo
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[CreditoMenudeo.SeccionCobranza]
Carpeta=CreditoMenudeo
Clave=SeccionCobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[CreditoMenudeo.UltimaModificacion]
Carpeta=CreditoMenudeo
Clave=UltimaModificacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[CreditoMenudeo.FechaUltimaModificacion]
Carpeta=CreditoMenudeo
Clave=FechaUltimaModificacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[CreditoMenudeo.Columnas]
Cliente=64
Nombre=309
SeccionCobranza=303
UltimaModificacion=121
FechaUltimaModificacion=167
CEA.Cliente=64
CanalVenta=88
Reg=72
[Instituciones.CanalVenta]
Carpeta=Instituciones
Clave=CanalVenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[CreditoMenudeo.CanalVenta]
Carpeta=CreditoMenudeo
Clave=CanalVenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Filtr]
Nombre=Filtr
Boton=107
NombreEnBoton=S
NombreDesplegar=&Filtrar...
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
Menu=Explorador
Expresion=Si Forma(<T>RM0935CtesFiltroCanFrm<T>) Entonces<BR>    Forma.ActualizarVista<BR>Fin
[Instituciones.Reg]
Carpeta=Instituciones
Clave=Reg
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[CreditoMenudeo.Reg]
Carpeta=CreditoMenudeo
Clave=Reg
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

