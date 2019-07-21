
[Forma]
Clave=RM1200PlazasFrm
Icono=0
Modulos=(Todos)
Nombre=Plazas

ListaCarpetas=Plazas
CarpetaPrincipal=Plazas
PosicionInicialAlturaCliente=273
PosicionInicialAncho=500
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar<BR>Todo<BR>Desmarcar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
[Plazas]
Estilo=Iconos
Pestana=S
Clave=Plazas
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1200PlazasVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S


ListaEnCaptura=Descripcion
MenuLocal=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPaginaEsp=200
IconosSeleccionMultiple=S
[Plazas.Columnas]
Descripcion=604

0=-2
[Plazas.Descripcion]
Carpeta=Plazas
Clave=Descripcion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco




[Acciones.SeleccionarTod.tod]
Nombre=tod
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S




[Acciones.Todo.Asign]
Nombre=Asign
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Todo.Registrar]
Nombre=Registrar
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Plazas<T>)
Activo=S
Visible=S

[Acciones.Todo.REsul]
Nombre=REsul
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(Mavi.RM1096ACategorias,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
Activo=S
Visible=S



[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=Seleccionar
Multiple=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
ListaAccionesMultiples=Asignar<BR>Registrar<BR>Resultado
Activo=S
Visible=S

[Acciones.Todo]
Nombre=Todo
Boton=23
NombreEnBoton=S
NombreDesplegar=Seleccionar Todo
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.Desmarcar]
Nombre=Desmarcar
Boton=72
NombreEnBoton=S
NombreDesplegar=Desmarcar Todo
EnBarraHerramientas=S
TipoAccion=controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

[Acciones.Seleccionar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar

[Acciones.Seleccionar.Registrar]
Nombre=Registrar
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion( <T>Plazas<T> )

[Acciones.Seleccionar.Resultado]
Nombre=Resultado
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(Mavi.RM1096ACategorias,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)

