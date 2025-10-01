#INCLUDE "RWMAKE.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
��� Fun�ao   � SCRVPres    � Autor � Vendas CLientes    � Data �08/01/2014���
�������������������������������������������������������������������������Ĵ��
��� Descri�ao� Monta o texto a ser impresso no comprovante de venda       ���
���          � (nao fiscal) no caso de venda de VALE PRESENTE.            ���
�������������������������������������������������������������������������Ĵ��
��� Retorno  � Texto a ser impresso                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Sigaloja                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/  
User Function SCRVPres()
Local nOrcam
Local sTexto                      
Local nCheques
Local nCartao
Local nConveni
Local nVales
Local nFinanc
Local nCredito		:= 0
Local nOutros
Local cQuant 		:= ""
Local cVrUnit		:= ""
Local cDesconto		:= ""
Local cVlrItem		:= ""

sTexto:= 'Codigo         Descricao'+Chr(13)+Chr(10)
sTexto:= sTexto+ 'Qtd             VlrUnit                 VlrTot'+Chr(13)+Chr(10)
sTexto:= sTexto+'-----------------------------------------------'+Chr(13)+Chr(10)
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
           
dbSelectArea("SL2")
dbSetOrder(1)  
dbSeek(xFilial("SL2") + nOrcam)
	
While !SL2->(Eof()) .AND. SL2->L2_FILIAL + SL2->L2_NUM == cFilAnt + nOrcam
	cQuant 		:= StrZero(SL2->L2_QUANT, 8, 3)
	cVrUnit		:= Str(( (SL2->L2_QUANT * SL2->L2_PRCTAB) ) / SL2->L2_QUANT, 15, 2)
	cDesconto	:= Str(SL2->L2_VALDESC, TamSx3("L2_VALDESC")[1], TamSx3("L2_VALDESC")[2])
	cVlrItem	:= Str(Val(cVrUnit) * SL2->L2_QUANT, 15, 2)

	sTexto		:= sTexto + SL2->L2_PRODUTO + SL2->L2_DESCRI + Chr(13) + Chr(10)
	sTexto		:= sTexto + cQuant + '  ' + cVrUnit + '      ' + cVlrItem + Chr(13) + Chr(10)
	If SL2->L2_VALDESC > 0 
		sTexto	:= sTexto + 'Desconto no Item:              ' + Str(SL2->L2_VALDESC, 15, 2) + Chr(13) + Chr(10)
	EndIf
	SL2->(DbSkip())
Enddo                      

If SL1->L1_DESCONTO > 0
	sTexto	:= sTexto + 'Desconto no Total:             ' + Str(SL1->L1_DESCONTO, 15, 2) + Chr(13) + Chr(10)
EndIf                                                                              
If SL1->L1_JUROS > 0
	sTexto	:= sTexto + 'Acrescimo no Total:            ' + Transform(SL1->L1_JUROS, "@R 99.99%") + Chr(13) + Chr(10)
EndIf

sTexto	:= sTexto + '-----------------------------------------------' + Chr(13) + Chr(10)
sTexto	:= sTexto + 'TOTAL                         ' + Str(SL1->L1_VLRLIQ, 15, 2) + Chr(13) + Chr(10)

If nDinheir > 0 
	sTexto := sTexto + 'DINHEIRO' + '                       ' + Str(nDinheir, 15, 2) + Chr(13) + Chr(10)
EndIf
If nCheques > 0 
	sTexto := sTexto + 'CHEQUE' + '                         ' + Str(nCheques, 15, 2) + Chr(13) + Chr(10)
EndIf
If nCartao > 0 
	sTexto := sTexto + 'CARTAO' + '                          ' + Str(nCartao, 15, 2) + Chr(13) + Chr(10)
EndIf
If nConveni > 0 
	sTexto := sTexto + 'CONVENIO' + '                        ' + Str(nConveni, 15, 2) + Chr(13) + Chr(10)
EndIf
If nVales > 0 
	sTexto := sTexto + 'VALES' + '                           ' + Str(nVales, 15, 2) + Chr(13) + Chr(10)
EndIf
If nFinanc > 0 
	sTexto := sTexto + 'FINANCIADO' + '                      ' + Str(nFinanc, 15, 2) + Chr(13) + Chr(10)
EndIf  
If nCredito > 0
	sTexto := sTexto + 'CREDITO ' + '                       ' + Str(nCredito, 15, 2) + Chr(13) + Chr(10)
EndIf			
			
sTexto := sTexto + '-----------------------------------------------' + Chr(13) + Chr(10)

Return sTexto