[Forma]
Clave=RM0755SucuAnadeCartFrm
Nombre=<T>Sucursal<T>
Icono=0
Modulos=(Todos)
ListaCarpetas=Vista
CarpetaPrincipal=Vista
PosicionInicialIzquierda=527
PosicionInicialArriba=245
PosicionInicialAlturaCliente=500
PosicionInicialAncho=226
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(Mavi.SW,1)<BR>/*si vacio(Mavi.RM0755UENNUM)<BR>    entonces<BR>        precaucion(<T>Debe seleccionar una UEN<T>)<BR>        abortaroperacion<BR>sino<BR>si vacio(Mavi.RM0755TipoSucurAnalisis)<BR>    entonces<BR>        precaucion(<T>Debe seleccionar un Tipo de Sucursal<T>)<BR>        abortaroperacion<BR>fin<BR>fin<BR>    */<BR> /**/<BR>/*precaucion(<T>Debe seleccionar un Tipo de Sucursal<T>,botonaceptar)=botonaceptar,abortaroperacion,abortaroperacion<BR> sino<BR>si (condatos(Mavi.TipoSucurAnalisis))<BR>entonces<BR>asigna(mavi.tiposucuranalisis,nulo)*/<BR>//sino<BR>//<T><T><BR>//fin

[Vista]
Estilo=Iconos
Clave=Vista
AlineacionAutomatica=S
AcomodarTexto=S
Zona=A1
Vista=RM0755SucuAnadeCartVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
MenuLocal=S
ListaAcciones=Todos<BR>QuitarSeleccion
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSubTitulo=<T>Sucursal<T>
IconosConRejilla=S
IconosSeleccionMultiple=S
ListaEnCaptura=Nombre
IconosNombre=RM0755SucuAnadeCartVis:Num

[Vista.Columnas]
0=52
1=145
Sucursal=100
Nombre=136
ID=24

[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
GuardarAntes=S
RefrescarDespues=S
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asigna<BR>Registrar<BR>Sel
BtnResaltado=S

[Acciones.Todos]
Nombre=Todos
Boton=0
NombreDesplegar=&Seleccionar Todos
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+E

[Acciones.QuitarSeleccion]
Nombre=QuitarSeleccion
Boton=0
NombreDesplegar=&Quitar Selección
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+R

[Acciones.Seleccionar.Registrar]
Nombre=Registrar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Vista<T>)  <BR>//Asigna(Mavi.Factura,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo))<BR>//Asigna(Mavi.SucuAdeC, nulo)

[Acciones.Seleccionar.Sel]
Nombre=Sel
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,2<T>)

[Acciones.Seleccionar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
[Acciones.AutoSelecciona.Seleccion]
Nombre=Seleccion
Boton=0
TipoAccion=Expresion
Expresion=SeleccionarTodo(<T>Vista<T>)
Activo=S
Visible=S

[Acciones.AutoSelecciona.Stop]
Nombre=Stop
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Mavi.SW,0)
Activo=S
Visible=S


[Vista.Nombre]
Carpeta=Vista
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro

