[Forma]
Clave=RM0188ComPagDifeCptoFrm
Nombre=Condición de Pago
Icono=86
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialIzquierda=536
PosicionInicialArriba=279
PosicionInicialAlturaCliente=427
PosicionInicialAncho=207
BarraHerramientas=S
EsConsultaExclusiva=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccion<BR>Cancela
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaAvanzaTab=S
VentanaEstadoInicial=Normal
[Lista]
Estilo=Iconos
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0188ComPagDifeCptoVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
IconosSubTitulo=<T>Condición de Pago<T>
MenuLocal=S
IconosNombre=RM0188ComPagDifeCptoVis:Condicion
ListaAcciones=SelTodo<BR>QuitaSel
[Lista.Columnas]
concepto=304
Condicion=304
0=168
[Acciones.Seleccion]
Nombre=Seleccion
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Registra<BR>Selecciona
[Acciones.Seleccion.Registra]
Nombre=Registra
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Lista<T>)
Activo=S
Visible=S
[Acciones.Seleccion.Selecciona]
Nombre=Selecciona
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=SQL(<T>EXEC SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1 <T>)
[Acciones.Cancela]
Nombre=Cancela
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cancelar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cancelar
Activo=S
Visible=S
[Acciones.SelTodo]
Nombre=SelTodo
Boton=0
NombreDesplegar=&Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+T
[Acciones.QuitaSel]
Nombre=QuitaSel
Boton=0
UsaTeclaRapida=S
TeclaRapida=Ctrl+Q
NombreDesplegar=&Quitar Selección
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

