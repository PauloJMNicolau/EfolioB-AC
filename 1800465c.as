;;;;;;;;;;;;;;;;;;;;;;;;;
;                       ;
; Nome : Paulo Nicolau  ;
; UAB_Numero: 1800465   ;
; Alinea C              ;
;                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;

ORIG        8000h
Input       STR     5, 1, 4, 8, 2, 16, 7, 12, 10, 11, 13, 14, 6, 9, 15, 3   ;Vetor de Dados de Entrada
VETORFIM    WORD    0                                                       ;Reserva espaço livre para Limite Vetor
POSICAO     WORD    0                                                       ;Posiçao da Peça Maior
FIMCICLO    WORD    0                                                       ;Valor da posiçao de Fim de  ciclo externo

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
                                JMP InicioDM                                ;Salta para próxima secção
;Fim Secção

;Calcular Distancia de Manhatan (DM)
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
                                JMP InicioCalcInv                           ;Salta para próxima secção
;Fim Secção

;Calcular Inversões (CI)
InicioCalcInv:                  MOV R4, Input                               ;Indice Ciclo Externo
                                MOV R7, VETORFIM                            ;
                                DEC R7                                      ;Valor Final do Ciclo Externo
                                MOV M[FIMCICLO], R7                         ;
                                MOV R2, R0                                  ;R2 guarda contador de inversoes
                                CMP M[R4], R0                               ;Verifica se existem valores validos para R4 e salta caso nao exista
                                JMP.Z ErroCI                                ;
        CicloExterno:           CMP R4, M[FIMCICLO]                         ;Verifica se é posição final
                                BR.Z FimCicloExterno                        ;
                                MOV R5, R4                                  ;Atribui a R5 valor de R4 e Incrementa (indice interno)
                                INC R5                                      ;
                                CMP M[R5], R0                               ;Verifica se existem valores validos para R5
                                JMP.Z ErroCI                                ;
            CicloInterno:       CMP R5, VETORFIM                            ;Verifica se chegou ao final do vetor
                                BR.Z  FimCicloInterno                       ;
                                MOV R6, R0                                  ;Coloca R6 a 0 (permite verificar se valor é maior ou menor)
                                MOV R7, M[R4]                               ;Valor em memoria de R4
                                CMP M[R5], R7                               ;Compara se o valor seguinte(R5) é maior que o valor atual (R4)
                                BR.P ValorMaior                             ;Salta se for Maior
                                INC R6                                      ; 
            ValorMaior:         CMP R6, R0                                  ;Verifica se programa saltou (Valor era maior)  
                                BR.Z ProximoInt                             ;Se for menor salta para proximo interação
                                INC R2                                      ;Se for maior incrementa contador (R2)
            ProximoInt:         INC R5                                      ;Incrementa ciclo interno
                                BR CicloInterno                             ;Proxima interação ciclo interno
            FimCicloInterno:    INC R4                                      ;Incrementa Ciclo Externo
                                BR CicloExterno                             ;Proxima interação ciclo externo
        FimCicloExterno:        JMP InicioPR                                ;Salta para próxima secção                                    
;Fim Secção

;CalcularPuzzleResoluvel(PR)
InicioPR:                       CMP R1, FFFFh                               ;Verifica se valor de distancia Manhattan é valido
                                JMP.Z ErroPR                                ;
                                CMP R2, FFFFh                               ;Em caso de não serem validos salta para erro e termina 
                                JMP.Z ErroPR                                ;
                                MOV R4, R1                                  ;Copia valor de R1 (distancia) para R4
                                MOV R5, R2                                  ;Copia valor de R2 (inversoes) para R5
                                ADD R4, R5                                  ;Soma valores de distancia e inversoes
                                MOV R5, 2                                   ;Divide valor de soma por 2
                                DIV R4, R5                                  ;
                                JMP.O ErroPR                                ;
                                CMP R5, R0                                  ;Verifica se o resto é 0
                                BR.NZ Impar
        Par:                    MOV R3, 1                                   ;Puzzle é resoluvel
                                JMP FIM
        Impar:                  MOV R3, 0                                   ;Puzzle não é resoluvel
                                JMP FIM

;Fim Secção

;Secção Erros
    ErroDM:                     MOV R1, FFFFh                               ;Deu erro no calculo da distancia de Manhattan
                                JMP FIM                                     ;
    ErroCI:                     MOV R2, FFFFh                               ;Deu erro no calculo de inversoes
                                JMP FIM                                     ;
    ErroPR:                     MOV R3, FFFFh                               ;Deu erro no calculo
FIM:                            JMP FIM                                     ;Fim do Programa
;Fim Programa
