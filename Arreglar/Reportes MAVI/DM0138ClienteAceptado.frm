
[Forma]
Clave=DM0138ClienteAceptado
Icono=0
Modulos=(Todos)

ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=131
PosicionInicialAncho=288
SinTransacciones=S
PosicionInicialIzquierda=493
PosicionInicialArriba=299
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=(Lista)
PosicionSec1=243
PosicionSec2=461
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Mavi.DM0138ValidaNomina, <T><T>)<BR>Asigna(Mavi.DM0138ValidaRFC, <T><T>)<BR>Asigna(Mavi.DM0138ValidaCargo, <T><T>)<BR>Asigna(Mavi.DM0138ValidaCond, <T>Falso<T>)
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
ListaEnCaptura=(Lista)

CarpetaVisible=S
FichaEspacioEntreLineas=12
FichaEspacioNombres=0
FichaColorFondo=Plata

PermiteEditar=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaEspacioNombresAuto=S
FichaAlineacionDerecha=S



[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Aceptar
Visible=S






Activo=S
ConCondicion=S
EjecucionCondicion=Si<BR>  Mavi.DM0138ValidaCond=<T>Verdadero<T><BR>Entonces<BR>  verdadero<BR>Sino<BR>  informacion(<T>Es necesario validar primero<T>)<BR>Fin
EjecucionMensaje=Es necesario validar primero
[Acciones.Aceptar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S


[Lista.Columnas]
Cliente=64
Nombre=293
Tipo=94








[Acciones.Validar.Validar]
Nombre=Validar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Si<BR>  SQL(<T>SELECT COUNT(NOMBRE) FROM TablaStD WITH(NOLOCK) WHERE TablaSt = :tTab AND Valor = :tp AND Nombre = :tNom <T>, <T>CANALES VENTA PRESUPUESTAL<T>, <T>P<T>, Info.ClaveDeCanal) > 0<BR>Entonces<BR>      Si<BR>        (SQL(<T>SELECT COUNT(Cargo) FROM CteEnviarA WITH(NOLOCK) WHERE Cliente =:tCli and Cargo =:tNom <T>, Info.Clave, Mavi.DM0138ValidaCargo) <  1)<BR>        o (SQL(<T>SELECT COUNT(RFCInstitucion) FROM CteEnviarA WITH(NOLOCK) WHERE Cliente =:tCli and RFCInstitucion =:tNom <T>, Info.Clave, Mavi.DM0138ValidaRFC) <  1)<BR>      Entonces<BR>        Informacion( <T>EL RFC Y LA CLAVE PRESUPUESTAL NO COINCIDEN<T> )<BR>        Asigna(Mavi.DM0138ValidaCond, <T>Falso<T>)<BR>      Sino<BR>        Asigna(Mavi.DM0138ValidaCond, <T>Verdadero<T>)<BR>      Fin<BR>Sino<BR>  Si<BR>    SQL(<T>SELECT PorRFCNomina FROM VentasCanalMAVI WITH(NOLOCK) WHERE ID =:tId<T>, Info.ClaveDeCanal) =<T>N<T> <BR>  Entonces<BR>    Si<BR>      SQL(<T>SELECT COUNT(Nomina) FROM CteEnviarA WITH(NOLOCK) WHERE Cliente =:tCli and Nomina =:tNom <T>, Info.Clave, Mavi.DM0138ValidaNomina) <  1<BR>    Entonces<BR>      Informacion( <T>EL NÚMERO DE NÓMINA NO COINCIDE<T> )<BR>      Asigna(Mavi.DM0138ValidaCond, <T>Falso<T>)<BR>    Sino<BR>      Asigna(Mavi.DM0138ValidaCond, <T>Verdadero<T>)<BR>    Fin<BR>  Sino<BR>    Si<BR>      SQL(<T>SELECT PorRFCNomina FROM VentasCanalMAVI WITH(NOLOCK) WHERE ID =:tId<T>, Info.ClaveDeCanal) =<T>R<T><BR>    Entonces<BR>      Si<BR>        SQL(<T>SELECT COUNT(RFCInstitucion) FROM CteEnviarA WITH(NOLOCK) WHERE Cliente =:tCli and RFCInstitucion =:tNom <T>, Info.Clave, Mavi.DM0138ValidaRFC) <  1<BR>      Entonces<BR>        Informacion( <T>EL RFC DE INSTITUCIÓN NO COINCIDE<T> )<BR>        Asigna(Mavi.DM0138ValidaCond, <T>Falso<T>)<BR>      Sino<BR>        Asigna(Mavi.DM0138ValidaCond, <T>Verdadero<T>)<BR>      Fin<BR>    Sino<BR>      Asigna(Mavi.DM0138ValidaCond, <T>Verdadero<T>)<BR>    Fin<BR>  Fin<BR>Fin
[Acciones.Validar]
Nombre=Validar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Validar
Multiple=S
EnBarraHerramientas=S
TipoAccion=Expresion
ListaAccionesMultiples=(Lista)
Activo=S
Visible=S











[Acciones.Validar.Var]
Nombre=Var
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S




[Acciones.Aceptar.Ac]
Nombre=Ac
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S




[Detalle.Columnas]
Aplica=100
AplicaID=64
AplicaNombre=116
Codigo=97
Articulo=87
SubCuenta=99
ClaveIdioma=74
SustitutoArticulo=76
SustitutoSubCuenta=71
Cantidad=48
CantidadNeta=47
Unidad=41
CantidadInventario=54
CantidadInvNeta=53
Horas=32
Espacio=42
Precio=77
DescuentoLinea=36
DescuentoImporte=54
PrecioMoneda=48
PrecioTipoCambio=64
FechaRequerida=88
HoraRequerida=33
Instruccion=58
ExcluirPlaneacion=36
Importe=87
PresupuestoEsp=114
ExcluirISAN=64
SubImpuesto2=72
SubImpuesto1=76
SubImpuesto3=66
EnviarA=80
Almacen=60
Posicion=64
ContUso=76
Agente=64
AgentesAsignados=44
ProveedorRef=57
AFArticulo=72
AFSerie=76
Costo=76
CostoTotal=77
Paquete=45
AutoLocalidad=68
UEN=25
DescripcionExtra=245
CantidadReservada=57
CantidadOrdenada=52
CantidadPendiente=53
ServicioNumero=54
Estado=85
CantidadA=47
TransferirA=64

[FormaAnexo.Columnas]
0=121
1=48
2=79

[MovEvento.Columnas]
0=455
1=70
2=69
3=86
4=76

[FormaExtraValor.Columnas]
VerCampo=370
VerValor=370

[(Carpeta Abrir).Columnas]
0=216
1=69
2=182
3=69
4=91
5=91
6=84
7=38
8=76


[Acciones.Aceptar.ListaAccionesMultiples]
(Inicio)=Ac
Ac=venta
venta=(Fin)

















[(Variables).Mavi.DM0138ValidaNomina]
Carpeta=(Variables)
Clave=Mavi.DM0138ValidaNomina
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).Mavi.DM0138ValidaRFC]
Carpeta=(Variables)
Clave=Mavi.DM0138ValidaRFC
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).Mavi.DM0138ValidaCargo]
Carpeta=(Variables)
Clave=Mavi.DM0138ValidaCargo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro























[(Variables).ListaEnCaptura]
(Inicio)=Mavi.DM0138ValidaNomina
Mavi.DM0138ValidaNomina=Mavi.DM0138ValidaRFC
Mavi.DM0138ValidaRFC=Mavi.DM0138ValidaCargo
Mavi.DM0138ValidaCargo=(Fin)












[Acciones.Validar.ListaAccionesMultiples]
(Inicio)=Var
Var=Validar
Validar=(Fin)

[Forma.ListaAcciones]
(Inicio)=Validar
Validar=Aceptar
Aceptar=(Fin)


