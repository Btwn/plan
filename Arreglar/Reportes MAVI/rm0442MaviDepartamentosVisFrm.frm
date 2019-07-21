[Forma]
Clave=rm0442MaviDepartamentosVisFrm
Nombre=RM0442 Dpartamentos
Icono=0
Modulos=(Todos)
ListaCarpetas=rm0442MaviDepartamentosVis
CarpetaPrincipal=rm0442MaviDepartamentosVis
PosicionInicialAlturaCliente=272
PosicionInicialAncho=293
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=493
PosicionInicialArriba=359
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
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
NombreDesplegar=&Quitar Selección
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[MaviAgenteEIVis.Columnas]
0=114
1=-2
[Acciones.Seleccionar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asigna<BR>Registra<BR>Seleccion
Activo=S
Visible=S
[Acciones.Seleccionar.Registra]
Nombre=Registra
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Vista<T>)
[Acciones.Seleccionar.Seleccion]
Nombre=Seleccion
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[rm0442MaviDepartamentosVis]
Estilo=Iconos
Clave=rm0442MaviDepartamentosVis
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=rm0442MaviDepartamentosVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Departamento<T>
ElementosPorPagina=200
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
IconosNombre=rm0442MaviDepartamentosVis:descripcion
[rm0442MaviDepartamentosVis.Columnas]
0=-2

