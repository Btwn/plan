
[Forma]
Clave=RM1180EstatusFrm
Icono=0
Modulos=(Todos)
Nombre=RM1180EstatusFrm
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal

ListaCarpetas=Vista
CarpetaPrincipal=Vista
PosicionInicialIzquierda=433
PosicionInicialArriba=303
PosicionInicialAlturaCliente=123
PosicionInicialAncho=500
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar


[EstatusVis.Columnas]
0=-2

[Acciones.SelectAll]
Nombre=SelectAll
Boton=0
NombreDesplegar=Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.DesSelectAll]
Nombre=DesSelectAll
Boton=0
NombreDesplegar=Quitar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

[Acciones.Seleccionar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Seleccionar.Registrar]
Nombre=Registrar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=RegistrarSeleccion(<T>Vista<T>)
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asignar<BR>Registrar<BR>Seleccionar
Activo=S
Visible=S

[Acciones.Seleccionar.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S

Expresion=Asigna(Mavi.RM1180EstatusFitro,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Vista]
Estilo=Iconos
PestanaOtroNombre=S
Clave=Vista
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1180EstatusVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSeleccionMultiple=S
ElementosPorPaginaEsp=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Estatus
ListaAcciones=SelectAll<BR>DesSelectAll

[Vista.Estatus]
Carpeta=Vista
Clave=Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=11
ColorFondo=Blanco

