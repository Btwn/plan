[Forma]
Clave=RelChequeMay
Nombre=<T>Relacion de Cheques Mayoreo<T>
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=Centrado
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=495
PosicionInicialArriba=439
PosicionInicialAltura=134
PosicionInicialAncho=290
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=Aceptar<BR>Cancelar
AccionesCentro=S
VentanaExclusiva=S
VentanaEscCerrar=S
AccionesDivision=S
PosicionInicialAlturaCliente=107
MovModulo=EMB
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=ASIGNA(Mavi.RM0971RelChqMay,<T><T>)

[(Variables)]
Estilo=Ficha
Clave=(Variables)
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={MS Sans Serif, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM0971RelChqMay
CarpetaVisible=S



[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreDesplegar=&Aceptar
EnBarraAcciones=S
TipoAccion=Reportes Pantalla
ClaveAccion=Relacion
Activo=S
Visible=S
ListaParametros1=info.EmbarqueMovid
Multiple=S
ListaAccionesMultiples=AsignaVariable<BR>cerr
Antes=S
AntesExpresiones=SQL(<T>Select Mov From Embarque where movid=:tmovid and mov =:tmov<T>,Info.EmbarqueMovID,<T>Embarque Mayoreo<T>)

[Acciones.Cancelar]
Nombre=Cancelar
Boton=0
NombreDesplegar=&Cancelar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Aceptar.AsignaVariable]
Nombre=AsignaVariable
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[(Variables).Mavi.RM0971RelChqMay]
Carpeta=(Variables)
Clave=Mavi.RM0971RelChqMay
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar.cerr]
Nombre=cerr
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
