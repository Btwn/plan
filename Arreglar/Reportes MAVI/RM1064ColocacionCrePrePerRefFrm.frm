[Forma]
Clave=RM1064ColocacionCrePrePerRefFrm
Nombre=Colocaci�n de credilana, pr�stamos personales y refinanciamiento
Icono=0
Modulos=(Todos)
ListaCarpetas=Ficha
CarpetaPrincipal=Ficha
PosicionInicialIzquierda=405
PosicionInicialArriba=116
PosicionInicialAlturaCliente=87
PosicionInicialAncho=465
AccionesTamanoBoton=15x5
BarraAcciones=S
ListaAcciones=Aceptar<BR>Cancelar
AccionesCentro=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Dise�o
VentanaEstadoInicial=Normal
[Ficha]
Estilo=Ficha
Clave=Ficha
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
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.FechaD<BR>Info.FechaA
CarpetaVisible=S
[Ficha.Info.FechaD]
Carpeta=Ficha
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.Info.FechaA]
Carpeta=Ficha
Clave=Info.FechaA
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Cancelar]
Nombre=Cancelar
Boton=0
NombreEnBoton=S
NombreDesplegar=&Cancelar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cancelar
Activo=S
Visible=S
[Acciones.Aceptar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.Abrir]
Nombre=Abrir
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
Expresion=Si<BR>     Info.FechaD > Info.FechaA<BR>Entonces<BR>     Informacion(<T>Seleccione Rango de Fechas Valido...<T>)<BR>     AbortarOperacion<BR>Sino<BR>     reportepantalla(<T>RM1064ColocacionCrePrePerRefFrmRepPantalla<T>)<BR>Fin
[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreEnBoton=S
NombreDesplegar=&Aceptar
Multiple=S
EnBarraAcciones=S
Activo=S
Visible=S
ListaAccionesMultiples=Asigna<BR>&Abrir<BR>&Cerrar
[Acciones.Aceptar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.&Abrir]
Nombre=&Abrir
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si<BR>     Info.FechaD > Info.FechaA<BR>Entonces<BR>     Informacion(<T>Seleccione Rango de Fechas Valido...<T>)<BR>     AbortarOperacion<BR>Sino<BR>     reportepantalla(<T>RM1064ColocacionCrePrePerRefPantaRep<T>)<BR>Fin
[Acciones.Aceptar.&Cerrar]
Nombre=&Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

