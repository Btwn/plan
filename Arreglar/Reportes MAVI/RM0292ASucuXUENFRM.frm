[Forma]
Clave=RM0292ASucuXUENFRM
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
PosicionInicialAncho=258
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
Vista=RM0292ASucuXUENVIS
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=NOMBRE
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Sucursal<T>
ElementosPorPagina=200
IconosSeleccionMultiple=S
IconosConRejilla=S
MenuLocal=S
IconosNombre=RM0292ASucuXUENVIS:SUCURSAL
ListaAcciones=seleccionatodo<BR>quitatodo
[vista.Columnas]
SUCURSAL=64
NOMBRE=172
0=58
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
[Acciones.seleccionar]
Nombre=seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
Activo=S
Visible=S
ListaAccionesMultiples=asigna<BR>registra<BR>selecciona
EnBarraHerramientas=S
[Acciones.seleccionar.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.seleccionar.registra]
Nombre=registra
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Vista<T>)
Activo=S
Visible=S
[Acciones.seleccionar.selecciona]
Nombre=selecciona
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(Mavi.RM0292ASucuXUEN,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Acciones.seleccionatodo]
Nombre=seleccionatodo
Boton=0
NombreDesplegar=Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.quitatodo]
Nombre=quitatodo
Boton=0
NombreDesplegar=Quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

