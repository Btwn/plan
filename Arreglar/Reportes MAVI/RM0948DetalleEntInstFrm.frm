[Forma]
Clave=RM0948DetalleEntInstFrm
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
Vista=RM0948DetalleEntInstVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
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
BusquedaRespetarFiltros=S
RefrescarAlEntrar=S
ListaEnCaptura=(Lista)
IconosCampo=Ico
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSubTitulo=<T>Canal de Venta<T>
IconosNombre=RM0948DetalleEntInstVis:Canal
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











13=-2
14=-2
15=-2
16=-2
17=-2
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
Expresion=Si Forma(<T>RM0948CxcAnEntInstFrm<T>) Entonces<BR>    Si<BR>        Mavi.DM0500BCuotasPer=<T>DETALLE<T><BR>    Entonces<BR>        Forma.ActualizarVista<BR>        Forma.ActualizarForma<BR>    Sino<BR>        Forma(<T>RM0948CxcExpEntInstFrm<T>)<BR>        Forma.Accion(<T>CerrarV<T>)<BR>    FIN <BR>Fin
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
ClaveAccion=RM0948DetalleEntInstRep
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

[Explora.Periodo]
Carpeta=Explora
Clave=Periodo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Explora.Ejercicio]
Carpeta=Explora
Clave=Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Explora.Quincena]
Carpeta=Explora
Clave=Quincena
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
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

[Explora.Aplicado]
Carpeta=Explora
Clave=Aplicado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Explora.Saldo]
Carpeta=Explora
Clave=Saldo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

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

[Explora.Mov]
Carpeta=Explora
Clave=Mov
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Explora.Folio]
Carpeta=Explora
Clave=Folio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Explora.MovPadre]
Carpeta=Explora
Clave=MovPadre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Explora.FolioPadre]
Carpeta=Explora
Clave=FolioPadre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro









[Acciones.TxT]
Nombre=TxT
Boton=54
NombreEnBoton=S
NombreDesplegar=&Enviar Txt
EnBarraHerramientas=S
TipoAccion=Reportes Impresora
ClaveAccion=RM0948DetTXT
Activo=S
Visible=S









[Explora.ImporteCobro]
Carpeta=Explora
Clave=ImporteCobro
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro


[Explora.ListaEnCaptura]
(Inicio)=Ejercicio
Ejercicio=Periodo
Periodo=Quincena
Quincena=Institucion
Institucion=NomRFC
NomRFC=Cuenta
Cuenta=Nombre
Nombre=Importe
Importe=Aplicado
Aplicado=Saldo
Saldo=ObservacionesCte
ObservacionesCte=CuentasRep
CuentasRep=ImporteCobro
ImporteCobro=Mov
Mov=Folio
Folio=MovPadre
MovPadre=FolioPadre
FolioPadre=(Fin)





[Forma.ListaAcciones]
(Inicio)=FiltrosExp
FiltrosExp=RepPrel
RepPrel=EnvExcel
EnvExcel=TxT
TxT=CerrarV
CerrarV=(Fin)

