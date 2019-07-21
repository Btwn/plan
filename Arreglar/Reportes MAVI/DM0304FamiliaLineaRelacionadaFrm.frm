[Forma]
Clave=DM0304FamiliaLineaRelacionadaFrm
Nombre=Familia Linea Relacionada
Icono=0
Modulos=(Todos)
ListaCarpetas=VistaPrincipal<BR>VistaCascaron<BR>(Variables)
CarpetaPrincipal=VistaPrincipal
PosicionInicialAlturaCliente=757
PosicionInicialAncho=1114
PosicionInicialIzquierda=83
PosicionInicialArriba=111
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Actualizar<BR>Guardar<BR>Refrescar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionSec1=118
PosicionSec2=184
VentanaBloquearAjuste=S
ExpresionesAlMostrar=EjecutarSQL(<T>EXEC SP_DM0304LineasRelacion :nOpc<T>,1)<BR>Asigna(Mavi.DM0304LineasBuscarArt,<T><T>)<BR>Asigna(Mavi.DM0304FamiliaBuscarArt,<T><T>)
[DM0304ActualizarFrm.Columnas]
ID=74
Familia=354
Linea=251
FamiliaRelacionada=263
LineaRelacionada=296
Cantidad=74
0=-2
1=-2
2=-2
3=-2
4=-2
[Actualizar.Columnas]
ID=74
Familia=354
Linea=354
FamiliaRelacionada=354
LineaRelacionada=354
Cantidad=74
[Acciones.Actualizar]
Nombre=Actualizar
Boton=95
NombreEnBoton=S
NombreDesplegar=Actualizar
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Guardar<BR>Expresion<BR>Actualizar
[VistaCascaron]
Estilo=Ficha
Clave=VistaCascaron
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0304LineasRelacionVis
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DM0304LineasRelacionTbl.Familia<BR>DM0304LineasRelacionTbl.Linea<BR>DM0304LineasRelacionTbl.FamiliaRelacionada<BR>DM0304LineasRelacionTbl.LineaRelacionada<BR>DM0304LineasRelacionTbl.Cantidad
CarpetaVisible=S
PermiteEditar=S
[VistaCascaron.DM0304LineasRelacionTbl.Familia]
Carpeta=VistaCascaron
Clave=DM0304LineasRelacionTbl.Familia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[VistaCascaron.DM0304LineasRelacionTbl.Linea]
Carpeta=VistaCascaron
Clave=DM0304LineasRelacionTbl.Linea
Editar=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[VistaCascaron.DM0304LineasRelacionTbl.FamiliaRelacionada]
Carpeta=VistaCascaron
Clave=DM0304LineasRelacionTbl.FamiliaRelacionada
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[VistaCascaron.DM0304LineasRelacionTbl.LineaRelacionada]
Carpeta=VistaCascaron
Clave=DM0304LineasRelacionTbl.LineaRelacionada
Editar=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[VistaCascaron.DM0304LineasRelacionTbl.Cantidad]
Carpeta=VistaCascaron
Clave=DM0304LineasRelacionTbl.Cantidad
Editar=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=15
[VistaPrincipal]
Estilo=Hoja
Clave=VistaPrincipal
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=C1
Vista=DM0304FamiliaBuscarVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
PermiteEditar=S
ListaEnCaptura=DM0304TablaRelacionTbl.Familia<BR>DM0304TablaRelacionTbl.Linea<BR>DM0304TablaRelacionTbl.FamiliaRelacionada<BR>DM0304TablaRelacionTbl.LineaRelacionada<BR>DM0304TablaRelacionTbl.Cantidad
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
MenuLocal=S
ListaAcciones=Eliminar2
[VistaPrincipal.Columnas]
Familia=269
Linea=220
FamiliaRelacionada=226
LineaRelacionada=269
Cantidad=74
0=-2
1=-2
2=-2
3=-2
4=-2
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=Guardar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Guardar<BR>Expresion<BR>Expresion2<BR>Actualizar
[Acciones.Guardar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Guardar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
Expresion=EjecutarSQL(<T>EXEC SP_DM0304LineasRelacion :nOpc<T>,2)
EjecucionCondicion=Si ConDatos(DM0304LineasRelacionVis:DM0304LineasRelacionTbl.Familia) y ConDatos(DM0304LineasRelacionVis:DM0304LineasRelacionTbl.Linea)y ConDatos(DM0304LineasRelacionVis:DM0304LineasRelacionTbl.FamiliaRelacionada) y ConDatos(DM0304LineasRelacionVis:DM0304LineasRelacionTbl.LineaRelacionada) y ConDatos(DM0304LineasRelacionVis:DM0304LineasRelacionTbl.Cantidad)<BR>Entonces<BR> Verdadero<BR>Sino<BR>Error(<T>Algunos campos están vacíos, por favor ingrese información  <T>)<BR> AbortarOperacion<BR><BR>Fin<BR><BR>Asigna(Info.Dialogo,<T><T>)<BR>Asigna(Info.Dialogo,SQL(<T>SELECT dbo.Fn_DM0304FamiliaLineaRelacionada()<T>))<BR><BR>Si<BR>  Info.Dialogo=<T>ERROR 1<T><BR>Entonces         <BR>  ERROR(<T>La cantidad de artículos excede el máximo  permitido<T>)<BR>  AbortarOperacion<BR>Sino<BR>    Si<BR>     <CONTINUA>
EjecucionCondicion002=<CONTINUA>Info.Dialogo=<T>CORRECTO<T><BR>   Entonces<BR>     Informacion(<T>Registro Guardado Correctamente<T>)<BR>     Verdadero<BR>   Fin<BR>Fin<BR><BR>Si<BR>  Info.Dialogo=<T>ERROR 2<T><BR>Entonces<BR>  ERROR(<T>La cantidad debe ser mayor a cero<T>)<BR>  AbortarOperacion<BR>Fin
[Acciones.Guardar.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Eliminar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Eliminar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
Expresion=EjecutarSQL(<T>EXEC SP_DM0304LineasRelacion :nOpc<T>,3)
EjecucionCondicion=Si ConDatos(DM0304LineasRelacionVis:DM0304LineasRelacionTbl.Familia) y ConDatos(DM0304LineasRelacionVis:DM0304LineasRelacionTbl.Linea)y ConDatos(DM0304LineasRelacionVis:DM0304LineasRelacionTbl.FamiliaRelacionada) y ConDatos(DM0304LineasRelacionVis:DM0304LineasRelacionTbl.LineaRelacionada)<BR>Entonces<BR>  Informacion(<T>Eliminación Correcta<T>)<BR> Verdadero<BR>Sino<BR>Error(<T>Algunos campos están vacíos, por favor ingrese información  <T>)<BR> AbortarOperacion<BR>Fin
[Acciones.Eliminar.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Actualizar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Actualizar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=EjecutarSQL(<T>EXEC SP_DM0304LineasRelacion :nOpc<T>,4)
[Acciones.Actualizar.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Guardar.Expresion2]
Nombre=Expresion2
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=EjecutarSQL(<T>EXEC SP_DM0304LineasRelacion :nOpc<T>,1)
[Acciones.Eliminar.Expresion2]
Nombre=Expresion2
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=EjecutarSQL(<T>EXEC SP_DM0304LineasRelacion :nOpc<T>,1)
[VistaPrincipal.DM0304TablaRelacionTbl.Familia]
Carpeta=VistaPrincipal
Clave=DM0304TablaRelacionTbl.Familia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[VistaPrincipal.DM0304TablaRelacionTbl.Linea]
Carpeta=VistaPrincipal
Clave=DM0304TablaRelacionTbl.Linea
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[VistaPrincipal.DM0304TablaRelacionTbl.FamiliaRelacionada]
Carpeta=VistaPrincipal
Clave=DM0304TablaRelacionTbl.FamiliaRelacionada
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[VistaPrincipal.DM0304TablaRelacionTbl.LineaRelacionada]
Carpeta=VistaPrincipal
Clave=DM0304TablaRelacionTbl.LineaRelacionada
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[VistaPrincipal.DM0304TablaRelacionTbl.Cantidad]
Carpeta=VistaPrincipal
Clave=DM0304TablaRelacionTbl.Cantidad
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Eliminar2]
Nombre=Eliminar2
Boton=0
NombreDesplegar=Eliminar
EnMenu=S
Carpeta=VistaPrincipal
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Registro Eliminar<BR>Guardar Cambios<BR>Actualizar Vista
[Acciones.otra.Asig]
Nombre=Asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.otra.refres]
Nombre=refres
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Eliminar2.Registro Eliminar]
Nombre=Registro Eliminar
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S
[Acciones.Eliminar2.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Eliminar2.Actualizar Vista]
Nombre=Actualizar Vista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Refrescar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Registro Cancelar
Carpeta=(Carpeta principal)
[Acciones.Refrescar.Refrez]
Nombre=Refrez
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
[(Variables).Columnas]
Familia=74
Linea=74
[Acciones.Refrescar.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Refrescar]
Nombre=Refrescar
Boton=82
NombreEnBoton=S
NombreDesplegar=Filtrar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=asig<BR>Actualizar
Activo=S
Visible=S
[(Variables)]
Estilo=Ficha
Clave=(Variables)
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
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
ListaEnCaptura=Mavi.DM0304FamiliaBuscarArt<BR>Mavi.DM0304LineasBuscarArt
CarpetaVisible=S
[(Variables).Mavi.DM0304LineasBuscarArt]
Carpeta=(Variables)
Clave=Mavi.DM0304LineasBuscarArt
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Refrescar.asig]
Nombre=asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[(Variables).Mavi.DM0304FamiliaBuscarArt]
Carpeta=(Variables)
Clave=Mavi.DM0304FamiliaBuscarArt
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

