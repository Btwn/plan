[Forma]
Clave=RM1153Familiafrm
Nombre=RM1153 Familia  
Icono=0
Modulos=(Todos)
ListaCarpetas=Familia
CarpetaPrincipal=Familia
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialAlturaCliente=273
PosicionInicialAncho=500
ListaAcciones=Seleccion
[Familia]
Estilo=Iconos
Clave=Familia
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1153FamiliaVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Familias<T>
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Negro
CarpetaVisible=S
IconosSeleccionMultiple=S
MenuLocal=S
IconosNombre=RM1153FamiliaVis:familia
ListaAcciones=todo<BR>Quitar
[Familia.Columnas]
0=-2
[Acciones.Seleccion.asign]
Nombre=asign
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccion.expre]
Nombre=expre
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Familia<T>)
[Acciones.Seleccion]
Nombre=Seleccion
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=asign<BR>expre<BR>selec
Activo=S
Visible=S
[Acciones.Seleccion.selec]
Nombre=selec
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(Mavi.RM1153Familia,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Acciones.todo]
Nombre=todo
Boton=0
NombreDesplegar=&Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.Quitar]
Nombre=Quitar
Boton=0
NombreDesplegar=&Quitar Seleccion 
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
