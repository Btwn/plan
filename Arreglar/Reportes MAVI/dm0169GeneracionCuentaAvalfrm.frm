[Forma]
Clave=dm0169GeneracionCuentaAvalfrm
Nombre=Cuenta a Aval reporte
Icono=0
Modulos=(Todos)
ListaCarpetas=Variables
CarpetaPrincipal=Variables
PosicionInicialIzquierda=523
PosicionInicialArriba=314
PosicionInicialAlturaCliente=232
PosicionInicialAncho=237
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Generar<BR>cerrar
BarraHerramientas=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Info.FechaD, nulo )<BR>Asigna(Info.FechaA, nulo )<BR>Asigna(Info.Usuario, nulo )<BR>Asigna(Info.Sucursal, nulo )<BR>Asigna(Info.FechaD, nulo )<BR>Asigna(Info.Cliente, nulo )
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
ListaEnCaptura=Info.FechaD<BR>Info.FechaA<BR>Info.Usuario<BR>Info.Sucursal<BR>Info.Cliente
PermiteEditar=S
[Variables.Info.FechaA]
Carpeta=Variables
Clave=Info.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Variables.Info.FechaD]
Carpeta=Variables
Clave=Info.FechaD
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Variables.Info.Usuario]
Carpeta=Variables
Clave=Info.Usuario
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Variables.Info.Sucursal]
Carpeta=Variables
Clave=Info.Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Variables.Info.Cliente]
Carpeta=Variables
Clave=Info.Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Generar.Generar]
Nombre=Generar
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Generar.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Generar]
Nombre=Generar
Boton=7
NombreDesplegar=&Generar Reporte
EnBarraAcciones=S
Activo=S
Visible=S
NombreEnBoton=S
EnBarraHerramientas=S
Multiple=S
ListaAccionesMultiples=asign<BR>cerr
[Acciones.cerrar]
Nombre=cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
EnBarraHerramientas=S
[Acciones.Generar.asign]
Nombre=asign
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Generar.cerr]
Nombre=cerr
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=Si (Info.FechaD <= Info.FechaA)<BR>entonces<BR>Verdadero    <BR>Sino<BR>Informacion(<T>Rango Incorrecto de Fechas<T>)<BR>Fin


