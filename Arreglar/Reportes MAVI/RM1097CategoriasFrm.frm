[Forma]
Clave=RM1097CategoriasFrm
Nombre=Categorias
Icono=0
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=cate
CarpetaPrincipal=cate
PosicionInicialAlturaCliente=273
PosicionInicialAncho=500
ListaAcciones=Seleccion
[cate]
Estilo=Iconos
Clave=cate
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1097CategoriaVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosConRejilla=S
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Categoria
CarpetaVisible=S
MenuLocal=S
ListaAcciones=seltodo<BR>quit
[cate.Categoria]
Carpeta=cate
Clave=Categoria
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[cate.Columnas]
0=-2
[Acciones.Seleccion.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccion.regis]
Nombre=regis
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>cate<T>)
Activo=S
Visible=S
[Acciones.Seleccion]
Nombre=Seleccion
Boton=23
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=asigna<BR>regis<BR>selec
Activo=S
Visible=S
NombreEnBoton=S
[Acciones.Seleccion.selec]
Nombre=selec
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(Mavi.RM1097Categoria,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Acciones.seltodo]
Nombre=seltodo
Boton=0
NombreDesplegar=Seleccionar &Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.quit]
Nombre=quit
Boton=0
NombreDesplegar=&Quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
