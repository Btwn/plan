
[Forma]
Clave=RM1168COMSReglaExigibleFrm
Icono=62
Modulos=(Todos)
Nombre=Regla Exigible Familia-Linea

ListaCarpetas=ExigibleLineaFamilia<BR>RM1168ReglaExigibleVis
CarpetaPrincipal=ExigibleLineaFamilia
PosicionInicialIzquierda=165
PosicionInicialArriba=0
PosicionInicialAlturaCliente=691
PosicionInicialAncho=1076
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Eliminar
BarraHerramientas=S
PosicionSec1=192
[ExigibleLineaFamilia]
Estilo=Ficha
Clave=ExigibleLineaFamilia
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM1168Familia<BR>Mavi.RM1168Linea<BR>Mavi.RM1168ExigibleDias
CarpetaVisible=S

PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata




[ExigibleLineaFamilia.Mavi.RM1168Linea]
Carpeta=ExigibleLineaFamilia
Clave=Mavi.RM1168Linea
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco

[principal.Columnas]
0=-2

[Acciones.Guardar.Capturar]
Nombre=Capturar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S

[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar Regla
Multiple=S
EnBarraAcciones=S
ListaAccionesMultiples=Capturar<BR>Validar
Activo=S
Visible=S

EnBarraHerramientas=S
[Acciones.Guardar.Validar]
Nombre=Validar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S





Expresion=Si<BR>  ConDatos(Mavi.RM1168Familia)<BR>  y ConDatos(Mavi.RM1168Linea)<BR>  y ConDatos(Mavi.RM1168ExigibleDias)<BR>Entonces<BR>  EjecutarSQL(<T>EXEC dbo.SpCOMSAgregarReglaExigible :tFamilia, :tLinea, :tDias, :nAccion<T>,Mavi.RM1168Familia,Mavi.RM1168Linea,Mavi.RM1168ExigibleDias,1)<BR>  ActualizarVista(<T>RM1168_ReglaExigible<T>)<BR>  ActualizarForma(<T>RM1168<T>)<BR>  Asigna(Mavi.RM1168Familia,nulo)<BR>  Asigna(Mavi.RM1168Linea,nulo)<BR>  Asigna(Mavi.RM1168ExigibleDias,nulo)<BR>Sino<BR>  Informacion(<T>¡DEBE LLENAR LOS TRES CAMPOS!<T>)<BR>Fin
[ExigibleLineaFamilia.Mavi.RM1168ExigibleDias]
Carpeta=ExigibleLineaFamilia
Clave=Mavi.RM1168ExigibleDias
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco


[ArtFamLinea.Columnas]
Familia=207
Linea=133
Dias=78

[ExigibleLineaFamilia.Mavi.RM1168Familia]
Carpeta=ExigibleLineaFamilia
Clave=Mavi.RM1168Familia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco



[RM1168_ReglaExigible.Columnas]
Familia=604
Linea=304
Dias=64

IdFamilia=241
IdLinea=304


[Acciones.Eliminar]
Nombre=Eliminar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Eliminar Regla
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S

ListaAccionesMultiples=Seleccionar<BR>Capturar<BR>Validar
[Acciones.Eliminar.Capturar]
Nombre=Capturar
Boton=0
TipoAccion=Controles Captura
Activo=S
Visible=S

ClaveAccion=Variables Asignar
[Acciones.Eliminar.Validar]
Nombre=Validar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Si<BR>  ConDatos(Mavi.RM1168Familia)<BR>  y ConDatos(Mavi.RM1168Linea)<BR>  y ConDatos(Mavi.RM1168ExigibleDias)<BR>Entonces<BR>  EjecutarSQL(<T>EXEC dbo.SpCOMSAgregarReglaExigible :tFamilia, :tLinea, :tDias, :nAccion<T>,Mavi.RM1168Familia,Mavi.RM1168Linea,Mavi.RM1168ExigibleDias,2)<BR>  ActualizarVista(<T>RM1168_ReglaExigible<T>)<BR>  ActualizarForma(<T>RM1168<T>)<BR>  Asigna(Mavi.RM1168Familia,nulo)<BR>  Asigna(Mavi.RM1168Linea,nulo)<BR>  Asigna(Mavi.RM1168ExigibleDias,nulo)<BR>Sino<BR>  Informacion(<T>¡DEBE LLENAR LOS TRES CAMPOS!<T>)<BR>Fin
[Acciones.Eliminar2.Capturar]
Nombre=Capturar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S

[Acciones.Eliminar2.Eliminar]
Nombre=Eliminar
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S



[Acciones.Eliminar.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S

[Acciones.Seleccionar.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S

[Acciones.Seleccionar.Registrar]
Nombre=Registrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Seleccionar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Asigna(Mavi.RM1168Familia,RM1168ReglaExigibleVis:RM1168COMSDReglaExigible.IdFamilia)<BR>Asigna(Mavi.RM1168Linea,RM1168ReglaExigibleVis:RM1168COMSDReglaExigible.IdLinea)<BR>Asigna(Mavi.RM1168ExigibleDias,RM1168ReglaExigibleVis:RM1168COMSDReglaExigible.Dias)
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=0
NombreDesplegar=Seleccionar
Multiple=S
EnMenu=S
ListaAccionesMultiples=Seleccionar<BR>Registrar<BR>Asignar
Activo=S
Visible=S









[DM1168ReglaExigible.Columnas]
IdFamilia=604
IdLinea=304
Dias=64





[DM1168ReglaExigibleVis.Columnas]
IdFamilia=604
IdLinea=304
Dias=64

[RM1168ReglaExigibleVis]
Estilo=Hoja
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Reglas Actuales de Exigibilidad
Clave=RM1168ReglaExigibleVis
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=RM1168ReglaExigibleVis
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
ListaEnCaptura=RM1168COMSDReglaExigible.IdFamilia<BR>RM1168COMSDReglaExigible.IdLinea<BR>RM1168COMSDReglaExigible.Dias
ListaAcciones=Seleccionar
CarpetaVisible=S




[RM1168ReglaExigibleVis.Columnas]
IdFamilia=604
IdLinea=304
Dias=64

[RM1168ReglaExigibleVis.RM1168COMSDReglaExigible.IdFamilia]
Carpeta=RM1168ReglaExigibleVis
Clave=RM1168COMSDReglaExigible.IdFamilia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[RM1168ReglaExigibleVis.RM1168COMSDReglaExigible.IdLinea]
Carpeta=RM1168ReglaExigibleVis
Clave=RM1168COMSDReglaExigible.IdLinea
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[RM1168ReglaExigibleVis.RM1168COMSDReglaExigible.Dias]
Carpeta=RM1168ReglaExigibleVis
Clave=RM1168COMSDReglaExigible.Dias
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

