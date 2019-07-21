[Forma]
Clave=RM1098DepositosInstFrm
Nombre=RM1098DepositosInstFrm
Icono=0
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=filtros
CarpetaPrincipal=filtros
PosicionInicialIzquierda=276
PosicionInicialArriba=355
PosicionInicialAlturaCliente=125
PosicionInicialAncho=551
VentanaTipoMarco=Chico
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ListaAcciones=Generar Reporte<BR>Imprimir<BR>Excel
PosicionSec1=99
ExpresionesAlMostrar=Asigna( Info.FechaD,   PrimerDiaMes( Hoy )  )<BR>Asigna( Info.FechaA,  UltimoDiaMes( Hoy ))<BR>Asigna( Info.CtaDinero, <T><T> )<BR>Asigna( Mavi.RM1098ConceptoDep, <T><T> )<BR>Asigna( Mavi.RM1098FechaDepReal, <T><T> )
[grid.Columnas]
MovID=59
Mov=82
FechaEmision=76
Importe=91
referencia=244
usuario=78
Observaciones=305
CtaDinero=96
Descripcion=208
Concepto=145
[Acciones.Imprimir]
Nombre=Imprimir
Boton=4
NombreEnBoton=S
NombreDesplegar=Imprimir&
EnBarraHerramientas=S
TipoAccion=Reportes Impresora
ClaveAccion=RM1098DepositosInstRep
Activo=S
Visible=S
EspacioPrevio=S
Multiple=S
ListaAccionesMultiples=asignar<BR>imp
[Acciones.Excel]
Nombre=Excel
Boton=115
NombreEnBoton=S
NombreDesplegar=Excel&
EnBarraHerramientas=S
TipoAccion=Reportes Excel
ClaveAccion=RM1098DepositosInstRep
Activo=S
Visible=S
EspacioPrevio=S
Multiple=S
ListaAccionesMultiples=asignar<BR>excel
[filtros]
Estilo=Ficha
Clave=filtros
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
ListaEnCaptura=Info.FechaD<BR>Info.FechaA<BR>Info.CtaDinero<BR>Mavi.RM1098ConceptoDep<BR>Mavi.RM1098FechaDepReal
CarpetaVisible=S
PermiteEditar=S
[filtros.Info.FechaD]
Carpeta=filtros
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[filtros.Info.FechaA]
Carpeta=filtros
Clave=Info.FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[filtros.Info.CtaDinero]
Carpeta=filtros
Clave=Info.CtaDinero
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[grid.MovID]
Carpeta=grid
Clave=MovID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[grid.Mov]
Carpeta=grid
Clave=Mov
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[grid.FechaEmision]
Carpeta=grid
Clave=FechaEmision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[grid.Importe]
Carpeta=grid
Clave=Importe
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[grid.CtaDinero]
Carpeta=grid
Clave=CtaDinero
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[grid.Descripcion]
Carpeta=grid
Clave=Descripcion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[grid.Concepto]
Carpeta=grid
Clave=Concepto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[grid.referencia]
Carpeta=grid
Clave=referencia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[grid.usuario]
Carpeta=grid
Clave=usuario
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[grid.Observaciones]
Carpeta=grid
Clave=Observaciones
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Filtrar.asignar]
Nombre=asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Filtrar.actualizar]
Nombre=actualizar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[filtros.Mavi.RM1098ConceptoDep]
Carpeta=filtros
Clave=Mavi.RM1098ConceptoDep
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[filtros.Mavi.RM1098FechaDepReal]
Carpeta=filtros
Clave=Mavi.RM1098FechaDepReal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Reporte.asignar]
Nombre=asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Reporte.reporte]
Nombre=reporte
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=RM1098DepositosInstRep
Activo=S
Visible=S
[Acciones.PDF.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.PDF.PDF]
Nombre=PDF
Boton=0
TipoAccion=Reportes PDF
ClaveAccion=RM1098DepositosInstRep
Activo=S
Visible=S
[Acciones.Generar Reporte]
Nombre=Generar Reporte
Boton=96
NombreEnBoton=S
NombreDesplegar=Generar Reporte&
Multiple=S
EnBarraHerramientas=S
TipoAccion=Reportes Pantalla
ClaveAccion=RM1098DepositosInstRep
ListaAccionesMultiples=asignar<BR>reporte
Activo=S
Visible=S
[Acciones.Generar Reporte.asignar]
Nombre=asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
[Acciones.Generar Reporte.reporte]
Nombre=reporte
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=RM1098DepositosInstRep
ConCondicion=S
EjecucionCondicion=SI<BR>    (ConDatos(Info.FechaD) Y ConDatos(Info.FechaA))<BR>ENTONCES<BR>    Verdadero<BR>SINO<BR>    Falso<BR>FIN
EjecucionMensaje=<T>Complete los campos Fecha Del y Fecha Al<T>
EjecucionConError=S
[Acciones.Imprimir.asignar]
Nombre=asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Imprimir.imp]
Nombre=imp
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM1098DepositosInstRep
Activo=S
Visible=S
[Acciones.Excel.asignar]
Nombre=asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Excel.excel]
Nombre=excel
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=RM1098DepositosInstRep
Activo=S
Visible=S
