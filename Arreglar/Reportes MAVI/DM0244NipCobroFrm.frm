[Forma]
Clave=DM0244NipCobroFrm
Nombre=Nip de Cobro
Icono=126
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=495
PosicionInicialArriba=449
PosicionInicialAlturaCliente=88
PosicionInicialAncho=289
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Acept
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaExclusiva=S
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(Mavi.DM0244NipCobro,<T><T>)
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
ListaEnCaptura=Mavi.DM0244NipCobro
CarpetaVisible=S
[Acciones.Acept.control]
Nombre=control
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Acept.exp]
Nombre=exp
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Clave,SQL(<T>Select NIP_Cobro From IntelisisTMP.dbo.DM0244_CLAVES  Where Cuenta=:tCte<T>,Info.Acreditado))<BR>Asigna(Mavi.DM0244GuardaNipGen,Mavi.DM0244NipCobro)<BR>Asigna(Mavi.DM0244NipCobro,MD5(Mavi.DM0244NipCobro,<T>p<T>))<BR>Asigna(Mavi.DM0244IndicaAccion, nulo)<BR><BR><BR>Si ConDatos(Info.Respuesta1)<BR>    Entonces<BR>    caso Info.Respuesta1<BR>    Es(<T>Cliente<T>)<BR>        Entonces<BR>            Si<BR>              (Info.Clave=Mavi.DM0244NipCobro) o (Mavi.DM0244GuardaNipGen = SQL(<T>SELECT valor FROM TABLASTD WHERE tablaST = :tTablaST <T>,<T>COBRO AVAL/CLIENTE FINAL<T>))<BR>            Entonces<BR>                Asigna(Info.Respuesta4,<T>Cliente<T>)<BR>                Asigna(Mavi.DM0244IndicaAccion, <T>Cerrar<T>)<BR>                Forma(<T>NegociaMoratoriosMavi<T>)<BR>   <CONTINUA>
Expresion002=<CONTINUA>         Sino<BR>              Error(<T>NIP No Valido<T>)<BR>            Fin                                                        <BR>    Es(<T>Dima<T>)<BR>        Entonces<BR>            Si<BR>              (Info.Clave=Mavi.DM0244NipCobro) o (Mavi.DM0244GuardaNipGen = SQL(<T>SELECT valor FROM TABLASTD WHERE tablaST = :tTablaST <T>,<T>COBRO AVAL/CLIENTE FINAL<T>))<BR>            Entonces<BR>                Asigna(Info.Respuesta4,<T>Dima<T>)<BR>                Asigna(Mavi.DM0244IndicaAccion, <T>Cerrar<T>)<BR>                Forma(<T>NegociaMoratoriosMavi<T>)<BR>            Sino<BR>              Error(<T>NIP No Valido<T>)<BR>            Fin<BR>     Es(<T>Cliente final<T>)<BR>        Entonces<BR>            Si<BR>              (Info.Clave=Mavi.DM0244NipCobro) o (Mavi.DM0244GuardaNipGen = SQ<CONTINUA>
Expresion003=<CONTINUA>L(<T>SELECT valor FROM TABLASTD WHERE tablaST = :tTablaST <T>,<T>COBRO AVAL/CLIENTE FINAL<T>))<BR>            Entonces<BR>                Asigna(Info.Respuesta4,<T>Cliente final<T>)<BR>                Asigna(Mavi.DM0244IndicaAccion, <T>Cerrar<T>)<BR>                Forma(<T>NegociaMoratoriosMavi<T>)<BR>            Sino<BR>              Error(<T>NIP No Valido<T>)<BR>            Fin<BR>    Sino<BR>        Falso<BR>  Fin<BR>Sino<BR>    Si<BR>      (Info.Clave=Mavi.DM0244NipCobro) o (Mavi.DM0244GuardaNipGen = SQL(<T>SELECT valor FROM TABLASTD WHERE tablaST = :tTablaST <T>,<T>COBRO AVAL/CLIENTE FINAL<T>))<BR>    Entonces<BR>      Asigna(Mavi.DM0244IndicaAccion, <T>Cerrar<T>)<BR>      Forma(<T>NegociaMoratoriosMavi<T>)<BR>    Sino<BR>      Error(<T>NIP No Valido<T>)<BR>    Fin                   <CONTINUA>
Expresion004=<CONTINUA>                       <BR>Fin
[Acciones.Acept]
Nombre=Acept
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=control<BR>exp<BR>cerrar
Activo=S
Visible=S
[(Variables).Mavi.DM0244NipCobro]
Carpeta=(Variables)
Clave=Mavi.DM0244NipCobro
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Pegado=S
[Acciones.Acept.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
ConCondicion=S
Visible=S
EjecucionCondicion=Mavi.DM0244IndicaAccion  = <T>Cerrar<T>

