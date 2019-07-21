[Forma]
Clave=RelIngresosConcepto
Nombre=Concepto del Movimiento Origen
Icono=0
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=Vista
ListaAcciones=Seleccionar<BR>AutoAsignar
CarpetaPrincipal=Vista
PosicionInicialIzquierda=471
PosicionInicialArriba=245
PosicionInicialAlturaCliente=273
PosicionInicialAncho=338
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaAvanzaTab=S
VentanaEstadoInicial=Normal
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
[Vista]
Estilo=Iconos
Clave=Vista
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
Zona=A1
Vista=RelIngresosConcepto
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
ListaEnCaptura=Concepto
ListaAcciones=Todos<BR>Ninguno
CarpetaVisible=S
[Vista.Concepto]
Carpeta=Vista
Clave=Concepto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
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
Expresion=RegistrarSeleccion(<T>Vista<T>)
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
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreDesplegar=&Seleccionar
GuardarAntes=S
RefrescarDespues=S
Multiple=S
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
ListaAccionesMultiples=Asignar<BR>Registrar<BR>Seleccion
Activo=S
Visible=S
NombreEnBoton=S
BtnResaltado=S
[Acciones.AutoAsignar.Selec]
Nombre=Selec
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion( <T>Vista<T> )
Activo=S
Visible=S
[Acciones.AutoAsignar]
Nombre=AutoAsignar
Boton=0
NombreDesplegar=AutoAsignar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Selec
Activo=S
[Vista.Columnas]
0=-2

