[Forma]
Clave=RM0946CxctipomovimientoVisFrm
Nombre=<T>Movimiento<T> 
Icono=0
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
CarpetaPrincipal=(vista)
ListaCarpetas=(vista)
PosicionInicialIzquierda=551
PosicionInicialArriba=395
PosicionInicialAlturaCliente=199
PosicionInicialAncho=178
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
VentanaBloquearAjuste=S
[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.Cer]
Nombre=Cer
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
GuardarAntes=S
Multiple=S
GuardarConfirmar=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=Asig<BR>cerr
BtnResaltado=S
EspacioPrevio=S
[Acciones.Preliminar.Asig]
Nombre=Asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.cerr]
Nombre=cerr
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
ConCondicion=S
EjecucionConError=S
Visible=S
EjecucionCondicion=Condatos(Info.FechaD) y Condatos(Info.FechaA)
EjecucionMensaje=<T>Selecciona un rango de fechas<T>
[Acciones.C]
Nombre=C
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Actual]
Nombre=Actual
Boton=0
GuardarAntes=S
GuardarConfirmar=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
ConAutoEjecutar=S
AutoEjecutarExpresion=1
[Acciones.Seleccionar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccionar.Registrar]
Nombre=Registrar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Vista<T>)
[Acciones.Seleccionar.Sel]
Nombre=Sel
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=SQL(<T>EXEC dbo.SP_MaviCuentaEstacionUEN :nEst, 0<T>,EstacionTrabajo)
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asigna<BR>Registrar<BR>Sel
Activo=S
Visible=S
[Acciones.Todos]
Nombre=Todos
Boton=0
UsaTeclaRapida=S
TeclaRapida=Ctrl+E
NombreDesplegar=@Seleccionar Todos
EnMenu=S
TipoAccion=Controles Captura
Activo=S
Visible=S
ClaveAccion=Seleccionar Todo
[Acciones.QuitarSeleccion]
Nombre=QuitarSeleccion
Boton=0
UsaTeclaRapida=S
TeclaRapida=Ctrl+R
NombreDesplegar=&Quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[Vista.Columnas]
0=-2
1=319
2=-2
[rm0947movimientovis.Columnas]
0=-2
[(vista)]
Estilo=Iconos
Clave=(vista)
AlineacionAutomatica=S
AcomodarTexto=S
Zona=A1
Vista=RM0946CxctipomovimientoVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosSubTitulo=<T>Tipo Movimiento<T>
ElementosPorPagina=200
IconosConRejilla=S
IconosSeleccionMultiple=S
IconosNombre=RM0946CxctipomovimientoVis:tipomovimiento
[(vista).Columnas]
0=164
1=131
2=179
3=81

