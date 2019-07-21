[Forma]
Clave=DM0203RecepLayoutAgentRutfrm
Icono=0
Modulos=(Todos)
ListaCarpetas=dm0203Vista2VIS
CarpetaPrincipal=dm0203Vista2VIS
PosicionInicialAlturaCliente=699
PosicionInicialAncho=215
Menus=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Import Information<BR>Guardar
AutoGuardar=S
PosicionInicialIzquierda=386
PosicionInicialArriba=105
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
Nombre=DM0203RecepLayoutAgentRut
PosicionCol1=96
PosicionSec1=250
ExpresionesAlCerrar=EjecutarSQLAnimado(<T>SP_MaviDM0203LayOutAgenteRuta :ndel<T>,1)
[RM0497IMPCTOVIS.Columnas]
Nivel=68
Agente=73
[Acciones.Import Information]
Nombre=Import Information
Boton=54
NombreDesplegar=Enviar/Recibir Excel
Carpeta=dm0203Vista2VIS
TipoAccion=Controles Captura
ClaveAccion=Enviar/Recibir Excel
Activo=S
Visible=S
EnBarraHerramientas=S
[RM0493BIMPCTOVIS.Columnas]
Nivel=109
Agente=68
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreDesplegar=Guardar
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
EnBarraHerramientas=S
Multiple=S
ListaAccionesMultiples=Guardar Cambios<BR>Expresion
[DM0203RecepLayouVIS.Columnas]
Agente=71
Ruta=78
[ejemplo.Columnas]
Agente=64
Ruta=59
[ejemplo.Agente]
Carpeta=ejemplo
Clave=Agente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[ejemplo.Ruta]
Carpeta=ejemplo
Clave=Ruta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[dm0203Vista2VIS.Columnas]
Agente=70
Ruta=86
[Acciones.Guardar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Guardar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si<BR>   SQL(<T>SP_MaviDM0203validarAgente<T>) = 0<BR>Entonces<BR><BR>       Si<BR>         SQL(<T>SP_MaviDM0203validarRuta<T>) = 0<BR>          Entonces<BR>                EjecutarSQLAnimado(<T>SP_MaviDM0203LayOutAgenteRuta :ndel<T>,0)<BR>                 informacion(<T>Se actualizo correctamente<T>)<BR>           sino<BR>            <BR>             <BR>              informacion(<T>Alguna de las rutas no es valida<T>)<BR>           fin<BR>sino<BR>  <BR>   <BR>     informacion(<T>Agente no valido<T>)<BR>fin
[DM0203RecepLayouVIS.DM0203RecepLayoutTBL.Agente]
Carpeta=DM0203RecepLayouVIS
Clave=DM0203RecepLayoutTBL.Agente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[DM0203RecepLayouVIS.DM0203RecepLayoutTBL.Ruta]
Carpeta=DM0203RecepLayouVIS
Clave=DM0203RecepLayoutTBL.Ruta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[dm0203Vista2VIS]
Estilo=Hoja
Clave=dm0203Vista2VIS
Detalle=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=dm0203Vista2VIS
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
ListaEnCaptura=DM0203cargaNvoTBL.Agente<BR>DM0203cargaNvoTBL.Ruta
PestanaOtroNombre=S
PestanaNombre=Agente a Actulizar
Pestana=S
CarpetaVisible=S
PermiteEditar=S
[dm0203Vista2VIS.DM0203cargaNvoTBL.Agente]
Carpeta=dm0203Vista2VIS
Clave=DM0203cargaNvoTBL.Agente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[dm0203Vista2VIS.DM0203cargaNvoTBL.Ruta]
Carpeta=dm0203Vista2VIS
Clave=DM0203cargaNvoTBL.Ruta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

