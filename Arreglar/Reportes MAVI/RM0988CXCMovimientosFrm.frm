[Forma]
Clave=RM0988CXCMovimientosFrm
Nombre=RM0988 Listado Movimientos
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=184
PosicionInicialAncho=353
PosicionSec1=90
PosicionInicialIzquierda=541
PosicionInicialArriba=382
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=RM0988CXCMovimientosRepImp<BR>RM0988
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=asigna(Mavi.RM0988FechaA,nulo)<BR>asigna(Mavi.RM0988FechaD,nulo)<BR>asigna(Mavi.RM0988Financiamiento,nulo)<BR>asigna(Mavi.RM0988Movimiento,nulo)<BR>asigna(Mavi.RM0988Concepto,nulo)<BR>asigna(Mavi.RM0988Categoria,nulo)
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
ListaEnCaptura=Mavi.RM0988Movimiento<BR>Mavi.RM0988Categoria<BR>Mavi.RM0988FechaD<BR>Mavi.RM0988FechaA<BR>Mavi.RM0988Concepto
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PestanaOtroNombre=S
PestanaNombre=Filtros
[(Variables).Mavi.RM0988Movimiento]
Carpeta=(Variables)
Clave=Mavi.RM0988Movimiento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables2).Mavi.RM0988Financiamiento]
Carpeta=(Variables2)
Clave=Mavi.RM0988Financiamiento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables2).Mavi.RM0988Categoria]
Carpeta=(Variables2)
Clave=Mavi.RM0988Categoria
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables2).Mavi.RM0988Concepto]
Carpeta=(Variables2)
Clave=Mavi.RM0988Concepto
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables2).Mavi.RM0988FechaA]
Carpeta=(Variables2)
Clave=Mavi.RM0988FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables2).Mavi.RM0988FechaD]
Carpeta=(Variables2)
Clave=Mavi.RM0988FechaD
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables3).Mavi.RM0988Categoria]
Carpeta=(Variables3)
Clave=Mavi.RM0988Categoria
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables3).Mavi.RM0988Concepto]
Carpeta=(Variables3)
Clave=Mavi.RM0988Concepto
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables3).Mavi.RM0988FechaA]
Carpeta=(Variables3)
Clave=Mavi.RM0988FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables3).Mavi.RM0988FechaD]
Carpeta=(Variables3)
Clave=Mavi.RM0988FechaD
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0988Categoria]
Carpeta=(Variables)
Clave=Mavi.RM0988Categoria
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0988Concepto]
Carpeta=(Variables)
Clave=Mavi.RM0988Concepto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0988FechaA]
Carpeta=(Variables)
Clave=Mavi.RM0988FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0988FechaD]
Carpeta=(Variables)
Clave=Mavi.RM0988FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Generar.asignar]
Nombre=asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Generar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=condatos(Mavi.RM0988FechaA) y condatos(Mavi.RM0988FechaD)<BR>/*y<BR>(si<BR>    ((SQL( <T>EXEC dbo.Sp_MaviRM0988ValidaPrestamo :tMovimiento<T>, Mavi.RM0988Movimiento ))=0 y (vacio(Mavi.RM0988Financiamiento)))<BR>Entonces<BR>    verdadero<BR>sino<BR>    si<BR>        ((SQL( <T>EXEC dbo.Sp_MaviRM0988ValidaPrestamo :tMovimiento<T>, Mavi.RM0988Movimiento ))=1 y (condatos(Mavi.RM0988Financiamiento)))<BR>    entonces<BR>        verdadero<BR>    sino<BR>        falso<BR>    fin<BR>fin)<BR>*/
EjecucionMensaje=<T>Debe incluir un rango de Fecha<T>
[Acciones.Expresion.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Expresion.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=//informacion((SQL( <T>EXEC dbo.Sp_MaviRM0988ValidaPrestamo :tMovimiento<T>, Mavi.RM0988Movimiento ))=0 y (vacio(Mavi.RM0988Financiamiento)))<BR>//informacion((SQL( <T>EXEC dbo.Sp_MaviRM0988ValidaPrestamo :tMovimiento<T>, Mavi.RM0988Movimiento ))=1 y (condatos(Mavi.RM0988Financiamiento)))<BR>si<BR>    ((SQL( <T>EXEC dbo.Sp_MaviRM0988ValidaPrestamo :tMovimiento<T>, Mavi.RM0988Movimiento ))=0 y (vacio(Mavi.RM0988Financiamiento)))<BR>Entonces<BR>    verdadero<BR>sino<BR>    si<BR>        ((SQL( <T>EXEC dbo.Sp_MaviRM0988ValidaPrestamo :tMovimiento<T>, Mavi.RM0988Movimiento ))=1 y (condatos(Mavi.RM0988Financiamiento)))<BR>    entonces<BR>        verdadero<BR>    sino<BR>        falso<BR>    fin<BR>fin
[Acciones.RM0988CXCMovimientosRepImp]
Nombre=RM0988CXCMovimientosRepImp
Boton=55
NombreEnBoton=S
NombreDesplegar=Generar &Txt
EnBarraHerramientas=S
TipoAccion=Reportes Impresora
ClaveAccion=RM0988CXCMovimientosRepImp
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>RM0988CXCMovimientosRepImp
[Acciones.RM0988CXCMovimientosRepImp.RM0988CXCMovimientosRepImp]
Nombre=RM0988CXCMovimientosRepImp
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM0988CXCMovimientosRepImp
Activo=S
Visible=S
[Acciones.RM0988CXCMovimientosRepImp.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.RM0988]
Nombre=RM0988
Boton=55
NombreEnBoton=S
NombreDesplegar=Generar &Nvo
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=RM0988ListadoMovimientosFrm
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>Listado
[Vista.Columnas]
0=185

[Acciones.RM0988.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.RM0988.Listado]
Nombre=Listado
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM0988ListadoMovimientosRepImp
Activo=S
Visible=S


