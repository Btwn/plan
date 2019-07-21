[Forma]
Clave=RM1101ClavesFrm
Nombre=Calificaciones
Icono=0
Modulos=(Todos)
ListaCarpetas=Califi
CarpetaPrincipal=Califi
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialIzquierda=465
PosicionInicialArriba=146
PosicionInicialAlturaCliente=273
PosicionInicialAncho=378
ListaAcciones=Selecc
[Califi]
Estilo=Iconos
Clave=Califi
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1101ClavesVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Nombre
CarpetaVisible=S
IconosSubTitulo=<T>Calificacion<T>
MenuLocal=S
IconosNombre=RM1101ClavesVis:Calificacion
ListaAcciones=todo<BR>quita
[Califi.Nombre]
Carpeta=Califi
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Califi.Columnas]
0=81
1=275
[Acciones.Selecc.asig]
Nombre=asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Selecc.exp]
Nombre=exp
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Califi<T>)
[Acciones.Selecc]
Nombre=Selecc
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=asig<BR>exp<BR>seleccion
Activo=S
Visible=S
[Acciones.Selecc.seleccion]
Nombre=seleccion
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(Mavi.RM1101Calificacion,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Acciones.todo]
Nombre=todo
Boton=0
NombreDesplegar=Seleccionar &Todos
EnMenu=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.quita]
Nombre=quita
Boton=0
NombreDesplegar=&Quitar Seleccion
EnMenu=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
