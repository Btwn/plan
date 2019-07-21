
[Forma]
Clave=DM0332Explorador1Frm
Icono=0
Modulos=(Todos)
Nombre=Modificacion de Importes

ListaCarpetas=CFDI De Egresos<BR>Relaciones<BR>Detalle
CarpetaPrincipal=CFDI De Egresos
EsConsultaExclusiva=S
PosicionInicialAlturaCliente=459
PosicionInicialAncho=719
PosicionSec1=217
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
Totalizadores=S
PosicionSec2=394
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Cerrar
PosicionCol2=410
VentanaBloquearAjuste=S
[CFDI De Egresos]
Estilo=Hoja
Pestana=S
Clave=CFDI De Egresos
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0332Explorador1Vis
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
CarpetaVisible=S

PestanaOtroNombre=S
PestanaNombre=CFDI de Egresos
MenuLocal=S
ListaAcciones=Actualizar





ListaEnCaptura=Relaciones<BR>UUID<BR>RFCEmisor<BR>FechaTimbrado<BR>Monto
HojaMantenerSeleccion=S
[Relaciones]
Estilo=Hoja
Pestana=S
Clave=Relaciones
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=DM0332ExploradorRelacion1Vis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DM0332ExploradorRelacionTBL.UUIDRelacionado<BR>DM0332ExploradorRelacionTBL.Importe
CarpetaVisible=S

PestanaOtroNombre=S
PestanaNombre=CFDI Relacionados
MenuLocal=S
ListaAcciones=Detalle
[Relaciones.DM0332ExploradorRelacionTBL.UUIDRelacionado]
Carpeta=Relaciones
Clave=DM0332ExploradorRelacionTBL.UUIDRelacionado
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

Editar=N
[Relaciones.DM0332ExploradorRelacionTBL.Importe]
Carpeta=Relaciones
Clave=DM0332ExploradorRelacionTBL.Importe
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[CFDI De Egresos.Columnas]
Relaciones=64
UUID=276
RFCEmisor=101
FechaTimbrado=123
Importe=64

Monto=64
[Relaciones.Columnas]
UUIDRelacionado=304
Importe=64

[Acciones.Actualizar]
Nombre=Actualizar
Boton=0
NombreDesplegar=Actualizar
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Asigna(Mavi.DM0332UUID,dm0332Explorador1Vis:UUID)<BR>Forma.ActualizarVista(<T>Relaciones<T>)<BR>Forma.ActualizarVista(<T>Detalle<T>)
[CFDI De Egresos.Relaciones]
Carpeta=CFDI De Egresos
Clave=Relaciones
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[CFDI De Egresos.UUID]
Carpeta=CFDI De Egresos
Clave=UUID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[CFDI De Egresos.RFCEmisor]
Carpeta=CFDI De Egresos
Clave=RFCEmisor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[CFDI De Egresos.FechaTimbrado]
Carpeta=CFDI De Egresos
Clave=FechaTimbrado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[CFDI De Egresos.Monto]
Carpeta=CFDI De Egresos
Clave=Monto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[(Carpeta Totalizadores)]
Clave=(Carpeta Totalizadores)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=C2
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=2
FichaEspacioNombres=78
FichaNombres=Izquierda
FichaAlineacion=Derecha
FichaColorFondo=Plata
FichaAlineacionDerecha=S
Totalizadores1=Total
Totalizadores2=SumaTotal(DM0332ExploradorRelacion1Vis:DM0332ExploradorRelacionTBL.Importe )
Totalizadores=S
CampoColorLetras=Negro
CampoColorFondo=Plata
CarpetaVisible=S
ListaEnCaptura=Total

Totalizadores3=(Monetario)
TotCarpetaRenglones=Relaciones
[(Carpeta Totalizadores).Total]
Carpeta=(Carpeta Totalizadores)
Clave=Total
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Plata

[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
NombreEnBoton=S

[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
ConCondicion=S
Visible=S

Multiple=S
ListaAccionesMultiples=Guardar<BR>Actualizar
EjecucionCondicion=Si<BR>   Diferencia(DM0332Explorador1Vis:Monto,SumaTotal(DM0332ExploradorRelacion1Vis:DM0332ExploradorRelacionTBL.Importe))<=1<BR>Entonces<BR>    VERDADERO<BR>Sino<BR>     INFORMACION(<T>Los Importes no corresponden.<T>)<BR>    AbortarOperacion<BR>Fin
[Acciones.Guardar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Guardar.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Asigna( Mavi.DM0332UUID,NULO )<BR>Forma.ActualizarVista(<T>Relaciones<T>)<BR>Forma.ActualizarVista(<T>CFDI De Egresos<T>)<BR>Forma.ActualizarVista(<T>Detalle<T>)
[Detalle]
Estilo=Hoja
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Movimientos
Clave=Detalle
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B2
Vista=DM0332ExploradorDetalleVis
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
ListaEnCaptura=Movimiento<BR>MovId
CarpetaVisible=S

[Detalle.Movimiento]
Carpeta=Detalle
Clave=Movimiento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Detalle.MovId]
Carpeta=Detalle
Clave=MovId
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.Detalle]
Nombre=Detalle
Boton=0
NombreDesplegar=Detalle
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.DM0332UUID,DM0332ExploradorRelacion1Vis:DM0332ExploradorRelacionTBL.UUIDRelacionado)<BR>Forma.ActualizarVista(<T>Detalle<T>)

[Detalle.Columnas]
Movimiento=136
MovId=102

