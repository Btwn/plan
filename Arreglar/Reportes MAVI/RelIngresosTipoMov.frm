[Forma]
Clave=RelIngresosTipoMov
Nombre=Tipo de Movimiento de Ingresos
Icono=0
CarpetaPrincipal=Vista
Modulos=(Todos)
ListaCarpetas=Vista
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialAlturaCliente=179
PosicionInicialAncho=322
ListaAcciones=Seleccionar<BR>AutoAsigna
PosicionInicialIzquierda=479
PosicionInicialArriba=292
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaEscCerrar=S
VentanaAvanzaTab=S
[Vista]
Estilo=Iconos
Clave=Vista
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
Zona=A1
Vista=RelIngresosTipoMov
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=Tipo Movimiento
ListaAcciones=Todos<BR>Ninguno
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosConRejilla=S
IconosSeleccionMultiple=S
[Acciones.Todos]
Nombre=Todos
Boton=0
NombreDesplegar=&Seleccionar Todos
GuardarAntes=S
RefrescarDespues=S
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
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
[Vista.Columnas]
0=292
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
BtnResaltado=S
Activo=S
Visible=S
GuardarAntes=S
RefrescarDespues=S
ListaAccionesMultiples=Asigna<BR>Registra<BR>Selecciona
TipoAccion=Ventana
ClaveAccion=Seleccionar
[Acciones.Seleccionar.Registra]
Nombre=Registra
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>vista<T>)
[Acciones.Seleccionar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccionar.Selecciona]
Nombre=Selecciona
Boton=0
TipoAccion=Ventana
Activo=S
Visible=S
ClaveAccion=Seleccionar/Resultado
Expresion=SQL(<T>Exec spRelIngresosEstacionMavi  <T>+ EstacionTrabajo )
[Acciones.AutoAsigna.Seleccion]
Nombre=Seleccion
Boton=0
TipoAccion=Expresion
Expresion=SeleccionarTodo(<T>Vista<T>)
Activo=S
Visible=S
[Acciones.AutoAsigna]
Nombre=AutoAsigna
Boton=0
NombreDesplegar=Auto Asignar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Seleccion
Activo=S
[Vista.Tipo Movimiento]
Carpeta=Vista
Clave=Tipo Movimiento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

