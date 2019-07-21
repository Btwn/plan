[Forma]
Clave=RM0000DivisionesInstVisFrm
Nombre=Divisiones de Instituciones
Icono=0
Modulos=(Todos)
ListaCarpetas=RM0000DivisionesInst
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
CarpetaPrincipal=RM0000DivisionesInst
ListaAcciones=Seleccionar
PosicionInicialAlturaCliente=263
PosicionInicialAncho=272
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=504
PosicionInicialArriba=363
[Acciones.Seleccionar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Seleccionar.Registrar]
Nombre=Registrar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>RM0953DivisionesInst<T>)
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asigna<BR>Registrar<BR>Seleccion
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S
[Acciones.Seleccionar.Seleccion]
Nombre=Seleccion
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=SQL(<T>EXEC SP_MaviCuentaEstacionUen :nSt, 2<T>,EstacionTrabajo)
[RM0953DivisionesInst.Columnas]
Agente=291
[RM0000DivisionesInst]
Estilo=Iconos
Clave=RM0000DivisionesInst
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0000DivisionesInstVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=Division
ElementosPorPagina=200
IconosSeleccionMultiple=S
PestanaOtroNombre=S
PestanaNombre=Divisiones
IconosNombre=RM0000DivisionesInstVis:Agente
[RM0000DivisionesInst.Columnas]
0=79

