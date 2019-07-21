[Forma]
Clave=RM1014InvGralAsegRepFrm
Nombre=RM1014 Inventarios Generales para Aseguranza
Icono=0
Modulos=(Todos)
ListaCarpetas=RM1014
CarpetaPrincipal=RM1014
PosicionInicialIzquierda=552
PosicionInicialArriba=256
PosicionInicialAlturaCliente=227
PosicionInicialAncho=269
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preli<BR>Excel<BR>CERRAR
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Mavi.RM1014Lineas,NULO)<BR>Asigna(Mavi.RM1014Familias,NULO)<BR>Asigna(Mavi.RM1014Grupos,NULO)<BR>Asigna(Mavi.RM1014Almacenes,NULO)
[Acciones.CERRAR]
Nombre=CERRAR
Boton=36
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Preli.asi]
Nombre=asi
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preli.asignar]
Nombre=asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Preli]
Nombre=Preli
Boton=68
NombreEnBoton=S
NombreDesplegar=Preliminar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=asi<BR>asignar
Activo=S
Visible=S
[RM1014]
Estilo=Ficha
Clave=RM1014
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
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM1014Grupos<BR>Mavi.RM1014Familias<BR>Mavi.RM1014Lineas<BR>Mavi.RM1014Almacenes
CarpetaVisible=S
[RM1014.Mavi.RM1014Grupos]
Carpeta=RM1014
Clave=Mavi.RM1014Grupos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[RM1014.Mavi.RM1014Familias]
Carpeta=RM1014
Clave=Mavi.RM1014Familias
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[RM1014.Mavi.RM1014Lineas]
Carpeta=RM1014
Clave=Mavi.RM1014Lineas
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[RM1014.Mavi.RM1014Almacenes]
Carpeta=RM1014
Clave=Mavi.RM1014Almacenes
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Excel]
Nombre=Excel
Boton=115
NombreEnBoton=S
NombreDesplegar=&Excel
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=Variables Asignar<BR>RepXls
[Acciones.Excel.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Excel.RepXls]
Nombre=RepXls
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=RM1014InvGralAsegRepXls
Activo=S
Visible=S

