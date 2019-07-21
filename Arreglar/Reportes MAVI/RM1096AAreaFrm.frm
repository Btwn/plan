
[Forma]
Clave=RM1096AAreaFrm
Icono=0
BarraHerramientas=S
Modulos=(Todos)
Nombre=Áreas
AccionesTamanoBoton=15x5
AccionesDerecha=S

ListaCarpetas=area
CarpetaPrincipal=area
PosicionInicialAlturaCliente=273
PosicionInicialAncho=500
ListaAcciones=Selecciona<BR>SelecTodo<BR>DesTodo
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=433
PosicionInicialArriba=228
[area]
Estilo=Iconos
Clave=area
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1096AAreaVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Categoria
CarpetaVisible=S

IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSeleccionMultiple=S
ElementosPorPaginaEsp=200
[area.Categoria]
Carpeta=area
Clave=Categoria
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[area.Columnas]
Categoria=304

0=-2
[Acciones.Selecciona]
Nombre=Selecciona
Boton=23
NombreEnBoton=S
NombreDesplegar=&Selección
Multiple=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

ListaAccionesMultiples=asigna<BR>regis<BR>selec
[Acciones.Selecciona.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Selecciona.regis]
Nombre=regis
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=RegistrarSeleccion(<T>area<T>)
[Acciones.Selecciona.selec]
Nombre=selec
Boton=0
TipoAccion=ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S

Expresion=Asigna(Mavi.RM1096ACategorias,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Acciones.SelecTodo]
Nombre=SelecTodo
Boton=23
NombreEnBoton=S
NombreDesplegar=Seleccionar Todo
EnBarraHerramientas=S
TipoAccion=controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.DesTodo]
Nombre=DesTodo
Boton=127
NombreEnBoton=S
NombreDesplegar=Desmarcar Todo
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

