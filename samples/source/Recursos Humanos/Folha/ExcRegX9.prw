#INCLUDE "PROTHEUS.CH"
#iNCLUDE 'TBICONN.CH'

/*/{Protheus.doc} ExcRegX9
Rotina que apaga registro indevido na tabela SX9
@type  User Function
@since 20/02/2020
@see
/*/
User Function ExcRegX9()

	Local aArea := getArea()

	// Se a chamada n�o ocorrer via Menu, necess�rio preparar o ambiente
	//PREPARE ENVIRONMENT EMPRESA "T1" FILIAL "D MG 01 " MODULO "GPE"

	DbSelectArea("SX9")
	DbSetOrder(1)

	If DbSeek("RA2")
		While !(Eof()) .And. X9_DOM == "RA2"
			If X9_CDOM == "RAK" .And. AllTrim(X9_EXPDOM) == "RA2_CALEND"
				If MsgNoYes("Foi encontrado um relacionamento incorreto entre as tabelas RA2 e RAK, deseja remov�-lo?")
					If RecLock("SX9",.F.)
						dbDelete()
						MsUnlock()
						ApMsgInfo("Ajuste realizado com sucesso!")
					EndIf
				EndIf
			EndIf
			DbSkip()
		EndDo
	EndIf

	If DbSeek("SRA")
		While !(Eof()) .And. X9_DOM == "SRA"
			If AllTrim(X9_EXPDOM) == "RA_MAT"
				If AllTrim(X9_EXPCDOM) == "AA1_CDFUNC"
					If MsgNoYes("Foi encontrado um relacionamento inconsistente entre as tabelas AA1 e SRA, deseja remov�-lo?")
						If RecLock("SX9",.F.)
							dbDelete()
							MsUnlock()
							ApMsgInfo("Registro exclu�do com sucesso!")
						EndIf
					EndIf
				EndIf
				If AllTrim(X9_EXPCDOM) == "QG_MAT"
					If MsgNoYes("Foi encontrado um relacionamento inconsistente entre as tabelas SQG e SRA, deseja remov�-lo?")
						If RecLock("SX9",.F.)
							dbDelete()
							MsUnlock()
							ApMsgInfo("Registro exclu�do com sucesso!")
						EndIf
					EndIf
				EndIf
				If AllTrim(X9_EXPCDOM) == "QB_MATRESP"
					If MsgNoYes("Registro de relacionamento inconsistente entre as tabelas SQB e SRA encontrado, deseja prosseguir com o ajuste?")
						If RecLock("SX9",.F.)
							dbDelete()
							MsUnlock()
							ApMsgInfo("Registro exclu�do com sucesso!")
						EndIf
					EndIf
				EndIf
			EndIf
			DbSkip()
		EndDo
	EndIf

RestArea(aArea)

Return
