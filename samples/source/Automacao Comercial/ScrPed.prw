#INCLUDE "RWMAKE.CH" 

User Function SCRPED()   

Local aArea 		:= GetArea()
Local aAreaSL1 		:= SL1->(GetArea())
Local aAreaSL2 		:= SL2->(GetArea())
Local nOrcam		:= 0
Local sTexto        := ""              
Local nCheques		:= 0
Local nCartaoC		:= 0
Local nCartaoD		:= 0
Local nPIX	 		:= 0
Local nCartDig 		:= 0
Local nConveni		:= 0
Local nVales		:= 0
Local nFinanc		:= 0
Local nCredito		:= 0
Local nOutros		:= 0
Local cQuant 		:= ""	
Local cVrUnit		:= "" 								// Valor unit�rio
Local cDesconto		:= ""
Local cVlrItem		:= ""
Local nVlrIcmsRet	:= 0								// Valor do icms retido (Substituicao tributaria)
Local nTroco		:= 0
Local lMvLjTroco  	:= SuperGetMV("MV_LJTROCO", ,.F. )	// Verifica se utiliza troco nas diferentes formas de pagamento
Local nGar			:= 0         	                    // Garantia Estendida
Local aProdGarantia :={}								// Array com os par�metros do rkmake de impress�o do relat�rio de Garantia
Local lMvGarFP		:= SuperGetMV("MV_LJGarFP", ,.F.)	// Define o conc
Local lLibQtdGE		:= SuperGetMv("MV_LJLIBGE", , .F.) 	// Libera quantidade da garantia estendida  .. por default � Falso
Local cServType		:= SuperGetMv("MV_LJTPSF",,"SF")	// Define o tipo do produto de servico financeiro
Local nValTot		:= 0
Local nDescTot		:= 0
Local nFatorRes		:= 1
Local nValPag		:= 0
Local nVlrDescIt	:= 0
Local cGarType		:= SuperGetMv("MV_LJTPGAR",,"GE")	// Define o tipo do produto de garantia estendida
Local nValPgAjus 	:= 0 								// Valor ajustado para pagamento
Local nVlrFSD		:= 0								// Valor do frete + seguro + despesas
Local cDocPed       := ""								// Documento do Pedido
Local cSerPed       := ""								// Serie do pedido
Local nVlrFSD       := 0                                // Valor do frete + seguro + despesas
Local nVlrTot       := 0                                // Valor Total
Local nVlrAcres     := 0                                // Valor Acrescimo
Local lMvArrefat    := SuperGetMv("MV_ARREFAT") == "S"
Local nMvLjTpDes    := SuperGetMv("MV_LJTPDES",, 0) 	// Indica qual desconto sera' utilizado 0 - Antigo / 1 - Novo (objeto)
Local nTotDesc		:= 0 								// Total de desconto de acordo com L2_DESCPRO
Local lPedido		:= .F.								// Indica se a venda tem itens com pedido
Local aVlrFormas	:= SCRPRetPgt()						// Resgata os valores de cada forma de pagamento
Local cTpEntreg     := ""                               // Tipo do campo de entrega

If ValType(PARAMIXB) == "A" .AND. Len(PARAMIXB) > 0  
	If ValType(PARAMIXB[1]) == "A" .AND. Len(PARAMIXB[1]) > 0
		ProdGarantia := PARAMIXB[1]
	EndIf
	If (Len(PARAMIXB) > 1) .And. ValType(PARAMIXB[2]) == "N" .AND. (PARAMIXB[2] > 0)
		nFatorRes	:=	PARAMIXB[2]
	EndIf
	If (Len(PARAMIXB) > 2) .And. ValType(PARAMIXB[3]) == "N" .AND. (PARAMIXB[2] > 0)
		nCredito	:=	PARAMIXB[3]
	EndIf
    If ValType(PARAMIXB) == "A" .AND. Len(PARAMIXB) >= 4 .AND. ValType(PARAMIXB[4]) == "A"
        cSerPed := PARAMIXB[4,1,1]
        cDocPed := PARAMIXB[4,1,2]
    EndIf
EndIf

//����������������������������Ŀ
//�Release 11.5 - Chile - F1CHI�
//������������������������������
If cPaisLoc $ "CHI|COL" .AND. GetRpoRelease("R5") .AND. SuperGetMv("MV_CTRLFOL",,.F.)		
	lRet:= u_LjPrtPdLoc ()
	Return lRet	
EndIf

sTexto:= 'Codigo         Descricao'+Chr(13)+Chr(10)
sTexto:= sTexto + 'Qtd             VlrUnit              VlrTot'+ Chr(13)+ Chr(10)
sTexto:= sTexto + '-----------------------------------------------'+ Chr(13)+ Chr(10)

dbSelectArea("SL1")                                                                  
dbSetOrder(1)  

nOrcam		:= SL1->L1_NUM
nTroco		:= Iif(SL1->(FieldPos("L1_TROCO1")) > 0,(nFatorRes * SL1->L1_TROCO1), 0)
nDinheir	:= (nFatorRes * aVlrFormas[01][02] )
nCheques	:= (nFatorRes * aVlrFormas[02][02] )
nCartaoC 	:= (nFatorRes * aVlrFormas[03][02] )
nCartaoD 	:= (nFatorRes * aVlrFormas[04][02] )
nPIX	 	:= (nFatorRes * aVlrFormas[05][02] )
nCartDig 	:= (nFatorRes * aVlrFormas[06][02] )
nFinanc		:= (nFatorRes * aVlrFormas[07][02] )
nConveni	:= (nFatorRes * aVlrFormas[08][02] )
nVales  	:= (nFatorRes * aVlrFormas[09][02] )
nCredito	:= (nFatorRes * aVlrFormas[10][02] )
nOutros		:= (nFatorRes * aVlrFormas[11][02] )
nValTot		:= 0
nDescTot	:= 0

/* Soma o valor de todas as formas de pagamento
Necessariio dar um round em cada forma para verificar se ha diferen�a de arredondamento no somatorio dos pagamentos*/
nValPag :=	Round(nDinheir,2)	+	Round(nCheques,2)	+	Round(nCartaoC,2)	+	Round(nCartaoD,2)	+;
			Round(nConveni,2)	+	Round(nVales,2)		+	Round(nCredito,2)	+	Round(nFinanc,2)	+;
			Round(nOutros,2) 	+ 	Round(nPIX,2)		+ 	Round(nCartDig,2)

dbSelectArea("SL2")
dbSetOrder(1)  
dbSeek(xFilial("SL2") + nOrcam)

While !SL2->(Eof()) .AND. SL2->L2_FILIAL + SL2->L2_NUM == xFilial("SL2") + nOrcam
      /* Entrega ou Retira Posterior ou Vale Presente*/	
	If SL2->L2_ENTREGA $("1|3|4|5") .OR. !Empty(SL2->L2_VALEPRE) ;
	       .OR. (Posicione("SB1",1,xFilial("SB1") + SL2->L2_PRODUTO,"SB1->B1_TIPO") == cServType) ;
	       .OR. (Posicione("SB1",1,xFilial("SB1") + SL2->L2_PRODUTO,"SB1->B1_TIPO") == cGarType)
		
		If SL2->L2_ENTREGA $("3|5")
			lPedido := .T.
		EndIf
		
		If aScan(aProdGarantia, { |p| RTrim(p[1]) ==  RTRim(SL2->L2_PRODUTO)} ) > 0
			cGarantia := "*"
		Else
			If SL2->(FieldPos("L2_GARANT")) > 0 .AND.  !Empty(SL2->L2_GARANT)
				cGarantia := "#"
			Else
				cGarantia := ""
			EndIf
		EndIf
	
		If !Empty(SL2->L2_ENTREGA)
			If !Empty(cGarantia)
				cGarantia += IIF(SL2->L2_ENTREGA == "3", " E", IIF(SL2->L2_ENTREGA == "1", " P", ""))
			Else
				cGarantia := IIF(SL2->L2_ENTREGA == "3", "E", IIF(SL2->L2_ENTREGA == "1", "P", ""))
			EndIf
	
		EndIf

		//Faz o tratamento do valor do ICMS ret.
		If SL2->(FieldPos("L2_ICMSRET")) > 0
			nVlrIcmsRet	:= SL2->L2_ICMSRET
		Endif

		cQuant 		:= StrZero(SL2->L2_QUANT, 8, 3)

		If (!lMvGarFP .AND. !lLibQtdGE ) .AND. (cGarantia == "*" .OR. (Posicione("SB1",1,xFilial("SB1")+SL2->L2_PRODUTO, "B1_TIPO") == SuperGetMV("MV_LJTPGAR",,"GE")))
			cVrUnit		:= Str(((SL2->L2_QUANT * SL2->L2_VLRITEM) + SL2->L2_VALIPI + nVlrIcmsRet) / SL2->L2_QUANT, 15, 2)
		Else
			cVrUnit		:= Str(((SL2->L2_QUANT * SL2->L2_PRCTAB) + SL2->L2_VALIPI + nVlrIcmsRet) / SL2->L2_QUANT, 15, 2)
		EndIf

		//Valor de desconto no item
		nVlrDescIt += SL2->L2_VALDESC
		nTotDesc   += SL2->L2_DESCPRO
		cVlrItem   := Str(Val(cVrUnit) * SL2->L2_QUANT, 15, 2)

		cTpEntreg := " (T.E:"+ AllTrim(SL2->L2_ENTREGA) +")"

		sTexto		:= sTexto + Padr(SL2->L2_PRODUTO, 15) + PadR(SL2->L2_DESCRI, 25) + cTpEntreg + Chr(13) + Chr(10)
		sTexto		:= sTexto + cQuant + '  ' + cVrUnit + '      ' + cVlrItem + Chr(13) + Chr(10)
		If SL2->L2_VALDESC > 0
			sTexto	:= sTexto + 'Desconto no Item:              ' + Str(SL2->L2_VALDESC, 15, 2) + Chr(13) + Chr(10)
		EndIf
		
		nValTot  += Val(cVlrItem)
 
		SL2->(DbSkip())
	Else
		SL2->(DbSkip())
	EndIf
EndDo                    

cDesconto	:= Str(nVlrDescIt, TamSx3("L2_VALDESC")[1], TamSx3("L2_VALDESC")[2])
nVlrFSD		:= SL1->L1_FRETE + SL1->L1_SEGURO + SL1->L1_DESPESA

If SL1->L1_DESCONTO > 0
	//O valor de desconto deve ser encontrada atraves da soma de todos os produtos (seus valores originais) (sem frete / sem desconto / sem acrescimo)
	//Porem quando � selecionado a NCC para pagamento os valores vem um pouco diferentes.
	If SL1->L1_CREDITO > 0 
		nDescTot	:= SL1->L1_DESCONT * (  (nValTot-nVlrDescIt) / (SL1->L1_VALBRUT - nVlrFSD + SL1->L1_DESCONT))
	Else
		nDescTot	:= nTotDesc
	EndIf 
	
	sTexto	:= sTexto + 'Desconto no Total:             ' + Str(nDescTot, 15, 2) + Chr(13) + Chr(10)
EndIf

//Armazena Valor Total
If lMvArrefat
    nVlrTot := Round((nValTot - nDescTot - nVlrDescIt + nTroco), TamSX3("D2_TOTAL")[2])
Else
    nVlrTot := NoRound((nValTot - nDescTot - nVlrDescIt + nTroco), TamSX3("D2_TOTAL")[2])
EndIf

//Calcula juros
If SL1->L1_VLRJUR > 0    

   nVlrAcres := SL1->L1_VLRJUR  
    
	nVlrTot   += nVlrAcres //Adiciona acrescimo no valor total
    sTexto    := sTexto + 'Valor do acrescimo no Total:     ' + Transform(SL1->L1_VLRJUR, "@R 99,999,999.99") + Chr(13) + Chr(10)

EndIf

//Adiciona frete somente quando existe um item com pedido na venda
If nVlrFSD > 0 .And. lPedido
    nVlrTot += nVlrFSD
EndIf

/* Ajusta o valor proporcionalizado na condi��o de pagamento em $
Necessario para evitar diferen�a de 0,01 centavos em determinados casos de venda mista*/
If nDinheir > 0
	If nValPag <> nVlrTot
		// Ajusto o valor em dinheiro para impress�o no comprovante n�o fiscal		
		//nDinheir := nDinheir + Round(nValTot + nVlrFSD - nDescTot - nVlrDescIt + nTroco + nVlrAcres,2) - nValPag
		nDinheir := nDinheir + Round(nValTot + nVlrFSD - nDescTot - nVlrDescIt + nTroco, 2) - nValPag

	EndIf	            
EndIf
                                                                    
If nVlrFSD > 0 .And. lPedido
	sTexto	:= sTexto + 'Frete:                         ' + Transform(nVlrFSD, PesqPict("SL1","L1_FRETE")) + Chr(13) + Chr(10)
EndIf

sTexto	:= sTexto + '-----------------------------------------------' + Chr(13) + Chr(10)
sTexto	:= sTexto + 'TOTAL                          ' + Str(nVlrTot, 15, 2) + Chr(13) + Chr(10)
If nDinheir > 0 
	sTexto := sTexto + 'DINHEIRO' + '                   ' + Str( nDinheir , 15, 2) + ' (+)' + Chr(13) + Chr(10)
EndIf
If nCheques > 0 
	sTexto := sTexto + 'CHEQUE' + '                     ' + Str(nCheques, 15, 2) + ' (+)' +  Chr(13) + Chr(10)
EndIf
If nCartaoC > 0 
	sTexto := sTexto + 'CARTAO CRED' + '                ' + Str(nCartaoC, 15, 2) + ' (+)' +  Chr(13) + Chr(10)
EndIf
If nCartaoD > 0 
	sTexto := sTexto + 'CARTAO DEB' + '                 ' + Str(nCartaoD, 15, 2) + ' (+)' + Chr(13) + Chr(10)
EndIf

If nPIX > 0 
	sTexto := sTexto + 'PIX' + '                        ' + Str(nPIX, 15, 2) + ' (+)' + Chr(13) + Chr(10)
EndIf
If nCartDig > 0 
	sTexto := sTexto + 'CARTEIRA DIGITAL' + '           ' + Str(nCartDig, 15, 2) + ' (+)' + Chr(13) + Chr(10)
EndIf

If nConveni > 0 
	sTexto := sTexto + 'CONVENIO' + '                   ' + Str(nConveni, 15, 2) + ' (+)' + Chr(13) + Chr(10)
EndIf
If nOutros > 0 
	sTexto := sTexto + 'OUTROS' + '                      ' + Str(nOutros, 15, 2) + ' (+)' + Chr(13) + Chr(10)
EndIf
If nVales > 0 
	sTexto := sTexto + 'VALES' + '                      ' + Str(nVales, 15, 2) + ' (+)' + Chr(13) + Chr(10)
EndIf
If nFinanc > 0 
	sTexto := sTexto + 'FINANCIADO' + '                 ' + Str(nFinanc, 15, 2) + ' (+)' + Chr(13) + Chr(10)
EndIf  
If nCredito > 0
	sTexto := sTexto + 'CREDITO ' + '                   ' + Str(nCredito, 15, 2) + ' (+)' + Chr(13) + Chr(10)
EndIf			
sTexto := sTexto + '-----------------------------------------------' + Chr(13) + Chr(10) 
If lMvLjTroco .And. nTroco > 0
	sTexto := sTexto + 'TROCO   ' + '                   ' + Str(nTroco, 15, 2) +' (-)'+ Chr(13) + Chr(10)
EndIf			                                                                                        
sTexto := sTexto + '-----------------------------------------------' + Chr(13) + Chr(10) 

If !Empty(cDocPed) .and. !Empty(cSerPed) 
    sTexto := sTexto + 'SERIE PEDIDO		' + '                         ' +  cSerPed + Chr(13) + Chr(10)
    sTexto := sTexto + 'DOCUMENTO PEDIDO    ' + '                         ' +  cDocPed + Chr(13) + Chr(10)
	sTexto := sTexto + 'LEGENDA DOS TIPOS DE ENTREGA' + '                 ' + Chr(13) + Chr(10)
	sTexto := sTexto + 'T.E:1 - Retira Posterior' + '                     ' + Chr(13) + Chr(10)
	sTexto := sTexto + 'T.E:3 - Entrega' + '                              ' + Chr(13) + Chr(10)
	sTexto := sTexto + 'T.E:4 - Retira Posterior c/ Pedido' + '           ' + Chr(13) + Chr(10)
	sTexto := sTexto + 'T.E:5 - Entrega c/ Pedido s/ Reserva' + '         ' + Chr(13) + Chr(10)
EndIf

sTexto := sTexto + Chr(13) + Chr(10)

RestArea(aAreaSL1)
RestArea(aAreaSL2)  
RestArea(aArea)

Return sTexto

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LjPrtPdLoc  �Autor�Vendas CRM		     � Data � 10/06/11    ���
�������������������������������������������������������������������������͹��
���Descri��o �Rotina para impressao de Comprovante de Venda - Release 11.5���
�������������������������������������������������������������������������͹��
���Sintaxe   �ExpL1 := LjPrtPdLoc()                       				  ���
�������������������������������������������������������������������������͹��
���Retorno   �											                  ���
�������������������������������������������������������������������������͹��
���Uso       �SIGALOJA/SIGAFRT	                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  
User Function LjPrtPdLoc ()
Local lRet := .T.


Local wnrel   	:= "SCRPED"
Local cString  	:= "SL1"
Local cDesc1   	:= "Comprobante de Venta"
Local cDesc2   	:= ""
Local cDesc3   	:= ""
Local nLastKey 	:= 0 
Local nOrcam    := 0          
Local nCheques	:= 0 
Local nCartao	:= 0 
Local nConveni	:= 0 
Local nVales	:= 0 
Local nFinanc	:= 0 
Local nCredito	:= 0
Local nOutros 	:= 0 
Local cQuant 	:= ""
Local cVrUnit	:= ""
Local cDesconto	:= ""
Local cVlrItem	:= "" 
Local cTpEntrega:= ""
Local nLinha	:= 10 
Local nMoedaCor	:= 1						//Moeda Corrente
Local nDecimais := MsDecimais(nMoedaCor)	//Decimais

Private cTitulo  	:= "Comprobante de Venta"
Private aReturn := { "Especial", 1,"Administracion", 1, 2, 1,"",1 }

//����������������������������������������
//� Envia controle para a funcao SETPRINT�
//����������������������������������������
wnrel:=SetPrint(cString,wnrel,"",@cTitulo,cDesc1,cDesc2,cDesc3,.F.)
If nLastKey == 27
	Return .F.
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return .F.
Endif
//����������������������������������������������
//�Verifica Posicao do Formulario na Impressora�
//����������������������������������������������
VerImp()

//�����������������������������������������Ŀ
//�Verificar os itens que atendem o tipo de �
//�entrega de acordo com o pais.            �
//�������������������������������������������
Do Case
	Case cPaisLoc == "COL"
		cTpEntrega := "1|3"		
	Case cPaisLoc == "CHI"
		cTpEntrega := "1"
EndCase


//��������������������������������������������������������������������������������������������������Ŀ
//�                                              CABECALHO                                           �
//����������������������������������������������������������������������������������������������������
@ nLinha, 001 PSAY "Codigo"
@ nLinha, 010 PSAY "Descripcion"
@ nLinha, 060 PSAY "Cantidad"
@ nLinha, 080 PSAY "Unitario"
@ nLinha, 100 PSAY "Total"

nLinha++
@ nLinha, 001 PSAY "----------------------------------------------------------------------------------------------------------------------------"
nLinha++

dbSelectArea("SL1")                                                                  
dbSetOrder(1)  
nOrcam		:= SL1->L1_NUM
nDinheir	:= SL1->L1_DINHEIR
nCheques	:= SL1->L1_CHEQUES
nCartao 	:= SL1->L1_CARTAO
nConveni	:= SL1->L1_CONVENI
nVales  	:= SL1->L1_VALES  	
nFinanc		:= SL1->L1_FINANC
nCredito	:= SL1->L1_CREDITO
nOutros		:= SL1->L1_OUTROS
           
//��������������������������������������������������������������������������������������������������Ŀ
//�                                              ITENS		                                         �
//����������������������������������������������������������������������������������������������������
dbSelectArea("SL2")
dbSetOrder(1)  
dbSeek(xFilial("SL2") + nOrcam)
	
While !SL2->(Eof()) .AND. SL2->L2_FILIAL + SL2->L2_NUM == cFilAnt + nOrcam
	If SL2->L2_ENTREGA $ cTpEntrega	
		cQuant 		:= StrZero(SL2->L2_QUANT, 8, 3)
		cVrUnit		:= Str(((SL2->L2_QUANT * SL2->L2_PRCTAB) / SL2->L2_QUANT), 15, nDecimais)
		cDesconto	:= Str(SL2->L2_VALDESC, TamSx3("L2_VALDESC")[1], TamSx3("L2_VALDESC")[2])
		cVlrItem	:= Str(Val(cVrUnit) * SL2->L2_QUANT, 15, nDecimais)
	     
		@ nLinha, 001 PSAY SL2->L2_PRODUTO
		@ nLinha, 010 PSAY SL2->L2_DESCRI
		@ nLinha, 060 PSAY cQuant
		@ nLinha, 080 PSAY AllTrim(cVrUnit)
		@ nLinha, 100 PSAY AllTrim(cVlrItem)
		
		If SL2->L2_VALDESC > 0 
			nLinha++
			@ nLinha, 060 PSAY 'Descuento del Item: ' + Str(SL2->L2_VALDESC, 15, nDecimais)
		EndIf
	EndIf
	SL2->(DbSkip())
	nLinha++
Enddo                      

//��������������������������������������������������������������������������������������������������Ŀ
//�                                              RODAPE		                                         �
//����������������������������������������������������������������������������������������������������
nLinha++
If SL1->L1_DESCONTO > 0
	@ nLinha, 080 PSAY 'Descuento Total: 	            ' + Str(SL1->L1_DESCONTO, 15, nDecimais)
	nLinha++
EndIf                                                                              
If SL1->L1_JUROS > 0
	@ nLinha, 080 PSAY 'Incremento Total:            	' + Transform(SL1->L1_JUROS, "@R 99.99%")
	nLinha++
EndIf

nLinha++
@ nLinha, 001 PSAY "----------------------------------------------------------------------------------------------------------------------------"
nLinha++

@ nLinha, 080 PSAY 'TOTAL                         ' + Str(SL1->L1_VLRLIQ+nCredito, 15, nDecimais)

If nDinheir > 0
	nLinha++ 
	@ nLinha, 080 PSAY 'DINERO' + '                      	 ' + Str(nDinheir, 15, nDecimais)
EndIf
If nCheques > 0 
	nLinha++
	@ nLinha, 080 PSAY 'CHEQUE' + '                         ' + Str(nCheques, 15, nDecimais)
EndIf
If nCartao > 0 
	nLinha++
	@ nLinha, 080 PSAY 'TARJETA' + '                          ' + Str(nCartao, 15, nDecimais)
EndIf
If nConveni > 0 
	nLinha++
	@ nLinha, 080 PSAY 'CONVENIO' + '                        ' + Str(nConveni, 15, nDecimais)
EndIf
If nVales > 0 
	nLinha++
	@ nLinha, 080 PSAY 'BONOS' + '                           ' + Str(nVales, 15, nDecimais)
EndIf
If nFinanc > 0 
	nLinha++
	@ nLinha, 080 PSAY 'FINANCIADO' + '                      ' + Str(nFinanc, 15, nDecimais)
EndIf  
If nCredito > 0
	nLinha++
	@ nLinha, 080 PSAY 'CREDITO' + '                       ' + Str(nCredito, 15, nDecimais)
EndIf			
			
nLinha++
@ nLinha, 001 PSAY "----------------------------------------------------------------------------------------------------------------------------"



Set Device To Screen
If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    � VerImp   �Autor  �Vendas CRM		     � Data �  10/06/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica posicionamento de papel na Impressora             ���
�������������������������������������������������������������������������͹��
���Uso       � SCRPED	                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function VerImp()

Local aDriver  :=  ""
Local nOpc     

nLin:= 0                // Contador de Linhas
aDriver:=ReadDriver()
If aReturn[5]==2
	
	nOpc       := 1
	While .T.
		
		SetPrc(0,0)
		dbCommitAll()
		
		@ 00   ,000	PSAY aDriver[5]
		@ nLin ,000 PSAY " "
		@ nLin ,004 PSAY "*"
		@ nLin ,022 PSAY "."
		
		IF MsgYesNo(OemToAnsi("�Fomulario esta en posicion? "))
		   nOpc := 1
		ElseIF MsgYesNo(OemToAnsi("�Intenta Nuevamente? "))
		   nOpc := 2
		Else
		   nOpc := 3
		Endif

		Do Case
		Case nOpc==1
			lContinua := .T.
			Exit
		Case nOpc==2
			Loop
		Case nOpc==3
			lContinua := .F.
			Return
		EndCase
	End
Endif
Return


//-------------------------------------------------------------------
/*/{Protheus.doc} SCRCRED
Funcao para impressao de Comprovante de cr�dito do cliente
@type function
@param 

@author Varejo
@version P12
@since 23/01/2018
@return cTexto, retorna texto do comprovante de credito do cliente

/*/
//-------------------------------------------------------------------
User Function SCRCRED()   

Local aArea 		:= GetArea()	// Guarda area atual
Local cTexto		:= ""			// Texto do comprovante a ser impresso
Local nX			:= 0 			// Contador
Local nTotNCCs		:= 0 			// Valor Total de todas as NCCs disponiveis para uso
Local lPOS			:= STFIsPOS() 	// Valida Pos?
Local nLarCup 		:= 40			// Largura do cupom de acordo com cadastro de estacao
Local cPicValor     := PesqPict("SL1","L1_VLRTOT")//Picture de valor
Local nTPCompNCC    := SuperGetMV("MV_LJCPNCC",,1)//Compensacao de NCC 1-Compensacao atual 2- Nova Compensacao 

Local nVlrCred 		:= PARAMIXB[1] 	// Valor de credito usado na venda L1_CREDITO
Local aNCCs 		:= PARAMIXB[2] 	// Array com todas NCCs abertas do cliente
Local nTotSelNCC	:= PARAMIXB[3] 	// Valor Total NCCs selecionadas
Local cCodCli    	:= PARAMIXB[4] 	// Codigo do Cliente
Local cCodLojCli	:= PARAMIXB[5] 	// Codigo da loja do cliente

/*   
	Posicoes do Array aNCCs
	
	aNCCs[x,1]  = .F.	// Caso a NCC seja selecionada, este campo recebe TRUE			 
	aNCCs[x,2]  = SE1->E1_SALDO  
	aNCCs[x,3]  = SE1->E1_NUM		
	aNCCs[x,4]  = SE1->E1_EMISSAO
	aNCCs[x,5]  = SE1->(Recno()) 
	aNCCs[x,6]  = SE1->E1_SALDO
	aNCCs[x,7]  = SuperGetMV("MV_MOEDA1")
	aNCCs[x,8]  = SE1->E1_MOEDA
	aNCCs[x,9]  = SE1->E1_PREFIXO	
	aNCCs[x,10] = SE1->E1_PARCELA	 
	aNCCs[x,11] = SE1->E1_TIPO
*/

nLarCup := IIF(lPOS,STFGetStation("LARGCOL"),LJGetStation("LARGCOL"))

//Caso o usu�rio n�o informe no cadastro de esta��o a largura do cupom ou edite pelo APSDU uma largura inv�lida
If nLarCup <= 0 
	nLarCup := 40
EndIf

//Somente Imprime para tipo de compensa��o 1 e 2 
If nTPCompNCC >= 1 .And. nTPCompNCC <= 2
	If Len(aNCCs) > 0 .AND. nVlrCred > 0
	
		cTexto += Replicate("-",nLarCup) + CHR(10)	
		cTexto += PADC(AllTrim(SM0->M0_NOMECOM),nLarCup) + CHR(10)	
		cTexto += PADC("CNPJ: " + AllTrim(SM0->M0_CGC),nLarCup) + CHR(10)	
		cTexto += PADC(DtoC(dDatabase)+" "+TIME(),nLarCup) + CHR(10)	
		cTexto += PADC(AllTrim(cCodCli) + "/" + cCodLojCli + " - " +  AllTrim(POSICIONE("SA1",1,xFilial("SA1")+cCodCli+cCodLojCli,"A1_NOME")),nLarCup)	+ CHR(10)
	
		For nX := 1 To Len(aNCCs) 
			nTotNCCs += aNCCs[nX][2] //Soma total de NCCs disponiveis
		Next nX
		
		cTexto += CHR(10) + PADR("Cr�dito utilizado na venda:",nLarCup-14) + PADL("R$ " +AllTrim(Transform(nVlrCred,cPicValor)),14) + CHR(10)
		cTexto +=  PADR("*** Saldo Restante:",nLarCup-15) + PADL("R$ " + AllTrim(Transform(nTotNCCs-nVlrCred,cPicValor)),15) + CHR(10) 
		cTexto += CHR(10) + "*** Posi��o de cr�dito dispon�vel" + CHR(10) 
		cTexto += Replicate("-",nLarCup) + CHR(10)	
		
	EndIf	
EndIf		
RestArea(aArea)

Return cTexto   

/*/{Protheus.doc} SCRPRetPgt
Retorna os valores de cada Forma de Pagamento da venda conforma os valores gravados na SL4
@type  Static Function
@author joao.marcos
@since 26/09/2023
@version version
@return aVlrFormas, arrray, array com os valores de cada Forma de Pagamento
/*/
Static Function SCRPRetPgt()
Local aAreaSL4		:= SL4->(GetArea())
Local aVlrFormas	:= {{"R$",0},;	// 01
						{"CH",0},;	// 02
						{"CC",0},;	// 03
						{"CD",0},;	// 04
						{"PX",0},;	// 05
						{"PD",0},;	// 06
						{"FI",0},;	// 07
						{"CO",0},;	// 08
						{"VA",0},;	// 09
						{"CR",0},;	// 10
						{"OUTRO",0}} // 11

SL4->(dbSetOrder(1))
If SL4->(dbSeek(SL1->L1_FILIAL + SL1->L1_NUM))
	While SL4->(!EOF()) .AND. SL4->L4_FILIAL == SL1->L1_FILIAL .AND. SL4->L4_NUM == SL1->L1_NUM
		Do Case
			Case AllTrim(SL4->L4_FORMA) == "R$"
				aVlrFormas[01][02] += SL4->L4_VALOR
			Case AllTrim(SL4->L4_FORMA) == "CH"
				aVlrFormas[02][02] += SL4->L4_VALOR
			Case AllTrim(SL4->L4_FORMA) == "CC"
				aVlrFormas[03][02] += SL4->L4_VALOR
			Case AllTrim(SL4->L4_FORMA) == "CD"
				aVlrFormas[04][02] += SL4->L4_VALOR
			Case AllTrim(SL4->L4_FORMA) == "PX"
				aVlrFormas[05][02] += SL4->L4_VALOR
			Case AllTrim(SL4->L4_FORMA) == "PD"
				aVlrFormas[06][02] += SL4->L4_VALOR
			Case AllTrim(SL4->L4_FORMA) == "FI"
				aVlrFormas[07][02] += SL4->L4_VALOR
			Case AllTrim(SL4->L4_FORMA) == "CO"
				aVlrFormas[08][02] += SL4->L4_VALOR
			Case AllTrim(SL4->L4_FORMA) == "VA"
				aVlrFormas[09][02] += SL4->L4_VALOR	
			Case AllTrim(SL4->L4_FORMA) == "CR"
				aVlrFormas[10][02] += SL4->L4_VALOR
			Otherwise
				aVlrFormas[11][02] += SL4->L4_VALOR	
		EndCase

		SL4->(dbSkip())
	EndDo
EndIf

RestArea(aAreaSL4)
	
Return aVlrFormas
