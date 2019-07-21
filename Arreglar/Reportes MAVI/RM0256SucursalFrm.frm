[Forma]
Clave=RM0256SucursalFrm
Nombre=RM0256 Sucursal
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=prel<BR>cer
PosicionInicialAlturaCliente=76
PosicionInicialAncho=220
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=530
PosicionInicialArriba=457
BarraHerramientas=S
ExpresionesAlMostrar=Asigna(Mavi.Sucursal,99)
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
ListaEnCaptura=Mavi.Sucursal
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
[(Variables).Mavi.Sucursal]
Carpeta=(Variables)
Clave=Mavi.Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.prel]
Nombre=prel
Boton=6
NombreDesplegar=&Preliminar
EnBarraAcciones=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
ConCondicion=S
EjecucionConError=S
Visible=S
NombreEnBoton=S
EnBarraHerramientas=S
GuardarAntes=S
EjecucionCondicion=condatos(Mavi.Sucursal)
EjecucionMensaje=<T>Seleccionar una Sucursal<T>
[Acciones.cer]
Nombre=cer
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


