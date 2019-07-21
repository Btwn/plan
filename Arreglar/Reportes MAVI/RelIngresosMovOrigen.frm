[Forma]
Clave=RelIngresosMovOrigen
Icono=0
Modulos=(Todos)
Nombre=Movimiento Origen
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=Vista
CarpetaPrincipal=Vista
PosicionInicialIzquierda=511
PosicionInicialArriba=259
PosicionInicialAlturaCliente=246
PosicionInicialAncho=257
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaAvanzaTab=S
VentanaEstadoInicial=Normal
ListaAcciones=Seleccionar<BR>AutoAsigna
ExpresionesAlMostrar=si vacio(RelIngresos.TipoMovIng)<BR>entonces<BR>sI(precaucion(<T>Debe seleccionar un tipo de movimiento de ingresos<T>, BotonAceptar)=BotonAceptar,AbortarOperacion,AbortarOperacion)<BR>Fin<BR><BR>si vacio(RelIngresos.MovIng)<BR>entonces<BR>sI(precaucion(<T>Debe seleccionar un movimiento de ingresos<T>, BotonAceptar)=BotonAceptar,AbortarOperacion,AbortarOperacion)<BR>Fin
[Acciones.Todos]
Nombre=Todos
Boton=0
NombreDesplegar=&Seleccionar Todos
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
GuardarAntes=S
RefrescarDespues=S
[Vista]
Estilo=Iconos
Clave=Vista
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
Zona=A1
Vista=RelingresosMovOrigen
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosConRejilla=S
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Movimiento Origen
ListaAcciones=Todos<BR>Ninguno
CarpetaVisible=S
[Vista.Columnas]
0=-2
[Acciones.Ninguno]
Nombre=Ninguno
Boton=0
NombreDesplegar=&Quitar Todos
GuardarAntes=S
RefrescarDespues=S
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
GuardarAntes=S
RefrescarDespues=S
Multiple=S
EnBarraHerramientas=S
BtnResaltado=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
ListaAccionesMultiples=Asignar<BR>Registrar<BR>Seleccion
[Acciones.Seleccionar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Seleccionar.Registrar]
Nombre=Registrar
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion( <T>Vista<T> )
Activo=S
Visible=S
[Acciones.Seleccionar.Seleccion]
Nombre=Seleccion
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=SQL(<T> EXEC spRelIngresosEstacionMavi <T>+ EstacionTrabajo)
[Acciones.AutoAsigna.AutoAsignar]
Nombre=AutoAsignar
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion( <T>Vista<T> )
Activo=S
Visible=S
[Acciones.AutoAsigna]
Nombre=AutoAsigna
Boton=0
NombreDesplegar=AutoAsigna
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=AutoAsignar
Activo=S
[Vista.Movimiento Origen]
Carpeta=Vista
Clave=Movimiento Origen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

