[Forma]
Clave=DM0173ValidaMonederoFrm
Nombre=DM0173 Validacion Monedero
Icono=49
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=71
PosicionInicialAncho=436
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=422
PosicionInicialArriba=457
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Cerrar
ExpresionesAlMostrar=Asigna(Mavi.DM0173CtaMonedero,<T><T>)<BR>Asigna(Mavi.DM0173CtaMonederoValido,<T>No<T>)
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
FichaEspacioEntreLineas=0
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=$00EAEAEA
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.DM0173CtaMonedero<BR>Mavi.DM0173CtaMonederoValido
CarpetaVisible=S
[(Variables).Mavi.DM0173CtaMonedero]
Carpeta=(Variables)
Clave=Mavi.DM0173CtaMonedero
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.DM0173CtaMonederoValido]
Carpeta=(Variables)
Clave=Mavi.DM0173CtaMonederoValido
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=6
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Guardar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Guardar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=SI(SQL(<T>EXEC dbo.SP_DM0173ValidaMonedero :tUsr,:tMon,:tOp<T>,USUARIO,Mavi.DM0173CtaMonedero,Mavi.DM0173CtaMonederoValido)=<T>1<T>,Informacion(<T>Guardado...<T>),Precaucion(<T>Monedero no Valido...<T>))
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Variables Asignar<BR>Expresion
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

