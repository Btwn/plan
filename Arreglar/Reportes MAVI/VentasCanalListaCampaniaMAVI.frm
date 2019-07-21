[Forma]
Clave=VentasCanalListaCampaniaMAVI
Nombre=Canales de Venta
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
ListaCarpetas=Lista
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
CarpetaPrincipal=Lista
ListaAcciones=Aceptar<BR>Cerrar<BR>Seleccionar Todo<BR>Quitar Seleccion
PosicionInicialIzquierda=381
PosicionInicialArriba=239
PosicionInicialAlturaCliente=288
PosicionInicialAncho=517
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Si Vacio(Mavi.CategoCanalesVenta)<BR>    Entonces<BR>        Si(Precaucion(<T>Debe seleccionar una Categoría<T>, BotonAceptar)=BotonAceptar,AbortarOperacion,AbortarOperacion)<BR>Fin
[Lista]
Estilo=Iconos
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=MaviCanalesVentaCveVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Categoria<T>
ElementosPorPagina=200
IconosSeleccionMultiple=S
ListaEnCaptura=Clave<BR>Cadena
IconosNombre=MaviCanalesVentaCveVis:Canal
[Lista.Columnas]
ID=64
Clave=64
Categoria=304
0=68
1=102
2=-2
[Lista.Cadena]
Carpeta=Lista
Clave=Cadena
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Clave]
Carpeta=Lista
Clave=Clave
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Seleccionar/Resultado<BR>Aceptar
Antes=S
AntesExpresiones=RegistrarSeleccion(<T>Vista<T>)<BR>//Asigna(Mavi.UEN,SQL(<T>sp_MAVICuentaEstacionUEN <T> + EstacionTrabajo + <T>, 0<T>))
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
NombreDesplegar=Seleccionar Todo
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
NombreDesplegar=Quitar Seleccion
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[Acciones.Aceptar.Seleccionar/Resultado]
Nombre=Seleccionar/Resultado
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,0<T>)
[Acciones.Aceptar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

