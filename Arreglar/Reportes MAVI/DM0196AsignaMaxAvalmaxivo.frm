[Forma]
Clave=DM0196AsignaMaxAvalmaxivo
Nombre=Asigna Maximo Avales x Agente
Icono=0
Modulos=(Todos)
ListaCarpetas=DM0196AgenteAvalTmpVis
CarpetaPrincipal=DM0196AgenteAvalTmpVis
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Cargar<BR>Cambiar<BR>Cerrar
PosicionInicialArriba=50
PosicionInicialAlturaCliente=230
PosicionInicialAncho=375
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=113
[DM0196AgenteAvalTmpVis]
Estilo=Hoja
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Asignar maximo de avales
Clave=DM0196AgenteAvalTmpVis
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0196AgenteAvalTmpVIs
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
PermiteEditar=S
ListaEnCaptura=DM0196AgenteAvalTmpTBL.Agente<BR>DM0196AgenteAvalTmpTBL.nivelcobranza<BR>DM0196AgenteAvalTmpTBL.Maximo
[DM0196AgenteAvalTmpVis.DM0196AgenteAvalTmpTBL.Agente]
Carpeta=DM0196AgenteAvalTmpVis
Clave=DM0196AgenteAvalTmpTBL.Agente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[DM0196AgenteAvalTmpVis.DM0196AgenteAvalTmpTBL.Maximo]
Carpeta=DM0196AgenteAvalTmpVis
Clave=DM0196AgenteAvalTmpTBL.Maximo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Cargar]
Nombre=Cargar
Boton=67
NombreDesplegar=Cargar
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Enviar/Recibir Excel
Activo=S
Visible=S
NombreEnBoton=S
[Acciones.Cambiar]
Nombre=Cambiar
Boton=3
NombreDesplegar=Cambiar
EnBarraHerramientas=S
Activo=S
Visible=S
NombreEnBoton=S
Multiple=S
EspacioPrevio=S
ListaAccionesMultiples=Varasignar<BR>Reasignar
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Cambiar.Varasignar]
Nombre=Varasignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Cambiar.Reasignar]
Nombre=Reasignar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=guardarcambios<BR>si (SQL(<T>Select count(agente) from DM0196agenteAvalTmp<T>)>0)entonces<BR>  Si (SQL(<T>Select count(Agente) from( Select dm.Agente,dm.nivelcobranza,ag.agente as agentev,ag.nivelcobranzamavi<BR>          From<BR>          DM0196agenteAvalTmp dm left join agente ag on dm.agente = ag.agente<BR>          where  estaciontrab = :Nestt and usua = :Tusua and (dm.nivelcobranza != ag.nivelcobranzamavi or ag.agente is null) )ag2<T> ,estaciontrabajo, Usuario ))=0)<BR>  entonces<BR>      EjecutarSql(<T>SP_MaviDM0196MaxAvalesxAgente :Ncambia , :Nest,:tusu<T>,1,estaciontrabajo, Usuario )<BR>      Informacion(<T>El máximo de avales han sido Actualizado<T>)<BR><BR>  sino<BR>       EJECUTARSQL(<T>SP_MaviDM0196MaxAvalesxAgente :Ncambia , :NEsttab, :TUsuar  <T>,0, EstacionTrabajo , Usuario <CONTINUA>
Expresion002=<CONTINUA>)<BR>      Error(<T>Alguno de los Agentes es incorrecto, por favor revise su archivo<T>)<BR><BR>  Fin<BR> sino<BR>  error(<T>Vuelva a cargar su archivo<T>)<BR>FIn
[DM0196AgenteAvalTmpVis.Columnas]
Agente=94
Maximo=64
estaciontrab=64
usua=61
nivelcobranza=166
[DM0196AgenteAvalTmpVis.DM0196AgenteAvalTmpTBL.nivelcobranza]
Carpeta=DM0196AgenteAvalTmpVis
Clave=DM0196AgenteAvalTmpTBL.nivelcobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro

