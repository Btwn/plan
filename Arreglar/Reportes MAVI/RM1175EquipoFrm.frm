
[Forma]
Clave=RM1175EquipoFrm
Icono=0
Modulos=(Todos)
Nombre=RM1175EquipoFrm

ListaCarpetas=RM1175EquipoVis
CarpetaPrincipal=RM1175EquipoVis
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>SeleccionarTodo<BR>QuitarSeleccion<BR>Cancelar
PosicionInicialAlturaCliente=273
PosicionInicialAncho=398
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=441
PosicionInicialArriba=356
[RM1175EquipoVis]
Estilo=Iconos
Clave=RM1175EquipoVis
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1175EquipoVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S

ListaEnCaptura=Equipo
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosConRejilla=S
IconosSeleccionMultiple=S
ElementosPorPaginaEsp=200
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

[RM1175EquipoVis.Equipo]
Carpeta=RM1175EquipoVis
Clave=Equipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco












[RM1175EquipoVis.Columnas]
Equipo=225
Zona=94
NivelCobranza=304
Region=184
Division=184
Agente=94
Maxcuentas=64
MaxAsociados=72
MaxCtesFinales=79
Categoria=304
UsrMod=94
FechaMod=94
0=361

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
Expresion=RegistrarSeleccion(<T>RM1175EquipoVis<T>)
Activo=S
Visible=S

[Acciones.Aceptar.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(Mavi.RM1175Equipo,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
Activo=S
Visible=S

