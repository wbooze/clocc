      SUBROUTINE MCON(ETA,INFINY,SMALNO,BASE)                           MCON4840
C MCON PROVIDES MACHINE CONSTANTS USED IN VARIOUS PARTS OF THE
C PROGRAM. THE USER MAY EITHER SET THEM DIRECTLY OR USE THE
C STATEMENTS BELOW TO COMPUTE THEM. THE MEANING OF THE FOUR
C CONSTANTS ARE -
C ETA       THE MAXIMUM RELATIVE REPRESENTATION ERROR
C WHICH CAN BE DESCRIBED AS THE SMALLEST POSITIVE
C FLOATING-POINT NUMBER SUCH THAT 1.0D0 + ETA IS
C GREATER THAN 1.0D0.
C INFINY    THE LARGEST FLOATING-POINT NUMBER
C SMALNO    THE SMALLEST POSITIVE FLOATING-POINT NUMBER
C BASE      THE BASE OF THE FLOATING-POINT NUMBER SYSTEM USED
C LET T BE THE NUMBER OF BASE-DIGITS IN EACH FLOATING-POINT
C NUMBER(DOUBLE PRECISION). THEN ETA IS EITHER .5*B**(1-T)
C OR B**(1-T) DEPENDING ON WHETHER ROUNDING OR TRUNCATION
C IS USED.
C LET M BE THE LARGEST EXPONENT AND N THE SMALLEST EXPONENT
C IN THE NUMBER SYSTEM. THEN INFINY IS (1-BASE**(-T))*BASE**M
C AND SMALNO IS BASE**N.
C THE VALUES FOR BASE,T,M,N BELOW CORRESPOND TO THE IBM/360.
      DOUBLE PRECISION ETA,INFINY,SMALNO,BASE
      INTEGER M,N,T
      BASE = 16.0D0
      T = 14
      M = 63
      N = -65
      ETA = BASE**(1-T)
      INFINY = BASE*(1.0D0-BASE**(-T))*BASE**(M-1)
      SMALNO = (BASE**(N+3))/BASE**3
      RETURN
      END
