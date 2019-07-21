[Forma]
Clave=RM1143EliminarCCXPlazaFrm
Nombre=Eliminar Plaza
Icono=384
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=529
PosicionInicialArriba=452
PosicionInicialAlturaCliente=82
PosicionInicialAncho=221
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Eliminar
VentanaExclusiva=S
ExpresionesAlCerrar=Asigna(MAVI.RM1143Eliminar,<T><T>)
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
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=MAVI.RM1143Eliminar
CarpetaVisible=S
[(Variables).MAVI.RM1143Eliminar]
Carpeta=(Variables)
Clave=MAVI.RM1143Eliminar
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
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
[Acciones.Eliminar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Dialogo,<T><T>)<BR>Asigna(Info.Dialogo,SQL(<T>EXEC SP_RM1143AccionesCCXPlaza :tPlaza, :tCentro, :nVer<T>,MAVI.RM1143Eliminar,<T><T>,2))<BR>Si<BR>    Info.Dialogo = <T>ELIMINADO<T><BR>Entonces<BR>    Informacion(<T>PLAZA ELIMINADA CORRECTAMENTE<T>) Verdadero<BR>    OtraForma(<T>RM1143CCXPlazaFrm<T>,Forma.Accion(<T>Actualizar<T>))<BR>Sino<BR>    Si Info.Dialogo = <T>NO EXISTE<T><BR>    Entonces Error(<T>NO EXISTE LA PLAZA INDICADA<T>) AbortarOperacion<BR>    Fin<BR>Fin
[Acciones.Eliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Eliminar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

