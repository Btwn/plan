
[Forma]
Clave=DM0351DisminucionLineaCreditoBFFrm
Icono=68
Modulos=(Todos)
Nombre=Disminución Línea de Crédito BF

ListaCarpetas=DM0351DisminucionLineaCreditoBFVis
CarpetaPrincipal=DM0351DisminucionLineaCreditoBFVis
PosicionInicialAlturaCliente=209
PosicionInicialAncho=500
PosicionInicialIzquierda=433
PosicionInicialArriba=260
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Salir
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaSinIconosMarco=S
MovModulo=(Todos)
[DM0351DisminucionLineaCreditoBFVis]
Estilo=Hoja
Clave=DM0351DisminucionLineaCreditoBFVis
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0351DisminucionLineaCreditoBFVis
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
ListaEnCaptura=DM0351CREDICDisminucionLineaDeCreditoBF.Concepto<BR>DM0351CREDICDisminucionLineaDeCreditoBF.Valor<BR>DM0351CREDICDisminucionLineaDeCreditoBF.Periodo



PermiteEditar=S
[DM0351DisminucionLineaCreditoBFVis.Columnas]
Concepto=222
Valor=133
Periodo=105

[DM0351DisminucionLineaCreditoBFVis.DM0351CREDICDisminucionLineaDeCreditoBF.Concepto]
Carpeta=DM0351DisminucionLineaCreditoBFVis
Clave=DM0351CREDICDisminucionLineaDeCreditoBF.Concepto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[DM0351DisminucionLineaCreditoBFVis.DM0351CREDICDisminucionLineaDeCreditoBF.Valor]
Carpeta=DM0351DisminucionLineaCreditoBFVis
Clave=DM0351CREDICDisminucionLineaDeCreditoBF.Valor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[DM0351DisminucionLineaCreditoBFVis.DM0351CREDICDisminucionLineaDeCreditoBF.Periodo]
Carpeta=DM0351DisminucionLineaCreditoBFVis
Clave=DM0351CREDICDisminucionLineaDeCreditoBF.Periodo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=Guardar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S

ListaAccionesMultiples=Guardar Cambios<BR>Expresion
[Acciones.Guardar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

ConCondicion=S
EjecucionCondicion=AvanzarCaptura
[Acciones.Guardar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Expresion=Informacion(<T>Cambios guardados<T>)
Activo=S
Visible=S

[Acciones.Salir.Cancelar Cambios]
Nombre=Cancelar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S

[Acciones.Salir.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Salir]
Nombre=Salir
Boton=23
NombreDesplegar=Salir
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Cancelar Cambios<BR>Cerrar
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S

