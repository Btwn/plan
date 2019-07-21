
[Forma]
Clave=DM0344FajillasSucFRm
Icono=0
Modulos=(Todos)
Nombre=<T>Sucursal<T>

ListaCarpetas=lisat
CarpetaPrincipal=lisat
PosicionInicialIzquierda=179
PosicionInicialAlturaCliente=273
PosicionInicialAncho=323
PosicionInicialArriba=215
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar<BR>Seleccionar Todo<BR>Quitar Seleccion
[lisat]
Estilo=Iconos
Clave=lisat
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0344FajillaSucVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S



PestanaNombre=Sucursal
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPaginaEsp=200
IconosSubTitulo=<T>Sucursal<T>
IconosSeleccionMultiple=S
Pestana=S
PestanaOtroNombre=S
IconosNombre=DM0344FajillaSucVis:Sucursal
ListaEnCaptura=nombre
[lisat.Columnas]
Sucursal=64
nombre=604

usuario=64



0=67
1=-2



suc=64
nom=604
2=-2



[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S

NombreEnBoton=S

ListaAccionesMultiples=Registrar<BR>Resultado
[lisat.nombre]
Carpeta=lisat
Clave=nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco

[Acciones.Seleccionar.Resultado]
Nombre=Resultado
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S

Expresion=SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)

[Acciones.Seleccionar.Registrar]
Nombre=Registrar
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion( <T>lisat<T> )
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
[Acciones.Quitar Seleccion]
Nombre=Quitar Seleccion
Boton=21
NombreEnBoton=S
NombreDesplegar=&Quitar selección
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

