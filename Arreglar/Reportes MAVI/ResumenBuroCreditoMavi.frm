[Forma]
Clave=ResumenBuroCreditoMavi
Nombre=Resumen de Buro
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=341
PosicionInicialArriba=314
PosicionInicialAlturaCliente=108
PosicionInicialAncho=250
AccionesTamanoBoton=15x5
AccionesDerecha=S
BarraHerramientas=S
ListaAcciones=Cerrar<BR>Aceptar     
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
ListaEnCaptura=Info.FechaD<BR>Info.FechaA
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=8
FichaEspacioNombres=0
FichaColorFondo=Plata
FichaNombres=Izquierda
FichaEspacioNombresAuto=S
FichaAlineacion=Derecha
[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreDesplegar=&Cerrar
EnMenu=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
NombreEnBoton=S
EnBarraHerramientas=S
[Acciones.Generar .generar]
Nombre=generar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Generar.variables Asignar]
Nombre=variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Generar.expresion]
Nombre=expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
[Acciones.Aceptar]
Nombre=Aceptar 
Boton=7
NombreEnBoton=S
NombreDesplegar=&Generar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S

