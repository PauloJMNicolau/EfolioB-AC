;;;;;;;;;;;;;;;;;;;;;;;;;
;                       ;
; Nome : Paulo Nicolau  ;
; UAB_Numero: 1800465   ;
; Alinea A              ;
;                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;

ORIG        8000h
Input       STR     5, 1, 4, 8, 2, 16, 7, 12, 10, 11, 13, 14, 6, 9, 15, 3   ;Vetor de Dados de Entrada
VETORFIM    WORD    0                                                       ;Reserva espaço livre para Limite Vetor
POSICAO     WORD    0                                                       ;Posiçao da Peça Maior

ORIG 0000h
;Verificar Posição do Espaço Vazio (Maior Valor no vetor [MVV])
InicioMVV:                      MOV R4, Input                               ;R4 (Endereço Maior) fica com endereço da posição inicial do vetor
                                CMP M[R4], R0                               ;Verifica se é um valor válido
                                JMP.Z ErroDM                                ;Salta se o valor for inválido
                                MOV R5, Input                               ;R5 (Indice Ciclo)
                                CMP M[R5], R0                               ;Verifica se é um valor válido
                                JMP.Z ErroDM 
    CicloProcura:               INC R5                                      ;Incrementa Ciclo
                                CMP R5, VETORFIM                            ;Verifica se é o valor final do vetor
                                BR.Z FimCicloProcura                        ;
                                MOV R6, R0                                  ;R6 Vai servir para verificar se programa saltou
                                
                                MOV R7, M[R4]                               ;R7 (Valor do Maior Encontrado)
                                CMP M[R5], R7                               ;Compara Valores
                                BR.P Maior                                  ;Salta se Maior(R7) for menor que  valor em R5
                                INC R6                                      ;Se for maior incrementa R6
        Maior:                  CMP R6, R0                                  ;Verifica se valor era maior
                                BR.NZ Proximo                               ;Salta se for menor
                                MOV R4, R5                                  ;R4 fica com o endereço no novo valor maior                                
        Proximo:                JMP CicloProcura                            ;Executa nova interação do ciclo
    FimCicloProcura:            MOV M[POSICAO], R4                          ;Coloca na memoria a posição no vetor do valor mais alto encontrado
                                JMP InicioDM                                ;
;Fim Secção

;Calcular Distancia de Manhatan
InicioDM:                       MOV R4, Input                               ;Endereço Posição inicial vetor
                                MOV R5, M[POSICAO]                          ;Endereço Maior Valor do Vetor
                                CMP R5, FFFFh                               ;Verifica se foi encontrado valor maior                              
                                SUB R5, R4                                  ;Calcula Distancia desde o inicio do vetor
                                MOV R6, 4                                   ;Valor do Tamanho da linha/coluna da matriz
                                INC R5                                      ;Incrementa valor de R5 para corrigir valor de indice 
                                DIV R5, R6                                  ;Calcula posições linha(R5) e coluna (R6)
                                JMP.O ErroDM                                ;Divisão por zero
                                CMP R6, R0                                  ;Verifica se Resto igual a 0
                                BR.NZ RestoDiferenteZero
    RestoZero:                  MOV R6, 4                                   ;Corrige Valor da Coluna
                                JMP Coninuar
    RestoDiferenteZero:         INC R5                                      ;Corrige valor de Linha                            
    Coninuar:                   MOV R4, 4                                   ;Posição Final do espaço Vazio (4x4)
                                SUB R5, R4                                  ;Linha - 4 
                                BR.P R5Positivo
                                NEG R5                                      ;Coloca R5 a Positivo
        R5Positivo:             SUB R6, R4                                  ;Coluna - 4
                                BR.P R6Positivo
                                NEG R6                                      ;Coloca R6 Positivo
        R6Positivo:             ADD R5, R6                                  ;Calcula Distancia Manhattan
                                BR FimDM
    FimDM:                      MOV R1, R5                                  ;Atribui a R1 Valor de Distancia Manhattan
                                JMP FIM                                     ;Fim do Programa
;Fim Secção

;Secção Erros
    ErroDM:                     MOV R1, FFFFh
                                JMP FIM
FIM:                            JMP FIM                                     ;Fim do Programa
;Fim Programa