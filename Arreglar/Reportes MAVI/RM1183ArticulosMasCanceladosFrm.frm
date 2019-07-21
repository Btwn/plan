
[Forma]
Clave=RM1183ArticulosMasCanceladosFrm
Icono=0
Modulos=(Todos)
Nombre=RM1183 Articulos Mas Cancelados
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialAlturaCliente=269
PosicionInicialAncho=464

ListaAcciones=Prelim<BR>cerrar
FiltrarFechasSinHora=S
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=459
PosicionInicialArriba=205
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaExclusiva=S
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
VentanaExclusivaOpcion=0
VentanaBloquearAjuste=S
ExpresionesAlMostrar=asigna(Info.FechaD,Nulo),  asigna(Info.FechaA, Nulo), asigna(Mavi.RM1183Sucursal,<T><T>), asigna(Mavi.RM1183Fam,<T><T>)
[Acciones.Prelim]
Nombre=Prelim
Boton=6
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Asign<BR>Acept
NombreEnBoton=S
[Acciones.Prelim.Asign]
Nombre=Asign
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Prelim.Acept]
Nombre=Acept
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

ConCondicion=S
EjecucionConError=S
EjecucionCondicion=((Condatos(Info.FechaD) y Condatos(Info.FechaA)) y (Info.FechaD <= Info.FechaA))y Condatos(Mavi.RM1183Sucursal) y ((izquierda(Mavi.RM1183Sucursal,1) <> <T>V<T>) y (izquierda(Mavi.RM1183Sucursal,1) <> <T>v<T>))
EjecucionMensaje=<T>Filtro erroneo y/o incompleto.<T>
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
FichaEspacioEntreLineas=2
FichaEspacioNombres=67
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=Info.FechaD<BR>Info.FechaA<BR>Mavi.RM1183Sucursal<BR>Mavi.RM1183Fam

FichaEspacioNombresAuto=S
[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


[(Variables).Columnas]
0=-2

[Acciones.cerrar]
Nombre=cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


[Vista.Columnas]
0=-2

[(Variables).Mavi.RM1183Sucursal]
Carpeta=(Variables)
Clave=Mavi.RM1183Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.RM1183Fam]
Carpeta=(Variables)
Clave=Mavi.RM1183Fam
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[RM1183SucursalesVis.Columnas]
0=37
1=-2

[Acciones.excel.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.excel.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.excel.excel]
Nombre=excel
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=RM1183ArticulosMasCanceladosXls
Activo=S
Visible=S



[Sucursales.Columnas]
0=-2
1=-2

