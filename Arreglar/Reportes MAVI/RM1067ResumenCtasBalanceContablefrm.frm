[Forma]
Clave=RM1067ResumenCtasBalanceContablefrm
Nombre=<T>Resumen De Cuentas De Balance Contable<T>
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=184
PosicionInicialAncho=377
PosicionInicialIzquierda=221
PosicionInicialArriba=133
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=Acept<BR>Cerrar<BR>Excel
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
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaNombres=Arriba
FichaColorFondo=Plata
FichaMarco=S
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
[Acciones.Acept.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Acept.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
ConCondicion=S
EjecucionConError=S
Visible=S
EjecucionCondicion=ConDatos(Info.Ano) y  ConDatos(Info.Periodo)
EjecucionMensaje=<T>Debe Seleccionar Periodo y Año<T>
[Acciones.Acept]
Nombre=Acept
Boton=23
NombreDesplegar=&Aceptar
Multiple=S
EnBarraAcciones=S
ListaAccionesMultiples=asigna<BR>Cerrar
Activo=S
Visible=S
NombreEnBoton=S
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
[Acciones.Excel.asig]
Nombre=asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Excel.xls]
Nombre=xls
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=RM1067ResumenCtasBalanceContablerepxls
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
ListaAccionesMultiples=asig<BR>xls<BR>cerrar
Activo=S
ConCondicion=S
EjecucionConError=S
Visible=S
EjecucionCondicion=ConDatos(Info.Ano)  y  ConDatos(Info.Periodo)
EjecucionMensaje=<T>Debe Seleccionar Periodo y Ejercicio<T>
[Acciones.Excel.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

