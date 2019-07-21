[Forma]
Clave=DM0196AsignacionAvalesRepFRM
Nombre=DM0196 Reporte de Avales   
Icono=0
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Cerrar<BR>Resumen
PosicionInicialAlturaCliente=213
PosicionInicialAncho=282
PosicionInicialIzquierda=371
PosicionInicialArriba=260
ListaCarpetas=Generarasignacion
CarpetaPrincipal=Generarasignacion
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(Mavi.Ejercicio,EjercicioTrabajo)<BR>Asigna(Mavi.Quincena, si (Dia( Hoy ))  >= 15 entonces Mes(hoy)*2 sino (Mes(hoy)*2)-1) Fin)
[Generarasignacion]
Estilo=Ficha
Pestana=S
Clave=Generarasignacion
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
Vista=(Variables)
ListaEnCaptura=Mavi.Ejercicio<BR>Mavi.Quincena
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
PestanaOtroNombre=S
PestanaNombre=Revisar Asignacion por quincena
[Generarasignacion.Mavi.Ejercicio]
Carpeta=Generarasignacion
Clave=Mavi.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFuente=Negro
Efectos=[Negritas]
ColorFondo=Blanco
[Generarasignacion.Mavi.Quincena]
Carpeta=Generarasignacion
Clave=Mavi.Quincena
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFuente=Negro
Efectos=[Negritas]
ColorFondo=Blanco
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S
[Acciones.Resumen]
Nombre=Resumen
Boton=17
NombreEnBoton=S
NombreDesplegar=Resumen
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Reportes Pantalla
ClaveAccion=DM0196ASignacionavalesREp
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asigna<BR>reporte
[Acciones.Resumen.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Resumen.reporte]
Nombre=reporte
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=DM0196ASignacionavalesREp
Activo=S
Visible=S
[Acciones.Asignar.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


