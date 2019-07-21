[Forma]
Clave=CteCtoListaMAVI
Nombre=Contactos del Clientes
Icono=44
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialIzquierda=356
PosicionInicialArriba=271
PosicionInicialAlturaCliente=443
PosicionInicialAncho=568
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
Comentarios=Info.Cliente
[Lista]
Estilo=Iconos
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=CteCto
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Nombre<T>
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
MenuLocal=S
ListaAcciones=Personalizar
ListaEnCaptura=CteCto.ApellidoPaterno<BR>CteCto.ApellidoMaterno<BR>CteCto.ID
IconosNombre=CteCto:CteCto.Nombre
FiltroGeneral=CteCto.Cliente=<T>{Info.Cliente}<T> AND CteCto.Tipo = <T>AVAL<T>
[Lista.Columnas]
0=470
1=-2
2=-2
3=-2
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
[Acciones.Personalizar]
Nombre=Personalizar
Boton=0
NombreDesplegar=Personalizar Vista
EnMenu=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Mostrar Campos
Activo=S
Visible=S
[Lista.CteCto.ApellidoPaterno]
Carpeta=Lista
Clave=CteCto.ApellidoPaterno
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[Lista.CteCto.ApellidoMaterno]
Carpeta=Lista
Clave=CteCto.ApellidoMaterno
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[Lista.CteCto.ID]
Carpeta=Lista
Clave=CteCto.ID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

