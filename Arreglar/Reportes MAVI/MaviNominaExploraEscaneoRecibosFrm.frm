[Forma]
Clave=MaviNominaExploraEscaneoRecibosFrm
Nombre=Explorador Escaneo Recibos de Nomina
Icono=152
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialAlturaCliente=1004
PosicionInicialAncho=1288
PosicionInicialIzquierda=-4
PosicionInicialArriba=-4
BarraHerramientas=S
BarraAcciones=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=CapturaDatos<BR>Escaneo de Recibos<BR>Cerrar<BR>ActualizaestatusBH<BR>Actualizar<BR>Reporte
AccionesDivision=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Maximizado
EsConsultaExclusiva=S
[Lista]
Estilo=Iconos
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
Zona=A1
Vista=MaviNominaExploraEscaneoRecibosVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=Empleado<BR>FechaRegistro<BR>Monto<BR>Estatus<BR>Comentario<BR>FechaEscaneo
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSubTitulo=<T>Periodo<T>
MenuLocal=S
ListaAcciones=ActualizaEstatus
BusquedaRapidaControles=S
FiltroFechas=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasCampo=FechaRegistro
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaAncho=20
FiltroIgnorarEmpresas=S
IconosConPaginas=S
BusquedaLocal=S
IconosNombre=MaviNominaExploraEscaneoRecibosVis:Periodo
[Lista.FechaRegistro]
Carpeta=Lista
Clave=FechaRegistro
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Monto]
Carpeta=Lista
Clave=Monto
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Comentario]
Carpeta=Lista
Clave=Comentario
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Estatus]
Carpeta=Lista
Clave=Estatus
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
EditarConBloqueo=N
[Lista.Columnas]
Empleado=64
FechaRegistro=155
Monto=64
Comentario=604
Estatus=154
UltimaModificacion=94
UsuarioModifico=304
0=53
1=62
2=87
3=91
4=210
5=265
6=90
7=104
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=<T>&Cerrar <T>
EnBarraAcciones=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Lista.Empleado]
Carpeta=Lista
Clave=Empleado
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.ActualizaEstatus]
Nombre=ActualizaEstatus
Boton=0
NombreDesplegar=Actualizar Estatus
EnMenu=S
TipoAccion=Formas
Activo=S
Visible=S
ClaveAccion=MaviNominaModificaEstatusRecibosNominaFrm
Multiple=S
ListaAccionesMultiples=AsignaML<BR>FormasML
[Acciones.ActualizaestatusBH]
Nombre=ActualizaestatusBH
Boton=12
NombreEnBoton=S
NombreDesplegar=<T>Actualizar &Estatus <T>
EnBarraHerramientas=S
TipoAccion=Formas
Activo=S
Visible=S
ClaveAccion=MaviNominaModificaEstatusRecibosNominaFrm
Multiple=S
ListaAccionesMultiples=AsignaBH<BR>FormaBH<BR>ActualizaDespues
[Acciones.ActualizaestatusBH.AsignaBH]
Nombre=AsignaBH
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Id,MaviNominaExploraEscaneoRecibosVis:Id)
[Acciones.ActualizaestatusBH.FormaBH]
Nombre=FormaBH
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=FormaModal(<T>MaviNominaModificaEstatusRecibosNominaFrm<T>)
[Acciones.ActualizaEstatus.AsignaML]
Nombre=AsignaML
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Id,MaviNominaExploraEscaneoRecibosVis:Id)
[Acciones.ActualizaEstatus.FormasML]
Nombre=FormasML
Boton=0
TipoAccion=Formas
ClaveAccion=MaviNominaModificaEstatusRecibosNominaFrm
Activo=S
Visible=S
[Acciones.Actualizar]
Nombre=Actualizar
Boton=82
NombreEnBoton=S
NombreDesplegar=<T>&Actualizar<T>
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.ActualizaestatusBH.ActualizaDespues]
Nombre=ActualizaDespues
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Escaneo de Recibos]
Nombre=Escaneo de Recibos
Boton=104
NombreDesplegar=<T>&Escaneo de Recibos<T>
EnBarraHerramientas=S
TipoAccion=Formas
Activo=S
Visible=S
NombreEnBoton=S
ClaveAccion=MaviNominaEscaneoRecibosNominaFrm
[Acciones.CapturaDatos]
Nombre=CapturaDatos
Boton=6
NombreEnBoton=S
NombreDesplegar=Captura Registros
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=MaviNominaCapturaImpresionEscaneoRecibosFrm
Activo=S
Visible=S
[Lista.FechaEscaneo]
Carpeta=Lista
Clave=FechaEscaneo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Reporte]
Nombre=Reporte
Boton=57
NombreEnBoton=S
NombreDesplegar=&Ver Reporte
EnBarraHerramientas=S
EnBarraAcciones=S
TipoAccion=Reportes Pantalla
ClaveAccion=MaviNomEdoReciboNomRep
Activo=S
Visible=S

