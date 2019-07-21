
[Forma]
Clave=DM0239CrearSegmentosFrm
Icono=68
Modulos=(Todos)
Nombre=Crear Segmentos

ListaCarpetas=CreaSegmento
CarpetaPrincipal=CreaSegmento
PosicionInicialIzquierda=467
PosicionInicialArriba=436
PosicionInicialAlturaCliente=113
PosicionInicialAncho=346
BarraAcciones=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Cerrar



VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Mavi.DM0239CrearSeg,Nulo)
[CreaSegmento]
Estilo=Ficha
Clave=CreaSegmento
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.DM0239CrearSeg
CarpetaVisible=S

FichaNombres=Arriba
FichaAlineacion=Centrado
AlinearTodaCarpeta=S
[CreaSegmento.Mavi.DM0239CrearSeg]
Carpeta=CreaSegmento
Clave=Mavi.DM0239CrearSeg
Editar=S
LineaNueva=S
ValidaNombre=N
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

[Acciones.Aceptar.Mostrar]
Nombre=Mostrar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

ConCondicion=S
Expresion=Forma(<T>DM0239ContraSegFrm<T>)
EjecucionCondicion=SI<BR>    SQL(<T>SELECT COUNT(Segmento) FROM INVCDistribucion WHERE Segmento = :tSeg <T>,Mavi.DM0239CrearSeg) > 0<BR>Entonces<BR>    Error(<T>EL SEGMENTO YA EXISTE<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin<BR><BR>SI<BR>    Vacio(Mavi.DM0239CrearSeg)<BR>Entonces<BR>    Error(<T>EL SEGEMENTO NO DEBE IR VACIO<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin
[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreEnBoton=S
NombreDesplegar=&Aceptar
Multiple=S
EnBarraAcciones=S
TipoAccion=Expresion
ListaAccionesMultiples=Asignar<BR>Mostrar<BR>Cerrar
Activo=S
Visible=S

EspacioPrevio=S
Antes=S
AntesExpresiones=Asigna(Info.Numero,1)
[Acciones.Cerrar]
Nombre=Cerrar
Boton=0
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraAcciones=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S








