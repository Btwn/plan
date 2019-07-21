
[Forma]
Clave=ContSATChequeLista
Icono=0
CarpetaPrincipal=ContSATCheque
BarraHerramientas=S
Modulos=(Todos)
Nombre=Información Complementaria Cheque
AccionesTamanoBoton=15x5
AccionesDerecha=S
VentanaTipoMarco=Normal
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal

ListaAcciones=Aceptar
ListaCarpetas=ContSATCheque
PosicionInicialAlturaCliente=484
PosicionInicialAncho=1102
VentanaTipoMarco=Normal
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=132
PosicionInicialArriba=123
Comentarios=Lista(Info.Ejercicio,Info.Periodo,Info.Mov)
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
GuardarAntes=S
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

[ContSATCheque]
Estilo=Hoja
Clave=ContSATCheque
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=ContSATCheque
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=ContSATCheque.NumeroCheque<BR>ContSATCheque.CtaOrigen<BR>CtaDinero.NumeroCta<BR>ContSATCheque.BancoOrigen<BR>ContSATCheque.Monto<BR>ContSATCheque.Fecha<BR>ContSATCheque.Beneficiario<BR>ContSATCheque.RFC

CarpetaVisible=S
Filtros=S

FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General




FiltroGeneral=ContSATCheque.ContID = {Info.ID}
[ContSATCheque.ContSATCheque.CtaOrigen]
Carpeta=ContSATCheque
Clave=ContSATCheque.CtaOrigen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[ContSATCheque.ContSATCheque.BancoOrigen]
Carpeta=ContSATCheque
Clave=ContSATCheque.BancoOrigen
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[ContSATCheque.ContSATCheque.Monto]
Carpeta=ContSATCheque
Clave=ContSATCheque.Monto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[ContSATCheque.ContSATCheque.Fecha]
Carpeta=ContSATCheque
Clave=ContSATCheque.Fecha
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[ContSATCheque.ContSATCheque.Beneficiario]
Carpeta=ContSATCheque
Clave=ContSATCheque.Beneficiario
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco

[ContSATCheque.ContSATCheque.NumeroCheque]
Carpeta=ContSATCheque
Clave=ContSATCheque.NumeroCheque
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[ContSATCheque.ContSATCheque.RFC]
Carpeta=ContSATCheque
Clave=ContSATCheque.RFC
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[ContSATCheque.Columnas]
Modulo=64
ModuloID=64
ContID=64
ModuloRenglon=77
CtaOrigen=94
BancoOrigen=115
Monto=64
Fecha=94
Beneficiario=163
NumeroCheque=110
RFC=138
NumeroCta=107





[ContSATCheque.ListaEnCaptura]
(Inicio)=ContSATCheque.CtaOrigen
ContSATCheque.CtaOrigen=ContSATCheque.BancoOrigen
ContSATCheque.BancoOrigen=ContSATCheque.Monto
ContSATCheque.Monto=ContSATCheque.Fecha
ContSATCheque.Fecha=ContSATCheque.Beneficiario
ContSATCheque.Beneficiario=ContSATCheque.NumeroCheque
ContSATCheque.NumeroCheque=ContSATCheque.RFC
ContSATCheque.RFC=(Fin)
[ContSATCheque.CtaDinero.NumeroCta]
Carpeta=ContSATCheque
Clave=CtaDinero.NumeroCta
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco

