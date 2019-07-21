[Forma]
Clave=MaviCredAnalisCarteraFrm
Nombre=Analisis de Cartera
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=356
PosicionInicialArriba=303
PosicionInicialAltura=196
PosicionInicialAncho=312
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
AccionesTamanoBoton=25x5
ListaAcciones=Cerrar<BR>RepPan
AccionesCentro=S
AccionesDivision=S
BarraHerramientas=S
VentanaEscCerrar=S
PosicionInicialAlturaCliente=127
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=asigna(Mavi.Plazo,0)<BR>Asigna(Info.Desglosar, <T>Si<T>)    <BR>Asigna(Info.Moneda, <T>(Todas)<T>)<BR>Asigna(Mavi.Vencimientos,<T>30,60,90<T>)<BR>asigna(Info.CteCat,<T><T>)<BR>Asigna(Info.Fechad,primerdiames(hoy))<BR>Asigna(Info.Fechaa,Ultimodiames(hoy))

[(Variables)]
Estilo=Ficha
Clave=(Variables)
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={MS Sans Serif, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.CteCat<BR>Mavi.Vencimientos<BR>Info.FechaD<BR>Info.FechaA
CarpetaVisible=S

[Acciones.RepPan]
Nombre=RepPan
Boton=6
NombreDesplegar=&Preliminar
Multiple=S
EnBarraAcciones=S
Activo=S
Visible=S
ListaAccionesMultiples=Variables Asignar<BR>exprecion<BR>Preliminar
NombreEnBoton=S
EnBarraHerramientas=S
GuardarAntes=S

[Acciones.RepPan.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Imprimir.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cancelar
Activo=S
Visible=S

[Acciones.RepPan.Preliminar]
Nombre=Preliminar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S

[Acciones.Imprimir.Imprimir]
Nombre=Imprimir
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=MaviCredAnalisisCarteraRep
Activo=S
Visible=S





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
EspacioPrevio=S
[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.CteCat]
Carpeta=(Variables)
Clave=Info.CteCat
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S
[(Variables).Mavi.Vencimientos]
Carpeta=(Variables)
Clave=Mavi.Vencimientos
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
EspacioPrevio=N
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.RepPan.exprecion]
Nombre=exprecion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si Mavi.Vencimientos=<T>30,60,90<T><BR>entonces<BR>asigna(Mavi.VarPlazo1,30)<BR>asigna(Mavi.VarPlazo2,60)<BR>asigna(Mavi.VarPlazo3,90)<BR>fin<BR><BR>Si Mavi.Vencimientos=<T>7,90,360<T><BR>entonces<BR>asigna(Mavi.VarPlazo1,7)<BR>asigna(Mavi.VarPlazo2,90)<BR>asigna(Mavi.VarPlazo3,360)<BR>fin<BR><BR>Si Mavi.Vencimientos=<T>90,360,720<T><BR>entonces<BR>asigna(Mavi.VarPlazo1,90)<BR>asigna(Mavi.VarPlazo2,360)<BR>asigna(Mavi.VarPlazo3,720)<BR>fin
