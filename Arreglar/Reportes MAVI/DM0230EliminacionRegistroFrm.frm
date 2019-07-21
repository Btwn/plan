
[Forma]
Clave=DM0230EliminacionRegistroFrm
Icono=0
Modulos=(Todos)
Nombre=Eliminar registro
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialAlturaCliente=66
PosicionInicialAncho=310

VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal


ListaAcciones=Eliminar<BR>Cerrar
CarpetaPrincipal=(Variables)
ListaCarpetas=(Variables)
PosicionInicialIzquierda=485
PosicionInicialArriba=460
PosicionSec1=42
PosicionCol1=174
[Acciones.Eliminar]
Nombre=Eliminar
Boton=36
NombreDesplegar=&Eliminar
EnBarraHerramientas=S
Activo=S
Visible=S
NombreEnBoton=S

TipoAccion=Dialogos
ClaveAccion=DM0230ConfirmaEliminarDlg
Multiple=S
ListaAccionesMultiples=Aceptar<BR>RegistrosFecha
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S



TipoAccion=Ventana
ClaveAccion=Cerrar
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
CarpetaVisible=S
FichaEspacioEntreLineas=6
FichaEspacioNombres=115
FichaColorFondo=Plata



FichaNombres=Izquierda
FichaAlineacion=Centrado
PermiteEditar=S
FichaAlineacionDerecha=S

ListaEnCaptura=Mavi.DM0230FechaEliminar
[Fecha.Info.Fecha]
Carpeta=Fecha
Clave=Info.Fecha
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco




[Acciones.Eliminar.RegistrosFecha]
Nombre=RegistrosFecha
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S



Expresion=Caso  Precaucion(<T>Se eliminarán los registros del día: <T>&Mavi.DM0230FechaEliminar&<T><BR>¿Desea continuar?<T>, BotonSi , BotonNo)<BR>  Es BotonSi<BR>  Entonces<BR>      Asigna(Info.dialogo,SQL(<T>Exec SpIDM0230_ValRegistros :opc,:fecha<T>,1,Mavi.DM0230FechaEliminar))<BR>      Si (Info.dialogo=0)<BR>      Entonces<BR>          Informacion(<T>Los registros se han eliminado<T>)<BR>      Sino<BR>          Informacion(<T>No se encontraron registros con esa fecha<T>)<BR>      Fin<BR>  Es BotonNo<BR>  Entonces<BR>      Falso<BR>Fin
[(Variables).Mavi.DM0230FechaEliminar]
Carpeta=(Variables)
Clave=Mavi.DM0230FechaEliminar
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.Eliminar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

