[Forma]
Clave=MaviAlmEmbarqueFisicoCausaEliminacionRegFrm
Nombre=Causa de Eliminacion
Icono=122
Modulos=(Todos)
ListaCarpetas=Variables
CarpetaPrincipal=Variables
PosicionInicialAlturaCliente=77
PosicionInicialAncho=203
PosicionInicialIzquierda=2
PosicionInicialArriba=6
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
VentanaSiempreAlFrente=S
VentanaSinIconosMarco=S
ExpresionesAlMostrar=Asigna(Mavi.AlmCausaEliminacion,Nulo)
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
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
FichaNombres=Arriba
FichaAlineacion=Centrado
PermiteEditar=S
ListaEnCaptura=Mavi.AlmCausaEliminacion
[Acciones.Aceptar.AsinaVals]
Nombre=AsinaVals
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.CierraForma]
Nombre=CierraForma
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
ConCondicion=S
EjecucionConError=S
Visible=S
EjecucionCondicion=condatos(Mavi.AlmCausaEliminacion)
EjecucionMensaje=<T>Debes capturar un motivo..<T>
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreDesplegar=<T>Aceptar <T>
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=AsinaVals<BR>CierraForma
Activo=S
Visible=S
NombreEnBoton=S
[Variables.Mavi.AlmCausaEliminacion]
Carpeta=Variables
Clave=Mavi.AlmCausaEliminacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=<T>Cerrar <T>
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


