[Forma]
Clave=RM0000AgentesporsucursalFrm
Nombre=Agentes de Sucursal
Icono=0
Modulos=(Todos)
ListaCarpetas=Viss
CarpetaPrincipal=Viss
PosicionInicialAlturaCliente=221
PosicionInicialAncho=410
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
EsConsultaExclusiva=S
ListaAcciones=Seleccion<BR>Cancelar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaBloquearAjuste=S
ExpresionesAlMostrar=asigna(Mavi.RM0000AgenteporSucursal,nulo)
PosicionInicialIzquierda=435
PosicionInicialArriba=384
[Viss]
Estilo=Iconos
Clave=Viss
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0000AgentesporSucursalVis
Fuente={Tahoma, 8, Negro, []}
CarpetaVisible=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=NOMBRE<BR>SUCURSAL
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Agente<T>
ElementosPorPagina=250
IconosSeleccionMultiple=S
MenuLocal=S
ListaAcciones=Seleccionar Todo<BR>Quitar
IconosNombre=RM0000AgentesporSucursalVis:Agente
[Viss.Columnas]
0=69
1=228
2=65
3=-2
[Viss.NOMBRE]
Carpeta=Viss
Clave=NOMBRE
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Seleccion.Registra]
Nombre=Registra
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Viss<T>)
[Acciones.Seleccion]
Nombre=Seleccion
Boton=23
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
TipoAccion=Expresion
ListaAccionesMultiples=Registra<BR>Seleccionar
Activo=S
Visible=S
NombreEnBoton=S
[Acciones.Cancelar]
Nombre=Cancelar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Seleccion.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
Activo=S
Visible=S
ClaveAccion=Seleccionar/Resultado
Expresion=SQL(<T>EXEC SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1 <T>)
[Acciones.Seleccionar Todo]
Nombre=Seleccionar Todo
Boton=0
NombreDesplegar=&Seleccionar Todo
EnMenu=S
Activo=S
Visible=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
UsaTeclaRapida=S
TeclaRapida=Ctrl+T
[Acciones.Quitar]
Nombre=Quitar
Boton=0
UsaTeclaRapida=S
TeclaRapida=Ctrl+Q
NombreDesplegar=&Quitar Seleccion
EnMenu=S
TipoAccion=controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[Viss.SUCURSAL]
Carpeta=Viss
Clave=SUCURSAL
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

