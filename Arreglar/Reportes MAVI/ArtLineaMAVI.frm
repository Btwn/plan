[Forma]
Clave=ArtLineaMAVI
Nombre=Líneas de Artículos
Icono=0
Modulos=INV
AccionesTamanoBoton=14x5
AccionesDerecha=S
ListaCarpetas=Lista
PosicionInicialIzquierda=459
PosicionInicialArriba=224
PosicionInicialAltura=345
PosicionInicialAncho=362
CarpetaPrincipal=Lista
ListaAcciones=Aceptar<BR>Cerrar<BR>Seleccionar Todo<BR>Quitar Seleccion
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=Centrado
BarraHerramientas=S
PosicionInicialAlturaCliente=318

[ArtLinea.Columnas]
Linea=104
Descripcion=304

[Lista]
Estilo=Iconos
PestanaNombre=Lista
Clave=Lista
OtroOrden=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=ArtLinea
Fuente={MS Sans Serif, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaOrden=ArtLinea.Linea<TAB>(Acendente)
CarpetaVisible=S
PermiteEditar=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
IconosNombre=ArtLinea:ArtLinea.Linea
IconosSubTitulo=<T>Linea<T>


[Lista.Columnas]
Linea=234
Descripcion=325
Clave=99
0=336

[Detalles.ArtLinea.Linea]
Carpeta=Detalles
Clave=ArtLinea.Linea
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30

[Detalles.ArtLinea.Icono]
Carpeta=Detalles
Clave=ArtLinea.Icono
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10



[Acciones.Aceptar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
[Acciones.Aceptar.Seleccionar/Resultado]
Nombre=Seleccionar/Resultado
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
Activo=S
Visible=S
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
GuardarAntes=S
Multiple=S
EnBarraHerramientas=S
EnMenu=S
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Aceptar
ListaAccionesMultiples=Seleccionar/Resultado<BR>Aceptar
Activo=S
ConCondicion=S
EjecucionConError=S
Visible=S
EjecucionCondicion=Asigna(Temp.Texto, ListaBuscarDuplicados(CampoEnLista(ArtLinea:ArtLinea.Linea)))<BR>Vacio(Temp.Texto)
EjecucionMensaje=Comillas(Temp.Texto)+<T> Duplicado<T>
Antes=S
AntesExpresiones=RegistrarSeleccion(<T>Vista<T>)
[Acciones.Cerrar]
Nombre=Cerrar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
ActivoCondicion=Usuario.EnviarExcel
Visible=S
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
