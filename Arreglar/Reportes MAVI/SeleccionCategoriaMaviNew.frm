[Forma]
Clave=SeleccionCategoriaMaviNew
Nombre=Canal de Venta
Icono=67
Modulos=(Todos)
CarpetaPrincipal=RM0855AGhostVis
PosicionInicialIzquierda=493
PosicionInicialArriba=435
PosicionInicialAlturaCliente=115
PosicionInicialAncho=293
AccionesTamanoBoton=15x5
ListaCarpetas=(Variables)<BR>RM0855AGhostVis
ListaAcciones=Aceptar<BR>Cerrar
AccionesCentro=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaSinIconosMarco=S
VentanaRepetir=S
VentanaBloquearAjuste=S
VentanaExclusiva=S
PosicionSec1=30
Menus=S
BarraAcciones=S
ExpresionesAlMostrar=Asigna(Info.cantidad2,nulo)<BR>Asigna(Info.CategoriaMavi,nulo)<BR>Asigna(Info.CanalVentaMavi,nulo)<BR>  Asigna(Info.UEN, SQL(<T>SELECT Uen FROM Usuario WHERE Usuario=:tusu<T>,Usuario))<BR><BR>Asigna(Info.Cliente,nulo)<BR>Asigna(MAVI.DM0116FaseC,0)
ExpresionesAlCerrar=Asigna(Info.Clase,nulo)<BR>Asigna(Info.clase1,nulo)<BR>Asigna(Info.Clase2,nulo)<BR>Asigna(Info.Clase3,nulo)<BR>Asigna(Info.Clase4,nulo)<BR>Asigna(Info.Clase5,nulo)<BR>Asigna(Info.Actividad,nulo)<BR>Asigna(Info.Observaciones,nulo)<BR>Asigna(Info.Articulo,0)<BR>Asigna(Info.ArticuloA,0)<BR>Asigna(Info.cantidad2,0)<BR>//SI(Info.ABC=nulo,Asigna(Info.cliente,Nulo))<BR>Asigna(Info.ABC,nulo)<BR>Asigna(Info.Copiar, Falso)<BR>Asigna(Info.Actualizar,nulo)<BR>Asigna(temp.Numerico1,0)<BR>Asigna(temp.Numerico2,0)<BR>Asigna(temp.Numerico3,0)<BR>Asigna(temp.Numerico4,0)<BR>Asigna(Info.Actualizar,nulo)<BR><BR><BR><BR>//informacion(Info.Cliente)
[Acciones.Hola]
Nombre=Hola
Boton=0
NombreDesplegar=Hola
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=informacion(<T>Hola<T>)
[(Variables)]
Estilo=Ficha
Clave=(Variables)
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
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
CampoColorFondo=Plata
ListaEnCaptura=Info.CanalVentaMAVI
CarpetaVisible=S
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreDesplegar=&Aceptar
TipoAccion=Formas
ClaveAccion=ClienteExpressMavi
Visible=S
NombreEnBoton=S
Multiple=S
ListaAccionesMultiples=variables Asignar<BR>calcSueldoDiario
ConCondicion=S
EjecucionConError=S
RefrescarDespues=S
EspacioPrevio=S
EnBarraAcciones=S
ActivoCondicion=MAVI.DM0116FaseC <> 1
EjecucionCondicion=Si<BR> (Info.Cliente <> nulo) y ( SQL(<T>SELECT COUNT(*) FROM RM0855ATabla_UsuariosProspecto WHERE Prospecto= :tCte And Usuario = :tus And Estacion = :nEst And Existe = :nEx<T>,Info.Cliente,Usuario, EstacionTrabajo,0 )> 0)<BR>Entonces<BR>  falso<BR>Sino<BR>  verdadero<BR>Fin
EjecucionMensaje=<T>ya esta capturando al cliente: <T>+ Info.Cliente +<T>, para capturar uno nuevo cierre la ventana.<T>
[Acciones.Aceptar.variables Asignar]
Nombre=variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.calcSueldoDiario]
Nombre=calcSueldoDiario
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=<BR>Si<BR>  info.canalventaMavi=nulo<BR>Entonces<BR>  error(<T>ES NECESARIO ELEGIR UNA CATEGORIA<T>)<BR>Sino<BR>  Asigna(Info.CategoriaMavi, SQL(<T>SELECT Categoria FROM VentasCanalMAVI WHERE ID=<T>&info.canalventaMavi))<BR>   Asigna(Info.UEN, SQL(<T>SELECT Uen FROM Usuario WHERE Usuario=:tusu<T>,Usuario))<BR>   //Asigna(Info.UEN, SQL(<T>SELECT Uen FROM Usuario WHERE Usuario=:tusu<T>,<T>VENTP00123<T>))<BR>Fin<BR><BR>Si<BR>  info.canalventaMavi<>nulo<BR>Entonces<BR>    Si<BR>     SQL(<T>SELECT Uen FROM ventascanalmavi WHERE id=:tusu<T>,info.canalventaMavi)<>Info.UEN<BR>    Entonces<BR>      error(<T>ES NECESARIO ELEGIR UNA CATEGORIA VALIDA<T>)<BR>    Sino<BR>      Si<BR>          (Info.CategoriaMavi en(<T>INSTITUCIONES<T>,<T>CREDITO MENUDEO<T>,<T>CONTADO<T>,<T>ASOCIADOS<T>,<T>MAYOREO<T>))<BR>      entonc<CONTINUA>
Expresion002=<CONTINUA>es<BR>          Asigna(Info.Cliente,SQL(<T>SP_GeneraConsecutivoCteMavi :tEmpresa<T>,Empresa))<BR>          Reemplaza( <T> <T>, <T><T>,Info.Cliente )<BR>          //Asigna(Info.Cliente,SQL(<T>SP_GeneraConsecutivoCteMavi :tEmpresa<T>,<T>MAVI<T>))<BR>Asigna(MAVI.DM0116FaseC,1)<BR>ActualizarForma<BR>          Ejecutar(<T>PlugIns\ClienteExpress\ClienteExpress.exe <T>+info.canalventaMavi+<T> <T>+ Reemplaza( <T> <T>, <T>_<T>, Info.CategoriaMavi ) +<T> <T>+ EstacionTrabajo+<T> <T>+ Empresa+ <T> <T>+ Sucursal +<T> <T>+Usuario+<T> <T>+Info.Cliente )<BR><BR>      sino<BR>          forma(<T>ClienteExpressMavi<T>)<BR>      fin<BR>    Fin<BR>Fin
[Acciones.cerra.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Cerrar.expresion]
Nombre=expresion
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=Si<BR> SQL(<T>SELECT COUNT(*) FROM RM0855ATabla_UsuariosProspecto WHERE Prospecto= :tCte And Usuario = :tus And Estacion = :nEst and Existe = :nEx<T>,Info.Cliente,Usuario, EstacionTrabajo,0 )> 0<BR>Entonces<BR> informacion(<T>Debe de guardar la Captura ó cerrar la Captura de Cliente Express<T>)<BR>Sino<BR><BR>EjecutarSQLAnimado( <T>SP_RM0855A_GuardaProspecto :tUs, :tCte,:nEst, :tHa, :nEx <T> ,Usuario,info.cliente,EstacionTrabajo,<T>Borrar<T> ,0)<BR><BR>Fin
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreDesplegar=Cerrar
Multiple=S
ListaAccionesMultiples=expresion<BR>cerrar
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S
EnBarraAcciones=S
[(Variables).Info.CanalVentaMAVI]
Carpeta=(Variables)
Clave=Info.CanalVentaMAVI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Plata
ColorFuente=Negro
[Acciones.Cerrar.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=Ventana
Activo=S
Visible=S
ClaveAccion=Cerrar
ConCondicion=S
EjecucionCondicion=Si<BR> SQL(<T>SELECT COUNT(*) FROM RM0855ATabla_UsuariosProspecto WHERE Prospecto= :tCte And Usuario = :tus And Estacion = :nEst And Existe = :nEx<T>,Info.Cliente,Usuario, EstacionTrabajo,0 )= 0<BR>Entonces<BR>  verdadero<BR><BR>sino<BR>  falso<BR><BR>Fin
[RM0855AGhostVis]
Estilo=Ficha
Clave=RM0855AGhostVis
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0855AGhostVis
Fuente={Tahoma, 8, Negro, []}
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
CampoColorLetras=Negro
CampoColorFondo=Negro


