[Forma]
Clave=AutorizarCondMAVI
Nombre=<T>Autorizar Condonacion <T>
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=518
PosicionInicialArriba=336
PosicionInicialAlturaCliente=93
PosicionInicialAncho=243
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=Centrado
AccionesTamanoBoton=15x5
ListaAcciones=Aceptar<BR>Cancelar
VentanaEscCerrar=S
VentanaExclusiva=S
AccionesDivision=S
AccionesCentro=S
BarraHerramientas=S
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=//Si<BR>//  Usuario.Autorizar<BR>//Entonces<BR>//  Asigna(Info.Usuario, Usuario)<BR>//  Asigna(Info.Contrasena, Usuario.Contrasena)<BR>//Sino<BR>  Asigna(Info.Usuario, Nulo)<BR>  Asigna(Info.Contrasena, Nulo)<BR>  Asigna(Info.Numero, Nulo)<BR>//Fin

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
ListaEnCaptura=Info.Usuario<BR>Info.Contrasena
CarpetaVisible=S

[(Variables).Info.Usuario]
Carpeta=(Variables)
Clave=Info.Usuario
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).Info.Contrasena]
Carpeta=(Variables)
Clave=Info.Contrasena
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.Aceptar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Aceptar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Temp.Reg, SQL(<T>SELECT Usuario, Contrasena FROM Usuario WHERE Usuario=:tUsuario<T>, Info.Usuario ))<BR>  Si<BR>    Temp.Reg[1]=Info.Usuario<BR>  Entonces<BR>    Si<BR>      Temp.Reg[2]=MD5(Info.Contrasena,<T>p<T>)<BR>    Entonces<BR>      Asigna(Info.Numero,SQL(<T>spValidaUsuarioMAVI :nID, :tUsuario, :nEstacion<T>,Info.ID, Info.Usuario, EstacionTrabajo))<BR>      Si Info.Numero = 1<BR>      Entonces<BR>          Asigna(Info.Numero,SQL(<T>spAutorizaCondonacionMAVI :nID, :tUsuario, :nEstacion<T>, Info.ID, Info.Usuario,  EstacionTrabajo ))<BR>      Sino<BR>          Error(<T>Usuario sin Permisos<T>)<BR>          AbortarOperacion<BR>      Fin<BR>    Sino<BR>      Error(<T>Contraseña Incorrecta<T>)<BR>    Fin<BR>  Sino<BR>    Error(<T>Usuario Incorrecto<T>)<BR>  Fin<BR>Si Info.Numero = <T>0<T> <CONTINUA>
Expresion002=<CONTINUA>Entonces<BR>    Informacion(<T>No existe informaciòn a condonar..<T>)<BR>    Asigna(Info.ABC, <T>4<T>)<BR>Sino<BR>    Asigna(Info.ABC, SQL(<T>spValidaAutorizacionCondMAVI :nID, :tUsuario, :tEstacion<T>,Info.ID, Info.Usuario,  EstacionTrabajo ))<BR>Fin<BR>//Informacion(Info.ABC)<BR>Si Info.ABC = <T>1<T> entonces<BR>  Informacion(<T>Ha sobrepasado el % permitido para condonar..Verificar<T>)<BR>Fin<BR>Si Info.ABC = <T>0<T> entonces<BR>  AbortarOperacion<BR>Sino<BR>    Si Info.ABC <> <T>4<T> Entonces<BR>        Si Info.SugerirCobro = <T>Importe Especifico<T><BR>        Entonces<BR>          ProcesarSQL( <T>spReajusteCobroMAVI :tSugerir, :tMod, :nId, :nImpTotal, :tUsua, :nEst<T>, Info.SugerirCobro, <T>CXC<T>, Info.ID, Info.Importe, Usuario ,EstacionTrabajo )<BR>          Asigna(Info.ABC, <T>4<T<CONTINUA>
Expresion003=<CONTINUA>>)<BR>        Sino<BR>          Si Info.SugerirCobro = <T>Por Factura<T><BR>          Entonces<BR>            ProcesarSQL( <T>spReajusteCobroxFact :tSugerir, :tMod, :nId, :nImpTotal, :tUsua, :nEst<T>, Info.SugerirCobro, <T>CXC<T>, Info.ID, Info.Importe, Usuario ,EstacionTrabajo )<BR>            Asigna(Info.ABC, <T>4<T>)<BR>          Fin<BR>        Fin<BR>    Fin<BR>Fin

[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreDesplegar=&Autorizar
Multiple=S
EnBarraAcciones=S
ListaAccionesMultiples=Variables Asignar<BR>Expresion<BR>Aceptar
Activo=S
Visible=S
NombreEnBoton=S
EnBarraHerramientas=S
GuardarAntes=S

[Acciones.Cancelar]
Nombre=Cancelar
Boton=36
NombreDesplegar=<T>&Cancelar<T>
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cancelar
Activo=S
Visible=S
NombreEnBoton=S
EnBarraHerramientas=S

[Acciones.Aceptar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
