#Include "protheus.ch"
#Include "totvs.ch"
 
/*/{Protheus.doc} ExecFont
    Função criada para chamada de outras funções do Protheus para evitar de ficar alterando menus
    @type  Function
    @author Douglas Andrade de Oliveira
    @since 01/10/2025
    @version 1.0
/*/
User Function ExecFont()
    Local aArea     := FWGetArea()
    Local cFuncName := Space(20)
 
    cFuncName := FwInputBox("Qual o nome da função?")
 
    If cFuncName == ""
        MsgInfo("Operação cancelada pelo usuário.","Operação Cancelada")
        FWRestArea(aArea)
        Return
    EndIf
 
    cFuncName := StrTran(cFuncName,"U_","")
    cFuncName := StrTran(cFuncName,"()","")
 
    cFuncName := "U_" + cFuncName
 
    If FindFunction(cFuncName)
        cFuncName := cFuncName + "()"
        &cFuncName
    Else
        FWAlertError("Função não encontrada no rpo.")
    EndIf
 
    FWRestArea(aArea)
Return
