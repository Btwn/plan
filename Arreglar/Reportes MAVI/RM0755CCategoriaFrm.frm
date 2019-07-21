
[Forma]
Clave=RM0755CCategoriaFrm
Icono=340
Modulos=(Todos)

ListaCarpetas=Categoria


CarpetaPrincipal=Categoria
PosicionInicialAlturaCliente=210
PosicionInicialAncho=382
Nombre=Canal Categoria
PosicionInicialIzquierda=449
PosicionInicialArriba=384
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaBloquearAjuste=S
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccion
[Categoria]
Estilo=Iconos
Clave=Categoria
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0755CCategoriaVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S


IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSeleccionMultiple=S
MenuLocal=S
ListaAcciones=SeleccionarTodo<BR>QuitarSeleccion
IconosSubTitulo=<T>Categoria<T>
IconosNombre=RM0755CCategoriaVis:CATEGORIA
[Categoria.Columnas]
CATEGORIA=354

Categoria=354
0=-2
1=-2

[Acciones.SeleccionarTodo]
Nombre=SeleccionarTodo
Boton=0
NombreDesplegar=Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.QuitarSeleccion]
Nombre=QuitarSeleccion
Boton=0
NombreDesplegar=Quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

[Acciones.Seleccion]
Nombre=Seleccion
Boton=23
NombreEnBoton=S
NombreDesplegar=S&eleccionar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S

ListaAccionesMultiples=Variables Asignar<BR>Expresion<BR>SeleccionaRes
[Acciones.Seleccion.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Seleccion.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Categoria<T>)

[Acciones.Seleccion.SeleccionaRes]
Nombre=SeleccionaRes
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(Mavi.RM0755CCategoriaCanal,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)<BR>Reemplaza( Comillas(<T>,<T>),<T>,<T>, Mavi.RM0755CCategoriaCanal)

