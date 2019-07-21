[Forma]
Clave=CFDConcentrado
Nombre=Comprobantes Asociados
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
ListaCarpetas=CFDConcentrado
CarpetaPrincipal=CFDConcentrado
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>AsociarXML<BR>AsociarSinXML
PosicionInicialIzquierda=302
PosicionInicialArriba=216
PosicionInicialAlturaCliente=296
PosicionInicialAncho=762
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
Comentarios=Lista(Info.Modulo,Info.Mov,Info.MovID)
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna( Info.Visible, SQL(<T>SELECT CAST(ContRelacionarComp as Varchar) FROM MovTipo WHERE Modulo = :tModulo AND Mov = :tMov<T>, Info.Modulo, Info.Mov) )<BR>EjecutarSQL(<T>spListaStBorrar :nEstacion<T>, EstacionTrabajo)
[CFDConcentrado]
Estilo=Hoja
Clave=CFDConcentrado
Filtros=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=CFDConcentrado
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
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
CarpetaVisible=S
ListaEnCaptura=Fecha<BR>RFC<BR>UUID<BR>Monto<BR>Tipo<BR>ID
MenuLocal=S
ListaAcciones=Desasociar
FiltroGeneral=CFDConcentrado.Empresa  = <T>{Empresa}<T> AND CFDConcentrado.Modulo = <T>{Info.Modulo}<T> AND CFDConcentrado.ModuloID = {Info.ID}
[Acciones.Aceptar]
Nombre=Aceptar
Boton=21
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
[Acciones.AsociarXML]
Nombre=AsociarXML
Boton=103
NombreEnBoton=S
NombreDesplegar=&Asociar XML
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Expresion
Activo=S
Expresion=FormaModal(<T>CFDValidoAsociarMov<T>)<BR>ActualizarForma
VisibleCondicion=SQL(<T>SELECT dbo.fnContSatDesplegarAsociarXml(:tModulo,:nID)<T>,Info.Modulo,Info.ID) y Info.Visible = <T>1<T>
[Acciones.AsociarSinXML]
Nombre=AsociarSinXML
Boton=50
NombreEnBoton=S
NombreDesplegar=Asociar &Sin XML
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Expresion
Activo=S
Expresion=FormaModal(<T>ContSATCFDTemp<T>)<BR>ActualizarForma
VisibleCondicion=SQL(<T>SELECT dbo.fnContSatDesplegarAsociarXml(:tModulo,:nID)<T>,Info.Modulo,Info.ID) y Info.Visible = <T>1<T>





[CFDConcentrado.Columnas]
Fecha=109
RFC=127
UUID=315
Monto=64
Tipo=100
[Acciones.Desasociar]
Nombre=Desasociar
Boton=0
NombreDesplegar=Desasociar Documento
EnMenu=S
TipoAccion=Expresion
Visible=S

Expresion=Si<BR>   Precaucion(<T>El documento se desasociará del movimiento. ¿Desea Continuar?<T>, BotonNo, BotonSi ) = BotonSi<BR>Entonces<BR>    Si<BR>        ConDatos(CFDConcentrado:ValidoMovID)<BR>    Entonces<BR>        EjecutarSQL(<T>spDesasociarDocumento :tEmpresa, :tModulo, :nModuloID, :nID <T>, Empresa, CFDConcentrado:Modulo, CFDConcentrado:ModuloID, CFDConcentrado:ValidoMovID )<BR>    Sino<BR>        EjecutarSQL(<T>spDesasociarDocumento :tEmpresa, :tModulo, :nModuloID, :nID, 1<T>, Empresa, CFDConcentrado:Modulo, CFDConcentrado:ModuloID, CFDConcentrado:ID )<BR>    Fin<BR>   Forma.ActualizarVista( <T>CFDConcentrado<T> )<BR>Fin
ActivoCondicion=ConDatos(CFDConcentrado:ModuloID)
[CFDConcentrado.Fecha]
Carpeta=CFDConcentrado
Clave=Fecha
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[CFDConcentrado.RFC]
Carpeta=CFDConcentrado
Clave=RFC
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[CFDConcentrado.UUID]
Carpeta=CFDConcentrado
Clave=UUID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco

[CFDConcentrado.Monto]
Carpeta=CFDConcentrado
Clave=Monto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[CFDConcentrado.Tipo]
Carpeta=CFDConcentrado
Clave=Tipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=7
ColorFondo=Blanco

[CFDConcentrado.ID]
Carpeta=CFDConcentrado
Clave=ID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco

