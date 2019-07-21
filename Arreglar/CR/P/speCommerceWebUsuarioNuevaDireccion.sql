SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE speCommerceWebUsuarioNuevaDireccion
@Cliente varchar(10)

AS BEGIN
IF NOT EXISTS(SELECT ID FROM CteEnviarA WHERE Cliente = @Cliente)
BEGIN
INSERT CteEnviarA(ID, GUID, Cliente,  Nombre,	Direccion,          DireccionNumeroInt,                                          Pais,     Estado,   Poblacion, CodigoPostal, Estatus, Delegacion,  DireccionNumero, Colonia,   eMail1, Telefonos)
SELECT 			  1, NEWID(), Cliente, ISNULL(NULLIF(Nombre, ''), 'N/A'), ISNULL(NULLIF(Direccion, ''), 'N/A'),          ISNULL(NULLIF(DireccionNumeroInt, ''), 'N/A'),                                          ISNULL(NULLIF(Pais, ''), 'N/A'),     ISNULL(NULLIF(Estado, ''), 'N/A'),   ISNULL(NULLIF(Poblacion, ''), 'N/A'), ISNULL(NULLIF(CodigoPostal, '00000'), 'N/A'), Estatus, ISNULL(NULLIF(Delegacion, ''), 'N/A'),  ISNULL(NULLIF(DireccionNumero, ''), 'N/A'), ISNULL(NULLIF(Colonia, ''), 'N/A'),   ISNULL(NULLIF(eMail1, ''), 'N/A'), ISNULL(NULLIF(Telefonos, ''), '00000')
FROM Cte WHERE Cliente = @Cliente
END
END

