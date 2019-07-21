
[Forma]
Clave=RM1155ReporteAsistenciasFrm
Icono=65
Nombre=Asistencias

ListaCarpetas=FiltCampos
CarpetaPrincipal=FiltCampos
PosicionInicialIzquierda=329
PosicionInicialArriba=440
PosicionInicialAlturaCliente=212
PosicionInicialAncho=339
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=(Lista)
BarraHerramientas=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Info.FechaD,Nulo)<BR>Asigna(Info.FechaA,Nulo)<BR>Asigna(Mavi.RM1155Departamento,<T><T>)<BR>Asigna(Mavi.RM1155Puesto,<T><T>)
[FiltCampos]
Estilo=Ficha
Pestana=S
Clave=FiltCampos
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

FichaEspacioEntreLineas=6
FichaEspacioNombres=71
FichaColorFondo=Blanco
FichaNombres=Arriba
PestanaOtroNombre=S
PestanaNombre=Filtros
PermiteEditar=S
[FiltCampos.Mavi.RM1155Puesto]
Carpeta=FiltCampos
Clave=Mavi.RM1155Puesto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro


[FiltCampos.Mavi.RM1155Departamento]
Carpeta=FiltCampos
Clave=Mavi.RM1155Departamento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro


[FiltCampos.Info.FechaD]
Carpeta=FiltCampos
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[FiltCampos.Info.FechaA]
Carpeta=FiltCampos
Clave=Info.FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro








[Acciones.generar]
Nombre=generar
Boton=7
NombreDesplegar=Generar Reporte
EnBarraHerramientas=S
EnMenu=S
Activo=S
Visible=S

NombreEnBoton=S
Multiple=S
ListaAccionesMultiples=(Lista)
[Acciones.cerrar]
Nombre=cerrar
Boton=36
NombreDesplegar=Cerrar
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S





NombreEnBoton=S




















EspacioPrevio=S








































[Vista.Columnas]
Descripcion=604



















0=-2

















[FiltCampos.ListaEnCaptura]
(Inicio)=Info.FechaD
Info.FechaD=Info.FechaA
Info.FechaA=Mavi.RM1155Departamento
Mavi.RM1155Departamento=Mavi.RM1155Puesto
Mavi.RM1155Puesto=(Fin)








































[Acciones.generar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S




[Acciones.generar.Seleccion]
Nombre=Seleccion
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

ConCondicion=S


EjecucionCondicion=Si Info.FechaD>Info.FechaA<BR>Entonces<BR>    Informacion(<T>Eliga un rango de fechas valido.<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin<BR><BR>Si Condatos(Info.FechaD) Y Condatos(Info.FechaA)<BR>Entonces<BR>   Verdadero<BR>Sino<BR>    Informacion(<T>Eliga un rango de fechas valido.<T>)<BR>    AbortarOperacion<BR>Fin<BR><BR>Si Condatos(Mavi.RM1155Departamento) O Condatos(Mavi.RM1155Puesto)<BR>Entonces<BR>   Verdadero<BR>Sino<BR>    Informacion(<T>Al menos un filtro debe tener datos.<T>)<BR>    AbortarOperacion<BR>Fin


[Acciones.generar.ListaAccionesMultiples]
(Inicio)=Asignar
Asignar=Seleccion
Seleccion=(Fin)













[Forma.ListaAcciones]
(Inicio)=generar
generar=cerrar
cerrar=(Fin)

