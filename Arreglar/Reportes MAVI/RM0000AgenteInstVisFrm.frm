[Forma]
Clave=RM0000AgenteInstVisFrm
Icono=0
Modulos=(Todos)
ListaCarpetas=Vistaagentes
CarpetaPrincipal=Vistaagentes
PosicionInicialAlturaCliente=714
PosicionInicialAncho=343
Nombre=RM0000 Agentes de Instituciones
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=468
PosicionInicialArriba=138
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
[Vistaagentes.Columnas]
0=89
Nombre=604
Agente=64
1=226
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asigna<BR>Registar<BR>Seleccionar
[Acciones.Seleccionar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Seleccionar.Registar]
Nombre=Registar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Vistaagentes<T>)
[Acciones.Seleccionar.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
Activo=S
Visible=S
ClaveAccion=Seleccionar/Resultado
Expresion=SQL(<T>EXEC SP_MaviCuentaEstacionUen :nSt, 2<T>,EstacionTrabajo)
[VistaAgentes.Nombre]
Carpeta=Vistaagentes
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Vistaagentes]
Estilo=Iconos
Clave=Vistaagentes
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0000AgenteInstVis
Fuente={MS Sans Serif, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Nombre
IconosSubTitulo=Agentes
IconosSeleccionMultiple=S
PestanaOtroNombre=S
PestanaNombre=Agentes
IconosNombre=RM0000AgenteInstVis:Agente

