[Forma]
Clave=DM0188Calificacionesfrm
Nombre=DM0188Calificaciones
Icono=0
Modulos=(Todos)
ListaCarpetas=variables
CarpetaPrincipal=variables
PosicionInicialAlturaCliente=546
PosicionInicialAncho=460
PosicionInicialIzquierda=403
PosicionInicialArriba=225
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
[variables]
Estilo=Iconos
Clave=variables
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0188CalificacionesDistintasVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
MenuLocal=S
ListaAcciones=selec<BR>quitar
ListaEnCaptura=SituacionCalif
[variables.Columnas]
0=-2
1=-2
[Acciones.Seleccionar.asig]
Nombre=asig
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccionar.reg]
Nombre=reg
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>variables<T>)
[Acciones.Seleccionar.selec]
Nombre=selec
Boton=0
TipoAccion=Ventana
Activo=S
Visible=S
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(Mavi.DM0188Calificaciones,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
TipoAccion=b
ClaveAccion=Seleccionar Todo
ListaAccionesMultiples=asig<BR>reg<BR>selec
Activo=S
Visible=S
NombreEnBoton=S
[Acciones.selec]
Nombre=selec
Boton=0
NombreDesplegar=&Seleccionar todo
EnMenu=S
TipoAccion=controles Captura
ClaveAccion=seleccionar Todo
Activo=S
Visible=S
[Acciones.quitar]
Nombre=quitar
Boton=0
NombreDesplegar=&Deseleccionar todo
EnMenu=S
TipoAccion=controles Captura
ClaveAccion=quitar Seleccion
Activo=S
Visible=S
[variables.SituacionCalif]
Carpeta=variables
Clave=SituacionCalif
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco
ColorFuente=Negro

