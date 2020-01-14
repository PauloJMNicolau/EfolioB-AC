;;;;;;;;;;;;;;;;;;;;;;;;;
;                       ;
; Nome : Paulo Nicolau  ;
; UAB_Numero: 1800465   ;
; Alinea A              ;
;                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;

ORIG        8000h
Input       STR     5, 1, 4, 8, 2, 16, 7, 12, 10, 11, 13, 14, 6, 9, 15, 3
VETORFIM    WORD    0   ;Define Limite Vetor
POSICAO     WORD    0   ;Posiçao da Peça Maior

ORIG 0000h
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

;Calcular Distancia
Inicio:         MOV R4, Input
                MOV R5, M[POSICAO]
                SUB R5, R4          ;Calcula Distancia desde o inicio do vetor
                MOV R6, 4           ;Coloca R6 com o valor 4
                INC R5              ;Incrementa valor de R5 para corrigir valor de indice
                DIV R5, R6          ;Calcula posições linha(R5) e coluna (R6)
                BR.O Erro
                INC R5
                MOV R4, 4           ;Coloca R4 a 4(posição 4x4)
                SUB R5, R4          ;Linha - 4 
                BR.P R5Positivo
                NEG R5              ;Coloca R5 a Positivo
    R5Positivo: SUB R6, R4          ;Coluna - 4
                BR.P R6Positivo
                NEG R6              ;Coloca R6 Positivo
    R6Positivo: ADD R5, R6          ;Calcula Distancia Manhattan
                BR Fim
    Erro:       MOV R1, FFFFh       ;Deu erro a operação
    Fim:        MOV R1, R5          ;Atribui a R1 Valor de Distancia Manhattan