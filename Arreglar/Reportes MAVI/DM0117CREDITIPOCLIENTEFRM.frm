[Forma]
Clave=DM0117CREDITIPOCLIENTEFRM
Nombre=Tipo de Ciente
Icono=0
Modulos=(Todos)
MovModulo=CXC
ListaCarpetas=DM0117CREDITIPOCLIENTEFRM
CarpetaPrincipal=DM0117CREDITIPOCLIENTEFRM
PosicionInicialAlturaCliente=96
PosicionInicialAncho=245
PosicionInicialIzquierda=517
PosicionInicialArriba=445
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
Plantillas=S
VentanaBloquearAjuste=S
VentanaEscCerrar=S
VentanaAvanzaTab=S
ExpresionesAlMostrar=asigna(Mavi.DM0117CREDITIPODECTE,<T>Cliente<T>)
[DM0117CREDITIPOCLIENTEFRM]
Estilo=Ficha
Clave=DM0117CREDITIPOCLIENTEFRM
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.DM0117CREDITIPODECTE
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PestanaNombre=Seleccionar Tipo de Cliente
FichaNombres=Arriba
FichaAlineacion=Izquierda
PermiteEditar=S
PestanaOtroNombre=S
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreDesplegar=Aceptar
Multiple=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
ListaAccionesMultiples=Asigna<BR>Sp<BR>Cerrar
NombreEnBoton=S
[Acciones.Aceptar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Aceptar.Sp]
Nombre=Sp
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=Si<BR> (Mavi.DM0117CREDITIPODECTE = <T>Cliente<T>)<BR>Entonces<BR>    forma(<T>DM0117CrediCanalVentaFrm<T>)<BR>Sino<BR>    si (Mavi.DM0117CREDITIPODECTE = <T>Deudor<T>)<BR>    Entonces<BR>        asigna(Mavi.DM0117CanalVenta,2)<BR>        forma(<T>DM0117CrediCteCapturaFrm<T>)<BR>    sino<BR>        <T><T><BR>    fin<BR>Fin
[DM0117CREDITIPOCLIENTEFRM.Mavi.DM0117CREDITIPODECTE]
Carpeta=DM0117CREDITIPOCLIENTEFRM
Clave=Mavi.DM0117CREDITIPODECTE
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


