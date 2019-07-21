[Forma]
Clave=RM0422CCredHojaSuperLaboralFrm
Nombre=RM0422C Hoja de Supervisión Laboral
Icono=572
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=Por Ruta<BR>Por Supervision<BR>Principal
CarpetaPrincipal=Principal
PosicionInicialIzquierda=511
PosicionInicialArriba=196
PosicionInicialAlturaCliente=342
PosicionInicialAncho=337
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaAvanzaTab=S
VentanaEstadoInicial=Normal
ListaAcciones=Preliminar<BR>Refresh<BR>Cerrar
PosicionSec1=57
ExpresionesAlMostrar=Asigna(Mavi.TipoFormatoSup,<T>PERSONAL<T>)<BR>Asigna(Mavi.TipoSupervision,<T>Supervision<T>)<BR>Asigna(Mavi.RM0422RutasIDSuperD,Nulo)<BR>Asigna(Mavi.RM0422RutasIDSuperA,Nulo)<BR>Asigna(Info.FechaD,Nulo)<BR>Asigna(Info.FechaA,Nulo)<BR>Asigna(Mavi.AgenteSuperv,Nulo)<BR>Asigna(Mavi.TipoLaboral,Nulo)<BR>Asigna(Mavi.RM0422SelecOP,<T>Por Ruta<T>)<BR>Asigna(Mavi.RM0422CSupervisionesP,Nulo)
ExpresionesAlActivar=Forma.IrCarpeta(<T>Por Ruta<T>)
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
[Acciones.Prel.CerrarV]
Nombre=CerrarV
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=(ConDatos(Mavi.TipoLaboral))y(ConDatos(Mavi.TipoSupervision))
EjecucionMensaje=Si Vacio(Mavi.TipoLaboral) Entonces <T>Seleccionar un Formato<T><BR>Sino Si Vacio(Mavi.TipoSupervision) Entonces <T>Seleccionar un Tipo de Supervisión<T>
[Acciones.Refresh]
Nombre=Refresh
Boton=125
NombreDesplegar=&Actualizar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Multiple=S
ListaAccionesMultiples=Asigna1<BR>change
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
[Acciones.Prel.Llamar]
Nombre=Llamar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=ReportePantalla(Mavi.Reporte,<T>RM0422CredHojaSuperlaboralRep<T>)
[Acciones.Preliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=ventana
ClaveAccion=cerrar
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=Si Mavi.RM0422SelecOP=<T>Por Ruta<T><BR>Entonces<BR>    1=1<BR>Sino<BR>   CONDATOS(Mavi.RM0422CSupervisionesP)<BR>FIN
[Acciones.Preliminar.Asignar]
Nombre=Asignar
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
ListaAccionesMultiples=Asignar<BR>call<BR>Cerrar
Activo=S
Visible=S
[Por Ruta]
Estilo=Ficha
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
ListaEnCaptura=Mavi.TipoLaboral<BR>Mavi.RM0422RutasIDSuperD<BR>Mavi.RM0422RutasIDSuperA<BR>Info.FechaD<BR>Info.FechaA<BR>Mavi.AgenteSuperv
CarpetaVisible=S
[Por Ruta.Mavi.TipoLaboral]
Carpeta=Por Ruta
Clave=Mavi.TipoLaboral
Editar=S
LineaNueva=S
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
Efectos=[Negritas]
[Por Ruta.Info.FechaA]
Carpeta=Por Ruta
Clave=Info.FechaA
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[Por Supervision]
Estilo=Ficha
Clave=Por Supervision
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
Vista=(Variables)
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
ListaEnCaptura=Mavi.RM0422CSupervisionesP
PermiteEditar=S
InicializarVariables=S
[Principal]
Estilo=Ficha
Clave=Principal
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
Vista=(Variables)
ListaEnCaptura=Mavi.RM0422SelecOP
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
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
[Acciones.Refresh.Asigna1]
Nombre=Asigna1
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.call]
Nombre=call
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Si Mavi.RM0422SelecOP=<T>Por Ruta<T><BR>entonces<BR>    ReportePantalla(<T>RM0422CCredHojaSuperLaboralRep<T>)<BR>sino<BR>    Si Vacio(Mavi.RM0422CSupervisionesP)<BR>    Entonces<BR>        Error(<T>Debe seleccionar una Supervision<T>)<BR>    SiNo<BR>        ReportePantalla(<T>RM0422CPorSupervisionRep<T>)<BR>    FIN<BR>fin
EjecucionCondicion=Si(ConDatos(Info.FechaD) Y Condatos(Info.FechaA),Info.FechaD<=Info.FechaA,1=1)<BR>    Y  Si(ConDatos(Mavi.RM0422RutasIDSuperD) Y Condatos(Mavi.RM0422RutasIDSuperA),Mavi.RM0422RutasIDSuperD<=Mavi.RM0422RutasIDSuperA,1=1)
EjecucionMensaje=<T>Los Rangos Finales no Deben ser Mayores a los Iniciales<T>
[Acciones.Refresh.change]
Nombre=change
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=SI Mavi.RM0422SelecOP=<T>Por Ruta<T><BR>entonces Forma.IrCarpeta(<T>Por Ruta<T>)<BR>sino Forma.IrCarpeta(<T>Por Supervision<T>)fin
[Por Supervision.Mavi.RM0422CSupervisionesP]
Carpeta=Por Supervision
Clave=Mavi.RM0422CSupervisionesP
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro



