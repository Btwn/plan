
[Forma]
Clave=ParActualizaComprobante
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
Nombre=Actualizar Comprobantes

ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialAlturaCliente=159
PosicionInicialAncho=320
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Cancelar
PosicionInicialIzquierda=523
PosicionInicialArriba=285
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
ExpresionesAlCerrar=EjecutarSQL(<T>spBorraParametros :nEstacion, :tTabla<T>, EstacionTrabajo, <T>ParActualizaComprobante<T>)
[Lista]
Estilo=Ficha
Clave=Lista
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=ParActualizaComprobante
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=ParActualizaComprobante.FechaD<BR>ParActualizaComprobante.FechaA<BR>ParActualizaComprobante.TipoPoliza
CarpetaVisible=S

FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
FiltroGeneral={<T>ParActualizaComprobante.Empresa = <T>& Comillas(Empresa)}<BR>AND<BR>{<T>ParActualizaComprobante.Estacion = <T>& Comillas(EstacionTrabajo)}
[Lista.ParActualizaComprobante.FechaD]
Carpeta=Lista
Clave=ParActualizaComprobante.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

Tamano=20
[Lista.ParActualizaComprobante.FechaA]
Carpeta=Lista
Clave=ParActualizaComprobante.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

Tamano=20
[Lista.ParActualizaComprobante.TipoPoliza]
Carpeta=Lista
Clave=ParActualizaComprobante.TipoPoliza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Lista.Columnas]
FechaD=94
FechaA=94
TipoPoliza=244

[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S

ListaAccionesMultiples=Expresion<BR>Cerrar
GuardarAntes=S
[Acciones.Cancelar]
Nombre=Cancelar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cancelar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cancelar/Cancelar Cambios
Activo=S
Visible=S

[Acciones.Aceptar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=EjecutarSQL(<T>spActualizaComprobantes :nEstacion<T>, EstacionTrabajo)
[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

