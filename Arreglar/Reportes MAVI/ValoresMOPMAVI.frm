[Forma]
Clave=ValoresMOPMAVI
Nombre=Valores MOP por dias vencidos
Icono=0
Modulos=(Todos)
ListaCarpetas=ValoresMOPMAVI
CarpetaPrincipal=ValoresMOPMAVI
PosicionInicialAlturaCliente=231
;PosicionInicialAncho=528
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=424
PosicionInicialArriba=249
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=(Lista)
PosicionInicialAncho=511
[ValoresMOPMAVI]
Estilo=Hoja
Clave=ValoresMOPMAVI
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=ValoresMOPMAVI
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
;ListaEnCaptura=ValoresMOPMAVI.ValorMOP<BR>ValoresMOPMAVI.Descripcion<BR>ValoresMOPMAVI.DiaAtrasoMin<BR>ValoresMOPMAVI.DiaAtrasoMax
PosicionInicialAncho=600
ListaEnCaptura=ValoresMOPMAVI.ValorMOP<BR>ValoresMOPMAVI.Descripcion<BR>ValoresMOPMAVI.DiaAtrasoMin<BR>ValoresMOPMAVI.DiaAtrasoMax<BR>ValoresMOPMAVI.MOPBuroMavi
CarpetaVisible=S
PermiteEditar=S
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
[ValoresMOPMAVI.ValoresMOPMAVI.ValorMOP]
Carpeta=ValoresMOPMAVI
Clave=ValoresMOPMAVI.ValorMOP
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[ValoresMOPMAVI.ValoresMOPMAVI.DiaAtrasoMin]
Carpeta=ValoresMOPMAVI
Clave=ValoresMOPMAVI.DiaAtrasoMin
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[ValoresMOPMAVI.ValoresMOPMAVI.DiaAtrasoMax]
Carpeta=ValoresMOPMAVI
Clave=ValoresMOPMAVI.DiaAtrasoMax
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[ValoresMOPMAVI.Columnas]
ValorMOP=61
DiaAtrasoMin=121
DiaAtrasoMax=114
0=-2
1=-2
2=-2
Descripcion=99
MOPBuroMavi=72
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreDesplegar=&Guardar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
NombreEnBoton=S
[ValoresMOPMAVI.ValoresMOPMAVI.Descripcion]
Carpeta=ValoresMOPMAVI
Clave=ValoresMOPMAVI.Descripcion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro

[ValoresMOPMAVI.ValoresMOPMAVI.MOPBuroMavi]
Carpeta=ValoresMOPMAVI
Clave=ValoresMOPMAVI.MOPBuroMavi
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro









[Forma.ListaAcciones]
(Inicio)=Cerrar
Cerrar=Guardar
Guardar=(Fin)

