SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spClavePresupuestalEnMascara
@Proyecto		varchar(50),
@ClavePresupuestal	varchar(50),
@Cat1		varchar(50) OUTPUT,
@Cat2		varchar(50) OUTPUT,
@Cat3		varchar(50) OUTPUT,
@Cat4		varchar(50) OUTPUT,
@Cat5		varchar(50) OUTPUT,
@Cat6		varchar(50) OUTPUT,
@Cat7		varchar(50) OUTPUT,
@Cat8		varchar(50) OUTPUT,
@Cat9		varchar(50) OUTPUT,
@CatA		varchar(50) OUTPUT,
@CatB		varchar(50) OUTPUT,
@CatC		varchar(50) OUTPUT

AS BEGIN
DECLARE @Mascara		varchar(50),
@MascaraReves		varchar(50),
@MascaraLargo		int,
@Inicio1		int,
@Fin1			int,
@Inicio2		int,
@Fin2			int,
@Inicio3		int,
@Fin3			int,
@Inicio4		int,
@Fin4			int,
@Inicio5		int,
@Fin5			int,
@Inicio6		int,
@Fin6			int,
@Inicio7		int,
@Fin7			int,
@Inicio8		int,
@Fin8			int,
@Inicio9		int,
@Fin9			int,
@InicioA		int,
@FinA			int,
@InicioB		int,
@FinB			int,
@InicioC		int,
@FinC			int
SELECT @Mascara = p.ClavePresupuestalMascara,
@MascaraReves = REVERSE(p.ClavePresupuestalMascara),
@MascaraLargo = LEN(p.ClavePresupuestalMascara)
FROM Proy p
WHERE p.Proyecto = @Proyecto
SELECT @Inicio1 = CHARINDEX('1', @Mascara),
@Fin1	   = ((@MascaraLargo - CHARINDEX('1', @MascaraReves)) +2) - @Inicio1,
@Inicio2 = CHARINDEX('2', @Mascara),
@Fin2	   = ((@MascaraLargo - CHARINDEX('2', @MascaraReves)) +2) - @Inicio2,
@Inicio3 = CHARINDEX('3', @Mascara),
@Fin3	   = ((@MascaraLargo - CHARINDEX('3', @MascaraReves)) +2) - @Inicio3,
@Inicio4 = CHARINDEX('4', @Mascara),
@Fin4	   = ((@MascaraLargo - CHARINDEX('4', @MascaraReves)) +2) - @Inicio4,
@Inicio5 = CHARINDEX('5', @Mascara),
@Fin5	   = ((@MascaraLargo - CHARINDEX('5', @MascaraReves)) +2) - @Inicio5,
@Inicio6 = CHARINDEX('6', @Mascara),
@Fin6	   = ((@MascaraLargo - CHARINDEX('6', @MascaraReves)) +2) - @Inicio6,
@Inicio7 = CHARINDEX('7', @Mascara),
@Fin7	   = ((@MascaraLargo - CHARINDEX('7', @MascaraReves)) +2) - @Inicio7,
@Inicio8 = CHARINDEX('8', @Mascara),
@Fin8	   = ((@MascaraLargo - CHARINDEX('8', @MascaraReves)) +2) - @Inicio8,
@Inicio9 = CHARINDEX('9', @Mascara),
@Fin9	   = ((@MascaraLargo - CHARINDEX('9', @MascaraReves)) +2) - @Inicio9,
@InicioA = CHARINDEX('A', @Mascara),
@FinA	   = ((@MascaraLargo - CHARINDEX('A', @MascaraReves)) +2) - @InicioA,
@InicioB = CHARINDEX('B', @Mascara),
@FinB	   = ((@MascaraLargo - CHARINDEX('B', @MascaraReves)) +2) - @InicioB,
@InicioC = CHARINDEX('C', @Mascara),
@FinC	   = ((@MascaraLargo - CHARINDEX('C', @MascaraReves)) +2) - @InicioC
SELECT @Cat1 = SUBSTRING(@ClavePresupuestal, NULLIF(@Inicio1,0), @Fin1),
@Cat2 = SUBSTRING(@ClavePresupuestal, NULLIF(@Inicio2,0), @Fin2),
@Cat3 = SUBSTRING(@ClavePresupuestal, NULLIF(@Inicio3,0), @Fin3),
@Cat4 = SUBSTRING(@ClavePresupuestal, NULLIF(@Inicio4,0), @Fin4),
@Cat5 = SUBSTRING(@ClavePresupuestal, NULLIF(@Inicio5,0), @Fin5),
@Cat6 = SUBSTRING(@ClavePresupuestal, NULLIF(@Inicio6,0), @Fin6),
@Cat7 = SUBSTRING(@ClavePresupuestal, NULLIF(@Inicio7,0), @Fin7),
@Cat8 = SUBSTRING(@ClavePresupuestal, NULLIF(@Inicio8,0), @Fin8),
@Cat9 = SUBSTRING(@ClavePresupuestal, NULLIF(@Inicio9,0), @Fin9),
@CatA = SUBSTRING(@ClavePresupuestal, NULLIF(@InicioA,0), @FinA),
@CatB = SUBSTRING(@ClavePresupuestal, NULLIF(@InicioB,0), @FinB),
@CatC = SUBSTRING(@ClavePresupuestal, NULLIF(@InicioC,0), @FinC)
RETURN
END

