[Forma]
Clave=RM1066ResumenCtasBalanceOperativofrm
Nombre=<T>Resumen Cuentas De Balance Operativo<T>
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
BarraAcciones=S
AccionesTamanoBoton=15x5
PosicionInicialAlturaCliente=149
PosicionInicialAncho=353
ListaAcciones=Aceptar<BR>Cerrar<BR>Excel
PosicionInicialIzquierda=547
PosicionInicialArriba=249
AccionesCentro=S
BarraHerramientas=S
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
ListaEnCaptura=Info.Periodo<BR>Info.Ano
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaNombres=Arriba
FichaColorFondo=Plata
FichaAlineacion=Centrado
FichaMarco=S
PermiteEditar=S
[(Variables).Info.Periodo]
Carpeta=(Variables)
Clave=Info.Periodo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.Ano]
Carpeta=(Variables)
Clave=Info.Ano
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=ConDatos(Info.Ano) y  ConDatos( Info.Periodo)
EjecucionMensaje=<T>Debe Seleccionar Periodo Y Año<T>
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
Multiple=S
EnBarraAcciones=S
ListaAccionesMultiples=asigna<BR>cerrar
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cancelar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Excel.asign]
Nombre=asign
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Excel.xls]
Nombre=xls
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=RM1066ResumenCtasBalanceOperativorepxls
Activo=S
Visible=S
[Acciones.Excel]
Nombre=Excel
Boton=115
NombreEnBoton=S
NombreDesplegar=Enviar a E&xcel
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=asign<BR>xls<BR>cerra
Activo=S
ConCondicion=S
EjecucionConError=S
Visible=S
EjecucionCondicion=ConDatos(Info.Ano) y  ConDatos(Info.Periodo)
EjecucionMensaje=<T>Debe Seleccionar Periodo y Ejercicio<T>
[Acciones.Excel.cerra]
Nombre=cerra
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

