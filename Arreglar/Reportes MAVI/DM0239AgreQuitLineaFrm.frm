
[Forma]
Clave=DM0239AgreQuitLineaFrm
Icono=0
Modulos=(Todos)
Nombre=Agregar/Quitar Linea


PosicionInicialIzquierda=467
PosicionInicialArriba=436
PosicionInicialAlturaCliente=113
PosicionInicialAncho=346
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=AgregarLineas<BR>QuitarLineas

ListaCarpetas=DM0239SegmentosFrm
CarpetaPrincipal=DM0239SegmentosFrm
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
[Acciones.AgregarLineas]
Nombre=AgregarLineas
Boton=55
NombreEnBoton=S
NombreDesplegar=&Agregar Lineas
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Asigna<BR>Mostrar<BR>Cerrar
Antes=S
AntesExpresiones=Asigna(Info.Numero,2)
[Acciones.QuitarLineas]
Nombre=QuitarLineas
Boton=5
NombreEnBoton=S
NombreDesplegar=&QuitarLineas
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Expresion
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Asignar<BR>Mostrar<BR>Cerrar
Antes=S
AntesExpresiones=Asigna(Info.Numero,3)
[DM0239AsigLineaFrm.Columnas]
0=-2

1=-2







[LineasDeSegmento.Mavi.DM0239AsigLinea]
Carpeta=LineasDeSegmento
Clave=Mavi.DM0239AsigLinea
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.AgregarLineas.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.AgregarLineas.Mostrar]
Nombre=Mostrar
Boton=0
TipoAccion=Formas
Activo=S
Visible=S

ClaveAccion=DM0239AgregaLineaFrm
ConCondicion=S
EjecucionCondicion=SI<BR>    Vacio(Mavi.DM0239Segmentos)<BR>Entonces<BR>    Error(<T>INGRESE UN SEGMENTO VALIDO<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin<BR><BR>Si<BR>    SQL(<T>SELECT COUNT(Segmento) FROM INVCDistribucion WHERE Segmento = :tSeg<T>,Mavi.DM0239Segmentos) > 0<BR>Entonces<BR>    Verdadero<BR>Sino<BR>    Error(<T>INGRESE UN SEGMENTO VALIDO<T>)<BR>    AbortarOperacion<BR>Fin
[Acciones.AgregarLineas.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.QuitarLineas.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.QuitarLineas.Mostrar]
Nombre=Mostrar
Boton=0
TipoAccion=Formas
Activo=S
Visible=S

ClaveAccion=DM0239QuitaLineaFrm
ConCondicion=S
EjecucionCondicion=SI<BR>    Vacio(Mavi.DM0239Segmentos)<BR>Entonces<BR>    Error(<T>INGRESE UN SEGMENTO VALIDO<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin<BR><BR>Si<BR>    SQL(<T>SELECT COUNT(Segmento) FROM INVCDistribucion WHERE Segmento = :tSeg<T>,Mavi.DM0239Segmentos) > 0<BR>Entonces<BR>    Verdadero<BR>Sino<BR>    Error(<T>INGRESE UN SEGMENTO VALIDO<T>)<BR>    AbortarOperacion<BR>Fin<BR><BR>Si<BR>     SQL(<T>SELECT COUNT(Linea) FROM INVCDistribucion D WHERE D.Linea  = :tLin AND D.Segmento = :tSeg<T>,<T>N/A<T>, Mavi.DM0239Segmentos) > 0<BR>Entonces<BR>     Error(<T>EL SEGMENTO SELECCIONADO NO TIENE LINEAS ASIGNADAS<T>)<BR>     AbortarOperacion<BR>Sino<BR>     Verdadero<BR>Fin
[Acciones.QuitarLineas.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S








[DM0239MuestraSegFrm.Columnas]
0=-2











[DM0239SegmentosFrm]
Estilo=Ficha
Clave=DM0239SegmentosFrm
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S



InicializarVariables=S

PermiteEditar=S
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaAlineacion=Centrado
FichaColorFondo=Plata
FichaAlineacionDerecha=S
ListaEnCaptura=Mavi.DM0239Segmentos
[DM0239SegmentosFrm.Columnas]
0=-2









Segmento=206
[DM0239SegmentosFrm.Mavi.DM0239Segmentos]
Carpeta=DM0239SegmentosFrm
Clave=Mavi.DM0239Segmentos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco







