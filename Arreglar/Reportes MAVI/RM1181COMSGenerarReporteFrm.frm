
[Forma]
Clave=RM1181COMSGenerarReporteFrm
Icono=134
Modulos=(Todos)

ListaCarpetas=Captura
CarpetaPrincipal=Captura
PosicionInicialIzquierda=512
PosicionInicialArriba=392
PosicionInicialAlturaCliente=201
PosicionInicialAncho=255
Nombre=<T>Reportes<T>
PosicionSec1=50
AccionesTamanoBoton=20x5
ListaAcciones=Reporte<BR>Capturar
AccionesCentro=S
AccionesDivision=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraAcciones=S
ExpresionesAlMostrar=Asigna(Mavi.RM1181Proveedor,)<BR>Asigna(Mavi.RM1181Familia,)<BR>Asigna(Mavi.RM1181Movimiento,)<BR>Asigna(Mavi.RM1181FechaD,)<BR>Asigna(Mavi.RM1181FechaA,)
[Captura]
Estilo=Ficha
Clave=Captura
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM1181FechaD<BR>Mavi.RM1181FechaA<BR>Mavi.RM1181Proveedor<BR>Mavi.RM1181Movimiento<BR>Mavi.RM1181Familia
CarpetaVisible=S

FichaEspacioEntreLineas=8
FichaEspacioNombres=0
FichaColorFondo=Plata
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaEspacioNombresAuto=S
PermiteEditar=S
[Captura.Mavi.RM1181FechaD]
Carpeta=Captura
Clave=Mavi.RM1181FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Captura.Mavi.RM1181FechaA]
Carpeta=Captura
Clave=Mavi.RM1181FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Captura.Mavi.RM1181Proveedor]
Carpeta=Captura
Clave=Mavi.RM1181Proveedor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

AccionAlEnter=Capturar
[Captura.Mavi.RM1181Movimiento]
Carpeta=Captura
Clave=Mavi.RM1181Movimiento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Captura.Mavi.RM1181Familia]
Carpeta=Captura
Clave=Mavi.RM1181Familia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[SeleccionarProveedor.Columnas]
Proveedor=64
Nombre=604

[Vista.Columnas]
0=-2


[Acciones.Reporte.variables Asignar]
Nombre=variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


[Acciones.Capturar]
Nombre=Capturar
Boton=0
NombreDesplegar=Capturar
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S




[Acciones.Reporte]
Nombre=Reporte
Boton=0
NombreEnBoton=S
NombreDesplegar=Generar Reporte
EnBarraAcciones=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Reporte
ConCondicion=S
EjecucionCondicion=Forma.Accion(<T>Capturar<T>)<BR>Si(ConDatos(Mavi.RM1181FechaD),Verdadero,Informacion(<T>Debe llenar el campo <De la fecha><T>)AbortarOperacion)<BR>Si(ConDatos(Mavi.RM1181FechaA),Verdadero,Informacion(<T>Debe llenar el campo <A la fecha><T>)AbortarOperacion)<BR>Si(ConDatos(Mavi.RM1181Proveedor),Verdadero,Informacion(<T>Debe llenar el campo <Proveedor><T>)AbortarOperacion)<BR>Si(ConDatos(Mavi.RM1181Familia),Verdadero,Informacion(<T>Debe llenar el campo <Familia><T>)AbortarOperacion)
[Acciones.Reporte.Reporte]
Nombre=Reporte
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S





