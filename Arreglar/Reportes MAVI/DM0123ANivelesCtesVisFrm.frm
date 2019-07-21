[Forma]
Clave=DM0123ANivelesCtesVisFrm
Nombre=Importar Clientes
Icono=0
Modulos=(Todos)
ListaCarpetas=NivelesCtesA
CarpetaPrincipal=NivelesCtesA
PosicionInicialAlturaCliente=273
PosicionInicialAncho=413
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Cargar<BR>Cambiar
PosicionInicialIzquierda=220
PosicionInicialArriba=201
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
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=guardarcambios<BR>si (SQL(<T>Select count(NIVELCONTACTO) from DM0123NivelesCtesctnTbl<T>)>0)entonces<BR>  Si (SQL(<T>Select count(NIVELCONTACTO) from DM0123NivelesCtesctnTbl where estacion = :Nestt and usuario = :Tusua<BR>    and NIVELCONTACTO not in (select nombre from NivelesEspecialesCobranzaMavi)<T>,estaciontrabajo,usuario))=0)<BR>  entonces<BR>      EjecutarSql(<T>SP_DM0123NivelContactoVariosCtes :Nest,:tusu<T>,estaciontrabajo,usuario)<BR>      Informacion(<T>Los Niveles de Cobranza han sido Actualizados<T>)<BR>      ejecutarsql(<T>SP_DM0123AEliminarReg :Nest,:tusu<T>,estaciontrabajo,usuario)<BR>      Asigna( Mavi.DM0123Cerrarventana,<T>SI<T> )<BR>  sino<BR>      Asigna( Mavi.DM0123Cerrarventana,<T>NO<T> )<BR>      Error(<T>Alguno de los niveles es incorrecto, por favor revise su arch<CONTINUA>
Expresion002=<CONTINUA>ivo<T>)<BR>      ejecutarsql(<T>SP_DM0123AEliminarReg :Nest,:tusu<T>,estaciontrabajo,usuario)<BR>  Fin<BR> sino<BR>  error(<T>Vuelva a cargar su archivo<T>)<BR>FIn
EjecucionCondicion=condatos(DM0123ANivelesCtesVis:DM0123ANivelesCtesctnTbl.CLIENTE)
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
[Acciones.Cambiar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=Mavi.DM0123Cerrarventana =<T>SI<T>
[NivelesCtesA]
Estilo=Hoja
Pestana=S
Clave=NivelesCtesA
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0123ANivelesCtesVis
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
ListaEnCaptura=DM0123ANivelesCtesctnTbl.CLIENTE<BR>DM0123ANivelesCtesctnTbl.NIVELCONTACTO<BR>DM0123ANivelesCtesctnTbl.IDaval
CarpetaVisible=S
[NivelesCtesA.DM0123ANivelesCtesctnTbl.CLIENTE]
Carpeta=NivelesCtesA
Clave=DM0123ANivelesCtesctnTbl.CLIENTE
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[NivelesCtesA.DM0123ANivelesCtesctnTbl.NIVELCONTACTO]
Carpeta=NivelesCtesA
Clave=DM0123ANivelesCtesctnTbl.NIVELCONTACTO
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[NivelesCtesA.Columnas]
CLIENTE=166
NIVELCONTACTO=122
IDaval=64
[NivelesCtesA.DM0123ANivelesCtesctnTbl.IDaval]
Carpeta=NivelesCtesA
Clave=DM0123ANivelesCtesctnTbl.IDaval
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
