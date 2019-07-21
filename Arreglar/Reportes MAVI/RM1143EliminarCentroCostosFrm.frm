[Forma]
Clave=RM1143EliminarCentroCostosFrm
Icono=674
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=498
PosicionInicialArriba=454
PosicionInicialAlturaCliente=77
PosicionInicialAncho=284
Nombre=Eliminar Centro de Costos
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Eliminar
ExpresionesAlMostrar=Asigna(MAVI.RM1143CentroCostos, <T><T>)
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
ListaEnCaptura=MAVI.RM1143CentroCostos
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
[(Variables).MAVI.RM1143CentroCostos]
Carpeta=(Variables)
Clave=MAVI.RM1143CentroCostos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[Acciones.Eliminar]
Nombre=Eliminar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Eliminar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=Variables Asignar<BR>Expresion<BR>Cerrar
[Acciones.Eliminar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Eliminar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
Expresion=Asigna(Info.Dialogo,<T><T>)<BR>Asigna(Info.Dialogo, SQL(<T>EXEC SP_RM1143EliminarCentroCostos :nAcc, :tCC<T>,1,MAVI.RM1143CentroCostos))<BR>Si Info.Dialogo=<T>ELIMINACION CORRECTA<T><BR>Entonces<BR>    Informacion(<T>EL CENTRO DE COSTOS SE ELIMINO CORRECTAMENTE<T>)<BR>    Verdadero<BR>Fin<BR>Si Info.Dialogo=<T>NO EXISTE<T><BR>Entonces<BR>    Error(<T>EL CENTRO DE COSTOS NO EXISTE<T>)<BR>    AbortarOperacion<BR>Fin
EjecucionCondicion=SI<BR> ConDatos(MAVI.RM1143CentroCostos)<BR>ENTONCES<BR> Verdadero<BR>SINO<BR> Error(<T>INGRESE UN CENTRO DE COSTOS<T>)<BR> AbortarOperacion<BR>FIN
[Acciones.Eliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


