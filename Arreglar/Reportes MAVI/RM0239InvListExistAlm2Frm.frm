[Forma]
Clave=RM0239InvListExistAlm2Frm
Nombre=RM239 Listado de Existencias por Almacén
Icono=94
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialIzquierda=435
PosicionInicialArriba=384
PosicionInicialAlturaCliente=217
PosicionInicialAncho=410
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar<BR>Actualizar<BR>LlenaFiltros
VentanaAvanzaTab=S
VentanaEscCerrar=S
ExpresionesAlMostrar=Asigna(Mavi.RM0239ArtCatLigGrup,Nulo)<BR>Asigna(Mavi.RM0239ArtGrupLigFam,Nulo)<BR>Asigna(Mavi.RM0239ArtFamLigLin,Nulo)<BR>Asigna(Mavi.RM0239ArtLinLigLin,Nulo)<BR>Asigna(Mavi.RM0239TodosAlmacenes,Nulo)<BR>Asigna(Mavi.RM0239EstatusB,Nulo)<BR>Asigna(Mavi.RM0239OpcionSerie,<T>Sin series<T>)
[Lista]
Estilo=Ficha
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaAlineacion=Centrado
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=Mavi.RM0239OpcionSerie<BR>Mavi.RM0239ArtCatLigGrup<BR>Mavi.RM0239ArtFamLigLin<BR>Mavi.RM0239ArtGrupLigFam<BR>Mavi.RM0239ArtLinLigLin<BR>Mavi.RM0239TodosAlmacenes<BR>Mavi.RM0239EstatusB
PermiteEditar=S
CampoAccionAlEnter=LlenaFiltros
[Acciones.Preliminar.AsignaR]
Nombre=AsignaR
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=Enter<BR>AsignaR<BR>InvocaReporte<BR>Cerrar
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=Si(Vacio(Mavi.RM0239OpcionSerie),Informacion(<T>Debe llenar el campo <Tipo De Reporte><T>) AbortarOperacion, Verdadero)<BR><BR>Si<BR>  Mavi.RM0239OpcionSerie = <T>Calzado En Exhibicion<T><BR>Entonces<BR>  Si(Vacio(Mavi.RM0239ArtCatLigGrup),Informacion(<T>Debe llenar el campo <Categoria><T>) AbortarOperacion, Verdadero)<BR>  Si(Vacio(Mavi.RM0239ArtGrupLigFam),Informacion(<T>Debe llenar el campo <Grupo><T>) AbortarOperacion, Verdadero)<BR>  Si(Vacio(Mavi.RM0239ArtFamLigLin),Informacion(<T>Debe llenar el campo <Familia><T>) AbortarOperacion, Verdadero)<BR>  Si(Vacio(Mavi.RM0239ArtLinLigLin),Informacion(<T>Debe llenar el campo <Linea><T>) AbortarOperacion, Verdadero)<BR>  Si(Vacio(Mavi.RM0239TodosAlmacenes),Informacion(<T>Debe llenar el campo <Almacen><T>) AbortarOperacion, Verdadero)<BR>Sino<BR>  Verdadero<BR>Fin<BR>                                                                       
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Actualizar]
Nombre=Actualizar
Boton=0
NombreDesplegar=Actualiza
TipoAccion=controles Captura
ClaveAccion=variables Asignar
GuardarAntes=S
ConAutoEjecutar=S
EnBarraHerramientas=S
Activo=S
AutoEjecutarExpresion=1
[Lista.Mavi.RM0239ArtCatLigGrup]
Carpeta=Lista
Clave=Mavi.RM0239ArtCatLigGrup
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
[Lista.Mavi.RM0239ArtFamLigLin]
Carpeta=Lista
Clave=Mavi.RM0239ArtFamLigLin
Editar=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
[Lista.Mavi.RM0239ArtGrupLigFam]
Carpeta=Lista
Clave=Mavi.RM0239ArtGrupLigFam
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
[Lista.Mavi.RM0239ArtLinLigLin]
Carpeta=Lista
Clave=Mavi.RM0239ArtLinLigLin
Editar=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
[Lista.Mavi.RM0239TodosAlmacenes]
Carpeta=Lista
Clave=Mavi.RM0239TodosAlmacenes
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
[Lista.Mavi.RM0239EstatusB]
Carpeta=Lista
Clave=Mavi.RM0239EstatusB
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco

[Vista.Columnas]
Categoria=304

0=268
[Lista.Columnas]
Grupo=256

Almacen=90
Nombre=229
Sucursal=46
Linea=304
0=-2
1=171
2=172
3=53
[Lista.Mavi.RM0239OpcionSerie]
Carpeta=Lista
Clave=Mavi.RM0239OpcionSerie
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco

AccionAlEnter=LlenaFiltros
AccionAlEnterBloquearAvance=N
[Acciones.LlenaFiltros]
Nombre=LlenaFiltros
Boton=0
TipoAccion=Expresion
Visible=S

Multiple=S
ListaAccionesMultiples=AvanzarCaptura<BR>Variables Asignar<BR>Autocompletar
Activo=S
[Acciones.LlenaFiltros.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.LlenaFiltros.Autocompletar]
Nombre=Autocompletar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Si<BR>  Mavi.RM0239OpcionSerie = <T>Calzado En Exhibicion<T><BR>Entonces<BR>  Asigna(Mavi.RM0239ArtCatLigGrup,<T>VENTA<T>)<BR>  Asigna(Mavi.RM0239ArtGrupLigFam,<T>MERCANCIA DE LINEA<T>)<BR>  Asigna(Mavi.RM0239ArtFamLigLin,Comillas(<T>CALZADO<T>))<BR>Fin
[Acciones.Preliminar.InvocaReporte]
Nombre=InvocaReporte
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Si<BR>  (Mavi.RM0239OpcionSerie = <T>Con series<T>) o (Mavi.RM0239OpcionSerie = <T>Sin series<T>)<BR>Entonces<BR>   ReportePantalla(<T>RM0239InvListexistAlmRep<T>)<BR>Sino<BR>  ReportePantalla(<T>RM0239VTASCalzadoExhibicionRep<T>)<BR>Fin
[Acciones.LlenaFiltros.AvanzarCaptura]
Nombre=AvanzarCaptura
Boton=0
TipoAccion=Expresion
Expresion=AvanzarCaptura
Activo=S
Visible=S

[Acciones.Test.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Test.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Informacion(Mavi.RM0239OpcionSerie)<BR><BR>Si<BR>  (Mavi.RM0239OpcionSerie = <T>Con Series<T>) o (Mavi.RM0239OpcionSerie = <T>Sin Series<T>)<BR>Entonces<BR>   Informacion(<T>Series<T>)<BR>   ReportePantalla(<T>RM0239InvListexistAlmRep<T>)<BR>Sino<BR>  Informacion(<T>Exhibicion<T>)<BR>  /*ReportePantalla(<T>RM0239VTASCalzadoExhibicionRep<T>)*/<BR>Fin

[Acciones.Preliminar.Enter]
Nombre=Enter
Boton=0
TipoAccion=Expresion
Expresion=AvanzarCaptura
Activo=S
Visible=S

[Acciones.Preliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

