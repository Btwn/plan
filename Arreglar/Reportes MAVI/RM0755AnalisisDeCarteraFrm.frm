[Forma]
Clave=RM0755AnalisisDeCarteraFrm
Icono=90
Modulos=(Todos)
ListaCarpetas=XV<BR>DV<BR>UENS<BR>TipoSucursal<BR>Canal de Venta<BR>Movimientos
CarpetaPrincipal=XV
PosicionInicialIzquierda=393
PosicionInicialArriba=242
PosicionInicialAlturaCliente=501
PosicionInicialAncho=494
AccionesTamanoBoton=15x5
AccionesDerecha=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
PosicionCol1=281
VentanaAvanzaTab=S
ListaAcciones=Preliminar<BR>ImprimirRep<BR>PDF<BR>Excel<BR>Cerrar<BR>Actualizar
PosicionSec1=162
PosicionSec2=314
PosicionCol2=281
Nombre=RM755 Análisis de Cartera
VentanaRepetir=S
PosicionCol3=282
VentanaAjustarZonas=S
ExpresionesAlMostrar=asigna(Mavi.RM0755Moratorios,<T>Sin Moratorio<T>)<BR>asigna(Mavi.AnalitCondenExtr,nulo)<BR>asigna(Mavi.RM0755TipoSucurAnalisis,nulo)<BR>asigna(Mavi.RM0755SucuAdeC,nulo)            <BR>asigna(Mavi.RM0755CategoriaCanalVta,nulo)<BR>asigna(Mavi.RM0755CategoCanalVta,nulo) <BR>asigna(Mavi.RM0755CanalVta,nulo)<BR>asigna(Mavi.RM0755TipoMovimiento,nulo)<BR>asigna(Mavi.RM0755UENNUM,nulo)<BR>asigna(Mavi.RM0755Zona,nulo)<BR>asigna(Mavi.RM0755Rutas,nulo)<BR>asigna(Mavi.RM0755NivelCobranza,nulo)<BR>asigna(info.Cliente,nulo)<BR>asigna(Mavi.XV1,0)<BR>asigna(Mavi.XV2,0)<BR>asigna(Mavi.XV3,0)<BR>asigna(Mavi.DV1,0)<BR>asigna(Mavi.DV2,0)<BR>asigna(Mavi.DV3,0)<BR>asigna(Mavi.DV4,0)<BR>asigna(Mavi.DV5,0)
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
ListaAccionesMultiples=Asignar<BR>AsignaXV-DV<BR>llamar<BR>CerrarV
GuardarAntes=S
ConCondicion=S
EjecucionCondicion=SI (Mavi.RM0755MORATORIOS NOEN(<T>Sin Moratorio<T>,<T>Con Moratorio<T>))<BR>entonces  ERROR(<T>Debe seleccionar una opcion de Moratorio<T>) sino<BR>SI (vacio(Mavi.AnalitCondenExtr)) entonces  ERROR(<T>Debe seleccionar Desglose<T>) sino<BR>SI ((Mavi.AnalitCondenExtr=<T>Analítico x Ruta Cob May<T>)<BR>y (Mavi.RM0755CategoriaCanalVta<> COMILLAS(<T>MAYOREO<T>)))<BR>entonces  ERROR(<T>Este Reporte Funciona Solo para la Categoria Mayoreo<T>) sino<BR><BR><BR>//Validacion para los dias por vencer<BR>SI (Mavi.XV1 <= 0) entonces  ERROR(<T>XV 1 debe ser mayor a cero<T>) SINO<BR>SI ((Mavi.XV2)<=(Mavi.XV1 +1)) entonces ERROR(<T>XV 2 debe ser mayor a: <T> + (Mavi.XV1 +1)) SINO<BR><BR>//Validacion para los dias vencidos<BR>SI (Mavi.DV1 <= 0) entonces  ERROR(<T>DV 1 debe ser mayor a cero<T>) SINO<BR>SI ((<CONTINUA>
EjecucionCondicion002=<CONTINUA>Mavi.DV2)<=(Mavi.DV1 +1)) entonces ERROR(<T>DV 2 debe ser mayor a: <T> + (Mavi.DV1 +1)) SINO<BR>SI ((Mavi.DV3)<=(Mavi.DV2 +1)) entonces ERROR(<T>DV 3 debe ser mayor a: <T> + (Mavi.DV2 +1)) SINO<BR>SI ((Mavi.DV4)<=(Mavi.DV3 +1)) entonces ERROR(<T>DV 4 debe ser mayor a: <T> + (Mavi.DV3 +1)) FIN
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
CampoColorLetras=$00A00000
CampoColorFondo=Plata
ListaEnCaptura=Mavi.DiaVencimiento<BR>Mavi.DV1<BR>Mavi.DV2<BR>Mavi.DV3<BR>Mavi.DV4<BR>Mavi.DV5
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
[TipoSucursal]
Estilo=Ficha
Clave=TipoSucursal
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B2
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM0755SucuAdeC<BR>Mavi.RM0755Moratorios
FichaEspacioEntreLineas=7
FichaEspacioNombres=38
FichaColorFondo=Plata
PermiteEditar=S
CarpetaVisible=S
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
[Canal de Venta]
Estilo=Ficha
Clave=Canal de Venta
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=C1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=10
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM0755CategoriaCanalVta<BR>Mavi.RM0755CategoCanalVta<BR>Mavi.RM0755CanalVta<BR>Info.Cliente
CarpetaVisible=S
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
CampoColorLetras=Plata
CampoColorFondo=Plata
ListaEnCaptura=Mavi.AnalitCondenExtr<BR>Mavi.DiaPorVencer<BR>Mavi.XV1<BR>Mavi.XV2<BR>Mavi.XV3
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
EjecucionCondicion=/*VALIDAR CAMPOS OBLIGATORIOS*/<BR>//DESGLOSE<BR>//y(Mavi.RM0755CategoriaCanalVta=<T>MAYOREO<T>)<BR>/*informacion(Mavi.AnalitCondenExtr)<BR>informacion(Mavi.RM0755CategoriaCanalVta)<BR>asigna(Mavi.RM0755CategoriaCanalVta,<T>MAYOREO<T>)<BR>SI (Mavi.RM0755MORATORIOS NOEN(<T>Sin Moratorio<T>,<T>Con Moratorio<T>))<BR>entonces  ERROR(<T>Debe seleccionar una opcion de Moratorio<T>) sino<BR>SI (vacio(Mavi.AnalitCondenExtr)) entonces  ERROR(<T>Debe seleccionar Desglose<T>) sino<BR>SI ((Mavi.AnalitCondenExtr=<T>Analítico x Ruta Cob May<T>)<BR>y (Mavi.RM0755CategoriaCanalVta<><T>MAYOREO<T>))<BR>entonces  ERROR(<T>Este Reporte Funciona Solo para la Categoria Mayoreo<T>) sino<BR><BR><BR>//Validacion para los dias por vencer<BR>SI (Mavi.XV1 <= 0) entonces  ERROR(<T>XV 1 debe ser mayor a cero<T>) SINO<B<CONTINUA>
EjecucionCondicion002=<CONTINUA>R>SI ((Mavi.XV2)<=(Mavi.XV1 +1)) entonces ERROR(<T>XV 2 debe ser mayor a: <T> + (Mavi.XV1 +1)) SINO<BR><BR>//Validacion para los dias vencidos<BR>SI (Mavi.DV1 <= 0) entonces  ERROR(<T>DV 1 debe ser mayor a cero<T>) SINO<BR>SI ((Mavi.DV2)<=(Mavi.DV1 +1)) entonces ERROR(<T>DV 2 debe ser mayor a: <T> + (Mavi.DV1 +1)) SINO<BR>SI ((Mavi.DV3)<=(Mavi.DV2 +1)) entonces ERROR(<T>DV 3 debe ser mayor a: <T> + (Mavi.DV2 +1)) SINO<BR>SI ((Mavi.DV4)<=(Mavi.DV3 +1)) entonces ERROR(<T>DV 4 debe ser mayor a: <T> + (Mavi.DV3 +1)) FIN<BR><BR>  */<BR><BR>/*VALIDAR UEN*/<BR>/*si (vacio(Mavi.UEN)) entonces<BR>Error(<T>Debe seleccionar mínimo una UEN<T>)<BR>sino */<BR>                                                          <BR>/*VALIDAR TIPOSUCURSAL*/<BR>/*si (vacio(Mavi.RM0755TipoSucurAnalisis))<BR>entonces<B<CONTINUA>
EjecucionCondicion003=<CONTINUA>R>Error(<T>Debe seleccionar Tipo de Sucursal<T>)<BR>sino */<BR><BR>/*VALIDAR SUCURSAL*/<BR>/*si (vacio(Mavi.RM0755SucuAdeC))            <BR>entonces<BR>Error(<T>Debe seleccionar una Sucursal<T>)<BR>sino  */<BR>/*VALIDAR MOVIMIENTOS*/<BR>/*si (vacio(Mavi.RM0755TipoMovimiento))<BR>entonces<BR>Error(<T>Debe seleccionar Movimiento<T>)<BR>sino */<BR>/*VALIDAR CLIENTE*/<BR>/*si (vacio(Mavi.TipoCteLegal))<BR>entonces<BR>Error(<T>Debe seleccionar Situación del Cliente<T>))<BR>Fin   */
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
[Movimientos]
Estilo=Ficha
Clave=Movimientos
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=C2
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=10
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM0755TipoMovimiento<BR>Mavi.RM0755NivelCobranza
CarpetaVisible=S
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
[Canal de Venta.Mavi.RM0755CanalVta]
Carpeta=Canal de Venta
Clave=Mavi.RM0755CanalVta
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
[UENS]
Estilo=Ficha
Clave=UENS
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=4
FichaEspacioNombres=106
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM0755Zona<BR>Mavi.RM0755Rutas
CarpetaVisible=S
;[UENS.Mavi.RM0755UenNum]
;Carpeta=UENS
;Clave=Mavi.RM0755UenNum
;Editar=S
;LineaNueva=S
;ValidaNombre=S
;3D=S
;Tamano=20
;ColorFondo=Blanco
;ColorFuente=Negro
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
[XV.Mavi.AnalitCondenExtr]
Carpeta=XV
Clave=Mavi.AnalitCondenExtr
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar.llamar]
Nombre=llamar
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=Caso Mavi.AnalitCondenExtr<BR> Es <T>Analítico<T> Entonces ReportePantalla(<T>RM0755AnalisisDeCarteraAnaliticoRep<T>)<BR> Es <T>Analítico x Sucursal<T> Entonces ReportePantalla(<T>RM0755AnalisisDeCarteraAnaliticoxSucursalRep<T>)<BR> Es <T>Analítico x Categoria<T> Entonces ReportePantalla(<T>RM0755AnalisisDeCarteraAnaliticoxCategoriaRep<T>)<BR> Es <T>Analítico x Canal Vta<T> Entonces ReportePantalla(<T>RM0755AnalisisDeCarteraAnaliticoxCanalVtaRep<T>)<BR> Es <T>Analítico x Ruta Cob May<T> Entonces ReportePantalla(<T>RM0755AnalisisDeCarteraAnaliticoxRutaCobMayRep<T>)<BR> Es <T>Condensado<T> Entonces ReportePantalla(<T>RM0755AnalisisDeCarteraCondensadoRep<T>)<BR> Es <T>Extracto x Sucursal<T> Entonces ReportePantalla(<T>RM0755AnalisisDeCarteraExtrSucursalRep<T>)<BR> Es <T>Extracto x Categoria<T<CONTINUA>
Expresion002=<CONTINUA>> Entonces ReportePantalla(<T>RM0755AnalisisDeCarteraExtrCategoRep<T>)<BR> Es <T>Extracto x Canal Vta<T> Entonces SI(Contiene(Mavi.RM0755CategoriaCanalVta,<T>MAYOREO<T>),ReportePantalla(<T>RM0755AnalisisDeCarteraExtrCanalVtaMayRep<T>), ReportePantalla(<T>RM0755AnalisisDeCarteraExtrCanalVtaRep<T>))<BR> Sino ReportePantalla(<T>RM0755AnalisisDeCarteraAnaliticoRep<T>)<BR>Fin
[Acciones.Preliminar.CerrarV]
Nombre=CerrarV
Boton=0
TipoAccion=ventana
ClaveAccion=Cancelar
Activo=S
Visible=S
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
[UENS.Mavi.RM0755Zona]
Carpeta=UENS
Clave=Mavi.RM0755Zona
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[UENS.Mavi.RM0755Rutas]
Carpeta=UENS
Clave=Mavi.RM0755Rutas
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
[Acciones.Excel.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Excel]
Nombre=Excel
Boton=115
NombreEnBoton=S
NombreDesplegar=&Excel
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Variables Asignar<BR>Asignar Dias<BR>Reporte
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=SI (Mavi.RM0755MORATORIOS NOEN(<T>Sin Moratorio<T>,<T>Con Moratorio<T>))<BR>entonces  ERROR(<T>Debe seleccionar una opcion de Moratorio<T>) sino<BR>SI (vacio(Mavi.AnalitCondenExtr)) entonces  ERROR(<T>Debe seleccionar Desglose<T>) sino<BR>SI ((Mavi.AnalitCondenExtr=<T>Analítico x Ruta Cob May<T>)<BR>y (Mavi.RM0755CategoriaCanalVta<> COMILLAS(<T>MAYOREO<T>)))<BR>entonces  ERROR(<T>Este Reporte Funciona Solo para la Categoria Mayoreo<T>) sino<BR><BR><BR>//Validacion para los dias por vencer<BR>SI (Mavi.XV1 <= 0) entonces  ERROR(<T>XV 1 debe ser mayor a cero<T>) SINO<BR>SI ((Mavi.XV2)<=(Mavi.XV1 +1)) entonces ERROR(<T>XV 2 debe ser mayor a: <T> + (Mavi.XV1 +1)) SINO<BR><BR>//Validacion para los dias vencidos<BR>SI (Mavi.DV1 <= 0) entonces  ERROR(<T>DV 1 debe ser mayor a cero<T>) SINO<BR>SI ((<CONTINUA>
EjecucionCondicion002=<CONTINUA>Mavi.DV2)<=(Mavi.DV1 +1)) entonces ERROR(<T>DV 2 debe ser mayor a: <T> + (Mavi.DV1 +1)) SINO<BR>SI ((Mavi.DV3)<=(Mavi.DV2 +1)) entonces ERROR(<T>DV 3 debe ser mayor a: <T> + (Mavi.DV2 +1)) SINO<BR>SI ((Mavi.DV4)<=(Mavi.DV3 +1)) entonces ERROR(<T>DV 4 debe ser mayor a: <T> + (Mavi.DV3 +1)) FIN
[Acciones.Excel.Asignar Dias]
Nombre=Asignar Dias
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=asigna(Mavi.XV3,(Mavi.XV2+1))<BR>asigna(Mavi.DV5,(Mavi.DV4+1))
[Acciones.Excel.Reporte]
Nombre=Reporte
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Caso Mavi.AnalitCondenExtr<BR> Es <T>Analítico<T> Entonces ReporteExcel(<T>RM0755AnalisisDeCarteraAnaliticoRepXls<T>)<BR> Es <T>Analítico x Sucursal<T> Entonces ReporteExcel(<T>RM0755AnalisisDeCarteraAnaliticoxSucursalRepXls<T>)<BR> Es <T>Analítico x Categoria<T> Entonces ReporteExcel(<T>RM0755AnalisisDeCarteraAnaliticoxCategoriaRepXls<T>)<BR> Es <T>Analítico x Canal Vta<T> Entonces ReporteExcel(<T>RM0755AnalisisDeCarteraAnaliticoxCanalVtaRepXls<T>)<BR> Es <T>Analítico x Ruta Cob May<T> Entonces ReporteExcel(<T>RM0755AnalisisDeCarteraAnaliticoxRutaCobMayRepXls<T>)<BR> Es <T>Condensado<T> Entonces ReporteExcel(<T>RM0755AnalisisDeCarteraCondensadoRepXls<T>)<BR> Es <T>Extracto x Sucursal<T> Entonces ReporteExcel(<T>RM0755AnalisisDeCarteraExtrSucursalRepXls<T>)<BR> Es <T>Extracto x Categoria<T<CONTINUA>
Expresion002=<CONTINUA>> Entonces ReporteExcel(<T>RM0755AnalisisDeCarteraExtrCategoRepXls<T>)<BR> Es <T>Extracto x Canal Vta<T> Entonces SI(Contiene(Mavi.RM0755CategoriaCanalVta,<T>MAYOREO<T>),ReporteExcel(<T>RM0755AnalisisDeCarteraExtrCategoMayRepXls<T>),ReporteExcel(<T>RM0755AnalisisDeCarteraExtrCategoRep<T>))<BR> Sino ReporteExcel(<T>RM0755AnalisisDeCarteraAnaliticoRepXls<T>)<BR>Fin
[Acciones.PDF]
Nombre=PDF
Boton=97
NombreEnBoton=S
NombreDesplegar=P&DF
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=Variables Asignar<BR>AsignaDias<BR>Llamar
[Acciones.PDF.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=/*VALIDAR CAMPOS OBLIGATORIOS*/<BR>//DESGLOSE<BR>//y(Mavi.RM0755CategoriaCanalVta=<T>MAYOREO<T>)<BR>/*informacion(Mavi.AnalitCondenExtr)<BR>informacion(Mavi.RM0755CategoriaCanalVta)<BR>asigna(Mavi.RM0755CategoriaCanalVta,<T>MAYOREO<T>)<BR>SI (Mavi.RM0755MORATORIOS NOEN(<T>Sin Moratorio<T>,<T>Con Moratorio<T>))<BR>entonces  ERROR(<T>Debe seleccionar una opcion de Moratorio<T>) sino<BR>SI (vacio(Mavi.AnalitCondenExtr)) entonces  ERROR(<T>Debe seleccionar Desglose<T>) sino<BR>SI ((Mavi.AnalitCondenExtr=<T>Analítico x Ruta Cob May<T>)<BR>y (Mavi.RM0755CategoriaCanalVta<><T>MAYOREO<T>))<BR>entonces  ERROR(<T>Este Reporte Funciona Solo para la Categoria Mayoreo<T>) sino<BR><BR><BR>//Validacion para los dias por vencer<BR>SI (Mavi.XV1 <= 0) entonces  ERROR(<T>XV 1 debe ser mayor a cero<T>) SINO<B<CONTINUA>
EjecucionCondicion002=<CONTINUA>R>SI ((Mavi.XV2)<=(Mavi.XV1 +1)) entonces ERROR(<T>XV 2 debe ser mayor a: <T> + (Mavi.XV1 +1)) SINO<BR><BR>//Validacion para los dias vencidos<BR>SI (Mavi.DV1 <= 0) entonces  ERROR(<T>DV 1 debe ser mayor a cero<T>) SINO<BR>SI ((Mavi.DV2)<=(Mavi.DV1 +1)) entonces ERROR(<T>DV 2 debe ser mayor a: <T> + (Mavi.DV1 +1)) SINO<BR>SI ((Mavi.DV3)<=(Mavi.DV2 +1)) entonces ERROR(<T>DV 3 debe ser mayor a: <T> + (Mavi.DV2 +1)) SINO<BR>SI ((Mavi.DV4)<=(Mavi.DV3 +1)) entonces ERROR(<T>DV 4 debe ser mayor a: <T> + (Mavi.DV3 +1)) FIN<BR><BR>  */<BR><BR>/*VALIDAR UEN*/<BR>/*si (vacio(Mavi.UEN)) entonces<BR>Error(<T>Debe seleccionar mínimo una UEN<T>)<BR>sino */<BR>                                                          <BR>/*VALIDAR TIPOSUCURSAL*/<BR>/*si (vacio(Mavi.RM0755TipoSucurAnalisis))<BR>entonces<B<CONTINUA>
EjecucionCondicion003=<CONTINUA>R>Error(<T>Debe seleccionar Tipo de Sucursal<T>)<BR>sino */<BR><BR>/*VALIDAR SUCURSAL*/<BR>/*si (vacio(Mavi.RM0755SucuAdeC))            <BR>entonces<BR>Error(<T>Debe seleccionar una Sucursal<T>)<BR>sino  */<BR>/*VALIDAR MOVIMIENTOS*/<BR>/*si (vacio(Mavi.RM0755TipoMovimiento))<BR>entonces<BR>Error(<T>Debe seleccionar Movimiento<T>)<BR>sino */<BR>/*VALIDAR CLIENTE*/<BR>/*si (vacio(Mavi.TipoCteLegal))<BR>entonces<BR>Error(<T>Debe seleccionar Situación del Cliente<T>))<BR>Fin   */
[Acciones.PDF.AsignaDias]
Nombre=AsignaDias
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=asigna(Mavi.XV3,(Mavi.XV2+1))<BR>asigna(Mavi.DV5,(Mavi.DV4+1))
[Acciones.PDF.Llamar]
Nombre=Llamar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Caso Mavi.AnalitCondenExtr<BR> Es <T>Analítico<T> Entonces ReportePDF(<T>RM0755AnalisisDeCarteraAnaliticoRep<T>,<T>(Especifico)<T>)<BR> Es <T>Analítico x Sucursal<T> Entonces ReportePDF(<T>RM0755AnalisisDeCarteraAnaliticoxSucursalRep<T>,<T>(Especifico)<T>)<BR> Es <T>Analítico x Categoria<T> Entonces ReportePDF(<T>RM0755AnalisisDeCarteraAnaliticoxCategoriaRep<T>,<T>(Especifico)<T>)<BR> Es <T>Analítico x Canal Vta<T> Entonces ReportePDF(<T>RM0755AnalisisDeCarteraAnaliticoxCanalVtaRep<T>,<T>(Especifico)<T>)<BR> Es <T>Analítico x Ruta Cob May<T> Entonces ReportePDF(<T>RM0755AnalisisDeCarteraAnaliticoxRutaCobMayRep<T>,<T>(Especifico)<T>)<BR> Es <T>Condensado<T> Entonces ReportePDF(<T>RM0755AnalisisDeCarteraCondensadoRep<T>,<T>(Especifico)<T>)<BR> Es <T>Extracto x Sucursal<T> Entonces ReportePDF<CONTINUA>
Expresion002=<CONTINUA>(<T>RM0755AnalisisDeCarteraExtrSucursalRep<T>,<T>(Especifico)<T>)            <BR> Es <T>Extracto x Categoria<T> Entonces ReportePDF(<T>RM0755AnalisisDeCarteraExtrCategoRep<T>,<T>(Especifico)<T>)<BR> Es <T>Extracto x Canal Vta<T> Entonces SI(Contiene(Mavi.RM0755CategoriaCanalVta,<T>MAYOREO<T>),ReportePDF(<T>RM0755AnalisisDeCarteraExtrCanalVtaMayRep<T>,<T>(Especifico)<T>), ReportePDF(<T>RM0755AnalisisDeCarteraExtrCanalVtaRep<T>,<T>(Especifico)<T>))<BR> Sino ReportePDF(<T>RM0755AnalisisDeCarteraAnaliticoRep<T>,<T>(Especifico)<T>)<BR>Fin
[Acciones.ImprimirRep]
Nombre=ImprimirRep
Boton=4
NombreEnBoton=S
NombreDesplegar=Imprimir
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=Variables Asignar<BR>AsignaDias<BR>Expresion
[Acciones.ImprimirRep.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.ImprimirRep.AsignaDias]
Nombre=AsignaDias
Boton=0
TipoAccion=Expresion
Expresion=asigna(Mavi.XV3,(Mavi.XV2+1))<BR>asigna(Mavi.DV5,(Mavi.DV4+1))
Activo=S
Visible=S
[Acciones.ImprimirRep.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Caso Mavi.AnalitCondenExtr<BR> Es <T>Analítico<T> Entonces ReporteImpresora(<T>RM0755AnalisisDeCarteraAnaliticoRep<T>)<BR> Es <T>Analítico x Sucursal<T> Entonces ReporteImpresora(<T>RM0755AnalisisDeCarteraAnaliticoxSucursalRep<T>)<BR> Es <T>Analítico x Categoria<T> Entonces ReporteImpresora(<T>RM0755AnalisisDeCarteraAnaliticoxCategoriaRep<T>)<BR> Es <T>Analítico x Canal Vta<T> Entonces ReporteImpresora(<T>RM0755AnalisisDeCarteraAnaliticoxCanalVtaRep<T>)<BR> Es <T>Analítico x Ruta Cob May<T> Entonces ReporteImpresora(<T>RM0755AnalisisDeCarteraAnaliticoxRutaCobMayRep<T>)<BR> Es <T>Condensado<T> Entonces ReporteImpresora(<T>RM0755AnalisisDeCarteraCondensadoRep<T>)<BR> Es <T>Extracto x Sucursal<T> Entonces ReporteImpresora(<T>RM0755AnalisisDeCarteraExtrSucursalRep<T>)<BR> Es <T>Extracto x Cate<CONTINUA>
Expresion002=<CONTINUA>goria<T> Entonces ReporteImpresora(<T>RM0755AnalisisDeCarteraExtrCategoRep<T>)<BR> Es <T>Extracto x Canal Vta<T> Entonces SI(Contiene(Mavi.RM0755CategoriaCanalVta,<T>MAYOREO<T>),ReporteImpresora(<T>RM0755AnalisisDeCarteraExtrCanalVtaMayRepImp<T>), ReportePantalla(<T>RM0755AnalisisDeCarteraExtrCanalVtaRep<T>))<BR> Sino ReporteImpresora(<T>RM0755AnalisisDeCarteraAnaliticoRep<T>)<BR>Fin


