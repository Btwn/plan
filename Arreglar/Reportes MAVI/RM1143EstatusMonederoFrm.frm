[Forma]
Clave=RM1143EstatusMonederoFrm
Nombre=RM1143 Estatus Monedero
Icono=91
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialIzquierda=614
PosicionInicialArriba=211
PosicionInicialAlturaCliente=81
PosicionInicialAncho=243
ListaCarpetas=Variables
CarpetaPrincipal=Variables
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ListaAcciones=Preliminar<BR>Cerrar<BR>Imprimir<BR>aExcel
ExpresionesAlMostrar=Asigna(Info.Periodo,PeriodoTrabajo)<BR>Asigna(Info.Ejercicio, EjercicioTrabajo)
[Variables]
Estilo=Ficha
Clave=Variables
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=Info.Periodo<BR>Info.Ejercicio
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Variables.Info.Periodo]
Carpeta=Variables
Clave=Info.Periodo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[Variables.Info.Ejercicio]
Carpeta=Variables
Clave=Info.Ejercicio
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Imprimir]
Nombre=Imprimir
Boton=46
NombreEnBoton=S
NombreDesplegar=&Imprimir
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=asignarCampos<BR>aImprimir
[Acciones.aExcel]
Nombre=aExcel
Boton=-1
NombreDesplegar=&Excel
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=Asigna<BR>Llamada<BR>Salir
[Acciones.Preliminar.Llamada]
Nombre=Llamada
Boton=0
TipoAccion=Reportes Impresora
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
ClaveAccion=RM1143EstatusMonederoRepTxt
EjecucionCondicion=CONDATOS(INFO.PERIODO) y<BR>CONDATOS(INFO.EJERCICIO)
EjecucionMensaje=<T>INGRESE Periodo o Ejercicio<T>+ ASCII( 13 )+ <T>SON CAMPOS REQUERIDOS<T>
[Acciones.Preliminar.Salir]
Nombre=Salir
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Imprimir.asignarCampos]
Nombre=asignarCampos
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Imprimir.aImprimir]
Nombre=aImprimir
Boton=0
TipoAccion=Reportes Impresora
Activo=S
Visible=S
[Acciones.aExcel.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.aExcel.Llamada]
Nombre=Llamada
Boton=0
TipoAccion=Expresion
Activo=S
ConCondicion=S
Visible=S
EjecucionConError=S
Expresion=Si<BR>    Mavi.RM1144MonXVolTipRep = <T>CONDENSADO<T><BR>Entonces<BR>    ReportePantalla(<T>RM1144MonederoXVolumenRepA<T>)<BR>Fin<BR><BR><BR>Si<BR>    Mavi.RM1144MonXVolTipRep = <T>ANALITICO<T><BR>Entonces<BR>     ReportePantalla(<T>RM1144MonederoXVolumenRep1<T>)<BR>Fin
EjecucionCondicion=CONDATOS(INFO.PERIODO) y<BR>CONDATOS(INFO.EJERCICIO) y<BR>CONDATOS(Mavi.RM1144MonXVolTipRep)
EjecucionMensaje=<T>INGRESE Periodo o Ejercicio o Tipo<T>+ ASCII( 13 )+ <T>SON CAMPOS REQUERIDOS<T>
[Acciones.aExcel.Salir]
Nombre=Salir
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Preliminar]
Nombre=Preliminar
Boton=54
NombreEnBoton=S
NombreDesplegar=&<T>Enviar a TXT<T>
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=Asigna<BR>Llamada<BR>Salir
Activo=S
Visible=S

