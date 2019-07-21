[Forma]
Clave=RM0422BCredHojaSuperPersonalFrm
Nombre=RM0422B Hoja de Supervisión Personal
Icono=572
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=Por Ruta<BR>Por Supervision<BR>Principal
CarpetaPrincipal=Principal
PosicionInicialIzquierda=498
PosicionInicialArriba=221
PosicionInicialAlturaCliente=292
PosicionInicialAncho=363
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaAvanzaTab=S
VentanaEstadoInicial=Normal
ListaAcciones=Preliminar<BR>Actualizar<BR>Cerrar
PosicionSec1=50
VentanaAjustarZonas=S
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(Mavi.TipoFormatoSup,<T>PERSONAL<T>)<BR>Asigna(Mavi.TipoSupervision,<T>Supervision<T>)<BR>Asigna(Mavi.RM0422RutasIDSuperD,Nulo)<BR>Asigna(Mavi.RM0422RutasIDSuperA,Nulo)<BR>Asigna(Info.FechaD,Nulo)<BR>Asigna(Info.FechaA,Nulo)<BR>Asigna(Mavi.AgenteSuperv,Nulo)<BR>Asigna(Mavi.RM0422SelecOP,<T>Por Ruta<T>)<BR>ASIGNA(Mavi.RM0422BSupervisionesP,Nulo)
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
EjecucionCondicion=Si Mavi.RM0422SelecOP=<T>Por Supervision<T><BR>Entonces<BR>    ConDatos(Mavi.RM0422BSupervisionesP)<BR>Sino<BR>    1=1<BR>FIN
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
ListaAccionesMultiples=Asignar<BR>Llamarpp<BR>Cerrar
Activo=S
Visible=S
[Principal]
Estilo=Ficha
Clave=Principal
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
PermiteEditar=S
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
Efectos=[Negritas]
[Acciones.Refresh.Asig1]
Nombre=Asig1
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Refresh.cambcamp]
Nombre=cambcamp
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=SI Mavi.RM0422SelecOP=<T>Por Ruta<T><BR>entonces Forma.IrCarpeta(<T>Por Ruta<T>)<BR>sino Forma.IrCarpeta(<T>Por Supervision<T>)fin
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
ListaEnCaptura=Mavi.RM0422RutasIDSuperD<BR>Mavi.RM0422RutasIDSuperA<BR>Info.FechaD<BR>Info.FechaA<BR>Mavi.AgenteSuperv
CarpetaVisible=S
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
[Por Supervision]
Estilo=Ficha
PestanaNombre=Por Supervision
Clave=Por Supervision
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=5
FichaEspacioNombres=121
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM0422BSupervisionesP
CarpetaVisible=S
[Acciones.Preliminar.Llamarpp]
Nombre=Llamarpp
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Si Mavi.RM0422SelecOP=<T>Por Ruta<T><BR>entonces<BR>    ReportePantalla(<T>RM0422BCredHojaSuperPersonalRep<T>)<BR>sino<BR>    Si Vacio(Mavi.RM0422BSupervisionesP)<BR>    Entonces<BR>        Error(<T>Debe seleccionar una Supervision<T>)<BR>    SiNo<BR>        ReportePantalla(<T>RM0422BPorSupervisionRep<T>)<BR>    FIN<BR>fin
EjecucionCondicion=Si(ConDatos(Info.FechaD) Y Condatos(Info.FechaA),Info.FechaD<=Info.FechaA,1=1)<BR>    Y  Si(ConDatos(Mavi.RM0422RutasIDSuperD) Y Condatos(Mavi.RM0422RutasIDSuperA),Mavi.RM0422RutasIDSuperD<=Mavi.RM0422RutasIDSuperA,1=1)
EjecucionMensaje=<T>Los Rangos Finales no Deben ser Mayores a los Iniciales<T>
[Por Supervision.Mavi.RM0422BSupervisionesP]
Carpeta=Por Supervision
Clave=Mavi.RM0422BSupervisionesP
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Actualizar]
Nombre=Actualizar
Boton=125
NombreEnBoton=S
NombreDesplegar=&Actualizar
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
ListaAccionesMultiples=Asigg1<BR>calling
Activo=S
Visible=S
[Acciones.Actualizar.Asigg1]
Nombre=Asigg1
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
[Acciones.Actualizar.calling]
Nombre=calling
Boton=0
TipoAccion=Expresion
Expresion=SI Mavi.RM0422SelecOP=<T>Por Ruta<T><BR>entonces Forma.IrCarpeta(<T>Por Ruta<T>)<BR>sino Forma.IrCarpeta(<T>Por Supervision<T>)fin



