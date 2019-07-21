[Forma]
Clave=DM0123AReasignarNivelCobConFrm
Nombre=Reasignar Nivel de Cobranza Contacto
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=462
PosicionInicialArriba=423
PosicionInicialAlturaCliente=140
PosicionInicialAncho=356
AccionesTamanoBoton=15x5
ListaAcciones=Cambiar<BR>Cancelar<BR>Cargar
BarraAcciones=S
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
VentanaEscCerrar=S
AccionesCentro=S
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Info.Cliente,<T><T>)<BR>Asigna(Mavi.DM0123ANivelCobranza,<T><T>)<BR>Asigna(MAvi.DM0123AidAval,<T><T>)

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
ListaEnCaptura=Info.Cliente<BR>Mavi.DM0123AidAval<BR>Mavi.DM0123ANivelCobranza
CarpetaVisible=S




[Acciones.Cancelar]
Nombre=Cancelar
Boton=0
NombreDesplegar=<T>&Cancelar<T>
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cancelar
Activo=S
Visible=S

[Acciones.Aceptar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Aceptar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

[Acciones.Aceptar.Reasignar]
Nombre=Reasignar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=ProcesarSQL(<T>spReasignarCobrador :tEmp, :tDe, :tA<T>, Empresa, Info.PersonalD, Info.PersonalA)
[(Variables).Info.Cliente]
Carpeta=(Variables)
Clave=Info.Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Cambiar]
Nombre=Cambiar
Boton=0
NombreDesplegar=&Cambiar
Multiple=S
EnBarraHerramientas=S
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Aceptar
ListaAccionesMultiples=Variables Asignar<BR>Reasignar<BR>Aceptar
Activo=S
Visible=S
[Acciones.Cambiar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
[Acciones.Cambiar.Reasignar]
Nombre=Reasignar
Boton=0
TipoAccion=Expresion
ConCondicion=S
EjecucionConError=S
Expresion=EjecutarSQL(<T>SP_DM0123ANivelContacto :tNivel,:tCte,:taval<T>,Mavi.DM0123ANivelCobranza,Info.cliente,Mavi.DM0123AidAval)<BR>Informacion(<T>Se ha Modificado el Nivel de Contacto Del Cliente<T>)
EjecucionCondicion=si<BR>(vacio(info.cliente))<BR>Entonces<BR> Error(<T>Debe seleccionar un cliente<T>)<BR>Sino<BR>Si<BR>  Vacio(Mavi.DM0123ANivelCobranza)<BR>Entonces<BR>  asigna(Mavi.DM0123ANivelCobranza,<T><T>)<BR>Fin <BR> (SQL(<T>Sp_MaviDM0123ValidaNiveles :tniv<T>,Mavi.DM0123ANivelCobranza))=1 Y (SQL(<T>SP_MaviDM0123ValidaCte :tcte<T>,Info.Cliente))=1<BR>Fin<BR><BR><BR><BR>//condatos(info.cliente)y(ejecutarsql(<T>Sp_MaviDM0123ValidaNiveles :tniv<T>,Mavi.DM0123NivelCobranza)=1)
EjecucionMensaje=<T>Debe Seleccionar un nivel de contacto valido o verifique que el cliente este correcto<T>
[Acciones.Cambiar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
[Acciones.Cargar]
Nombre=Cargar
Boton=-1
NombreEnBoton=S
NombreDesplegar=<T>&Cargar<T>
EnBarraAcciones=S
TipoAccion=Formas
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Var Asig<BR>asignar<BR>llamar<BR>Aceptar
[Acciones.Cargar.Var Asig]
Nombre=Var Asig
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Cargar.asignar]
Nombre=asignar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=ejecutarsql(<T>SP_DM0123AEliminarReg :Nest,:tusu<T>,estaciontrabajo,usuario)
[Acciones.Cargar.llamar]
Nombre=llamar
Boton=0
TipoAccion=Formas
ClaveAccion=DM0123ANivelesCtesVisFrm
Activo=S
Visible=S
[Acciones.Cargar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
[(Variables).Mavi.DM0123ANivelCobranza]
Carpeta=(Variables)
Clave=Mavi.DM0123ANivelCobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.DM0123AidAval]
Carpeta=(Variables)
Clave=Mavi.DM0123AidAval
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
