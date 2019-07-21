SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spCFDXSL
@Empresa	char(5),
@Modulo 	varchar(20),
@Id 		int

AS BEGIN
DECLARE
@XSL		varchar(255),
@Cliente 		varchar(20),
@TipoAddenda 	varchar(20),
@Fecha			datetime
IF @Modulo = 'VTAS'
SELECT @Cliente = Cliente FROM Venta WITH (NOLOCK) WHERE ID = @ID
IF @Modulo = 'CXC'
SELECT @Cliente = Cliente FROM CXC WITH (NOLOCK) WHERE ID = @ID
SELECT @Fecha = Fecha FROM CFD WITH (NOLOCK) WHERE Modulo = @Modulo AND ModuloID = @ID
IF @Fecha IS NULL SELECT @Fecha = GETDATE()
SELECT @TipoAddenda = TipoAddenda FROM CteCFD WITH (NOLOCK) WHERE Cliente = @Cliente
SELECT @XSL = NULL
/*  IF @TipoAddenda = 'AMECE / LIVERPOOL'
SELECT @XSL = XSL FROM CteCFD WITH (NOLOCK) WHERE Cliente = @Cliente
ELSE */
SELECT @XSL = CASE WHEN VersionFecha < @Fecha OR VersionFecha IS NULL THEN XSL ELSE XSLAnterior END FROM EmpresaCFD WITH (NOLOCK) WHERE Empresa = @Empresa
EXEC xpCFDxsl @Empresa, @Modulo, @Id, @Cliente, @TipoAddenda, @XSL OUTPUT
SELECT 'XSL' = @XSL
RETURN
END

