#Include "protheus.ch"
#Include "totvs.ch"
 
/*/{Protheus.doc} ExecFont
    Fun��o criada para chamada de outras fun��es do Protheus para evitar de ficar alterando menus
    @type  Function
    @author Douglas Andrade de Oliveira
    @since 01/10/2025
    @version 1.0
/*/
User Function ExecFont()
    Local aArea     := FWGetArea()
    Local cFuncName := Space(20)
 
    cFuncName := FwInputBox("Qual o nome da fun��o?")
 
    If cFuncName == ""
        MsgInfo("Opera��o cancelada pelo usu�rio.","Opera��o Cancelada")
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
        FWAlertError("Fun��o n�o encontrada no rpo.")
    EndIf
 
    FWRestArea(aArea)
Return
