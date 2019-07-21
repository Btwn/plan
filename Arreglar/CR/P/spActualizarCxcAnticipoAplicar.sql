SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROC spActualizarCxcAnticipoAplicar
@Empresa    varchar(5),
@Cliente    varchar(10),
@PedidoID   int,
@Estacion   int,
@ID         int

AS
BEGIN
UPDATE Cxc SET AnticipoAplicaID = @ID ,AnticipoAplicaModulo = 'VTAS',AnticipoAplicar = a.AnticipoAplicar
FROM CxcAnticipoPendienteTemp a JOIN Cxc c ON a.ID = c.ID
WHERE a.Estacion = @Estacion AND ISNULL(a.AnticipoAplicar,0.0) > 0.0
UPDATE Cxc SET AnticipoAplicaID = @ID ,AnticipoAplicaModulo = 'VTAS',AnticipoAplicar = a.AnticipoAplicar
FROM CxcAnticipoPendienteTemp2 a JOIN Cxc c ON a.ID = c.ID
WHERE a.Estacion = @Estacion AND ISNULL(a.AnticipoAplicar,0.0) > 0.0
END

