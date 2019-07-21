[Forma]
Clave=RM1143EBuscaNombreFrm
Nombre=Buscador Nombre
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
ListaCarpetas=(Variables)<BR>Listado
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=401
PosicionInicialAncho=868
PosicionSec1=55
PosicionInicialIzquierda=1
PosicionInicialArriba=530
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Cerrar<BR>Actualizar Vista
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Mavi.RM1143ENombre,<T><T>)<BR>Asigna(Mavi.RM1143EApellidoP,<T><T>)<BR>Asigna(Mavi.RM1143EApellidoM,<T><T>)
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
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
ListaEnCaptura=MAVI.RM1143EApellidoP<BR>MAVI.RM1143EApellidoM<BR>MAVI.RM1143ENombre
PermiteEditar=S
FichaNombres=Arriba
FichaAlineacion=Centrado
[Listado]
Estilo=Hoja
Clave=Listado
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=RM1143EBuscarNombrevis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Personal<BR>Nombre<BR>ApellidoPaterno<BR>ApellidoMaterno<BR>Depto<BR>Puesto
CarpetaVisible=S
MenuLocal=S
ListaAcciones=Expresion
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroGeneral={Si(Condatos(Mavi.RM1143EApellidoP),<T> ApellidoPaterno like <T>+comillas(ASCII(37)+Mavi.RM1143EApellidoP+ASCII(37)),<T>1=0<T>)}<BR>{Si(Condatos(Mavi.RM1143EApellidoM),<T> and ApellidoMaterno like <T>+comillas(ASCII(37)+Mavi.RM1143EApellidoM+ASCII(37)),<T><T>)}<BR>{Si(Condatos(Mavi.RM1143ENombre),<T> and Nombre like <T>+comillas(ASCII(37)+Mavi.RM1143ENombre+ASCII(37)),<T><T>)}
FiltroRespetar=S
FiltroTipo=General
[Listado.Personal]
Carpeta=Listado
Clave=Personal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Listado.Nombre]
Carpeta=Listado
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=92
ColorFondo=Blanco
ColorFuente=Negro
[Listado.Depto]
Carpeta=Listado
Clave=Depto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Listado.Puesto]
Carpeta=Listado
Clave=Puesto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Listado.Columnas]
Personal=64
Nombre=137
Depto=224
Puesto=185
ApellidoPaterno=111
ApellidoMaterno=108
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Actualizar Vista]
Nombre=Actualizar Vista
Boton=82
NombreEnBoton=S
NombreDesplegar=Actualizar Vista
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>Actualizar Vista
[Acciones.Actualizar Vista.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Actualizar Vista.Actualizar Vista]
Nombre=Actualizar Vista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[(Variables).MAVI.RM1143ENombre]
Carpeta=(Variables)
Clave=MAVI.RM1143ENombre
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Listado.ApellidoPaterno]
Carpeta=Listado
Clave=ApellidoPaterno
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[Listado.ApellidoMaterno]
Carpeta=Listado
Clave=ApellidoMaterno
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).MAVI.RM1143EApellidoP]
Carpeta=(Variables)
Clave=MAVI.RM1143EApellidoP
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).MAVI.RM1143EApellidoM]
Carpeta=(Variables)
Clave=MAVI.RM1143EApellidoM
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Expresion]
Nombre=Expresion
Boton=0
NombreDesplegar=Obtener Nomina
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.RM1143EAgente,RM1143EBuscarNombrevis:Personal)<BR>OtraForma(<T>RM1143GastosFrm<T>,Asigna(Mavi.RM1143EAgente,Mavi.RM1143EAgente))<BR>OtraForma(<T>RM1143GastosFrm<T>,Forma.ActualizarForma)


