
[Forma]
Clave=DM0207EstatusCobroBeneficiarioFrm
Icono=90
BarraAcciones=S
Modulos=(Todos)
Nombre=Estatus Cobro Beneficiario
AccionesTamanoBoton=20x5

ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=544
PosicionInicialArriba=320
PosicionInicialAlturaCliente=74
PosicionInicialAncho=317
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=asigna(Mavi.DM0207EstatusCobroCteFinal,<T><T>)
ListaAcciones=GenerarReporte
AccionesCentro=S
[(Variables)]
Estilo=Ficha
Clave=(Variables)
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
ListaEnCaptura=Mavi.DM0207EstatusCobroCteFinal
CarpetaVisible=S

[(Variables).Mavi.DM0207EstatusCobroCteFinal]
Carpeta=(Variables)
Clave=Mavi.DM0207EstatusCobroCteFinal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Estatus.Columnas]
0=52
1=-2

[Acciones.GenerarReporte]
Nombre=GenerarReporte
Boton=0
NombreDesplegar=Generar &Reporte
EnBarraAcciones=S
TipoAccion=Reportes Impresora
Activo=S
Visible=S
NombreEnBoton=S
Multiple=S
EspacioPrevio=S

ListaAccionesMultiples=asigna<BR>reporte
[Acciones.GenerarReporte.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.GenerarReporte.reporte]
Nombre=reporte
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=DM0207CXCAsigCtasDetalleEstatusCteFinalTXT
Activo=S
Visible=S

