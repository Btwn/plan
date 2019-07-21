
[Forma]
Clave=CFDValidoAsociarMov
Icono=0
Modulos=(Todos)
Nombre=XML Validos
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S

ListaCarpetas=CFDValido<BR>CFDValidoMov
CarpetaPrincipal=CFDValido
PosicionInicialIzquierda=149
PosicionInicialAlturaCliente=473
PosicionInicialAncho=1068
PosicionInicialArriba=128
ListaAcciones=Expresion<BR>FiltroAsociado<BR>FiltroNoAsociados<BR>FiltroTodos<BR>Excel<BR>ConfugurarColumnas
Comentarios=Lista(Info.Modulo,Info.Mov)
PosicionCol1=772
ExpresionesAlMostrar=Asigna(Info.Filtro,<T> 1 = 1 <T>)<BR>SI Info.Modulo EN(<T>VTAS<T>,<T>CXC<T>) ENTONCES Asigna(Info.Filtro,<T> CFDValido.Modulo IN (<T>+Comillas(<T>CXC<T>)+<T>,<T>+Comillas(<T>VTAS<T>)+<T>)<T>) FIN<BR>SI Info.Modulo EN(<T>CXP<T>,<T>GAS<T>,<T>COMS<T>) ENTONCES Asigna(Info.Filtro,<T> CFDValido.Modulo IN (<T>+Comillas(<T>CXP<T>)+<T>,<T>+Comillas(<T>COMS<T>)+<T>,<T>+Comillas(<T>GAS<T>)+<T>)<T>) FIN<BR>SI Info.Modulo = <T>NOM<T> ENTONCES Asigna(Info.Filtro,<T> CFDValido.Modulo = <T>+Comillas(<T>NOM<T>)) FIN<BR>SI Info.Modulo = <T>CONT<T> ENTONCES Asigna(Info.Filtro,<T> CFDValido.Modulo = CFDValido.Modulo<T>) FIN<BR>SI Info.Modulo = <T>DIN<T><BR>ENTONCES<BR>    SI Info.Clave EN(<T>DIN.CH<T>,<T>DIN.CHE<T>) ENTONCES Asigna(Info.Filtro,<T> CFDValido.Modulo IN (<T>+Comillas(<T>CXP<T>)+<T>,<T>+Comillas(<T>COMS<T>)+<T>,<T>+Comillas(<T>GAS<T>)+<T>)<T>) FIN<BR>    SI Info.Clave EN(<T>DIN.D<T>,<T>DIN.DE<T>) ENTONCES Asigna(Info.Filtro,<T> CFDValido.Modulo IN (<T>+Comillas(<T>VTAS<T>)+<T>,<T>+Comillas(<T>CXC<T>)+<T>)<T>) FIN<BR>FIN<BR><BR>Asigna( Info.Vale, <T>NoAsociados<T>)<BR>EjecutarSQL(<T>spListaStBorrar :nEstacion<T>, EstacionTrabajo)
[CFDValido]
Estilo=Iconos
Clave=CFDValido
Filtros=S
BusquedaRapidaControles=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=CFDValido
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSeleccionMultiple=S
ElementosPorPaginaEsp=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=Múltiple (por Grupos)
FiltroFechas=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasCampo=CFDValido.FechaTimbrado
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
CarpetaVisible=S
IconosSubTitulo=<T>Nombre<T>
ListaEnCaptura=CFDValido.UUID<BR>CFDValido.RFCEmisor<BR>CFDValido.Monto

FiltroGrupo1=CFDValido.Tipo
FiltroValida1=CFDValido.Tipo
FiltroGrupo2=Modulo.Nombre
FiltroValida2=Modulo.Nombre
FiltroMonedas=S
FiltroMonedasCampo=CFDValido.Moneda

FiltroTodo=S
MenuLocal=S
ListaAcciones=Seleccionar Todo<BR>Quitar Seleccion
PestanaOtroNombre=S
PestanaNombre=Archivos
BusquedaRapida=S
BusquedaEnLinea=S
FiltroFechasDefault=Hoy
IconosNombre=CFDValido:CFDValido.Nombre
FiltroGeneral={<T>CFDValido.Empresa = <T>&Comillas(Empresa)&<T> AND<T>}<BR>{Info.Filtro}<BR>{Si Info.Vale = <T>Asociados<T> Entonces <T> AND EXISTS (<T>&<T>SELECT ID FROM CFDValidoMov A WHERE A.ID = CFDValido.ID AND A.Empresa = <T>&Comillas(Empresa)&<T>)<T> Sino <T> <T> Fin}<BR>{Si Info.Vale = <T>NoAsociados<T> Entonces <T> AND NOT EXISTS (<T>&<T>SELECT ID FROM CFDValidoMov A WHERE A.ID =  CFDValido.ID AND A.Empresa = <T>&Comillas(Empresa)&<T>)<T> Sino <T> <T> Fin}
BusquedaRespetarControles=S
[CFDValido.CFDValido.UUID]
Carpeta=CFDValido
Clave=CFDValido.UUID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[CFDValido.CFDValido.RFCEmisor]
Carpeta=CFDValido
Clave=CFDValido.RFCEmisor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[CFDValido.CFDValido.Monto]
Carpeta=CFDValido
Clave=CFDValido.Monto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[CFDValido.Columnas]
0=165
1=228
2=123
3=94


4=88
5=100
[Acciones.Seleccionar Todo]
Nombre=Seleccionar Todo
Boton=0
NombreDesplegar=Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.Quitar Seleccion]
Nombre=Quitar Seleccion
Boton=0
NombreDesplegar=Quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S





[Acciones.Expresion.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Si<BR>  CuantosSeleccionID(<T>CFDValido<T>) > 0<BR>Entonces<BR>  RegistrarSeleccionID(<T>CFDValido<T>)<BR>  Asigna(Info.Descripcion, SQL(<T>spValidaImporteSAT :nEstacion, :tModulo, :tEmpresa, 2, :tMov, :tMovID, :nID <T>, EstacionTrabajo, Info.Modulo, Empresa, Info.Mov, Info.MovID, Info.ID ))<BR>  Si<BR>    (Info.Descripcion <> <T><T>) y (Info.Descripcion <> Nulo)   <BR>  Entonces<BR>    Informacion(Info.Descripcion)<BR>  Fin<BR><BR>  Informacion(SQL(<T>spContSatAsociarRegistro :nEstacion, :nID, :tEmpresa, :tModulo, :tMov, :tMovID, :tUsuario,:tEstatus<T>,  EstacionTrabajo, Info.ID,Empresa, Info.Modulo, Info.Mov, Info.MovID,Usuario,Info.Estatus))<BR><BR>Fin
[Acciones.Expresion.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

[Acciones.Expresion]
Nombre=Expresion
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
GuardarAntes=S
Multiple=S
EnBarraHerramientas=S
TipoAccion=Expresion
ListaAccionesMultiples=Expresion<BR>Aceptar

Visible=S












Activo=S
[Acciones.FiltroAsociado]
Nombre=FiltroAsociado
Boton=71
NombreEnBoton=S
NombreDesplegar=&Asociados
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Antes=S
Visible=S








ActivoCondicion=Info.Vale <> <T>Asociados<T>
AntesExpresiones=Asigna( Info.Vale,<T>Asociados<T>)
[Acciones.FiltroNoAsociados]
Nombre=FiltroNoAsociados
Boton=71
NombreEnBoton=S
NombreDesplegar=&No Asociados
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Antes=S
Visible=S
ActivoCondicion=Info.Vale <> <T>NoAsociados<T>
AntesExpresiones=Asigna( Info.Vale ,<T>NoAsociados<T>)




[Acciones.FiltroTodos]
Nombre=FiltroTodos
Boton=71
NombreEnBoton=S
NombreDesplegar=&Todos
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma

























































Antes=S



























































ActivoCondicion=Info.Vale <> <T>Todos<T>
AntesExpresiones=Asigna( Info.Vale, <T>Todos<T> )








[CFDValido.ListaEnCaptura]
(Inicio)=CFDValido.UUID
CFDValido.UUID=CFDValido.RFCEmisor
CFDValido.RFCEmisor=CFDValido.Monto
CFDValido.Monto=CFDValidoMov.Movimiento
CFDValidoMov.Movimiento=CFDValidoMov.MovID
CFDValidoMov.MovID=(Fin)

[CFDValido.ListaAcciones]
(Inicio)=Seleccionar Todo
Seleccionar Todo=Quitar Seleccion
Quitar Seleccion=(Fin)


[Acciones.Expresion.ListaAccionesMultiples]
(Inicio)=Expresion
Expresion=Aceptar
Aceptar=(Fin)

[Forma.ListaAcciones]
(Inicio)=Expresion
Expresion=FiltroAsociado
FiltroAsociado=FiltroNoAsociados
FiltroNoAsociados=FiltroTodos
FiltroTodos=(Fin)

[CFDValidoMov]
Estilo=Hoja
Clave=CFDValidoMov
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A2
Vista=CFDValidoMov
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
ListaEnCaptura=CFDValidoMov.Movimiento<BR>CFDValidoMov.MovID
CarpetaVisible=S

Detalle=S
VistaMaestra=CFDValido
LlaveLocal=CFDValidoMov.ID<BR>CFDValidoMov.Empresa
LlaveMaestra=CFDValido.ID<BR>CFDValido.Empresa
BusquedaRapidaControles=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
[CFDValidoMov.CFDValidoMov.Movimiento]
Carpeta=CFDValidoMov
Clave=CFDValidoMov.Movimiento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[CFDValidoMov.CFDValidoMov.MovID]
Carpeta=CFDValidoMov
Clave=CFDValidoMov.MovID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[CFDValidoMov.Columnas]
Movimiento=110
MovID=78
[Acciones.Excel]
Nombre=Excel
Boton=67
NombreEnBoton=S
NombreDesplegar=Enviar a E&xcel
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Enviar a Excel
Activo=S
Visible=S
[Acciones.ConfugurarColumnas]
Nombre=ConfugurarColumnas
Boton=45
NombreDesplegar=Personalizar Vista
EnBarraHerramientas=S
EspacioPrevio=S
Carpeta=CFDValido
TipoAccion=Controles Captura
ClaveAccion=Mostrar Campos
Activo=S
Visible=S

