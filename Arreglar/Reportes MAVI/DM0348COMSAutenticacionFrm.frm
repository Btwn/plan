
[Forma]
Clave=DM0348COMSAutenticacionFrm
Icono=357
Modulos=(Todos)
Nombre=<T>Acceso A Tabla De Parametros Cotizador<T>

ListaCarpetas=UserPass
CarpetaPrincipal=UserPass
PosicionInicialAlturaCliente=133
PosicionInicialAncho=482
PosicionInicialIzquierda=399
PosicionInicialArriba=426
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=Aceptar<BR>Cancelar<BR>CapturarDatos
AccionesCentro=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(Mavi.DM0348Usuario,)<BR>Asigna(Mavi.DM0348Contrasena,)
[UserPass]
Estilo=Ficha
Clave=UserPass
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=15
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.DM0348Usuario<BR>Mavi.DM0348Contrasena
CarpetaVisible=S

[UserPass.Mavi.DM0348Usuario]
Carpeta=UserPass
Clave=Mavi.DM0348Usuario
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[UserPass.Mavi.DM0348Contrasena]
Carpeta=UserPass
Clave=Mavi.DM0348Contrasena
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreEnBoton=S
NombreDesplegar=Aceptar
EnBarraAcciones=S
Activo=S
Visible=S

TipoAccion=Expresion
ConCondicion=S
Multiple=S
ListaAccionesMultiples=Aceptar<BR>DM0348COMSParametrosCotizadorFrm
EjecucionCondicion=Forma.Accion(<T>CapturarDatos<T>)<BR>Si(ConDatos(Mavi.DM0348Usuario), verdadero, Informacion(<T>Debe llenar el campo <Usuario><T>) AbortarOperacion)<BR>Si(ConDatos(Mavi.DM0348Contrasena), verdadero, Informacion(<T>Debe llenar el campo <Contraseña><T>) AbortarOperacion)<BR><BR>Si<BR> SQL(<T>SELECT COUNT(*) FROM Usuario WHERE Usuario = :tUsuario AND Estatus = :tEstatus<T>,Mavi.DM0348Usuario,<T>ALTA<T>)>0<BR>Entonces<BR>  Si<BR>    SQL(<T>SELECT Contrasena FROM Usuario WHERE Usuario = :t<T>,Mavi.DM0348Usuario) = md5(Mavi.DM0348Contrasena,<T>p<T>)<BR>  Entonces<BR>    Forma(<T>DM0348COMSParametrosCotizadorFrm<T>)<BR>    Verdadero<BR>  Sino<BR>    Informacion(<T>Usuario/Contraseña Invalida<T>)<BR>  Fin<BR>Sino<BR>  Informacion(<T>Usuario no autorizado<T>)<BR>  AbortarOperacion<BR>Fin
[Acciones.Cancelar]
Nombre=Cancelar
Boton=0
NombreEnBoton=S
NombreDesplegar=Cancelar
EnBarraAcciones=S
Activo=S
Visible=S


TipoAccion=Ventana
ClaveAccion=Cerrar
[Acciones.CapturarDatos]
Nombre=CapturarDatos
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Principal.Columnas]
Linea=209
Arancel=68
Nom1=169
ValorNom1=101
Nom2=140
ValorNom2=101
Flete=96
Gastos=106
ContadoMAMV=108
CreditoMAMC=101
CreditoMAPP=100
ContadoVIUMV=110
CreditoVIUMC=105
CreditoVIUPP=101
Familia=156
CompradorAsignado=133

[Acciones.Aceptar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

[Acciones.Aceptar.DM0348COMSParametrosCotizadorFrm]
Nombre=DM0348COMSParametrosCotizadorFrm
Boton=0
TipoAccion=Formas
ClaveAccion=DM0348COMSParametrosCotizadorFrm
Activo=S
Visible=S

