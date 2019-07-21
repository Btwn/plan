
[Forma]
Clave=RM1171AyudaTipoDIMAFrm
Icono=727
Modulos=(Todos)

ListaCarpetas=Vista
CarpetaPrincipal=Vista
PosicionInicialAlturaCliente=273
PosicionInicialAncho=265
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=550
PosicionInicialArriba=228
Nombre=Tipo de Cliente DIMA
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccion
[Vista]
Estilo=Iconos
Clave=Vista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1171AyudaTipoDIMAVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Negro
CarpetaVisible=S

MenuLocal=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosNombre=RM1171AyudaTipoDIMAVis:TipoDIMA
IconosSeleccionMultiple=S
ElementosPorPaginaEsp=200
ListaAcciones=Seleccionar<BR>Deseleccionar
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

[Vista.Columnas]
0=245

[Acciones.Seleccion.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Seleccion.Registro]
Nombre=Registro
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Vista<T>)
Activo=S
Visible=S

[Acciones.Seleccion.Resultado]
Nombre=Resultado
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S

Expresion=Asigna(Mavi.RM1171soloDimas,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Acciones.Seleccion]
Nombre=Seleccion
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asignar<BR>Registro<BR>Resultado
Activo=S
Visible=S

