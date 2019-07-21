[Forma]
Clave=RM0292SucuXUENFRM
Nombre=Sucursales por UEN
Icono=0
Modulos=(Todos)
ListaCarpetas=vista
CarpetaPrincipal=vista
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=511
PosicionInicialArriba=349
PosicionInicialAlturaCliente=291
PosicionInicialAncho=257
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
Vista=RM0292SucuXUENVIS
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=NOMBRE
MenuLocal=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosNombre=RM0292SucuXUENVIS:SUCURSAL
IconosSubTitulo=sucursal
ElementosPorPagina=200
IconosConRejilla=S
IconosSeleccionMultiple=S
ListaAcciones=selctodo<BR>quitasel
[vista.Columnas]
SUCURSAL=64
NOMBRE=172
0=-2
1=-2
[vista.NOMBRE]
Carpeta=vista
Clave=NOMBRE
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
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
Expresion=asigna(Mavi.RM0292SucuXUEN,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>     SQL(<T>EXEC dbo.SP_MaviCuentaEstacionUEN :nEst, 1<T>,EstacionTrabajo)

