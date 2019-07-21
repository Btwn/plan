[Forma]
Clave=RM1100XMLFiltrosUsuariosFrm
Nombre=RM1100XMLFiltrosUsuarios
Icono=407
Modulos=(Todos)
ListaCarpetas=VISTA
CarpetaPrincipal=VISTA
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialAlturaCliente=182
PosicionInicialAncho=167
ListaAcciones=selec
PosicionInicialIzquierda=589
PosicionInicialArriba=235
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaBloquearAjuste=S
[P42.Columnas]
0=-2
1=217
[Acciones.selec.asign]
Nombre=asign
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.selec.regis]
Nombre=regis
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>VISTA<T>)
[Acciones.selec]
Nombre=selec
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=asign<BR>regis<BR>seleciona
Activo=S
Visible=S
BtnResaltado=S
[Acciones.selec.seleciona]
Nombre=seleciona
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(Mavi.RM1100XMLFiltrosUsuarios,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Acciones.selc]
Nombre=selc
Boton=0
NombreDesplegar=&Seleccionar Todo
EnMenu=S
EspacioPrevio=S
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
[VISTA]
Estilo=Iconos
Clave=VISTA
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1100XMLFiltrosUsuariosVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Usuario
ListaAcciones=selc<BR>quitar
CarpetaVisible=S
[VISTA.Usuario]
Carpeta=VISTA
Clave=Usuario
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[VISTA.Columnas]
0=-2

