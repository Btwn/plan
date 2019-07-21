[Forma]
Clave=RM0946BFiltroCategoriaFrm
Nombre=RM0946B Filtro Categoria
Icono=0
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=lista
CarpetaPrincipal=lista
PosicionInicialIzquierda=214
PosicionInicialArriba=127
PosicionInicialAlturaCliente=189
PosicionInicialAncho=322
ListaAcciones=Seleccio
[Acciones.selectodo]
Nombre=selectodo
Boton=0
NombreDesplegar=Seleccionar &Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.QuitaSel]
Nombre=QuitaSel
Boton=0
NombreDesplegar=&Quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[lista]
Estilo=Iconos
Clave=lista
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0946BCategoriaVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaAcciones=selectodo<BR>QuitaSel
CarpetaVisible=S
IconosSubTitulo=Tipo Seccion Cobranza
IconosNombre=RM0946BCategoriaVis:SeccionCobranzaMavi
[lista.Columnas]
0=-2
[Acciones.Seleccio.asig]
Nombre=asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccio.Registra]
Nombre=Registra
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Lista<T>)
Activo=S
Visible=S
[Acciones.Seleccio]
Nombre=Seleccio
Boton=23
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=asig<BR>Registra<BR>sel
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S
[Acciones.Seleccio.sel]
Nombre=sel
Boton=0
TipoAccion=Ventana
Activo=S
Visible=S
ClaveAccion=Seleccionar/Resultado
Expresion=asigna(Mavi.RM0946BCategoriaFiltro,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>EXEC dbo.SP_MaviCuentaEstacionUEN :nEst, 1<T>,EstacionTrabajo)
