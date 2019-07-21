
[Forma]
Clave=RM1168ComprasAuditoriaDIMASTiendaVirtualFRM
Icono=117
Modulos=(Todos)
Nombre=RM1168 Auditoria DIMAS Tienda Virtual

ListaCarpetas=Principal<BR>DIMAS<BR>TiendaVirtual
CarpetaPrincipal=Principal
PosicionInicialAlturaCliente=477
PosicionInicialAncho=813
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=ReporteDIMAS<BR>ReporteTiendaVirtual<BR>Actualiza<BR>ExcluirProductos<BR>NormaFoto<BR>ReglaExigible
BarraHerramientas=S
PosicionInicialIzquierda=253
PosicionInicialArriba=301
PosicionSec1=192
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
CampoColorFondo=Negro
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata

[DIMAS]
Estilo=Hoja
Pestana=S
Clave=DIMAS
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S


Vista=RM1168ComprasDIMASVis
PestanaOtroNombre=S
PestanaNombre=DIMAS
ListaEnCaptura=Concepto<BR>DepResponsable<BR>exigible<BR>noExigible
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
[TiendaVirtual]
Estilo=Hoja
Pestana=S
PestanaOtroNombre=S
PestanaNombre=TiendaVirtual
Clave=TiendaVirtual
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S

Vista=RM1168ComprasTiendaVirtualVis
ListaEnCaptura=Concepto<BR>DepResponsable<BR>exigible<BR>noExigible




[TiendaVirtual.Concepto]
Carpeta=TiendaVirtual
Clave=Concepto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco


[TiendaVirtual.exigible]
Carpeta=TiendaVirtual
Clave=exigible
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[TiendaVirtual.noExigible]
Carpeta=TiendaVirtual
Clave=noExigible
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[DIMAS.Columnas]
Concepto=304
DepResponsable=167
exigible=64
noExigible=64

DepartamentoResponsable=304
Exigible=64
NoExigible=64
[TiendaVirtual.Columnas]
Concepto=304
DepResponsable=166
exigible=64
noExigible=64

DepartamentoResponsable=304
Exigible=64
NoExigible=64
[Acciones.ReporteDIMAS]
Nombre=ReporteDIMAS
Boton=18
NombreEnBoton=S
NombreDesplegar=Generar Reporte DIMAS
EnBarraAcciones=S
TipoAccion=Reportes Pantalla
Activo=S
Visible=S
EnBarraHerramientas=S

ClaveAccion=RM1168ComprasDIMASRep
Multiple=S
ListaAccionesMultiples=InvocaForma
[Acciones.ReporteTiendaVirtual]
Nombre=ReporteTiendaVirtual
Boton=18
NombreDesplegar=Generar Reporte Virtual
EnBarraHerramientas=S
TipoAccion=Reportes Pantalla
Activo=S
Visible=S
NombreEnBoton=S

ClaveAccion=RM1168ComprasTiendaVirtualRep
EspacioPrevio=S
Multiple=S
ListaAccionesMultiples=InvocaForma
[Acciones.ExcluirProductos]
Nombre=ExcluirProductos
Boton=35
NombreDesplegar=Exclusion de Productos
EnBarraHerramientas=S
TipoAccion=Formas
Activo=S
NombreEnBoton=S

EspacioPrevio=S
ClaveAccion=RM1168ComprasExcluyeProductoFrm
VisibleCondicion=Si<BR>    SQL(<T>SELECT COUNT(*) FROM Usuario U INNER JOIN TablaStD D ON U.ACCESO=D.NOMBRE WHERE D.TablaSt =<T>+Comillas(<T>RM1168ValidaAuditoria<T>) +<T>And U.Estatus=<T>+comillas(<T>Alta<T>) +<T>AND U.Usuario=<T>+Comillas(usuario) +<T> AND D.Valor in(<T>+Comillas(<T>Perfil1<T>)+<T> ,<T>+Comillas(<T>Perfil3<T>)+<T>)<T>)>0<BR>Entonces<BR>    Verdadero<BR>Fin
[Acciones.NormaFoto]
Nombre=NormaFoto
Boton=74
NombreEnBoton=S
NombreDesplegar=Definir Norma de Fotografias
EnBarraHerramientas=S
TipoAccion=Formas
Activo=S
EspacioPrevio=S
ClaveAccion=RM1168ComprasNormaFotografiaFrm


VisibleCondicion=Si<BR>    SQL(<T>SELECT COUNT(*) FROM Usuario U INNER JOIN TablaStD D ON U.ACCESO=D.NOMBRE WHERE D.TablaSt =<T>+Comillas(<T>RM1168ValidaAuditoria<T>) +<T>And U.Estatus=<T>+comillas(<T>Alta<T>) +<T>AND U.Usuario=<T>+Comillas(usuario) +<T> AND D.Valor in(<T>+Comillas(<T>Perfil2<T>)+<T> ,<T>+Comillas(<T>Perfil3<T>)+<T>)<T>)>0<BR>Entonces<BR>    Verdadero<BR>Fin
[Acciones.Actualiza]
Nombre=Actualiza
Boton=125
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

[DIMAS.Concepto]
Carpeta=DIMAS
Clave=Concepto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco


[DIMAS.exigible]
Carpeta=DIMAS
Clave=exigible
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[DIMAS.noExigible]
Carpeta=DIMAS
Clave=noExigible
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco


[DIMAS.DepResponsable]
Carpeta=DIMAS
Clave=DepResponsable
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[TiendaVirtual.DepResponsable]
Carpeta=TiendaVirtual
Clave=DepResponsable
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco


[principal.Columnas]
0=-2

[Acciones.ReporteDIMAS.InvocaForma]
Nombre=InvocaForma
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Asigna(Mavi.RM1168TipoAuditoria,<T>DIMAS<T>)<BR>forma(<T>RM1168COMSFiltroRepComPubFrm<T>)
[Acciones.ReporteTiendaVirtual.InvocaForma]
Nombre=InvocaForma
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Asigna(Mavi.RM1168TipoAuditoria,<T>Tienda Virtual<T>)<BR>forma(<T>RM1168COMSFiltroRepComPubFrm<T>)
[Acciones.ReglaExigible]
Nombre=ReglaExigible
Boton=57
NombreEnBoton=S
NombreDesplegar=&Agregar Regla Exigible
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
EspacioPrevio=S

Expresion=Forma(<T>RM1168COMSReglaExigibleFrm<T>)
[RM1168_ReglaExigible.Columnas]
IdFamilia=241
IdLinea=304
Dias=64

[DM1168ReglaExigibleVis.Columnas]
IdFamilia=604
IdLinea=304
Dias=64

[RM1168ReglaExigibleVis.Columnas]
IdFamilia=604
IdLinea=304
Dias=64

