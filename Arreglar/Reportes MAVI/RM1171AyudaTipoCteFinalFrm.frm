
[Forma]
Clave=RM1171AyudaTipoCteFinalFrm
Icono=716
Modulos=(Todos)

ListaCarpetas=Vista
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
CarpetaPrincipal=Vista
PosicionInicialIzquierda=544
PosicionInicialArriba=228
PosicionInicialAlturaCliente=273
PosicionInicialAncho=261
BarraHerramientas=S
Nombre=Tipo de Cliente Final
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccion
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=0
NombreDesplegar=Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.Deseleccionar]
Nombre=Deseleccionar
Boton=0
NombreDesplegar=Quitar Selección
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

[Vista]
Estilo=Iconos
Clave=Vista
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1171AyudaTipoCteFinalVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosNombre=RM1171AyudaTipoCteFinalVis:TipoBF
IconosSeleccionMultiple=S
ElementosPorPaginaEsp=200
CampoColorLetras=Negro
CampoColorFondo=Negro
ListaAcciones=Seleccionar<BR>Deseleccionar
CarpetaVisible=S

[Vista.Columnas]
0=241

[Acciones.Seleccion]
Nombre=Seleccion
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Asignar<BR>Registrar<BR>Resultado
[Acciones.Seleccion.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Seleccion.Registrar]
Nombre=Registrar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=RegistrarSeleccion(<T>Vista<T>)
[Acciones.Seleccion.Resultado]
Nombre=Resultado
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(Mavi.RM1171TipoCteFinal,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)

