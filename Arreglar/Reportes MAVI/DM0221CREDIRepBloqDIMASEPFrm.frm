
[Forma]
Clave=DM0221CREDIRepBloqDIMASEPFrm
Icono=0
Modulos=(Todos)
Nombre=Bloqueo DIMA<T>S Evaluacion de Pago

ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=166
PosicionInicialAncho=332
PosicionInicialIzquierda=674
PosicionInicialArriba=135
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar
VentanaTipoMarco=Normal
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=asigna(Info.FechaD,Nulo)<BR>asigna(Info.FechaA,Nulo)<BR>asigna(Info.Cliente,Nulo)
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
ListaEnCaptura=Info.FechaD<BR>Info.FechaA<BR>Info.Cliente
CarpetaVisible=S

FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Negro
PermiteEditar=S
[(Variables).Info.Cliente]
Carpeta=(Variables)
Clave=Info.Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
LineaNueva=N
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

[Acciones.Preliminar.Preliminar]
Nombre=Preliminar
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

ConCondicion=S
EjecucionCondicion=Si<BR>  (Condatos(info.fechaD)y vacio(info.fechaA))o (Condatos(info.fechaA)y vacio(info.fechaD))<BR>Entonces<BR>    error(<T>Rango no valido<T>)<BR>  Abortaroperacion<BR>Sino<BR>Si<BR>  (info.fechaD)>(info.fechaA)<BR>Entonces<BR>  error(<T>Rango no valido<T>)<BR>  Abortaroperacion<BR>Sino<BR>   verdadero<BR>Fin<BR>  verdadero<BR>Fin
[Acciones.Preliminar]
Nombre=Preliminar
Boton=68
NombreEnBoton=S
NombreDesplegar=&Preliminar
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=Preliminar<BR>Cerrar
Activo=S
Visible=S

[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
NombreEnBoton=S

[Lista.Columnas]
Cliente=117
Nombre=293
RFC=107
