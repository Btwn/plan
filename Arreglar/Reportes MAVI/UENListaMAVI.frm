[Forma]
Clave=UENListaMAVI
Nombre=Unidades Estratégicas Negocio (UEN<T>s)
Icono=0
Modulos=(Todos)
ListaCarpetas=ListaMAVI
CarpetaPrincipal=ListaMAVI
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Cerrar<BR>Seleccionar Todo<BR>Quitar Seleccion
PosicionInicialIzquierda=455
PosicionInicialArriba=318
PosicionInicialAlturaCliente=130
PosicionInicialAncho=370
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaEstadoInicial=Normal





[Lista.Columnas]
UEN=44
Nombre=269
[ListaMAVI]
Estilo=Iconos
Clave=ListaMAVI
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=UEN
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
IconosSeleccionMultiple=S
IconosSubTitulo=<T>UEN<T>
ExpAlRefrescar=//Asigna(Info.UEN, UEN:UEN.Nombre)
IconosNombre=UEN:UEN.Nombre
[ListaMAVI.Columnas]
0=358
1=260
2=-2
[Acciones.Aceptar.Seleccionar/Aceptar]
Nombre=Seleccionar/Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
[Acciones.Aceptar.Seleccionar Todo]
Nombre=Seleccionar Todo
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.Seleccionar.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
Activo=S
Visible=S
ClaveAccion=Seleccionar/Resultado
Expresion=SQL(<T>sp_MAVICuentaEstacionUEN <T> + EstacionTrabajo + <T>, 1<T>)
[Acciones.AutoAsigna.Seleccion]
Nombre=Seleccion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=SeleccionarTodo(<T>Vista<T>)
[Acciones.Seleccionar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
EspacioPrevio=S
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
GuardarAntes=S
RefrescarDespues=S
Multiple=S
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
ListaAccionesMultiples=Seleccionar/Resultado<BR>Aceptar
Activo=S
Antes=S
DespuesGuardar=S
Visible=S
AntesExpresiones=RegistrarSeleccion(<T>Vista<T>)<BR>Asigna(Mavi.UEN,SQL(<T>sp_MAVICuentaEstacionUEN <T> + EstacionTrabajo + <T>, 1<T>))
[Acciones.Seleccionar Todo]
Nombre=Seleccionar Todo
Boton=54
NombreEnBoton=S
NombreDesplegar=&Seleccionar Todo
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
EspacioPrevio=S
[Acciones.Quitar Seleccion]
Nombre=Quitar Seleccion
Boton=55
NombreEnBoton=S
NombreDesplegar=&Quitar Seleccion
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[Acciones.Aceptar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
[Acciones.Aceptar.Seleccionar/Resultado]
Nombre=Seleccionar/Resultado
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
