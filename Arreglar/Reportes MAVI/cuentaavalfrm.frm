[Forma]
Clave=CuentaAvalfrm
Nombre=Cuenta Aval
Icono=0
BarraAcciones=S
Modulos=(Todos)
AccionesTamanoBoton=17x5
ListaAcciones=AsignactaAval<BR>Aceptar<BR>Cerrar
PosicionInicialAlturaCliente=93
PosicionInicialAncho=378
PosicionInicialIzquierda=416
PosicionInicialArriba=429
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
AccionesIzq=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Info.ProspectoAcambiar,Mavi.DM0192ProspACliente)
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
EnBarraAcciones=S
TipoAccion=ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asigna<BR>Select<BR>Cerrar
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Aceptar.Select]
Nombre=Select
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
Expresion=SI<BR>(condatos(Mavi.DM0169FiltroAval) )y (Mavi.DM0169FiltroAval <> <T>No hay Coincidencias<T>)<BR>  ENTONCES<BR><BR>   INFORMACION(SQL(<T>EXEC SP_MAVIDM0169INSERTAVALCLIENTE :tProspACliente,:tFiltroAval,:tInformacion,:tUser<T>,Info.ProspectoACambiar,Mavi.DM0169FiltroAval,<T>Inserta<T>,Usuario))<BR><BR>  SINO<BR>      INFORMACION(<T>Seleccione Aval<T>)<BR> FIN
EjecucionCondicion=SI     /* 1 */<BR>(condatos(Mavi.DM0169FiltroAval) )<BR>  ENTONCES<BR>          SI (Mavi.DM0169FiltroAval = <T>No hay Coincidencias<T>)   /* 2 */<BR>             entonces<BR>             informacion(<T>No hay coincidencias. Intente asignar aval manualmente<T>)<BR>             sino    /* 2 */<BR><BR>                 asigna(Info.Competencia,SQL(<T>EXEC SP_MAVIDM0169INSERTAVALCLIENTE :tProspACliente,:tFiltroAval,:tInformacion,:tUser<T>,Info.ProspectoACambiar,Mavi.DM0169FiltroAval,<T>Informacion<T>,Usuario))<BR>                   caso Info.Competencia<BR>                   es <T>No hay un cliente registrado a quien insertar aval<T><BR>                   entonces<BR>                   Informacion(<T>No hay un cliente registrado a quien insertar aval<T>)<BR>                   es <T>Seleccione un<CONTINUA>
EjecucionCondicion002=<CONTINUA> aval para ligar<T><BR>                   entonces<BR>                   Informacion(<T>Seleccione un aval para ligar<T>)<BR>                   es <T>El cliente que quiere seleccionar como aval no existe<T><BR>                   entonces<BR>                   Informacion(<T>El cliente que quiere seleccionar como aval no existe<T>)<BR>                   sino<BR>                   verdadero                                       <BR>                   fin<BR>                             <BR><BR><BR>            fin    /* 2 */<BR><BR> SINO     /* 1 */<BR>      INFORMACION(<T>Seleccione Aval<T>)<BR> FIN     /* 1 */
[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=condatos(Mavi.DM0169FiltroAval)
EjecucionMensaje=Seleccione aval del cliente.
[(Variables)]
Estilo=Ficha
Clave=(Variables)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.DM0169FiltroAval
FichaEspacioEntreLineas=6
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
[Acciones.AsignactaAval]
Nombre=AsignactaAval
Boton=18
NombreDesplegar=Asigna cta Aval  
TipoAccion=Controles Captura
ClaveAccion=Documento Abrir
Activo=S
Visible=S
NombreEnBoton=S
EnBarraAcciones=S
EspacioPrevio=S
Multiple=S
ListaAccionesMultiples=exec<BR>cerrar
[(Variables).Mavi.DM0169FiltroAval]
Carpeta=(Variables)
Clave=Mavi.DM0169FiltroAval
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.AsignactaAval.exec]
Nombre=exec
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
ConCondicion=S
Expresion=Asigna(Info.dialogo,SQL(<T>Exec SP_MAVIDM0169GeneracionCuentaAval :tProspACliente,:tValida,:tUSr<T>,Info.ProspectoACambiar,<T>Inserta<T>,Usuario))<BR>Informacion(Info.dialogo)
EjecucionCondicion=si<BR>(<BR>(SQL(<T>Exec SP_MAVIDM0169GeneracionCuentaAval :tProspACliente,:tValida,:tuser<T>,Info.ProspectoACambiar,<T>NoInserta<T>,Usuario)) = <T>El Aval ya es cliente.. seleccionarlo de coincidencias<T>)<BR>entonces<BR>        informacion(<T>El Aval ya es cliente.. seleccionarlo de coincidencias<T>)<BR>sino                                                                                                              <BR>verdadero<BR>fin
[Acciones.AsignactaAval.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


