;;;;;;;;;;;;;;;;;;;;;;;;;
;                       ;
; Nome : Paulo Nicolau  ;
; UAB_Numero: 1800465   ;
; Alinea C              ;
;                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;

ORIG        8000h
Input       STR     5, 1, 4, 8, 2, 16, 7, 12, 10, 11, 13, 14, 6, 9, 15, 3
VETORFIM    WORD    0   ;Reserva espaço livre para Limite Vetor
POSICAO     WORD    0   ;Posiçao da Peça Maior
FIM         WORD    0   ;Valor da posiçao de Fim de  ciclo externo

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
                BR.O ErroCM
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
    ErroCM:     MOV R1, FFFFh       ;Deu erro a operação
                BR FimCM
    Fim:        MOV R1, R5          ;Atribui a R1 Valor de Distancia Manhattan
    FimCM:      NOP
;FimCalculoManhattan


;Calcular Inversões (CI)
InicioCalcInv:              MOV R4, Input           ;Indice Ciclo Externo
                            MOV R7, VETORFIM        ;
                            DEC R7                  ;Valor Final do Ciclo Externo
                            MOV M[FIM], R7          
                            MOV R2, R0              ;R2 guarda contador de inversoes
                            CMP M[R4], R0           ;Verifica se existem valores validos para R4
                            BR.Z ErroCI
    CicloExterno:           CMP R4, M[FIM]          ;Verifica se Posições são as mesmas
                            BR.Z FimCicloExterno
                            MOV R5, R4              ;Atribui a R5 valor de R4 e Incrementa (indice interno)
                            INC R5
                            CMP M[R5], R0           ;Verifica se existem valores validos para R5
                            BR.Z ErroCI
        CicloInterno:       CMP M[R5], R0           ;Verifica se chegou ao final do vetor
                            BR.Z  FimCicloInterno   ;
                            MOV R6, R0              ;Coloca R6 a 0 (permite verificar se valor é maior ou menor)
                            MOV R7, M[R4]           ;Valor em memoria de R4
                            CMP M[R5], R7           ;Compara se o valor seguinte(R5) é maior que o valor atual (R4)
                            BR.P ValorMaior         ;Salta se for Maior
                            INC R6                  
        ValorMaior:         CMP R6, R0              ;Verifica se programa saltou (Valor era maior)  
                            BR.Z ProximoInt         ;Se for menor salta para proximo interação
                            INC R2                  ;Se for maior incrementa contador (R2)
        ProximoInt:         INC R5                  ;Incrementa ciclo interno
                            BR CicloInterno
        FimCicloInterno:    INC R4                  ;Incrementa Ciclo Externo
                            BR CicloExterno
    FimCicloExterno:        BR FimCI
    ErroCI:                 MOV R2, FFFFh           ;Deu erro
        FimCI:              NOP
;FimInicioCalcInv

;CalcularPuzzleResoluvel(PR)
InicioPR:                       CMP R1, FFFFh       ; 
                                BR.Z ErroPR           ;Verifica se valores nos registos R1 e R2 são Validos
                                CMP R2, FFFFh       ;Em caso de não serem validos salta para erro e termina 
                                BR.Z ErroPR           ;
                                MOV R4, R1          ;Move valor de R1 (distancia) para R4
                                MOV R5, R2          ;Move valor de R2 (inversoes) para R5
                                ADD R4, R5          ;Soma valores de distancia e inversoes
                                MOV R5, 2           
                                DIV R4, R5          ;Divide valor de soma por 2
                                CMP R5, R0          ;Verifica se o resto é 0
                                BR.NZ Impar
        Par:                    MOV R3, 1           ;Puzzle é resoluvel
                                BR FimPR
        Impar:                  MOV R3, 0           ;Puzzle não é resoluvel
                                BR FimPR
    ErroPR:                     MOV R3, FFFFh       ;Deu erro
FimPR:                          NOP
;FimCalcularPuzzleResoluvel