[Forma]
Clave=DM0138CapturaCorreo
Nombre=Captura de Correo
Icono=60
Modulos=(Todos)
ListaCarpetas=(Variables)<BR>(Variables)2
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=141
PosicionInicialAncho=530
PosicionInicialIzquierda=375
PosicionInicialArriba=422
VentanaSiempreAlFrente=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Cerrar
PosicionSec1=57
ExpresionesAlMostrar=Asigna(Mavi.DM0138CuentaCorreo,nulo)<BR>Asigna(Mavi.DM0138DominioCorreo,nulo)<BR>Asigna(Info.Observaciones,<T>Si el cliente no cuenta con un correo electrónico, deberá capturar:<T>)<BR>Asigna(Info.Observaciones2,<T>deberá capturar: <T>)<BR>Asigna(Mavi.DM0138Arroba,<T>@<T>)
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
ListaEnCaptura=Mavi.DM0138CuentaCorreo<BR>Mavi.DM0138Arroba<BR>Mavi.DM0138DominioCorreo
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
[(Variables).Mavi.DM0138CuentaCorreo]
Carpeta=(Variables)
Clave=Mavi.DM0138CuentaCorreo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=35
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.DM0138DominioCorreo]
Carpeta=(Variables)
Clave=Mavi.DM0138DominioCorreo
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Guardar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar
Multiple=S
EnBarraHerramientas=S
TipoAccion=Expresion
ListaAccionesMultiples=Variables Asignar<BR>Guardar<BR>Cerrar
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=VariablesAsignar<BR>Cerrar
[Acciones.Guardar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[(Variables)2]
Estilo=Ficha
Clave=(Variables)2
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Plata
ListaEnCaptura=Info.Observaciones<BR>Mavi.DM0138CorreoDefault
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=229
FichaColorFondo=Plata
FichaNombres=Izquierda
[(Variables)2.Info.Observaciones]
Carpeta=(Variables)2
Clave=Info.Observaciones
Editar=S
LineaNueva=S
ValidaNombre=N
3D=N
Tamano=45
ColorFondo=Plata
ColorFuente=Negro
[(Variables)2.Mavi.DM0138CorreoDefault]
Carpeta=(Variables)2
Clave=Mavi.DM0138CorreoDefault
Editar=S
LineaNueva=N
ValidaNombre=S
Tamano=0
ColorFondo=$00F0F0F0
ColorFuente=Negro
Pegado=S
[Acciones.Guardar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=Si<BR>  Contiene(Mavi.DM0138CuentaCorreo, <T>!<T>,<T>#<T>,<T>$<T>,<T>%<T>,<T>&<T>,<T>(<T>,<T>)<T>,<T>*<T>,<T>+<T>,<T>,<T>,<T>/<T>,<T>:<T>,<T>;<T>,<T><<T>,<T>=<T>,<T>><T>,<T>?<T>,<T>[<T>,<T>\<T>,<T>]<T>,<T>^<T>,<T>{<T>,<T>}<T>,<T>~<T> )<BR>Entonces<BR>        informacion(<T>Capture un Correo Valido...<T>)<BR>        AbortarOperacion<BR><BR>Sino<BR>Si<BR>    SQL(<T>SELECT dbo.FN_DM0138ValidaCaracter(:tCuenta,:tDominio)<T>,Mavi.DM0138CuentaCorreo&<T>1<T>,Mavi.DM0138DominioCorreo&<T>1<T>)<><T>0<T><BR>Entonces<BR>    informacion(SQL(<T>SELECT dbo.FN_DM0138ValidaCaracter(:tCuenta,:tDominio)<T>,Mavi.DM0138CuentaCorreo&<T>1<T>,Mavi.DM0138DominioCorreo&<T>1<T>))<BR>    AbortarOperacion<BR>Sino<BR>    SI<BR>        SQL(<T>EXEC dbo.SP_MAVIDM0138GuardaCorreo :tCte, :tCta, :tDom<T>,Info.Cliente, Mavi.DM0138CuentaCorreo,Mavi.DM0138DominioCorreo) = <T>0<T><BR>    ENTONCES<BR>        informacion(<T>Capture un Correo Valido...<T>)<BR>        AbortarOperacion<BR>    SINO<BR>        SQL(<T>EXEC dbo.SP_MAVIDM0138HistInsertCorreo :tCliente, :tUsuario, :tSucursal, :tCorreo<T>,Info.Cliente,usuario,sucursal,Mavi.DM0138CuentaCorreo&<T>@<T>&Mavi.DM0138DominioCorreo)<BR>        EjecutarSQL(<T>EXEC SP_DM0138InsertGuardaCorreomodulo :nID, :tMod, :nUen, :tCor<T>,Info.ID,Mavi.DM0138Modulo,Info.UEN,Mavi.DM0138CuentaCorreo&<T>@<T>&Mavi.DM0138DominioCorreo)<BR>        Si<BR>            MAYUSCULAS(Mavi.DM0138CuentaCorreo&<T>@<T>&Mavi.DM0138DominioCorreo) =<T>SINCORREO@SINCORREO.COM<T><BR>        Entonces<BR>            Asigna(Mavi.DM0138Bandera, 3)<BR>            SQL(<T>EXEC SP_MAVIDM0138ChecarAbrirVentana :tCliente,:tMov,:tEstatus,:nBandera,:nInd,:nID,:tModulo,:tUsr,:nSuc,:tcorr<T>,Info.Cliente,Mavi.DM0138MovCorreo,Mavi.DM0138MovEstatus,Mavi.DM0138Bandera,1,Info.IDMAVI,Mavi.DM0138Modulo,Usuario,Sucursal,Mavi.DM0138CuentaCorreo&<T>@<T>&Mavi.DM0138DominioCorreo)<BR>            1=1<BR>        Sino<BR>            SQL(<T>EXEC SP_MAVIDM0138ChecarAbrirVentana :tCliente,:tMov,:tEstatus,:nBandera,:nInd,:nID,:tModulo,:tUsr,:nSuc,:tcorr<T>,Info.Cliente,Mavi.DM0138MovCorreo,Mavi.DM0138MovEstatus,Mavi.DM0138Bandera,4,Info.IDMAVI,Mavi.DM0138Modulo,Usuario,Sucursal,Mavi.DM0138CuentaCorreo&<T>@<T>&Mavi.DM0138DominioCorreo)<BR>            1=1<BR>        Fin<BR>    FIN<BR>Fin<BR>Fin
[Acciones.Cerrar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Si<BR>  VACIO(Mavi.DM0138CuentaCorreo) o VACIO(Mavi.DM0138DominioCorreo)<BR>Entonces<BR>  1=0<BR>Sino<BR>    Si<BR>        SQL(<T>SELECT dbo.FN_DM0138ValidaCaracter(:tCuenta,:tDominio)<T>,Mavi.DM0138CuentaCorreo,Mavi.DM0138DominioCorreo)<><T>0<T><BR>    Entonces<BR>        informacion(SQL(<T>SELECT dbo.FN_DM0138ValidaCaracter(:tCuenta,:tDominio)<T>,Mavi.DM0138CuentaCorreo,Mavi.DM0138DominioCorreo))<BR>        AbortarOperacion<BR>    Sino<BR>        Si<BR>            MAYUSCULAS(Mavi.DM0138CuentaCorreo&<T>@<T>&Mavi.DM0138DominioCorreo) =<T>SINCORREO@SINCORREO.COM<T><BR>        Entonces<BR>            SQL(<T>EXEC SP_MAVIDM0138ChecarAbrirVentana :tCliente,:tMov,:tEstatus,:nBandera,:nInd,:nID,:tModulo<T>,Info.Cliente,Mavi.DM0138MovCorreo,Mavi.DM0138MovEstatus,Mavi.DM0138Bandera,1,Info.IDMAVI,Ma<CONTINUA>
EjecucionCondicion002=<CONTINUA>vi.DM0138Modulo)<BR>            1=1<BR>        Sino<BR>            Si<BR>                (MAYUSCULAS(SQL(<T>SELECT EMAIL1 FROM  CTE WHERE  CLIENTE =:tCliente<T>,Info.Cliente))) <> (MAYUSCULAS(Mavi.DM0138CuentaCorreo&<T>@<T>&Mavi.DM0138DominioCorreo)))<BR>            Entonces<BR>                Si(Precaucion(<T>                                     Usted realizo cambios al correo electronico.<BR>          Si desea conservar dichos cambios, oprima el boton de Aceptar y despues el boton de Guardar.<T>,BotonAceptar, BotonCancelar)=BotonAceptar,AbortarOperacion)<BR>            Sino<BR>                1=1<BR>            Fin                                              <BR>        Fin<BR>    Fin<BR>Fin
EjecucionMensaje=<T>Campos Vacios, Escribir el Correo Generico o Uno Valido <T>
[Acciones.Cerrar.VariablesAsignar]
Nombre=VariablesAsignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[(Variables).Mavi.DM0138Arroba]
Carpeta=(Variables)
Clave=Mavi.DM0138Arroba
ValidaNombre=S
3D=N
Pegado=N
Tamano=2
ColorFondo=Plata
ColorFuente=Negro
OcultaNombre=N
LineaNueva=N



