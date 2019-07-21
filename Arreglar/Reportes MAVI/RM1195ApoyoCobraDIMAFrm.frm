
[Forma]
Clave=RM1195ApoyoCobraDIMAFrm
Icono=0
Modulos=(Todos)
Nombre=RM1195 - Reporte Apoyo Cobranza DIMA

ListaCarpetas=Filtros
CarpetaPrincipal=Filtros
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=525
PosicionInicialArriba=272
PosicionInicialAlturaCliente=186
PosicionInicialAncho=316
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar
VentanaAvanzaTab=S
VentanaSinIconosMarco=S
ExpresionesAlMostrar=Asigna(Info.FechaD,PrimerDiaMes(Hoy))<BR>Asigna(Info.FechaA,UltimoDiaMes(Hoy))<BR>Asigna(Mavi.RM1195Movimiento,NULO)<BR>Asigna(Mavi.RM1195Estatus,NULO)<BR>Asigna(Mavi.RM1195Cliente,NULO)<BR>Asigna(Mavi.RM1195Beneficiario,NULO)
[Filtros]
Estilo=Ficha
Clave=Filtros
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Microsoft Sans Serif, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Blanco
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.FechaD<BR>Info.FechaA<BR>Mavi.RM1195Movimiento<BR>Mavi.RM1195Estatus<BR>Mavi.RM1195Cliente<BR>Mavi.RM1195Beneficiario
CarpetaVisible=S

ConFuenteEspecial=S
[Filtros.Info.FechaD]
Carpeta=Filtros
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20

ColorFondo=Blanco
EspacioPrevio=S
[Filtros.Info.FechaA]
Carpeta=Filtros
Clave=Info.FechaA
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Filtros.Mavi.RM1195Movimiento]
Carpeta=Filtros
Clave=Mavi.RM1195Movimiento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Filtros.Mavi.RM1195Estatus]
Carpeta=Filtros
Clave=Mavi.RM1195Estatus
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Filtros.Mavi.RM1195Cliente]
Carpeta=Filtros
Clave=Mavi.RM1195Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Filtros.Mavi.RM1195Beneficiario]
Carpeta=Filtros
Clave=Mavi.RM1195Beneficiario
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


[Acciones.Cerrar]
Nombre=Cerrar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
Activo=S
Visible=S
TipoAccion=Ventana
ClaveAccion=Cerrar

[Vista.Columnas]
0=19
1=165
2=-2

[Acciones.Excel.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Excel.Rep Excel]
Nombre=Rep Excel
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=RM1195ApoyoCobraDIMARepXls
Activo=S
Visible=S


[Acciones.Preliminar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Preliminar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Variables Asignar<BR>Aceptar
Activo=S
Visible=S

