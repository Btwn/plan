[Forma]
Clave=RM0292MaviTipoSucuFrm
Nombre=Tipo de Sucursal
Icono=0
Modulos=(Todos)
ListaCarpetas=vista
CarpetaPrincipal=vista
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=535
PosicionInicialArriba=395
PosicionInicialAlturaCliente=199
PosicionInicialAncho=210
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=seleccionar
BarraHerramientas=S
[vista]
Estilo=Iconos
Clave=vista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0292MaviTipoSucuVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=Tipo
MenuLocal=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosConRejilla=S
IconosSeleccionMultiple=S
ListaAcciones=selctodo<BR>quitasel
[vista.Columnas]
SUCURSAL=64
NOMBRE=172
0=-2
1=-2
[Acciones.selctodo]
Nombre=selctodo
Boton=0
NombreDesplegar=Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.quitasel]
Nombre=quitasel
Boton=0
NombreDesplegar=quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[Acciones.seleccionar.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.seleccionar.reg]
Nombre=reg
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Vista<T>)
Activo=S
Visible=S
[Acciones.seleccionar]
Nombre=seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
ListaAccionesMultiples=asigna<BR>reg<BR>sel
Activo=S
Visible=S
EnBarraHerramientas=S
[Acciones.seleccionar.sel]
Nombre=sel
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=asigna(Mavi.TipoSuc292,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>     SQL(<T>EXEC dbo.SP_MaviCuentaEstacionUEN :nEst, 1<T>,EstacionTrabajo)
[vista.Tipo]
Carpeta=vista
Clave=Tipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

