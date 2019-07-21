[Forma]
Clave=DM0133MaviCatalogoFactorBonifModificaFrm
Icono=0
Modulos=(Todos)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialAlturaCliente=184
PosicionInicialAncho=162
ListaAcciones=Aceptar<BR>Cerr<BR>Actualizar
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=532
PosicionInicialArriba=377
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
Nombre=Modificar Registros
VentanaSinIconosMarco=S
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
Visible=S
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
ListaEnCaptura=Mavi.Dm0133Movto<BR>Mavi.Dm0133Condicion<BR>Info.Factor<BR>Info.Porcentaje
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
[(Variables).Mavi.Dm0133Movto]
Carpeta=(Variables)
Clave=Mavi.Dm0133Movto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.Factor]
Carpeta=(Variables)
Clave=Info.Factor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar]
Nombre=Aceptar
Boton=68
NombreEnBoton=S
NombreDesplegar=&Aceptar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=acept<BR>sp<BR>Cerra
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=condatos(Mavi.Dm0133Movto)  y  condatos(Mavi.Dm0133Condicion)
EjecucionMensaje=si vacio(Mavi.Dm0133Movto)<BR>entonces <T>Falta capturar el Mov<T><BR>sino<BR>  si vacio(Mavi.Dm0133Condicion)<BR>   entonces <T>Falta capturar la Condicion<T><BR>   fin<BR>fin
[Acciones.Actualizar]
Nombre=Actualizar
Boton=0
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
ConAutoEjecutar=S
AutoEjecutarExpresion=1
[Acciones.Aceptar.acept]
Nombre=acept
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
[Acciones.Aceptar.sp]
Nombre=sp
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=informacion(SQL(<T>Exec Sp_MAVI_DM0133UpdateFacBonif :tMov,:tCond,:nFact,:nPorc<T>,Mavi.Dm0133Movto,Mavi.Dm0133Condicion,Info.Factor,Info.Porcentaje))
[Acciones.Aceptar.Cerra]
Nombre=Cerra
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[(Variables).Mavi.Dm0133Condicion]
Carpeta=(Variables)
Clave=Mavi.Dm0133Condicion
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.Porcentaje]
Carpeta=(Variables)
Clave=Info.Porcentaje
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Cerr]
Nombre=Cerr
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


