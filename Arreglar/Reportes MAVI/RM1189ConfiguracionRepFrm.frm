
[Forma]
Clave=RM1189ConfiguracionRepFrm
Icono=403
BarraHerramientas=S
Modulos=(Todos)
Nombre=Analisis de Ventas
AccionesTamanoBoton=15x5
AccionesDerecha=S

ListaAcciones=Preliminar<BR>Cerrar
ListaCarpetas=ConfiguracionRep
CarpetaPrincipal=ConfiguracionRep
PosicionInicialIzquierda=517
PosicionInicialArriba=179
PosicionInicialAlturaCliente=272
PosicionInicialAncho=263
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionCol1=248
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(Mavi.RM1189FechaInicio,Hoy)<BR>Asigna(Mavi.RM1189FechaFin,Hoy)<BR>Asigna(Mavi.RM1189SucursalVenta,NULO)<BR>Asigna(Mavi.RM1189Familia,NULO)<BR>Asigna(Mavi.RM1189Linea,NULO)<BR>Asigna(Mavi.RM1189Ranking,NULO)
[Acciones.Preliminar]
Nombre=Preliminar
Boton=108
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Asignar<BR>Aceptar
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

[ConfiguracionRep]
Estilo=Ficha
PestanaOtroNombre=S
PestanaNombre=Configuracin reporte
Clave=ConfiguracionRep
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S

FichaEspacioEntreLineas=14
FichaEspacioNombres=0
FichaColorFondo=Plata
ListaEnCaptura=Mavi.RM1189FechaInicio<BR>Mavi.RM1189FechaFin<BR>Mavi.RM1189SucursalVenta<BR>Mavi.RM1189Familia<BR>Mavi.RM1189Linea<BR>Mavi.RM1189Ranking
PermiteEditar=S
FichaNombres=Izquierda
FichaAlineacion=Centrado
FichaEspacioNombresAuto=S
[Acciones.Preliminar.Asignar]
Nombre=Asignar
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
Visible=S

ConCondicion=S
EjecucionCondicion=Si<BR>    (Vacio(Mavi.RM1189FechaInicio)) o (Vacio(Mavi.RM1189FechaFin))<BR>Entonces<BR>    Error(<T>LOS FILTROS DE FECHA INICIAL Y FECHA FINAL SON OBLIGATORIOS<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin<BR><BR>Si<BR>  Mavi.RM1189FechaInicio>Mavi.RM1189FechaFin<BR>Entonces<BR>  Precaucion(<T>LA FECHA INICIAL NO PUEDE SER MAYOR A LA FECHA FINAL<T>)<BR>  AbortarOperacion<BR>Sino<BR>  Verdadero<BR>Fin<BR>SI<BR>(Vacio(Mavi.RM1189Ranking))<BR>Entonces<BR>  Error(<T>El campo ranking no puede dejarse vacio<T>)<BR>   abortarOperacion<BR> Sino<BR>   Verdadero<BR>Fin<BR><BR>/*<BR>Si (ConDatos(Mavi.RM1189SucursalVenta))<BR>  Entonces<BR>    Si<BR>      SQL(<T>EXEC SpVTASValidacionSucursal :tSuc<T>,Mavi.RM1189SucursalVenta)>0<BR>    Entonces<BR>      Informacion(<T>LA SUCURSAL ELEGIDA DEBE ESTAR CON ESTATUS ALTA Y SER DE TIPO PISO<T>)<BR>      AbortarOperacion<BR>    Sino<BR>      Verdadero<BR>    Fin<BR>       Si<BR>        SQL(<T>EXEC SpVTASValidacionSucursal :tSuc<T>,Mavi.RM1189SucursalVenta)<0<BR>      Entonces<BR>        Informacion(<T>EL FILTRO DE SUCURSAL NO PERMITE LETRAS<T>)<BR>        AbortarOperacion<BR>      Sino<BR>        Verdadero<BR>      Fin<BR>Sino<BR>    Verdadero<BR>Fin<BR>  */<BR><BR>Si<BR>  SQL(<T>SELECT dbo.FnVTASValidacionNumero (:tCval)<T>,Mavi.RM1189Ranking)=1<BR>Entonces<BR>  Precaucion(<T>LA CASILLA DE RANKING SOLO PERMITE NUMEROS ENTEROS POSITIVOS Y ESTOS DEBEN SER MAYORES A CERO<T>)<BR>  AbortarOperacion<BR>Sino<BR>  Verdadero<BR>Fin
[ConfiguracionRep.Mavi.RM1189FechaInicio]
Carpeta=ConfiguracionRep
Clave=Mavi.RM1189FechaInicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[ConfiguracionRep.Mavi.RM1189FechaFin]
Carpeta=ConfiguracionRep
Clave=Mavi.RM1189FechaFin
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[ConfiguracionRep.Mavi.RM1189SucursalVenta]
Carpeta=ConfiguracionRep
Clave=Mavi.RM1189SucursalVenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[ConfiguracionRep.Mavi.RM1189Familia]
Carpeta=ConfiguracionRep
Clave=Mavi.RM1189Familia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[ConfiguracionRep.Mavi.RM1189Linea]
Carpeta=ConfiguracionRep
Clave=Mavi.RM1189Linea
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[ConfiguracionRep.Mavi.RM1189Ranking]
Carpeta=ConfiguracionRep
Clave=Mavi.RM1189Ranking
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[RM1189Lineas.Columnas]
0=-2

[RM1189familias.Columnas]
0=-2

[MuestraSucursales.Columnas]
0=-2
1=-2






