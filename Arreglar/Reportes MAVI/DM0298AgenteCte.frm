[Forma]
Clave=DM0298AgenteCte
Nombre=Clientes del Agente
Icono=0
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>ImportarExcel<BR>Cerrar
PosicionInicialIzquierda=405
PosicionInicialArriba=203
PosicionInicialAltura=350
PosicionInicialAncho=555
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=Centrado
Comentarios=Lista(Info.Agente, Info.Nombre)
PosicionInicialAlturaCliente=323
VentanaEstadoInicial=Normal
VentanaSinIconosMarco=S
ExpresionesAlMostrar=Asigna(Info.Cliente, Nulo)<BR>//Asigna(Info.Agente,<T>EQVDIM01<T>)<BR>Asigna(Info.Numero,nulo)

[Lista]
Estilo=Hoja
Clave=Lista
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0298AgenteCte
Fuente={MS Sans Serif, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DM0298AgenteCte.Cliente<BR>Cte.Nombre<BR>DM0298AgenteCte.Comision<BR>DM0298AgenteCte.Empresa
CarpetaVisible=S
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=Todo
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
FiltroGeneral=DM0298AgenteCte.Agente=<T>{Info.Agente}<T>

[Lista.DM0298AgenteCte.Cliente]
Carpeta=Lista
Clave=DM0298AgenteCte.Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Cte.Nombre]
Carpeta=Lista
Clave=Cte.Nombre
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.Aceptar]
Nombre=Aceptar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar y cerrar
GuardarAntes=S
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=Asigna(Info.Dialogo,CampoEnLista(DM0298AgenteCte:DM0298AgenteCte.Cliente))<BR>RegistrarLista(Info.dialogo)<BR><BR><BR>Asigna(Info.ABC,SQLEnLista(<T>EXEC SP_DM0298ValidacionClientesDIMAS :nEstacion, :tAgente <T>,EstacionTrabajo,Info.Agente))<BR><BR>Asigna(Info.Campo,Medio(Info.ABC,0,1))<BR><BR>  Caso  Info.Campo<BR>  Es <T>0<T> Entonces SQL(<T>EXEC SP_DM0298ImportacionClientesDIMAS :nEstacion1, :tAgente, :tUsuario<T>,Estaciontrabajo,Info.Agente,Usuario) informacion(<T>Datos guardados Correctamente<T>)                                 <BR>  Es <T>1<T> Entonces informacion(Info.ABC)abortaroperacion<BR>  ES <T>2<T> Entonces Informacion(<T>Los siguientes no son Clientes DIMA: <T>+Ascii(10)+Medio(Lista(Info.ABC),1,longitud(Info.ABC)))abortaroperacion<BR>  ES <T>3<T> Entonces Informacion(<T>Los si<CONTINUA>
EjecucionCondicion002=<CONTINUA>guientes Clientes DIMA no cuentan con el minimo de antigüedad: <T>+Ascii(10)+Lista(Info.ABC)))abortaroperacion<BR><BR>  Fin

[Lista.Columnas]
Cliente=116
Nombre=285
Comision=59
Empresa=63

[Lista.DM0298AgenteCte.Comision]
Carpeta=Lista
Clave=DM0298AgenteCte.Comision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Lista.DM0298AgenteCte.Empresa]
Carpeta=Lista
Clave=DM0298AgenteCte.Empresa
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=5
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.ImportarExcel]
Nombre=ImportarExcel
Boton=115
NombreEnBoton=S
NombreDesplegar=Importar a Excel
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Enviar/Recibir Excel
Activo=S
Visible=S

[Acciones.Cerrar.Cancelar Cambios]
Nombre=Cancelar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S
[Acciones.Cerrar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=5
NombreDesplegar=Cerrar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Cancelar Cambios<BR>Cerrar
Activo=S
Visible=S
NombreEnBoton=S
