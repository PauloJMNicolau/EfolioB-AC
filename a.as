;;;;;;;;;;;;;;;;;;;;;;;;;
;                       ;
; Nome : Paulo Nicolau  ;
; UAB_Numero: 1800465   ;
; Alinea A              ;
;                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;

ORIG        8000h
Input       STR     5, 1, 4, 8, 2, 16, 7, 12, 10, 11, 13, 14, 6, 9, 15, 3
VETORFIM    WORD    0   ;Reserva espaço livre para Limite Vetor
POSICAO     WORD    0   ;Posiçao da Peça Maior

ORIG 0000h
;Ver Posição maior valor (PMV)
InicioPMV:  MOV R4, Input
            MOV R5, Input
    PMV:    INC R5
            MOV R6, R0          ;Coloca a 0 R6 (vai servir para sverificar se valor é maior ou menor)
            CMP M[R5], R0       ;Verifica se é uma posição livre(valor 0)
            BR.Z PMVIf          ;Salta para o final de PMV
    PMVElse:MOV R7, M[R4]       ;Atribui a R7 valor mais alto encotrado
            CMP M[R5], R7       ;Compara se valor de R5 é maior que o mais alto encontrado 
            BR.P Maior          ;Salta se for maior
            INC R6
    Maior:  CMP R6,R0           ;Verifica se valor de R5 era maior ou menor
            BR.NZ Proximo       ;Se for menor salta para o proximo ciclo
            MOV R4, R5          ;Se for Maior coloca em R4 valor de R5
    Proximo:BR PMV
    PMVIf:  MOV M[POSICAO], R4  ;Coloca na memoria a posição no vetor do valor mais alto encontrado
;FimPMV

;Calcular Distancia Manhattan
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
                BR FimCM
    Fim:        MOV R1, R5          ;Atribui a R1 Valor de Distancia Manhattan
    FimCM:      NOP
;FimCalculoManhattan
