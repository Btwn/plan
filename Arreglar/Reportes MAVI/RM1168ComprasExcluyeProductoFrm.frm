
[Forma]
Clave=RM1168ComprasExcluyeProductoFrm
Icono=416
Modulos=(Todos)
Nombre=RM1168ComprasExcluyeProductoFrm

ListaCarpetas=Principal<BR>Excluidos
CarpetaPrincipal=Principal
PosicionInicialAlturaCliente=461
PosicionInicialAncho=566
PosicionInicialIzquierda=278
PosicionInicialArriba=129
PosicionSec1=101
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=AgregaExclusion<BR>GuardaCambios
MovModulo=(Todos)
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Mavi.RM1168Familia,<T><T>)<BR>Asigna(Mavi.RM1168Linea,<T><T>)<BR>Asigna(Mavi.RM1168Articulo,<T><T>)
[Principal]
Estilo=Ficha
Clave=Principal
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
ListaEnCaptura=Mavi.RM1168Articulo<BR>Mavi.RM1168Familia<BR>Mavi.RM1168Linea<BR>Mavi.RM1168TipoAuditoria

PermiteEditar=S
MenuLocal=S



[Lista.Columnas]
Articulo=131
Descripcion1=244
Familia=263
Linea=234

[Excluidos]
Estilo=Hoja
Clave=Excluidos
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
Vista=RM1168ComprasEliminaExclusionVis




ListaEnCaptura=RM1168ComprasEliminaExclusionTbl.Concepto<BR>RM1168ComprasEliminaExclusionTbl.Tipo<BR>RM1168ComprasEliminaExclusionTbl.TipoAuditoria
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
PestanaOtroNombre=S
PestanaNombre=Articulos Actualmente Excluidos
Pestana=S
PermiteEditar=S
[Excluidos.Columnas]
Concepto=309
Tipo=76
AuditoriaDIMAS=85

TipoAuditoria=124
[Acciones.AgregaExclusion]
Nombre=AgregaExclusion
Boton=23
NombreDesplegar=Agregar Exclusion
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S

Multiple=S
ListaAccionesMultiples=Asignar<BR>Expresion
[Principal.Mavi.RM1168TipoAuditoria]
Carpeta=Principal
Clave=Mavi.RM1168TipoAuditoria
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.Guardar]
Nombre=Guardar
Boton=0
NombreDesplegar=Guardar Cambios
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S





[Excluidos.RM1168ComprasEliminaExclusionTbl.Concepto]
Carpeta=Excluidos
Clave=RM1168ComprasEliminaExclusionTbl.Concepto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Excluidos.RM1168ComprasEliminaExclusionTbl.Tipo]
Carpeta=Excluidos
Clave=RM1168ComprasEliminaExclusionTbl.Tipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco


[Acciones.GuardaCambios]
Nombre=GuardaCambios
Boton=3
NombreDesplegar=Guardar Cambios
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S

Multiple=S
ListaAccionesMultiples=Guarda<BR>ActualizaVistas
[Acciones.AgregaExclusion.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.AgregaExclusion.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S

Expresion=Si<BR>    ConDatos(Mavi.RM1168TipoAuditoria)<BR>Entonces<BR><BR>    EjecutarSQL(<T>SPIRM1168_AgregaExclusiones :tArt, :tFam, :tLin, :tOp<T>, Reemplaza(ASCII(39),<T><T>,Mavi.RM1168Articulo), Reemplaza(ASCII(39),<T><T>,Mavi.RM1168Familia),Reemplaza(ASCII(39),<T><T>,Mavi.RM1168Linea),Mavi.RM1168TipoAuditoria)<BR>    ActualizarVista(<T>RM1168ComprasEliminaExclusionVis<T>)<BR>Asigna(Mavi.RM1168Familia,<T><T>)<BR>Asigna(Mavi.RM1168Linea,<T><T>)<BR>Asigna(Mavi.RM1168Articulo,<T><T>)<BR>ActualizarVista(<T>RM1168ComprasTiendaVirtualVisFrm<T>)<BR>ActualizarVista(<T>RM1168ComprasDIMASVisFrm<T>)<BR>Sino<BR>Informacion(<T>Selecciona un tipo de reporte<T>)<BR>Fin
EjecucionCondicion=Si<BR>            ConDatos(Mavi.RM1168Articulo) o ConDatos(Mavi.RM1168Linea) o ConDatos(Mavi.RM1168Familia)<BR>        Entonces<BR>            verdadero<BR>        Sino<BR>            Error(<T>Debes seleccionar al menos un campo para excluir<T>)<BR>                               AbortarOperacion<BR>        Fin
[Acciones.GuardaCambios.Guarda]
Nombre=Guarda
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S


[Acciones.GuardaCambios.ActualizaVistas]
Nombre=ActualizaVistas
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S





Expresion=ActualizarVista(<T>RM1168ComprasTiendaVirtualVisFrm<T>)<BR>ActualizarVista(<T>RM1168ComprasDIMASVisFrm<T>)
[Principal.Mavi.RM1168Articulo]
Carpeta=Principal
Clave=Mavi.RM1168Articulo
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

LineaNueva=S
[Principal.Mavi.RM1168Familia]
Carpeta=Principal
Clave=Mavi.RM1168Familia
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Principal.Mavi.RM1168Linea]
Carpeta=Principal
Clave=Mavi.RM1168Linea
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Principal.Columnas]
Articulo=124
Linea=304
familia=304

Familia=304
0=-2


Descripcion1=604
[fam.Columnas]
0=-2

[Excluidos.RM1168ComprasEliminaExclusionTbl.TipoAuditoria]
Carpeta=Excluidos
Clave=RM1168ComprasEliminaExclusionTbl.TipoAuditoria
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


