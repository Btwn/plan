[Forma]
Clave=RM1039MonPrincipalFrm
Nombre=RM1039 Kardex Monedero
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=72
PosicionInicialAncho=298
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=491
PosicionInicialArriba=456
ExpresionesAlMostrar=Asigna(Mavi.RM1039CtaMonedero,<T><T>)
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
ListaEnCaptura=Mavi.RM1039CtaMonedero
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
FichaNombres=Arriba
[(Variables).Mavi.RM1039CtaMonedero]
Carpeta=(Variables)
Clave=Mavi.RM1039CtaMonedero
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.Preliminar]
Nombre=Preliminar
Boton=23
NombreDesplegar=&Preliminar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=Variables Asignar<BR>Aceptar<BR>REPORTE
NombreEnBoton=S
[Acciones.Preliminar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=SI (SQL(<T>SELECT dbo.fnMonederoDV(:tSerie,0)<T>,Mavi.RM1039CtaMonedero))=<T>1<T> y Longitud(Mavi.RM1039CtaMonedero)<=11<BR>ENTONCES<BR>    Asigna(Mavi.RM1039CtaMonedero,Izquierda(Mavi.RM1039CtaMonedero,8))<BR>    Verdadero<BR>SINO<BR>    Asigna(Mavi.RM1039CtaMonedero,<T><T>)<BR>    Falso<BR>FIN
EjecucionMensaje=<T>Monedero incorrecto...<T>

[Acciones.Cerrar]
Nombre=Cerrar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S



[Acciones.Preliminar.REPORTE]
Nombre=REPORTE
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=RM1039KardexMonederoRep
Activo=S
Visible=S

