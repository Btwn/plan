[Forma]
Clave=RM0500ANOMNivelesCobranzaVisFrm
Nombre=Niveles de Cobranza
Icono=132
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=Niveles
CarpetaPrincipal=Niveles
PosicionInicialAlturaCliente=310
PosicionInicialAncho=199
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=540
PosicionInicialArriba=340
ListaAcciones=Sel
VentanaBloquearAjuste=S
[Niveles]
Estilo=Iconos
Clave=Niveles
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0500ANOMNivelesCobranzaVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
MenuLocal=S
ListaAcciones=selAll<BR>QuitSel
IconosConRejilla=S
RefrescarAlEntrar=S
IconosNombre=RM0500ANOMNivelesCobranzaVis:nivelcobranza
[Niveles.Columnas]
Nombre=319
nivelcobranza=304
0=-2
1=-2
[Acciones.Sel]
Nombre=Sel
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asigna<BR>Reg<BR>Ven
[Acciones.Sel.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Sel.Reg]
Nombre=Reg
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>RM0500ANOMNivelesCobranzaVis<T>)
[Acciones.Sel.Ven]
Nombre=Ven
Boton=0
TipoAccion=Ventana
Activo=S
Visible=S
ClaveAccion=Seleccionar/Resultado
Expresion=SQL(<T>Exec SP_MaviCuentaEstacionUen <T>+estaciontrabajo+<T>,2<T>)
[Acciones.selAll]
Nombre=selAll
Boton=0
NombreDesplegar=&Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.QuitSel]
Nombre=QuitSel
Boton=0
NombreDesplegar=&QuitarSeleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

