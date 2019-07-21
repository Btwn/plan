
[Forma]
Clave=RM1196FiltrosCFDIGlobalesFrm
Icono=0
Modulos=(Todos)
Nombre=CFDI Globales

ListaCarpetas=Filtros
BarraAcciones=S
AccionesTamanoBoton=15x5
AccionesCentro=S
CarpetaPrincipal=Filtros
ListaAcciones=Aceptar
PosicionInicialAlturaCliente=218
PosicionInicialAncho=239
PosicionInicialIzquierda=576
PosicionInicialArriba=183
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna( Mavi.RM1196TipoCFDI, nulo ),<BR>  Asigna( Mavi.RM1196TipoConsulta, nulo )
[Filtros]
Estilo=Ficha
Clave=Filtros
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S

FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
ListaEnCaptura=Mavi.RM1196TipoCFDI<BR>Mavi.RM1196TipoConsulta<BR>Info.Periodo<BR>Info.Ano
PermiteEditar=S
FichaAlineacion=Centrado
[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreDesplegar=Aceptar
EnBarraAcciones=S
TipoAccion=Expresion
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Asignar<BR>Auditar
[Filtros.Mavi.RM1196TipoCFDI]
Carpeta=Filtros
Clave=Mavi.RM1196TipoCFDI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco

[Filtros.Info.Periodo]
Carpeta=Filtros
Clave=Info.Periodo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Filtros.Info.Ano]
Carpeta=Filtros
Clave=Info.Ano
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.Aceptar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Aceptar.Auditar]
Nombre=Auditar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Si<BR>  ConDatos(Mavi.RM1196TipoCFDI) y ConDatos(Mavi.RM1196TipoConsulta)<BR>Entonces<BR>     Caso  (Mavi.RM1196TipoCFDI)<BR>  Es <T>Ventas a Credito<T><BR>      Entonces<BR>       Si<BR>       (Mavi.RM1196TipoConsulta=<T>Previo<T>)<BR>        Entonces<BR>           ReporteExcel(<T>RM1196AuditoriaCFDI8RepXls<T>)<BR>      Sino<BR>          ReporteExcel(<T>RM1196AuditoriaCFDI9RepXls<T>)<BR>      Fin<BR>  Es <T>Ventas de Contado<T><BR>      Entonces<BR>      Si<BR>       (Mavi.RM1196TipoConsulta=<T>Previo<T>)<BR>        Entonces<BR>           ReporteExcel(<T>RM1196AuditoriaCFDI6RepXls<T>)<BR>      Sino<BR>          Informacion(<T>Reporte Posterior<T>)<BR>      Fin<BR>  Es <T>Notas de Cargo<T><BR>      Entonces<BR>      Si<BR>       (Mavi.RM1196TipoConsulta=<T>Previo<T>)<BR>        Entonces<BR>          ReporteExcel(<T>RM1196AuditoriaCFDI7RepXls<T>)<BR>      Sino<BR>          ReporteExcel(<T>RM1196AuditoriaCFDI10RepXls<T>)<BR>      Fin<BR>      Es <T>Complemento de Pagos<T><BR>      Entonces<BR>          Si<BR>       (Mavi.RM1196TipoConsulta=<T>Previo<T>)<BR>        Entonces<BR>          ReporteImpresora(<T>RM1196AuditoriaCFDI11RepTxt<T>)<BR>      Sino<BR>          ReporteImpresora(<T>RM1196AuditoriaCFDI12RepTxt<T>)<BR>      Fin<BR>  Es <T>Numero de Parcialidades CFDI de Ingreso<T><BR>      Entonces<BR>      ReporteExcel(<T>RM1196AuditoriaCFDI13RepXls<T>)<BR>Sino<BR>  Informacion(<T>Datos Incorrectos<T>)<BR>Fin<BR>Sino<BR>    Si                                                                                                                       <BR>        (Mavi.RM1196TipoCFDI=<T>Numero de Parcialidades CFDI de Ingreso<T>)<BR>    Entonces<BR>       ReporteExcel(<T>RM1196AuditoriaCFDI13RepXls<T>)<BR>    Sino<BR>      Informacion(<T>Favor de llenar información<T>)<BR>    Fin<BR>Fin
[Filtros.Mavi.RM1196TipoConsulta]
Carpeta=Filtros
Clave=Mavi.RM1196TipoConsulta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


