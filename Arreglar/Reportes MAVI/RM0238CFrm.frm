[Forma]
Clave=RM0238CFrm
Nombre=RM238 Consulta Auxiliar de Movimientos Inventario
Icono=22
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=434
PosicionInicialArriba=412
PosicionInicialAltura=131
PosicionInicialAncho=412
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
AccionesTamanoBoton=15x5
AccionesDivision=S
AccionesCentro=S
PosicionInicialAlturaCliente=161
BarraHerramientas=S
VentanaEstadoInicial=Normal
ListaAcciones=Preliminar<BR>Excel<BR>Imprimir<BR>Cerrar
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
ExpresionesAlMostrar=Asigna(Info.FechaD,Nulo)<BR>Asigna(Info.FechaA,Nulo)<BR>Asigna(Mavi.ArticuloD,Nulo)<BR>Asigna(Mavi.ArticuloA,Nulo)<BR>Asigna(Info.Almacen,Nulo)<BR>Asigna(Rep.SaldoInicial,0)<BR>Asigna(Mavi.ban,0)<BR>Asigna(Rep.Suma,0)<BR>Asigna(Rep.Suma1,0)<BR>Asigna(Rep.Suma2,0)
ExpresionesAlCerrar=SI(Info.Almacen=<T>(Todos)<T>, Asigna(Almacen,Nulo),<T><T>)

[(Variables)]
Estilo=Ficha
Clave=(Variables)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={MS Sans Serif, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
FichaEspacioEntreLineas=4
FichaEspacioNombres=65
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
PermiteEditar=S
ListaEnCaptura=Mavi.RM0238ArticuloDAll<BR>Mavi.RM0238ArticuloAAll<BR>Info.FechaD<BR>Info.FechaA<BR>Info.Almacen





[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asignar<BR>Cerrar
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
[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
ConCondicion=S
EjecucionConError=S
Visible=S
EjecucionCondicion=(((Info.FechaD)<=(Info.FechaA)) o (Vacio(Info.FechaD) y Vacio(Info.FechaA)) o (ConDatos(Info.FechaD) y Vacio(Info.FechaA))) y<BR>(((Mavi.ArticuloD)<=(Mavi.ArticuloA)) o (Vacio(Mavi.ArticuloD) y Vacio(Mavi.ArticuloA)) o (ConDatos(Mavi.ArticuloD) y Vacio(Mavi.ArticuloA)))
EjecucionMensaje=<T>Verifique los Campos los Rangos son Incorrectos<T>
[Acciones.Excel]
Nombre=Excel
Boton=115
NombreEnBoton=S
NombreDesplegar=&Excel
EnBarraHerramientas=S
TipoAccion=Reportes Excel
ClaveAccion=RM0238ConAuxMovimientosInvRepXls
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asignar<BR>xls
[Acciones.Imprimir]
Nombre=Imprimir
Boton=4
NombreEnBoton=S
NombreDesplegar=&Imprimir
EnBarraHerramientas=S
TipoAccion=Reportes Impresora
ClaveAccion=RM0238ConAuxMovimientosInvRepImp
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>RM0238ConAuxMovimientosInvRepImp
[Acciones.Excel.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Excel.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Excel.xls]
Nombre=xls
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=RM0238CRepxls
Activo=S
Visible=S
[Acciones.Imprimir.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Imprimir.RM0238ConAuxMovimientosInvRepImp]
Nombre=RM0238ConAuxMovimientosInvRepImp
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM0238CRepImp
Activo=S
Visible=S
[(Variables).Mavi.RM0238ArticuloDAll]
Carpeta=(Variables)
Clave=Mavi.RM0238ArticuloDAll
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0238ArticuloAAll]
Carpeta=(Variables)
Clave=Mavi.RM0238ArticuloAAll
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.Almacen]
Carpeta=(Variables)
Clave=Info.Almacen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

