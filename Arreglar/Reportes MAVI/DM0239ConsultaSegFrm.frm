
[Forma]
Clave=DM0239ConsultaSegFrm
Icono=9
CarpetaPrincipal=DM0239ConsultaSegFrm
Modulos=(Todos)
Nombre=Consulta Segmento/Linea

ListaCarpetas=DM0239ConsultaSegFrm

PosicionInicialAlturaCliente=90
PosicionInicialAncho=310



PosicionInicialIzquierda=485
PosicionInicialArriba=448
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraHerramientas=S
ListaAcciones=Mostrar detalle
AccionesTamanoBoton=15x5
AccionesCentro=S
ExpresionesAlMostrar=Asigna(Mavi.DM0239Segmentos,Nulo)
[DM0239ConsultaSegFrm]
Estilo=Ficha
Clave=DM0239ConsultaSegFrm
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
ListaEnCaptura=Mavi.DM0239Segmentos


PermiteEditar=S
[DM0239ConsultaSegFrm.Columnas]
0=-2





[DM0239ConsultaSegFrm.Mavi.DM0239Segmentos]
Carpeta=DM0239ConsultaSegFrm
Clave=Mavi.DM0239Segmentos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[DM0239SegmentosFrm.Columnas]
Segmento=206

[Acciones.Mostrar detalle]
Nombre=Mostrar detalle
Boton=0
NombreEnBoton=S
NombreDesplegar=&Mostrar Detalle
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Asigna<BR>Mostrar<BR>Cerrar
[Acciones.Mostrar detalle.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Mostrar detalle.Mostrar]
Nombre=Mostrar
Boton=0
TipoAccion=Formas
Activo=S
Visible=S

ClaveAccion=DM0239ConsultaFrm
[Acciones.Mostrar detalle.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


