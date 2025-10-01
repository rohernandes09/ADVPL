#include "protheus.ch"
User Function U_Soma()
    Local nNum1 := 0
    Local nNum2 := 0
    Local nSoma := 0

    // Solicita o primeiro número
    Pergunte("Digite o primeiro número:", @nNum1)

    // Solicita o segundo número
    Pergunte("Digite o segundo número:", @nNum2)

    // Calcula a soma
    nSoma := nNum1 + nNum2

    // Exibe o resultado
    MsgInfo("A soma de " + AllTrim(Str(nNum1)) + " e " + AllTrim(Str(nNum2)) + " é " + AllTrim(Str(nSoma)) + ".", "Resultado da Soma")
Return
