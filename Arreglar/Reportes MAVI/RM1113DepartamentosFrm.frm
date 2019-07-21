
[Forma]
Clave=RM1113DepartamentosFrm
Icono=0
Modulos=(Todos)
Nombre=RM1113 Departamentos

ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialAlturaCliente=459
PosicionInicialAncho=468
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
Vista=RM1113DepartamentosVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco

CarpetaVisible=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
ListaEnCaptura=Descripcion
IconosNombre=RM1113DepartamentosVis:Departamento
IconosSeleccionMultiple=S
[Lista.ListaEnCaptura]
(Inicio)=Departamento
Departamento=Descripcion
Descripcion=(Fin)



[Lista.Columnas]
0=-2
1=-2

[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
TipoAccion=Controles Captura
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=(Lista)
NombreEnBoton=S
BtnResaltado=S
EspacioPrevio=S
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
Activo=S
Visible=S


Expresion=RegistrarSeleccion(<T>Departamento<T>)
[Acciones.Seleccionar.Seleccion]
Nombre=Seleccion
Boton=0
TipoAccion=Ventana
Activo=S
Visible=S



ClaveAccion=Seleccionar/Resultado













Expresion=Asigna(Mavi.RM1113DEPARTAMENTOS,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
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







[Acciones.Seleccionar.ListaAccionesMultiples]
(Inicio)=Asignar
Asignar=Expresion
Expresion=Seleccion
Seleccion=(Fin)
