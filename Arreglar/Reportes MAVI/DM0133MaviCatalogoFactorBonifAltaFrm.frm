[Forma]
Clave=DM0133MaviCatalogoFactorBonifAltaFrm
Icono=0
Modulos=(Todos)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialAlturaCliente=191
PosicionInicialAncho=162
ListaAcciones=Aceptar<BR>Cerrar<BR>Actualizar
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=533
PosicionInicialArriba=380
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
Nombre=Insertar Registros
VentanaSinIconosMarco=S
ExpresionesAlMostrar=asigna(Mavi.Dm0133Movto,<T><T>)<BR>asigna(Mavi.Dm0133Condicion,<T><T>)<BR>asigna(Info.Factor,0)
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
ListaAccionesMultiples=acept<BR>sp
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=condatos(Mavi.Dm0133Movto)  y  condatos(Mavi.Dm0133Condicion)
EjecucionMensaje=si vacio(Mavi.Dm0133Movto)<BR>entonces <T>Falta capturar el Mov<T><BR>sino<BR>   si vacio(Mavi.Dm0133Condicion)<BR>   entonces <T>Falta capturar la Condicion<T><BR>   fin<BR>fin
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
Expresion=informacion(SQL(<T>Exec Sp_MAVI_DM0133InsertFacBonif :tMov,:tCondi,:nFact,:Porc<T>,Mavi.Dm0133Movto,Mavi.Dm0133Condicion,Info.Factor,Info.Porcentaje))
[(Variables).Mavi.Dm0133Condicion]
Carpeta=(Variables)
Clave=Mavi.Dm0133Condicion
Editar=S
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
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
EspacioPrevio=S


