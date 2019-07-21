[Forma]
Clave=RM0255AEspecificarAlmacenFrm
Nombre=RM255A Resurtido a Sucursales con Artículos Nuevos
Icono=551
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
AccionesTamanoBoton=15x5
ListaAcciones=Aceptar<BR>Cancelar
PosicionInicialIzquierda=418
PosicionInicialArriba=448
PosicionInicialAltura=108
PosicionInicialAncho=444
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
PosicionInicialAlturaCliente=90
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesCentro=S
Comentarios=FechaEnTexto(Hoy,<T>dd-mmm-aaaa<T>)&<T> - <T>&Usuario
VentanaAvanzaTab=S
PosicionCol1=319
ExpresionesAlMostrar=Asigna(Mavi.RM0255Almacen,<T><T>)<BR> Asigna(Mavi.RM0255ASucursales,<T><T>)

[(Variables)]
Estilo=Ficha
Clave=(Variables)
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={MS Sans Serif, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=62
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM0255Almacen<BR>Mavi.RM0255ASucursales
CarpetaVisible=S


[Acciones.Aceptar]
Nombre=Aceptar
Boton=6
NombreDesplegar=&Preliminar
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asignar<BR>Cerrar
NombreEnBoton=S
EnBarraHerramientas=S

[Acciones.Cancelar]
Nombre=Cancelar
Boton=23
NombreDesplegar=&Cerrar
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
NombreEnBoton=S
EnBarraHerramientas=S
[(Variables).Mavi.RM0255Almacen]
Carpeta=(Variables)
Clave=Mavi.RM0255Almacen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=Si<BR>    (Vacio(Mavi.RM0255Almacen) Y Vacio(Mavi.RM0255ASucursales))<BR>Entonces<BR>    Informacion(<T>Para poder continuar, necesitas seleccionar un Filtro solamente.<T>)<BR>SiNo<BR>    Si<BR>        (ConDatos(Mavi.RM0255Almacen) Y ConDatos(Mavi.RM0255ASucursales))<BR>    Entonces<BR>        Asigna(Mavi.RM0255Almacen,<T><T>)<BR>        Asigna(Mavi.RM0255ASucursales,<T><T>)                               <BR>        Informacion(<T>Solo Puede Seleccionar Almacenes O Sucursales Ingresa Nuevamente tus Filtros para Continuar.<T>)<BR><BR>    Sino<BR>        Verdadero<BR>    Fin<BR>Fin
[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[(Variables).Mavi.RM0255ASucursales]
Carpeta=(Variables)
Clave=Mavi.RM0255ASucursales
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

