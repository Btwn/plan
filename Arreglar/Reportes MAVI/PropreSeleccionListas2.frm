[Forma]
Clave=PropreSeleccionListas2
Icono=0
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialAlturaCliente=273
PosicionInicialAncho=203
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Cerrar
BarraHerramientas=S
AutoGuardar=S
PosicionInicialIzquierda=255
PosicionInicialArriba=92
Nombre=Grupo 2
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
[ya.Columnas]
0=-2
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
GuardarAntes=S
EnBarraHerramientas=S
EnBarraAcciones=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Antes=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asignar<BR>Actualizar<BR>Cerrar
AntesExpresiones=RegistrarSeleccion(<T>ya<T>)<BR>EjecutarSQL(<T>spPropreSeleccLista2 :nEstac<T>, EstacionTrabajo )
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Lista]
Estilo=Iconos
PestanaNombre=Listas
Clave=Lista
PermiteEditar=S
GuardarAlSalir=S
AlineacionAutomatica=S
AcomodarTexto=S
Zona=A1
Vista=proprelista
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
ElementosPorPagina=200
IconosSeleccionMultiple=S
IconosCambiarOrden=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=PropreLista.Descripcion
CarpetaVisible=S
IconosSubTitulo=<T>Listas<T>
IconosNombre=proprelista:PropreLista.Lista
[Lista.Columnas]
0=-2
1=-2
[Acciones.Aceptar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Aceptar.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Expresion
Expresion=ActualizarVista(<T>PropreListaGrupo2<T>)<BR>ActualizarForma(<T>PropreR09<T>)
Activo=S
Visible=S
[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Lista.PropreLista.Descripcion]
Carpeta=Lista
Clave=PropreLista.Descripcion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

