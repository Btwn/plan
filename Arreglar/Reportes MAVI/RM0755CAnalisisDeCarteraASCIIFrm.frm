[Forma]
Clave=RM0755CAnalisisDeCarteraASCIIFrm
Icono=90
Modulos=(Todos)
ListaCarpetas=XV<BR>DV
CarpetaPrincipal=XV
PosicionInicialIzquierda=348
PosicionInicialArriba=379
PosicionInicialAlturaCliente=221
PosicionInicialAncho=583
AccionesTamanoBoton=15x5
AccionesDerecha=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
PosicionCol1=323
VentanaAvanzaTab=S
ListaAcciones=Preliminar<BR>Cerrar<BR>Actualizar
PosicionSec1=162
PosicionSec2=328
PosicionCol2=281
Nombre=RM0755C Análisis de Cartera ASCII
VentanaRepetir=S
PosicionCol3=282
VentanaAjustarZonas=S
ExpresionesAlMostrar=asigna(Mavi.XV1,0)<BR>asigna(Mavi.XV2,0)<BR>asigna(Mavi.XV3,0)<BR>asigna(Mavi.DV1,0)<BR>asigna(Mavi.DV2,0)<BR>asigna(Mavi.DV3,0)<BR>asigna(Mavi.DV4,0)<BR>asigna(Mavi.DV5,0)<BR>asigna(Mavi.RM0755CCategoriaCanal,<T><T>)
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
[Acciones.Preliminar]
Nombre=Preliminar
Boton=108
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asignar<BR>AsignaXV-DV<BR>Asignacion
GuardarAntes=S
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
[DV]
Estilo=Ficha
Clave=DV
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A2
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=133
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=(Lista)
CarpetaVisible=S
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
Boton=0
NombreDesplegar=&Actualizar
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
ConAutoEjecutar=S
EnBarraHerramientas=S
Multiple=S
ListaAccionesMultiples=Asignar
GuardarAntes=S
RefrescarDespues=S
AutoEjecutarExpresion=1
[Acciones.Actualizar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
Activo=S
Visible=S
ClaveAccion=Variables Asignar

[XV]
Estilo=Ficha
Clave=XV
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=117
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.DiaPorVencer<BR>Mavi.XV1<BR>Mavi.XV2<BR>Mavi.XV3<BR>Mavi.RM0755CCategoriaCanal
CarpetaVisible=S
ConFuenteEspecial=S
[XV.Mavi.DiaPorVencer]
Carpeta=XV
Clave=Mavi.DiaPorVencer
LineaNueva=S
OcultaNombre=S
EspacioPrevio=S
Tamano=10
ColorFondo=Plata
ColorFuente=$00A00000
Efectos=[Negritas]
[XV.Mavi.XV1]
Carpeta=XV
Clave=Mavi.XV1
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=6
ColorFondo=Blanco
ColorFuente=Azul marino
Efectos=[Negritas]
[XV.Mavi.XV2]
Carpeta=XV
Clave=Mavi.XV2
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=6
ColorFondo=Blanco
ColorFuente=Azul marino
Efectos=[Negritas]
[XV.Mavi.XV3]
Carpeta=XV
Clave=Mavi.XV3
LineaNueva=S
ValidaNombre=S
Tamano=0
ColorFondo=Plata
ColorFuente=Plata
[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=/*VALIDAR CAMPOS OBLIGATORIOS*/<BR><BR>//Validacion para los dias por vencer<BR>SI (Mavi.XV1 <= 0) entonces  ERROR(<T>XV 1 debe ser mayor a cero<T>) SINO<BR>SI ((Mavi.XV2)<=(Mavi.XV1 +1)) entonces ERROR(<T>XV 2 debe ser mayor a: <T> + (Mavi.XV1 +1)) SINO<BR><BR>//Validacion para los dias vencidos<BR>SI (Mavi.DV1 <= 0) entonces  ERROR(<T>DV 1 debe ser mayor a cero<T>) SINO<BR>SI ((Mavi.DV2)<=(Mavi.DV1 +1)) entonces ERROR(<T>DV 2 debe ser mayor a: <T> + (Mavi.DV1 +1)) SINO<BR>SI ((Mavi.DV3)<=(Mavi.DV2 +1)) entonces ERROR(<T>DV 3 debe ser mayor a: <T> + (Mavi.DV2 +1)) SINO<BR>SI ((Mavi.DV4)<=(Mavi.DV3 +1)) entonces ERROR(<T>DV 4 debe ser mayor a: <T> + (Mavi.DV3 +1)) FIN
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
NombreDesplegar=&Quitar Selección
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
[Acciones.Preliminar.AsignaXV-DV]
Nombre=AsignaXV-DV
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=asigna(Mavi.XV3,(Mavi.XV2+1))<BR>asigna(Mavi.DV5,(Mavi.DV4+1))

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
[UENS.Mavi.RM0755CRutas]
Carpeta=UENS
Clave=Mavi.RM0755CRutas
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[UENS.Mavi.RM0755CZona]
Carpeta=UENS
Clave=Mavi.RM0755CZona
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Canal de Venta.Mavi.RM0755CCanalVta]
Carpeta=Canal de Venta
Clave=Mavi.RM0755CCanalVta
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

[Forma.ListaAcciones]
(Inicio)=Preliminar
Preliminar=Cerrar
Cerrar=Actualizar
Actualizar=(Fin)


[Categoria.Columnas]
Categoria=354
0=-2




[Vista.Columnas]
0=227











[XV.Mavi.RM0755CCategoriaCanal]
Carpeta=XV
Clave=Mavi.RM0755CCategoriaCanal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

