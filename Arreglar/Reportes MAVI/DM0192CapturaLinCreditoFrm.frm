[Forma]
Clave=DM0192CapturaLinCreditoFrm
Icono=0
Modulos=(Todos)
Nombre=Captura Linea Credito Inicial
ListaCarpetas=(Variables)<BR>autorizacionespecial
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=91
PosicionInicialAncho=363
PosicionInicialIzquierda=498
PosicionInicialArriba=319
BarraAcciones=S
AccionesTamanoBoton=15x5
AccionesCentro=S
ListaAcciones=Aceptar<BR>Cerrar
AccionesDivision=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaSinIconosMarco=S
ExpresionesAlMostrar=asigna(Mavi.DM0192SelImporte,nulo)
ExpresionesAlCerrar=SI condatos(Mavi.DM0192SelImporte) Y Mavi.DM0192CERRAR=verdadero<BR>  ENTONCES<BR>  ASIGNA(Mavi.DM0192CERRAR,FALSO)<BR>   SINO<BR>       Si vacio(Mavi.DM0192SelImporte)<BR>       entonces<BR>       INFORMACION(<T>Seleccione Importe Despues Presione Aceptar<T>)<BR>       sino<BR>      INFORMACION(<T>Presione Aceptar...<T>)<BR>      fin<BR>AbortarOperacion<BR>FIN<BR><BR><BR><BR>         si (sql(<T>select  top 1 mavitipoventa from Venta where Cliente =:tcli<BR>and Estatus<><T>+comillas(<T>SINAFECTAR<T>)+<BR><T>order by UltimoCambio desc<T>,Mavi.DM0192ProspACliente)=<T>Nuevo<T>)y (Mavi.DM0192CERRAR2=falso)<BR>entonces<BR>asigna(info.cliente,Mavi.DM0192ProspACliente)<BR> forma(<T>ExpRegistroCte<T>)<BR> fin
PosicionCol1=159
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
CarpetaVisible=S
ListaEnCaptura=Mavi.DM0192SelImporte
[(Variables).Mavi.DM0192SelImporte]
Carpeta=(Variables)
Clave=Mavi.DM0192SelImporte
Editar=S
LineaNueva=S
ValidaNombre=N
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Aceptar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=ASIGNA(Mavi.DM0192CERRAR,VERDADERO)<BR>SI condatos(Mavi.DM0192SelImporte)<BR>    ENTONCES<BR>    ACTUALIZARFORMA<BR>    INFORMACION(SQL(<T>EXEC SP_DM0192ActualizaLineaCreditoCte :tcte,:nlinea,:tesp<T>,Mavi.DM0192ProspACliente,Mavi.DM0192SelImporte,Mavi.DM0192LimCredEspecial))<BR>  SINO<BR>      INFORMACION(<T>Seleccione Importe<T>)<BR> ASIGNA(Mavi.DM0192CERRAR,FALSO)<BR> FIN<BR> Forma.ActualizarControles
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
Multiple=S
EnBarraAcciones=S
TipoAccion=Controles Captura
ListaAccionesMultiples=Aceptar<BR>Expresion<BR>forma
Visible=S
RefrescarDespues=S
ActivoCondicion=Mavi.DM0192CERRAR=falso
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraAcciones=S
TipoAccion=Ventana
Activo=S
Antes=S
Visible=S
ClaveAccion=Cerrar
Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>Cerrar
AntesExpresiones=Si(Precaucion(<T>Esta seguro de cerrar?<T>, BotonAceptar,BotonCancelar)=BotonCancelar, AbortarOperacion)
[Acciones.Aceptar.forma]
Nombre=forma
Boton=0
TipoAccion=formas
ClaveAccion=CuentaAvalfrm
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=Si<BR>  SQL(<T>SELECT count(Cliente) FROM CteCto With(NoLock) WHERE Tipo =<T>+comillas(<T>Aval<T>)+<T> and Cliente =<T>+comillas(Mavi.DM0192ProspACliente))> 0<BR><BR>    entonces<BR>      Verdadero<BR>    SINO<BR>        falso<BR>        INFORMACION(<T>No tiene Avales<T>)<BR><BR> FIN
[Acciones.Cerrar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Cerrar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[autorizacionespecial]
Estilo=Ficha
Clave=autorizacionespecial
InicializarVariables=S
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A2
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
ListaEnCaptura=Mavi.DM0192LimCredEspecial
CarpetaVisible=S
[autorizacionespecial.Mavi.DM0192LimCredEspecial]
Carpeta=autorizacionespecial
Clave=Mavi.DM0192LimCredEspecial
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=6
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]

