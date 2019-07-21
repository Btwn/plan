
[Forma]
Clave=RM1113ControladordeGastosSemanalfrm
Icono=0
Modulos=(Todos)
Nombre=RM1113 Controlador de Gastos Semanal

ListaCarpetas=(Lista)
CarpetaPrincipal=Filtros_Fechas
PosicionInicialAlturaCliente=153
PosicionInicialAncho=487
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=(Lista)
BarraHerramientas=S



PosicionSec1=57
PosicionInicialIzquierda=0
PosicionInicialArriba=0
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreDesplegar=&Preliminar
Multiple=S
EnMenu=S
Activo=S
Visible=S

NombreEnBoton=S
EnBarraHerramientas=S
BtnResaltado=S
ListaAccionesMultiples=Asignar
EspacioPrevio=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreDesplegar=&Cerrar
EnMenu=S
EspacioPrevio=S
Activo=S
Visible=S







NombreEnBoton=S
EnBarraHerramientas=S
BtnResaltado=S





TipoAccion=Ventana
ClaveAccion=Cerrar
[Filtros.ListaEnCaptura]
(Inicio)=Mavi.FechaI
Mavi.FechaI=Mavi.FechaF
Mavi.FechaF=(Fin)

[Filtros_Fechas]
Estilo=Ficha
Clave=Filtros_Fechas
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=(Lista)

CarpetaVisible=S



[Filtros_Nomina]
Estilo=Ficha
Clave=Filtros_Nomina
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S







Vista=(Variables)
ListaEnCaptura=(Lista)



FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
[Filtros_Nomina.Columnas]
Agente=64







[Filtros_Nomina.Mavi.RM1113NOMINAS]
Carpeta=Filtros_Nomina
Clave=Mavi.RM1113NOMINAS
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro






[Filtros_Nomina.Mavi.RM1113DEPARTAMENTOS]
Carpeta=Filtros_Nomina
Clave=Mavi.RM1113DEPARTAMENTOS
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro




[Lista.Columnas]
0=-2
1=-2




































[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S






















[Filtros_Nomina.Mavi.RM1113PUESTOS]
Carpeta=Filtros_Nomina
Clave=Mavi.RM1113PUESTOS
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro





[Acciones.Segmentar.AsignaF]
Nombre=AsignaF
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Segmentar.Mensaje]
Nombre=Mensaje
Boton=0
TipoAccion=Expresion
Expresion=Informacion(<T>Rango de fechas asignado correctamente<T>)
Activo=S
Visible=S




[Acciones.Segmentar.ListaAccionesMultiples]
(Inicio)=AsignaF
AsignaF=Mensaje
Mensaje=(Fin)











[Acciones.Asignar.asignar]
Nombre=asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Asignar.mensaje]
Nombre=mensaje
Boton=0
TipoAccion=Expresion
Expresion=Informacion(<T>Rango de fechas asignado correctamente<T>)
Activo=S
Visible=S


[Acciones.Asignar.ListaAccionesMultiples]
(Inicio)=asignar
asignar=mensaje
mensaje=(Fin)









[Filtros_Fechas.Info.FechaD]
Carpeta=Filtros_Fechas
Clave=Info.FechaD
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro







[Filtros_Fechas.Info.FechaA]
Carpeta=Filtros_Fechas
Clave=Info.FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro






[Filtros_Nomina.ListaEnCaptura]
(Inicio)=Mavi.RM1113NOMINAS
Mavi.RM1113NOMINAS=Mavi.RM1113DEPARTAMENTOS
Mavi.RM1113DEPARTAMENTOS=Mavi.RM1113PUESTOS
Mavi.RM1113PUESTOS=(Fin)

[Filtros_Fechas.ListaEnCaptura]
(Inicio)=Info.FechaD
Info.FechaD=Info.FechaA
Info.FechaA=(Fin)











[Forma.ListaCarpetas]
(Inicio)=Filtros_Fechas
Filtros_Fechas=Filtros_Nomina
Filtros_Nomina=(Fin)

[Forma.ListaAcciones]
(Inicio)=Preliminar
Preliminar=Cerrar
Cerrar=(Fin)


