[Forma]
Clave=DM0232EstatusFrm
Nombre=Estatus
Icono=0
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=Estatus
CarpetaPrincipal=Estatus
PosicionInicialAlturaCliente=273
PosicionInicialAncho=500
ListaAcciones=Seleccion
[Acciones.todo]
Nombre=todo
Boton=0
NombreDesplegar=Seleccionar &Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.quitar]
Nombre=quitar
Boton=0
NombreDesplegar=&Quitar Seleccion
EnMenu=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[Estatus]
Estilo=Iconos
Clave=Estatus
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0232EstatusVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Estatus
ListaAcciones=todo<BR>quitar
CarpetaVisible=S
[Estatus.Estatus]
Carpeta=Estatus
Clave=Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Estatus.Columnas]
0=-2
[Acciones.Seleccion.asign]
Nombre=asign
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccion.exp]
Nombre=exp
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Estatus<T>)
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
ListaAccionesMultiples=asign<BR>exp<BR>sele
Activo=S
Visible=S
[Acciones.Seleccion.sele]
Nombre=sele
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(Mavi.DM0232Estatus,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
