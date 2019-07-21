[Forma]
Clave=DM0244PreNipCobroFrm
Nombre=Realizar el cobro
Icono=126
Modulos=(Todos)
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar
PosicionInicialAlturaCliente=80
PosicionInicialAncho=280
PosicionInicialIzquierda=500
PosicionInicialArriba=453
VentanaExclusiva=S
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(Mavi.DM0244NipCobro,<T><T>)<BR>Asigna(Info.Respuesta1,Nulo)<BR>Asigna(Info.Respuesta2,Nulo)
ExpresionesAlCerrar=Asigna(Mavi.DM0244ListaAvales,Nulo)<BR>Asigna(Mavi.DM0244TipoClienteCobros,Nulo)<BR>Asigna(Mavi.DM0244NipCobro,Nulo)
[(Variables)]
Estilo=Ficha
Clave=(Variables)
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
ListaEnCaptura=Mavi.DM0244TipoClienteCobros
CarpetaVisible=S
PermiteEditar=S
[(Variables).Mavi.DM0244TipoClienteCobros]
Carpeta=(Variables)
Clave=Mavi.DM0244TipoClienteCobros
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Pegado=S
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
EnBarraHerramientas=S
Activo=S
Visible=S
NombreEnBoton=S
NombreDesplegar=&Aceptar
Multiple=S
EspacioPrevio=S
ListaAccionesMultiples=control<BR>exp<BR>cerrar
[Acciones.Aceptar.control]
Nombre=control
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.exp]
Nombre=exp
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.DM0244IndicaAccion, nulo)<BR><BR>Si<BR>    ConDatos(Info.Respuesta1)<BR>    Entonces<BR>    Caso  Info.Respuesta1<BR>    Es <T>Aval<T><BR>          Entonces                                                <BR>                Asigna(Info.Respuesta4,<T>Aval<T>)             <BR>                Asigna(Mavi.DM0244IndicaAccion,<T>Cerrar<T>)<BR>                Forma(<T>DM0244AvalesClienteFrm<T>)<BR>      Es <T>Cliente<T><BR>          Entonces<BR>            Si                                                                                       <BR>             (Info.CanalVentaMAVI = 76)<BR>            Entonces<BR>               Asigna(Mavi.DM0244IndicaAccion,<T>Cerrar<T>)<BR>               Forma(<T>DM0244NipCobroFrm<T>)<BR>            Sino<BR>               Asigna(Mavi.DM0244IndicaAcc<CONTINUA>
Expresion002=<CONTINUA>ion,<T>Cerrar<T>)<BR>               Asigna(Info.Respuesta4,<T>Cliente<T>)<BR>               Forma(<T>NegociaMoratoriosMavi<T>)<BR>            Fin<BR>      Es <T>Dima<T><BR>          Entonces<BR>            Si<BR>             (Info.CanalVentaMAVI = 76)<BR>            Entonces<BR>               Asigna(Mavi.DM0244IndicaAccion,<T>Cerrar<T>)<BR>               Forma(<T>DM0244NipCobroFrm<T>)<BR>            Sino<BR>               Asigna(Mavi.DM0244IndicaAccion,<T>Cerrar<T>)<BR>               Asigna(Info.Respuesta4,<T>Dima<T>)<BR>               Forma(<T>NegociaMoratoriosMavi<T>)<BR>            Fin<BR><BR>      Es <T>Cliente final<T>  <BR>          Entonces<BR>              Si<BR>               (Info.CanalVentaMAVI = 76)<BR>             Entonces<BR>               Asigna(Mavi.DM0244IndicaAccion,<T>Ce<CONTINUA>
Expresion003=<CONTINUA>rrar<T>)<BR>               Forma(<T>DM0244NipCobroFrm<T>)<BR>             Sino<BR>               Asigna(Info.Respuesta4,<T>Cliente final<T>)<BR>               Asigna(Mavi.DM0244IndicaAccion,<T>Cerrar<T>)<BR>               Forma(<T>NegociaMoratoriosMavi<T>)<BR>             Fin<BR>               Si<BR>                   ConDatos(Info.Respuesta2)<BR>               Entonces<BR>                   Asigna(Info.Respuesta2,nulo)<BR>               Sino<BR>                  Falso<BR>               Fin<BR>      Sino<BR>      Falso                                                                                                            <BR>    Fin<BR>Sino<BR>    Error(<T>Seleccione un tipo de cobro<T>)<BR>Fin
[Acciones.Aceptar.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
ConCondicion=S
Visible=S
EjecucionCondicion=Mavi.DM0244IndicaAccion  = <T>Cerrar<T>

