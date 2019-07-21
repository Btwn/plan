
[Forma]
Clave=RM1107SucursalFrm
Icono=0
Modulos=(Todos)
Nombre=RM1107Sucursal

ListaCarpetas=lista
CarpetaPrincipal=lista
PosicionInicialAlturaCliente=515
PosicionInicialAncho=355
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
[lista]
Estilo=Iconos
Clave=lista
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1107SUCURSALESVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Nombre
CarpetaVisible=S

ListaAcciones=(Lista)
IconosNombre=RM1107SUCURSALESVis:Sucursal
[lista.Nombre]
Carpeta=lista
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro

[lista.Columnas]
0=54

1=-2
2=-2
[Acciones.Seleccionartodo]
Nombre=Seleccionartodo
Boton=0
NombreDesplegar=&Seleccionar todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.Quitarseleccion]
Nombre=Quitarseleccion
Boton=0
NombreDesplegar=Quitar seleccion
EnMenu=S
Activo=S
Visible=S


[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=0
NombreDesplegar=&Seleccionar sucursales
EnBarraHerramientas=S
Activo=S
Visible=S

NombreEnBoton=S
Multiple=S
BtnResaltado=S
ListaAccionesMultiples=(Lista)
[Acciones.Seleccionar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Seleccionar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Nombre<T>)
Activo=S
Visible=S

[Acciones.Seleccionar.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S

Expresion=Asigna(Mavi.RM1107SUCURSALES,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)





[Acciones.Seleccionar.ListaAccionesMultiples]
(Inicio)=Asignar
Asignar=Expresion
Expresion=Seleccionar
Seleccionar=(Fin)




[lista.ListaEnCaptura]
(Inicio)=Sucursal
Sucursal=Nombre
Nombre=(Fin)





[lista.ListaAcciones]
(Inicio)=Seleccionartodo
Seleccionartodo=Quitarseleccion
Quitarseleccion=(Fin)
