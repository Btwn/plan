[Forma]
Clave=RM1100MovFrm
Nombre=RM1100 Movimientos
Icono=0
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=Movimientos
CarpetaPrincipal=Movimientos
PosicionInicialAlturaCliente=290
PosicionInicialAncho=291
ListaAcciones=Selecccion
[Acciones.todo]
Nombre=todo
Boton=0
NombreDesplegar=Seleccionar &Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.quita]
Nombre=quita
Boton=0
NombreDesplegar=&Quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[Movimientos]
Estilo=Iconos
Clave=Movimientos
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1100MovVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mov
ListaAcciones=todo<BR>quita
CarpetaVisible=S
[Movimientos.Mov]
Carpeta=Movimientos
Clave=Mov
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Movimientos.Columnas]
0=-2
[Acciones.Selecccion.asign]
Nombre=asign
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Selecccion.exp]
Nombre=exp
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Movimientos<T>)
Activo=S
Visible=S
[Acciones.Selecccion]
Nombre=Selecccion
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=asign<BR>exp<BR>selec
Activo=S
Visible=S
[Acciones.Selecccion.selec]
Nombre=selec
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(Mavi.RM1100Mov,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
Activo=S
Visible=S
