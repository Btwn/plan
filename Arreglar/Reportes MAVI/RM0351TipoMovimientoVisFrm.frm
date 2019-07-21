[Forma]
Clave=RM0351TipoMovimientoVisFrm
Nombre=Tipo de Movimiento
Icono=95
Modulos=(Todos)
PosicionInicialAlturaCliente=548
PosicionInicialAncho=166
ListaCarpetas=Vista
CarpetaPrincipal=Vista
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=557
PosicionInicialArriba=93
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccion
[Vista]
Estilo=Iconos
Clave=Vista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0351TipoMovimientoVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
MenuLocal=S
ListaAcciones=SelAll<BR>QuitaSel
ListaEnCaptura=MOVIMIENTO
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
IconosConRejilla=S
[Vista.Columnas]
Tipo=304
Tipo de Sucursal=210
0=134
MOVIMIENTO=304
[Acciones.Seleccion]
Nombre=Seleccion
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccion
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asigna<BR>registra<BR>Seleccion
[Acciones.SelAll]
Nombre=SelAll
Boton=0
UsaTeclaRapida=S
TeclaRapida=Ctrl+E
NombreDesplegar=Seleccionar &Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.QuitaSel]
Nombre=QuitaSel
Boton=0
UsaTeclaRapida=S
TeclaRapida=Ctrl+R
NombreDesplegar=&Quitar Seleccionar
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[Acciones.Seleccion.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccion.registra]
Nombre=registra
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Vista<T>)
[Acciones.Seleccion.Seleccion]
Nombre=Seleccion
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,2<T>)
[Vista.MOVIMIENTO]
Carpeta=Vista
Clave=MOVIMIENTO
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

