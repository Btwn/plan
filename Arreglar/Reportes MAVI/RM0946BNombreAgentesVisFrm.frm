[Forma]
Clave=RM0946BNombreAgentesVisFrm
Nombre=Agentes
Icono=0
Modulos=(Todos)
ListaCarpetas=RM0946BNombreAgentesVis
CarpetaPrincipal=RM0946BNombreAgentesVis
PosicionInicialAlturaCliente=273
PosicionInicialAncho=232
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=396
PosicionInicialArriba=230
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=selecionar<BR>cerrar<BR>localizar
VentanaBloquearAjuste=S
[RM0946NombreAgentesVis.Columnas]
0=217
[Acciones.selecionar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.selecionar.Registrar]
Nombre=Registrar
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Vista<T>)
Activo=S
Visible=S
[Acciones.selecionar.Sel]
Nombre=Sel
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=asigna(Mavi.RM0946agente,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>EXEC dbo.SP_MaviCuentaEstacionUEN :nEst, 1<T>,EstacionTrabajo)
[Acciones.selecionar]
Nombre=selecionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asigna<BR>Registrar<BR>Sel
Activo=S
Visible=S
[Acciones.cerrar]
Nombre=cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.localizar]
Nombre=localizar
Boton=68
NombreEnBoton=S
NombreDesplegar=&Localizar
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Localizar
Activo=S
Visible=S
[RM0946BNombreAgentesVis]
Estilo=Iconos
Clave=RM0946BNombreAgentesVis
PermiteLocalizar=S
AlineacionAutomatica=S
AcomodarTexto=S
Zona=A1
Vista=RM0946BNombreAgentesVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosSubTitulo=<T>Agentes<T>
ElementosPorPagina=200
IconosConRejilla=S
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
IconosNombre=RM0946BNombreAgentesVis:agentecobrador
[RM0946BNombreAgentesVis.Columnas]
0=-2

