[Forma]
Clave=RM0743EspecificarFechas
Nombre=Fechas Especificas
Icono=5
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=491
PosicionInicialArriba=428
PosicionInicialAltura=131
PosicionInicialAncho=298
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=Centrado
AccionesTamanoBoton=15x5
ListaAcciones=Aceptar<BR>Excel<BR>Cancelar
VentanaExclusiva=S
PosicionInicialAlturaCliente=129
AccionesDivision=S
BarraHerramientas=S
AccionesCentro=S
BarraAcciones=S
VentanaEstadoInicial=Normal

[(Variables)]
Estilo=Ficha
Clave=(Variables)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={MS Sans Serif, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
FichaEspacioEntreLineas=4
FichaEspacioNombres=65
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
ListaEnCaptura=Info.FechaD<BR>Info.FechaA
PermiteEditar=S

[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


[Acciones.Cancelar]
Nombre=Cancelar
Boton=5
NombreDesplegar=Cancelar
TipoAccion=Ventana
ClaveAccion=Cancelar
Activo=S
Visible=S
EnBarraHerramientas=S
NombreEnBoton=S
[Acciones.Excel.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Excel.Excel]
Nombre=Excel
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=AuxIngresosCredilanasXLS
Activo=S
Visible=S
[Acciones.Excel.L]
Nombre=L
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreDesplegar=Aceptar
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
NombreEnBoton=S
EnBarraHerramientas=S
[Acciones.Excel]
Nombre=Excel
Boton=115
NombreEnBoton=S
NombreDesplegar=Envio a Excel
EnBarraHerramientas=S
EnBarraAcciones=S
TipoAccion=Reportes Excel
ClaveAccion=AuxIngresosCredilanasImp
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>ExcelRep<BR>Aceptar
[Acciones.Excel.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Excel.ExcelRep]
Nombre=ExcelRep
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=AuxIngresosCredilanasImp
Activo=S
Visible=S
[Acciones.Excel.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
