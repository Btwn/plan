[Forma]
Clave=RM1143CedulaCostoVentaFrm
Nombre=RM1143 Cedula Costo de Ventas
Icono=86
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=479
PosicionInicialArriba=459
PosicionInicialAlturaCliente=67
PosicionInicialAncho=322
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Generar<BR>Cerrar
ExpresionesAlMostrar=Asigna(MAVI.RM1143Periodo,1)<BR>Asigna(MAVI.RM1143Ejercicio,Año(Hoy))
[(Variables)]
Estilo=Ficha
Clave=(Variables)
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=MAVI.RM1143Ejercicio<BR>MAVI.RM1143Periodo
CarpetaVisible=S
[(Variables).MAVI.RM1143Ejercicio]
Carpeta=(Variables)
Clave=MAVI.RM1143Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[(Variables).MAVI.RM1143Periodo]
Carpeta=(Variables)
Clave=MAVI.RM1143Periodo
Editar=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[Acciones.Generar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Generar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Generar]
Nombre=Generar
Boton=54
NombreEnBoton=S
NombreDesplegar=&Generar Archivo TXT
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Variables Asignar<BR>relacion<BR>Cerrar
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Generar.relacion]
Nombre=relacion
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM1143CedulaCostoVentaRep
Activo=S
Visible=S

