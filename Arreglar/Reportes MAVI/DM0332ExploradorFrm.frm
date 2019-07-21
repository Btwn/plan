
[Forma]
Clave=DM0332ExploradorFrm
Icono=0
Modulos=(Todos)
Nombre=Explorador


CarpetaPrincipal=Relaciones

ListaCarpetas=CFDValido<BR>Relaciones
PosicionInicialAlturaCliente=501
PosicionInicialAncho=716


PosicionSec1=184
Totalizadores=S
PosicionSec2=440
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
[(variables).Temp.Logico]
Carpeta=(variables)
Clave=Temp.Logico
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[CFDValido]
Estilo=Hoja
Clave=CFDValido
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0332ExploradorVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
FiltroPredefinido1=
FiltroPredefinido2=

MenuLocal=S
ListaAcciones=Actualizar
Pestana=S
PestanaOtroNombre=S
PestanaNombre=CFDI Egresos




HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
HojaMantenerSeleccion=S
ListaEnCaptura=Relaciones<BR>UUID<BR>RFCEmisor<BR>FechaTimbrado<BR>Monto
[CFDValido.Columnas]
Empresa=45
UUID=259
RFCReceptor=304
Monto=64

Nombre=604
RFCEmisor=133
FechaTimbrado=135
Relaciones=64
[Acciones.Actualizar]
Nombre=Actualizar
Boton=0
NombreDesplegar=Actualizar
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S


Expresion=Asigna(Mavi.DM0332UUID,dm0332ExploradorVis:UUID)<BR>Forma.ActualizarVista(<T>Relaciones<T>)
[Relaciones]
Estilo=Hoja
Pestana=S
Clave=Relaciones
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=DM0332ExploradorRelacionVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S

PestanaOtroNombre=S
PestanaNombre=CFDI Relacionados
PermiteEditar=S
HojaPermiteInsertar=S





ListaEnCaptura=DM0332ExploradorRelacionTBL.Tipo<BR>DM0332ExploradorRelacionTBL.UUID<BR>DM0332ExploradorRelacionTBL.UUIDRelacionado<BR>DM0332ExploradorRelacionTBL.Importe
HojaPermiteEliminar=S
[Relaciones.Columnas]
Tipo=24
UUID=253
UUIDRelacionado=304
Importe=64





SumImporte=64










[Relaciones.DM0332ExploradorRelacionTBL.UUID]
Carpeta=Relaciones
Clave=DM0332ExploradorRelacionTBL.UUID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Relaciones.DM0332ExploradorRelacionTBL.Importe]
Carpeta=Relaciones
Clave=DM0332ExploradorRelacionTBL.Importe
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Relaciones.DM0332ExploradorRelacionTBL.UUIDRelacionado]
Carpeta=Relaciones
Clave=DM0332ExploradorRelacionTBL.UUIDRelacionado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[(Carpeta Totalizadores)]
Clave=(Carpeta Totalizadores)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=C2
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=0
FichaEspacioNombres=52
FichaNombres=Izquierda
FichaAlineacion=Derecha
FichaColorFondo=Plata
FichaAlineacionDerecha=S
Totalizadores1=Total
Totalizadores2=SumaTotal( DM0332ExploradorRelacionVis:DM0332ExploradorRelacionTBL.Importe )
Totalizadores3=(Monetario)
Totalizadores=S
TotCarpetaRenglones=Relaciones
TotExpresionesEnSumas=S
TotAlCambiar=S
CampoColorLetras=Negro
CampoColorFondo=Plata
ListaEnCaptura=Total
CarpetaVisible=S

[(Carpeta Totalizadores).Total]
Carpeta=(Carpeta Totalizadores)
Clave=Total
Editar=S
LineaNueva=N
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
NombreDesplegar=&Guardar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
ConCondicion=S
Visible=S
NombreEnBoton=S

Multiple=S
ListaAccionesMultiples=Guardar<BR>Actualizar
EjecucionCondicion=Si<BR>   Diferencia(DM0332ExploradorVis:Monto,SumaTotal(DM0332ExploradorRelacionVis:DM0332ExploradorRelacionTBL.Importe))<=1<BR>Entonces<BR>   VERDADERO<BR>Sino<BR>   INFORMACION(<T>Los Importes no corresponden.<T>)<BR>   AbortarOperacion<BR>Fin
[CFDValido.Relaciones]
Carpeta=CFDValido
Clave=Relaciones
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[CFDValido.UUID]
Carpeta=CFDValido
Clave=UUID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[CFDValido.RFCEmisor]
Carpeta=CFDValido
Clave=RFCEmisor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[CFDValido.FechaTimbrado]
Carpeta=CFDValido
Clave=FechaTimbrado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[CFDValido.Monto]
Carpeta=CFDValido
Clave=Monto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Relaciones.DM0332ExploradorRelacionTBL.Tipo]
Carpeta=Relaciones
Clave=DM0332ExploradorRelacionTBL.Tipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=1
ColorFondo=Blanco

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
Expresion=Asigna( Mavi.DM0332UUID, NULO )<BR>Forma.ActualizarVista(<T>Relaciones<T>)<BR>Forma.ActualizarVista(<T>CFDValido<T>)

