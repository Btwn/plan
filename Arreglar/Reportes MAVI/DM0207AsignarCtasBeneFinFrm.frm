[Forma]
Clave=DM0207AsignarCtasBeneFinFrm
Nombre=Asignar Nivel de Cobranza
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=519
PosicionInicialArriba=307
PosicionInicialAlturaCliente=115
PosicionInicialAncho=328
AccionesTamanoBoton=15x5
ListaAcciones=Cambiar<BR>Cancelar<BR>Cargar
BarraAcciones=S
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
VentanaEscCerrar=S
AccionesCentro=S
VentanaEstadoInicial=Normal

VentanaExclusivaOpcion=0
ExpresionesAlMostrar=Asigna(Mavi.DM0207InfoBeneFinal,<T><T>)<BR>Asigna(Mavi.DM0123NivelCobranza,<T><T>)
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
ListaEnCaptura=Mavi.DM0207InfoBeneFinal<BR>Mavi.DM0123NivelCobranza
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

[(Variables).Mavi.DM0123NivelCobranza]
Carpeta=(Variables)
Clave=Mavi.DM0123NivelCobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
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
Expresion=EjecutarSQL(<T>SPIDM0207_NivelCobranza :tNivel,:tCte<T>,Mavi.DM0123NivelCobranza,Mavi.DM0207InfoBeneFinal)<BR>Informacion(<T>Se ha Modificado el Nivel de Cobranza Del Cliente<T>)
EjecucionCondicion=si (vacio(Mavi.DM0207InfoBeneFinal)) entonces<BR>Error(<T>Debe seleccionar un cliente<T>)<BR>sino<BR>(SQL(<T>Sp_MaviDM0123ValidaNiveles :tniv<T>,Mavi.DM0123NivelCobranza))=1 Y (SQL(<T>SPIDM0207_ValidaCteFinal :tcte<T>,Mavi.DM0207InfoBeneFinal))=1<BR>Fin<BR><BR><BR>//condatos(info.cliente)y(ejecutarsql(<T>Sp_MaviDM0123ValidaNiveles :tniv<T>,Mavi.DM0123NivelCobranza)=1)
EjecucionMensaje=<T>Debe Seleccionar un Nivel de cobranza valido o Verifique Que el Cliente Este Correcto<T>
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
TipoAccion=expresion
Activo=S
Visible=S
Expresion=ejecutarsql(<T>SP_MaviDM0123EliminaReg :Nest,:tusu<T>,estaciontrabajo,usuario)
[Acciones.Cargar.llamar]
Nombre=llamar
Boton=0
TipoAccion=Formas
ClaveAccion=DM0207NivelesCtesFinVisFrm
Activo=S
Visible=S
[Acciones.Cargar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

[Vista.Columnas]
Nombre=604



[(Variables).Mavi.DM0207InfoBeneFinal]
Carpeta=(Variables)
Clave=Mavi.DM0207InfoBeneFinal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Lista.Columnas]
ClienteF=64
Nombre=604
ApellidoPaterno=604
ApellidoMaterno=604
RFC=94
Domicilio=184
NombreCompleto=327
