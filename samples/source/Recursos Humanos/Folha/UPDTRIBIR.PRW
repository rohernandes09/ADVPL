#INCLUDE "PROTHEUS.CH"

User Function UPDTRIBIR()

    Local aButtons      := {}
    Local aSays         := {}
    Local nOpcA         := 0

    Private aLogUPD     := {}
    Private aTitle      := {}
    Private cPerg       := "UPDTRIBIR"

    If !fVldSX1()
        cMsg := "Para executar essa rotina é obrigatório possuir o grupo de perguntas UPDTRIBIR." + CRLF
        cMsg += "Verifique a documentação no TDN: https://tdn.totvs.com/pages/viewpage.action?pageId=824196728."
        MsgInfo(cMsg)
        Return()
    EndIf

    AAdd( aSays, 'Este programa tem como objetivo preencher o conteúdo do campo "Trib. IR" (RD_TRIBIR)' )
    AAdd( aSays, "das verbas de base de IR que não possuem informação nesse campo, a partir do período" )
    AAdd( aSays, "05/2023, para que o programa de geração da DIRF possa validar qual o modelo de" )
    AAdd( aSays, "tributação do IR foi utilizado no cálculo." )
    AAdd( aSays, 'Clique no botão "Abrir" para abrir a documentação no TDN.' )

    AAdd( aButtons, { 14, .T., { || ShellExecute( "open", "https://tdn.totvs.com/pages/viewpage.action?pageId=824196728", "", "", 1 ) } } )
    AAdd( aButtons, { 5, .T., { || Pergunte( cPerg, .T. ) } } )
    AAdd( aButtons, { 1, .T., { || nOpcA := 1, IIf(gpconfOK(), FechaBatch(), nOpcA := 0 ) } } )
    AAdd( aButtons, { 2, .T., { || FechaBatch() } } )

    //Abre a tela de processamento
    FormBatch( 'Atualização do campo "Trib. IR" (RD_TRIBIR)', aSays, aButtons )

    If nOpcA == 1 .And. MsgNoYes("Foi efetuado o backup da tabela SRD?", "Atenção!") .And. MsgYesNo("Tem certeza que deseja continuar?", "Atenção!")
        AAdd( aTitle, OemToAnsi( "Atualizações realizadas:" ) )
        AAdd( aLogUPD, {} )
        Processa( { || fProcessa() }, "Aguarde...", Nil, .T. )        

        If !Empty(aLogUPD[1])
            fMakeLog(aLogUPD, aTitle, Nil, Nil, "UPDTRIBIR_"+FWTimeStamp(), OemToAnsi("Log de Ocorrências"), "M", "L", Nil, .F.)
        EndIf
    EndIf

Return

/*/{Protheus.doc} fVldSX1
Função que verifica as perguntas que serão utilizdas na rotina
/*/
Static Function fVldSX1()

    Local lOk       := .F.
    Local oSX1      := FWSX1Util():New()

    oSX1:AddGroup("UPDTRIBIR")
    oSX1:SearchGroup()
    
    If Len(oSX1:aGrupo) >= 1 .And. Len(oSX1:aGrupo[1][2]) >= 1
        lOk := .T.
    EndIf

    Return lOk

/*/{Protheus.doc} fProcessa
Função que efetua o processamento
/*/
Static Function fProcessa()

    Local aArea         := SRD->( GetArea() )
    Local aAreaSMU      := SMU->( GetArea() )
    Local aAreaSRA      := SRA->( GetArea() )
    Local aAreaSRD      := SRD->( GetArea() )
    Local aAreaSRQ      := SRQ->( GetArea() )
    Local aCodFol       := {}
    Local aTabS073      := {}
    Local cAliasQry     := GetNextAlias()
    Local cFilMatOld    := ""
    Local cFilOld       := ""
    Local cJoinRDRV	    := "% " + FWJoinFilial( "SRD", "SRV" ) + " %"
    Local cWhere        := ""
    Local nRecnoSRD     := 0
    Local nRegSRD       := 0
    Local nTotSRD       := 0

    SMU->( dbSetOrder(1) )//MU_FILIAL+MU_MAT+MU_CODFOR+MU_PERINI
    SRA->( DBSetOrder(1) )//RA_FILIAL+RA_MAT+RA_NOME
    SRD->( DBSetOrder(1) )//RD_FILIAL+RD_MAT+RD_DATARQ+RD_PD+RD_SEMANA+RD_SEQ+RD_CC+RD_PROCES
    SRQ->( DBSetOrder(1) )//RQ_FILIAL+RQ_MAT+RQ_ORDEM+RQ_SEQUENC

    Pergunte( cPerg, .F. )
    MakeSqlExpr( cPerg )

    If Empty(mv_par03) .Or. Empty(mv_par04)
        MsgAlert("Efetue o preenchimento do período de/até")
        Return
    EndIf

    //Filial
    If !Empty(mv_par01)
        cWhere += mv_par01
    EndIf

    //Matricula
    If !Empty(mv_par02)
        cWhere += Iif( !Empty(cWhere), " AND ", "")
        cWhere += mv_par02
    EndIf

    cWhere += Iif( !Empty(cWhere), " AND ", "")
    cWhere += "SRD.RD_DATARQ >= '202305' AND "

    //Período de
    cWhere += "SRD.RD_DATARQ >= '" + mv_par03 + "' AND "

    //Período até
    cWhere += "SRD.RD_DATARQ <= '" + mv_par04 + "' AND "

    cWhere := "%" + cWhere + "%"

    BeginSql alias cAliasQry
        SELECT COUNT(*) AS TOTAL
        FROM %table:SRD% SRD
        INNER JOIN %table:SRV% SRV
        ON	%exp:cJoinRDRV% AND
            SRV.RV_COD = SRD.RD_PD AND
            SRV.%notDel%
        WHERE %exp:cWhere%
            SRV.RV_CODFOL IN ('0010', '0015', '0016', '0027', '0100') AND
            SRD.RD_TRIBIR = ' ' AND
            SRD.%notDel%
    EndSql

    nTotSRD := (cAliasQry)->TOTAL
    ProcRegua(nTotSRD)

    (cAliasQry)->( DBCloseArea() )

    BeginSql alias cAliasQry
        SELECT SRD.R_E_C_N_O_ AS RECNO
        FROM %table:SRD% SRD
        INNER JOIN %table:SRV% SRV
        ON	%exp:cJoinRDRV% AND
            SRV.RV_COD = SRD.RD_PD AND
            SRV.%notDel%
        WHERE %exp:cWhere%
                SRV.RV_CODFOL IN ('0010', '0015', '0016', '0027', '0100') AND
                SRD.RD_TRIBIR = ' ' AND
                SRD.%notDel%
        ORDER BY SRD.RD_FILIAL, SRD.RD_MAT, SRD.RD_DATARQ, SRD.RD_SEMANA, SRD.RD_DATPGT, SRD.RD_PD
    EndSql

    While (cAliasQry)->( !EoF() )
        nRegSRD++
        IncProc( "Validando registro " + cValToChar(nRegSRD) + " de " + cValToChar(nTotSRD) )

        nRecnoSRD := (cAliasQry)->RECNO
        SRD->( DBGoTo( nRecnoSRD ) )
        SRA->( DBSeek( SRD->RD_FILIAL+SRD->RD_MAT ) )
          
        If SRD->RD_FILIAL != cFilOld
            aCodFol     := {}
            aTabS073    := {}
            cFilOld     := SRD->RD_FILIAL
            RstaCodFol()
            Fp_CodFol(@aCodFol, SRD->RD_FILIAL, .F., .F.)
            RstGpexIni()
            fRetTab( @aTabS073, "S073", Nil, Nil, Nil, Nil, .T., Nil, .T. )
        EndIf

        If cFilMatOld != SRD->RD_FILIAL+SRD->RD_MAT
            If !Empty(cFilMatOld)
                aAdd( aLogUPD[1], "" )
            EndIf
            cFilMatOld := SRD->RD_FILIAL+SRD->RD_MAT
        EndIf

        fVldSRD( nRecnoSRD, aCodFol, aTabS073 )

        (cAliasQry)->( DBSkip() )
    End

    (cAliasQry)->( DBCloseArea() )

    RestArea(aAreaSMU)
    RestArea(aAreaSRA)
    RestArea(aAreaSRD)
    RestArea(aAreaSRQ)
    RestArea(aArea)

Return

/*/{Protheus.doc} fVldSRD
Função que irá validar o modelo de tributação da base de IR
/*/
Static Function fVldSRD( nRecnoSRD, aCodFol, aTabS073 )

    Local aVbPensao     := {}
    Local aVbPrevS073   := {}
    Local aVerbasAnt    := {}
    Local cCodFol       := RetValSRV( SRD->RD_PD, SRD->RD_FILIAL, "RV_CODFOL" )
    Local cDetVerba     := RTrim( SRD->RD_PD + " - " + RetValSRV( SRD->RD_PD, SRD->RD_FILIAL, "RV_DESC" ) )
    Local cCpoPensao    := ""
    Local cRDDatarq     := SRD->RD_DATARQ
    Local cRDFilial     := SRD->RD_FILIAL
    Local cRDMat        := SRD->RD_MAT
    Local cRDSemana     := SRD->RD_SEMANA
    Local cRotCalc      := ""
    Local cSeqMV        := SRD->RD_SEQMV
    Local cTribIR       := ""
    Local cVbDescIR     := ""
    Local cVbDep        := ""
    Local cVbDissINSS   := ""
    Local cVbDedINSS    := ""
    Local cVbDescINSS   := ""
    Local cVbDINSSMs    := ""
    Local cVbInsMV      := ""
    Local cVbInsMV2     := ""
    Local cVbPrevId     := ""
    Local cPerAnt       := ""
    Local dDatPgt       := SRD->RD_DATPGT
    Local lRotFer       := .F.
    Local lVerPerAnt    := .T.
    Local lVldMV        := !Empty(cSeqMV)
    Local lVldSemana    := (SRA->RA_TIPOPGT == "S")
    Local nContPensao   := 0
    Local nContS073     := 0
    Local nDedSimp      := 528
    Local nValDep       := 0
    Local nValINSS      := 0
    Local nValPensao    := 0
    Local nValPensaoAnt := 0
    Local nValPrev      := 0
    Local nTotDedLeg    := 0

    If cCodFol == "0010"//Adiantamento
        cCpoPensao  := "RQ_VERBADT"
        cRotCalc    := "ADI"
        cPerAnt     := SubMesAno( cRDDatarq )
        cVbDep      := aCodFol[59, 1]
        cVbDescIR   := aCodFol[9, 1]
        cVbDedINSS  := aCodFol[167, 1]
        cVbDescINSS := aCodFol[64, 1]
        cVbInsMV    := aCodFol[289, 1]
        cVbPrevId   := aCodFol[215, 1] 
        aVerbasAnt  := fBuscaAcmPer( aCodFol[106, 1], Nil, "V", 0, Nil, cRDDatarq, cRDDatarq, Nil, Nil, cRotCalc, .T. )
        If Len(aVerbasAnt) > 0
            lVerPerAnt := .T.
        EndIf
    ElseIf cCodFol == "0015"//Folha
        cCpoPensao  := "RQ_VERBFOL"
        cRotCalc    := "FOL"
        cVbDedINSS  := aCodFol[167, 1]
        cVbDep      := aCodFol[59, 1]
        cVbDescINSS := aCodFol[64, 1]
        cVbDescIR   := aCodFol[66, 1]
        cVbDissINSS := aCodFol[340, 1]
        cVbInsMV    := aCodFol[289, 1]
        cVbPrevId   := aCodFol[215, 1]
    ElseIf cCodFol == "0016"//Férias
        cCpoPensao  := "RQ_VERBFER"
        cRotCalc    := "FER"
        cVbDedINSS  := aCodFol[168, 1]
        cVbDep      := aCodFol[60, 1]
        cVbDescINSS := aCodFol[65, 1]
        cVbDescIR   := aCodFol[67, 1]
        cVbDINSSMs  := aCodFol[232, 1]
        cVbInsMV    := aCodFol[397, 1]
        cVbInsMV2   := aCodFol[1861, 1]
        cVbPrevId   := aCodFol[216, 1]
        lRotFer     := .T.
    ElseIf cCodFol == "0027"//13º salário
        cCpoPensao  := "RQ_VERB132"
        cRotCalc    := "132"
        cVbDedINSS  := aCodFol[169, 1]
        cVbDep      := aCodFol[62, 1]
        cVbDescINSS := aCodFol[70, 1]
        cVbDescIR   := aCodFol[71, 1]
        cVbDissINSS := aCodFol[401, 1]
        cVbInsMV    := aCodFol[291, 1]
        cVbPrevId   := aCodFol[302, 1]
    ElseIf cCodFol == "0100"//Diferença férias
        cCpoPensao  := "RQ_VERBDFE"
        cRotCalc    := "FER"
        cVbDedINSS  := aCodFol[168, 1]
        cVbDep      := aCodFol[61, 1]
        cVbDescINSS := aCodFol[65, 1]
        cVbDescIR   := aCodFol[101, 1]
        cVbDINSSMs  := aCodFol[232, 1]
        cVbInsMV    := aCodFol[397, 1]
        cVbInsMV2   := aCodFol[1861, 1]
        cVbPrevId   := aCodFol[216, 1]
    EndIf

    If SRD->( DBSeek( cRDFilial+cRDMat+cRDDatarq+cVbDescIR+cRDSemana ) ) .And. !Empty(SRD->RD_TRIBIR)
        cTribIR := SRD->RD_TRIBIR
        
        If aScan( aLogUPD[1], { |x| x == "Filial: " + cRDFilial + "  -  Matrícula: " + cRDMat } ) == 0
            aAdd( aLogUPD[1], "Filial: " + cRDFilial + "  -  Matrícula: " + cRDMat )
        EndIf
        aAdd( aLogUPD[1], "    -> Verba atualizada: " + cDetVerba + " | Modelo de tributação: " + cTribIR + " (" + IIf( cTribIR == "1", "Completo", "Simplificado" ) + ")" + " | Motivo: utilizado a informação da verba " + cVbDescIR + ".")

        fGrvSRD( nRecnoSRD, cTribIR )
    Else
        //Pesquisa dedução INSS
        If !Empty(cVbDedINSS)
            fBuscaSRD( @nValINSS, cVbDedINSS, cRDFilial, cRDMat, If(cRotCalc == "ADI" .And. lVerPerAnt, cPerAnt, cRDDatarq), cRDSemana, Nil, lRotFer, dDatPgt, lVldSemana )
        EndIf

        //Pesquisa desconto INSS
        If !Empty(cVbDescINSS)
            fBuscaSRD( @nValINSS, cVbDescINSS, cRDFilial, cRDMat, If(cRotCalc == "ADI" .And. lVerPerAnt, cPerAnt, cRDDatarq), cRDSemana, Nil, lRotFer, dDatPgt, lVldSemana )
        EndIf

        //Pesquisa desconto INSS mês seguinte
        If !Empty(cVbDINSSMs)
            fBuscaSRD( @nValINSS, cVbDINSSMs, cRDFilial, cRDMat, cRDDatarq, cRDSemana, Nil, lRotFer, dDatPgt, lVldSemana )
        EndIf

        //Pesquisa INSS outras empresas
        If lVldMV .Or. lRotFer
            If !Empty(cVbInsMV)
                fBuscaSRD( @nValINSS, cVbInsMV, cRDFilial, cRDMat, If(cRotCalc == "ADI" .And. lVerPerAnt, cPerAnt, cRDDatarq), cRDSemana, lVldMV, lRotFer, dDatPgt, lVldSemana )
            EndIf
            If !Empty(cVbInsMV2)
                fBuscaSRD( @nValINSS, cVbInsMV2, cRDFilial, cRDMat, cRDDatarq, cRDSemana, lVldMV, lRotFer, dDatPgt, lVldSemana )
            EndIf
        EndIf

        //Pesquisa pensão alimentícia
        fVldSRQ( @aVbPensao, cRDFilial, cRDMat, cRDDatarq, cCpoPensao )
        For nContPensao := 1 To Len(aVbPensao)
            fBuscaSRD( @nValPensao, aVbPensao[nContPensao], cRDFilial, cRDMat, cRDDatarq, cRDSemana, Nil, Nil, Nil, lVldSemana  )
            If cRotCalc == "ADI" .And. lVerPerAnt
                fBuscaSRD( @nValPensaoAnt, aVbPensao[nContPensao], cRDFilial, cRDMat, cPerAnt, cRDSemana, Nil, Nil, Nil, lVldSemana  )
                nValPensao += nValPensaoAnt
            EndIf
        Next nContPensao

        //Pesquisa previdência privada com ID
        If !Empty(cVbPrevId)
            fBuscaSRD( @nValPrev, cVbPrevId, cRDFilial, cRDMat, If(cRotCalc == "ADI" .And. lVerPerAnt, cPerAnt, cRDDatarq), cRDSemana, Nil, Nil, Nil, lVldSemana  )
        EndIf

        //Pesquisa previdência privada da tabela S073
        If cRotCalc $ "FOL/FER/132"
            fVldS073( @aVbPrevS073, aTabS073, cRDFilial, cRDMat, cRDDatarq, cRotCalc )
            For nContS073 := 1 To Len(aVbPrevS073)
                If aVbPrevS073[nContS073] != cVbPrevId
                    fBuscaSRD( @nValPrev, aVbPrevS073[nContS073], cRDFilial, cRDMat, cRDDatarq, cRDSemana, Nil, Nil, Nil, lVldSemana  )
                EndIf
            Next nContS073
        EndIf

        //Pesquisa dependentes
        fBuscaSRD( @nValDep, cVbDep, cRDFilial, cRDMat, cRDDatarq, cRDSemana, Nil, Nil, Nil, lVldSemana  )
        
        nTotDedLeg := nValINSS + nValPensao + nValPrev + nValDep
        
        If nTotDedLeg >= nDedSimp
            cTribIR := "1"
        Else
            cTribIR := "2"
        EndIf

        If aScan( aLogUPD[1], { |x| x == "Filial: " + cRDFilial + "  -  Matrícula: " + cRDMat } ) == 0
            aAdd( aLogUPD[1], "Filial: " + cRDFilial + "  -  Matrícula: " + cRDMat )
        EndIf
        aAdd( aLogUPD[1], "    -> Verba atualizada: " + cDetVerba + " | Modelo de tributação: " + cTribIR + " (" + IIf( cTribIR == "1", "Completo", "Simplificado" ) + ")" + " | Motivo: " + IIf( cTribIR == "1", "valor das deduções legais (R$ " + AllTrim( Transform( nTotDedLeg, "@E 9,999.99" ) ) + ") maior que a dedução simplificada de R$ 528,00.", "dedução simplificada de R$ 528,00 maior que o valor das deduções legais (R$ " + AllTrim( Transform( nTotDedLeg, "@E 9,999.99" ) ) + ")." ) )
        
        fGrvSRD( nRecnoSRD, cTribIR )
    EndIf    

Return

/*/{Protheus.doc} fBuscaSRD
Função que faz pesquisa da verba na tabela SRD e retorna o valor da verba
/*/
Static Function fBuscaSRD( nValSRD, cCodVerba, cRDFilial, cRDMat, cRDDatarq, cRDSemana, lMV, lRotFer, dDatPgt, lVldSemana )

    Local cChaveSeek    := Iif( !lVldSemana, cRDFilial+cRDMat+cRDDatarq+cCodVerba+cRDSemana, cRDFilial+cRDMat+cRDDatarq+cCodVerba )
    
    Default lMV         := .F.
    Default lRotFer     := .F.

    If SRD->( DBSeek( cChaveSeek ) ) .And. (SRD->RD_IR == "S" .Or. lMV)
        While SRD->( !Eof() ) .And. Iif( !lVldSemana, SRD->RD_FILIAL+SRD->RD_MAT+SRD->RD_DATARQ+SRD->RD_PD+SRD->RD_SEMANA, SRD->RD_FILIAL+SRD->RD_MAT+SRD->RD_DATARQ+SRD->RD_PD ) == cChaveSeek
            If (!lRotFer .Or. SRD->RD_DATPGT <= dDatPgt) .And. (!lVldSemana .Or. SRD->RD_SEMANA <= cRDSemana)
                nValSRD += SRD->RD_VALOR
            EndIf
            SRD->( DBSkip() )
        End
    EndIf

Return

/*/{Protheus.doc} fVldSRQ
Função que faz pesquisa da pensão na tabela SRQ
/*/
Static Function fVldSRQ( aVbPensao, cRDFilial, cRDMat, cRDDatarq, cCpoPensao )

    If SRQ->( dbSeek( cRDFilial+cRDMat ) )
        While SRQ->( !EoF() ) .And. SRQ->RQ_FILIAL+SRQ->RQ_MAT == cRDFilial+cRDMat
            If ( Empty(SRQ->RQ_DTINI) .Or. cRDDatarq >= AnoMes(SRQ->RQ_DTINI) ) .Or. ( Empty(SRQ->RQ_DTFIM) .Or. cRDDatarq <= AnoMes(SRQ->RQ_DTFIM) ) 
                AAdd( aVbPensao, SRQ->( &(cCpoPensao) ) )
            EndIf
            SRQ->( dbSkip() )
        End
    EndIf

Return

/*/{Protheus.doc} fVldS073
Função que faz pesquisa da previdência privada na tabela SMU/S073
/*/
Static Function fVldS073( aVbPrevS073, aTabS073, cRDFilial, cRDMat, cRDDatarq, cRotCalc )

    Local nPosS073      := 0

    If SMU->( dbSeek( cRDFilial+cRDMat ) )
        While SMU->( !EoF() ) .And. SMU->MU_FILIAL+SMU->MU_MAT == cRDFilial+cRDMat
            If cRDDatarq >= SubStr( SMU->MU_PERINI, 3, 4)+SubStr( SMU->MU_PERINI, 1, 2) .And. cRDDatarq <= SubStr( SMU->MU_PERFIM, 3, 4)+SubStr( SMU->MU_PERFIM, 1, 2)
                If ( nPosS073 := aScan( aTabS073, { |x| x[5] == SMU->MU_CODFOR } ) ) > 0
                    If RetValSRV( Iif( cRotCalc $ "FOL/FER", aTabS073[nPosS073, 10], aTabS073[nPosS073, 11] ), cRDFilial, "RV_IR" ) == "S"
                        AAdd( aVbPrevS073, Iif( cRotCalc $ "FOL/FER", aTabS073[nPosS073, 10], aTabS073[nPosS073, 11] ) )
                    EndIf
                EndIf
            EndIf
            SMU->( dbSkip() )
        End
    EndIf

Return

/*/{Protheus.doc} fGrvSRD
Função que irá atualizar os campos RD_TRIBIR e RD_NUMID da base de IR
/*/
Static Function fGrvSRD( nRecnoSRD, cTribIR )

    SRD->( DBGoTo( nRecnoSRD ) )
    
    If SRD->( Reclock("SRD", .F.) )
        SRD->RD_TRIBIR  := cTribIR
        SRD->RD_NUMID   := "UPDTRIBIR"
        SRD->( MsUnlock() )
    EndIf

Return
