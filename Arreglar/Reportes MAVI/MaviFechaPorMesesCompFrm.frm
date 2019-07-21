[Forma]
Clave=MaviFechaPorMesesCompFrm
Nombre=Seleccionar Meses a Comparar
Icono=729
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=Vista
CarpetaPrincipal=Vista
PosicionInicialAlturaCliente=281
PosicionInicialAncho=255
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaAvanzaTab=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=384
PosicionInicialArriba=230
VentanaBloquearAjuste=S
ListaAcciones=Sel
[Vista]
Estilo=Iconos
PestanaOtroNombre=S
PestanaNombre=Meses
Clave=Vista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=MaviFechaporMesesVIS
Fuente={Tahoma, 8, Negro, [Negritas]}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Meses del Año<T>
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
IconosSeleccionMultiple=S
ConFuenteEspecial=S
MenuLocal=S
IconosNombre=MaviFechaporMesesVIS:Mes
ListaAcciones=SelTodo<BR>QuitaSel
[Vista.Columnas]
0=243
[Acciones.Sel.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Vista<T>)
Activo=S
Visible=S
[Acciones.Sel]
Nombre=Sel
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
ListaAccionesMultiples=Asignar<BR>Registra
Activo=S
Visible=S
[Acciones.Sel.Registra]
Nombre=Registra
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,2<T>)
Activo=S
Visible=S
[Acciones.SelTodo]
Nombre=SelTodo
Boton=0
UsaTeclaRapida=S
TeclaRapida=Ctrl+T
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
TeclaRapida=Ctrl+Q
NombreDesplegar=&Quitar Selección
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

