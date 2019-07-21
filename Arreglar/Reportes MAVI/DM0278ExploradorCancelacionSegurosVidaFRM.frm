[Forma]
Clave=DM0278ExploradorCancelacionSegurosVidaFRM
Icono=290
Modulos=(Todos)
ListaCarpetas=(Variables)<BR>Uno
CarpetaPrincipal=Uno
PosicionInicialAlturaCliente=949
PosicionInicialAncho=1298
PosicionInicialIzquierda=0
PosicionInicialArriba=15
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Actualizar<BR>Seleccionar<BR>Seleccionar Reporte<BR>Historico<BR>Importe<BR>Enviar a Excel
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
Nombre=SOLICITUDES PEDIENTES DE CANCELACIÓN
PosicionSec1=62
Totalizadores=S
PosicionSec2=782
ExpresionesAlMostrar=Asigna(Mavi.DM0278FiltroCliente,nulo)<BR>Asigna(Mavi.DM0278FiltroFactura,nulo)<BR>Asigna(Mavi.DM0278Estatus,nulo)<BR>Asigna(Mavi.DM0278Sucursal,nulo)
[Uno]
Estilo=Hoja
Clave=Uno
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=DM0278HistCancelacionSegurosVidaVIS
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=DM0278HistCancelacionSegurosVidaTBL.Cliente<BR>DM0278HistCancelacionSegurosVidaTBL.NombreCliente<BR>Cxc.SucursalOrigen<BR>Cxc.FechaEmision<BR>DM0278HistCancelacionSegurosVidaTBL.MovID<BR>DM0278HistCancelacionSegurosVidaTBL.MovIDCXC<BR>DM0278HistCancelacionSegurosVidaTBL.ImporteCancelacion<BR>DM0278HistCancelacionSegurosVidaTBL.Motivos<BR>DM0278HistCancelacionSegurosVidaTBL.NominaSolicitante<BR>DM0278HistCancelacionSegurosVidaTBL.NombreSolicitante<BR>DM0278HistCancelacionSegurosVidaTBL.Saldo<BR>DM0278HistCancelacionSegurosVidaTBL.Telefono<BR>DM0278HistCancelacionSegurosVidaTBL.ComentarioVentas<BR>DM0278HistCancelacionSegurosVidaTBL.ComentarioCobranza<BR>DM0278HistCancelacionSegurosVidaTBL.Estatus
ListaEnCaptura002=<CONTINUA>78HistCancelacionSegurosVidaTBL.NotaCargo
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
MenuLocal=S
ListaAcciones=Reactiva
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
FiltroGeneral={<BR>Si (condatos(Mavi.DM0278FiltroCliente)) y (ConDatos(Mavi.DM0278FiltroFactura))<BR>Entonces<BR>    Si ConDatos(Mavi.DM0278Estatus)<BR>    Entonces<BR>        Si ConDatos(Mavi.DM0278Sucursal)<BR>        Entonces<BR>            <T>DM0278HistCancelacionSegurosVidaTBL.Cliente=<T>+comillas(Mavi.DM0278FiltroCliente)+ <T> and <T>+ <T>DM0278HistCancelacionSegurosVidaTBL.MovID=<T>+comillas(Mavi.DM0278FiltroFactura)+<T> and <T>+<T>DM0278HistCancelacionSegurosVidaTBL.Estatus=<T>+comillas(Mavi.DM0278Estatus)+<T> and <T>+<T>Cxc.SucursalOrigen IN (<T>+Mavi.DM0278Sucursal+<T>)<T><BR>        Sino<BR>            <T>DM0278HistCancelacionSegurosVidaTBL.Cliente=<T>+comillas(Mavi.DM0278FiltroCliente)+ <T> and <T>+ <T>DM0278HistCancelacionSegurosVidaTBL.MovID=<T>+comillas(Mavi.DM0278FiltroFactura)+<T> and <T>+<T>DM0278HistCancelacionSegurosVidaTBL.Estatus=<T>+comillas(Mavi.DM0278Estatus)<BR>        Fin<BR>    Sino<BR>        <T>DM0278HistCancelacionSegurosVidaTBL.Cliente=<T>+comillas(Mavi.DM0278FiltroCliente)+ <T> and <T>+ <T>DM0278HistCancelacionSegurosVidaTBL.MovID=<T>+comillas(Mavi.DM0278FiltroFactura)<BR>    Fin<BR>Sino<BR>    Si (ConDatos(Mavi.DM0278FiltroCliente)) y (Vacio(Mavi.DM0278FiltroFactura))<BR>    Entonces<BR>        Si ConDatos(Mavi.DM0278Estatus)<BR>        Entonces<BR>            Si ConDatos(Mavi.DM0278Sucursal)<BR>            Entonces<BR>                <T>DM0278HistCancelacionSegurosVidaTBL.Cliente=<T>+comillas(Mavi.DM0278FiltroCliente)+<T> and <T>+<T>DM0278HistCancelacionSegurosVidaTBL.Estatus=<T>+comillas(Mavi.DM0278Estatus)+<T> and <T>+<T>Cxc.SucursalOrigen IN (<T>+Mavi.DM0278Sucursal+<T>)<T><BR>            Sino<BR>                <T>DM0278HistCancelacionSegurosVidaTBL.Cliente=<T>+comillas(Mavi.DM0278FiltroCliente)+<T> and <T>+<T>DM0278HistCancelacionSegurosVidaTBL.Estatus=<T>+comillas(Mavi.DM0278Estatus)<BR>            Fin<BR>        Sino<BR>            <T>DM0278HistCancelacionSegurosVidaTBL.Cliente=<T>+comillas(Mavi.DM0278FiltroCliente)<BR>        Fin<BR>    Sino<BR>        Si (Vacio(Mavi.DM0278FiltroCliente)) y (ConDatos(Mavi.DM0278FiltroFactura))<BR>        Entonces<BR>            Si ConDatos(Mavi.DM0278Estatus)<BR>            Entonces<BR>                Si ConDatos(Mavi.DM0278Sucursal)<BR>                Entonces<BR>                    <T>DM0278HistCancelacionSegurosVidaTBL.MovID=<T>+comillas(Mavi.DM0278FiltroFactura)+<T> and <T>+<T>DM0278HistCancelacionSegurosVidaTBL.Estatus=<T>+comillas(Mavi.DM0278Estatus)+<T> and <T>+<T>Cxc.SucursalOrigen IN (<T>+Mavi.DM0278Sucursal+<T>)<T><BR>                Sino<BR>                    <T>DM0278HistCancelacionSegurosVidaTBL.MovID=<T>+comillas(Mavi.DM0278FiltroFactura)+<T> and <T>+<T>DM0278HistCancelacionSegurosVidaTBL.Estatus=<T>+comillas(Mavi.DM0278Estatus)<BR>                Fin<BR>            Sino<BR>               <T>DM0278HistCancelacionSegurosVidaTBL.MovID=<T>+comillas(Mavi.DM0278FiltroFactura)<BR>            Fin<BR>        Sino<BR>            Si (Vacio(Mavi.DM0278FiltroCliente)) y (Vacio(Mavi.DM0278FiltroFactura))<BR>            Entonces<BR>                Si ConDatos(Mavi.DM0278Estatus)<BR>                Entonces<BR>                    Si ConDatos(Mavi.DM0278Sucursal)<BR>                    Entonces<BR>                        <T>DM0278HistCancelacionSegurosVidaTBL.Estatus=<T>+comillas(Mavi.DM0278Estatus)+<T> and <T>+<T>Cxc.SucursalOrigen IN (<T>+Mavi.DM0278Sucursal+<T>)<T><BR>                    Sino<BR>                        <T>DM0278HistCancelacionSegurosVidaTBL.Estatus=<T>+comillas(Mavi.DM0278Estatus)<BR>                    Fin<BR>                Sino<BR>                  Si (Vacio(Mavi.DM0278FiltroCliente)) y (Vacio(Mavi.DM0278FiltroFactura)) (Vacio(Mavi.DM0278Estatus)) y  (ConDatos(Mavi.DM0278Sucursal))<BR>                  Entonces<BR>                       <T>Cxc.SucursalOrigen IN (<T>+Mavi.DM0278Sucursal+<T>)<T><BR>                  Sino<BR>                       <T><T><BR>                  Fin<BR>            Fin<BR>        Fin<BR>    Fin<BR>Fin<BR>}
[Uno.Columnas]
Factura=65
Saldo=64
Motivos=215
Cuenta_Cliente=85
Nombre_Cliente=269
Telefono=124
ImportePCancelar=90
Nomina_Solicitante=94
Nombre_Solicitante=304
Comentario_Ventas=604
Comentario_Cobranza=604
MovID=76
Cliente=67
Importe_Cancelacion=105
ID=64
Pagado=64
Mov=184
MovCXC=124
MovIDCXC=124
NombreCliente=228
NominaSolicitante=88
NombreSolicitante=237
ComentarioVentas=452
ComentarioCobranza=314
ImporteCancelacion=99
NotaCargo=94
Estatus=94
FechaEmision=109
SucursalOrigen=95
[Acciones.Seleccionar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.DM0278FacturaMovID,DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.ID)
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreDesplegar=Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asignar<BR>Seleccionar/Resultado
Visible=S
NombreEnBoton=S
ConCondicion=S
EjecucionConError=S
ActivoCondicion=SQL(<T>select  dbo.FN_DM0278VerificarUsuarioAcceso(<T>+comillas(Usuario)+<T>)<T>)=2
EjecucionCondicion=SQL(<T>select COUNT(ID) from DM0278HistCancelacionSegurosVida where Estatus=:tEstatus<T>,<T>PENDIENTE<T>)>0
EjecucionMensaje=<T>No existen Solicitudes Pendientes<T>
[Acciones.Seleccionar.Seleccionar/Resultado]
Nombre=Seleccionar/Resultado
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Forma( <T>DM0278CancelacionSegurosVidaConsultaFRM<T> )
[Uno.DM0278HistCancelacionSegurosVidaTBL.MovID]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.MovID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Uno.DM0278HistCancelacionSegurosVidaTBL.Saldo]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.Saldo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
[Uno.DM0278HistCancelacionSegurosVidaTBL.Motivos]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.Motivos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
[Uno.DM0278HistCancelacionSegurosVidaTBL.Cliente]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
[Uno.DM0278HistCancelacionSegurosVidaTBL.Telefono]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.Telefono
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


[Uno.DM0278HistCancelacionSegurosVidaTBL.MovIDCXC]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.MovIDCXC
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Uno.DM0278HistCancelacionSegurosVidaTBL.NombreCliente]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.NombreCliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
[Uno.DM0278HistCancelacionSegurosVidaTBL.NominaSolicitante]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.NominaSolicitante
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
[Uno.DM0278HistCancelacionSegurosVidaTBL.NombreSolicitante]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.NombreSolicitante
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
[Uno.DM0278HistCancelacionSegurosVidaTBL.ComentarioVentas]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.ComentarioVentas
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=250
ColorFondo=Blanco
[Uno.DM0278HistCancelacionSegurosVidaTBL.ComentarioCobranza]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.ComentarioCobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=250
ColorFondo=Blanco
[Uno.DM0278HistCancelacionSegurosVidaTBL.ImporteCancelacion]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.ImporteCancelacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
[Acciones.Seleccionar Reporte]
Nombre=Seleccionar Reporte
Boton=65
NombreEnBoton=S
NombreDesplegar=Abrir Reporte
EnBarraHerramientas=S
TipoAccion=Reportes Pantalla
ClaveAccion=DM0278CancelacionSegurosVidaREP
Visible=S
Multiple=S
ListaAccionesMultiples=Asigna<BR>Resultado
ActivoCondicion=SQL(<T>select  dbo.FN_DM0278VerificarUsuarioAcceso(<T>+comillas(Usuario)+<T>)<T>)=1
[Acciones.Seleccionar Reporte.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.DM0278FacturaMovID,DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.ID)
[Acciones.Seleccionar Reporte.Resultado]
Nombre=Resultado
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=ReportePantalla(<T>DM0278CancelacionSegurosVidaREP<T>)
[Uno.DM0278HistCancelacionSegurosVidaTBL.Estatus]
Carpeta=Uno
Clave=DM0278HistCancelacionSegurosVidaTBL.Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
[Acciones.Historico]
Nombre=Historico
Boton=18
NombreEnBoton=S
NombreDesplegar=Historico de Solicitudes Concluidas
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=DM0278HistoricoCancelacionesSegurosVidaFRM
Visible=S
ActivoCondicion=SQL(<T>Select dbo.FN_DM0278VerificarAccesoCobranza(<T>+Comillas(USUARIO)+<T>)<T>)
[Acciones.Importe]
Nombre=Importe
Boton=64
NombreDesplegar=Cambiar Importe de Cancelación
EnBarraHerramientas=S
Visible=S
NombreEnBoton=S
TipoAccion=Formas
ClaveAccion=DM0278SegurosImporteCancelarFRM
ActivoCondicion=SQL(<T>Select dbo.FN_DM0278VerificarAccesoCobranza(<T>+Comillas(USUARIO)+<T>)<T>)
[(Variables)]
Estilo=Ficha
Clave=(Variables)
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
ListaEnCaptura=Mavi.DM0278FiltroCliente<BR>Mavi.DM0278FiltroFactura<BR>Mavi.DM0278Estatus<BR>Mavi.DM0278Sucursal
CarpetaVisible=S
[(Variables).Mavi.DM0278FiltroCliente]
Carpeta=(Variables)
Clave=Mavi.DM0278FiltroCliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[(Variables).Mavi.DM0278FiltroFactura]
Carpeta=(Variables)
Clave=Mavi.DM0278FiltroFactura
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Acciones.Actualizar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Actualizar.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Expresion
Expresion=Forma.ActualizarVista(<T>Uno<T>)
Activo=S
Visible=S
[Acciones.Actualizar]
Nombre=Actualizar
Boton=82
NombreDesplegar=Actualizar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Variables Asignar<BR>Actualizar
Activo=S
Visible=S
NombreEnBoton=S



[(Variables).Mavi.DM0278Estatus]
Carpeta=(Variables)
Clave=Mavi.DM0278Estatus
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.DM0278Sucursal]
Carpeta=(Variables)
Clave=Mavi.DM0278Sucursal
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Sucursal.Columnas]
0=-2
1=-2

[(Carpeta Totalizadores)]
Clave=(Carpeta Totalizadores)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=C1
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=9
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
Totalizadores1=Totalizador
Totalizadores2=ConteoTotal(DM0278HistCancelacionSegurosVidaTBL.ID)
Totalizadores=S
TotCarpetaRenglones=Uno
CampoColorLetras=Negro
CampoColorFondo=Plata
CarpetaVisible=S
TotAlCambiar=S
ListaEnCaptura=Totalizador

[(Carpeta Totalizadores).Totalizador]
Carpeta=(Carpeta Totalizadores)
Clave=Totalizador
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Plata




[Acciones.Enviar a Excel]
Nombre=Enviar a Excel
Boton=115
NombreEnBoton=S
NombreDesplegar=Enviar a Excel
EnBarraHerramientas=S
Carpeta=DM0278ExploradorCancelacionSegVidRepXls
TipoAccion=Controles Captura
ClaveAccion=Enviar a Excel
Activo=S
Visible=S



[Acciones.Reactiva.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Asigna(Mavi.DM0278FacturaMovID,DM0278HistCancelacionSegurosVidaVIS:DM0278HistCancelacionSegurosVidaTBL.ID)
[Acciones.Reactiva.SeleccionaResult]
Nombre=SeleccionaResult
Boton=0
TipoAccion=Ventana
Activo=S
Visible=S

ClaveAccion=Seleccionar/Resultado
Expresion=Forma( <T>DM0278ReactivarSegurosVidaCrearFRM<T> )
[Acciones.Reactiva]
Nombre=Reactiva
Boton=0
NombreDesplegar=Reactivar
Multiple=S
EnMenu=S
ListaAccionesMultiples=Asigna<BR>SeleccionaResult
Visible=S

ActivoCondicion=SQL(<T>Select dbo.FN_DM0278VerificarAccesoCobranza(<T>+Comillas(USUARIO)+<T>)<T>)
[Uno.Cxc.FechaEmision]
Carpeta=Uno
Clave=Cxc.FechaEmision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Uno.Cxc.SucursalOrigen]
Carpeta=Uno
Clave=Cxc.SucursalOrigen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

