
[Forma]
Clave=RM1197COMSGenerarReporteFrm
Icono=134
Modulos=(Todos)
Nombre=<T>Generar Reporte<T>

ListaCarpetas=Principal
CarpetaPrincipal=Principal
PosicionInicialIzquierda=390
PosicionInicialArriba=411
PosicionInicialAlturaCliente=162
PosicionInicialAncho=500
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraAcciones=S
AccionesTamanoBoton=20x5
ListaAcciones=Reporte
AccionesCentro=S
AccionesDivision=S
ExpresionesAlMostrar=Asigna(Mavi.RM1197Familia,)<BR>Asigna(Mavi.RM1197Linea,)<BR>Asigna(Mavi.RM1197Tipo,)
[Principal]
Estilo=Ficha
Clave=Principal
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM1197Familia<BR>Mavi.RM1197Linea<BR>Mavi.RM1197Tipo
CarpetaVisible=S

[Principal.Mavi.RM1197Familia]
Carpeta=Principal
Clave=Mavi.RM1197Familia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=60
ColorFondo=Blanco

AccionAlEnter=
[Principal.Mavi.RM1197Linea]
Carpeta=Principal
Clave=Mavi.RM1197Linea
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=60
ColorFondo=Blanco

AccionAlEnter=
[Principal.Mavi.RM1197Tipo]
Carpeta=Principal
Clave=Mavi.RM1197Tipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=60
ColorFondo=Blanco

AccionAlEnter=
[Acciones.Reporte]
Nombre=Reporte
Boton=0
NombreEnBoton=S
NombreDesplegar=Generar Reporte
EnBarraAcciones=S
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Capturar<BR>Reporte<BR>LimpiarCampos
[Principal.Columnas]
0=376







[Acciones.Reporte.Capturar]
Nombre=Capturar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Reporte.Reporte]
Nombre=Reporte
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM1197COMSTiposFamiliaLineaRepTxt
Activo=S
Visible=S

[Acciones.Reporte.LimpiarCampos]
Nombre=LimpiarCampos
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Mavi.RM1197Familia,)<BR>Asigna(Mavi.RM1197Linea,)<BR>Asigna(Mavi.RM1197Tipo,)
Activo=S
Visible=S

