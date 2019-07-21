[Forma]
Clave=MonederoRangoFrm
Nombre=MonederoRangoFrm
Icono=0
Modulos=(Todos)
MovModulo=MonederoRangoFrm
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=490
PosicionInicialArriba=190
PosicionInicialAlturaCliente=85
PosicionInicialAncho=346
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Info.MonederoD,<T><T>)<BR>Asigna(Info.MonederoH,<T><T>)
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
ListaEnCaptura=Info.MonederoD<BR>Info.MonederoH
CarpetaVisible=S
MenuLocal=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
[(Variables).Info.MonederoD]
Carpeta=(Variables)
Clave=Info.MonederoD
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.MonederoH]
Carpeta=(Variables)
Clave=Info.MonederoH
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>Expresion2<BR>Expresion
[Acciones.Cerrar]
Nombre=Cerrar
Boton=5
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Aceptar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si condatos(Info.MonederoD ) y condatos(Info.MonederoH )<BR>entonces<BR>    Si  Info.NumMon > 0<BR>    entonces<BR>           error(<T>Rango De: <T>+ Info.MonederoD +<T>   Hasta: <T>+ Info.MonederoH + <T>   No Agregados :<T>+  NumEnTexto(  Info.NumMon ))<BR>    sino<BR>          Confirmacion(<T> Rango agregado De: <T>+ Info.MonederoD +<T>   Hasta:  <T>+ Info.MonederoH, BotonAceptar)<BR>    fin<BR>fin
[Acciones.Aceptar.Expresion2]
Nombre=Expresion2
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
Expresion=Si vacio(Info.MonederoD ) y vacio(Info.MonederoH )<BR>entonces<BR>      error(<T>Capture el Rango de Monedero<T>)<BR>sino<BR>      Asigna(Info.NumMon,SQL(<T>SP_MonederoRango :tEmpresa,:tUsuario,:tMonederoD,:tMonederoH <T>,Empresa,Usuario,Info.MonederoD,Info.MonederoH))<BR>fin
EjecucionCondicion=si vacio(Info.MonederoD)y vacio(Info.MonederoH)<BR>entonces<BR>     error(<T>Capture el Rango, por favor<T>)<BR>fin


