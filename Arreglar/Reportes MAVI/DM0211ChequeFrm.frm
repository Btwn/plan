[Forma]
Clave=DM0211ChequeFrm
Nombre=Tipo Cheque & Cta        
Icono=0
Modulos=(Todos)
ListaCarpetas=Variable
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=Aceptar<BR>Cancelar
CarpetaPrincipal=Variable
PosicionInicialAlturaCliente=129
PosicionInicialAncho=216
AccionesCentro=S
PosicionInicialIzquierda=642
PosicionInicialArriba=485
[Variable]
Estilo=Ficha
Clave=Variable
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.DM0211CtaDinero<BR>Mavi.DM0211TipoCheque
CarpetaVisible=S
PermiteEditar=S
[Variable.Mavi.DM0211TipoCheque]
Carpeta=Variable
Clave=Mavi.DM0211TipoCheque
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreDesplegar=&Aceptar
EnBarraAcciones=S
TipoAccion=Controles Captura
Activo=S
Visible=S
NombreEnBoton=S
ClaveAccion=Variables Asignar
Multiple=S
ListaAccionesMultiples=asig<BR>expresion<BR>cerrar
[Acciones.Cancelar]
Nombre=Cancelar
Boton=0
NombreDesplegar=&Cancelar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
NombreEnBoton=S
[Acciones.Aceptar.asig]
Nombre=asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.expresion]
Nombre=expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si<BR>   vacio(Mavi.DM0211TipoCheque)<BR>Entonces<BR>  informacion(<T>Seleccionar un Tipo de Cheque ... !<T>)                                              <BR>  falso<BR>Sino<BR><BR>SQL(<T>EXEC SP_DM0211GenPagCheq :TMOV, :TCHEQUE, :TUSUARIO, :TCTA, :TMOVIMIENTO<T>,Mavi.DM0211MovGrid,Mavi.DM0211TipoCheque,USUARIO,Mavi.DM0211CtaDinero,Mavi.DM0211Movimiento)<BR><BR>///////////////////////////////////////////////////////////////////////////////////////////////////////////////////<BR>Si<BR>   (SQL(<T>EXEC SP_DM0211Mensaje :NMOV <T>,1))=<T>0<T> <BR><BR>Entonces<BR>  INFORMACION(<T>No Hubo Mov Afectados ... !<T>)<BR><BR>Sino<BR>   INFORMACION(<T>Se Generaron Los Movimientos <T> & SQL(<T>EXEC SP_DM0211Mensaje :NMOV <T>,1))<BR> Fin<BR>Si<BR>  (SQL(<T>EXEC SP_DM0211Mensaje :NMOV <T>,2))>0           <CONTINUA>
Expresion002=<CONTINUA>                                                    <BR>Entonces<BR>  reportepantalla(<T>DM0211SinAfectar1Rep<T>)<BR>FIN<BR><BR><BR>///////////////////////////////////////////////////////////////////////////////////////////////////////////////////<BR><BR><BR><BR>OtraForma( <T>DM0211GenPagChequesFrm<T>,  ActualizarForma  )<BR><BR>Fin
[Acciones.Aceptar.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Variable.Mavi.DM0211CtaDinero]
Carpeta=Variable
Clave=Mavi.DM0211CtaDinero
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

