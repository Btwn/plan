[Forma]
Clave=RM1143AgregarCentroCostosFrm
Icono=730
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
Nombre=Agregar Centro de Costos
ListaCarpetas=CCAreaMoto
CarpetaPrincipal=CCAreaMoto
PosicionInicialIzquierda=284
PosicionInicialArriba=429
PosicionInicialAlturaCliente=128
PosicionInicialAncho=711
AutoGuardar=S
ListaAcciones=Aceptar<BR>Cancelar
PosicionSec1=103
PosicionSec2=135
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaBloquearAjuste=S
VentanaSinIconosMarco=S
VentanaAvanzaTab=S
VentanaExclusiva=S
ExpresionesAlMostrar=EjecutarSQL(<T>EXEC SP_RM1143CentroCostos <T>+1)
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
[(Variables).MAVI.RM1143Nombre]
Carpeta=(Variables)
Clave=MAVI.RM1143Nombre
Editar=S
ValidaNombre=S
3D=S
Tamano=58
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[(Variables).MAVI.RM1143AM1]
Carpeta=(Variables)
Clave=MAVI.RM1143AM1
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[(Variables).MAVI.RM1143AM2]
Carpeta=(Variables)
Clave=MAVI.RM1143AM2
Editar=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[(Variables).MAVI.RM1143AM3]
Carpeta=(Variables)
Clave=MAVI.RM1143AM3
Editar=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[(Variables).MAVI.RM1143AM4]
Carpeta=(Variables)
Clave=MAVI.RM1143AM4
Editar=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[(Variables).MAVI.RM1143AM5]
Carpeta=(Variables)
Clave=MAVI.RM1143AM5
Editar=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[(Variables).MAVI.RM1143Total]
Carpeta=(Variables)
Clave=MAVI.RM1143Total
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
EnBarraHerramientas=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Guardar<BR>Expresion
Antes=S
AntesExpresiones=Si Vacio(RM1143CCSecundariaVis:RM1143CCSecundariaTbl.CentroCostos) o Vacio(RM1143CCSecundariaVis:RM1143CCSecundariaTbl.Nombre)<BR>Entonces<BR>    Error(<T>EL CENTRO DE COSTOS O EL NOMBRE NO PUEDEN ESTAR VACIOS<T>)<BR>    AbortarOperacion<BR>Fin
[(Variables)2.MAVI.RM1143Total]
Carpeta=(Variables)2
Clave=MAVI.RM1143Total
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[(Carpeta Totalizadores)]
Clave=(Carpeta Totalizadores)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Fuente={Tahoma, 8, Negro, [Negritas]}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
Totalizadores=S
CampoColorLetras=Negro
CampoColorFondo=Plata
CarpetaVisible=S
Totalizadores1=Total
Totalizadores2=Suma(RM1143CCSecundariaTbl.AreaMotora1+RM1143CCSecundariaTbl.AreaMotora2+RM1143CCSecundariaTbl.AreaMotora3+RM1143CCSecundariaTbl.AreaMotora4+RM1143CCSecundariaTbl.AreaMotora5)
TotCarpetaRenglones=CCAreaMoto
ListaEnCaptura=Total
TotExpresionesEnSumas=S
TotAlCambiar=S
ConFuenteEspecial=S
[(Carpeta Totalizadores).Total]
Carpeta=(Carpeta Totalizadores)
Clave=Total
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=N
Tamano=10
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]
[Acciones.Limpiar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=EjecutarSQL(<T>EXEC SP_RM1143CentroCostos <T>+2)
[Acciones.Limpiar.Actualizar Vista]
Nombre=Actualizar Vista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Limpiar.Actualizar Forma]
Nombre=Actualizar Forma
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
[Acciones.Actualizar Vista.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Expresion=EjecutarSQL(<T>EXEC SP_RM1143CentroCostos <T>+2)
Activo=S
Visible=S
[Acciones.Actualizar Vista.Actualizar Vista]
Nombre=Actualizar Vista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Actualizar Vista.Actualizar Vistaw]
Nombre=Actualizar Vistaw
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Aceptar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Dialogo,<T><T>)<BR>Asigna(Info.Dialogo,SQL(<T>EXEC SP_RM1143CentroCostos <T>+2))<BR>Si Info.Dialogo = <T>YA EXISTE<T> Entonces Error(<T>EL CENTRO DE COSTOS YA EXISTE<T>) AbortarOperacion<BR>Sino Si Info.Dialogo = <T>SUMA DIFERENTE 100<T> Entonces Error(<T>LA SUMA DE LOS FACTORES ES DIFERENTE DE 100<T>) AbortarOperacion<BR>Sino Si Info.Dialogo = <T>INGRESO CORRECTO<T> Entonces Informacion(<T>CENTRO DE COSTOS INGRESADO CORRECTAMENTE<T>) Verdadero<BR>Fin
[Acciones.Aceptar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Cancelar]
Nombre=Cancelar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Cancelar Cambios<BR>Cerrar
EspacioPrevio=S
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
[CCAreaMoto]
Estilo=Ficha
Clave=CCAreaMoto
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1143CCSecundariaVis
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Plata
CarpetaVisible=S
ListaEnCaptura=RM1143CCSecundariaTbl.CentroCostos<BR>RM1143CCSecundariaTbl.Nombre<BR>RM1143CCSecundariaTbl.AreaMotora1<BR>RM1143CCSecundariaTbl.AreaMotora2<BR>RM1143CCSecundariaTbl.AreaMotora3<BR>RM1143CCSecundariaTbl.AreaMotora4<BR>RM1143CCSecundariaTbl.AreaMotora5<BR>STotal
PermiteEditar=S
[CCAreaMoto.RM1143CCSecundariaTbl.CentroCostos]
Carpeta=CCAreaMoto
Clave=RM1143CCSecundariaTbl.CentroCostos
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[CCAreaMoto.RM1143CCSecundariaTbl.Nombre]
Carpeta=CCAreaMoto
Clave=RM1143CCSecundariaTbl.Nombre
Editar=S
ValidaNombre=S
3D=S
Tamano=70
ColorFondo=Blanco
ColorFuente=Negro
[CCAreaMoto.RM1143CCSecundariaTbl.AreaMotora1]
Carpeta=CCAreaMoto
Clave=RM1143CCSecundariaTbl.AreaMotora1
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[CCAreaMoto.RM1143CCSecundariaTbl.AreaMotora2]
Carpeta=CCAreaMoto
Clave=RM1143CCSecundariaTbl.AreaMotora2
Editar=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[CCAreaMoto.RM1143CCSecundariaTbl.AreaMotora3]
Carpeta=CCAreaMoto
Clave=RM1143CCSecundariaTbl.AreaMotora3
Editar=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[CCAreaMoto.RM1143CCSecundariaTbl.AreaMotora4]
Carpeta=CCAreaMoto
Clave=RM1143CCSecundariaTbl.AreaMotora4
Editar=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[CCAreaMoto.RM1143CCSecundariaTbl.AreaMotora5]
Carpeta=CCAreaMoto
Clave=RM1143CCSecundariaTbl.AreaMotora5
Editar=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[CCAreaMoto.STotal]
Carpeta=CCAreaMoto
Clave=STotal
Editar=N
LineaNueva=N
ValidaNombre=S
3D=S
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]
Tamano=15

