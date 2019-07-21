[Forma]
Clave=RM0948CxcExpEntInstFrm
Icono=122
Modulos=(Todos)
PosicionInicialAlturaCliente=731
PosicionInicialAncho=1151
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=Explora
CarpetaPrincipal=Explora
PosicionInicialIzquierda=64
PosicionInicialArriba=127
ListaAcciones=(Lista)
Nombre=RM0948 Análisis de Enteros de Instituciones (Explorador)
Comentarios=<T>Ejercicio: <T> & Info.Ejercicio & <T>, Periodo: <T> & Info.Periodo & <T>, Canal de Venta: <T> & Mavi.NumCanalVenta & <T>, Coincidencia: <T> & Vacio(Mavi.RM0948Coincide,<T>Todos<T>) & <T>, Aplicación: <T> & Vacio(Mavi.RM0948Aplicado,<T>Todos<T>) & <T>.<T>
[Explora]
Estilo=Iconos
Clave=Explora
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0948CxcExpEntInstVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=Ejercicio<BR>Periodo<BR>Quincena<BR>Institucion<BR>NomRFC<BR>Cuenta<BR>Nombre<BR>Importe<BR>Aplicado<BR>Saldo<BR>ObservacionesCte<BR>CuentasRep
BusquedaRapidaControles=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaRespetarControles=S
BusquedaEnLinea=S
PestanaOtroNombre=S
PestanaNombre=Registros
IconosCampo=Ico
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Canal de Venta<T>
ElementosPorPagina=200
BusquedaRespetarFiltros=S
RefrescarAlEntrar=S
IconosNombre=RM0948CxcExpEntInstVis:Canal
[Explora.Columnas]
Canal=64
Institucion=304
Periodo=64
Ejercicio=64
NomRFC=124
Cuenta=64
Nombre=604
Importe=64
Aplicado=64
Saldo=64
ObservacionesCte=604
CuentasRep=72
Ico=64
0=85
1=51
2=48
3=64
4=156
5=67
6=259
7=77
8=77
9=74
10=263
11=303
12=-2
[Explora.Ejercicio]
Carpeta=Explora
Clave=Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Explora.Periodo]
Carpeta=Explora
Clave=Periodo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Explora.Institucion]
Carpeta=Explora
Clave=Institucion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Explora.NomRFC]
Carpeta=Explora
Clave=NomRFC
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Explora.Cuenta]
Carpeta=Explora
Clave=Cuenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Explora.Nombre]
Carpeta=Explora
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Explora.Importe]
Carpeta=Explora
Clave=Importe
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Totalizador=1
[Explora.Aplicado]
Carpeta=Explora
Clave=Aplicado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Totalizador=1
[Explora.Saldo]
Carpeta=Explora
Clave=Saldo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Totalizador=1
[Explora.ObservacionesCte]
Carpeta=Explora
Clave=ObservacionesCte
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Explora.CuentasRep]
Carpeta=Explora
Clave=CuentasRep
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.FiltrosExp]
Nombre=FiltrosExp
Boton=107
NombreEnBoton=S
NombreDesplegar=&Filtros...
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
Antes=S
Expresion=Si Forma(<T>RM0948CxcAnEntInstFrm<T>) Entonces<BR>    Si<BR>        Mavi.DM0500BCuotasPer=<T>DETALLE<T><BR>    Entonces<BR>        Forma(<T>RM0948DetalleEntInstFrm<T>)<BR>        Forma.Accion(<T>CerrarV<T>)<BR>    Sino<BR>        Forma.ActualizarVista<BR>        Forma.ActualizarForma<BR>    FIN <BR>Fin
AntesExpresiones=Asigna(Info.Conteo,Info.Conteo+1)
[Acciones.CerrarV]
Nombre=CerrarV
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
EspacioPrevio=S
[Acciones.RepPrel]
Nombre=RepPrel
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Reportes Pantalla
ClaveAccion=RM0948CxcExpEntInstRep
Activo=S
Visible=S
[Acciones.EnvExcel]
Nombre=EnvExcel
Boton=67
NombreDesplegar=Enviar a E&xcel
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Enviar a Excel
Activo=S
Visible=S
NombreEnBoton=S
[Explora.Quincena]
Carpeta=Explora
Clave=Quincena
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro








[Acciones.TxT]
Nombre=TxT
Boton=54
NombreDesplegar=&Enviar Txt
EnBarraHerramientas=S
Activo=S
Visible=S



TipoAccion=Reportes Impresora








NombreEnBoton=S








ClaveAccion=RM0948ConTXT


[Forma.ListaAcciones]
(Inicio)=FiltrosExp
FiltrosExp=RepPrel
RepPrel=EnvExcel
EnvExcel=TxT
TxT=CerrarV
CerrarV=(Fin)

