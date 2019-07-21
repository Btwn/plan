[Forma]
Clave=RM1143AgregarCCXPlazaFrm
Icono=407
Modulos=(Todos)
ListaCarpetas=Variables
CarpetaPrincipal=Variables
PosicionInicialAlturaCliente=87
PosicionInicialAncho=687
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=296
PosicionInicialArriba=449
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Agregar<BR>Cerrar<BR>Recarga
VentanaRepetir=S
ExpresionesAlMostrar=Asigna(Info.Numero,0)
Nombre=Agregar Plaza
[Variables]
Estilo=Ficha
Clave=Variables
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Plata
ListaEnCaptura=MAVI.RM1143Plazas<BR>MAVI.RM1143Descrip<BR>MAVI.RM1143Centros
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
[Variables.MAVI.RM1143Plazas]
Carpeta=Variables
Clave=MAVI.RM1143Plazas
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Variables.MAVI.RM1143Centros]
Carpeta=Variables
Clave=MAVI.RM1143Centros
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Variables.MAVI.RM1143Descrip]
Carpeta=Variables
Clave=MAVI.RM1143Descrip
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Plata
ColorFuente=Negro
Editar=N
[Acciones.Agregar]
Nombre=Agregar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Agregar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=Asignar<BR>Expresion<BR>Cerrar
[Acciones.Cerrar]
Nombre=Cerrar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Expresion.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Expresion.Actualizar Forma]
Nombre=Actualizar Forma
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
[Acciones.Expresion.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=/*SI<BR>    ConDatos(MAVI.RM1143Plazas)<BR>Entonces*/<BR>    Asigna(MAVI.RM1143Descrip,SQL(<T>SELECT Descripcion FROM COMERCIALIZADORA..PLAZA WHERE Plaza = :tPlaza<T>, MAVI.RM1143Plazas))<BR>    Informacion(MAVI.RM1143Plazas)<BR>    Informacion(MAVI.RM1143Descrip)<BR>    Forma(<T>RM1143AgregarCCXPlazaFrm<T>)<BR>    Forma.Accion(<T>Cerrar<T>)<BR>//Fin<BR> Forma.ActualizarForma
[Acciones.Asignar.A]
Nombre=A
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Asignar.B]
Nombre=B
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si<BR>    ConDatos(MAVI.RM1143Plazas)<BR>Entonces<BR>    Asigna(MAVI.RM1143Descrip,SQL(<T>SELECT Descripcion FROM COMERCIALIZADORA..PLAZA WHERE Plaza = :tPlaza<T>,MAVI.RM1143Plazas))<BR>   Informacion(MAVI.RM1143Plazas)<BR>Fin
[Acciones.Expresion.w]
Nombre=w
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Expresion.r]
Nombre=r
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=SI<BR>    ConDatos(MAVI.RM1143Plazas)<BR>Entonces<BR>    Informacion(MAVI.RM1143Plazas)<BR>    Asigna(MAVI.RM1143Descrip,SQL(<T>SELECT Descripcion FROM COMERCIALIZADORA..PLAZA WHERE Plaza = :tPlaza<T>,MAVI.RM1143Plazas))<BR>    Informacion(MAVI.RM1143Descrip)<BR>Fin
[Acciones.Expresion.i]
Nombre=i
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Forma( <T>RM1143AgregarCCXPlazaFrm<T> )<BR>Forma.Accion(<T>Cerrar<T>)
[Acciones.Magia.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Magia.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si<BR>    ConDatos(MAVI.RM1143Plazas)<BR>Entonces<BR>    Asigna(MAVI.RM1143Descrip,SQL(<T>SELECT Descripcion FROM COMERCIALIZADORA.dbo.PLAZA WHERE Plaza = :tPlaza<T>,MAVI.RM1143Plazas))<BR>    Forma(<T>RM1143AgregarCCXPlazaFrm<T>)<BR>    Forma.Accion(<T>Cerrar<T>)<BR>Fin
[Acciones.Actualizar Arbol.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Actualizar Arbol.Forma]
Nombre=Forma
Boton=0
TipoAccion=Formas
ClaveAccion=RM1143AgregarCCXPlazaFrm
Activo=S
Visible=S
[Acciones.Arbol.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
[Acciones.Arbol.Forma]
Nombre=Forma
Boton=0
TipoAccion=Formas
ClaveAccion=RM1143AgregarCCXPlazaFrm
[Acciones.Recarga]
Nombre=Recarga
Boton=0
NombreEnBoton=S
NombreDesplegar=Recarga
Multiple=S
Carpeta=Variables
TipoAccion=Controles Captura
ClaveAccion=Limpiar Carpeta
ListaAccionesMultiples=Cerrar<BR>Forma
Activo=S
ConCondicion=S
ConAutoEjecutar=S
EnBarraHerramientas=S
EjecucionCondicion=ConDatos(MAVI.RM1143Plazas) y Info.Numero=1
AutoEjecutarExpresion=1
[Acciones.Recarga.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
[Acciones.Recarga.Forma]
Nombre=Forma
Boton=0
TipoAccion=Formas
ClaveAccion=RM1143AgregarCCXPlazaFrm
[Acciones.Agregar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
Expresion=Asigna(Info.Dialogo,<T><T>)<BR>Asigna(Info.Dialogo,SQL(<T>EXEC SP_RM1143AccionesCCXPlaza :tPlaza, :tCentro, :nVer<T>,MAVI.RM1143Plazas,MAVI.RM1143Centros,1))<BR>Caso  Info.Dialogo<BR>  Es <T>EXISTE P<T> Entonces Error(<T>LA PLAZA YA EXISTE<T>) AbortarOperacion<BR>  Es <T>NO EXISTE CC<T> Entonces Error(<T>CENTRO DE COSTOS NO VALIDO<T>) AbortarOperacion<BR>  Es <T>INGRESO CORRECTO<T> Entonces Informacion(<T>REGISTRO INGRESADO CORRECTAMENTE<T>) OtraForma(<T>RM1143CCXPlazaFrm<T>,Forma.Accion(<T>Actualizar<T>)) Verdadero<BR>Fin
EjecucionCondicion=Si<BR>    ConDatos(MAVI.RM1143Plazas) y ConDatos(MAVI.RM1143Centros)<BR>Entonces<BR>    Verdadero<BR>Sino<BR>    Error(<T>PLAZA O CENTRO DE COSTOS VACIOS<T>)<BR>    AbortarOperacion<BR>Fin
[Acciones.Agregar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Agregar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


