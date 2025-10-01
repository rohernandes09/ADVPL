#include "protheus.ch"

User Function U_NOME()
    Local cNome := ""

    // Solicita o nome do usuário
    Pergunte("Digite seu nome:", @cNome)

    // Exibe a saudação
    MsgInfo("Olá, " + AllTrim(cNome) + "! Bem-vindo ao Protheus.", "Saudação")
Return
