[Forma]
Clave=RM1150LineasArtVisFrm
Nombre=Lineas
Icono=0
Modulos=(Todos)
ListaCarpetas=formas
CarpetaPrincipal=formas
PosicionInicialAlturaCliente=273
PosicionInicialAncho=428
PosicionInicialIzquierda=346
PosicionInicialArriba=225
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
[formas]
Estilo=Iconos
Clave=formas
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1150LineasArtVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=Linea
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
MenuLocal=S
ListaAcciones=selec<BR>quit
[formas.Linea]
Carpeta=formas
Clave=Linea
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[formas.Columnas]
Linea=354
0=243
1=-2
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=Seleccionar
EnBarraHerramientas=S
BtnResaltado=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=var<BR>asig<BR>selec
[Acciones.Seleccionar.var]
Nombre=var
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccionar.asig]
Nombre=asig
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>formas<T>)
[Acciones.Seleccionar.selec]
Nombre=selec
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(Mavi.RM1150LineasArt,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)<BR>Reemplaza( Comillas(<T>,<T>),<T>,<T>, Mavi.RM1150LineasArt)
[Acciones.selec]
Nombre=selec
Boton=0
NombreDesplegar=&Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.quit]
Nombre=quit
Boton=0
NombreDesplegar=&Quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
