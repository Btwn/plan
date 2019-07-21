SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER VIEW MFAEmpresa AS
SELECT
em.Empresa							'id_empresa',
ISNULL(em.Nombre, '')				'Nombre',
ISNULL(em.Grupo, '')				'Grupo',
ISNULL(em.Direccion, '')			'Direccion',
ISNULL(em.DireccionNumero, '')		'DireccionNumero',
ISNULL(em.DireccionNumeroInt, '')	'DireccionNumeroInt',
ISNULL(em.Poblacion, '')			'Clave_ciudad',
ISNULL(em.CodigoPostal, '')			'CodigoPostal',
ISNULL(em.Telefonos, '')			'Telefonos',
ISNULL(em.RFC, '')					'RFC',
ISNULL(RegistroPatronal, '')		'RegistroPatronal'
FROM EmpresaMFA e
JOIN Empresa em ON e.Empresa = em.Empresa

