C      MAIN PROGRAM TO TEST FIXPNF, FIXPQF, AND FIXPDF
C       BROWN'S FUNCTION, ZERO FINDING.
C
C       THIS PROGRAM TESTS THE HOMPACK ROUTINES FIXPNF, FIXPQF, AND
C       FIXPDF.  THE USER MAY INSERT CALLS TO A SYSTEM TIMER AT THE
C       DESIGNATED LOCATIONS IN ORDER TO GET EXECUTION TIME FOR THESE
C       ROUTINES.
C
C       THE MODIFICATIONS TO BE MADE FOR THE SYSTEM TIMER ARE INDICATED
C       BY A LINE OF M'S, E.G.
CMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
C
C
C       THE OUTPUT FROM THIS ROUTINE SHOULD BE AS FOLLOWS, WITH THE
C       EXECUTION TIMES CORRESPONDING TO A VAX 11/785.
C
C       TESTING FIXPQF
C
C LAMBDA = 1.00000000  FLAG = 1       6 JACOBIAN EVALUATIONS
C EXECUTION TIME(SECS) =      0.44    ARCLEN =     2.693
C   1.00000000E+00  1.00000000E+00  1.00000000E+00
C   1.00000000E+00  1.00000000E+00
C
C       TESTING FIXPNF
C
C LAMBDA = 1.00000000  FLAG = 1      22 JACOBIAN EVALUATIONS
C EXECUTION TIME(SECS) =      0.19   ARCLEN =     2.682
C   1.00000000E+00  1.00000000E+00  1.00000000E+00
C   1.00000000E+00  1.00000000E+00
C
C       TESTING FIXPDF
C
C LAMBDA = 1.00000000  FLAG = 1      71 JACOBIAN EVALUATIONS
C EXECUTION TIME(SECS) =      0.57   ARCLEN =     2.712
C   1.00000000E+00  1.00000000E+00  1.00000000E+00
C   1.00000000E+00  1.00000000E+00
C
C
C
       PROGRAM MAINF
       IMPLICIT DOUBLE PRECISION (A-H,O-Z)
       DOUBLE PRECISION WT(101),PHI(101,16),P(101)
       DOUBLE PRECISION ARCLEN,QT(101,101),R(101*52),F0(101)
       DOUBLE PRECISION F1(101),DZ(101),T(101)
       DOUBLE PRECISION Y(101),W(101),WP(101),Z0(101),Z1(101),
     + YP(101),YOLD(101),YPOLD(101),A(100),QR(101,102),
     + ALPHA(100),TZ(101),SSPAR(8),YSAV(101),PAR(1)
       INTEGER PIVOT(101),CODE,TIME,IPAR(1),N,NDIMA,NFE,TRACE,
     +   IFLAG,II,J,NP1
       CHARACTER*6 NAME
       REAL DTIME
       COMMON /SIZE/ N
C
C TEST EACH OF THE THREE ALGORITHMS.
C
       DO 60 II=1,3
C
C INITIALIZE TIMER VARIABLES.
C
          CODE=2
          TIME=0
          DTIME=0.0
C
C DEFINE ARGUMENTS FOR CALL TO HOMPACK PROCEDURE.
C
          N=5
          NP1=N+1
          ARCRE=0.5D-4
          ARCAE=0.5D-4
          ANSRE=1.0D-10
          ANSAE=1.0D-10
	  TRACE=0
          DO 30 J=1,8
30           SSPAR(J)=0.0
          IFLAG=-1
          DO 40 J=2,NP1
40           Y(J)=0.0D0
C
CMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
C
C INSERT CALL TO INITIALIZE SYSTEM TIMER HERE.  FOR EXAMPLE, FOR
C THE VAX, THE FOLLOWING STATEMENT IS USED.
C
C         CALL LIB$INIT_TIMER
C
CMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
C
C CALL TO HOMPACK ROUTINE.
C
        IF (II .EQ. 1) THEN
           NAME='FIXPQF'
           CALL FIXPQF(N,Y,IFLAG,ARCRE,ARCAE,ANSRE,ANSAE,TRACE,A,NFE,
     +       ARCLEN,YP,YOLD,YPOLD,QT,R,F0,F1,Z0,DZ,W,T,YSAV,
     +       SSPAR,PAR,IPAR)
        ELSE IF (II .EQ. 2) THEN
           NAME='FIXPNF'
           CALL FIXPNF(N,Y,IFLAG,ARCRE,ARCAE,ANSRE,ANSAE,TRACE,A,NFE,
     +       ARCLEN,YP,YOLD,YPOLD,QR,ALPHA,TZ,PIVOT,W,WP,Z0,Z1,
     +       SSPAR,PAR,IPAR)
        ELSE
           NAME='FIXPDF'
           CALL FIXPDF(N,Y,IFLAG,ARCRE,ANSRE,TRACE,A,NDIMA,NFE,
     +       ARCLEN,YP,YPOLD,QR,ALPHA,TZ,PIVOT,WT,PHI,P,PAR,IPAR)
        END IF
C
CMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
C
C INSERT CALL TO RETURN EXECUTION TIME IN SECONDS IN  DTIME.
C FOR EXAMPLE, THE VAX STATEMENTS ARE AS FOLLOWS.
C      CALL LIB$STAT_TIMER(CODE,TIME)
C      DTIME=TIME/100.0
C
CMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
C
          WRITE (6,45) NAME
45        FORMAT (//,8X,'TESTING',1X,6A)
          WRITE (6,50) Y(1),IFLAG,NFE,DTIME,ARCLEN,(Y(J),J=2,NP1)
50        FORMAT(//' LAMBDA =',F11.8,'  FLAG =',I2,I8,' JACOBIAN ',
     +    'EVALUATIONS',/,1X,'EXECUTION TIME(SECS) =',F10.2,4X,
     +     'ARCLEN =',F10.3/(1X,1P,3E16.8))
60     CONTINUE
400    STOP
       END
       SUBROUTINE F(X,V)
C********************************************************************
C
C      SUBROUTINE F(X,V) -- EVALUATES BROWN'S FUNCTION AT THE POINT
C         X, AND RETURNS THE VALUE IN V.
C
C********************************************************************
C
       DOUBLE PRECISION X(1),V(1),PROD,SUM
       INTEGER J,N
       COMMON /SIZE/ N
       PROD=1.0D0
       DO 10 J=1,N
10     PROD=PROD*X(J)
       V(1)=PROD-1.0D0
       SUM=0.0D0
       DO 20 J=1,N
20     SUM=SUM+X(J)
       SUM=SUM-DBLE(N+1)
       DO 30 J=2,N
30     V(J)=SUM+X(J)
       RETURN
       END
       SUBROUTINE FJAC(X,V,K)
C********************************************************************
C
C      SUBROUTINE FJAC(X,V,K)  --  EVALUATES THE K-TH COLUMN OF
C         THE JACOBIAN MATRIX FOR BROWN'S FUNCTION EVALUATED AT
C         THE POINT X, RETURNING THE VALUE IN V.
C
C********************************************************************
C
       DOUBLE PRECISION X(1),V(1),PROD
       INTEGER J,K,N
       COMMON /SIZE/ N
       PROD=1.0D0
       DO 10 J=1,K-1
10     PROD=PROD*X(J)
       DO 15 J=K+1,N
15     PROD=PROD*X(J)
       V(1)=PROD
       DO 20 J=2,N
20     V(J)=1.0D0
       IF (K .GT. 1) V(K)=V(K)+1.0D0
       RETURN
       END
