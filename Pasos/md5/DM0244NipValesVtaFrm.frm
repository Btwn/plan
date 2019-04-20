[Forma]
Clave=DM0244NipValesVtaFrm
Nombre=Nip Vales Venta
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=451
PosicionInicialArriba=280
PosicionInicialAlturaCliente=108
PosicionInicialAncho=263
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Acept
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Mavi.DM0244NipVenta,<T><T>)<BR>Asigna(Mavi.DM0244Vale,<T><T>)
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
ListaEnCaptura=(Lista)
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
Expresion=Asigna(Info.Clave,SQL(<T>Select NIP_VENTA From DM0244_CLAVES Where Cuenta=:tCte<T>,Info.Acreditado))<BR>Asigna(Mavi.DM0244Bandera,0)<BR>Asigna(Mavi.DM0244NipVenta,MD5(Mavi.DM0244NipVenta,<T>p<T>))<BR>Si                                   <BR>  Info.Clave=Mavi.DM0244NipVenta<BR>Entonces<BR>   Asigna(Info.Clave,SQL(<T>EXEC dbo.SP_DM0244ValidaVales :tCte,:tvale<T>,Info.Acreditado,Mavi.DM0244Vale))<BR>   Si<BR>        Info.Clave=1<BR>    Entonces<BR>        informacion(<T>VALE Valido<T>)<BR>        EjecutarSQL(<T>EXEC SP_DM0244ValeRelacionId :nID,:nvale<T>,Info.ID,Mavi.DM0244Vale)<BR>    Sino<BR>        Error(<T>VALE No Valido<T>)<BR>    Fin<BR>Sino<BR>  Error(<T>NIP No Valido<T>)<BR>Fin
[Acciones.Acept]
Nombre=Acept
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=control<BR>exp<BR>cerr
Activo=S
Visible=S
[Acciones.Acept.cerr]
Nombre=cerr
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Si<BR>    SQl(<T>select COUNT(*) from DM0244_FOLIOS_VALES With(NoLock) where CODIGOBARRAS = :tVal<T>,Mavi.DM0244Vale) > 0<BR>Entonces<BR>    verdadero<BR>sino<BR>    falso<BR>fin
EjecucionMensaje=<T>Ingrese Un Vale valido<T>



[(Variables).Mavi.DM0244Vale]
Carpeta=(Variables)
Clave=Mavi.DM0244Vale
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro







[(Variables).Mavi.DM0244NipVenta]
Carpeta=(Variables)
Clave=Mavi.DM0244NipVenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro




[(Variables).ListaEnCaptura]
(Inicio)=Mavi.DM0244NipVenta
Mavi.DM0244NipVenta=Mavi.DM0244Vale
Mavi.DM0244Vale=(Fin)

