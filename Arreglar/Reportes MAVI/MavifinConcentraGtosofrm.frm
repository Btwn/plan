[Forma]
Clave=MavifinConcentraGtosofrm
Nombre=Concentrado de Gastos
Icono=0
CarpetaPrincipal=(variables)
Modulos=(Todos)
ListaCarpetas=(variables)
PosicionInicialAlturaCliente=158
PosicionInicialAncho=529
PosicionInicialIzquierda=252
PosicionInicialArriba=312
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Cerrar<BR>Preeliminar
[(variables)]
Estilo=Ficha
Clave=(variables)
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
CarpetaVisible=S
ListaEnCaptura=Mavi.categoria<BR>Mavi.MesD<BR>Mavi.AlMes<BR>Mavi.ImporteD<BR>Mavi.ImporteA<BR>Mavi.NumEco
[(variables).Mavi.categoria]
Carpeta=(variables)
Clave=Mavi.categoria
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=55
ColorFondo=Blanco
ColorFuente=Negro
[(variables).Mavi.MesD]
Carpeta=(variables)
Clave=Mavi.MesD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(variables).Mavi.AlMes]
Carpeta=(variables)
Clave=Mavi.AlMes
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(variables).Mavi.ImporteD]
Carpeta=(variables)
Clave=Mavi.ImporteD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(variables).Mavi.ImporteA]
Carpeta=(variables)
Clave=Mavi.ImporteA
Editar=S
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
[Acciones.Preeliminar]
Nombre=Preeliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preeliminar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[(variables).Mavi.NumEco]
Carpeta=(variables)
Clave=Mavi.NumEco
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
