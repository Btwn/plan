[Forma]
Clave=DM0117CrediCteTelFrm
Nombre=Tel�fonos del Cliente
Icono=0
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialIzquierda=334
PosicionInicialArriba=307
PosicionInicialAlturaCliente=372
PosicionInicialAncho=611
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar
Comentarios=Info.Cliente
VentanaTipoMarco=Di�logo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal

[Lista]
Estilo=Hoja
Clave=Lista
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0117CrediCteTelVis
Fuente={Tahoma, 8, Negro, []}
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Autom�tica
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DM0117CrediCteTel.Tipo<BR>DM0117CrediCteTel.lada<BR>DM0117CrediCteTel.Telefono
CarpetaVisible=S
HojaTitulos=S
HojaAjustarColumnas=S
HojaMostrarColumnas=S
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
FiltroGeneral=DM0117CrediCteTel.Cliente=<T>{Anexo.ID}<T>


[Lista.Columnas]
Telefono=227
Cliente=64
Tipo=124
Extencion=53
Lada=41
PedirTono=57
DePreferencia=74

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

[Lista.DM0117CrediCteTel.lada]
Carpeta=Lista
Clave=DM0117CrediCteTel.lada
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Lista.DM0117CrediCteTel.Telefono]
Carpeta=Lista
Clave=DM0117CrediCteTel.Telefono
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[Lista.DM0117CrediCteTel.Tipo]
Carpeta=Lista
Clave=DM0117CrediCteTel.Tipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
