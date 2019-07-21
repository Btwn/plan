[Forma]
Clave=DM0206ImpAgente
Nombre=Importador de estructuras instituciones
Icono=734
Modulos=(Todos)
PosicionInicialAlturaCliente=111
PosicionInicialAncho=360
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
Menus=S
AccionesTamanoBoton=15x5
BarraAcciones=S
ListaAcciones=Aceptar<BR>Cerrar
AccionesDerecha=S
AccionesDivision=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=378
PosicionInicialArriba=230
ExpresionesAlMostrar=Asigna( mavi.importador,nulo )<BR>Asigna( mavi.Grupo,nulo )
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
ListaEnCaptura=mavi.importador<BR>mavi.Grupo
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
[(Variables).mavi.importador]
Carpeta=(Variables)
Clave=mavi.importador
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
NombreDesplegar=Aceptar
TipoAccion=Expresion
Activo=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=Shift+F5
NombreEnBoton=S
GuardarAntes=S
EnMenu=S
Expresion=Si<BR> condatos(mavi.importador) y condatos(mavi.Grupo)<BR>Entonces<BR>  Si<BR>      (mavi.importador=<T>EQUIPO<T> )<BR>    Entonces<BR>      Forma( <T>DM0206TMPEQUIPOSFRM<T> )<BR>    Sino<BR>     Si<BR>         (mavi.importador=<T>CELULA<T> )<BR>        Entonces<BR>          Forma( <T>DM0206TMPGTECELDIVFRM<T> )<BR>     Sino<BR>          Si<BR>              ( mavi.importador=<T>GERENTE<T>)<BR>            Entonces<BR>               Forma( <T>DM0206TMPGTECELDIVFRM<T> )<BR>            Sino<BR>              Si<BR>                  ( mavi.importador=<T>DIVISION<T>)<BR>                Entonces<BR>                     Forma( <T>DM0206TMPGTECELDIVFRM<T> )<BR>                Sino<BR>                  Error(<T>ESCOGIO UNA OPCION INVALIDA<T>)<BR>                Fin<BR>            Fin<BR>        Fin<B<CONTINUA>
Expresion002=<CONTINUA>R>    Fin<BR>Sino<BR>  Error(<T>No se puede dejar una o varias opciones sin seleccionar<T>)<BR>Fin//si  condatos(mavi.importador) y condatos(mavi.Grupo)<BR>    //entonces informacion(<T>importador= <T>+mavi.importador+<T> grupo= <T>+ mavi.Grupo+ <T> 1<T>)<BR>    //sino informacion(<T>Importador= <T>+mavi.importador+<T> grupo= <T>+ mavi.Grupo+<T> 2<T>)<BR>//fin
[Acciones.Cerrar]
Nombre=Cerrar
Boton=0
UsaTeclaRapida=S
TeclaRapida=Alt+F4
NombreDesplegar=&Cerrar
EnMenu=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[(Variables).mavi.Grupo]
Carpeta=(Variables)
Clave=mavi.Grupo
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


