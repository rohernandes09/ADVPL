#INCLUDE "PROTHEUS.CH"

User Function UPDSRQ()

Local aButtons  := {}
Local aSays     := {}
Local cMsg      := ""
Local lContinua := .F.
Local nOpcA     := 0
Local aErros	:= {}
Local cMsgHelp	:= ""
Local cLink		:= 'https://tdn.totvs.com/x/0hiVMw'

Private aLog    := {}
Private aTitle  := {}
Private cPerg   := "UPDSRQ"

// VERIFICA SE ENCONTROU O GRUPO DE PERGUNTAS

If  !SX1->(DbSeek('UPDSRQ'))
	cMsg :=  + CRLF + OemToAnsi("Não foi encontrado o grupo de perguntas: ") + Alltrim(cPerg)
	
	cMsgHelp += + CRLF + OemToAnsi("Antes de prosseguir será necessário criar o grupo de perguntas. Para isso, siga as instruções contidos no link abaixo:")
	cMsgHelp += + CRLF + cLink + CRLF

	aAdd(aErros, cMsgHelp)
	
	Help(,, 'NOPERGUNT',, cMsg, 1, 0,,,,,, {aErros})
			
	Return()
EndIf

aAdd(aSays,OemToAnsi( "Este programa tem como objetivo, ajustar o cadastro de beneficiarios, devido a alguns " ))
aAdd(aSays,OemToAnsi( "problemas detectados na base, após alterações em pensões com base de calculo " ))

aAdd(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
aAdd(aButtons, { 1,.T.,{|o| nOpcA := 1,IF(gpconfOK(), FechaBatch(), nOpcA := 0 ) }} )
aAdd(aButtons, { 2,.T.,{|o| FechaBatch() }} )

//Abre a tela de processamento
FormBatch( "Ajuste para beneficiarios com pensão calculada por base de calculo sobre verbas", aSays, aButtons )

//Efetua o processamento de geração
If nOpcA == 1
    Aadd( aTitle, OemToAnsi( "Funcionario com beneficiario ajustado" ) )
    Aadd( aLog, {} )
    ProcGpe( {|lEnd| fProcessa()},,,.T. )
    fMakeLog(aLog,aTitle,,,"UPDSRQ",OemToAnsi("Log de Ocorrências"),"M","P",,.F.)
EndIf

Return

/*/{Protheus.doc} fProcessa
Função que efetua os ajustes na base dos beneficiarios
/*/
Static Function fProcessa()
Local aArea     := GetArea()
Local cAliasQry := GetNextAlias()
Local lDelet    := .F.
Local lSeqEmpty := .F.
Local lSeq02    := .F.
Local lProc     := .F.
Local cAlias    := "SRQ"
Local nOpc      := 1 
Local nSeq      := 0

Pergunte( cPerg, .F. )
MakeSqlExpr( cPerg )

dbSelectArea("SRQ")

nOpc := MV_PAR04

    cAliasQry := GetNextAlias()

    //Processa a query e cria a tabela temporária com os resultados
    BeginSql alias cAliasQry
        SELECT SRQ.RQ_FILIAL, SRQ.RQ_MAT, SRQ.RQ_ORDEM, SRQ.RQ_SEQUENC, SRQ.R_E_C_D_E_L_, SRQ.RQ_VERBAS, SRQ.R_E_C_N_O_ AS RECNOSRQ
        FROM %table:SRQ% SRQ
        WHERE RQ_FILIAL = %Exp:MV_PAR01%
        AND RQ_MAT = %Exp:MV_PAR02%
        AND RQ_ORDEM = %Exp:MV_PAR03%
        AND RQ_VERBAS <> '' 
        ORDER BY SRQ.RQ_VERBAS, SRQ.RQ_FILIAL, SRQ.RQ_MAT, SRQ.RQ_ORDEM, SRQ.RQ_SEQUENC
    EndSql 

    //Inclusao 08/2024 gera erro array out of bounds [0] of [0]  on GP280ACOLS(GPEA280.PRX) 12/08/2024 17:54:52 line 

    If nOpc = 1
        While (cAliasQry)->( !EoF() )
            lProc := .T.
            If (cAliasQry)->RQ_SEQUENC == "01" .AND. (cAliasQry)->R_E_C_D_E_L_ == RECNOSRQ
                lDelet := .T.
            Endif
            If Empty((cAliasQry)->RQ_SEQUENC)  .AND. (cAliasQry)->R_E_C_D_E_L_ == 0
                lSeqEmpty := .T.
            Endif
            If (cAliasQry)->RQ_SEQUENC == "02"  .AND. (cAliasQry)->R_E_C_D_E_L_ == 0
                lSeq02 := .T.
            Endif
            (cAliasQry)->( dbSkip() )
        Enddo   
        (cAliasQry)->( dbCloseArea() )

        If lDelet .And. lSeqEmpty .And. lSeq02
            cAliasQry := GetNextAlias()

            BeginSql alias cAliasQry
            SELECT SRQ.RQ_FILIAL, SRQ.RQ_MAT, SRQ.RQ_ORDEM, SRQ.RQ_SEQUENC, SRQ.R_E_C_D_E_L_, SRQ.RQ_VERBAS, SRQ.R_E_C_N_O_ AS RECNOSRQ
            FROM %table:SRQ% SRQ
            WHERE RQ_FILIAL = %Exp:MV_PAR01%
                AND RQ_MAT = %Exp:MV_PAR02%
                AND RQ_ORDEM = %Exp:MV_PAR03%
                AND RQ_VERBAS <> '' 
            ORDER BY  SRQ.RQ_FILIAL, SRQ.RQ_MAT, SRQ.RQ_ORDEM, SRQ.R_E_C_D_E_L_, SRQ.RQ_SEQUENC  DESC
            EndSql 

            SRQ->(DBGoTop())
            While (cAliasQry)->( !EoF() )
                If (cAliasQry)->R_E_C_D_E_L_ == (cAliasQry)->RECNOSRQ .And. (cAliasQry)->RQ_SEQUENC == "01"
                    SRQ->(dbGoto((cAliasQry)->RECNOSRQ))
                    If SRQ->( RecLock("SRQ", .F.) )
                        SRQ->(DBRecall())
                        SRQ->( MsUnlock() )
                    Endif
                ElseIf (cAliasQry)->R_E_C_D_E_L_ == 0 
                    nSeq   := Val((cAliasQry)->RQ_SEQUENC)
                    SRQ->(dbGoto((cAliasQry)->RECNOSRQ))    
                    If SRQ->( RecLock("SRQ", .F.) )
                    SRQ->RQ_SEQUENC := StrZero(nSeq+2,2)
                    nSeq ++
                    SRQ->( MsUnlock() )
                    Endif
                Endif 
             
                (cAliasQry)->( dbSkip() )  
            EndDo
            (cAliasQry)->( dbCloseArea() )
        Endif
    Endif

    //Apagar registro
    If nOpc = 2
        lProc := .T.
        SRQ->(DBGoTop())
        IF MsgYesNo( "Confirma a exclusão deste beneficiário? " ) //"Confirma a exclusao deste item?"
            While (cAliasQry)->( !EoF() )
                SRQ->(dbGoto((cAliasQry)->RECNOSRQ))  
                If SRQ->( RecLock("SRQ", .F.) )
                    SRQ->(DBDelete())
                    SRQ->( MsUnlock() )
                Endif
                (cAliasQry)->( dbSkip() )  
            EndDo
        Endif    
        (cAliasQry)->( dbCloseArea() )
    Endif
    

    If !lProc
       aAdd( aLog[1], "Não foram encontrados registros para processamento.")
    Else
       aAdd( aLog[1], "Registros Processados.")
    EndIf

   RestArea( aArea)

Return

