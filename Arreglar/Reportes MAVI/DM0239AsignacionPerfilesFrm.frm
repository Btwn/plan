
[Forma]
Clave=DM0239AsignacionPerfilesFrm
Icono=405
Modulos=(Todos)
Nombre=Asignacion de Permisos

ListaCarpetas=AsignacionPerfiles<BR>DM0239MuestraPerfiles
CarpetaPrincipal=AsignacionPerfiles
PosicionInicialIzquierda=442
PosicionInicialArriba=317
PosicionInicialAlturaCliente=352
PosicionInicialAncho=396
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Agregar<BR>quitar
PosicionSec1=97
PosicionCol1=171
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
[AsignacionPerfiles]
Estilo=Ficha
Clave=AsignacionPerfiles
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata


ListaEnCaptura=Mavi.DM0239AsignacionPerfiles<BR>Mavi.DM0239ListaPermisos
InicializarVariables=S
PermiteEditar=S
FichaNombres=Arriba
FichaAlineacion=Centrado
[Acciones.Agregar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Agregar]
Nombre=Agregar
Boton=24
NombreEnBoton=S
NombreDesplegar=&Agregar
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=Asignar<BR>Registra<BR>Decision<BR>Procedimiento<BR>Actualizar
Activo=S
Visible=S



[AsignacionPerfiles.Mavi.DM0239AsignacionPerfiles]
Carpeta=AsignacionPerfiles
Clave=Mavi.DM0239AsignacionPerfiles
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[AsignacionPerfiles.Mavi.DM0239ListaPermisos]
Carpeta=AsignacionPerfiles
Clave=Mavi.DM0239ListaPermisos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Perfiles.Columnas]
GrupoTrabajo=304

Acceso=159
[DM0239MuestraPerfiles]
Estilo=Iconos
Clave=DM0239MuestraPerfiles
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=DM0239PerfilesUsuarioVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
PestanaOtroNombre=S
PestanaNombre=Muestra Permisos




ListaEnCaptura=Asignar/Desasignar Lineas<BR>Crear/Eliminar Segmentos
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosConRejilla=S
ElementosPorPaginaEsp=200
IconosSubTitulo=Acceso
IconosNombre=DM0239PerfilesUsuarioVis:Acceso
[DM0239MuestraPerfiles.Columnas]
GpoTrabajo=124
PermLineas=64
PermSegmento=76

Grupo de Trabajo=124
Asignar/Desasignar Lineas=130
Crear/Eliminar Segmentos=127

0=85
1=-2
2=142



[Acciones.Agregar.Procedimiento]
Nombre=Procedimiento
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=EjecutarSQL(<T>SpINVAdministracionPerfiles :tAccesos, :tPermisos, :tDecision<T>, Mavi.DM0239AsignacionPerfiles,Mavi.DM0239ListaPermisos,Info.dato)
[Acciones.Agregar.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S







Expresion=ActualizarVista
[DM0239MuestraPerfiles.Asignar/Desasignar Lineas]
Carpeta=DM0239MuestraPerfiles
Clave=Asignar/Desasignar Lineas
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[DM0239MuestraPerfiles.Crear/Eliminar Segmentos]
Carpeta=DM0239MuestraPerfiles
Clave=Crear/Eliminar Segmentos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Acciones.quitar]
Nombre=quitar
Boton=25
NombreEnBoton=S
NombreDesplegar=Retirar
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S

ListaAccionesMultiples=Asigna<BR>Registra<BR>Decision<BR>Pocedimiento<BR>Actulizar

[Acciones.quitar.Actulizar]
Nombre=Actulizar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=ActualizarVista

[Acciones.quitar.Pocedimiento]
Nombre=Pocedimiento
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S


Expresion=EjecutarSQL(<T>SpINVAdministracionPerfiles :tAccesos, :tPermisos, :tDecision<T>, Mavi.DM0239AsignacionPerfiles,Mavi.DM0239ListaPermisos,Info.dato)
[Acciones.quitar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.quitar.Registra]
Nombre=Registra
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>AsignacionPerfiles<T>)

[Acciones.Agregar.Registra]
Nombre=Registra
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=RegistrarSeleccion(<T>AsignacionPerfiles<T>)
[Acciones.Agregar.Decision]
Nombre=Decision
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Asigna(Info.dato,<T>Agrega<T>)
[Acciones.quitar.Decision]
Nombre=Decision
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.dato,<T>Retira<T>)


