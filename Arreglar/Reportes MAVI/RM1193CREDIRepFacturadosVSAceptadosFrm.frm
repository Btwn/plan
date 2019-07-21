
[Forma]
Clave=RM1193CREDIRepFacturadosVSAceptadosFrm
Icono=0
Modulos=(Todos)
Nombre=Analisis Facturado VS Aceptados
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S

ListaAcciones=Preliminar<BR>Cerrar
ListaCarpetas=Variables
CarpetaPrincipal=Variables
PosicionInicialIzquierda=398
PosicionInicialArriba=234
PosicionInicialAlturaCliente=189
PosicionInicialAncho=323
PosicionCol1=248

VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
VentanaBloquearAjuste=S
ExpresionesAlMostrar=asigna(Info.FechaD,Nulo)<BR>asigna(Info.FechaA,Nulo)<BR>asigna(Mavi.TipoClienteVenta,Nulo)
[Acciones.Aceptar.ACEP]
Nombre=ACEP
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

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
ListaEnCaptura=Info.FechaD<BR>Info.FechaA<BR>Mavi.TipoClienteVenta
CarpetaVisible=S

FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S

FichaAlineacion=Centrado
FichaNombres=Arriba
[Variables.Info.FechaD]
Carpeta=Variables
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Variables.Info.FechaA]
Carpeta=Variables
Clave=Info.FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

Pegado=N
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

NombreEnBoton=S

EspacioPrevio=S
[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S



[Acciones.Aceptar.aceptar]
Nombre=aceptar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Aceptar.CERR]
Nombre=CERR
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S



[Variables.Mavi.TipoClienteVenta]
Carpeta=Variables
Clave=Mavi.TipoClienteVenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.Preliminar]
Nombre=Preliminar
Boton=68
NombreEnBoton=S
NombreDesplegar=&Preliminar
GuardarAntes=S
Multiple=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
ListaAccionesMultiples=preliminar<BR>CERR
Activo=S
Visible=S

EspacioPrevio=S
[Acciones.Preliminar.preliminar]
Nombre=preliminar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar

[Acciones.Preliminar.CERR]
Nombre=CERR
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar

ConCondicion=S

EjecucionCondicion=Si<BR>    ConDatos(Info.FechaD) y ConDatos(Info.FechaA)<BR>Entonces<BR>    Si<BR>       Info.FechaD > Info.FechaA<BR>    Entonces<BR>       Error(<T>Rango de Fechas no Valido<T>)<BR>       AbortarOperacion<BR>    Sino<BR>       Verdadero<BR>    Fin<BR>Fin<BR>Si<BR>  ConDatos(Info.FechaD)<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  Error(<T>Fecha de inicio debe ser obligatoria<T>)<BR>  AbortarOperacion<BR>Fin<BR>Si<BR>  ConDatos(Info.FechaA)<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  Error(<T>Fecha de inicio debe ser obligatoria<T>)<BR>  AbortarOperacion<BR>Fin<BR>Si<BR>  ConDatos(Mavi.TipoClienteVenta)<BR>Entonces<BR> Verdadero<BR>Sino<BR>  Error(<T>Es necesario seleccionar un tipo de cliente<T>)<BR>   AbortarOperacion<BR>Fin
[Acciones.Excel.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Excel.Generar]
Nombre=Generar
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=RM1193FacturadoVSAceptadosRepXls
Activo=S
Visible=S

[Acciones.Excel.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Texto.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Texto.generar]
Nombre=generar
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM1193FacturadoVSAceptadosRepTxt
Activo=S
Visible=S

[Acciones.Texto.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


