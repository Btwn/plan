[Forma]
Clave=TarjetaSerieRedimNormalFrm
Nombre=Captura Serie de Monedero
Icono=91
Modulos=(Todos)
ListaCarpetas=Var
CarpetaPrincipal=Var
PosicionInicialIzquierda=351
PosicionInicialArriba=142
PosicionInicialAlturaCliente=90
PosicionInicialAncho=341
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=Aceptar<BR>Cerrar
AccionesCentro=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Mavi.SerieMoneVirtual,<T><T>)
[Var]
Estilo=Ficha
Clave=Var
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.SerieMoneVirtual
CarpetaVisible=S
[Var.Mavi.SerieMoneVirtual]
Carpeta=Var
Clave=Mavi.SerieMoneVirtual
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreEnBoton=S
NombreDesplegar=&Aceptar
EnBarraAcciones=S
TipoAccion=Expresion
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asigna<BR>virtual<BR>Close
[Acciones.Aceptar.Vitual]
Nombre=Vitual
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Forma( <T>TarjetaSerieMovMAVIRedimirVitual<T> )
[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=0
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Aceptar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Aceptar.virtual]
Nombre=virtual
Boton=0
TipoAccion=Formas
ClaveAccion=TarjetaSerieMovMAVIRedimirVitual
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=condatos(Mavi.SerieMoneVirtual) y SQL(<T>SELECT dbo.fnMonederoDV(:tSerie,0)<T>,Mavi.SerieMoneVirtual)=<T>1<T>
EjecucionMensaje=<T>Necesario escanear serie o la serie es incorrecta<T>
[Acciones.Aceptar.Close]
Nombre=Close
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

