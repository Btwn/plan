
[Forma]
Clave=DM0264VeriExecpcionesfrm
Icono=0
Modulos=(Todos)
Nombre=Carga de Datos

ListaCarpetas=Articulos
CarpetaPrincipal=Articulos
PosicionInicialAlturaCliente=273
PosicionInicialAncho=500
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Cargar<BR>VerificaryGuardar<BR>Elimniar<BR>Cerrar
PosicionInicialIzquierda=394
PosicionInicialArriba=222
[Articulos]
Estilo=Hoja
Clave=Articulos
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0264VeriExecpcionesvis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S

PermiteEditar=S
ListaEnCaptura=DM0264VeriExecpcionestbl.Articulo
[Acciones.Cargar]
Nombre=Cargar
Boton=115
NombreEnBoton=S
NombreDesplegar=Importar Excel
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Enviar/Recibir Excel
Activo=S
Visible=S

ConAutoEjecutar=S
[Articulos.DM0264VeriExecpcionestbl.Articulo]
Carpeta=Articulos
Clave=DM0264VeriExecpcionestbl.Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Articulos.Columnas]
Articulo=124

[Acciones.VerificaryGuardar]
Nombre=VerificaryGuardar
Boton=3
NombreEnBoton=S
NombreDesplegar=Verificar y Guardar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S

ListaAccionesMultiples=Guardar<BR>Verificar<BR>Otraforma
[Acciones.VerificaryGuardar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.VerificaryGuardar.Verificar]
Nombre=Verificar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Asigna(Info.Dialogo,SQL(<T>EXEC SPCREDIVeriExcepciones<T>)),<BR>Si<BR>     (Info.Dialogo)=<T>CORRECTO<T><BR>Entonces<BR>  Informacion(Info.Dialogo),<BR>  Forma.Accion(<T>Cerrar<T>)<BR>Sino<BR>  Error(Info.Dialogo)<BR>Fin
[Acciones.Elimniar]
Nombre=Elimniar
Boton=5
NombreDesplegar=&Eliminar
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S
NombreEnBoton=S


[Acciones.VerificaryGuardar.Otraforma]
Nombre=Otraforma
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=OtraForma(<T>DM0264ExcepcionesFrm<T>, Forma.Accion(<T>Actualizar<T>))

[Acciones.Cerrar]
Nombre=Cerrar
Boton=0
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
