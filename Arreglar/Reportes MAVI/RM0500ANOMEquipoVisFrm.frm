[Forma]
Clave=RM0500ANOMEquipoVisFrm
Nombre=Equipos Mavi
Icono=0
Modulos=(Todos)
ListaCarpetas=vista
CarpetaPrincipal=vista
PosicionInicialAlturaCliente=383
PosicionInicialAncho=201
PosicionInicialIzquierda=539
PosicionInicialArriba=303
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Sel
[MaviEquipo.Columnas]
equipo=169
[vista]
Estilo=Iconos
Clave=vista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0500ANOMEquipoVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Equipo
CarpetaVisible=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
MenuLocal=S
ListaAcciones=SelAll<BR>QuitAll
IconosNombre=RM0500ANOMEquipoVis:Equipo
[vista.Equipo]
Carpeta=vista
Clave=Equipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[vista.Columnas]
Equipo=64
0=-2
1=-2
[Acciones.Sel.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Sel]
Nombre=Sel
Boton=23
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asigna<BR>Reg<BR>Ven
Activo=S
Visible=S
NombreEnBoton=S
[Acciones.Sel.Reg]
Nombre=Reg
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>RM0500ANOMEquipoVis<T>)
[Acciones.Sel.Ven]
Nombre=Ven
Boton=0
Activo=S
Visible=S
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+estacionTrabajo+<T>,2<T>)
[Acciones.SelAll]
Nombre=SelAll
Boton=0
NombreDesplegar=&SeleccionarTodo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.QuitAll]
Nombre=QuitAll
Boton=0
NombreDesplegar=&QuitarSeleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

