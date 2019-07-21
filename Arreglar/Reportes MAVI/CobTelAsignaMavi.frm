[Forma]
Clave=CobTelAsignaMavi
Nombre=Asignacion de la Cobranza Telefonica
Icono=407
Modulos=(Todos)
ListaCarpetas=CobTelAsignaMavi<BR>CobTelAsignaDMavi
CarpetaPrincipal=CobTelAsignaMavi
DialogoAbrir=S
PosicionInicialAlturaCliente=803
PosicionInicialAncho=492
PosicionInicialIzquierda=394
PosicionInicialArriba=93
FiltrarFechasSinHora=S
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=NuevaA<BR>Abri<BR>Nuevo<BR>Conclu<BR>Cancela<BR>Repo<BR>Cierra<BR>Aceptar<BR>Cancelar
PosicionSec1=174
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaAvanzaTab=S
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=EjecutarSQL(<T>Exec SP_CobTelBorraAsignacionesNulasMavi<T>)
[CobTelAsignaMavi]
Estilo=Ficha
Clave=CobTelAsignaMavi
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=CobTelAsignaMavi
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
ListaEnCaptura=MovID<BR>CobTelAsignacionMavi.FechaEmision<BR>CobTelAsignacionMavi.FechaFinal<BR>CobTelAsignacionMavi.Estatus<BR>CobTelAsignacionMavi.Usuario<BR>CobTelAsignacionMavi.Vigente
CarpetaVisible=S
GuardarAlSalir=S
[CobTelAsignaMavi.MovID]
Carpeta=CobTelAsignaMavi
Clave=MovID
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[CobTelAsignaMavi.CobTelAsignacionMavi.FechaEmision]
Carpeta=CobTelAsignaMavi
Clave=CobTelAsignacionMavi.FechaEmision
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=20
[CobTelAsignaMavi.CobTelAsignacionMavi.Estatus]
Carpeta=CobTelAsignaMavi
Clave=CobTelAsignacionMavi.Estatus
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[CobTelAsignaMavi.CobTelAsignacionMavi.Usuario]
Carpeta=CobTelAsignaMavi
Clave=CobTelAsignacionMavi.Usuario
Editar=N
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=N
[CobTelAsignaMavi.CobTelAsignacionMavi.Vigente]
Carpeta=CobTelAsignaMavi
Clave=CobTelAsignacionMavi.Vigente
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[CobTelAsignaMavi.CobTelAsignacionMavi.FechaFinal]
Carpeta=CobTelAsignaMavi
Clave=CobTelAsignacionMavi.FechaFinal
Editar=N
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=20
LineaNueva=S
[(Carpeta Abrir)]
Estilo=Iconos
Clave=(Carpeta Abrir)
BusquedaRapidaControles=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Vista=CobTelAsignaMavi
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=Asignacion
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=CobTelAsignacionMavi.FechaEmision<BR>CobTelAsignacionMavi.Estatus<BR>CobTelAsignacionMavi.Vigente<BR>CobTelAsignacionMavi.FechaFinal
FiltroEstatus=S
FiltroFechas=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasCampo=CobTelAsignacionMavi.FechaEmision
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaRespetarFiltros=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaAncho=20
BusquedaEnLinea=S
CarpetaVisible=S
FiltroUsuarioDefault=(Todos)
FiltroListaEstatus=(Todos)<BR>CANCELADO<BR>PENDIENTE<BR>CONCLUIDO
BusquedaAutoAsterisco=S
IconosNombre=CobTelAsignaMavi:MovID
[(Carpeta Abrir).CobTelAsignacionMavi.FechaEmision]
Carpeta=(Carpeta Abrir)
Clave=CobTelAsignacionMavi.FechaEmision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).CobTelAsignacionMavi.Estatus]
Carpeta=(Carpeta Abrir)
Clave=CobTelAsignacionMavi.Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).CobTelAsignacionMavi.Vigente]
Carpeta=(Carpeta Abrir)
Clave=CobTelAsignacionMavi.Vigente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).CobTelAsignacionMavi.FechaFinal]
Carpeta=(Carpeta Abrir)
Clave=CobTelAsignacionMavi.FechaFinal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).Columnas]
0=-2
1=90
2=81
3=48
4=-2
[Acciones.Nuevo]
Nombre=Nuevo
Boton=59
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Documento Nuevo Usando
Multiple=S
ListaAccionesMultiples=Exe<BR>Abri
DocNuevo=S
NombreEnBoton=S
NombreDesplegar=Generar Asignacion
ConCondicion=S
EjecucionConError=S
Visible=S
GuardarAntes=S
ActivoCondicion=CobTelAsignaMavi:CobTelAsignacionMavi.Estatus=<T>PENDIENTE<T> o vacio(CobTelAsignaMavi:CobTelAsignacionMavi.Estatus)
EjecucionCondicion=(Vacio(CobTelAsignaMavi:CobTelAsignacionMavi.Estatus) o (CobTelAsignaMavi:CobTelAsignacionMavi.Estatus=<T>PENDIENTE<T> ))
EjecucionMensaje=<T>Genere una Nueva Asignación<T>
[Acciones.Nuevo.Exe]
Nombre=Exe
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=EjecutarSQLAnimado(<T>Exec SP_GeneraAsignacionCobTelMavi <T>&Comillas(Usuario)&<T>, <T>&CobTelAsignaMavi:CobTelAsignacionMavi.ID)
[Acciones.Nuevo.Abri]
Nombre=Abri
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[CobTelAsignaDMavi]
Estilo=Hoja
Clave=CobTelAsignaDMavi
Detalle=S
PermiteEditar=S
GuardarAlSalir=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=CobTelAsignaDMavi
Fuente={Tahoma, 8, Negro, []}
VistaMaestra=CobTelAsignaMavi
LlaveLocal=CobTelAsignacionDMavi.ID
LlaveMaestra=CobTelAsignacionMavi.ID
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaTitulosEnBold=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=CobTelAsignacionDMavi.Cliente<BR>CobTelAsignacionDMavi.Saldo<BR>CobTelAsignacionDMavi.DiaVencimiento<BR>NivelCobranzaTelMavi.Nombre<BR>CobTelAsignacionDMavi.Equipo
CarpetaVisible=S
OtroOrden=S
ListaOrden=NivelCobranzaTelMavi.Nivel<TAB>(Acendente)<BR>CobTelAsignacionDMavi.Cliente<TAB>(Acendente)
[CobTelAsignaDMavi.CobTelAsignacionDMavi.Cliente]
Carpeta=CobTelAsignaDMavi
Clave=CobTelAsignacionDMavi.Cliente
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[CobTelAsignaDMavi.CobTelAsignacionDMavi.Saldo]
Carpeta=CobTelAsignaDMavi
Clave=CobTelAsignacionDMavi.Saldo
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[CobTelAsignaDMavi.CobTelAsignacionDMavi.DiaVencimiento]
Carpeta=CobTelAsignaDMavi
Clave=CobTelAsignacionDMavi.DiaVencimiento
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[CobTelAsignaDMavi.CobTelAsignacionDMavi.Equipo]
Carpeta=CobTelAsignaDMavi
Clave=CobTelAsignacionDMavi.Equipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[CobTelAsignaDMavi.Columnas]
Cliente=64
Saldo=83
DiaVencimiento=92
Equipo=64
Nombre=113
[CobTelAsignaDMavi.NivelCobranzaTelMavi.Nombre]
Carpeta=CobTelAsignaDMavi
Clave=NivelCobranzaTelMavi.Nombre
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.NuevaA]
Nombre=NuevaA
Boton=1
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Documento Nuevo
Activo=S
Visible=S
NombreDesplegar=Nueva Asignacion
[Acciones.Conclu]
Nombre=Conclu
Boton=7
NombreEnBoton=S
NombreDesplegar=Concluye Asignacion
RefrescarDespues=S
EnBarraHerramientas=S
TipoAccion=Expresion
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=EjecutarSQLAnimado(<T>Exec SP_AsignaCobranzaTel <T>&CobTelAsignaMavi:CobTelAsignacionMavi.ID&<T>, <T>&Comillas(<T>CONCLUYE<T>))
ActivoCondicion=CobTelAsignaMavi:CobTelAsignacionMavi.Estatus =<T>PENDIENTE<T>
EjecucionCondicion=CobTelAsignaMavi:CobTelAsignacionMavi.Estatus <><T>CONCLUIDO<T>
EjecucionMensaje=<T>No es posible Concluir una asignación previamente concluida...<T>
[Acciones.Cancela]
Nombre=Cancela
Boton=33
NombreDesplegar=Cancela Asignacion
EnBarraHerramientas=S
TipoAccion=Expresion
Visible=S
RefrescarDespues=S
ConCondicion=S
EjecucionConError=S
Expresion=EjecutarSQLAnimado(<T>Exec SP_AsignaCobranzaTel <T>&CobTelAsignaMavi:CobTelAsignacionMavi.ID&<T>, <T>&Comillas(<T>CANCELA<T>))
ActivoCondicion=CobTelAsignaMavi:CobTelAsignacionMavi.Estatus=<T>PENDIENTE<T>
EjecucionCondicion=CobTelAsignaMavi:CobTelAsignacionMavi.Estatus <><T>CONCLUIDO<T>
EjecucionMensaje=<T>No es posible cancelar una asignación previamente concluida...<T>
[Acciones.Abri]
Nombre=Abri
Boton=2
NombreDesplegar=Abrir
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Documento Abrir
Activo=S
Visible=S
[Acciones.Repo]
Nombre=Repo
Boton=6
EnBarraHerramientas=S
TipoAccion=Reportes Pantalla
ClaveAccion=CobTelAsignacionResumenMavi
Activo=S
Visible=S
ListaParametros1=CobTelAsignaMavi:CobTelAsignacionMavi.ID
ListaParametros=S
Antes=S
AntesExpresiones=Asigna(Info.ID,CobTelAsignaDMavi:CobTelAsignacionDMavi.ID)
[Acciones.Cierra]
Nombre=Cierra
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
GuardarAntes=S
Multiple=S
ListaAccionesMultiples=Expre
[Acciones.Cierra.Expre]
Nombre=Expre
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si Vacio(CobTelAsignaMavi:CobTelAsignacionMavi.Estatus) Entonces<BR>    informacion(CobTelAsignaMavi:CobTelAsignacionMavi.ID)<BR>    EjecutarSQL(<T>Exec SP_AsignaCobranzaTel <T>& CobTelAsignaMavi:CobTelAsignacionMavi.ID &<T>, <T>&Comillas(<T>ELIMINAR<T>))<BR>    Forma.Accion(<T>Aceptar<T>)<BR>Sino<BR>    Si CobTelAsignaMavi:CobTelAsignacionMavi.Estatus=<T>PENDIENTE<T> Entonces<BR>        Si Dialogo(<T>MaviGuardaCambiosDlg<T>) Entonces<BR>            Forma.Accion(<T>Aceptar<T>)<BR>        Sino Forma.Accion(<T>Cancelar<T>)<BR>        Fin<BR>    Sino Forma.Accion(<T>Aceptar<T>)<BR>    Fin<BR>Fin
[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreDesplegar=Acepta
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
[Acciones.Cancelar]
Nombre=Cancelar
Boton=0
NombreDesplegar=Cancelar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cancelar
Activo=S

