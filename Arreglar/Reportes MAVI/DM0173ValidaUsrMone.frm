[Forma]
Clave=DM0173ValidaUsrMone
Nombre=DM0173 Autoriza Monedero
Icono=63
Modulos=(Todos)
MovModulo=(Todos)
ListaCarpetas=Acceso
CarpetaPrincipal=Acceso
PosicionInicialAlturaCliente=106
PosicionInicialAncho=500
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=390
PosicionInicialArriba=440
VentanaSinIconosMarco=S
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Cancelar
[Acceso]
Estilo=Ficha
Clave=Acceso
Filtros=S
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=Acceso
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
ListaEnCaptura=Acceso.Usuario<BR>Usuario.Nombre<BR>Acceso.Contrasena
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
CarpetaVisible=S
FiltroGeneral=1=0
[Acceso.Acceso.Usuario]
Carpeta=Acceso
Clave=Acceso.Usuario
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=12
ColorFondo=Blanco
ColorFuente=Negro
[Acceso.Usuario.Nombre]
Carpeta=Acceso
Clave=Usuario.Nombre
ValidaNombre=S
3D=S
Tamano=32
ColorFondo=Plata
ColorFuente=Negro
[Acceso.Acceso.Contrasena]
Carpeta=Acceso
Clave=Acceso.Contrasena
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=56
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar]
Nombre=Aceptar
Boton=7
NombreDesplegar=&Aceptar
EnBarraHerramientas=S
TipoAccion=Ventana
Activo=S
Visible=S
Antes=S
NombreEnBoton=S
ClaveAccion=Aceptar
Multiple=S
ListaAccionesMultiples=Cancelar Cambios<BR>Cerrar
AntesExpresiones=Forma.IrCarpeta(<T>Acceso<T>)<BR><BR>Asigna(Acceso:Acceso.Contrasena,MD5(Acceso:Acceso.Contrasena,<T>p<T>))<BR><BR>CASO SQL(<T>EXEC dbo.SP_MAVIDM0173AutorizaMonedero :tId,:tUsr,:tPws<T>,Info.ID,Acceso:Acceso.Usuario,Acceso:Acceso.Contrasena)<BR>    ES 1 ENTONCES Si(Precaucion(<T>Usuario no Valido...<T>, BotonAceptar)=BotonAceptar, AbortarOperacion,AbortarOperacion)<BR>    ES 2 ENTONCES Si(Precaucion(<T>Contraseña no Valida...<T>, BotonAceptar)=BotonAceptar, AbortarOperacion,AbortarOperacion)<BR>FIN
[Acciones.Cancelar.Cancelar Cambios]
Nombre=Cancelar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S
[Acciones.Cancelar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Cancelar]
Nombre=Cancelar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Cancelar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Cancelar Cambios<BR>Cerrar
Activo=S
Visible=S
[Acciones.Aceptar.Cancelar Cambios]
Nombre=Cancelar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S
[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
