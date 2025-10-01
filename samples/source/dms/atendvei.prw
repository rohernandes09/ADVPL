// ÉÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍ»
// º Versao º 04     º
// ÈÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍ¼

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ ATENDVEI ³ Autor ³ Andre Luis Almeida    ³ Data ³ 06/05/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Impressao do Atendimento/Proposta de Venda de Veiculos     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Veiculos                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ATENDVEI()
Local cFilAte    := ParamIXB[1] // Filial do Atendimento
Local cNumAte    := ParamIXB[2] // Nro do Atendimento
Local cDesc1     := ""
Local cDesc2     := ""
Local cDesc3     := ""
Local cAlias     := "VV9"
Local lSA1       := .f.
Local lVV1       := .f.
Local lNF        := .f.
Local cNFSerie   := ""
Local cVV9Status := ""
Local nVlNeg     := 0
Local cQuery     := ""
Local cSQLAlias  := "SQLVS9"
Local lVVACODMAR := ( VVA->(FieldPos("VVA_CODMAR")) > 0 )
Local cCodMar    := ""
Private nLin 	 := 1
Private aReturn  := { "Zebrado" , 1 , "Administração" , 1 , 2 , 1 , "" , 1 } // { "Zebrado", 1,"Administracao", 2, 1, 1, "",1 }
Private cTamanho := "P"           // P/M/G
Private Limite   := 80            // 80/132/220
Private nCaracter:= 15
Private aOrdem   := {}            // Ordem do Relatorio
Private cTitulo  := "Impressão Atendimento de Veiculos"
Private cNomeRel := "ATENDVEI"
Private nLastKey := 0
Private cabec1   := "" 
Private cabec2   := ""
Private Li       := 132
Private m_Pag    := 1
Private lAbortPrint := .f.

cNomeRel := SetPrint(cAlias,cNomeRel,,@cTitulo,cDesc1,cDesc2,cDesc3,.f.,,.t.,cTamanho)
If nLastKey == 27
	Return
EndIf
SetDefault(aReturn,cAlias)
Set Printer to &cNomeRel
Set Printer On
Set Device  to Printer

VV9->(DbSetOrder(1))
VV9->(DbSeek(cFilAte+cNumAte))
VV0->(DbSetOrder(1))
VV0->(DbSeek(VV9->VV9_FILIAL+VV9->VV9_NUMATE))
lNF := !Empty(VV0->VV0_NUMNFI+VV0->VV0_SERNFI+VV0->VV0_NNFFDI+VV0->VV0_SNFFDI) // Possui NF
If !Empty(VV9->VV9_CODCLI+VV9->VV9_LOJA)
	lSA1 := .t.
	SA1->(dbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1")+VV9->VV9_CODCLI+VV9->VV9_LOJA))
	VAM->(dbSetOrder(1))
	VAM->(DbSeek(xFilial("VAM")+SA1->A1_IBGE))
EndIf
SA3->(dbSetOrder(1))
SA3->(DbSeek(xFilial("SA3")+VV0->VV0_CODVEN))
If lNF
	If VV0->VV0_TIPFAT == "2" // Faturamento Direto
		cNFSerie := VV0->VV0_NNFFDI+" - "+VV0->VV0_SNFFDI
	Else
		cNFSerie := VV0->VV0_NUMNFI+" - "+VV0->VV0_SERNFI
	EndIf
	cabec1 := space(20)+"V E N D A          N F  "+cNFSerie
Else
	cabec1 := space(20)+"P R O P O S T A      D E      V E N D A"
EndIf
nLin := cabec(ctitulo,cabec1,cabec2,cNomeRel,ctamanho,nCaracter)+1
Do Case
	Case VV9->VV9_STATUS == "A" 
		cVV9Status := "Em Aberto"
	Case VV9->VV9_STATUS == "P" 
		cVV9Status := "Pendente de Aprovação"
	Case VV9->VV9_STATUS == "O" 
		cVV9Status := "Pre-Aprovado"
	Case VV9->VV9_STATUS == "L" 
		cVV9Status := "Aprovado"
	Case VV9->VV9_STATUS == "R" 
		cVV9Status := "Reprovado"
	Case VV9->VV9_STATUS == "F" 
		cVV9Status := "Finalizado"
	Case VV9->VV9_STATUS == "C" 
		cVV9Status := "Cancelado"
EndCase
@ nLin++,00 psay left("Atendimento: "+VV9->VV9_NUMATE+" ( "+cVV9Status+" )"+space(60),60) + right(space(20)+" Data: "+Transform(VV0->VV0_DATMOV,"@D"),20)
@ nLin++,00 psay left("Vendedor...: "+VV0->VV0_CODVEN+"-"+SA3->A3_NOME+space(80),80) 
nLin++
If lSA1
	cCGCCPF1 := subs(transform(SA1->A1_CGC,PicPes(RetPessoa(SA1->A1_CGC))),1,at("%",transform(SA1->A1_CGC,PicPes(RetPessoa(SA1->A1_CGC))))-1)
	cCGCCPF  := cCGCCPF1 + space(18-len(cCGCCPF1))
	@ nLin++,00 psay left("Cliente.: "+SA1->A1_NOME+space(45),45) + left(" CNPJ/CPF: "+cCGCCPF+space(35),35)
	@ nLin++,00 psay left("Endereço: "+SA1->A1_END+space(45),45)  + left(" Bairro..: "+SA1->A1_BAIRRO+space(35),35)
	@ nLin++,00 psay left("Cidade..: "+Alltrim(VAM->VAM_DESCID)+"-"+VAM->VAM_ESTADO+space(45),45) + left(" CEP.....: "+Transform(SA1->A1_CEP,"@R 99999-999")+space(35),35)
	@ nLin++,00 psay left("Telefone: "+"( "+VAM->VAM_DDD+" ) "+SA1->A1_TEL+space(80),80)
Else
	@ nLin++,00 psay left("Cliente.: "+VV9->VV9_NOMVIS+space(45),45) + left(" Telefone: "+VV9->VV9_TELVIS+space(35),35)
EndIf
VVA->(DbSetOrder(1))
VVA->(DbSeek(VV9->VV9_FILIAL+VV9->VV9_NUMATE))
While !VVA->(Eof()) .and. VVA->VVA_FILIAL == VV9->VV9_FILIAL .and. VVA->VVA_NUMTRA == VV9->VV9_NUMATE
	lVV1 := .f.
	If !Empty(VVA->VVA_CHAINT)
		lVV1 := .t.
		VV1->(DbSetOrder(1))
		VV1->(DbSeek(xFilial("VV1")+VVA->VVA_CHAINT))
	EndIf
	If lVVACODMAR
		cCodMar := VVA->VVA_CODMAR
		VV2->(DbSetOrder(1))
		VV2->(DbSeek(xFilial("VV2")+VVA->VVA_CODMAR+VVA->VVA_MODVEI))
		VVC->(DbSetOrder(1))
		VVC->(DbSeek(xFilial("VVC")+VVA->VVA_CODMAR+VVA->VVA_CORVEI))
	Else
		cCodMar := VV0->VV0_CODMAR
		VV2->(DbSetOrder(1))
		VV2->(DbSeek(xFilial("VV2")+VV0->VV0_CODMAR+VV0->VV0_MODVEI))
		VVC->(DbSetOrder(1))
		VVC->(DbSeek(xFilial("VVC")+VV0->VV0_CODMAR+VV0->VV0_CORVEI))
	EndIf
	nLin++
	If lVV1
		@ nLin++,00 psay IIF(VV1->VV1_ESTVEI=="1",left("VEICULO USADO"+"  "+"KM:"+Transform(VV1->VV1_KILVEI,"@E 999,999,999")+space(45),45)+" Placa...: "+Transform(VV1->VV1_PLAVEI,"@R AAA-!!!!"),"VEICULO NOVO")
		@ nLin++,00 psay left("Chassi..: "+VV1->VV1_CHASSI+space(45),45) + left(" Fab/Mod.: "+substr(VV1->VV1_FABMOD,1,4)+" / "+substr(VV1->VV1_FABMOD,5,4)+space(35),35)
		@ nLin++,00 psay left("Modelo..: "+cCodMar+" "+VV2->VV2_DESMOD+space(45),45) + left(" Cor.....: "+VVC->VVC_DESCRI+space(35),35)
	Else
		@ nLin++,00 psay left("VEICULO NOVO"+space(45),45) + left(" Cor.....: "+VVC->VVC_DESCRI+space(35),35)
		@ nLin++,00 psay left("Modelo..: "+cCodMar+" "+VV2->VV2_DESMOD+space(80),80) 
	EndIf
	VVA->(DbSkip())
EndDo
nLin++
@ nLin++,46 psay left(IIf(lNF,"Total Venda","Total Atendimento")+space(20),20)+Transform(VV0->VV0_VALMOV,"@E 999,999,999.99")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta vetor VS9 ( Composicao de Parcelas )            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nVlNeg := VV0->VV0_VALFPR // Financiamento Proprio - Utilizar Valor Total (VV0_VALFPR), pois o VS9 esta com o Juros embutido no Valor
cQuery := "SELECT VS9.VS9_TIPPAG , VS9.VS9_DATPAG , VS9.VS9_VALPAG , VS9.VS9_REFPAG , VS9.VS9_SEQUEN , VSA.VSA_DESPAG , VSA.VSA_TIPO FROM "+RetSQLName("VS9")+" VS9 "
cQuery += "INNER JOIN "+RetSQLName("VSA")+" VSA ON ( VSA.VSA_FILIAL='"+xFilial("VSA")+"' AND VSA.VSA_TIPPAG=VS9.VS9_TIPPAG AND VSA.D_E_L_E_T_=' ' ) "
cQuery += "WHERE VS9.VS9_FILIAL='"+xFilial("VS9")+"' AND VS9.VS9_NUMIDE='"+cNumAte+"' AND VS9.VS9_TIPOPE='V' AND VS9.D_E_L_E_T_=' '"
dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cSQLAlias , .F. , .T. )
If !(cSQLAlias)->(Eof())
	nLin++
	@ nLin++,00 psay "Forma de Pagamento ( Composição de Parcelas )"
EndIf
While !(cSQLAlias)->(Eof())
	If (cSQLAlias)->( VSA_TIPO ) <> "2" // Tipos de Pagamento diferente de Financiamento Proprio
		nVlNeg += (cSQLAlias)->VS9_VALPAG
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta Observacao para ser exibida no Listbox ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cDescObs := VX002OVS9( cNumAte, (cSQLAlias)->( VS9_TIPPAG ), (cSQLAlias)->( VSA_TIPO ) , (cSQLAlias)->( VS9_REFPAG ), (cSQLAlias)->( VS9_SEQUEN ), VV0->VV0_CLFINA, VV0->VV0_LJFINA, VV0->VV0_CFINAM, VV0->VV0_NFINAM )		
	If nLin > 55
		nLin := cabec(ctitulo,cabec1,cabec2,cNomeRel,ctamanho,nCaracter)+1
	EndIf
	@ nLin++,00 psay left(Transform(stod((cSQLAlias)->( VS9_DATPAG )),"@D")+" "+(cSQLAlias)->( VS9_TIPPAG )+"-"+Alltrim((cSQLAlias)->( VSA_DESPAG ))+" "+cDescObs+space(80),80-14)+Transform((cSQLAlias)->( VS9_VALPAG ),"@E 999,999,999.99")
	(cSQLAlias)->(dbSkip())
EndDo
(cSQLAlias)->(dbCloseArea())
If VV0->VV0_VALMOV > nVlNeg
	nLin++
	@ nLin++,46 psay left("Saldo Restante"+space(20),20)+Transform(VV0->VV0_VALMOV-nVlNeg,"@E 999,999,999.99")
ElseIf VV0->VV0_VALMOV < nVlNeg
	nLin++
	@ nLin++,46 psay left("Devolução"+space(20),20)+Transform(nVlNeg-VV0->VV0_VALMOV,"@E 999,999,999.99")
EndIf
nLin++
If !lNF
	@ nLin++,46 psay "Validade da Proposta: ___/___/____"
EndIf
@ nLin++,00 psay repl("-",80)
Ms_Flush()
Set Printer to
Set Device to Screen
If aReturn[5] == 1
	OurSpool( cNomeRel )
EndIf
Return()
