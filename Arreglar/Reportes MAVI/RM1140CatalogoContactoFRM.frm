[Forma]
Clave=RM1140CatalogoContactoFRM
Nombre=Catalogo Contacto Aval
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialAlturaCliente=192
PosicionInicialAncho=282
PosicionInicialIzquierda=549
PosicionInicialArriba=325
ListaAcciones=Preliminar<BR>cerrar<BR>ExpTxt
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
BarraAyuda=S
ExpresionesAlMostrar=ASIGNA(MAVI.RM1140Cliente,<T><T>)<BR>ASIGNA(MAVI.RM1140TipoAval,<T><T>)<BR>ASIGNA(MAVI.RM1140Estatus,<T><T>)
[(Variables)]
Estilo=Ficha
Clave=(Variables)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
Vista=(Variables)
FichaEspacioEntreLineas=6
FichaEspacioNombres=0
FichaColorFondo=$00F0F0F0
ListaEnCaptura=MAVI.RM1140Cliente<BR>MAVI.RM1140TipoAval<BR>MAVI.RM1140Estatus
PermiteEditar=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaAlineacionDerecha=S
FichaEspacioNombresAuto=S
[(Variables).MAVI.RM1140Cliente]
Carpeta=(Variables)
Clave=MAVI.RM1140Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Acciones.Preliminar]
Nombre=Preliminar
Boton=35
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
Activo=S
Visible=S
NombreEnBoton=S
Multiple=S
ListaAccionesMultiples=asing<BR>cerrar
[Acciones.Preliminar.asing]
Nombre=asing
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.cerrar]
Nombre=cerrar
Boton=36
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
NombreEnBoton=S
NombreDesplegar=&Cerrar
EspacioPrevio=S

[RM1140SeleccionCliente.Columnas]
cliente=64


[(Variables).MAVI.RM1140TipoAval]
Carpeta=(Variables)
Clave=MAVI.RM1140TipoAval
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).MAVI.RM1140Estatus]
Carpeta=(Variables)
Clave=MAVI.RM1140Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.ExpTxt]
Nombre=ExpTxt
Boton=54
NombreDesplegar=&TXT
EnBarraHerramientas=S
TipoAccion=Reportes PDF
Activo=S
Visible=S

NombreEnBoton=S
Multiple=S
ClaveAccion=RM1140CatalogoContatoAvalREPTXT
ListaAccionesMultiples=asignar<BR>reporteTXT
[Acciones.ExpTxt.asignar]
Nombre=asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.ExpTxt.reporteTXT]
Nombre=reporteTXT
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM1140CatalogoContatoAvalREPTXT
Activo=S
Visible=S

[RM1140SeleccionCategoriaFrm.Columnas]
Categoria=304



