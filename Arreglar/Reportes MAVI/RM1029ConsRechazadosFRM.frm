[Forma]
Clave=RM1029ConsRechazadosFRM
Nombre=RM1029 Analisis Cred Rechazados
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=531
PosicionInicialArriba=279
PosicionInicialAlturaCliente=165
PosicionInicialAncho=399
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Dise�o
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Info.FechaD,HOY)<BR>Asigna(Info.FechaA,HOY)<BR>Asigna(Mavi.RM1029Tipo, nulo)
ExpresionesAlCerrar=Si Mavi.RM1029Tipo=<T>Gerencia<T><BR>Entonces<BR>    ConDatos(Mavi.RM1029Tipo)<BR>Sino<BR>    1=1<BR>FIN
Menus=S
[(Variables)]
Estilo=Ficha
Clave=(Variables)
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
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
ListaEnCaptura=Info.FechaD<BR>Info.FechaA<BR>Mavi.RM1029Tipo
CarpetaVisible=S
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
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S
[Acciones.cerrar]
Nombre=cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=Cerrar
TipoAccion=Ventana
Activo=S
Visible=S
ClaveAccion=Cerrar
EnMenu=S
UsaTeclaRapida=S
[Acciones.Preliminar.asignar]
Nombre=asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreDesplegar=Preliminar
Multiple=S
ListaAccionesMultiples=asignar<BR>expe<BR>cerrar
Activo=S
Visible=S
NombreEnBoton=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+P
EnMenu=S
[(Variables).Mavi.RM1029Tipo]
Carpeta=(Variables)
Clave=Mavi.RM1029Tipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar.expe]
Nombre=expe
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si Mavi.RM1029Tipo=<T>Sucursal<T><BR>entonces<BR>    ReportePantalla(<T>RM1029DivisionRep<T>)<BR>sino<BR>    Si Vacio(Mavi.RM1029Tipo)<BR>    Entonces<BR>        Error(<T>Debe seleccionar un reporte<T>)<BR>    SiNo<BR>        ReportePantalla(<T>RM1029GerenciaRep<T>)<BR>    FIN<BR>fin
[Acciones.actualizar.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.actualizar.call]
Nombre=call
Boton=0
TipoAccion=expresion
Expresion=SI Mavi.RM1029Tipo=<T>Division<T><BR>entonces Forma.IrCarpeta(<T>Por Ruta<T>)<BR>sino Forma.IrCarpeta(<T>Por Supervision<T>)fin
Activo=S
Visible=S
[Acciones.Preliminar.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

