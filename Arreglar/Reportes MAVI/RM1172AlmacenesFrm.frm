
[Forma]
Clave=RM1172AlmacenesFrm
Icono=370
Modulos=(Todos)
Nombre=RM1172A Reporte de Almacenes
PosicionInicialAlturaCliente=125
PosicionInicialAncho=318
PosicionInicialIzquierda=481
PosicionInicialArriba=430
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal

ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar
PosicionCol1=78
ExpresionesAlMostrar=Asigna(Mavi.RM1172AlmacenesAlm,nulo)<BR>Asigna(Mavi.RM1172AlmacenesTipo,nulo)<BR>Asigna(Mavi.RM1172AlmacenesEstatus,nulo)
[(Variables)]
Estilo=Ficha
Clave=(Variables)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
FichaEspacioEntreLineas=11
FichaEspacioNombres=139
FichaColorFondo=Plata

ListaEnCaptura=Mavi.RM1172AlmacenesAlm<BR>Mavi.RM1172AlmacenesTipo<BR>Mavi.RM1172AlmacenesEstatus
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaEspacioNombresAuto=S
PermiteEditar=S
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Reportes Pantalla
Activo=S
Visible=S

ClaveAccion=RM1172AlmacenesRep
Multiple=S
ListaAccionesMultiples=VariablesAsignar
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
EspacioPrevio=S






[Almacen.Columnas]
0=282

[Tipo.Columnas]
0=288

[Estatus.Columnas]
0=286

[(Variables).Mavi.RM1172AlmacenesAlm]
Carpeta=(Variables)
Clave=Mavi.RM1172AlmacenesAlm
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.RM1172AlmacenesTipo]
Carpeta=(Variables)
Clave=Mavi.RM1172AlmacenesTipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.RM1172AlmacenesEstatus]
Carpeta=(Variables)
Clave=Mavi.RM1172AlmacenesEstatus
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco




[Acciones.Preliminar.VariablesAsignar]
Nombre=VariablesAsignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S


