[Forma]
Clave=CFDInvalido
Nombre=Archivos Inválidos
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Borrar<BR>Actualizar<BR>Ingreso<BR>Egreso<BR>Todos
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
PosicionInicialIzquierda=297
PosicionInicialArriba=193
PosicionInicialAlturaCliente=343
PosicionInicialAncho=772
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna( Info.Accion, <T>Todos<T> )<BR>Asigna( Info.Visible,SQL(<T>SELECT PathMultiempresa FROM EmpresaCfgContaSAT<T>))
[Acciones.SeleccionarTodo]
Nombre=SeleccionarTodo
Boton=0
NombreDesplegar=Selecionar Todo
EnMenu=S
TipoAccion=Expresion
Expresion=SeleccionarTodo(Lista)
Activo=S
Visible=S
[Acciones.QuitarSeleccion]
Nombre=QuitarSeleccion
Boton=0
NombreDesplegar=Quitar Selección
EnMenu=S
TipoAccion=Expresion
Expresion=QuitarSeleccion(Lista)
ActivoCondicion=ListaSeleccion(Lista) <> <T><T>
Visible=S
[Acciones.Eliminar.Elimina]
Nombre=Elimina
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion('Lista')<BR>    Si<BR>    Precaucion( <T>El documento seleccionado también se eliminará del equipo ¿Desea continuar?<T>, BotonSi, BotonNo ) = BotonSi<BR>Entonces<BR>    ProcesarSQL(<T>EXEC spBorraInvalidos 0, 0,:nEstacion<T>, EstacionTrabajo)<BR>Sino<BR>    <T><T><BR>Fin
Activo=S
Visible=S
[Acciones.Eliminar.Refresca]
Nombre=Refresca
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
[Acciones.Eliminar]
Nombre=Eliminar
Boton=0
NombreDesplegar=Eliminar
Multiple=S
EnMenu=S
ListaAccionesMultiples=Elimina<BR>Refresca
ActivoCondicion=ListaSeleccion(Lista) <> <T><T>
Visible=S
[Lista]
Estilo=Iconos
Clave=Lista
Filtros=S
OtroOrden=S
MenuLocal=S
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=CFDInvalido
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=Selección
ElementosPorPagina=200
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=CFDInvalido.Ruta<BR>CFDInvalido.Documento<BR>CFDInvalido.Tipo<BR>CFDInvalido.Ok<BR>CFDInvalido.OkRef
ListaOrden=CFDInvalido.ID<TAB>(Acendente)
FiltroPredefinido=S
FiltroGrupo1=CFDInvalido.Tipo
FiltroValida1=CFDInvalido.Tipo
FiltroGrupo2=Modulo.Nombre
FiltroValida2=Modulo.Nombre
FiltroNullNombre=(sin clasificar)
FiltroTodo=S
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=Múltiple (por Grupos)
ListaAcciones=SeleccionarTodo<BR>QuitarSeleccion<BR>Eliminar
CarpetaVisible=S
IconosNombre=CFDInvalido:CFDInvalido.ID
FiltroGeneral=1=1<BR>{Si Info.Accion = <T>Ingresos<T> Entonces <T> AND Tipo = <T>&Comillas(<T>Ingresos<T>) Sino <T><T> Fin}<BR>{Si Info.Accion = <T>Egresos<T> Entonces <T> AND Tipo = <T>&Comillas(<T>Egresos<T>) Sino <T><T> Fin}<BR>{Si Info.Visible = Verdadero Entonces <T> AND Empresa = <T>&Comillas(Empresa) Sino <T><T> Fin }
[Lista.CFDInvalido.Ruta]
Carpeta=Lista
Clave=CFDInvalido.Ruta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco
[Lista.CFDInvalido.Documento]
Carpeta=Lista
Clave=CFDInvalido.Documento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
[Lista.CFDInvalido.Tipo]
Carpeta=Lista
Clave=CFDInvalido.Tipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Lista.CFDInvalido.Ok]
Carpeta=Lista
Clave=CFDInvalido.Ok
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
[Lista.CFDInvalido.OkRef]
Carpeta=Lista
Clave=CFDInvalido.OkRef
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=Cerr&ar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
[Acciones.Borrar.Borrar]
Nombre=Borrar
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion('Lista')<BR>    Si<BR>    Precaucion( <T>El documento seleccionado también se eliminará del equipo ¿Desea continuar?<T>, BotonSi, BotonNo ) = BotonSi<BR>Entonces<BR>    ProcesarSQL(<T>EXEC spBorraInvalidos 0, 0,:nEstacion<T>, EstacionTrabajo)<BR>Sino<BR>    <T><T><BR>Fin
Activo=S
Visible=S
[Acciones.Borrar.Refrescate]
Nombre=Refrescate
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
[Acciones.Borrar]
Nombre=Borrar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Eliminar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Borrar<BR>Refrescate
Activo=S
Visible=S
[Acciones.Actualizar]
Nombre=Actualizar
Boton=82
NombreEnBoton=S
NombreDesplegar=A&ctualizar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
[Acciones.Ingreso]
Nombre=Ingreso
Boton=71
NombreEnBoton=S
NombreDesplegar=&Ingreso
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
ActivoCondicion=Info.Accion <> <T>Ingresos<T>
Antes=S
AntesExpresiones=Asigna( Info.Accion, <T>Ingresos<T> )
Visible=S
[Acciones.Egreso]
Nombre=Egreso
Boton=71
NombreEnBoton=S
NombreDesplegar=E&greso
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
ActivoCondicion=Info.Accion <> <T>Egresos<T>
Antes=S
AntesExpresiones=Asigna( Info.Accion, <T>Egresos<T>)
Visible=S
[Acciones.Todos]
Nombre=Todos
Boton=71
NombreEnBoton=S
NombreDesplegar=&Todos
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
ActivoCondicion=Info.Accion <> <T>Todos<T>
Antes=S
AntesExpresiones=Asigna( Info.Accion, <T>Todos<T> )
Visible=S
[Lista.Columnas]
0=64
1=100
2=100
3=100
4=53
5=100

6=-2


