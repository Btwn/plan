[Forma]
Clave=CteExpressRelacionadofrm
Nombre=<T>Cliente Relacionado para <T> + Mavi.CteExpressProspecto
Icono=104
Modulos=(Todos)
ListaCarpetas=Cte
CarpetaPrincipal=Cte
PosicionInicialIzquierda=69
PosicionInicialArriba=55
PosicionInicialAlturaCliente=273
PosicionInicialAncho=618
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
AccionesTamanoBoton=15x5
AccionesDerecha=S
BarraHerramientas=S
ListaAcciones=Expresion
ExpresionesAlMostrar=//Asigna(Mavi.CteExpressProspecto,<T>P01499999<T>)<BR>Asigna(Mavi.CteExpressSiNo,<T>SI<T>)<BR>Si<BR>   ConDatos( Info.Cliente)<BR>Entonces<BR> Asigna( Mavi.CteExpressCuenta, SQL( <T>SELECT Cliente FROM cte WITH(NOLOCK) where Cliente = <T>+ comillas(Info.Cliente)))<BR> Asigna( Mavi.CteExpressNombre, SQL(<T>SELECT Nombre FROM cte WITH(NOLOCK) where Cliente = <T>+ comillas(Info.Cliente)))<BR> Asigna( Mavi.CteExpressDireccion, SQL(<T>SELECT Direccion +<T>+comillas(<T> <T>)+<T>+ DireccionNumero +<T>+comillas(<T> <T>)+<T>+ DireccionNumeroInt +<T>+comillas(<T> <T>)+<T>+Colonia+<T>+comillas(<T> <T>)+<T>+Delegacion+<T>+comillas(<T> <T>)+<T>+Estado AS Dir  FROM cte WITH(NOLOCK) where Cliente = <T>+ comillas(Info.Cliente)))<BR> //informacion(SQL( <T>SELECT Nombre FROM cte WITH(NOLOCK) where Cliente =<CONTINUA>
ExpresionesAlMostrar002=<CONTINUA> <T>+ comillas(Info.ClienteExpress)))<BR>Sino<BR>  informacion(<T>no tiene cuenta<T>)<BR>Fin
[Cte]
Estilo=Ficha
Clave=Cte
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=80
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.CteExpressCuenta<BR>Mavi.CteExpressNombre<BR>Mavi.CteExpressDireccion<BR>Info.ClienteExpress<BR>Mavi.CteExpressSiNo
CarpetaVisible=S
ControlRenglon=S
[Cte.Mavi.CteExpressNombre]
Carpeta=Cte
Clave=Mavi.CteExpressNombre
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=60
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Expresion]
Nombre=Expresion
Boton=7
NombreEnBoton=S
NombreDesplegar=Guardar
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>Expresion<BR>Cerrar
EjecucionCondicion=ConDatos(Mavi.CteExpressCuenta)
EjecucionMensaje=<T>no tiene un cuenta capturada<T>
[Cte.Mavi.CteExpressCuenta]
Carpeta=Cte
Clave=Mavi.CteExpressCuenta
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Cte.Mavi.CteExpressDireccion]
Carpeta=Cte
Clave=Mavi.CteExpressDireccion
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=60
ColorFondo=Blanco
ColorFuente=Negro
[Cte.Info.ClienteExpress]
Carpeta=Cte
Clave=Info.ClienteExpress
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Expresion.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Expresion.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si<BR>   ConDatos( Mavi.CteExpressCuenta ) y  ConDatos(Mavi.CteExpressNombre ) y  ConDatos( Mavi.CteExpressProspecto ) y ConDatos(Info.ClienteExpress )<BR>Entonces<BR>     Si<BR>       Confirmacion(<T>¿Desea capturar Relacionado?<T>,BotonSi, BotonNo)=Botonsi<BR>     Entonces<BR>         informacion(SQL( <T>EXEC SP_RM0855RelaiconadoIntelisis :tRe,:tPro,:tAc,:tPa,:tSN<T>,Mavi.CteExpressCuenta,Mavi.CteExpressProspecto,<T>Genera<T>,Info.ClienteExpress,Mavi.CteExpressSiNo ))<BR>          <BR>          Si<BR>            Mavi.CteExpressSiNo = <T>Si<T><BR>         Entonces<BR>             EjecutarSQLAnimado( <T>EXEC SpRM0855A_CtoConyuAvalRecomienda :tRe,:tPro,:tAc,:nid<T>,Mavi.CteExpressCuenta,Mavi.CteExpressProspecto,<T>Genera<T>,<T>0<T>)<BR>         Fin<BR>          <BR>     Fin<BR><BR><BR>Sino<<CONTINUA>
Expresion002=<CONTINUA>BR> informacion(<T>Faltan llenar campo Parentesco<T>) <BR>Fin
[Cte.Mavi.CteExpressSiNo]
Carpeta=Cte
Clave=Mavi.CteExpressSiNo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Expresion.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

