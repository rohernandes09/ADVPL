
#include "protheus.ch"

User Function U_TESTE()
    Local oDlg
    Local cNome := Space(50)

    
DEFINE DIALOG oDlg TITLE "Entrada de Dados" FROM 0,0 TO 300,200
    @ 80,30 SAY "Digite seu nome:" SIZE 120,20
    @ 90,30 GET cNome SIZE 250,20
    @ 100,30 BUTTON "Confirmar" SIZE 100,30 ACTION oDlg:End()
ACTIVATE DIALOG oDlg


    MsgInfo("Olá " + Alltrim(cNome) + "! Bem-vindo ao Protheus.", "Saudação")
Return
