
[Forma]
Clave=RM1184ConfiguracionRepVentasMXFrm
Icono=402
Modulos=(Todos)
Nombre=Reporte Ventas Mx

ListaCarpetas=RM1184Configuracion
CarpetaPrincipal=RM1184Configuracion
PosicionInicialIzquierda=425
PosicionInicialArriba=418
PosicionInicialAlturaCliente=150
PosicionInicialAncho=430




PosicionSec1=104
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Mavi.RM1184FechaInicial,Nulo)<BR>Asigna(Mavi.RM1184FechaFinal,Nulo)<BR>Asigna(Mavi.RM1184Sucursal,Nulo)
[RM1184Configuracion]
Estilo=Ficha
Clave=RM1184Configuracion
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S





FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
ListaEnCaptura=Mavi.RM1184FechaInicial<BR>Mavi.RM1184FechaFinal<BR>Mavi.RM1184Sucursal
[Acciones.Preliminar]
Nombre=Preliminar
Boton=108
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S

EspacioPrevio=S
Multiple=S
ListaAccionesMultiples=Asignar<BR>Acepta
[Acciones.Cerrar]
Nombre=Cerrar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


[Acciones.Preliminar.Variables asignar]
Nombre=Variables asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Preliminar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
ConCondicion=S
Visible=S


EjecucionCondicion=Si<BR>    (Vacio(Mavi.RM1184FechaInicial)) o (Vacio(Mavi.RM1184FechaFinal)) o (Vacio(Mavi.RM1184Almacen))<BR>Entonces<BR>    Error(<T>LOS FILTROS DE FECHA INICIAL, FECHA FINAL Y ALMACEN SON OBLIGATORIOS<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin<BR><BR>Si<BR>  Mavi.RM1184FechaInicial > Mavi.RM1184FechaFinal<BR>Entonces<BR>    Error(<T>LA FECHA INICIAL NO PUEDE SER MAYOR A LA FECHA FINAL <T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin
[RM1184Configuracion.Mavi.RM1184FechaInicial]
Carpeta=RM1184Configuracion
Clave=Mavi.RM1184FechaInicial
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[RM1184Configuracion.Mavi.RM1184FechaFinal]
Carpeta=RM1184Configuracion
Clave=Mavi.RM1184FechaFinal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


[MuestraAlmacen.Columnas]
0=-2
1=299

[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Preliminar.Acepta]
Nombre=Acepta
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
ConCondicion=S
Visible=S

EjecucionCondicion=Si<BR>    (Vacio(Mavi.RM1184FechaInicial)) o (Vacio(Mavi.RM1184FechaFinal)) o (Vacio(Mavi.RM1184Sucursal))<BR>Entonces<BR>    Error(<T>LOS FILTROS DE FECHA INICIAL, FECHA FINAL Y SUCURSAL SON OBLIGATORIOS<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin                                                             <BR><BR>Si<BR>  Mavi.RM1184FechaInicial>Mavi.RM1184FechaFinal<BR>Entonces<BR>  Precaucion(<T>LA FECHA INICIAL NO PUEDE SER MAYOR A LA FECHA FINAL<T>)<BR>  AbortarOperacion<BR>Sino<BR>  Verdadero<BR>Fin
[RM1184Configuracion.Mavi.RM1184Sucursal]
Carpeta=RM1184Configuracion
Clave=Mavi.RM1184Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[MuestraSucursal.Columnas]
0=41
1=-2

