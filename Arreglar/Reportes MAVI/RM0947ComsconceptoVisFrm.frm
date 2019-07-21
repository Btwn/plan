[Forma]
Clave=RM0947ComsconceptoVisFrm
Nombre=<T>Concepto<T> 
Icono=0
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaAvanzaTab=S
VentanaEstadoInicial=Normal
CarpetaPrincipal=(Vista)
ListaCarpetas=(Vista)
PosicionInicialIzquierda=560
PosicionInicialArriba=345
PosicionInicialAlturaCliente=300
PosicionInicialAncho=160
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
ClaveAccion=Variables Asignar / Ventana Aceptar
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
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
GuardarAntes=S
RefrescarDespues=S
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
[(Vista)]
Estilo=Iconos
Clave=(Vista)
AlineacionAutomatica=S
AcomodarTexto=S
Zona=A1
Vista=RM0947ComsconceptoVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Concepto<T>
ElementosPorPagina=200
IconosConRejilla=S
IconosNombre=RM0947ComsconceptoVis:concepto
[(Vista).Columnas]
0=148
1=-2

