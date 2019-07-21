
[Forma]
Clave=RM1183SucursalesFrm
Icono=0
Modulos=(Todos)

ListaCarpetas=Sucursales
CarpetaPrincipal=Sucursales
PosicionInicialAlturaCliente=273
PosicionInicialAncho=500
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=selc
Nombre=Sucursales
PosicionInicialIzquierda=448
PosicionInicialArriba=231
[Sucursales]
Estilo=Iconos
Clave=Sucursales
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1183SucursalesVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSeleccionMultiple=S
ElementosPorPaginaEsp=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S

MenuLocal=S
ListaAcciones=selec<BR>quitar
IconosSubTitulo=<T>suc<T>

ListaEnCaptura=Nombre
IconosNombre=RM1183SucursalesVis:Suc
[Sucursales.Columnas]
0=-2
1=-2

2=-2
[Acciones.selec]
Nombre=selec
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
NombreDesplegar=&Quitar Seleccion
EnMenu=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

[Acciones.selc.asinga]
Nombre=asinga
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.selc.expre]
Nombre=expre
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=RegistrarSeleccion(<T>Sucursales<T>)
[Acciones.selc]
Nombre=selc
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=asinga<BR>expre<BR>seleccion
Activo=S
Visible=S

[Acciones.selc.seleccion]
Nombre=seleccion
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(Mavi.RM1183Sucursal,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
Activo=S
Visible=S

[Sucursales.Nombre]
Carpeta=Sucursales
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco


