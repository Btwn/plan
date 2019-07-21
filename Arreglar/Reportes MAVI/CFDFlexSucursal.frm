[Forma]
Clave=CFDFlexSucursal
Nombre=Sucursales
Icono=0
Modulos=(Todos)
ListaCarpetas=Lista<BR>CFDFlexSucursal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
CarpetaPrincipal=Lista
ListaAcciones=Aceptar<BR>Registrar
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=Centrado
PosicionInicialIzquierda=353
PosicionInicialArriba=266
PosicionInicialAltura=300
PosicionInicialAncho=893
PosicionInicialAlturaCliente=329

PosicionCol1=242
[Lista]
Estilo=Hoja
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=CFDFlexSucursal
Fuente={MS Sans Serif, 8, Negro, []}
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S


ListaEnCaptura=CFDFlexSucursal.Sucursal<BR>CFDFlexSucursal.Nombre
[Acciones.Aceptar]
Nombre=Aceptar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar y cerrar
GuardarAntes=S
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

[Lista.Columnas]
NivelAcademico=292

Empresa=123
Nombre=160

Sucursal=49
[Empresa.Empresa.Nombre]
Carpeta=Empresa
Clave=Empresa.Nombre
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[CFDFlexSucursal]
Estilo=Ficha
Clave=CFDFlexSucursal
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A2
Vista=CFDFlexSucursal
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
ListaEnCaptura=CFDFlexSucursal.CFDFlex<BR>CFDFlexSucursal.noCertificado<BR>CFDFlexSucursal.ContrasenaSello<BR>CFDFlexSucursal.CertificadoBase64<BR>CFDFlexSucursal.RutaCertificado<BR>CFDFlexSucursal.Llave
CarpetaVisible=S

[Lista.CFDFlexSucursal.Sucursal]
Carpeta=Lista
Clave=CFDFlexSucursal.Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Lista.CFDFlexSucursal.Nombre]
Carpeta=Lista
Clave=CFDFlexSucursal.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro


[CFDFlexSucursal.CFDFlexSucursal.CFDFlex]
Carpeta=CFDFlexSucursal
Clave=CFDFlexSucursal.CFDFlex
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[CFDFlexSucursal.CFDFlexSucursal.noCertificado]
Carpeta=CFDFlexSucursal
Clave=CFDFlexSucursal.noCertificado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[CFDFlexSucursal.CFDFlexSucursal.Llave]
Carpeta=CFDFlexSucursal
Clave=CFDFlexSucursal.Llave
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=70
ColorFondo=Blanco
ColorFuente=Negro

[CFDFlexSucursal.CFDFlexSucursal.ContrasenaSello]
Carpeta=CFDFlexSucursal
Clave=CFDFlexSucursal.ContrasenaSello
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[CFDFlexSucursal.CFDFlexSucursal.CertificadoBase64]
Carpeta=CFDFlexSucursal
Clave=CFDFlexSucursal.CertificadoBase64
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=70x7
ColorFondo=Blanco
ColorFuente=Negro

[CFDFlexSucursal.CFDFlexSucursal.RutaCertificado]
Carpeta=CFDFlexSucursal
Clave=CFDFlexSucursal.RutaCertificado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=70
ColorFondo=Blanco
ColorFuente=Negro









[Acciones.Registrar]
Nombre=Registrar
Boton=83
NombreEnBoton=S
NombreDesplegar=&Registrar Certificado CFD
GuardarAntes=S
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Expresion
Activo=S
Expresion=EJECUTARSQL(<T>EXEC spCFDFlexInsertarCertificadoXML :nEstacion, :tEmpresa, :tSucursal, :tTipo, 0<T>,EstacionTrabajo,Info.Empresa, CFDFlexSucursal:CFDFlexSucursal.Sucursal, <T>Sucursal<T>)<BR>ActualizarForma
VisibleCondicion=(General.CFDFlex) y (CFDFlexSucursal:CFDFlexSucursal.CFDFlex)
