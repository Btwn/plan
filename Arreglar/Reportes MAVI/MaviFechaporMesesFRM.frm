[Forma]
Clave=MaviFechaporMesesFRM
Nombre=Seleccione los meses:
Icono=132
Modulos=(Todos)
ListaCarpetas=MaviFechaporMeses
CarpetaPrincipal=MaviFechaporMeses
PosicionInicialIzquierda=529
PosicionInicialArriba=360
PosicionInicialAlturaCliente=274
PosicionInicialAncho=222
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=sel
[MaviFechaporMeses]
Estilo=Iconos
Clave=MaviFechaporMeses
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=MaviFechaporMesesVIS
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=Meses
IconosConPaginas=S
ElementosPorPagina=12
IconosConRejilla=S
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
IconosNombreNumerico=S
PestanaOtroNombre=S
PestanaNombre=Meses
MenuLocal=S
ListaAcciones=SelAll<BR>quitSel
IconosNombre=MaviFechaporMesesVIS:Mes
[MaviFechaporMeses.Columnas]
0=209
1=143
[Acciones.sel.Asig]
Nombre=Asig
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.sel.Registrar]
Nombre=Registrar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>MaviFechaporMeses<T>)
[Acciones.sel]
Nombre=sel
Boton=23
NombreEnBoton=S
NombreDesplegar=Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asig<BR>Registrar<BR>ejec
Activo=S
Visible=S
[Acciones.sel.ejec]
Nombre=ejec
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Acciones.SelAll]
Nombre=SelAll
Boton=0
NombreDesplegar=Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.quitSel]
Nombre=quitSel
Boton=0
NombreDesplegar=Quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

