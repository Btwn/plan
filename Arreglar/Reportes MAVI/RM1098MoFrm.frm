[Forma]
Clave=RM1098MoFrm
Nombre=RM1098 Movimiento
Icono=0
BarraHerramientas=S
Modulos=DIN
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=RM1098Mov
CarpetaPrincipal=RM1098Mov
PosicionInicialAlturaCliente=326
PosicionInicialAncho=467
ListaAcciones=Seleccion
[RM1098Mov]
Estilo=Iconos
Clave=RM1098Mov
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1098MovVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=Mov
ListaAcciones=todo<BR>quita
IconosSeleccionMultiple=S
[Acciones.todo]
Nombre=todo
Boton=0
NombreDesplegar=Seleccionar &Todo
EnMenu=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.quita]
Nombre=quita
Boton=0
NombreDesplegar=&Quitar Seleccion
EnMenu=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[RM1098Mov.Mov]
Carpeta=RM1098Mov
Clave=Mov
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[RM1098Mov.Columnas]
0=-2
[Acciones.Seleccion.Asig]
Nombre=Asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccion.exp]
Nombre=exp
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>RM1098Mov<T>)
Activo=S
Visible=S
[Acciones.Seleccion]
Nombre=Seleccion
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=Asig<BR>exp<BR>selec
Activo=S
Visible=S
[Acciones.Seleccion.selec]
Nombre=selec
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(Mavi.RM1098Mov,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
Activo=S
Visible=S
