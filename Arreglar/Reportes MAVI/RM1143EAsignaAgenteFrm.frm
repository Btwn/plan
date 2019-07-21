[Forma]
Clave=RM1143EAsignaAgenteFrm
Nombre=Gastos Comer
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=cerrar<BR>Actualizar Vista
PosicionInicialAlturaCliente=86
PosicionInicialAncho=215
BarraHerramientas=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=931
PosicionInicialArriba=174
VentanaRepetir=S
ExpresionesAlCerrar=Asigna(Info.Dialogo,<T><T>)
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
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
ListaEnCaptura=MAVI.RM1143EIdComer
FichaNombres=Arriba
FichaAlineacion=Centrado
PermiteEditar=S
ExpAntesRefrescar=Si Condatos(Info.Dialogo)<BR>Entonces<BR>   Asigna(Mavi.RM1143EAgente,SQL(<T>Select dbo.fn_RM01143EObtenEmpleado(:nID)<T>,Info.Dialogo))<BR>fin
[Acciones.cerrar]
Nombre=cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
EnBarraHerramientas=S
[Acciones.Actualizar Vista]
Nombre=Actualizar Vista
Boton=82
NombreEnBoton=S
NombreDesplegar=Actualizar Vista
EnBarraAcciones=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
EnBarraHerramientas=S
Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>prueba<BR>Actualizar Vista
[Acciones.Actualizar Vista.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Actualizar Vista.Actualizar Vista]
Nombre=Actualizar Vista
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Forma.ActualizarVista<BR> Forma( <T>RM1143EAsignaAgenteFrm<T> )<BR>Forma.Accion(<T>Cerrar<T>)<BR>OtraForma(<T>RM1143GastosFrm<T>,Asigna(Mavi.RM1143EAgente,Mavi.RM1143EAgente))<BR>OtraForma(<T>RM1143GastosFrm<T>,Forma.ActualizarForma)
[Acciones.Actualizar Vista.prueba]
Nombre=prueba
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si Condatos(Mavi.RM1143EIdComer)<BR>Entonces<BR>   Asigna(Mavi.RM1143EAgente,SQL(<T>Select dbo.fn_RM01143EObtenEmpleado(:nID)<T>,Mavi.RM1143EIdComer))<BR>fin
[(Variables).MAVI.RM1143EIdComer]
Carpeta=(Variables)
Clave=MAVI.RM1143EIdComer
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


