
[Forma]
Clave=RM1113PuestosFrm
Icono=0
Modulos=(Todos)
Nombre=RM1113 Puestos

ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialAlturaCliente=547
PosicionInicialAncho=487
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
[Lista]
Estilo=Iconos
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1113PuestosVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
IconosNombre=RM1113PuestosVis:Puesto
ListaEnCaptura=Descripcion

[Lista.Descripcion]
Carpeta=Lista
Clave=Descripcion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Columnas]
0=-2
1=-2

[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
BtnResaltado=S
EspacioPrevio=S
Activo=S
Visible=S

ListaAccionesMultiples=(Lista)
[Acciones.Seleccionar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Seleccionar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Puesto<T>)
Activo=S
Visible=S

[Acciones.Seleccionar.Expresion1]
Nombre=Expresion1
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Puesto<T>)
Activo=S
Visible=S


[Acciones.Seleccionar.Seleccion]
Nombre=Seleccion
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(Mavi.RM1113PUESTOS,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
Activo=S
Visible=S

[Acciones.Seleccionar.ListaAccionesMultiples]
(Inicio)=Asignar
Asignar=Expresion1
Expresion1=Seleccion
Seleccion=(Fin)
