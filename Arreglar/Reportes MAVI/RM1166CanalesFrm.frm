[Forma]
Clave=RM1166CanalesFrm
Nombre=RM1166 Canales venta
Icono=0
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=Canales
CarpetaPrincipal=Canales
PosicionInicialAlturaCliente=273
PosicionInicialAncho=500
ListaAcciones=Selecc
[Canales]
Estilo=Iconos
Clave=Canales
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1166Canalesvis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=ID
CarpetaVisible=S
MenuLocal=S
ListaAcciones=todo<BR>Quitar
[Canales.ID]
Carpeta=Canales
Clave=ID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Canales.Columnas]
0=-2
[Acciones.Selecc.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Selecc.Expre]
Nombre=Expre
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Canales<T>)
[Acciones.Selecc.selct]
Nombre=selct
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(MAVI.RM1166CV,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
Activo=S
Visible=S
[Acciones.Selecc]
Nombre=Selecc
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asigna<BR>Expre<BR>selct
Activo=S
Visible=S
[Acciones.todo]
Nombre=todo
Boton=0
NombreDesplegar=Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.Quitar]
Nombre=Quitar
Boton=0
NombreDesplegar=Quitar Seleccion
EnMenu=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
