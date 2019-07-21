
[Forma]
Clave=RM1172SucursalesFrm
Icono=0
Modulos=(Todos)

ListaCarpetas=suc
CarpetaPrincipal=suc
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=selec
PosicionInicialAlturaCliente=273
PosicionInicialAncho=500
[suc]
Estilo=Iconos
Clave=suc
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1172SucursalesVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSeleccionMultiple=S
ElementosPorPaginaEsp=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Sucursal
CarpetaVisible=S

MenuLocal=S
ListaAcciones=todo<BR>quitar
[suc.Sucursal]
Carpeta=suc
Clave=Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Acciones.selec.asign]
Nombre=asign
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.selec.expre]
Nombre=expre
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Suc<T>)
Activo=S
Visible=S

[Acciones.selec]
Nombre=selec
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=asign<BR>expre<BR>seleccion
Activo=S
Visible=S


[suc.Columnas]
0=-2

[Acciones.todo]
Nombre=todo
Boton=0
NombreDesplegar=&Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.quitar]
Nombre=quitar
Boton=0
NombreDesplegar=&Quitar Todos
EnMenu=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

[Acciones.selec.seleccion]
Nombre=seleccion
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(Mavi.RM1172Sucursales,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
