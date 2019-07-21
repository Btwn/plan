[Forma]
Clave=DM0102AsignacionPreciosEspFrm
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)<BR>DM0102AsignacionPreciosListaEspVis<BR>DM0102PropreListaEspecialtblTemporal<BR>DatosSinCumplir
CarpetaPrincipal=DM0102PropreListaEspecialtblTemporal
PosicionInicialAlturaCliente=962
PosicionInicialAncho=1296
PosicionInicialIzquierda=-8
PosicionInicialArriba=-8
PosicionSec1=62
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Actua<BR>Guardar<BR>Importar<BR>Excel<BR>Cerrar<BR>Imprimir<BR>Resfrecar
Menus=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
PosicionSec2=448
PosicionCol3=646
ExpresionesAlMostrar=Asigna( Mavi.DM0102Buscador,nulo )
ExpresionesAlCerrar=EJECUTARSQL(<T>EXEC dbo.SPCXcAsignacioPrecio :nOpcion<T>,2)
VentanaExclusiva=S
VentanaExclusivaOpcion=3
[DM0102AsignacionPreciosListaEspVis]
Estilo=Hoja
Clave=DM0102AsignacionPreciosListaEspVis
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=DM0102AsignacionPreciosListaEspVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Articulo<BR>Descripcion1<BR>PrecioAsignado<BR>Fecha<BR>Usuario1<BR>EstacionTrabajoMod<BR>Disponible<BR>Almacen
CarpetaVisible=S
MenuLocal=S
ListaAcciones=pRE<BR>Hist
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
FiltroGeneral=Grupo=<T>MERCANCIA ESPECIAL<T><BR>{Si(condatos(Mavi.DM0102Buscador),<T><T>,Si(Mavi.DM0102PrecioAsignado=<T>Si<T>,<T>And PrecioAsignado >0 <T>,<T>And (PrecioAsignado <=0 or PrecioAsignado is null) <T>))}<BR>{Si(Mavi.DM0102DiasTrans>0 ,<T>And datediff(dd,Fecha, getdate()) >=<T>+Mavi.DM0102DiasTrans,<T> <T>)}<BR>{Si(condatos(Mavi.DM0102Buscador),<T><T>,Si(Mavi.DM0102Existencia=<T>Si<T> ,<T>And Disponible >0 <T>,<T>And (Disponible <=0 or  Disponible is null) <T>))}<BR>{Si(condatos(Mavi.DM0102LineaArtEsp),<T> and Linea=<T>+comillas(Mavi.DM0102LineaArtEsp),<T><T>)}<BR>{Si(condatos(Mavi.DM0102FamArtEsp),<T> and Familia=<T>+comillas(Mavi.DM0102FamArtEsp),<T><T>)}<BR>{Si(condatos(Mavi.DM0102Almacen),<T> and Almacen=<T>+comillas(Mavi.DM0102Almacen),<T><T>)}<BR>{Si(condatos(Mavi.DM0102Categoria),<T> and Categoria=<T>+comillas(Mavi.DM0102Categoria),<T><T>)}<BR>{Si(condatos(Mavi.DM0102Buscador),<T> and Articulo=<T>+comillas(Mavi.DM0102Buscador),<T><T>)}
[DM0102AsignacionPreciosListaEspVis.Articulo]
Carpeta=DM0102AsignacionPreciosListaEspVis
Clave=Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[DM0102AsignacionPreciosListaEspVis.Descripcion1]
Carpeta=DM0102AsignacionPreciosListaEspVis
Clave=Descripcion1
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[DM0102AsignacionPreciosListaEspVis.Columnas]
Articulo=124
Descripcion1=481
Grupo=304
Categoria=304
Estatus=94
UltimoCambio=94
Usuario=64
Articulo_1=124
PrecioAsignado=81
Fecha=130
Usuario_1=64
EstacionTrabajoMod=101
Disponible=64
Almacen=64
Usuario1=64
[DM0102AsignacionPreciosListaEspVis.PrecioAsignado]
Carpeta=DM0102AsignacionPreciosListaEspVis
Clave=PrecioAsignado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
[DM0102AsignacionPreciosListaEspVis.Fecha]
Carpeta=DM0102AsignacionPreciosListaEspVis
Clave=Fecha
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
[DM0102AsignacionPreciosListaEspVis.EstacionTrabajoMod]
Carpeta=DM0102AsignacionPreciosListaEspVis
Clave=EstacionTrabajoMod
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
[DM0102AsignacionPreciosListaEspVis.Disponible]
Carpeta=DM0102AsignacionPreciosListaEspVis
Clave=Disponible
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
[DM0102AsignacionPreciosListaEspVis.Almacen]
Carpeta=DM0102AsignacionPreciosListaEspVis
Clave=Almacen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
[Acciones.pRE]
Nombre=pRE
Boton=0
NombreDesplegar=&Asignar Precio
Multiple=S
EnMenu=S
ListaAccionesMultiples=Actualizar
UsaTeclaRapida=S
TeclaRapida=F11


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
ListaEnCaptura=Mavi.DM0102DiasTrans<BR>Mavi.DM0102Existencia<BR>Mavi.DM0102PrecioAsignado<BR>Mavi.DM0102FamArtEsp<BR>Mavi.DM0102LineaArtEsp<BR>Mavi.DM0102Almacen<BR>Mavi.DM0102Categoria<BR>Mavi.DM0102Buscador
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
[(Variables).Mavi.DM0102DiasTrans]
Carpeta=(Variables)
Clave=Mavi.DM0102DiasTrans
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[(Variables).Mavi.DM0102Existencia]
Carpeta=(Variables)
Clave=Mavi.DM0102Existencia
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[(Variables).Mavi.DM0102PrecioAsignado]
Carpeta=(Variables)
Clave=Mavi.DM0102PrecioAsignado
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[(Variables).Mavi.DM0102FamArtEsp]
Carpeta=(Variables)
Clave=Mavi.DM0102FamArtEsp
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
[(Variables).Mavi.DM0102LineaArtEsp]
Carpeta=(Variables)
Clave=Mavi.DM0102LineaArtEsp
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[(Variables).Mavi.DM0102Almacen]
Carpeta=(Variables)
Clave=Mavi.DM0102Almacen
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[(Variables).Mavi.DM0102Categoria]
Carpeta=(Variables)
Clave=Mavi.DM0102Categoria
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[DM0102AsignacionPreciosListaEspVis.Usuario1]
Carpeta=DM0102AsignacionPreciosListaEspVis
Clave=Usuario1
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
[Acciones.Fil.asig]
Nombre=asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Fil.act]
Nombre=act
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Actua]
Nombre=Actua
Boton=82
NombreEnBoton=S
NombreDesplegar=&Actualizar_F5
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=asi<BR>Expresion<BR>actuali<BR>Nulo
Activo=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=F5
TeclaFuncion=F5
EnMenu=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
UsaTeclaRapida=S
TeclaRapida=F6
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
EspacioPrevio=S
[Acciones.Actua.asi]
Nombre=asi
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
[Acciones.Actua.actuali]
Nombre=actuali
Boton=0
TipoAccion=Expresion
Expresion=Forma.ActualizarVista(<T>DM0102AsignacionPreciosListaEspVis<T>)
[Acciones.Hist]
Nombre=Hist
Boton=0
UsaTeclaRapida=S
TeclaRapida=F12
NombreDesplegar=&Histórico de Precios
EnMenu=S
TipoAccion=Formas
ClaveAccion=DM0102HistoricodePreciosFrm
Activo=S
Antes=S
Visible=S
TeclaFuncion=F12
AntesExpresiones=Asigna(Info.Articulo,DM0102AsignacionPreciosListaEspVis:Articulo)<BR>Asigna(Info.Almacen,DM0102AsignacionPreciosListaEspVis:Almacen)
[Acciones.Excel]
Nombre=Excel
Boton=115
NombreEnBoton=S
NombreDesplegar=&Enviar a Excel
EnBarraHerramientas=S
EnMenu=S
Carpeta=DM0102AsignacionPreciosListaEspVis
TipoAccion=Controles Captura
ClaveAccion=Enviar a Excel
Activo=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=F10
TeclaFuncion=F10
EspacioPrevio=S



[Acciones.Imprimir.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Imprimir.Imprimir]
Nombre=Imprimir
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=DM0102AsignaPreciosEspecialesRepImp
Activo=S
Visible=S

[Acciones.Imprimir]
Nombre=Imprimir
Boton=4
NombreEnBoton=S
NombreDesplegar=&Imprimir
Multiple=S
EnBarraHerramientas=S
EnMenu=S
EspacioPrevio=S
ListaAccionesMultiples=Asignar<BR>Imprimir

Activo=S
Visible=S
[Acciones.Imprimir.ListaAccionesMultiples]
(Inicio)=Asignar
Asignar=Imprimir
Imprimir=(Fin)

[Acciones.pRE.ListaAccionesMultiples]
(Inicio)=FRM
FRM=ASI
ASI=(Fin)

[DM0102AsignacionPreciosListaEspVis.ListaEnCaptura]
(Inicio)=Articulo
Articulo=Descripcion1
Descripcion1=PrecioAsignado
PrecioAsignado=Fecha
Fecha=Usuario1
Usuario1=EstacionTrabajoMod
EstacionTrabajoMod=Disponible
Disponible=Almacen
Almacen=(Fin)

[DM0102AsignacionPreciosListaEspVis.ListaAcciones]
(Inicio)=pRE
pRE=Hist
Hist=(Fin)





[Forma.ListaCarpetas]
(Inicio)=(Variables)
(Variables)=DM0102AsignacionPreciosListaEspVis
DM0102AsignacionPreciosListaEspVis=(Fin)

[Forma.ListaAcciones]
(Inicio)=Actua
Actua=Excel
Excel=Cerrar
Cerrar=Imprimir
Imprimir=(Fin)

[(Variables).Mavi.DM0102Buscador]
Carpeta=(Variables)
Clave=Mavi.DM0102Buscador
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Vista.Columnas]
Articulo=124


[DM0102AlmacenesVis.Columnas]
Almacen=99

[Acciones.Actua.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Si<BR>  condatos(Mavi.DM0102Buscador)<BR>Entonces<BR>  Asigna( Mavi.DM0102DiasTrans, nulo )<BR>  Asigna( Mavi.DM0102Existencia, nulo )<BR>  Asigna( Mavi.DM0102PrecioAsignado, nulo )<BR>  Asigna( Mavi.DM0102FamArtEsp, nulo )<BR>  Asigna( Mavi.DM0102Almacen, nulo )<BR>  Asigna( Mavi.DM0102Categoria, nulo )<BR>  Asigna( Mavi.DM0102LineaArtEsp, nulo )<BR>Fin
[Acciones.Actua.Nulo]
Nombre=Nulo
Boton=0
TipoAccion=expresion
Activo=S
Visible=S

Expresion=Si<BR>ConDatos(Mavi.DM0102Buscador)<BR>Entonces<BR>  Asigna( Mavi.DM0102Buscador, nulo )<BR>Fin
[Acciones.Importar]
Nombre=Importar
Boton=115
NombreEnBoton=S
NombreDesplegar=&Importar Excel
EnBarraHerramientas=S
EnMenu=S
Activo=S
Visible=S
Multiple=S

ListaAccionesMultiples=Enviar/RecibirExcel
[Acciones.Importar.Enviar/RecibirExcel]
Nombre=Enviar/RecibirExcel
Boton=0
Activo=S
Visible=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Enviar/Recibir Excel


[Acciones.GuardarDatos.RegistroSiguiente]
Nombre=RegistroSiguiente
Boton=0
Activo=S
Visible=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Siguiente

[Acciones.GuardarDatos.GuardarCambios]
Nombre=GuardarCambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S



[DM0102PropreListaEspecialtblTemporal]
Estilo=Hoja
Clave=DM0102PropreListaEspecialtblTemporal
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=C1
Vista=DM0102PropreListaEspecialtblTemporalVits
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
ListaEnCaptura=CXCDDM0102PropreListaEspecialtblTemporal.Articulo<BR>CXCDDM0102PropreListaEspecialtblTemporal.PrecioAsignado<BR>CXCDDM0102PropreListaEspecialtblTemporal.Almacen
CarpetaVisible=S

PermiteEditar=S
PestanaOtroNombre=S
PestanaNombre=Datos del archivo
Pestana=S
[DM0102PropreListaEspecialtblTemporal.CXCDDM0102PropreListaEspecialtblTemporal.Articulo]
Carpeta=DM0102PropreListaEspecialtblTemporal
Clave=CXCDDM0102PropreListaEspecialtblTemporal.Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[DM0102PropreListaEspecialtblTemporal.CXCDDM0102PropreListaEspecialtblTemporal.PrecioAsignado]
Carpeta=DM0102PropreListaEspecialtblTemporal
Clave=CXCDDM0102PropreListaEspecialtblTemporal.PrecioAsignado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[DM0102PropreListaEspecialtblTemporal.CXCDDM0102PropreListaEspecialtblTemporal.Almacen]
Carpeta=DM0102PropreListaEspecialtblTemporal
Clave=CXCDDM0102PropreListaEspecialtblTemporal.Almacen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco

[DM0102PropreListaEspecialtblTemporal.Columnas]
Articulo=79
PrecioAsignado=77
Almacen=64

Usuario=64
Spid=64
[Acciones.GuardarDatos.Actulaiza]
Nombre=Actulaiza
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=Forma.ActualizarVista( <T>DM0102PropreListaEspecialtblTemporal<T> )

[Acciones.Guardar.GuardarDatos]
Nombre=GuardarDatos
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Si<BR>  DM0102PropreListaEspecialtblTemporalVits:CXCDDM0102PropreListaEspecialtblTemporal.PrecioAsignado > 0<BR>Entonces<BR>verdadero<BR>Sino<BR>  falso<BR>Fin
EjecucionMensaje=<T>Ingrese un valor mayor a 0<T>
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreDesplegar=&Guardar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=si<BR>GuardarDatos<BR>Expresion
Activo=S
Visible=S
NombreEnBoton=S




[Acciones.Guardar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=expresion
Activo=S
Visible=S

Expresion=EJECUTARSQL(<T>EXEC dbo.SPCXcAsignacioPrecio :nOpcion<T>,1)<BR>Forma.ActualizarVista(<T>DatosSinCumplir<T>)
[DatosSinCumplir]
Estilo=Hoja
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Datos sin cumplir
Clave=DatosSinCumplir
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=C2
Vista=DM0102DatosSinCumplir
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
ListaEnCaptura=Articulo<BR>PrecioAsignado<BR>Almacen
CarpetaVisible=S

[DatosSinCumplir.Articulo]
Carpeta=DatosSinCumplir
Clave=Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[DatosSinCumplir.PrecioAsignado]
Carpeta=DatosSinCumplir
Clave=PrecioAsignado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[DatosSinCumplir.Almacen]
Carpeta=DatosSinCumplir
Clave=Almacen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco

[DatosSinCumplir.Columnas]
Articulo=124
PrecioAsignado=77
Almacen=64



[Acciones.Resfrecar]
Nombre=Resfrecar
Boton=125
NombreDesplegar=&Refrescar_F1
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S

NombreEnBoton=S


UsaTeclaRapida=S
TeclaRapida=F1
Multiple=S
ListaAccionesMultiples=Cancelar<BR>Expresion
[Acciones.Guardar.si]
Nombre=si
Boton=0
Carpeta=(DM0102PropreListaEspecialtblTemporal)
TipoAccion=Controles Captura
ClaveAccion=Registro Siguiente
Activo=S
Visible=S

[Acciones.pRE.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S


Expresion=Asigna( DM0102PropreListaEspecialtblTemporalVits:CXCDDM0102PropreListaEspecialtblTemporal.Articulo,DM0102AsignacionPreciosListaEspVis:Articulo)<BR> Asigna(DM0102PropreListaEspecialtblTemporalVits:CXCDDM0102PropreListaEspecialtblTemporal.PrecioAsignado,DM0102AsignacionPreciosListaEspVis:PrecioAsignado )<BR>Asigna(DM0102PropreListaEspecialtblTemporalVits:CXCDDM0102PropreListaEspecialtblTemporal.Almacen,DM0102AsignacionPreciosListaEspVis:Almacen  )

[Acciones.Resfrecar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=expresion
Expresion=EJECUTARSQL(<T>EXEC dbo.SPCXcAsignacioPrecio :nOpcion<T>,2)<BR>Forma.ActualizarVista( <T>DM0102PropreListaEspecialtblTemporal<T> )<BR>Forma.ActualizarVista( <T>DatosSinCumplir<T> )
Activo=S
Visible=S

[Acciones.Resfrecar.Cancelar]
Nombre=Cancelar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S


