[Forma]
Clave=CteCtoCTMavi
Nombre=Contactos del Cliente
Icono=0
Modulos=(Todos)
ListaCarpetas=Lista<BR>Ficha
CarpetaPrincipal=Ficha
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Cerrar
PosicionInicialIzquierda=219
PosicionInicialArriba=126
PosicionInicialAlturaCliente=517
PosicionInicialAncho=841
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=Centrado
PosicionColumna1=54
PosicionCol1=449


[Lista.Columnas]
Nombre=185
Cargo=97
FechaNacimiento=88
Telefonos=102
Extencion=51
eMail=147
Grupo=128
Atencion=61
Tratamiento=65
NombreCompleto=268



[Ficha]
Estilo=Ficha
Clave=Ficha
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A2
Vista=CteCto
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=CteCto.Nombre<BR>CteCto.ApellidoPaterno<BR>CteCto.ApellidoMaterno<BR>CteCto.eMail<BR>CteCto.Cargo<BR>CteCto.Grupo<BR>CteCto.Telefonos<BR>CteCto.Extencion<BR>CteCto.Fax<BR>CteCto.PedirTono<BR>CteCto.EnviarA<BR>CteEnviarA.Nombre<BR>CteCto.FechaNacimiento<BR>CteCto.Sexo<BR>CteCto.Tipo<BR>CteCto.Tratamiento<BR>CteCto.Atencion
CarpetaVisible=S

[Ficha.CteCto.Nombre]
Carpeta=Ficha
Clave=CteCto.Nombre
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.CteCto.Cargo]
Carpeta=Ficha
Clave=CteCto.Cargo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.CteCto.Grupo]
Carpeta=Ficha
Clave=CteCto.Grupo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.CteCto.Telefonos]
Carpeta=Ficha
Clave=CteCto.Telefonos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.CteCto.Extencion]
Carpeta=Ficha
Clave=CteCto.Extencion
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.CteCto.eMail]
Carpeta=Ficha
Clave=CteCto.eMail
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
EspacioPrevio=S

[Ficha.CteCto.FechaNacimiento]
Carpeta=Ficha
Clave=CteCto.FechaNacimiento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=25
EspacioPrevio=S

[Ficha.CteCto.Atencion]
Carpeta=Ficha
Clave=CteCto.Atencion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.CteCto.Tratamiento]
Carpeta=Ficha
Clave=CteCto.Tratamiento
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Lista]
Estilo=Hoja
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=CteCto
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
ListaEnCaptura=NombreCompleto<BR>CteCto.eMail
CarpetaVisible=S
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
HojaMantenerSeleccion=S
BusquedaRapidaControles=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaAncho=20
BusquedaEnLinea=S
OtroOrden=S
ListaOrden=CteCto.Nombre<TAB>(Acendente)<BR>CteCto.ApellidoPaterno<TAB>(Acendente)<BR>CteCto.ApellidoMaterno<TAB>(Acendente)
FiltroGeneral=CteCto.Cliente=<T>{Info.Cliente}<T>

[Lista.CteCto.eMail]
Carpeta=Lista
Clave=CteCto.eMail
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro







[Ficha.CteCto.Fax]
Carpeta=Ficha
Clave=CteCto.Fax
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.CteCto.PedirTono]
Carpeta=Ficha
Clave=CteCto.PedirTono
Editar=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro


[Ficha.CteCto.EnviarA]
Carpeta=Ficha
Clave=CteCto.EnviarA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.CteEnviarA.Nombre]
Carpeta=Ficha
Clave=CteEnviarA.Nombre
Editar=S
LineaNueva=N
3D=S
Tamano=40
ColorFondo=Plata
ColorFuente=Negro
ValidaNombre=S

[Lista.NombreCompleto]
Carpeta=Lista
Clave=NombreCompleto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=200
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.CteCto.ApellidoPaterno]
Carpeta=Ficha
Clave=CteCto.ApellidoPaterno
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.CteCto.ApellidoMaterno]
Carpeta=Ficha
Clave=CteCto.ApellidoMaterno
Editar=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.CteCto.Tipo]
Carpeta=Ficha
Clave=CteCto.Tipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.CteCto.Sexo]
Carpeta=Ficha
Clave=CteCto.Sexo
Editar=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=N



