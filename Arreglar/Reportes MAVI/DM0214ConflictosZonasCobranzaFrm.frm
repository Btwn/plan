
[Forma]
Clave=DM0214ConflictosZonasCobranzaFrm
Icono=0
Modulos=(Todos)




ListaCarpetas=ListaConflictos
CarpetaPrincipal=ListaConflictos
PosicionInicialAlturaCliente=273
PosicionInicialAncho=326
PosicionInicialIzquierda=520
PosicionInicialArriba=228
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=Reparar<BR>Ignorar
AccionesDivision=S
AccionesDerecha=S
Nombre=Conflictos en la tabla <T>DM0214ZonasCobranza<T>
VentanaSinIconosMarco=S
VentanaExclusiva=S
VentanaConIcono=S
VentanaExclusivaOpcion=0
[ListaConflictos]
Estilo=Hoja
Clave=ListaConflictos
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0214ConflictosZonasCobranzaVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Agente<BR>Conflicto
CarpetaVisible=S

[ListaConflictos.Agente]
Carpeta=ListaConflictos
Clave=Agente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[ListaConflictos.Conflicto]
Carpeta=ListaConflictos
Clave=Conflicto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco

[ListaConflictos.Columnas]
Agente=94
Conflicto=184

[Acciones.Reparar]
Nombre=Reparar
Boton=45
NombreEnBoton=S
NombreDesplegar=Reparar
EnBarraAcciones=S
TipoAccion=Expresion
Activo=S
Visible=S
Multiple=S
BtnResaltado=S

EspacioPrevio=S
ListaAccionesMultiples=Expresion<BR>Cerrar
[Acciones.Ignorar]
Nombre=Ignorar
Boton=23
NombreEnBoton=S
NombreDesplegar=Ignorar
Multiple=S
EnBarraAcciones=S
BtnResaltado=S
Activo=S
Visible=S
BotonDefault=S



ListaAccionesMultiples=Cerrar
EspacioPrevio=S
[Acciones.Ignorar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S



[Acciones.Reparar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Reparar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=EjecutarSQL(<T>EXEC Sp_DM0214RepararConflictosZonasCobranza <T>+ASCII(39)+Usuario+ASCII(39))
