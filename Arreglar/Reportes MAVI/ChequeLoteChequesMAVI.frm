[Forma]
Clave=ChequeLoteChequesMAVI
Nombre=Cheque en lote
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=149
PosicionInicialAncho=195
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialIzquierda=410
PosicionInicialArriba=272
ListaAcciones=Preliminar
[(Variables)]
Estilo=Ficha
Clave=(Variables)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
ListaEnCaptura=Info.ChequeD<BR>Info.ChequeA
[(Variables).Info.ChequeD]
Carpeta=(Variables)
Clave=Info.ChequeD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.ChequeA]
Carpeta=(Variables)
Clave=Info.ChequeA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Imprimir.Preliminar]
Nombre=Preliminar
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
ListaAccionesMultiples=Asignar<BR>Preliminar
Activo=S
Visible=S
[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
[Acciones.Preliminar.Preliminar]
Nombre=Preliminar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Institucion,SQL( <T>select Institucion from ctadinero where ctadinero =:TCtaDinero<T>,Info.CtaDinero))<BR>Caso  Info.Institucion<BR>  Es <T>BANAMEX<T> Entonces ReportePantalla(<T>RepChequeLoteBanamexMAVI<T>)<BR>  Es <T>BANSI<T> Entonces ReportePantalla(<T>RepChequeLoteBansiMAVI<T>)<BR>  Es <T>BANORTE<T> Entonces ReportePantalla(<T>RepChequeLoteBanorteMAVI<T>)<BR>  Es <T>SANTANDER SERFIN<T> Entonces ReportePantalla(<T>RepChequeLoteSantanderMAVI<T>)<BR>  Es <T>BBVA BANCOMER<T> Entonces ReportePantalla(<T>RepChequeLoteBancomerMAVI<T>)<BR>  Es <T>HSBC<T> Entonces ReportePantalla(<T>RepChequeLoteHsbcMAVI<T>)<BR>  Es <T>BANCO DEL BAJIO<T> Entonces ReportePantalla(<T>RepChequeLoteBajioMAVI<T>)<BR>Sino<BR>  Informacion(<T>Este Banco No tiene definido un Formato de Cheque<T>)<BR>Fin

