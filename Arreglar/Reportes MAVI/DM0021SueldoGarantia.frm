[Forma]
Clave=DM0021SueldoGarantia
Nombre=Quincena Sueldo Garantia
Icono=0
CarpetaPrincipal=Sueldo
MovModulo=(Todos)
ListaCarpetas=Sueldo
AccionesTamanoBoton=3*2
ListaAcciones=Aceptar<BR>Historico
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
AccionesDivision=S
AccionesIzq=S
BarraHerramientas=S
PosicionInicialIzquierda=430
PosicionInicialArriba=317
PosicionInicialAlturaCliente=95
PosicionInicialAncho=500
Comentarios=<T>Quincenas  a  Tomar en Cuenta para Sueldo Garantia<T>
[Sueldo]
Estilo=Ficha
Clave=Sueldo
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0021SueldoGarantia
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=10
FichaEspacioNombres=104
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
FichaMarco=S
ListaEnCaptura=DM0021SueldoGarantia.NoDQuincena
[Acciones.Aceptar]
Nombre=Aceptar
Boton=3
NombreDesplegar=&Guardar y Salir
TipoAccion=Ventana
Activo=S
Visible=S
NombreEnBoton=S
EnBarraHerramientas=S
ClaveAccion=Cerrar
GuardarAntes=S
EnMenu=S
Multiple=S
ListaAccionesMultiples=SaliryCerrar<BR>TablaHistorico
[Sueldo.Columnas]
NoDQuincena=69
0=-2
[Sueldo.DM0021SueldoGarantia.NoDQuincena]
Carpeta=Sueldo
Clave=DM0021SueldoGarantia.NoDQuincena
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Historico]
Nombre=Historico
Boton=88
NombreEnBoton=S
NombreDesplegar=&Historico
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=formas
ClaveAccion=DM0021SueldoGarantiaHist
Activo=S
Visible=S
[Acciones.Aceptar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Aceptar.Historico]
Nombre=Historico
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
[Acciones.Aceptar.Salir]
Nombre=Salir
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Aceptar.SaliryCerrar]
Nombre=SaliryCerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Aceptar.TablaHistorico]
Nombre=TablaHistorico
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=EjecutarSQLAnimado(<T>SP_DM0021SueldoGarantiaHist  :tUsuario<T>, Usuario)
