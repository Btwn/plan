[Forma]
Clave=RM1062CanalFrm
Nombre=Canal de Venta
Icono=0
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=RM1062CanalVis
CarpetaPrincipal=RM1062CanalVis
ListaAcciones=Seleccionar
PosicionInicialAlturaCliente=273
PosicionInicialAncho=175
[Acciones.Seltodo]
Nombre=Seltodo
Boton=0
NombreDesplegar=&Seleccionar todos
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.QuitSel]
Nombre=QuitSel
Boton=0
NombreDesplegar=&Quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[Acciones.Seleccionar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccionar.Regis]
Nombre=Regis
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Vista<T>)
[Acciones.Seleccionar.Selec]
Nombre=Selec
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(Mavi.RM1062CanalFiltro,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
Activo=S
Visible=S
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asigna<BR>Regis<BR>Selec
Activo=S
Visible=S
[Vista.Columnas]
0=-2
[RM1062CanalFiltro.Columnas]
0=-2
[RM1062CanalVis.Columnas]
0=113
1=-2
[RM1062canalVis.CLienteEnviarA]
Carpeta=RM1062CanalVis
Clave=CLienteEnviarA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[RM1062CanalVis]
Estilo=Iconos
Clave=RM1062CanalVis
Vista=RM1062CanalVis
Fuente={MS Sans Serif, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=CLienteEnviarA
