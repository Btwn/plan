[Forma]
Clave=RM0500ACXCTipoCuotaVisFrm
Nombre=Tipo Cuotas
Icono=0
Modulos=(Todos)
ListaCarpetas=RM0500ACXCTipoCuotaVisFrm
CarpetaPrincipal=RM0500ACXCTipoCuotaVisFrm
PosicionInicialIzquierda=593
PosicionInicialArriba=312
PosicionInicialAlturaCliente=138
PosicionInicialAncho=170
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
[RM0500ACXCTipoCuotaVisFrm]
Estilo=Iconos
Clave=RM0500ACXCTipoCuotaVisFrm
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0500ACXCTipoCuotaVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosConRejilla=S
IconosSeleccionPorLlave=S
IconosSeleccionMultiple=S
IconosSubTitulo=<T>TipoCuota<T>
IconosNombre=RM0500ACXCTipoCuotaVis:Cuota
[RM0500ACXCTipoCuotaVisFrm.Columnas]
Cuota=130
0=-2
1=-2
[Acciones.Seleccionar.Asig]
Nombre=Asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccionar.Regi]
Nombre=Regi
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
ListaAccionesMultiples=Asig<BR>Regi<BR>sdes
Activo=S
Visible=S
[Acciones.Seleccionar.sdes]
Nombre=sdes
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(Mavi.RM0500ATipoCuota,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,2<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,2<T>)
