[Forma]
Clave=ProprePreguntaLista
Nombre=<T>Enviar/Copiar/Mover Articulo(s) a Lista<T>
Icono=5
CarpetaPrincipal=Ficha
Modulos=(Todos)
ListaCarpetas=Ficha
PosicionInicialIzquierda=464
PosicionInicialArriba=311
PosicionInicialAlturaCliente=110
PosicionInicialAncho=352
VentanaTipoMarco=Di�logo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=Aceptar<BR>Cancelar
AccionesCentro=S
AccionesDivision=S
VentanaSiempreAlFrente=S
VentanaBloquearAjuste=S
ExpresionesAlCerrar=Asigna(Info.PropreMargen1,SQL(<T>SELECT Margen1 FROM PropreLista WHERE Lista = :tLista<T>,Info.PropreLista))<BR>Asigna(Info.PropreMargen2,SQL(<T>SELECT Margen2 FROM PropreLista WHERE Lista = :tLista<T>,Info.PropreLista))<BR>Asigna(Info.PropreMargen3,SQL(<T>SELECT Margen3 FROM PropreLista WHERE Lista = :tLista<T>,Info.PropreLista))<BR>Asigna(Info.PropreMargenOriginal,1000)
[Ficha]
Estilo=Ficha
Clave=Ficha
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
ListaEnCaptura=Info.PropreLista
CarpetaVisible=S
[Ficha.Info.PropreLista]
Carpeta=Ficha
Clave=Info.PropreLista
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreEnBoton=S
NombreDesplegar=&Aceptar
EnBarraAcciones=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
EspacioPrevio=S
[Acciones.Cancelar]
Nombre=Cancelar
Boton=0
NombreDesplegar=&Cancelar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cancelar
Activo=S
Visible=S
