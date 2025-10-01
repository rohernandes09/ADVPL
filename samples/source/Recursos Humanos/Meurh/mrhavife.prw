#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "FWPRINTSETUP.CH" 
#INCLUDE "RPTDEF.CH"
#INCLUDE "MRHAVIFE.CH"

User Function MRHAVIFE()
    Local oPrint
    Local lRet        := .T.
    Local nLin        := 0
    Local nSizePage   := 0
    Local nTamMarg    := 25
    Local oFont12n    := TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)	//Normal negrito
    Local oFont10     := TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)	//Normal s/ negrito
    Local aDados      := PARAMIXB // Variável Private da execução de pontos de entrada.
    Local nLen        := Len(aDados)

    //Informações sobre a estrutura esperada do array de dados
    // PARAMIXB[1]  = tipo do aviso            (P=programado) (F=Férias) 
    // PARAMIXB[2]  = cCompanyState            (estado federativo da empresa)
    // PARAMIXB[3]  = dNoticeDate              (data do aviso)
    // PARAMIXB[4]  = cEmployeeName            (nome do funcionário)
    // PARAMIXB[5]  = cLaborCardNumber         (carteira de trabalho)
    // PARAMIXB[6]  = cLaborCardSeries         (série da carteira de trabalho) 
    // PARAMIXB[7]  = cDepartmentDescription   (descrição do departamento)
    // PARAMIXB[8]  = nPaydLeaveFollow         (dias de licença remunerada mês seguinte - férias calculadas)
    // PARAMIXB[9]  = nPaydLeave               (dias de licença remunerada - férias calculadas)
    // PARAMIXB[10] = dAcquisitiveStartDate   (data de inicio do período aquisitivo)
    // PARAMIXB[11] = dAcquisitiveEndDate     (data de término do período aquisitivo)
    // PARAMIXB[12] = dEnjoymentStart         (data de inicio do gozo de férias)
    // PARAMIXB[13] = dEnjoymentEndDate       (data de término do gozo de férias)
    // PARAMIXB[14] = cCompanyName            (nome descritivo da empresa)
    // PARAMIXB[15] = cCompanyCNPJ            (CNPJ da empresa)
    // PARAMIXB[16] = nPecuniaryAllowance     (dias de abono pecuniário - férias calculadas/programadas)
    // PARAMIXB[17] = cAccept                 (informações do aceite - férias calculadas)
    // PARAMIXB[18] = cBranch                 (filial do funcionário)
    // PARAMIXB[19] = cMat                    (matricula do funconário)
    // PARAMIXB[20] = cAdmissionDate          (admissão do funconário)
    // PARAMIXB[21] = cReceiptDate            (data do recibo)
    // PARAMIXB[22] = local de impressão      ( local de impressão)
    // PARAMIXB[23] = nome do arquivo         ( nome a ser impresso)


    If valtype(aDados) != "A" .or. ( nLen > 0 .And. nLen <> 23 ) .or. empty(aDados[23])
        lRet := .F.
    EndIf

    //geração do html para o recibo de férias
    If lRet

        oPrint := FWMSPrinter():New(aDados[23]+".rel", IMP_PDF, .F., aDados[22], .T., , , , .T., , .F., )
        
        oPrint:SetPortrait()
        oPrint:SetPaperSize(DMPAPER_A4)
        oPrint:SetMargin(nTamMarg,nTamMarg,nTamMarg,nTamMarg)
        oPrint:StartPage()

        nSizePage := oPrint:nPageWidth / oPrint:nFactorHor

        nLin += 50
        oPrint:SayAlign(nLin, 0, OemToAnsi(STR0001), oFont12n, 550, , , 2, 0) //"Aviso de Férias"
        nLin += 20	
        oPrint:Line(nLin, 15, nLin, nSizePage-(nTamMarg*2))
        
        nLin += 50
        cMsgLine := AllTrim(aDados[2]) +', ' +SubStr(DtoC( aDados[3] ),1,2) +STR0002 +MesExtenso(Month(aDados[3])) +STR0002 +STR(Year(aDados[3]),4) 
        oPrint:Say(nLin, 15, cMsgLine, oFont10) 

        nLin += 40		
        cMsgLine := STR0003 //"A(o) Sr(a)" 
        oPrint:Say(nLin, 15, cMsgLine, oFont10) 
        nLin += 15		
        cMsgLine := Left(aDados[4],30) 
        oPrint:Say(nLin, 15, cMsgLine, oFont10) 
        nLin += 10		
        cMsgLine := STR0004 +aDados[5] +' - ' +aDados[6] +SPACE(8) +STR0005 +aDados[7]  //"CTPS: " / "Depto: "
        oPrint:Say(nLin, 15, cMsgLine, oFont10) 

        nLin += 40		
        oPrint:Say(nLin, 15, STR0006 +" " +STR0007, oFont10)  //"Nos termos da legislação vigente, suas férias serão" "concedidas conforme as informações abaixo:"

        If aDados[1] == "F" //Férias calculadas
            nLin += 15		
            cMsgLine := STR0009 +Padr(DtoC(aDados[10]),10) +STR0013 +Padr(DtoC(aDados[11]),10) //"Período Aquisitivo: " " a "
            oPrint:Say(nLin, 15, cMsgLine, oFont10)

            nLin += 10
            cMsgLine := STR0010 +Padr(DtoC(aDados[12]),10) +STR0013 +Padr(DtoC(aDados[13]),10) //"Período de Gozo: "  " a "
            oPrint:Say(nLin, 15, cMsgLine, oFont10)  

            If ( aDados[8] + aDados[9] ) > 0
                If aDados[9] == 30
                    nLin += 10		
                    cMsgLine := STR0011 + CVALTOCHAR(aDados[8] + aDados[9]) //"Qtd Lic.remun.: " 
                    oPrint:Say(nLin, 15, cMsgLine, oFont10) 
                EndIf
        EndIf

        ElseIf aDados[1] == "P" //Férias programadas
            nLin += 15
            cMsgLine := STR0010 +Padr(DtoC(aDados[12]),10) +STR0013 +Padr(DtoC(aDados[13]),10) //"Período de Gozo: "  " a "
            oPrint:Say(nLin, 15, cMsgLine, oFont10)  
        EndIf

        nLin += 10
        cMsgLine := STR0015 + Padr(DtoC(aDados[13] + 1), 10) //"Retorno ao Trabalho: "
        oPrint:Say(nLin, 15, cMsgLine, oFont10)  

        //montagem para assinaturas
        nLin += 50
        cMsgLine := replicate("_",50)
        oPrint:SayAlign(nLin, 0, cMsgLine, oFont10, 550, , , 2, 0)  

        nLin += 15
        cMsgLine := aDados[14]
        oPrint:SayAlign(nLin, 0, cMsgLine, oFont10, 550, , , 2, 0)  

        nLin += 50
        cMsgLine := replicate("_",50) 
        oPrint:SayAlign(nLin, 0, cMsgLine, oFont10, 550, , , 2, 0) 

        nLin += 15
        cMsgLine := aDados[4]
        oPrint:SayAlign(nLin, 0, cMsgLine, oFont10, 550, , , 2, 0)  
            
        oPrint:EndPage()
        oPrint:cPathPDF := aDados[22] 
        oPrint:lViewPDF := .F.
        oPrint:Print()

    EndIf

Return(lRet)
