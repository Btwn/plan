[Forma]
Clave=CteRelacionScredUnicaja
Nombre=Relación entre ClientesRech
Icono=0
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Todos
PosicionInicialAltura=445
PosicionInicialAncho=859
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=Centrado
PosicionInicialIzquierda=210
PosicionInicialArriba=254
Comentarios=Info.Cliente
PosicionInicialAlturaCliente=418
VentanaAjustarZonas=S
VentanaEscCerrar=S
VentanaRepetir=S
VentanaEstadoInicial=Normal

[Lista]
Estilo=Hoja
Clave=Lista
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=CteRelacionScredUnicaja
Fuente={MS Sans Serif, 8, Negro, []}
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
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=Todo
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
ListaEnCaptura=CteRelacionScredUnicaja.Cliente<BR>Cte.Nombre<BR>CteRelacionScredUnicaja.Relacion<BR>MaviRechazoServicred.nombrecliente
FiltroGeneral=1=1<BR>{Si(ConDatos(Info.Cliente), <T>CteRelacionScredUnicaja.Cliente=<T>+Comillas(Info.Cliente)+<T> OR CteRelacionScredUnicaja.Relacion=<T>+Comillas(Info.Cliente),<T><T>)}



[Acciones.Aceptar]
Nombre=Aceptar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar y cerrar
GuardarAntes=S
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

[Lista.Columnas]
Relacion=97
Nombre=204
Cliente=109
Nombre_1=237
nombrecliente=244



[Acciones.Todos]
Nombre=Todos
Boton=55
NombreEnBoton=S
NombreDesplegar=&Todas las Relaciones
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Antes=S
AntesExpresiones=Asigna(Info.Cliente, Nulo)
VisibleCondicion=ConDatos(Info.Cliente)
[Lista.CteRelacionScredUnicaja.Cliente]
Carpeta=Lista
Clave=CteRelacionScredUnicaja.Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Cte.Nombre]
Carpeta=Lista
Clave=Cte.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Lista.CteRelacionScredUnicaja.Relacion]
Carpeta=Lista
Clave=CteRelacionScredUnicaja.Relacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Lista.MaviRechazoServicred.nombrecliente]
Carpeta=Lista
Clave=MaviRechazoServicred.nombrecliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco
ColorFuente=Negro
