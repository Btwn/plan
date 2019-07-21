[Forma]
Clave=CFDFlexEmpresa
Nombre=Empresas
Icono=0
Modulos=(Todos)
ListaCarpetas=Lista<BR>CFDFlexEmpresaGral<BR>Empresa
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
CarpetaPrincipal=Lista
ListaAcciones=Aceptar<BR>EmpresaCFDFlex<BR>EmpresaRegimenFiscales<BR>CFDFlexSucursal
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=Centrado
PosicionInicialIzquierda=514
PosicionInicialArriba=285
PosicionInicialAltura=300
PosicionInicialAncho=571
PosicionInicialAlturaCliente=292

PosicionCol1=390
PosicionSec1=220
[Lista]
Estilo=Hoja
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=CFDFlexEmpresaGral
Fuente={MS Sans Serif, 8, Negro, []}
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S


ListaEnCaptura=CFDFlexEmpresaGral.Empresa<BR>Empresa.Nombre
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
Nombre=233
CFDI=64

[Empresa.Empresa.Nombre]
Carpeta=Empresa
Clave=Empresa.Nombre
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco



[Acciones.EmpresaCFDFlex]
Nombre=EmpresaCFDFlex
Boton=132
NombreEnBoton=S
NombreDesplegar=CFD &Flexible
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=EmpresaCFDFlex
Activo=S



Antes=S

















GuardarAntes=S
AntesExpresiones=Asigna(Info.Empresa, CFDFlexEmpresaGral:CFDFlexEmpresaGral.Empresa)<BR>Asigna(Info.Nombre, CFDFlexEmpresaGral:Empresa.Nombre)
VisibleCondicion=CFDFlexEmpresaGral.eDoc y CFDFlexEmpresaGral.CFDFlex
[Acciones.EmpresaRegimenFiscales]
Nombre=EmpresaRegimenFiscales
Boton=47
NombreDesplegar=&Régimenes Fiscales
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=EmpresaRegimenFiscales
Activo=S



NombreEnBoton=S








Antes=S





























GuardarAntes=S
AntesExpresiones=Asigna(Info.Empresa, CFDFlexEmpresaGral:CFDFlexEmpresaGral.Empresa)<BR>Asigna(Info.Nombre, CFDFlexEmpresaGral:Empresa.Nombre)
VisibleCondicion=CFDFlexEmpresaGral.eDoc y CFDFlexEmpresaGral.CFDFlex

[CFDFlexEmpresaGral]
Estilo=Ficha
Clave=CFDFlexEmpresaGral
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A2
Vista=CFDFlexEmpresaGral
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
ListaEnCaptura=CFDFlexEmpresaGral.eDoc<BR>CFDFlexEmpresaGral.CFDFlex<BR>CFDFlexEmpresaGral.CFDI<BR>


PermiteEditar=S
[CFDFlexEmpresaGral.CFDFlexEmpresaGral.eDoc]
Carpeta=CFDFlexEmpresaGral
Clave=CFDFlexEmpresaGral.eDoc
Editar=S
LineaNueva=S
ValidaNombre=N
3D=S
ColorFondo=Blanco

Tamano=20
[CFDFlexEmpresaGral.CFDFlexEmpresaGral.CFDFlex]
Carpeta=CFDFlexEmpresaGral
Clave=CFDFlexEmpresaGral.CFDFlex
Editar=S
LineaNueva=S
ValidaNombre=N
3D=S
ColorFondo=Blanco

Tamano=20
[CFDFlexEmpresaGral.CFDFlexEmpresaGral.CFDI]
Carpeta=CFDFlexEmpresaGral
Clave=CFDFlexEmpresaGral.CFDI
Editar=S
LineaNueva=S
ValidaNombre=N
3D=S
ColorFondo=Blanco







Tamano=20

[Lista.CFDFlexEmpresaGral.Empresa]
Carpeta=Lista
Clave=CFDFlexEmpresaGral.Empresa
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=5
ColorFondo=Blanco
ColorFuente=Negro



























































[Acciones.CFDFlexSucursal]
Nombre=CFDFlexSucursal
Boton=16
NombreEnBoton=S
NombreDesplegar=&Sucursales
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=CFDFlexSucursal
Activo=S











Antes=S
AntesExpresiones=Asigna(Info.Empresa, CFDFlexEmpresaGral:CFDFlexEmpresaGral.Empresa)<BR>Asigna(Info.Nombre, CFDFlexEmpresaGral:Empresa.Nombre)
VisibleCondicion=CFDFlexEmpresaGral.eDoc y CFDFlexEmpresaGral.CFDFlex
















[Forma.ListaCarpetas]
(Inicio)=Lista
Lista=CFDFlexEmpresaGral
CFDFlexEmpresaGral=(Fin)

[Forma.ListaAcciones]
(Inicio)=Aceptar
Aceptar=EmpresaCFDFlex
EmpresaCFDFlex=EmpresaRegimenFiscales
EmpresaRegimenFiscales=CFDFlexSucursal
CFDFlexSucursal=(Fin)
[Lista.Empresa.Nombre]
Carpeta=Lista
Clave=Empresa.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Empresa]
Estilo=Ficha
Clave=Empresa
Detalle=S
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=Empresa
Fuente={Tahoma, 8, Negro, []}
VistaMaestra=CFDFlexEmpresaGral
LlaveLocal=Empresa.Empresa
LlaveMaestra=CFDFlexEmpresaGral.Empresa
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Empresa.FiscalRegimen
CarpetaVisible=S
[Empresa.Empresa.FiscalRegimen]
Carpeta=Empresa
Clave=Empresa.FiscalRegimen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
