
[Forma]
Clave=DM0344FajillasUsuFRm
Icono=0
Modulos=(Todos)
Nombre=Cajero

ListaCarpetas=usuarios
CarpetaPrincipal=usuarios
PosicionInicialAlturaCliente=653
PosicionInicialAncho=409
PosicionInicialIzquierda=242
PosicionInicialArriba=125
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar<BR>Seleccionar Todo<BR>Quitar
[usuarios]
Estilo=Iconos
Clave=usuarios
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0344FajillasUsuVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S


IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSeleccionMultiple=S
ElementosPorPaginaEsp=200

Pestana=S

ListaEnCaptura=nombre
IconosNombre=DM0344FajillasUsuVis:usu
IconosSubTitulo=<T>usuario<T>
[usuarios.Columnas]
Sucursal=64
usuario=64
cajero=64
nombre=336

Defcajero=64


0=-2
1=-2

[Acciones.Seleccionar.Registrar]
Nombre=Registrar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=RegistrarSeleccion( <T>usuarios<T> )
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Registrar<BR>Resultado
Activo=S
Visible=S

NombreEnBoton=S
[Acciones.Seleccionar.Resultado]
Nombre=Resultado
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
Activo=S
Visible=S

[Acciones.Seleccionar Todo]
Nombre=Seleccionar Todo
Boton=23
NombreDesplegar=&Seleccionar Todo
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

NombreEnBoton=S
[Acciones.Quitar]
Nombre=Quitar
Boton=21
NombreEnBoton=S
NombreDesplegar=&Quitar Seleccion
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

[usuarios.nombre]
Carpeta=usuarios
Clave=nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
