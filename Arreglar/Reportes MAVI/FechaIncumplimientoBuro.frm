
[Forma]
Clave=FechaIncumplimientoBuro
Icono=0
Modulos=(Todos)
Nombre=Fecha Incumplimiento

ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
AccionesTamanoBoton=15x5
ListaAcciones=(Lista)
PosicionInicialIzquierda=518
PosicionInicialArriba=320
PosicionInicialAlturaCliente=123
PosicionInicialAncho=255
BarraAcciones=S
AccionesCentro=S
AccionesDivision=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
[(Variables)]
Estilo=Ficha
Clave=(Variables)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=(Lista)

CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=10
FichaEspacioNombres=0
FichaColorFondo=Plata

FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaEspacioNombresAuto=S
FichaAlineacionDerecha=S
[(Variables).Info.Periodo]
Carpeta=(Variables)
Clave=Info.Periodo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

EspacioPrevio=N
[(Variables).Info.Ejercicio]
Carpeta=(Variables)
Clave=Info.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreEnBoton=S
NombreDesplegar=&Aceptar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S


EnBarraAcciones=S
Multiple=S
ListaAccionesMultiples=(Lista)
[Acciones.Cancelar]
Nombre=Cancelar
Boton=0
NombreEnBoton=S
NombreDesplegar=&Cancelar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cancelar
Activo=S
Visible=S




EnBarraAcciones=S

























[Acciones.Aceptar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Aceptar.Ejecuta]
Nombre=Ejecuta
Boton=0
TipoAccion=Expresion
Expresion=informacion('Fecha inicio: ' + ahora )<BR>EjecutarSQL(<T>spFechaIncumBuro :nperiodo, :nejercicio <T>, Info.Periodo, Info.Ejercicio) <BR>informacion('Fecha termino: ' + ahora )
Activo=S
Visible=S

[Acciones.Aceptar.ListaAccionesMultiples]
(Inicio)=Asigna
Asigna=Ejecuta
Ejecuta=(Fin)
















[(Variables).ListaEnCaptura]
(Inicio)=Info.Periodo
Info.Periodo=Info.Ejercicio
Info.Ejercicio=(Fin)



[Forma.ListaAcciones]
(Inicio)=Aceptar
Aceptar=Cancelar
Cancelar=(Fin)


