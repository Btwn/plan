[Forma]
Clave=MaviUtilMenMayXMarFrm
Nombre=RM197A Reporte de Utilidad Mensual Ventas Mayoreo
Icono=35
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=421
PosicionInicialArriba=433
PosicionInicialAlturaCliente=129
PosicionInicialAncho=438
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar
VentanaTipoMarco=Di�logo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaBloquearAjuste=S
VentanaEscCerrar=S
VentanaAvanzaTab=S
ExpresionesAlMostrar=//Asigna(Mavi.MesD,(FechaEnTexto( hoy ,<T>mmmm<T>)))<BR>Asigna(Mavi.MesD,Nulo)<BR>Asigna(Info.ano,Nulo)<BR>Asigna(Mavi.CiaFabFam,Nulo)
Comentarios=FechaEnTexto(Hoy,<T>dd-mmm-aaaa<T>)&<T> - <T>&Usuario
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
FichaEspacioEntreLineas=3
FichaEspacioNombres=0
FichaColorFondo=Plata
ListaEnCaptura=Mavi.MesD<BR>Info.Ano<BR>Mavi.CiaFabFam
PermiteEditar=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaEspacioNombresAuto=S
FichaAlineacionDerecha=S
[(Variables).Mavi.MesD]
Carpeta=(Variables)
Clave=Mavi.MesD
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
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Controles Captura
Activo=S
Visible=S
ClaveAccion=Variables Asignar / Ventana Aceptar
Multiple=S
ListaAccionesMultiples=Asignar<BR>Cerrar
[(Variables).Mavi.CiaFabFam]
Carpeta=(Variables)
Clave=Mavi.CiaFabFam
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Nueva Consulta.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Nueva Consulta.Nueva Forma]
Nombre=Nueva Forma
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=MaviUtilMenMayXMarRep
Activo=S
Visible=S
[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
ConCondicion=S
EjecucionConError=S
Visible=S
EjecucionCondicion=ConDatos(Mavi.MesD) y ConDatos(Info.ano) y ConDatos(Mavi.CiaFabFam)
EjecucionMensaje=Si (Vacio(Mavi.MesD)) Entonces <T>No se ha seleccionado un mes<T> SiNo<BR>Si (Vacio(Info.ano)) Entonces <T>No se ha seleccionado un a�o<T> SiNo<BR>Si (Vacio(Mavi.CiaFabFam)) Entonces <T>Seleccione una opci�n para desplegar la informaci�n<T>

