[Forma]
Clave=DM0123NivelesCtesVisFrm
Nombre=Importar Clientes
Icono=0
Modulos=(Todos)
ListaCarpetas=NivelesCtes
CarpetaPrincipal=NivelesCtes
PosicionInicialAlturaCliente=273
PosicionInicialAncho=500
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Cargar<BR>Cambiar
PosicionInicialIzquierda=220
PosicionInicialArriba=201
[NivelesCtes]
Estilo=Hoja
Pestana=S
Clave=NivelesCtes
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0123NivelesCtesVis
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
ListaEnCaptura=DM0123NivelesCtesTbl.CLIENTE<BR>DM0123NivelesCtesTbl.COBRANZA
[NivelesCtes.Columnas]
CLIENTE=64
COBRANZA=304
[Acciones.Cargar]
Nombre=Cargar
Boton=72
NombreEnBoton=S
NombreDesplegar=Cargar
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=controles Captura
ClaveAccion=Enviar/Recibir Excel
Activo=S
Visible=S
[Acciones.Cambiar.Var Asignar]
Nombre=Var Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Cambiar.Reasignar]
Nombre=Reasignar
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=guardarcambios<BR>si (SQL(<T>Select count(cobranza) from DM0123NivelesCtesTbl<T>)>0)entonces<BR>  Si (SQL(<T>Select count(cobranza) from DM0123NivelesCtesTbl where estacion = :Nestt and usuario = :Tusua<BR>    and cobranza not in (select nombre from NivelesEspecialesCobranzaMavi)<T>,estaciontrabajo,usuario))=0)<BR>  entonces<BR>      EjecutarSql(<T>SP_MaviDM0123NivelCobranzaVariosCtes :Nest,:tusu<T>,estaciontrabajo,usuario)<BR>      Informacion(<T>Los Niveles de Cobranza han sido Actualizados<T>)<BR>      ejecutarsql(<T>SP_MaviDM0123EliminaReg :Nest,:tusu<T>,estaciontrabajo,usuario)<BR>      Asigna( Mavi.DM0123Cerrarventana,<T>SI<T> )<BR>  sino<BR>      Asigna( Mavi.DM0123Cerrarventana,<T>NO<T> )<BR>      Error(<T>Alguno de los niveles es incorrecto, por favor revise su archivo<T>)<BR>    <CONTINUA>
Expresion002=<CONTINUA>  ejecutarsql(<T>SP_MaviDM0123EliminaReg :Nest,:tusu<T>,estaciontrabajo,usuario)<BR>  Fin<BR> sino<BR>  error(<T>Vuelva a cargar su archivo<T>)<BR>FIn
EjecucionCondicion=condatos(DM0123NivelesCtesVis:DM0123NivelesCtesTbl.CLIENTE)
EjecucionMensaje=<T>Debe incluir al menos un cliente<T>
[Acciones.Cambiar]
Nombre=Cambiar
Boton=23
NombreDesplegar=Cambiar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Var Asignar<BR>Reasignar<BR>Aceptar
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S
[NivelesCtes.DM0123NivelesCtesTbl.CLIENTE]
Carpeta=NivelesCtes
Clave=DM0123NivelesCtesTbl.CLIENTE
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[NivelesCtes.DM0123NivelesCtesTbl.COBRANZA]
Carpeta=NivelesCtes
Clave=DM0123NivelesCtesTbl.COBRANZA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Cambiar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=Mavi.DM0123Cerrarventana =<T>SI<T>
