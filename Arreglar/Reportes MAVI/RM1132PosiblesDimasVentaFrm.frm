[Forma]
Clave=RM1132PosiblesDimasVentaFrm
Nombre=RM1132 Presumibles Dimas GTE
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=504
PosicionInicialArriba=225
PosicionInicialAlturaCliente=316
PosicionInicialAncho=375
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
PosicionSec1=291
ExpresionesAlMostrar=Asigna(Mavi.RM1132soloDimas,<T>AMBOS<T>)<BR>Asigna(Mavi.RM1132Ejercicio,NULO)<BR>Asigna(Mavi.RM1132Quincena,NULO)
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
ListaEnCaptura=Mavi.RM1132soloDimas<BR>MAVI.RM1132Saldo<BR>MAVI.RM1132NoFacturas<BR>MAVI.RM1132NoDias<BR>Mavi.RM1132Abonos<BR>MAVI.RM1132DV<BR>MAVI.RM1132HistDV<BR>Mavi.RM1132Ejercicio<BR>Mavi.RM1132Quincena
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



[(Variables).Mavi.RM1132Ejercicio]
Carpeta=(Variables)
Clave=Mavi.RM1132Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.RM1132Quincena]
Carpeta=(Variables)
Clave=Mavi.RM1132Quincena
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

