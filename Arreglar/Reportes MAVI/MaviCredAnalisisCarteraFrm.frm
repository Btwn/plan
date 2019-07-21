[Forma]
Clave=MaviCredAnalisisCarteraFrm
Nombre=RM429 Análisis de Cartera
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=377
PosicionInicialArriba=301
PosicionInicialAltura=196
PosicionInicialAncho=269
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
AccionesTamanoBoton=25x5
ListaAcciones=RepPan<BR>Cerrar
AccionesCentro=S
AccionesDivision=S
VentanaEscCerrar=S
PosicionInicialAlturaCliente=132
VentanaEstadoInicial=Normal
BarraHerramientas=S
ExpresionesAlMostrar=Asigna(Mavi.VencimientoD,NULO)<BR>Asigna(Mavi.VencimientoH,NULO)<BR>Asigna(Mavi.CveCanalVtaCre,NULO)

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
FichaEspacioEntreLineas=15
FichaEspacioNombres=100
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.CveCanalVtaCre<BR>Mavi.VencimientoD<BR>Mavi.VencimientoH
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
BtnResaltado=S

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
BtnResaltado=S

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





[Acciones.RepPan.exprecion]
Nombre=exprecion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si Mavi.Vencimientos=<T>30,60,90<T><BR>entonces<BR>asigna(Mavi.VarPlazo1,30)<BR>asigna(Mavi.VarPlazo2,60)<BR>asigna(Mavi.VarPlazo3,90)<BR>fin<BR><BR>Si Mavi.Vencimientos=<T>7,90,360<T><BR>entonces<BR>asigna(Mavi.VarPlazo1,7)<BR>asigna(Mavi.VarPlazo2,90)<BR>asigna(Mavi.VarPlazo3,360)<BR>fin<BR><BR>Si Mavi.Vencimientos=<T>90,360,720<T><BR>entonces<BR>asigna(Mavi.VarPlazo1,90)<BR>asigna(Mavi.VarPlazo2,360)<BR>asigna(Mavi.VarPlazo3,720)<BR>fin
[(Variables).Mavi.CveCanalVtaCre]
Carpeta=(Variables)
Clave=Mavi.CveCanalVtaCre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=N
[(Variables).Mavi.VencimientoD]
Carpeta=(Variables)
Clave=Mavi.VencimientoD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=N
[(Variables).Mavi.VencimientoH]
Carpeta=(Variables)
Clave=Mavi.VencimientoH
Editar=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
