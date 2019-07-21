
[Forma]
Clave=RM1206CalculoFrm
Icono=0
Modulos=(Todos)
Nombre=REPORTE DE ENTRADAS DIVERSAS ARTICULOS ESPE Y NVO+

ListaCarpetas=Variables<BR>datos
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Buscar<BR>Reporte<BR>Cerrar
CarpetaPrincipal=Variables
PosicionInicialIzquierda=75
PosicionInicialArriba=259
PosicionInicialAlturaCliente=467
PosicionInicialAncho=1130
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionSec1=75
ExpresionesAlMostrar=Asigna(Info.FechaD, Hoy )<BR>Asigna(Info.FechaA, Hoy )<BR>Asigna( Info.Mensaje,0)
[Variables]
Estilo=Ficha
Clave=Variables
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.FechaD<BR>Info.FechaA
CarpetaVisible=S

[Variables.Info.FechaD]
Carpeta=Variables
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Variables.Info.FechaA]
Carpeta=Variables
Clave=Info.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.Buscar.Asig]
Nombre=Asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Buscar]
Nombre=Buscar
Boton=7
NombreDesplegar=&Buscar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asig<BR>Aceptar
Activo=S
Visible=S
NombreEnBoton=S

[Acciones.Buscar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Expresion
Activo=S
ConCondicion=S
Visible=S



Expresion=Forma.ActualizarVista(<T>RM1206CalculoPagoVis<T>)<BR>           ActualizarForma
EjecucionCondicion=Si<BR>  (Info.FechaD = nulo) o (Info.FechaA = nulo)<BR>Entonces<BR>   Informacion(<T>Se requiere fecha<T>)<BR>  AbortarOperacion<BR>Sino<BR>  Si<BR>     (Info.FechaD) > (Info.FechaA)<BR>    Entonces<BR>      Informacion(<T>La fecha inicial no puede ser mayor a la inicial<T>)<BR>      AbortarOperacion<BR>    Sino<BR>        Si<BR>         ( sql(<T>SELECT COUNT(i.ID)<BR>         from inv i<BR>         with (nolock)<BR>         inner join invd ind  on i.id = ind.id<BR>         inner join art a on ind.articulo = a.articulo<BR>         where  i.estatus=:testatus and i.concepto=:tconce and<BR>         i.mov=:tentrada and fechaemision between :tfenini and<BR>         :tfechafin<T>,<T>concluido<T>, <T>adjudicacion<T>, <T>Entrada Diversa<T>,<BR>          FechaFormatoServidor(Info.FechaD) , FechaFormatoServidor(Info.FechaA) ))>0<BR><BR>         Entonces<BR>           verdadero<BR>           Asigna(Info.Mensaje,1)<BR>        Sino<BR>           Informacion(<T>No hay informacion en los parametros requeridos<T>)<BR>            Asigna(Info.Mensaje,0)<BR>            Forma.ActualizarVista(<T>RM1206CalculoPagoVis<T>)<BR>            ActualizarForma<BR>            AbortarOperacion<BR><BR>       Fin<BR>     verdadero<BR>   Fin<BR>Fin
[datos]
Estilo=Hoja
Clave=datos
BusquedaRapidaControles=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=RM1206CalculoPagoVis
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
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
CarpetaVisible=S





ListaEnCaptura=articulo<BR>descripcion1<BR>cantidad<BR>almacen<BR>movId<BR>fec<BR>usu
[datos.Columnas]
articulo=124
descripcion1=511
almacen=60
fechaEmision=89
usuario=95
movId=132
movID=132



fec=98
cantidad=48
usu=99
[Acciones.Reporte]
Nombre=Reporte
Boton=67
NombreDesplegar=&Reporte
EnBarraHerramientas=S
TipoAccion=Reportes Excel
ClaveAccion=RM1206CalcRepXls
NombreEnBoton=S
Visible=S

Activo=S
ConCondicion=S
EjecucionCondicion=Si<BR>  (Info.mensaje)=1<BR>Entonces<BR> verdadero<BR>Sino<BR>  falso<BR>Fin
[Acciones.Cerrar]
Nombre=Cerrar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S




[datos.articulo]
Carpeta=datos
Clave=articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[datos.descripcion1]
Carpeta=datos
Clave=descripcion1
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco

[datos.cantidad]
Carpeta=datos
Clave=cantidad
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[datos.almacen]
Carpeta=datos
Clave=almacen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco

[datos.movId]
Carpeta=datos
Clave=movId
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[datos.fec]
Carpeta=datos
Clave=fec
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[datos.usu]
Carpeta=datos
Clave=usu
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco

