;;;;;;;;;;;;;;;;;;;;;;;;;
;                       ;
; Nome : Paulo Nicolau  ;
; UAB_Numero: 1800465   ;
;                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;

ORIG        8000h
Input       STR     5, 9, 7, 2, 8, 6, 4, 3, 1
VETORFIM    WORD    0   ;Define Limite Vetor
MAX         WORD    0
POSICAO     WORD    0
N           WORD    0

ORIG 0000h
;Ver Tamanho Vetor (VT)
InicioVT:   MOV R4, Input
            MOV R5, R0     
    VT:     CMP M[R4], R0
            BR.Z VTIf
    VTElse: INC R5
            INC R4
            BR VT
    VTIf:   MOV M[N], R5
;FimVT

;Ver Posição maior valor (PMV)
InicioPMV:  MOV R4, Input
            MOV R5, Input
    PMV:    INC R5
            MOV R6, R0
            CMP M[R5], R0
            BR.Z PMVIf
            
    PMVElse:MOV R7, M[R4]
            CMP M[R5], R7
            BR.P Maior
            INC R6
    Maior:  CMP R6,R0
            BR.NZ Proximo 
    Menor:  MOV R4, R5
    Proximo:BR PMV
    PMVIf:  MOV M[POSICAO], R4
;FimPMV