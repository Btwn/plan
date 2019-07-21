[Forma]
Clave=RM1143IniProvMonXAMFrm
Nombre=RM1143 Provision Monedero Por AM
Icono=91
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialIzquierda=604
PosicionInicialArriba=196
PosicionInicialAlturaCliente=80
PosicionInicialAncho=243
ListaCarpetas=Variables
CarpetaPrincipal=Variables
ListaAcciones=Preliminar<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Info.Periodo,PeriodoTrabajo)<BR>Asigna(Info.Ejercicio, EjercicioTrabajo)
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
CampoColorFondo=Blanco
ListaEnCaptura=Info.Periodo<BR>Info.Ejercicio
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
[Acciones.Preliminar]
Nombre=Preliminar
Boton=54
NombreEnBoton=S
NombreDesplegar=&<T>Enviar a TXT<T>
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S
ListaAccionesMultiples=Asigna<BR>Ejecutar
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Preliminar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.Ejecutar]
Nombre=Ejecutar
Boton=0
TipoAccion=Reportes Impresora
Activo=S
Visible=S
ClaveAccion=RM1143PROvisionMonederoXAMRepTXT
[Variables.Info.Periodo]
Carpeta=Variables
Clave=Info.Periodo
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[Variables.Info.Ejercicio]
Carpeta=Variables
Clave=Info.Ejercicio
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro


