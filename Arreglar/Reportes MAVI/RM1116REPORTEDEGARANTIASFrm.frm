[Forma]
Clave=RM1116REPORTEDEGARANTIASFrm
Icono=0
Modulos=(Todos)
ListaCarpetas=Fechas
CarpetaPrincipal=Fechas
PosicionInicialIzquierda=491
PosicionInicialArriba=439
PosicionInicialAlturaCliente=107
PosicionInicialAncho=297
AccionesTamanoBoton=15x5
AccionesDerecha=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
PosicionCol1=237
VentanaAvanzaTab=S
ListaAcciones=(Lista)
PosicionSec1=162
PosicionSec2=328
PosicionCol2=281
Nombre=RM1116 REPORTE DE GARANTIAS
VentanaRepetir=S
PosicionCol3=282
VentanaAjustarZonas=S
[Acciones.ACTUALIZA.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.ACTUALIZA.AsignarSub]
Nombre=AsignarSub
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Anexo.ID,Afectar.ID+1)
Activo=S
Visible=S
[Acciones.ACTUALIZA.Refrescar]
Nombre=Refrescar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=AvanzarCaptura
[Ficha1.XVencver]
Carpeta=Ficha1
Clave=XVencver
Editar=S
LineaNueva=S
ValidaNombre=N
Tamano=10
ColorFondo=Plata
ColorFuente=Azul marino
Efectos=[Negritas]
[Ficha1.Prueba.XV1]
Carpeta=Ficha1
Clave=Prueba.XV1
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=5
EspacioPrevio=S
[Ficha1.Prueba.XV1MAS1]
Carpeta=Ficha1
Clave=Prueba.XV1MAS1
Editar=N
LineaNueva=S
ValidaNombre=S
ColorFondo=Plata
ColorFuente=Negro
Tamano=5
Efectos=[Negritas + Subrayado]
[Ficha1.Prueba.XV2]
Carpeta=Ficha1
Clave=Prueba.XV2
Editar=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=5
Pegado=S
[Ficha1.Prueba.MXV2]
Carpeta=Ficha1
Clave=Prueba.MXV2
Editar=N
LineaNueva=S
ValidaNombre=S
ColorFondo=Plata
ColorFuente=Negro
Tamano=5
Efectos=[Negritas + Subrayado]
[Ficha1.Dias]
Carpeta=Ficha1
Clave=Dias
Editar=S
ValidaNombre=N
3D=N
Tamano=4
ColorFondo=Plata
ColorFuente=Negro
IgnoraFlujo=S
Pegado=N
[Ficha1.Dias2]
Carpeta=Ficha1
Clave=Dias2
Editar=S
ValidaNombre=N
3D=N
Tamano=4
ColorFondo=Plata
ColorFuente=Negro
IgnoraFlujo=S
[Ficha1.Dias3]
Carpeta=Ficha1
Clave=Dias3
Editar=S
ValidaNombre=N
3D=N
Tamano=4
ColorFondo=Plata
ColorFuente=Negro
IgnoraFlujo=S

[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[FichaB1.Columnas]
UEN=0
Nombre=604
0=145
1=89
2=-2
[Acciones.Imprimir]
Nombre=Imprimir
Boton=0
NombreDesplegar=&Imprimir
EnMenu=S
TipoAccion=Ventana
ClaveAccion=Normal
Activo=S
Visible=S
[Ficha4.Prueba.UEN]
Carpeta=Ficha4
Clave=Prueba.UEN
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=5
[Ficha4.Prueba.UENNombre]
Carpeta=Ficha4
Clave=Prueba.UENNombre
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[FICHA4]
Estilo=Ficha
Clave=FICHA4
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B2
Vista=Art
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Art.Articulo
CarpetaVisible=S
[FICHA4.Art.Articulo]
Carpeta=FICHA4
Clave=Art.Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=0
NombreDesplegar=&Seleccionar
EnMenu=S
Activo=S
Visible=S
[Variables]
Estilo=Ficha
Clave=Variables
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=C2
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.MovID
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Negro
RefrescarAlEntrar=S
[Variables.Info.MovID]
Carpeta=Variables
Clave=Info.MovID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[DV.Mavi.DV1]
Carpeta=DV
Clave=Mavi.DV1
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=6
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[DV.Mavi.DV2]
Carpeta=DV
Clave=Mavi.DV2
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=6
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[DV.Mavi.DV3]
Carpeta=DV
Clave=Mavi.DV3
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=6
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[DV.Mavi.DV4]
Carpeta=DV
Clave=Mavi.DV4
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=6
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[DV.Mavi.DV5]
Carpeta=DV
Clave=Mavi.DV5
Editar=N
LineaNueva=S
ValidaNombre=S
3D=N
Tamano=0
ColorFondo=Plata
ColorFuente=Plata
Efectos=[Negritas]
[UEN.Columnas]
UEN=64
0=174
1=-2
2=-2
[DV.Mavi.DiaVencimiento]
Carpeta=DV
Clave=Mavi.DiaVencimiento
Editar=N
LineaNueva=S
OcultaNombre=S
Tamano=20
ColorFondo=Plata
ColorFuente=$00A00000
Efectos=[Negritas]
EspacioPrevio=N

[Acciones.Sel.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Sel.Expr]
Nombre=Expr
Boton=0
TipoAccion=Expresion
Expresion=asigna(Mavi.XV2,Mavi.XV1+1)
Activo=S
Visible=S
[Acciones.Sel.Refresh]
Nombre=Refresh
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
[Acciones.Actualizar]
Nombre=Actualizar
Boton=55
NombreDesplegar=&Generar reporte
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
EnBarraHerramientas=S
Multiple=S
ListaAccionesMultiples=(Lista)
GuardarAntes=S
RefrescarDespues=S
NombreEnBoton=S
BtnResaltado=S
[Acciones.Actualizar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
Activo=S
Visible=S
ClaveAccion=Variables Asignar






[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Todos]
Nombre=Todos
Boton=0
NombreDesplegar=&Seleccionar Todos
GuardarAntes=S
RefrescarDespues=S
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.QuitarSeleccion]
Nombre=QuitarSeleccion
Boton=0
NombreDesplegar=&Quitar Selecci�n
GuardarAntes=S
RefrescarDespues=S
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=quitar Seleccion
Activo=S
Visible=S
[Acciones.sucu.Asign]
Nombre=Asign
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=Informacion(Mavi.SucuAdeC)

[(Carpeta Totalizadores)]
Pestana=S
Clave=(Carpeta Totalizadores)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=C2
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
Totalizadores2=MaviUENNomVis:UEN
Totalizadores=S
CampoColorLetras=Negro
CampoColorFondo=Negro
CarpetaVisible=S
[Canal de Venta.Info.Cliente]
Carpeta=Canal de Venta
Clave=Info.Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Canal de Venta.Mavi.RM0755CategoriaCanalVta]
Carpeta=Canal de Venta
Clave=Mavi.RM0755CategoriaCanalVta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Movimientos.Mavi.RM0755TipoMovimiento]
Carpeta=Movimientos
Clave=Mavi.RM0755TipoMovimiento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[UEN.UEN]
Carpeta=UEN
Clave=UEN
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=
ColorFondo=Blanco
ColorFuente=Negro
[UEN.Nombre]
Carpeta=UEN
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro

[UENS.Mavi.RM0755UenNum]
Carpeta=UENS
Clave=Mavi.RM0755UenNum
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[TipoSucursal.Mavi.RM0755SucuAdeC]
Carpeta=TipoSucursal
Clave=Mavi.RM0755SucuAdeC
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Movimientos.Mavi.RM0755NivelCobranza]
Carpeta=Movimientos
Clave=Mavi.RM0755NivelCobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Desglose.Mavi.AnalitCondenExtr]
Carpeta=Desglose
Clave=Mavi.AnalitCondenExtr
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


[TipoSucursal.Mavi.RM0755Moratorios]
Carpeta=TipoSucursal
Clave=Mavi.RM0755Moratorios
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[UENS.Mavi.RM0755ERutas]
Carpeta=UENS
Clave=Mavi.RM0755ERutas
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[UENS.Mavi.RM0755EZona]
Carpeta=UENS
Clave=Mavi.RM0755EZona
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Canal de Venta.Mavi.RM0755ECanalVta]
Carpeta=Canal de Venta
Clave=Mavi.RM0755ECanalVta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Canal de Venta.Mavi.RM0755CategoCanalVta]
Carpeta=Canal de Venta
Clave=Mavi.RM0755CategoCanalVta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


















[Acciones.Preliminar.Asignacion]
Nombre=Asignacion
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S

[Acciones.Preliminar.ListaAccionesMultiples]
(Inicio)=Asignar
Asignar=AsignaXV-DV
AsignaXV-DV=Asignacion
Asignacion=(Fin)





































[XV.ListaEnCaptura]
(Inicio)=Mavi.DiaPorVencer
Mavi.DiaPorVencer=Mavi.XV1
Mavi.XV1=Mavi.XV2
Mavi.XV2=Mavi.XV3
Mavi.XV3=(Fin)

[DV.ListaEnCaptura]
(Inicio)=Mavi.DiaVencimiento
Mavi.DiaVencimiento=Mavi.DV1
Mavi.DV1=Mavi.DV2
Mavi.DV2=Mavi.DV3
Mavi.DV3=Mavi.DV4
Mavi.DV4=Mavi.DV5
Mavi.DV5=(Fin)







[Forma.ListaCarpetas]
(Inicio)=XV
XV=DV
DV=(Fin)


[Fechas]
Estilo=Ficha
Clave=Fechas
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
ConFuenteEspecial=S
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=117
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=(Lista)

CarpetaVisible=S
[Fechas.ListaEnCaptura]
(Inicio)=Info.FechaD
Info.FechaD=Info.FechaA
Info.FechaA=(Fin)

[Fechas.Info.FechaD]
Carpeta=Fechas
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Fechas.Info.FechaA]
Carpeta=Fechas
Clave=Info.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro






[Acciones.Preliminar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Expresion
Expresion=asigna(Mavi.XV3,(Mavi.XV2+1))<BR>asigna(Mavi.DV5,(Mavi.DV4+1))
Activo=S
Visible=S





































[Acciones.Actualizar.Imprimir]
Nombre=Imprimir
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM1116REPORTEDEGARANTIASRep
Activo=S
Visible=S



[Acciones.Actualizar.ListaAccionesMultiples]
(Inicio)=Asignar
Asignar=Imprimir
Imprimir=(Fin)

[Forma.ListaAcciones]
(Inicio)=Actualizar
Actualizar=Cerrar
Cerrar=(Fin)

