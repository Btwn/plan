;**** Se modifico para que el titulo sea presentado por medio de una variable. Faustino L. Raygoza 04/Dic/2009
[Forma]
Clave=SugerirCosteoFleteMayoreoMAVI
;Nombre=Costeo Flete Mayoreo
Nombre=Info.Titulo
Icono=114
Modulos=(Todos)
ListaCarpetas=(Variables)
BarraAcciones=S
AccionesTamanoBoton=15x5
AccionesDivision=S
CarpetaPrincipal=(Variables)
ListaAcciones=Aceptar<BR>Cancelar
AccionesCentro=S
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=Centrado
PosicionInicialIzquierda=440
PosicionInicialArriba=273
PosicionInicialAlturaCliente=173
PosicionInicialAncho=400
VentanaExclusiva=S
ExpresionesAlMostrar=Asigna(Anexo.EvaluarTipoUnidad, SQL(<T>Select TipoUnidadVehicular FROM Vehiculo WHERE Vehiculo=:tVehiculo<T>,Anexo.Vehiculo))<BR>Asigna(Anexo.DescFlete,<T>No<T>)

[(Variables)]
Estilo=Ficha
Clave=(Variables)
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=22
FichaEspacioNombres=127
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Anexo.IncluirDestinos<BR>Anexo.IncluirManiobras<BR>Anexo.OtrosCargos<BR>Anexo.OtrosCargosMonto<BR>Anexo.EvaluarTipoUnidad
CarpetaVisible=S
FichaEspacioNombresAuto=S

[(Variables).Anexo.IncluirDestinos]
Carpeta=(Variables)
Clave=Anexo.IncluirDestinos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=12
ColorFondo=Blanco
ColorFuente=Negro
Pegado=N

[(Variables).Anexo.IncluirManiobras]
Carpeta=(Variables)
Clave=Anexo.IncluirManiobras
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=12
ColorFondo=Blanco
ColorFuente=Negro
Pegado=N

[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreDesplegar=Aceptar
EnBarraAcciones=S
Activo=S
Visible=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
GuardarAntes=S
Antes=S
RefrescarDespues=S
AntesExpresiones=Si(EsNumerico(Anexo.DescFleteMonto),<T> <T>,Si(Precaucion(<T>Específique un monto de descuento válido<T>,BotonAceptar)=BotonAceptar,AbortarOperacion, AbortarOperacion))<BR>Si(EsNumerico(Anexo.OtrosCargosMonto),<T> <T>,Si(Precaucion(<T>Específique un monto válido<T>,BotonAceptar)=BotonAceptar,AbortarOperacion, AbortarOperacion))

[Acciones.Cancelar]
Nombre=Cancelar
Boton=0
NombreDesplegar=Cancelar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cancelar
Activo=S
Visible=S

[(Variables).Anexo.OtrosCargos]
Carpeta=(Variables)
Clave=Anexo.OtrosCargos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=12
ColorFondo=Blanco
ColorFuente=Negro
Pegado=N

[(Variables).Anexo.OtrosCargosMonto]
Carpeta=(Variables)
Clave=Anexo.OtrosCargosMonto
Editar=S
ValidaNombre=S
3D=S
Tamano=12
ColorFondo=Blanco
ColorFuente=Negro
Pegado=N

[(Variables).Anexo.EvaluarTipoUnidad]
Carpeta=(Variables)
Clave=Anexo.EvaluarTipoUnidad
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=18
ColorFondo=Blanco
ColorFuente=Negro
Pegado=N
