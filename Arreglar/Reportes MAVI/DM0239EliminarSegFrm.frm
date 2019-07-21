
[Forma]
Clave=DM0239EliminarSegFrm
Icono=0
Modulos=(Todos)
Nombre=Eliminar Segmento

PosicionInicialAlturaCliente=113
PosicionInicialAncho=346
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=Aceptar<BR>Cancelar
AccionesCentro=S
PosicionInicialIzquierda=520
PosicionInicialArriba=240

ListaCarpetas=DM0239SegmentosFrm
CarpetaPrincipal=DM0239SegmentosFrm
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Mavi.DM0239Segmentos,Nulo)
[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreEnBoton=S
NombreDesplegar=&Aceptar
EnBarraAcciones=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Asigna<BR>Mostrar<BR>Cerrar
Antes=S
AntesExpresiones=Asigna(Info.Numero,4)
[Acciones.Cancelar]
Nombre=Cancelar
Boton=0
NombreEnBoton=S
NombreDesplegar=&Cancelar
EnBarraAcciones=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S












[DM0239SegmentosFrm]
Estilo=Ficha
Clave=DM0239SegmentosFrm
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaNombres=Arriba
FichaAlineacion=Centrado
FichaColorFondo=Plata
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S




ListaEnCaptura=Mavi.DM0239Segmentos
[DM0239SegmentosFrm.Columnas]
Segmento=206

[Acciones.Aceptar.Asigna]
Nombre=Asigna
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
EjecucionCondicion=SI<BR>    SQL(<T>SELECT COUNT(Segmento) FROM INVCDistribucion WHERE Segmento = :tSeg <T>,Mavi.DM0239Segmentos) > 0<BR>Entonces<BR>    Verdadero<BR>Sino<BR>    Error(<T>INGRESE UN SEGMENTO VALIDO<T>)<BR>    AbortarOperacion<BR>Fin<BR><BR>SI<BR>    Vacio(Mavi.DM0239Segmentos)<BR>Entonces<BR>    Error(<T>EL SEGEMENTO NO DEBE IR VACIO<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin<BR><BR>Si<BR>  SQL(<T>SELECT COUNT(Segmento) FROM INVCDistribucion WHERE Segmento = :tSeg  AND Linea = :tLin AND Estatus = :tEst<T>,Mavi.DM0239Segmentos,<T>N/A<T>,<T>Sin Asignar<T>) > 0 <BR>Entonces<BR>    Verdadero<BR>Sino<BR>    Error(<T>EL SEGMENTO TIENE LINEAS ASIGNADAS<T>)<BR>    AbortarOperacion<BR>Fin
[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S



[DM0239SegmentosFrm.Mavi.DM0239Segmentos]
Carpeta=DM0239SegmentosFrm
Clave=Mavi.DM0239Segmentos
Editar=S
LineaNueva=S
ValidaNombre=N
3D=S
Tamano=20
ColorFondo=Blanco


