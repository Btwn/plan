[Forma]
Clave=RM1132PosiblesDimasfrm
Nombre=RM1132 Posibles Dimas
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=504
PosicionInicialArriba=225
PosicionInicialAlturaCliente=449
PosicionInicialAncho=425
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>cerrar<BR>TXT
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
PosicionSec1=291
ExpresionesAlMostrar=Asigna( MAVI.RM1132Zona, <T><T> )<BR>Asigna(Mavi.RM1132soloDimas,<T>AMBOS<T>)<BR>Asigna(Mavi.RM1132HabilitarFil,<T>NO<T>)
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
ListaEnCaptura=Mavi.RM1132soloDimas<BR>MAVI.RM1132Saldo<BR>MAVI.RM1132NoFacturas<BR>MAVI.RM1132NoDias<BR>Mavi.RM1132Abonos<BR>MAVI.RM1132DV<BR>MAVI.RM1132HistDV<BR>Mavi.RM1132DiasVen<BR>MAVI.RM1132Fechas<BR>Info.FechaD<BR>Info.FechaA
CarpetaVisible=S
[(Variables).Mavi.RM1132Abonos]
Carpeta=(Variables)
Clave=Mavi.RM1132Abonos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
EspacioPrevio=S
[(Variables).MAVI.RM1132DV]
Carpeta=(Variables)
Clave=MAVI.RM1132DV
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
LineaNueva=S
[(Variables).MAVI.RM1132HistDV]
Carpeta=(Variables)
Clave=MAVI.RM1132HistDV
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[(Variables).MAVI.RM1132NoDias]
Carpeta=(Variables)
Clave=MAVI.RM1132NoDias
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
LineaNueva=S
[(Variables).MAVI.RM1132NoFacturas]
Carpeta=(Variables)
Clave=MAVI.RM1132NoFacturas
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Acciones.Preliminar.asign]
Nombre=asign
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.Cerra]
Nombre=Cerra
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=SQL(<T>Select dbo.FN_MaviRM1132PosiblesDimasValidacionZona(:tusu,:tzon)<T>,Usuario,MAVI.RM1132Zona) = 1
EjecucionMensaje=<T>Esta zona no corresponde a este usuario<T>
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=asign<BR>Cerra
Activo=S
Visible=S
[Acciones.cerrar]
Nombre=cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[(Variables).MAVI.RM1132Saldo]
Carpeta=(Variables)
Clave=MAVI.RM1132Saldo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
EspacioPrevio=S

[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
EspacioPrevio=N

[zona.MAVI.RM1132Zona]
Carpeta=zona
Clave=MAVI.RM1132Zona
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[1.Info.FechaA]
Carpeta=1
Clave=Info.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[1.Info.FechaD]
Carpeta=1
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM1132soloDimas]
Carpeta=(Variables)
Clave=Mavi.RM1132soloDimas
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


[Fechaliq.Columnas]
FechaUltimoCobro=604

[Factu.Columnas]
Facturas=64

[MontoAbonos.Columnas]
MontoAbonos=70

[MHDV.Columnas]
MHDV=304

[meses.Columnas]
Meses=64

[(Variables).MAVI.RM1132Fechas]
Carpeta=(Variables)
Clave=MAVI.RM1132Fechas
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=0
ColorFondo=Blanco
OcultaNombre=N
EspacioPrevio=S

[Acciones.TXT .asign]
Nombre=asign
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.TXT .reporte]
Nombre=reporte
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM1132posiblesDimasReptxt
Activo=S
Visible=S

[Acciones.TXT .close]
Nombre=close
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


[Acciones.TXT]
Nombre=TXT
Boton=9
NombreEnBoton=S
NombreDesplegar=Generar &TxT
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=asign<BR>repor<BR>close
Activo=S
Visible=S

[Acciones.TXT.asign]
Nombre=asign
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar

[Acciones.TXT.repor]
Nombre=repor
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM1132posiblesDimasReptxt

[Acciones.TXT.close]
Nombre=close
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar

[(Variables).Mavi.RM1132DiasVen]
Carpeta=(Variables)
Clave=Mavi.RM1132DiasVen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

