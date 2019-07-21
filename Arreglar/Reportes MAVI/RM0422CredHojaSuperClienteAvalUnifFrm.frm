[Forma]
Clave=RM0422CredHojaSuperClienteAvalUnifFrm
Nombre=RM0422A Hoja de Supervisión
Icono=572
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=Por Ruta<BR>Por Supervision<BR>Principal
CarpetaPrincipal=Principal
PosicionInicialIzquierda=505
PosicionInicialArriba=226
PosicionInicialAlturaCliente=282
PosicionInicialAncho=350
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaAvanzaTab=S
VentanaEstadoInicial=Normal
ListaAcciones=Prel<BR>Refresh<BR>Cerrar
PosicionCol1=173
PosicionSec1=52
VentanaAjustarZonas=S
VentanaBloquearAjuste=S
CarpetasMultilinea=S
ExpresionesAlMostrar=Asigna(Mavi.TipoSupervision,<T>Supervision<T>)<BR>Asigna(Mavi.RM0422RutasIDSuperD,Nulo)<BR>Asigna(Mavi.RM0422RutasIDSuperA,Nulo)<BR>Asigna(Info.FechaD,Nulo)<BR>Asigna(Info.FechaA,Nulo)<BR>Asigna(Mavi.AgenteSuperv,Nulo)<BR>Asigna(Mavi.TipoFormatoSuper,Nulo)<BR>Asigna(Mavi.RM0422SelecOP,<T>Por Ruta<T>)        <BR>Asigna(Mavi.RM0422SupervisionesP,Nulo)
ExpresionesAlActivar=Forma.IrCarpeta(<T>Por Ruta<T>)
[Acciones.Prel]
Nombre=Prel
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asignar<BR>llamar<BR>CerrarV
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
EspacioPrevio=S
[Acciones.Prel.llamar]
Nombre=llamar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Si Mavi.RM0422SelecOP=<T>Por Ruta<T><BR>entonces<BR>    ReportePantalla(<T>RM0422CredHojaSuperClienteAvalUnifRep<T>)<BR>sino<BR>    Si Vacio(Mavi.RM0422SupervisionesP)<BR>    Entonces<BR>        Error(<T>Debe seleccionar una Supervision<T>)<BR>    SiNo<BR>        ReportePantalla(<T>RM0422SuperviReproRep<T>)<BR>    FIN<BR>fin
EjecucionCondicion=si Mavi.RM0422SelecOP=<T>Por Ruta<T><BR>entonces<BR>    (ConDatos(Mavi.TipoFormatoSuper)) Y Si(ConDatos(Info.FechaD) Y Condatos(Info.FechaA),Info.FechaD<=Info.FechaA,1=1)<BR>    Y  Si(ConDatos(Mavi.RM0422RutasIDSuperD) Y Condatos(Mavi.RM0422RutasIDSuperA),Mavi.RM0422RutasIDSuperD<=Mavi.RM0422RutasIDSuperA,1=1)<BR>sino<BR>     1=1<BR>fin
EjecucionMensaje=<T>Se debe elegir un TipoFormatoSuper o Los Rangos Finales no Deben ser Mayores a los Iniciales<T>
[Acciones.Prel.CerrarV]
Nombre=CerrarV
Boton=0
TipoAccion=Ventana
ClaveAccion=Cancelar
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=Si Mavi.RM0422SelecOP=<T>Por Supervision<T><BR>Entonces<BR>     ConDatos(Mavi.RM0422SupervisionesP)<BR>Sino<BR>     1=1<BR>Fin
EjecucionMensaje=<T>Seleccionar un Tipo de Supervisión<T>
[Acciones.Refresh]
Nombre=Refresh
Boton=125
NombreDesplegar=&Actualizar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Multiple=S
ListaAccionesMultiples=ASIGNA4<BR>CambiarCampo
Visible=S
NombreEnBoton=S
EspacioPrevio=S
[Acciones.Prel.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[PorSupervision.Columnas]
movid=0
[PorSup.movid]
Carpeta=PorSup
Clave=movid
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[PorSup.Columnas]
movid=124
[Pru.movid]
Carpeta=Pru
Clave=movid
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[XSup.Mavi.RM0422SupervisionesP]
Carpeta=XSup
Clave=Mavi.RM0422SupervisionesP
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Pre2.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Pre2.llama2]
Nombre=llama2
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=ReportePantalla(<T>RM0422SuperviReproRep<T>)
[Acciones.Pre2.cerrar2]
Nombre=cerrar2
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[(Carpeta Abrir)]
Estilo=Ficha
Pestana=S
Clave=(Carpeta Abrir)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
IconosCampo=(Situación)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.FechaD<BR>Info.FechaA
CarpetaVisible=S
IconosNombre=kkk
[(Carpeta Abrir).Info.FechaD]
Carpeta=(Carpeta Abrir)
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).Info.FechaA]
Carpeta=(Carpeta Abrir)
Clave=Info.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Por Ruta]
Estilo=Ficha
PestanaNombre=Por Ruta
Clave=Por Ruta
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.TipoSupervision<BR>Mavi.TipoFormatoSuper<BR>Mavi.RM0422RutasIDSuperD<BR>Mavi.RM0422RutasIDSuperA<BR>Info.FechaD<BR>Info.FechaA<BR>Mavi.AgenteSuperv
CarpetaVisible=S
[Por Ruta.Mavi.TipoSupervision]
Carpeta=Por Ruta
Clave=Mavi.TipoSupervision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
IgnoraFlujo=N
[Por Ruta.Mavi.TipoFormatoSuper]
Carpeta=Por Ruta
Clave=Mavi.TipoFormatoSuper
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Por Ruta.Mavi.RM0422RutasIDSuperD]
Carpeta=Por Ruta
Clave=Mavi.RM0422RutasIDSuperD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Por Ruta.Mavi.RM0422RutasIDSuperA]
Carpeta=Por Ruta
Clave=Mavi.RM0422RutasIDSuperA
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Por Ruta.Info.FechaD]
Carpeta=Por Ruta
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Por Ruta.Info.FechaA]
Carpeta=Por Ruta
Clave=Info.FechaA
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Por Ruta.Mavi.AgenteSuperv]
Carpeta=Por Ruta
Clave=Mavi.AgenteSuperv
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Principal]
Estilo=Ficha
Clave=Principal
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
ListaEnCaptura=Mavi.RM0422SelecOP
CarpetaVisible=S
[Por Supervision]
Estilo=Ficha
PestanaNombre=Por Id
Clave=Por Supervision
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM0422SupervisionesP
CarpetaVisible=S
PermiteEditar=S
RefrescarAlEntrar=S
[Acciones.Refresh.ASIGNA4]
Nombre=ASIGNA4
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Refresh.CambiarCampo]
Nombre=CambiarCampo
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=SI Mavi.RM0422SelecOP=<T>Por Ruta<T><BR>entonces Forma.IrCarpeta(<T>Por Ruta<T>)<BR>sino Forma.IrCarpeta(<T>Por Supervision<T>)fin
[Principal.Mavi.RM0422SelecOP]
Carpeta=Principal
Clave=Mavi.RM0422SelecOP
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Por Supervision.Mavi.RM0422SupervisionesP]
Carpeta=Por Supervision
Clave=Mavi.RM0422SupervisionesP
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro




