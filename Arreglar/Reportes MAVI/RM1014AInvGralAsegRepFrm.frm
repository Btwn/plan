[Forma]
Clave=RM1014AInvGralAsegRepFrm
Nombre=RM1014A Inventarios Generales para Aseguranza
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
ListaAcciones=Preli<BR>Excel<BR>Transito<BR>CERRAR
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Mavi.RM1014ALineas,NULO)<BR>Asigna(Mavi.RM1014AFamilias,NULO)<BR>Asigna(Mavi.RM1014AGrupos,NULO)<BR>Asigna(Mavi.RM1014AAlmacenes,NULO)
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
ListaEnCaptura=Mavi.RM1014AGrupos<BR>Mavi.RM1014AFamilias<BR>Mavi.RM1014ALineas<BR>Mavi.RM1014AAlmacenes
CarpetaVisible=S
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
ClaveAccion=RM1014AInvGralAsegRepXls
Activo=S
Visible=S
[Acciones.Transito]
Nombre=Transito
Boton=107
NombreEnBoton=S
NombreDesplegar=Transito
EnBarraHerramientas=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=asi<BR>asignar<BR>cerrar<BR>Expresion
Antes=S
[RM1014.Mavi.RM1014AGrupos]
Carpeta=RM1014
Clave=Mavi.RM1014AGrupos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[RM1014.Mavi.RM1014AFamilias]
Carpeta=RM1014
Clave=Mavi.RM1014AFamilias
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[RM1014.Mavi.RM1014ALineas]
Carpeta=RM1014
Clave=Mavi.RM1014ALineas
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[RM1014.Mavi.RM1014AAlmacenes]
Carpeta=RM1014
Clave=Mavi.RM1014AAlmacenes
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Transito.asi]
Nombre=asi
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Transito.asignar]
Nombre=asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Transito.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Expresion=ReportePantalla(<T>RM1014ATranInvGralAsegRep<T>)   
Activo=S
Visible=S
[Acciones.Transito.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

