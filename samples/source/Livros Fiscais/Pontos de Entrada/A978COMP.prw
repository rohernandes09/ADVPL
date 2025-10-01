/*
�����������������������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������������������ͻ��
���Programa  �A978COMP  �Autor�                       Microsiga                            �Data�  31/03/2006 ���
�������������������������������������������������������������������������������������������������������������͹��
���Descricao �PE para tratar as compensacoes da DCTF atraves de titulos manuais compensados                   ���
���          �                                                                                                ���
�������������������������������������������������������������������������������������������������������������͹��
���Parametros�PARAMIXB[1] -> Alias da tabela SE2 posicionado no momento                                       ���
���          �PARAMIXB[2] -> Array contendo dados da baixa do titulo                                          ���
���          �PARAMIXB[3] -> Dados do fornecedor posicionado no momento - Codigo + Loja                       ���
���          �PARAMIXB[4] -> Codigo de receita+variacao conforme solicitado pela DCTF                         ���
���          �PARAMIXB[5] -> Retorna X, de acordo com a periodicidade. Ex: cPeriod="Q" e dData 14/10/2004,    ���
���          �               retorno 1, 1. Quinzena.                                                          ���
���          �PARAMIXB[6] -> Data de apuracao do titulo                                                       ���
���          �PARAMIXB[7] -> Numero de acordo com a periodicidade - D=Diario, S=Semanal, X=Decendial,         ���
���          �               Q=Quinzenal, M=Mensal, B=Bimentral, T=Trimestral, U=Quadrimestral, E=Semestral e ���
���          �               A=Anual.                                                                         ���
���          �PARAMIXB[8] -> Periodocidade de uma data - D=Diario, S=Semanal, X=Decendial, Q=Quinzenal,       ���
���          �               M=Mensal, B=Bimentral, T=Trimestral, U=Quadrimestral, E=Semestral e A=Anual.     ���
���          �PARAMIXB[9] -> CNPJ do SIGAMAT ou do FORNECEDOR do titulo PAI, caso exista.                     ���
���          �PARAMIXB[10] -> SA2->A2_CODMUN do FORNECEDOR do titulo PAI, caso exista.                        ���
���          �PARAMIXB[11] -> Codigo de receita do titulo - deve ser utilizada, pois na DCTF trimestral ela   ���
���          �                tem um tratamento especial no MATA978                                           ���
���          �                                                                                                ���
�������������������������������������������������������������������������������������������������������������͹��
���Retorno   �1-Indicador de COMPENSACAO, S para COMPENSACAO e N para NAO.                                    ���
���          �2-Tipo de FORMALIZACAO                                                                          ���
���          �3-Numero da FORMALIZACAO                                                                        ���
���          �4-Indicador se devo tratar no padrao do sistema (T) ou NAO(F). Quando tratar pelo               ���
���          �  padrao do sistema ele NAO irah identificar a compensacao.                                     ���
���          �                                                                                                ���
�������������������������������������������������������������������������������������������������������������͹��
���Sintaxe   � A978COMP                                                                                       ���
�������������������������������������������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������������������������
*/ 
User Function A978COMP
	Local	cAlsSe2		:=	PARAMIXB[1]		//Alias da tabela SE2 posicionado no momento
	Local	aBaixa		:=	PARAMIXB[2]		//Array contendo dados da baixa do titulo
	Local	cComp		:=	Iif ("COMPENSACAO"$Upper (aBaixa[9]), "S", "N")	//Verificacao se eh um TX que foi compensado
	Local	aFornece	:=	PARAMIXB[3]		//Dados do fornecedor posicionado no momento - Codigo + Loja
	Local	cCodRetVar	:=	StrZero (Val (PARAMIXB[4]), 5)		//Codigo de receita+variacao conforme solicitado pela DCTF
	Local	cDSQD		:=	StrZero (PARAMIXB[5], 2)			//Retorna X, de acordo com a periodicidade. Ex: cPeriod="Q" e dData 14/10/2004, retorno 1, 1. Quinzena.
	Local	dDtApur		:=	PARAMIXB[6]							//Data de apuracao do titulo
	Local	cMBTQS		:=	StrZero (PARAMIXB[7], 2)			//Numero de acordo com a periodicidade - D=Diario, S=Semanal, X=Decendial, Q=Quinzenal, M=Mensal, B=Bimentral, T=Trimestral, U=Quadrimestral, E=Semestral e A=Anual.
	Local	cPeriod		:=	PARAMIXB[8]							//Periodocidade de uma data - D=Diario, S=Semanal, X=Decendial, Q=Quinzenal, M=Mensal, B=Bimentral, T=Trimestral, U=Quadrimestral, E=Semestral e A=Anual.
	Local	nCnpjDarf	:=	PARAMIXB[9]							//CNPJ do SIGAMAT ou do FORNECEDOR do titulo PAI, caso exista.
	Local	cCodMun		:=	PARAMIXB[10]						//SA2->A2_CODMUN do FORNECEDOR do titulo PAI, caso exista.
	Local	cCodRet		:=	PARAMIXB[11]						//Codigo de receita do titulo - deve ser utilizada, pois na DCTF trimestral ela tem um tratamento especial no MATA978
	Local	cAnoApur	:=	StrZero (Year (dDtApur), 4)
	Local	aInfComp	:=	{"N","","",.T.}					//Informacoes da Nota de Debito Fornecedor, ou seja, da compensacao
																//1-Indicador de COMPENSACAO, S para COMPENSACAO e N para NAO.
																//2-Tipo de FORMALIZACAO
																//3-Numero da FORMALIZACAO
																//4-Indicador se devo tratar no padrao do sistema (T) ou NAO(F). Quando tratar pelo padrao do sistema ele NAO irah identificar a compensacao.
	//
	//������������������������Ŀ
	//�SOMENTE PARA COMPENSACAO�
	//��������������������������
	If ("S"$cComp)
		RetComp ((cAlsSe2)->E2_PREFIXO, (cAlsSe2)->E2_NUM, (cAlsSe2)->E2_PARCELA, (cAlsSe2)->E2_TIPO, (cAlsSe2)->E2_FORNECE, (cAlsSe2)->E2_LOJA, @aInfComp)
		//���������������������������������������Ŀ
		//�TRB utilizado na geracao dos registros.�
		//�����������������������������������������
		If !TRB->(DbSeek (aFornece[1]+aFornece[2]+cCodRetVar+cDSQD+cAnoApur+cMBTQS+aInfComp[1]+aInfComp[2]+aInfComp[3]))
			TRB->(RecLock ("TRB", .T.))
				TRB->TRB_FORN	:=	aFornece[1]
				TRB->TRB_LOJA	:=	aFornece[2]
				TRB->TRB_CODREC	:=	Val (cCodRetVar)
				TRB->TRB_ANOAPU	:=	Val (cAnoApur)
				TRB->TRB_MESAPU	:=	Val (cMBTQS)
				TRB->TRB_DSQD	:=	Val (cDSQD)
				TRB->TRB_PERIOD	:=	cPeriod
				//����������������������������������������������������������������������������������������Ŀ
				//�Regra na validacao - Somente deverah ser preenchido quando nao for compensacao ou quando�
				//�      for e a formalizacao for 3.                                                       �
				//������������������������������������������������������������������������������������������
				If ("S"$aInfComp[1] .And. "3"$aInfComp[2]) .Or. ("N"$aInfComp[1])
					TRB->TRB_PERAPU	:=	dDtApur
					TRB->TRB_CNPJDA	:=	nCnpjDarf
					TRB->TRB_CODRE2	:=	Val ((cAlsSe2)->E2_CODRET)
					TRB->TRB_DTVENC	:=	(cAlsSe2)->E2_VENCREA
				EndIf
				TRB->TRB_DATA	:=	dDtApur
				TRB->TRB_COMP	:=	aInfComp[1]
				TRB->TRB_FORMAL	:=	aInfComp[2]
				TRB->TRB_NUMERO	:=	aInfComp[3]
				//
				If ("4028"$cCodRet)
					TRB->TRB_NUMRER	:=	cCodMun
				Else
					TRB->TRB_NUMRER	:=	""
				EndIf
				TRB->TRB_NATUR	:=	(cAlsSe2)->E2_NATUREZ
		Else
			TRB->(RecLock ("TRB", .F.))
		EndIf
				//����������������������������������������������������������������������������������������Ŀ
				//�Regra na validacao - Somente deverah ser preenchido quando nao for compensacao ou quando�
				//�      for e a formalizacao for 3.                                                       �
				//������������������������������������������������������������������������������������������
				If ("S"$cComp .And. "3"$aInfComp[2]) .Or. ("N"$cComp)
					TRB->TRB_VLRPRI	+=	(cAlsSe2)->E2_VALOR
				EndIf
				TRB->TRB_VLRMUL	+=	aBaixa[4]
				TRB->TRB_VLRJUR	+=	aBaixa[3]
				TRB->TRB_VLRPAG	+=	aBaixa[6]			//Somo o desconto pois a DCTF nao considera se estiver embutido na baixa
			TRB->(MsUnLock ())
	EndIf
Return (aInfComp)
/*
�����������������������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������������������������ͻ��
���Programa  |RetComp   �Autor�                       Microsiga                            �Data�  31/03/2006 ���
�������������������������������������������������������������������������������������������������������������͹��
���Descricao �Retorna valores necessario para a geracao do Registro 12 (Compensacao)                          ���
���          �                                                                                                ���
�������������������������������������������������������������������������������������������������������������͹��
���Observacao�Ao passar as informacoes do titulo TX em processamento, verifico se possui baixa por compensacao,���
���          � se houver, atraves dos campos E5_DOCUMEN, E5_FORNADT e E5_LOJAADT posiciono no titulo que o    ���
���          � compensou e retorno as informacoes de FORMALIZACAO e NUMERO DE PROCESSO do titulo de compensacao���
���          �                                                                                                ���
�������������������������������������������������������������������������������������������������������������͹��
���Parametros�cPrefixo -> Prefixo do titulo TX                                                                ���
���          �cNumero -> Numero do titulo TX                                                                  ���
���          �cParcela -> Parcela do titulo TX                                                                ���
���          �cTipo -> Tipo do titulo TX                                                                      ���
���          �cClifor -> Codigo do fornecedor do titulo TX                                                    ���
���          �cLoja -> Loja do fornecedor do titulo TX                                                        ���
���          �                                                                                                ���
�������������������������������������������������������������������������������������������������������������͹��
���Retorno   �aRet -> Array contendo as informacoes de Formalizacao e Numero Processo para o registro 12.     ���
���          �                                                                                                ���
�������������������������������������������������������������������������������������������������������������͹��
���Sintaxe   �RetComp (cPrefixo, cNumero, cParcela, cTipo, cCliFor, cLoja)                                    ���
�������������������������������������������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������������������������������
*/
Static Function	RetComp (cPrefixo, cNumero, cParcela, cTipo, cCliFor, cLoja, aInfComp)
	Local   nTamTit		:=	TamSx3 ("E5_PREFIXO")[1]+TamSx3 ("E5_NUMERO")[1]+TamSx3 ("E5_PARCELA")[1]+TamSx3 ("E5_TIPO")[1]
	Local	aMVCMPSE2	:=	&(GetNewPar ("MV_CMPSE2", "{}"))
	//
	If Len (aMVCMPSE2)==0
		aInfComp		:=	{"N","", "", .T.}
		Return (aInfComp)
	EndIf
	//
	DbSelectArea ("SE5")
		SE5->(DbSetOrder (7))
	If (SE5->(DbSeek (xFilial ("SE5")+cPrefixo+cNumero+cParcela+cTipo+cCliFor+cLoja)))
		Do While !SE5->(Eof ()) .And.;
			cPrefixo+cNumero+cParcela+cTipo+cCliFor+cLoja==SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA
			//
			If (SE5->E5_MOTBX=="CMP")
				DbSelectArea ("__SE2")
					__SE2->(DbSetOrder (1))
				If (__SE2->(DbSeek (xFilial ("SE2")+SubStr (SE5->E5_DOCUMEN, 1, nTamTit)+SE5->E5_FORNADT+SE5->E5_LOJAADT)))
					aInfComp[2]	:=	&("__SE2->"+aMVCMPSE2[1])		//Formalizacao do Pedido
					aInfComp[3]	:=	&("__SE2->"+aMVCMPSE2[2])		//Numero do PERDCOMP ou PROCESSO
					aInfComp[1]	:=	"S"
					aInfComp[4]	:=	.F.
					//
					Exit
				EndIf
			EndIf
			//
			SE5->(DbSkip ())
		EndDo
	EndIf
Return (.T.)