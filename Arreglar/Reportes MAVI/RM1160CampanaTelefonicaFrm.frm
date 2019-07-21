[Forma]
Clave=RM1160CampanaTelefonicaFrm
Nombre=Campaña Cobranza Telefonica
Icono=0
Modulos=(Todos)
ListaCarpetas=Variables
CarpetaPrincipal=Variables
PosicionInicialIzquierda=367
PosicionInicialArriba=97
PosicionInicialAlturaCliente=343
PosicionInicialAncho=854
EsConsultaExclusiva=S
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Agregar Campaña<BR>AgregarMensaje<BR>Cerrar<BR>Asignar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
VentanaAvanzaTab=S
VentanaBloquearAjuste=S
VentanaConIcono=S
ExpresionesAlMostrar=Asigna(MAVI.RM1160Reporte,<T>GENERAL<T>)<BR>Asigna(Mavi.RM1160GestionaA,<T>AMBOS<T>)<BR>Asigna(Mavi.RM1160Seccion,<T><T>)<BR>Asigna(Mavi.RM1160Categoria,<T><T>)<BR>Asigna(Mavi.RM1160CanalVenta,<T><T>)<BR>Asigna(Mavi.RM1160Nivel,<T><T>)<BR>Asigna(Mavi.RM1160ProxVenc,nulo)            <BR>Asigna(Mavi.RM1160DVDesde,nulo)<BR>Asigna(Mavi.RM1160DVHasta,nulo)                                                <BR>Asigna(Mavi.RM1160DIDesde,nulo)<BR>Asigna(Mavi.RM1160DIHasta,nulo)<BR>Asigna(Mavi.RM1160Campanas,<T><T>)
[Variables]
Estilo=Ficha
Clave=Variables
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=MAVI.RM1160Reporte<BR>Mavi.RM1160GestionaA<BR>Mavi.RM1160Seccion<BR>Mavi.RM1160Categoria<BR>Mavi.RM1160Nivel<BR>Mavi.RM1160CanalVenta<BR>Mavi.RM1160ProxVenc<BR>Mavi.RM1160DVDesde<BR>Mavi.RM1160DVHasta<BR>Mavi.RM1160DIDesde<BR>Mavi.RM1160DIHasta<BR>Mavi.RM1160Campanas<BR>MAVI.RM1160Tipo
CarpetaVisible=S
FichaEspacioEntreLineas=9
FichaEspacioNombres=75
FichaColorFondo=Plata
PermiteEditar=S
FichaNombres=Izquierda
FichaEspacioNombresAuto=S
FichaAlineacion=Izquierda

[Variables.Mavi.RM1160GestionaA]
Carpeta=Variables
Clave=Mavi.RM1160GestionaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Variables.Mavi.RM1160Seccion]
Carpeta=Variables
Clave=Mavi.RM1160Seccion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Variables.Mavi.RM1160Categoria]
Carpeta=Variables
Clave=Mavi.RM1160Categoria
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Variables.Mavi.RM1160CanalVenta]
Carpeta=Variables
Clave=Mavi.RM1160CanalVenta
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Variables.Mavi.RM1160ProxVenc]
Carpeta=Variables
Clave=Mavi.RM1160ProxVenc
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Variables.Mavi.RM1160DVDesde]
Carpeta=Variables
Clave=Mavi.RM1160DVDesde
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Variables.Mavi.RM1160DVHasta]
Carpeta=Variables
Clave=Mavi.RM1160DVHasta
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Variables.Mavi.RM1160DIDesde]
Carpeta=Variables
Clave=Mavi.RM1160DIDesde
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Variables.Mavi.RM1160DIHasta]
Carpeta=Variables
Clave=Mavi.RM1160DIHasta
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreDesplegar=&Preliminar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asignar<BR>Asignar Aceptar<BR>Abrir Rep
Activo=S
Visible=S
NombreEnBoton=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Preliminar.Abrir Rep]
Nombre=Abrir Rep
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Caso MAVI.RM1160Reporte<BR>  Es <T>GENERAL<T> Entonces ReportePantalla(<T>RM1160GeneralRep<T>)<BR>  Es <T>GENERAL CONDENSADO<T> Entonces ReportePantalla(<T>RM1160GeneralCondensadoRep<T>)<BR>  Es <T>PREDICTIVO<T> Entonces ReportePantalla(<T>RM1160PredictivoRep<T>)<BR>  Es <T>SMS<T> Entonces ReportePantalla(<T>RM1160SMSRep<T>)<BR>Fin
[Variables.Mavi.RM1160Nivel]
Carpeta=Variables
Clave=Mavi.RM1160Nivel
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.Asignar Aceptar]
Nombre=Asignar Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
ConCondicion=S
Visible=S
EjecucionCondicion=Caso  MAVI.RM1160Reporte<BR><BR> Es <T>GENERAL<T><BR> Entonces<BR>        SI  ConDatos(MAVI.RM1160Reporte) y ConDatos(Mavi.RM1160GestionaA)<BR>        ENTONCES<BR>            VERDADERO<BR>        SINO<BR>             Error(<T>Por favor selecciona Tipo de Reporte y Gestiona A para continuar<T>)<BR>             AbortarOperacion<BR>        FIN<BR>Es   <T>PREDICTIVO<T>                                                                             <BR> Entonces<BR>        SI  ConDatos(MAVI.RM1160Reporte) y ConDatos(Mavi.RM1160GestionaA)<BR>        ENTONCES<BR>           // VERDADERO<BR>        SINO<BR>             Error(<T>Por favor selecciona Tipo de Reporte y Gestiona A para continuar<T>)<BR>             AbortarOperacion<BR>        FIN<BR> Es <T>SMS<T><BR> Entonces<BR>       SI  ConDatos(MAVI.RM1160Reporte) y ConDatos(Mavi.RM1160Campanas)<BR>       ENTONCES<BR>            VERDADERO<BR>       SINO<BR>            Error(<T>Por favor selecciona Tipo de Reporte y Campaña para continuar<T>)<BR>         AbortarOperacion<BR>       FIN<BR>Fin<BR><BR><BR>Si  (MAVI.RM1160Reporte  = <T>GENERAL<T>)  o  ( MAVI.RM1160Reporte  = <T>PREDICTIVO<T>)<BR>Entonces              <BR><BR>    Si (ConDatos(Mavi.RM1160DVDesde)) y (ConDatos(Mavi.RM1160DVHasta))<BR>    Entonces<BR>          Si  TextoEnNum( Mavi.RM1160DVDesde )  > TextoEnNum( Mavi.RM1160DVHasta )<BR>             Entonces<BR>             Error(<T>Dias Vencidos Minimos deben ser menor que Dias Vencidos Maximos<T>)<BR>             AbortarOperacion<BR>          Fin<BR>    Fin<BR><BR>    Si ConDatos(Mavi.RM1160DIDesde) y ConDatos(Mavi.RM1160DIHasta)<BR>    Entonces                                                                                                                         <BR>          Si TextoEnNum( Mavi.RM1160DIDesde )    > TextoEnNum( Mavi.RM1160DIHasta )<BR>          Entonces<BR>               Error(<T>Dias Inactivos Minimos deben ser menor que Dias Inactivos Maximos<T>)<BR>               AbortarOperacion<BR>          Fin<BR>    Fin<BR><BR>Fin
[Acciones.Agregar Campaña]
Nombre=Agregar Campaña
Boton=39
NombreEnBoton=S
NombreDesplegar=Agregar Campaña
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=RM1160ConfigCampTelFrm
Activo=S
Visible=S
[Variables.Mavi.RM1160Campanas]
Carpeta=Variables
Clave=Mavi.RM1160Campanas
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Acciones.info.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si<BR> esnumerico(Mavi.RM1160DVDesde)<BR>Entonces<BR>  informacion(<T>si es num<T>)<BR>Sino                                     <BR>  informacion(<T>no es num<T>)<BR>Fin

[Listado.Columnas]
Id=34
Titulo=106
Nombre=140
MinimoDV=64
MaximoDV=64
Uen=64
TextoMensaje=604
TextoSalida=604
Usuario=76
Fecha=94
0=-2

ID=34
Tipo=154
[Acciones.AgregarMensaje]
Nombre=AgregarMensaje
Boton=38
NombreEnBoton=S
NombreDesplegar=&Agregar Mensaje
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=RM1160CatalogoCampanaFrm
Activo=S
Visible=S

[Categoria Filtro.Columnas]
0=185

[Principal.Columnas]
0=90
1=-2

[Variables.MAVI.RM1160Reporte]
Carpeta=Variables
Clave=MAVI.RM1160Reporte
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco



[Variables.MAVI.RM1160Tipo]
Carpeta=Variables
Clave=MAVI.RM1160Tipo
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

AccionAlEnter=
AccionAlEnterBloquearAvance=N
EditarConBloqueo=N
IgnoraFlujo=N
Pegado=N

[Acciones.AsignarValorTipo.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S




[Acciones.prueba.ex]
Nombre=ex
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Informacion( MAVI.RM1160Tipo )





[Acciones.Asignar]
Nombre=Asignar
Boton=0
NombreDesplegar=&Asignar
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
ConAutoEjecutar=S
EnBarraHerramientas=S
AutoEjecutarExpresion=1




