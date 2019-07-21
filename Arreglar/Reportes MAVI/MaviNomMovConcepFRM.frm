[Forma]
Clave=MaviNomMovConcepFRM
Nombre=Selecciona los Movimientos de Nomina
Icono=152
Modulos=(Todos)
ListaCarpetas=Movimientos
CarpetaPrincipal=Movimientos
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=RegSel
PosicionInicialIzquierda=488
PosicionInicialArriba=428
PosicionInicialAlturaCliente=140
PosicionInicialAncho=303
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
[Movimientos]
Estilo=Iconos
PestanaOtroNombre=S
PestanaNombre=Movimientos de conceptos
Clave=Movimientos
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=MaviNomMovConcepVIS
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosConPaginas=S
ElementosPorPagina=10
IconosConRejilla=S
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Negro
CarpetaVisible=S
IconosNombre=MaviNomMovConcepVIS:Movimiento
IconosSubTitulo=Movimientos
ListaAcciones=SelAll<BR>quitSel
[Acciones.SelAll]
Nombre=SelAll
Boton=0
NombreDesplegar=Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.quitSel]
Nombre=quitSel
Boton=0
NombreDesplegar=Quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[Acciones.RegSel.Asig]
Nombre=Asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.RegSel.Reg]
Nombre=Reg
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Movimientos<T>)
Activo=S
Visible=S
[Acciones.RegSel.Exec]
Nombre=Exec
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Acciones.RegSel]
Nombre=RegSel
Boton=23
NombreEnBoton=S
NombreDesplegar=Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asig<BR>Reg<BR>Exec
Activo=S
Visible=S
[Movimientos.Columnas]
0=290

