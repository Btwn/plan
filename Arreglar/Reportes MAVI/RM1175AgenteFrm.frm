
[Forma]
Clave=RM1175AgenteFrm
Icono=0
BarraHerramientas=S
Modulos=(Todos)
Nombre=RM1175AgenteFrm
AccionesTamanoBoton=15x5
AccionesDerecha=S

ListaAcciones=Aceptar<BR>SeleccionarTodo<BR>QuitarSeleccion<BR>Cancelar
PosicionInicialAlturaCliente=305
PosicionInicialAncho=443
ListaCarpetas=RM1175AgenteVis
CarpetaPrincipal=RM1175AgenteVis
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=418
PosicionInicialArriba=340
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Asignar<BR>Expresion<BR>Seleccionar
[Acciones.Cancelar]
Nombre=Cancelar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cancelar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[RM1175AgenteVis]
Estilo=Iconos
Clave=RM1175AgenteVis
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1175AgenteVis
Fuente={Tahoma, 8, Negro, []}
CarpetaVisible=S

CampoColorLetras=Negro
CampoColorFondo=Blanco
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPaginaEsp=200
IconosConRejilla=S
IconosSeleccionMultiple=S
ListaEnCaptura=Nombre

IconosSubTitulo=Agente
IconosNombre=RM1175AgenteVis:Agente
[RM1175AgenteVis.Nombre]
Carpeta=RM1175AgenteVis
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco


[RM1175AgenteVis.Columnas]
Agente=69
Nombre=367
Estatus=94
0=88
1=318

2=-2


[Acciones.SeleccionarTodo]
Nombre=SeleccionarTodo
Boton=55
NombreEnBoton=S
NombreDesplegar=&Seleccionar Todo
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.QuitarSeleccion]
Nombre=QuitarSeleccion
Boton=35
NombreEnBoton=S
NombreDesplegar=&Quitar Seleccion
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

[Acciones.Aceptar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Aceptar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>RM1175AgenteVis<T>)

[Acciones.Aceptar.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
Activo=S
Visible=S
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(Mavi.RM1175Agente,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)

