[Forma]
Clave=RM1145ReportesCeroFRM
Nombre=RM1145 Reportes Cero
Icono=135
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialIzquierda=626
PosicionInicialArriba=204
PosicionInicialAlturaCliente=92
PosicionInicialAncho=205
ListaCarpetas=Variables
CarpetaPrincipal=Variables
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Mavi.RM1145RepCeroResDet,<T>Resumen De Articulos<T>)
ListaAcciones=ArticulosSinMarcaEnFabricante<BR>Cerrar<BR>ArticulosQ<BR>FabricanteCalzado
[Variables]
Estilo=Ficha
Clave=Variables
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
ListaEnCaptura=Mavi.RM1145RepCeroResDet
CarpetaVisible=S
[Variables.Mavi.RM1145RepCeroResDet]
Carpeta=Variables
Clave=Mavi.RM1145RepCeroResDet
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S
[Acciones.ArticulosQ]
Nombre=ArticulosQ
Boton=71
NombreEnBoton=S
NombreDesplegar=Articulos Q 
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=Asigna<BR>Llamada<BR>Salir
[Acciones.FabricanteCalzado]
Nombre=FabricanteCalzado
Boton=37
NombreEnBoton=S
NombreDesplegar=Fabricante Calzado
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=Asigna<BR>Llamada<BR>Salir
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.ArticulosSinMarcaEnFabricante]
Nombre=ArticulosSinMarcaEnFabricante
Boton=42
NombreEnBoton=S
NombreDesplegar=Articulos Sin Marca
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S
ListaAccionesMultiples=Asigna<BR>Llamada<BR>Salir
[Acciones.ArticulosSinMarcaEnFabricante.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.ArticulosSinMarcaEnFabricante.Llamada]
Nombre=Llamada
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Si<BR>    Mavi.RM1145RepCeroResDet = <T>Resumen De Articulos<T><BR>Entonces<BR>    ReportePantalla(<T>RM1145ArtSinMarcaEnFabResRep<T>)<BR>Fin<BR><BR><BR>Si                                                                               <BR>    Mavi.RM1145RepCeroResDet = <T>Detalle De Articulos<T><BR>Entonces<BR>     ReportePantalla(<T>RM1145ArtSinMarcaEnFabDetRep<T>)<BR>Fin
EjecucionCondicion=CONDATOS(Mavi.RM1145RepCeroResDet)
EjecucionMensaje=<T>INGRESE OPCION<T>+ ASCII( 13 )+ <T>ES CAMPO REQUERIDO<T>
[Acciones.ArticulosSinMarcaEnFabricante.Salir]
Nombre=Salir
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.ArticulosQ.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.ArticulosQ.Llamada]
Nombre=Llamada
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si<BR>    Mavi.RM1145RepCeroResDet = <T>Resumen De Articulos<T><BR>Entonces<BR>    ReportePantalla(<T>RM1145ArticulosQRep<T>)<BR>Fin<BR><BR><BR>Si                                                                               <BR>    Mavi.RM1145RepCeroResDet = <T>Detalle De Articulos<T><BR>Entonces<BR>     ReportePantalla(<T>RM1145ArticulosQRep<T>)<BR>Fin
ConCondicion=S
EjecucionCondicion=CONDATOS(Mavi.RM1145RepCeroResDet)
EjecucionMensaje=<T>INGRESE OPCION<T>+ ASCII( 13 )+ <T>ES CAMPO REQUERIDO<T>
EjecucionConError=S
[Acciones.ArticulosQ.Salir]
Nombre=Salir
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.FabricanteCalzado.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.FabricanteCalzado.Llamada]
Nombre=Llamada
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Si<BR>    Mavi.RM1145RepCeroResDet = <T>Resumen De Articulos<T><BR>Entonces<BR>    ReportePantalla(<T>RM1145FabCalzSinMarcaOMultiRep<T>)<BR>Fin<BR><BR><BR>Si                                                                               <BR>    Mavi.RM1145RepCeroResDet = <T>Detalle De Articulos<T><BR>Entonces<BR>     ReportePantalla(<T>RM1145FabCalzSinMarcaOMultiRep<T>)<BR>Fin
EjecucionCondicion=CONDATOS(Mavi.RM1145RepCeroResDet)
EjecucionMensaje=<T>INGRESE OPCION<T>+ ASCII( 13 )+ <T>ES CAMPO REQUERIDO<T>
[Acciones.FabricanteCalzado.Salir]
Nombre=Salir
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

