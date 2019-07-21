[Forma]
Clave=RM0946NiveldeCobranzaVisFrm
Nombre=Nivrl de Cobranza
Icono=0
Modulos=(Todos)
ListaCarpetas=RM0946NiveldeCobranzaVis
CarpetaPrincipal=RM0946NiveldeCobranzaVis
PosicionInicialAlturaCliente=254
PosicionInicialAncho=223
PosicionInicialIzquierda=528
PosicionInicialArriba=368
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar<BR>cerrar
ExpresionesAlCerrar=Forma.ActualizarVista(<T>RM0946CxcInfEdoCtasVis<T>)<BR>Forma.ActualizarVista(<T>RM0946CxcInfEdoCtasAcumCteVis<T>)<BR> Forma.ActualizarVista(<T>RM0946CxcInfEdoCtasRutVis<T>)<BR> Forma.ActualizarVista(<T>RM0946CxcInfEdoCtasConRutVis<T>)
[RM0946NiveldeCobranzaVis]
Estilo=Iconos
Clave=RM0946NiveldeCobranzaVis
AlineacionAutomatica=S
AcomodarTexto=S
Zona=A1
Vista=RM0946NiveldeCobranzaVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosNombre=RM0946NiveldeCobranzaVis:nivelcobranza
IconosSubTitulo=<T>Nivel de Cobranza<T>
ElementosPorPagina=200
IconosConRejilla=S
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Negro
CarpetaVisible=S
[RM0946NiveldeCobranzaVis.Columnas]
0=211
[Acciones.Seleccionar.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccionar.registra]
Nombre=registra
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Vista<T>)
Activo=S
Visible=S
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=asigna<BR>registra<BR>sel
Activo=S
Visible=S
[Acciones.Seleccionar.sel]
Nombre=sel
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=asigna(Mavi.RM0946ncobranza,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>EXEC dbo.SP_MaviCuentaEstacionUEN :nEst, 1<T>,EstacionTrabajo)
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

