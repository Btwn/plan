[Forma]
Clave=RM0755TipoSucurAnalisisFrm
Nombre=Tipos de Sucursales
Icono=402
Modulos=(Todos)
ListaCarpetas=Vista
CarpetaPrincipal=Vista
PosicionInicialAlturaCliente=171
PosicionInicialAncho=225
PosicionInicialIzquierda=527
PosicionInicialArriba=409
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
VentanaAvanzaTab=S
ExpresionesAlMostrar=Asigna(Mavi.SW,1)<BR>si vacio(Mavi.RM0755UENNUM)<BR>entonces<BR>sI(precaucion(<T>Debe seleccionar una UEN<T>, BotonAceptar)=BotonAceptar,AbortarOperacion,AbortarOperacion)<BR>Fin

[Vista]
Estilo=Iconos
Clave=Vista
AlineacionAutomatica=S
AcomodarTexto=S
Zona=A1
Vista=RM0755TipoSucurAnalisisVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Tipo de Sucursal
MenuLocal=S
ListaAcciones=SelecAll<BR>QuitarSel
CarpetaVisible=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosConRejilla=S
IconosSeleccionMultiple=S

[Vista.Tipo de Sucursal]
Carpeta=Vista
Clave=Tipo de Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

[Vista.Columnas]
Tipo de Sucursal=196
0=213

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
BtnResaltado=S
Multiple=S
ListaAccionesMultiples=Asigna<BR>Registrar<BR>Seleccionar
Activo=S
Visible=S

[Acciones.Seleccionar.Registrar]
Nombre=Registrar
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>vista<T>)

[Acciones.Seleccionar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Seleccionar.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)

[Acciones.SelecAll]
Nombre=SelecAll
Boton=0
NombreDesplegar=&Seleccionar Todos
GuardarAntes=S
RefrescarDespues=S
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.QuitarSel]
Nombre=QuitarSel
Boton=0
NombreDesplegar=&Quitar Selección
GuardarAntes=S
RefrescarDespues=S
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+R


[Acciones.AutoAsigna.Seleccion]
Nombre=Seleccion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=SeleccionarTodo(<T>Vista<T>)

[Acciones.AutoAsigna.Stop]
Nombre=Stop
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.SW,0)

