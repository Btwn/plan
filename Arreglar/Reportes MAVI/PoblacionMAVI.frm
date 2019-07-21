[Forma]
Clave=PoblacionMAVI
Nombre=PoblacionMAVI
Icono=0
Modulos=(Todos)
ListaCarpetas=PoblacionMAVI
CarpetaPrincipal=PoblacionMAVI
PosicionInicialAlturaCliente=657
PosicionInicialAncho=363
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Si vacio(Info.Estado) o ((Info.Estado) = <T><T>)<BR>    Entonces<BR>        Si(Precaucion(<T>Debe seleccionar un Estado<T>, BotonAceptar)=BotonAceptar,AbortarOperacion,AbortarOperacion)<BR>Fin
PosicionInicialIzquierda=458
PosicionInicialArriba=54
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Cerrar<BR>Seleccionar Todo<BR>Quitar Seleccion
[PoblacionMAVI]
Estilo=Iconos
Clave=PoblacionMAVI
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=PoblacionMAVI
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Negro
CarpetaVisible=S
Filtros=S
IconosSubTitulo=<T>Población<T>
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
IconosNombre=PoblacionMAVI:Delegacion
FiltroGeneral=Estado in ({Info.Estado})
[PoblacionMAVI.Columnas]
0=337
[Acciones.Aceptar.Seleccionar/Resultado]
Nombre=Seleccionar/Resultado
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
Activo=S
Visible=S
[Acciones.Aceptar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Seleccionar/Resultado<BR>Aceptar
Activo=S
Antes=S
AntesExpresiones=RegistrarSeleccion( <T>Vista<T> )
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

