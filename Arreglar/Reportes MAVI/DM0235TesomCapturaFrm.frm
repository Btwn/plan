[Forma]
Clave=DM0235TesomCapturaFrm
Icono=0
Modulos=(Todos)
ListaCarpetas=Tesomcaptura
CarpetaPrincipal=Tesomcaptura
PosicionInicialIzquierda=407
PosicionInicialArriba=229
PosicionInicialAlturaCliente=309
PosicionInicialAncho=537
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
Nombre=DM0235 Captura Deposito
ListaAcciones=guarda<BR>cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Dise�o
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Mavi.DM0235Banco,<T> <T>)<BR> Asigna(Mavi.DM0235Cuenta,<T> <T>)<BR> Asigna(Mavi.DM0235FechaDDep, nulo )<BR> Asigna(Mavi.DM0235Referencia,<T> <T>)<BR> Asigna(Mavi.DM0235Autorizacion,<T> <T>)<BR> Asigna(Mavi.DM0235ImporteDep, nulo )<BR> Asigna(Mavi.DM0235Observaciones,<T> <T>)<BR> Asigna(Mavi.DM0235ImporteCP, nulo )
[Tesomcaptura]
Estilo=Ficha
Clave=Tesomcaptura
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
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.DM0235Banco<BR>Mavi.DM0235Cuenta<BR>Mavi.DM0235FechaDDep<BR>Mavi.DM0235Referencia<BR>Mavi.DM0235Autorizacion<BR>Mavi.DM0235ImporteDep<BR>Mavi.DM0235ImporteCP<BR>Mavi.DM0235Observaciones
CarpetaVisible=S
[Acciones.guarda.exp]
Nombre=exp
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Asigna(Info.Dialogo,SQL(<T>EXEC SP_DM0235GuardaDep :tBco, :tCta, :fFec, :tRef, :tAut, :mImpteDep, :mImpteCp, :tObs, :tUsr<T>,Mavi.DM0235Banco,Mavi.DM0235Cuenta,Mavi.DM0235FechaDDep,Mavi.DM0235Referencia,Mavi.DM0235Autorizacion,Mavi.DM0235ImporteDep,Mavi.DM0235ImporteCP,Mavi.DM0235Observaciones, Usuario ))<BR>Informacion(Info.Dialogo)
EjecucionCondicion=ConDatos(Mavi.DM0235Banco) y  ConDatos(Mavi.DM0235Cuenta) y  ConDatos(Mavi.DM0235FechaDDep) y  ConDatos(Mavi.DM0235ImporteDep) y  ConDatos(Mavi.DM0235Referencia)  y  ConDatos( Mavi.DM0235Autorizacion) y  ConDatos(Mavi.DM0235ImporteCP) y (SQL(<T>Select dbo.fn_MaviDM0235ValidFechDep(:fFecha)<T>,Mavi.DM0235FechaDDep)=0)
EjecucionMensaje=SI<BR> (SQL(<T>Select dbo.fn_MaviDM0235ValidFechDep(:fFecha)<T>,Mavi.DM0235FechaDDep)=0)<BR>  Entonces<BR>    <T>Los Campos Banco, Cuenta, Fecha Deposito, Referencia, Autorizacion, Importe Deposito, Importe Cadenas Productivas son Obligatorios <T><BR>  Sino<BR>    <T>La Fecha Deposito no debe ser mayor a la Actual<T><BR>Fin
[Acciones.guarda]
Nombre=guarda
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=asign<BR>exp<BR>cerra<BR>forma
Activo=S
Visible=S
[Acciones.guarda.cerra]
Nombre=cerra
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.cerrar]
Nombre=cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.guarda.forma]
Nombre=forma
Boton=0
TipoAccion=Formas
ClaveAccion=DM0235ControladorDepyDispFrm
Activo=S
Visible=S
[Tesomcaptura.Mavi.DM0235Banco]
Carpeta=Tesomcaptura
Clave=Mavi.DM0235Banco
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
[Tesomcaptura.Mavi.DM0235Cuenta]
Carpeta=Tesomcaptura
Clave=Mavi.DM0235Cuenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Tesomcaptura.Mavi.DM0235FechaDDep]
Carpeta=Tesomcaptura
Clave=Mavi.DM0235FechaDDep
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Pegado=S
[Tesomcaptura.Mavi.DM0235Referencia]
Carpeta=Tesomcaptura
Clave=Mavi.DM0235Referencia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Tesomcaptura.Mavi.DM0235Autorizacion]
Carpeta=Tesomcaptura
Clave=Mavi.DM0235Autorizacion
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Tesomcaptura.Mavi.DM0235ImporteDep]
Carpeta=Tesomcaptura
Clave=Mavi.DM0235ImporteDep
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Tesomcaptura.Mavi.DM0235ImporteCP]
Carpeta=Tesomcaptura
Clave=Mavi.DM0235ImporteCP
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Pegado=S
[Tesomcaptura.Mavi.DM0235Observaciones]
Carpeta=Tesomcaptura
Clave=Mavi.DM0235Observaciones
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=55X5
ColorFondo=Blanco
ColorFuente=Negro
ConScroll=S
[Acciones.guarda.asign]
Nombre=asign
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

