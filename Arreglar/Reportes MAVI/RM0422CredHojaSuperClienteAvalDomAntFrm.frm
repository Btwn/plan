[Forma]
Clave=RM0422CredHojaSuperClienteAvalDomAntFrm
Nombre=RM0422E Hoja de Supervisión Domicilio Anterior
Icono=572
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=EPor Ruta<BR>EPor Supervision<BR>Principal
CarpetaPrincipal=EPor Ruta
PosicionInicialIzquierda=512
PosicionInicialArriba=187
PosicionInicialAlturaCliente=360
PosicionInicialAncho=335
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaAvanzaTab=S
VentanaEstadoInicial=Normal
ListaAcciones=Prel<BR>Refresh<BR>Cerrar
PosicionSec1=57
ExpresionesAlMostrar=Asigna(Mavi.TipoSupervision,<T>Supervision<T>)<BR>Asigna(Mavi.RM0422RutasIDSuperD,Nulo)<BR>Asigna(Mavi.RM0422RutasIDSuperA,Nulo)<BR>Asigna(Info.FechaD,Nulo)<BR>Asigna(Info.FechaA,Nulo)                   <BR>Asigna(Mavi.AgenteSuperv,Nulo)<BR>Asigna(Mavi.TipoFormatoSuper,Nulo)<BR>Asigna(Mavi.RM0422SelecOP,<T>Por Ruta<T>)<BR>Asigna(Mavi.RM0422ESupervisionesP,nulo)
ExpresionesAlActivar=Forma.IrCarpeta(<T>EPor Ruta<T>)
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
[Acciones.Prel.llamar]
Nombre=llamar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Si Mavi.RM0422SelecOP=<T>Por Ruta<T><BR>entonces<BR>    ReportePantalla(<T>RM0422CredHojaSuperClienteAvalDomAntRep<T>)<BR>sino<BR>    Si Vacio(Mavi.RM0422ESupervisionesP)<BR>    Entonces<BR>        Error(<T>Debe seleccionar una Supervision<T>)<BR>    SiNo<BR>        ReportePantalla(<T>RM0422EPorSupervRep<T>)<BR>    FIN<BR>fin
EjecucionCondicion=si Mavi.RM0422SelecOP=<T>Por Ruta<T><BR>entonces<BR>    (ConDatos(Mavi.TipoFormatoSuper))  Y Si(ConDatos(Info.FechaD) Y Condatos(Info.FechaA),Info.FechaD<=Info.FechaA,1=1)<BR>     Y  Si(ConDatos(Mavi.RM0422RutasIDSuperD) Y Condatos(Mavi.RM0422RutasIDSuperA),Mavi.RM0422RutasIDSuperD<=Mavi.RM0422RutasIDSuperA,1=1)<BR>sino<BR>     1=1<BR>fin
EjecucionMensaje=<T>Se debe elegir un TipoFormatoSuper o Los Rangos Finales no Deben ser Mayores a los Iniciales<T>
[Acciones.Prel.CerrarV]
Nombre=CerrarV
Boton=0
TipoAccion=Ventana
ClaveAccion=Cancelar
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=Si Mavi.RM0422SelecOP=<T>Por Ruta<T><BR>    entonces<BR>        1=1<BR>    Sino<BR>        ConDatos(Mavi.RM0422ESupervisionesP)<BR>FIN
EjecucionMensaje=Si Vacio(Mavi.TipoSupervision) Entonces <T>Seleccionar un Tipo de Supervisión<T> fin
[Acciones.Prel.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[EPor Supervision.Mavi.RM0422ESupervisionesP]
Carpeta=EPor Supervision
Clave=Mavi.RM0422ESupervisionesP
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
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
[EPor Ruta]
Estilo=Ficha
Clave=EPor Ruta
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
[EPor Ruta.Mavi.TipoSupervision]
Carpeta=EPor Ruta
Clave=Mavi.TipoSupervision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[EPor Ruta.Mavi.TipoFormatoSuper]
Carpeta=EPor Ruta
Clave=Mavi.TipoFormatoSuper
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[EPor Ruta.Mavi.RM0422RutasIDSuperD]
Carpeta=EPor Ruta
Clave=Mavi.RM0422RutasIDSuperD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[EPor Ruta.Mavi.RM0422RutasIDSuperA]
Carpeta=EPor Ruta
Clave=Mavi.RM0422RutasIDSuperA
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[EPor Ruta.Info.FechaD]
Carpeta=EPor Ruta
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[EPor Ruta.Info.FechaA]
Carpeta=EPor Ruta
Clave=Info.FechaA
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[EPor Ruta.Mavi.AgenteSuperv]
Carpeta=EPor Ruta
Clave=Mavi.AgenteSuperv
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Refresh]
Nombre=Refresh
Boton=125
NombreEnBoton=S
NombreDesplegar=&Actualizar
EnBarraHerramientas=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=re1<BR>ChangeE
[Acciones.Refresh.re1]
Nombre=re1
Boton=0
Activo=S
Visible=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
[EPor Supervision]
Estilo=Ficha
Clave=EPor Supervision
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM0422ESupervisionesP
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
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
[Acciones.Refresh.ChangeE]
Nombre=ChangeE
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=SI Mavi.RM0422SelecOP=<T>Por Ruta<T><BR>entonces Forma.IrCarpeta(<T>EPor Ruta<T>)<BR>sino Forma.IrCarpeta(<T>EPor Supervision<T>)fin



