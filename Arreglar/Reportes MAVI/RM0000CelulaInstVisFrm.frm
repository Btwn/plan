[Forma]
Clave=RM0000CelulaInstVisFrm
Nombre=Rm0000Celulas de instituciones
Icono=0
ListaCarpetas=vistacelulas
CarpetaPrincipal=vistacelulas
PosicionInicialAlturaCliente=567
PosicionInicialAncho=308
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
PosicionInicialIzquierda=486
PosicionInicialArriba=211
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
[vistacelulas]
Estilo=Iconos
Clave=vistacelulas
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0000CelulaInstVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=Celulas
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Negro
CarpetaVisible=S
IconosSeleccionMultiple=S
PestanaOtroNombre=S
PestanaNombre=Celulas
IconosNombre=RM0000CelulaInstVis:Equipo
[vistacelulas.Columnas]
0=-2
[Acciones.Seleccionar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Seleccionar.Registra]
Nombre=Registra
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>vistacelulas<T>)
[Acciones.Seleccionar.Seleccion]
Nombre=Seleccion
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=SQL(<T>EXEC SP_MaviCuentaEstacionUen :nSt, 2<T>,EstacionTrabajo)
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asigna<BR>Registra<BR>Seleccion
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S

