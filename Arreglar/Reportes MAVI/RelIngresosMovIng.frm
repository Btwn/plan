[Forma]
Clave=RelIngresosMovIng
Nombre=Movimiento de Ingresos
Icono=0
CarpetaPrincipal=Vista
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialIzquierda=484
PosicionInicialArriba=263
PosicionInicialAlturaCliente=237
PosicionInicialAncho=311
ListaCarpetas=Vista
ListaAcciones=Seleccionar<BR>AutoAsigna
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaAvanzaTab=S
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=si vacio(RelIngresos.TipoMovIng)<BR>entonces<BR>sI(precaucion(<T>Debe seleccionar un tipo de movimiento de ingresos<T>, BotonAceptar)=BotonAceptar,AbortarOperacion,AbortarOperacion)<BR>Fin
[(Vista).Columnas]
0=-2
[Vista.Columnas]
0=287
[Vista]
Estilo=Iconos
Clave=Vista
AlineacionAutomatica=S
AcomodarTexto=S
Zona=A1
Vista=RelIngresosMovIng
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Movimiento
CarpetaVisible=S
MenuLocal=S
ListaAcciones=Todos<BR>Ninguno
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosConRejilla=S
IconosSeleccionMultiple=S
[Acciones.Seleccionar.Asingar]
Nombre=Asingar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
BtnResaltado=S
Activo=S
Visible=S
GuardarAntes=S
RefrescarDespues=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Multiple=S
ListaAccionesMultiples=Asigna<BR>Registro<BR>Selecciona
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
Activo=S
Visible=S
ClaveAccion=Seleccionar/Resultado
Expresion=SQL(<T>Exec SP_MaviCuentaEstacionUEN <T> + EstacionTrabajo + <T>, 1<T> )
[Acciones.Todos]
Nombre=Todos
Boton=0
NombreDesplegar=&Todos
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
NombreDesplegar=&Ninguno
GuardarAntes=S
RefrescarDespues=S
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[Acciones.AutoAsignar.AutoAsigna]
Nombre=AutoAsigna
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion (<T>Vista<T>)
Activo=S
Visible=S
[Acciones.Actualiza.Refrescar]
Nombre=Refrescar
Boton=0
TipoAccion=Expresion
Expresion=ActualizarForma
Activo=S
Visible=S
[Acciones.AutoAsignar.Refresca]
Nombre=Refresca
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion( relingresos.tipomoving )
Activo=S
Visible=S
[Acciones.Seleccionar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Seleccionar.Registro]
Nombre=Registro
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Vista<T>) 
Activo=S
Visible=S
[Acciones.Seleccionar.Selecciona]
Nombre=Selecciona
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=SQL(<T>Exec spRelIngresosEstacionMavi  <T>+ EstacionTrabajo )
[Acciones.AutoAsigna.Selecciona]
Nombre=Selecciona
Boton=0
TipoAccion=Expresion
Expresion=SeleccionarTodo(<T>Vista<T>)
Activo=S
Visible=S
[Acciones.AutoAsigna]
Nombre=AutoAsigna
Boton=0
NombreDesplegar=AutoAsigna
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Selecciona
Activo=S
[Vista.Movimiento]
Carpeta=Vista
Clave=Movimiento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

