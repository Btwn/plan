[Forma]
Clave=GenerarLayoutsMAVI
Nombre=Generar Layouts
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
AccionesTamanoBoton=15x5
ListaCarpetas=GenerarLayoutsMAVI
CarpetaPrincipal=GenerarLayoutsMAVI
ListaAcciones=Cerrar<BR>Aceptar
PosicionInicialAlturaCliente=166
PosicionInicialAncho=248
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=516
PosicionInicialArriba=299
AccionesCentro=S
BarraHerramientas=S
ExpresionesAlMostrar=Asigna(Info.Periodo, 0)<BR>Asigna(Info.Ejercicio,0)<BR>Asigna(Info.Institucion,<T><T>)
[GenerarLayoutsMAVI]
Estilo=Ficha
Clave=GenerarLayoutsMAVI
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
Vista=(Variables)
ListaEnCaptura=Info.Empresa<BR>Info.InstitucionMAVI<BR>Info.Ejercicio<BR>Info.Periodo
PermiteEditar=S
FichaEspacioEntreLineas=6
FichaEspacioNombres=0
FichaColorFondo=Plata
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaEspacioNombresAuto=S
[GenerarLayoutsMAVI.Info.Periodo]
Carpeta=GenerarLayoutsMAVI
Clave=Info.Periodo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[GenerarLayoutsMAVI.Info.Ejercicio]
Carpeta=GenerarLayoutsMAVI
Clave=Info.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[GenerarLayoutsMAVI.Info.Empresa]
Carpeta=GenerarLayoutsMAVI
Clave=Info.Empresa
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar]
Nombre=Aceptar
Boton=7
NombreDesplegar=&Generar
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
NombreEnBoton=S
EnBarraAcciones=S
EnBarraHerramientas=S
Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>Expresion
EspacioPrevio=S
[Acciones.Aceptar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Caso  Info.InstitucionMAVI<BR>  Es <T>MAGISTERIO SECCION 16 JALISCO<T> Entonces ReportePantalla(<T>canal12<T>, <T>{info.empresa}<T>,<T>{Info.InstitucionMAVI}<T>,{info.ejercicio},{info.periodo} )<BR>  Es <T>MAGISTERIO SECCION 06 COLIMA<T> Entonces ReportePantalla(<T>canal25<T>, <T>{info.empresa}<T>,<T>{Info.InstitucionMAVI}<T>,{info.ejercicio},{info.periodo} )<BR>  Es <T>MAGISTERIO SECCION 47 JALISCO<T> Entonces ReportePantalla(<T>canal13<T>, <T>{info.empresa}<T>,<T>{Info.InstitucionMAVI}<T>,{info.ejercicio},{info.periodo} )<BR>  Es <T>MAGISTERIO SECCION 20 NAYARIT<T> Entonces ReportePantalla(<T>seccion20<T>, <T>{info.empresa}<T>,<T>{Info.InstitucionMAVI}<T>,{info.ejercicio},{info.periodo} )<BR>  Es <T>MAGISTERIO SECCION 01 AGUASCALIENTES<T> Entonces ReportePantalla(<T>seccion1Aguas<T><CONTINUA>
Expresion002=<CONTINUA>, <T>{info.empresa}<T>,<T>{Info.InstitucionMAVI}<T>,{info.ejercicio},{info.periodo} )<BR>  Es <T>HOSPITAL CIVIL<T> Entonces ReportePantalla(<T>canal14<T>, <T>{info.empresa}<T>,<T>{Info.InstitucionMAVI}<T>,{info.ejercicio},{info.periodo} )<BR>  Es <T>SINDICATO UNIVERSIDAD DE GUADALAJARA<T> Entonces ReportePantalla(<T>SUDG<T>, <T>{info.empresa}<T>,<T>{Info.InstitucionMAVI}<T>,{info.ejercicio},{info.periodo} )<BR>  Es <T>MAGISTERIO SECCION 39 COLIMA<T> Entonces ReportePantalla(<T>SECC39<T>, <T>{info.empresa}<T>,<T>{Info.InstitucionMAVI}<T>,{info.ejercicio},{info.periodo} )<BR>  Es <T>H  AYUNTAMIENTO TLAQUEPAQUE<T> Entonces ReportePantalla(<T>HATLAQUEP<T>, <T>{info.empresa}<T>,<T>{Info.InstitucionMAVI}<T>,{info.ejercicio},{info.periodo} )<BR>  Es <T>H  AYUNTAMIENTO PUERTO VALLARTA<T> Entonces R<CONTINUA>
Expresion003=<CONTINUA>eportePantalla(<T>HAPTOV<T>, <T>{info.empresa}<T>,<T>{Info.InstitucionMAVI}<T>,{info.ejercicio},{info.periodo} )<BR>  Es <T>MAGISTERIO SECCION 49 NAYARIT<T> Entonces ReportePantalla(<T>canal20<T>, <T>{info.empresa}<T>,<T>{Info.InstitucionMAVI}<T>,{info.ejercicio},{info.periodo},{EstacionTrabajo} )<BR>  Es <T>H  AYUNTAMIENTO GUADALAJARA<T> Entonces ReportePantalla(<T>canal17<T>, <T>{info.empresa}<T>,<T>{Info.InstitucionMAVI}<T>,{info.ejercicio},{info.periodo},{EstacionTrabajo} )<BR>  Es <T>IMSS<T> Entonces ReportePantalla(<T>canal15<T>, <T>{info.empresa}<T>,<T>{Info.InstitucionMAVI}<T>,{info.ejercicio},{info.periodo},{EstacionTrabajo} )  <BR>  Es <T>AYUNTAMIENTO CIUDAD GUZMAN<T> Entonces ReportePantalla(<T>HACGUZMAN<T>, <T>{info.empresa}<T>,<T>{Info.InstitucionMAVI}<T>,{info.ejercicio},{info.periodo} )<BR>  Es <T>H  AYUNTAMIENTO COLIMA<T> Entonces ReportePantalla(<T>HACOL<T>, <T>{info.empresa}<T>,<T>{Info.InstitucionMAVI}<T>,{info.ejercicio},{info.periodo} )<BR><BR><BR>Sino<BR> Error( <T>Institución No Encontrada<T>, BotonAceptar  )<BR>Fin
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[GenerarLayoutsMAVI.Info.InstitucionMAVI]
Carpeta=GenerarLayoutsMAVI
Clave=Info.InstitucionMAVI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


