;;;;;;;;;;;;;;;;;;;;;;;;;
;                       ;
; Nome : Paulo Nicolau  ;
; UAB_Numero: 1800465   ;
; Alinea B              ;
;                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;

ORIG        8000h
Input       STR     5, 1, 4, 8, 2, 16, 7, 12, 10, 11, 13, 14, 6, 9, 15, 3
VETORFIM    WORD    0                                                   ;Reserva espaço livre para Limite Vetor
FIMCICLO    WORD    0                                                   ;Valor da posiçao de Fim de  ciclo externo

ORIG 0000h
;Calcular Inversões (CI)
InicioCalcInv:              MOV R4, Input                               ;Indice Ciclo Externo
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
    FimCicloExterno:        JMP FIM                                     
;Fim Secção

;Secção Erros
    ErroCI:                 MOV R2, FFFFh                               ;Deu erro no calculo de inversoes
                            JMP FIM                                     ;Fim do Programa

FIM:                        JMP FIM                                     ;Fim do Programa
;Fim Programa