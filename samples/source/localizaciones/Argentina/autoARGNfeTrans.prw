//BIBLIOTECAS
#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

//CONSTANTES
#DEFINE PRX_LIN CHR(13) + CHR(10)

/*/{Protheus.doc} DSVFAT2
MONTAGEM DO ENVIRONMENT.
@type function
@author Rafael Falco
@since 25/09/2018
@version 12

@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
User Function DSVFAT2()

	/*======== CRIAÇÃO DO ENVIROMENT =========*/
	RpcClearEnv() 
	RpcSetType(3)
	//Informar os dados do ambiente para a execução da Função RpcSetEnv
	//RpcSetEnv - Abertura do ambiente em rotinas automáticas
	//https://tdn.totvs.com/pages/releaseview.action?pageId=6814927
	RpcSetEnv( "99", "01"  , "ADMIN", ""        , "FAT", , { "SF1", "SF2", "SA1" }, .F., .F. )
	
	U_DSVFAT1()
	
Return Nil	
	
/*/{Protheus.doc} DSVFAT1
EXECUÇÃO DO PROCESSO DE TRANSMISSÃO DO AUTONFE VIA SCHEDULE/JOB.
@type function
@author Rafael Falco
@since 25/09/2018
@version 12

@param cTipPro 1 - Transmissao, 2 - Monitoramento, 3 - Cancelamento
@param aSerNfe  MV_PAR01, serie utilizada na transmissão automatica
@param MV_AUTTRAN , Parâmetro controlar data/hora da última execução REMITO/FACTURA  [AAAAMMDD|HH:MM:SS] 
@param MV_INTERVA - Parâmetro para controlar o intervalo entre as execuções [120]-Minutos 
@param MV_NFESPEC - Parâmetro para as espécies de NF utilizadas no SFP->FP_ESPECIE [ 1, 2, 3, 4, 5, 6, 7 ]
@param MV_WRKFLW - Parâmetro para listar as contas de e-mail que serão enviados [aaaa@gmail.com;bbbb@gmail.com;cccc@gmail.com] 

@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
User Function DSVFAT1()

	Local cAutTra	:= SuperGetMV("MV_AUTTRAN",.F.,"" )// DATA/HORA DA ÚLTIMA EXECUÇÃO
	Local nInterv	:= SuperGetMV("MV_INTERVA",.F.,1 )	// CONTROLAR O INTERVALO ENTRE AS EXECUÇÕES
	Local cSfpEsp	:= SuperGetMV("MV_NFESPEC",.F.,"" )	// ESPÉCIES DE NF UTILIZADAS NO [SFP->FP_ESPECIE]
	Local cSerVld	:= SuperGetMV("MV_SERVLDS",.F.,"" )// SÉRIES VÁLIDAS A SEREM UTILIZADAS NO FILTRO [SFP.FP_SERIE]
	Local cMailPr	:= SubStr(Alltrim( SuperGetMV("MV_WRKFLW",.F.,"") ), 1, At(';', Alltrim( SuperGetMV("MV_WRKFLW",.F.,"") ))-1)	/// EMAIL PARA QUEM 
	Local cMailCp	:= SubStr(Alltrim( SuperGetMV("MV_WRKFLW",.F.,"") ), At(';', Alltrim( SuperGetMV("MV_WRKFLW",.F.,"") ))+1, Len(Alltrim( SuperGetMV("MV_WRKFLW",.F.,"") )) )	/// EMAIL COM CÓPIA
	Local cMailBc	:= ""						/// EMAIL COM CÓPIA OCULTA  
	Local cMaiAss	:= ""						/// ASSUNTO DO E-MAIL
	Local cMsgPad 	:= ""						/// MENSAGEM PADRÃO
	Local cHtml 	:= ""						/// CORPO DO EMAIL
	Local cPerAtu	:= SubStr( DtoS( Date() ), 1, 6 )
	Local cOrdAtu	:= iIf( Val( SubStr( DtoS( Date() ), 7, 2 ) ) >= 16, "2", "1" )
	Local cCAEE 	:= ""
	
	Local cQry 		:= ""
	Local cAliTmp	:= GetNextAlias()
	Local cAliTm2	:= GetNextAlias()
	Local cQrySFP	:= ''
	Local cAliSFP 	:= GetNextAlias()
	
	Local nI		:= 0
	Local nVezes    := 0
	Local nTotReg	:= 0
	Local nCriArq 	:= 0							/// CONTROLE DA CRIAÇÃO DO ARQUIVO
	Local nMinuto	:= 0							/// TEMPO DA ÚLTIMA EXECUÇÃO
	Local cHraAtu	:= Time()						/// HORA ATUAL
	Local cHraUlt	:= SubStr( cAutTra, 10, 18 )	/// HORA ULTIMA EXECUÇÃO
	Local cDirLog	:= GetSrvProfString("RootPath", "\undefined") + GetSrvProfString("StartPath", "\undefined") + "Auto_Envio_Log\" 	/// DIRETÓRIO PARA GRAVAÇÀO DO ARQUIVO DE LOG
	Local lDirExi	:= .F.							/// DIRETÓRIO PARA GRAVAÇÀO DO ARQUIVO DE LOG
	Local cSelectQry := ""
	Local cFromQry   := ""
	Local cWhereQry  := ""
	Local cBancoDB   := Upper(TcGetDb())

	Private cAutRet	:= ""
	Private cAutSer	:= ""
	Private cAutNtI	:= ""
	Private cAutNtF	:= ""
	Private cAutMsg := ""
	Private cTipTra	:= "1-Salida"					/// [FATURA/REMITO] = 1 - SALIDA / 2 - ENTRADA 
	Private cAutFil := "4-Sin Filtro     "			/// [REMITO]=4-Sin Filtro / [FACTURA]=5-Sin Filtro
	Private cTipFac	:= ""							/// SFP.FP_ESPECIE
	Private cTipoWs	:= ""							/// SFP.FP_NFEEX - AJUSTADO PARA OPÇÕES DA TELA MANUAL
	Private cPtoVnd	:= ""							/// SFP.FP_PV
	Private cAutPlt	:= SuperGetMV( "MV_COTPLAN",.F.,"")
	Private cAutPrt	:= SuperGetMV( "MV_COTPORT",.F.,"")
	Private aLogEnv	:= {}							/// ARRAY CONTENDO MENSAGENS DE LOG DO ENVIO 
	Private lAutoNf	:= .T.							/// Envio Automático de Nota Fiscal
	
	conout("=======================================================================")
	conout("======>>>>  Inicio da transmissao:" + DtoS( Date() ) + "|" + Time() )
	conout("=======================================================================" + CRLF)

	/// CRIAÇÃO DO LOCAL PARA GRAVAÇÃO DO LOG DE ENVIO
	If( ! ExistDir( cDirLog ) )
		lDirExi := MakeDir( cDirLog )
	EndIf

	/// TRATAMENTO PARA CONTROLE DE EXECUÇÃO (intervalo)
	nMinuto := Hrs2Min( ElapTime( cHraUlt, cHraAtu ) )
	cAutMsg := DtoS( Date() ) + "|" + cHraAtu
	aAdd( aLogEnv, { cAutMsg, "**Linha-0110", DtoS( Date() ) + "|" + Time() } )
	If( nMinuto >= nInterv )
		PutMv( "MV_AUTTRAN", DtoS( Date() ) + "|" + cHraAtu )

		cSelectQry := "% SFP.FP_SERIE, SFP.FP_NUMINI, SFP.FP_NUMFIM, SFP.FP_ESPECIE, SFP.FP_PV, SFP.FP_ULTDTHR, "
		cSelectQry += " SFP.FP_TOTTENT, SFP.FP_QTDTENT, SFP.FP_FILUSO, SFP.FP_FILIAL, SFP.FP_NFEEX, SFP.R_E_C_N_O_ RECNO %"

		cFromQry   := "% " + RetSqlName('SFP') + " SFP %"

		cWhereQry  := "% SFP.FP_FILIAL = '" + xFilial('SFP') + "'"
		cWhereQry  += " AND SFP.FP_ESPECIE IN (" + cSfpEsp + ") "
		cWhereQry  += " AND RTRIM(SFP.FP_SERIE) IN (" + cSerVld + ") "
		cWhereQry  += " AND SFP.D_E_L_E_T_ = '' %"

		BeginSql Alias cAliTmp
			SELECT %exp:cSelectQry%
			FROM  %exp:cFromQry%
			WHERE %exp:cWhereQry%
			ORDER BY %Order:SFP,5%
		EndSql

		(cAliTmp)->( DbGoTop() )
		
		//// ADICIONA DADOS NO ARRAY A SER LIDO PELA FUNÇÃO 
		While( (cAliTmp)->( ! Eof() ) )

			cAutSer		:= (cAliTmp)->FP_SERIE              
			cAutNtI		:= (cAliTmp)->FP_NUMINI
			If( ! Empty( (cAliTmp)->FP_NUMFIM ) )    
				cAutNtF	:= (cAliTmp)->FP_NUMFIM    
			Else
				cAutNtF	:= (cAliTmp)->FP_NUMINI
			EndIf
			
			cChvNfe := cAutNtI + cAutSer
			
			If( (cAliTmp)->FP_ESPECIE $ "6|7" )		/// ROTINA PARA TRANSMISSÃO DE REMITO    

				cAutRet := ArgRem2(nVezes==0, "SF2")
				cAutRet := FwCutOff(cAutRet)

				aAdd( aLogEnv, { cAutRet, "**Linha-0146", DtoS( Date() ) + "|" + Time() } )
				
				If( At( "[.TSMOK.]", cAutRet ) == 0 )

					// RETORNO DA EXECUÇÃO DA ROTINA DE TRANSMISSÃO AUTOMATICA - ERRO
					Conout( "ERRO----------------TRANSMISSAO AUTOMATICA DE NOTAS FISCAIS - REMITO-----------" )
					Conout( "- Serie-[" + cAutSer + "] - Num_Ini-[" + cAutNtI + "] - Num_Fim-[" + cAutNtF + "]" )
					Conout( cAutRet )
					Conout( "-*-*-----------------------------------------------------------------------*-*-" )
					
					cMaiAss := "ERRO - Workflow de transmissão de Remito"
					cMsgPad := "Processamento cancelado! Verifique."	
					
					//////////////////////////////////////////////////////////////////////
					/// MONTAGEM DO WORFLOW
					WKFEnv( cMailPr, cMailCp, cMailBc, cHtml, cMaiAss, cMsgPad, cAutRet )				
					//////////////////////////////////////////////////////////////////////

					aAdd( aLogEnv, { cAutRet, "**Linha-0164", DtoS( Date() ) + "|" + Time() } )			

					Exit
				
				Else	/// RETORNO DA ROTINA DE TRANSMISSÃO AUTOMATICA - SUCESSO
				
					/// RETORNO DA ROTINA DE TRANSMISSÃO AUTOMATICA DE REMITO - SUCESSO
					Conout( "-*-*----------------TRANSMISSAO AUTOMATICA DE NOTAS FISCAIS----------------*-*-" )
					Conout( "- SUCESSO NA EXECUCAO DA ROTINA AUTOMATICA DE TRANSMISSAO. [REMITO]" )
					Conout( "- Serie-[" + cAutSer + "] - Num_Ini-[" + cAutNtI + "] - Num_Fim-[" + cAutNtF + "]" )
					Conout( cAutRet )
					Conout( "-*-*-----------------------------------------------------------------------*-*-" )
				EndIf
				
				(cAliTmp)->( DbSkip() )

			ElseIf( (cAliTmp)->FP_ESPECIE $ "4" .and. (cAliTmp)->FP_NFEEX == "6" )	/// ROTINA PARA TRANSMISSÃO DE REGIME NOMINAÇÃO    

				cTipoWs := "3"															/// 3-Regime Nominação
				cTipTra := "2-Entrada"													/// Tipo de Transmissão (NCC)
				cAutFil := "5-Sin filtro     "
				cTipFac	:= (cAliTmp)->FP_ESPECIE
				cPtoVnd	:= (cAliTmp)->FP_PV

				cSelectQry := "% SF1.F1_FILIAL, SF1.F1_EMISSAO, SF1.F1_FORMUL, SF1.F1_DOC, SF1.F1_SERIE, SF1.F1_FORNECE, "
				cSelectQry += " SF1.F1_LOJA, SF1.F1_ESPECIE, SF1.F1_CAEE, SF1.F1_FLFTEX, SF1.F1_TIPO, SF1.F1_TPVENT %"
				
				cFromQry   := "% " + RetSqlName('SF1') + " SF1 %"

				cWhereQry  := "% SF1.F1_FILIAL = '" + xFilial('SF1') + "' "
				cWhereQry  += fQrPVDifBD(cBancoDB, "SF1", cPtoVnd)
				cWhereQry  += " AND SF1.F1_SERIE = '" + cAutSer + "' "
				cWhereQry  += " AND SF1.F1_FLFTEX <> 'S' "
				cWhereQry  += " AND RTRIM(SF1.F1_ESPECIE) = 'NCC' "
				cWhereQry  += " AND SF1.D_E_L_E_T_ = '' %"

				BeginSql Alias cAliTm2
					SELECT %exp:cSelectQry%
					FROM  %exp:cFromQry%
					WHERE %exp:cWhereQry%
					ORDER BY %Order:SF1,1%
				EndSql

				(cAliTm2)->( DbGoTop() )
				
				//// ADICIONA DADOS NO ARRAY A SER LIDO PELA FUNÇÃO 
				While( (cAliTm2)->( ! Eof() ) )
				
					DbSelectArea( "CG6" )		//// LOCALIZA O NUMERO DO CAEA PARA GRAVAR NO REGISTRO
					DbsetOrder( 2 )
					If( DbSeek( xFilial('CG6') + (cAliTm2)->F1_FILIAL + cPerAtu + cOrdAtu ) )
						cCAEE := CG6->CG6_CAEA
					Else
						cAutRet := "[Necessita gerar código CAEA para a quinzena atual !]"
						aAdd( aLogEnv, { cAutRet, "**Linha-0212", DtoS( Date() ) + "|" + Time() } )
					EndIf

					DbSelectArea( "SF1" )		//// AJUSTE DO CAMPO F1_TPVENT A ROTINA AGNFE.PRX ESPERA RECEBER LETRAS[B|S|A] E 
					DbsetOrder( 1 )
					If( DbSeek( (cAliTm2)->F1_FILIAL + (cAliTm2)->F1_DOC + (cAliTm2)->F1_SERIE + (cAliTm2)->F1_FORNECE + (cAliTm2)->F1_LOJA + (cAliTm2)->F1_TIPO + (cAliTm2)->F1_FORMUL ) )
						If( SF1->F1_TPVENT $ "1|2|3" .or. Empty( SF1->F1_TPVENT ) )
							RecLock( "SF1", .F. )
								If( Empty( AllTrim( SF1->F1_CAEE ) ) )
									SF1->F1_CAEE := cCAEE
								EndIf	
								If( (cAliTm2)->F1_TPVENT == "1" )
									SF1->F1_TPVENT  := "B"
								ElseIf( (cAliTm2)->F1_TPVENT == "2" )
									SF1->F1_TPVENT  := "S"
								ElseIf( (cAliTm2)->F1_TPVENT == "3" )
									SF1->F1_TPVENT  := "A"
								Else
									SF1->F1_TPVENT  := "U"  //// INDEFINIDO
								EndIf
							SF1->( MsUnLock() )
						Else
							RecLock( "SF1", .F. )
								If( Empty( AllTrim( SF1->F1_CAEE ) ) )
									SF1->F1_CAEE := cCAEE
								EndIf	
							SF1->( MsUnLock() )
						EndIf
					EndIf

					DbSelectArea( "SFP" )			//// GRAVAÇÃO DA EXECUÇÃO DA ROTINA AUTOMÁTICA PARA CONTROLE
					DbsetOrder( 6 )
					If( DbSeek( (cAliTmp)->FP_FILIAL + (cAliTmp)->FP_FILUSO + (cAliTmp)->FP_ESPECIE + (cAliTmp)->FP_SERIE + (cAliTmp)->FP_NUMINI ) )
						RecLock( "SFP", .F. )
							SFP->FP_ULTDTHR  := DtoS( Date() ) + "|" + cHraAtu
							If( (cAliTmp)->FP_TOTTENT == 0 )
								SFP->FP_TOTTENT  := 5
							EndIf		
						SFP->( MsUnLock() )
					EndIf

					cAutSer		:= (cAliTm2)->F1_SERIE              
					cAutNtI		:= (cAliTm2)->F1_DOC
					cAutNtF		:= (cAliTm2)->F1_DOC

					// GRAVAR ÚLTIMA EXECUÇÃO NOS CAMPO DA SFP (FP_TOTTENT / FP_QTDTENT / FP_ENVDTHR )					
					If( (cAliTmp)->FP_QTDTENT > 0 )
						RecLock( "SFP", .F. )
							SFP->FP_ULTDTHR  := DtoS( Date() ) + "|" + cHraAtu
							SFP->FP_QTDTENT  := 0
						SFP->( MsUnLock() )
					EndIf	
				
					Conout( "-*-*----------------TRANSMISSAO AUTOMATICA DE NOTAS FISCAIS----------------*-*-" )
					Conout( "-  [NCC REGIMEN NOMINACION]" )
					cAutRet := ARGNNFe2(nVezes==0, "SF1")

					aAdd( aLogEnv, { cAutRet, "**Linha-0271", DtoS( Date() ) + "|" + Time() } )

					If( At( "[.TSMOK.]", cAutRet ) == 0 )
					    Conout( "-*-*----------------TRANSMISSAO AUTOMATICA DE NOTAS FISCAIS----------------*-*-" )
					    Conout( "-  [NCC REGIMEN NOMINACION] ERROR" )
						Exit
					Else
						/// RETORNO DA ROTINA DE TRANSMISSÃO AUTOMATICA DE FACTURA - SUCESSO
						Conout( "-*-*----------------TRANSMISSAO AUTOMATICA DE NOTAS FISCAIS----------------*-*-" )
						Conout( "- SUCESSO NA EXECUCAO DA ROTINA AUTOMATICA DE TRANSMISSAO. [FACTURA]" )
						Conout( "- Serie-[" + cAutSer + "] - Num_Ini-[" + cAutNtI + "] - Num_Fim-[" + cAutNtF + "]" )
						Conout( cAutRet )
						conout( "*-*------------------------------------------------------------------------------------------------------------*-*" )
						conout( "*=*============================================================================================================*=*" )

						(cAliTm2)->( DbSkip() )

					EndIf					

				End

				(cAliTm2)->( DbCloseArea() )

				If( Empty(cAutRet) )
					cAutRet := "----------------TRANSMISSAO AUTOMATICA DE NOTAS FISCAIS - FACTURA-----------" + PRX_LIN
					cAutRet += "------------------- NENHUM REGISTRO LOCALIZADO -------------------" + PRX_LIN
					cAutRet += "- Serie-[" + cAutSer + "] - Num_Ini-[" + cAutNtI + "] - Num_Fim-[" + cAutNtF + "]" + PRX_LIN
					cAutRet += "-[.TSMOK.]" + PRX_LIN
				Else	
					cAutRet := FwCutOff(cAutRet)
				EndIf

				If( At( "[.TSMOK.]", cAutRet ) == 0 )

					// RETORNO DA EXECUÇÃO DA ROTINA DE TRANSMISSÃO AUTOMATICA - ERRO
					Conout( "ERRO----------------TRANSMISSAO AUTOMATICA DE NOTAS FISCAIS - FACTURA-----------" )
					Conout( "- Serie-[" + cAutSer + "] - Num_Ini-[" + cAutNtI + "] - Num_Fim-[" + cAutNtF + "]" )
					Conout( cAutRet )
					Conout( "-*-*-----------------------------------------------------------------------*-*-" )
					cMaiAss := "ERRO - Workflow de transmissão de Factura"
					cMsgPad := "Processamento cancelado! Verifique."					

					//////////////////////////////////////////////////////////////////////
					/// MONTAGEM DO WORFLOW
					WKFEnv( cMailPr, cMailCp, cMailBc, cHtml, cMaiAss, cMsgPad, cAutRet )				
					//////////////////////////////////////////////////////////////////////

					aAdd( aLogEnv, { cAutRet, "**Linha-0316", DtoS( Date() ) + "|" + Time() } )	

					Exit					

				Else					
					/// RETORNO DA ROTINA DE TRANSMISSÃO AUTOMATICA DE FACTURA - SUCESSO
					Conout( "-*-*----------------TRANSMISSAO AUTOMATICA DE NOTAS FISCAIS----------------*-*-" )
					Conout( "- SUCESSO NA EXECUCAO DA ROTINA AUTOMATICA DE TRANSMISSAO. [FACTURA]" )
					Conout( "- Serie-[" + cAutSer + "] - Num_Ini-[" + cAutNtI + "] - Num_Fim-[" + cAutNtF + "]" )
					Conout( cAutRet )
					Conout( "-*-*-----------------------------------------------------------------------*-*-" )
					
					cAutRet := "- Serie-[" + cAutSer + "] - Num_Ini-[" + cAutNtI + "] - Num_Fim-[" + cAutNtF + "]" + PRX_LIN
					cAutRet += "ESPÉCIE ====>>>> " + (cAliTmp)->FP_ESPECIE + "<<<<==== " + PRX_LIN
					cMaiAss := "Workflow de transmissão de Factura"
					cMsgPad := "Simulação de transmissão [FACTURA]"
				EndIf	


			ElseIf( (cAliTmp)->FP_ESPECIE $ "4"  )	/// TRANSMISION NCC WEBSERVER NACIONAL    

				//// ADEQUAÇÃO DO TIPO DE FORMULARIO WEB SERVICE QUE SERÁ USADO
				If( (cAliTmp)->FP_NFEEX == "3" )											/// 3-Web Server Nacional
					cTipoWs := "1"           /// 1-Nacional
				ElseIf( (cAliTmp)->FP_NFEEX == "1" .or. (cAliTmp)->FP_NFEEX == "2" )		/// 1-Web Server / 2-On Line Export
					cTipoWs := "2"															/// 2-Exportação
				ElseIf( (cAliTmp)->FP_NFEEX == "4" )										/// 4-Regime Nominação
					cTipoWs := "3"															/// 3-Nominacion
				ElseIf( (cAliTmp)->FP_NFEEX == "5" )										/// 5-Regime Bono
					cTipoWs := "4"															/// 4-Regime de Bono
				ElseIf( (cAliTmp)->FP_NFEEX == "6" )										/// 6-Nacional CAEA
					cTipoWs := "5"															/// 5-Nacional CAEA
					cTipoWs := "7"															/// 7-Nominação CAEA
				EndIf

				cTipTra := "2-Entrada"													/// Tipo de Transmissão (NCC)
				cAutFil := "5-Sin filtro     "
				cTipFac	:= (cAliTmp)->FP_ESPECIE
				cPtoVnd	:= (cAliTmp)->FP_PV

				cSelectQry := "% SF1.F1_FILIAL, SF1.F1_EMISSAO, SF1.F1_FORMUL, SF1.F1_DOC, SF1.F1_SERIE, SF1.F1_FORNECE, "
				cSelectQry += " SF1.F1_LOJA, SF1.F1_ESPECIE, SF1.F1_CAEE, SF1.F1_FLFTEX, SF1.F1_TIPO, SF1.F1_TPVENT %"

				cFromQry   := "% " + RetSqlName('SF1') + " SF1 %"

				cWhereQry  := "% SF1.F1_FILIAL = '" + xFilial('SF1') + "' "
				cWhereQry  += fQrPVDifBD(cBancoDB, "SF1", cPtoVnd)
				cWhereQry  += " AND SF1.F1_SERIE = '" + cAutSer + "' "
				cWhereQry  += " AND SF1.F1_FLFTEX <> 'S' "
				cWhereQry  += " AND RTRIM(SF1.F1_ESPECIE) = 'NCC' "
				cWhereQry  += " AND SF1.D_E_L_E_T_ = '' %"

				BeginSql Alias cAliTm2
					SELECT %exp:cSelectQry%
					FROM  %exp:cFromQry%
					WHERE %exp:cWhereQry%
					ORDER BY %Order:SF1,1%
				EndSql

				(cAliTm2)->( DbGoTop() )
				
				//// ADICIONA DADOS NO ARRAY A SER LIDO PELA FUNÇÃO 
				While( (cAliTm2)->( ! Eof() ) )
				
					DbSelectArea( "SF1" )		//// AJUSTE DO CAMPO F1_TPVENT A ROTINA AGNFE.PRX ESPERA RECEBER LETRAS[B|S|A] E 
					DbsetOrder( 1 )
					If( DbSeek( (cAliTm2)->F1_FILIAL + (cAliTm2)->F1_DOC + (cAliTm2)->F1_SERIE + (cAliTm2)->F1_FORNECE + (cAliTm2)->F1_LOJA + (cAliTm2)->F1_TIPO + (cAliTm2)->F1_FORMUL ) )
						If( SF1->F1_TPVENT $ "1|2|3" .or. Empty( SF1->F1_TPVENT ) )
							RecLock( "SF1", .F. )
								If( Empty( AllTrim( SF1->F1_CAEE ) ) )
									SF1->F1_CAEE := cCAEE
								EndIf	
								If( (cAliTm2)->F1_TPVENT == "1" )
									SF1->F1_TPVENT  := "B"
								ElseIf( (cAliTm2)->F1_TPVENT == "2" )
									SF1->F1_TPVENT  := "S"
								ElseIf( (cAliTm2)->F1_TPVENT == "3" )
									SF1->F1_TPVENT  := "A"
								Else
									SF1->F1_TPVENT  := "U"  //// INDEFINIDO
								EndIf
							SF1->( MsUnLock() )
						EndIf
					EndIf

					DbSelectArea( "SFP" )			//// GRAVAÇÃO DA EXECUÇÃO DA ROTINA AUTOMÁTICA PARA CONTROLE
					DbsetOrder( 6 )
					If( DbSeek( (cAliTmp)->FP_FILIAL + (cAliTmp)->FP_FILUSO + (cAliTmp)->FP_ESPECIE + (cAliTmp)->FP_SERIE + (cAliTmp)->FP_NUMINI ) )
						RecLock( "SFP", .F. )
							SFP->FP_ULTDTHR  := DtoS( Date() ) + "|" + cHraAtu
							If( (cAliTmp)->FP_TOTTENT == 0 )
								SFP->FP_TOTTENT  := 9
							EndIf		
						SFP->( MsUnLock() )
					EndIf

					cAutSer		:= (cAliTm2)->F1_SERIE              
					cAutNtI		:= (cAliTm2)->F1_DOC
					cAutNtF		:= (cAliTm2)->F1_DOC

					// GRAVAR ÚLTIMA EXECUÇÃO NOS CAMPO DA SFP (FP_TOTTENT / FP_QTDTENT / FP_ENVDTHR )					
					If( (cAliTmp)->FP_QTDTENT > 0 )
						RecLock( "SFP", .F. )
							SFP->FP_ULTDTHR  := DtoS( Date() ) + "|" + cHraAtu
							SFP->FP_QTDTENT  := 0
						SFP->( MsUnLock() )
					EndIf	
				
					Conout( "-*-*----------------TRANSMISSAO AUTOMATICA DE NOTAS FISCAIS----------------*-*-" )
					Conout( "- [NCC REGIMEN] "+cTipoWs )
					cAutRet := ARGNNFe2(nVezes==0, "SF1")

					aAdd( aLogEnv, { cAutRet, "**Linha-0415", DtoS( Date() ) + "|" + Time() } )

					If( At( "[.TSMOK.]", cAutRet ) == 0 )
						Conout( "-*-*----------------TRANSMISSAO AUTOMATICA DE NOTAS FISCAIS----------------*-*-" )
						Conout( "- [NCC REGIMEN] "+cTipoWs + "  - ERROR")
						Exit
					Else
						/// RETORNO DA ROTINA DE TRANSMISSÃO AUTOMATICA DE FACTURA - SUCESSO
						Conout( "-*-*----------------TRANSMISSAO AUTOMATICA DE NOTAS FISCAIS----------------*-*-" )
						Conout( "- SUCESSO NA EXECUCAO DA ROTINA AUTOMATICA DE TRANSMISSAO. [FACTURA]" )
						Conout( "- Serie-[" + cAutSer + "] - Num_Ini-[" + cAutNtI + "] - Num_Fim-[" + cAutNtF + "]" )
						Conout( cAutRet )
						conout( "*-*------------------------------------------------------------------------------------------------------------*-*" )
						conout( "*=*============================================================================================================*=*" )

						(cAliTm2)->( DbSkip() )

					EndIf					

				End

				(cAliTm2)->( DbCloseArea() )

				If( Empty(cAutRet) )
					cAutRet := "----------------TRANSMISSAO AUTOMATICA DE NOTAS FISCAIS - FACTURA-----------" + PRX_LIN
					cAutRet += "------------------- NENHUM REGISTRO LOCALIZADO -------------------" + PRX_LIN
					cAutRet += "- Serie-[" + cAutSer + "] - Num_Ini-[" + cAutNtI + "] - Num_Fim-[" + cAutNtF + "]" + PRX_LIN
					cAutRet += "-[.TSMOK.]" + PRX_LIN
				Else	
					cAutRet := FwCutOff(cAutRet)
				EndIf

				If( At( "[.TSMOK.]", cAutRet ) == 0 )

					// RETORNO DA EXECUÇÃO DA ROTINA DE TRANSMISSÃO AUTOMATICA - ERRO
					Conout( "ERRO----------------TRANSMISSAO AUTOMATICA DE NOTAS FISCAIS - FACTURA-----------" )
					Conout( "- Serie-[" + cAutSer + "] - Num_Ini-[" + cAutNtI + "] - Num_Fim-[" + cAutNtF + "]" )
					Conout( cAutRet )
					Conout( "-*-*-----------------------------------------------------------------------*-*-" )
					cMaiAss := "ERRO - Workflow de transmissão de Factura"
					cMsgPad := "Processamento cancelado! Verifique."					

					//////////////////////////////////////////////////////////////////////
					/// MONTAGEM DO WORFLOW
					WKFEnv( cMailPr, cMailCp, cMailBc, cHtml, cMaiAss, cMsgPad, cAutRet )				
					//////////////////////////////////////////////////////////////////////

					aAdd( aLogEnv, { cAutRet, "**Linha-0460", DtoS( Date() ) + "|" + Time() } )	

					Exit					

				Else					
					/// RETORNO DA ROTINA DE TRANSMISSÃO AUTOMATICA DE FACTURA - SUCESSO
					Conout( "-*-*----------------TRANSMISSAO AUTOMATICA DE NOTAS FISCAIS----------------*-*-" )
					Conout( "- SUCESSO NA EXECUCAO DA ROTINA AUTOMATICA DE TRANSMISSAO. [FACTURA]" )
					Conout( "- Serie-[" + cAutSer + "] - Num_Ini-[" + cAutNtI + "] - Num_Fim-[" + cAutNtF + "]" )
					Conout( cAutRet )
					Conout( "-*-*-----------------------------------------------------------------------*-*-" )
					
					cAutRet := "- Serie-[" + cAutSer + "] - Num_Ini-[" + cAutNtI + "] - Num_Fim-[" + cAutNtF + "]" + PRX_LIN
					cAutRet += "ESPÉCIE ====>>>> " + (cAliTmp)->FP_ESPECIE + "<<<<==== " + PRX_LIN
					cMaiAss := "Workflow de transmissão de Factura"
					cMsgPad := "Simulação de transmissão [FACTURA]"
				EndIf	


			Else		/// CHAMADA DA ROTINA DE TRANSMISSÃO DE FACTURA

				//// ADEQUAÇÃO DO TIPO DE FORMULARIO WEB SERVICE QUE SERÁ USADO
				If( (cAliTmp)->FP_NFEEX == "3" )											/// 3-Web Server Nacional
					cTipoWs := "1"           /// 1-Nacional
				ElseIf( (cAliTmp)->FP_NFEEX == "1" .or. (cAliTmp)->FP_NFEEX == "2" )		/// 1-Web Server / 2-On Line Export
					cTipoWs := "2"															/// 2-Exportação
				ElseIf( (cAliTmp)->FP_NFEEX == "4" )										/// 4-Regime Nominação
					cTipoWs := "3"															/// 3-Nominação
				ElseIf( (cAliTmp)->FP_NFEEX == "5" )										/// 5-Regime Bono
					cTipoWs := "4"															/// 4-Regime de Bono
				ElseIf( (cAliTmp)->FP_NFEEX == "6" )										/// 6-Nacional CAEA
					cTipoWs := "5"															/// 5-Nacional CAEA
					cTipoWs := "7"															/// 7-Nominação CAEA
				EndIf

				cAutFil := "5-Sin filtro     "
				cTipFac	:= (cAliTmp)->FP_ESPECIE
				cPtoVnd	:= (cAliTmp)->FP_PV

				cSelectQry := "% SF2.F2_FILIAL, SF2.F2_EMISSAO, SF2.F2_FORMUL, SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_CLIENTE, "
				cSelectQry += " SF2.F2_LOJA, SF2.F2_ESPECIE, SF2.F2_CAEE, SF2.F2_FLFTEX, SF2.F2_TIPO, SF2.F2_TPVENT %"

				cFromQry   := "% " + RetSqlName('SF2') + " SF2 %"

				cWhereQry  := "% SF2.F2_FILIAL = '" + xFilial('SF2') + "' "
				cWhereQry  += fQrPVDifBD(cBancoDB, "SF2", cPtoVnd)
				cWhereQry  += " AND SF2.F2_SERIE = '" + cAutSer + "' "
				cWhereQry  += " AND SF2.F2_FLFTEX <> 'S' "
				If (cTipFac $ "1|5|7") 
					cWhereQry  += " AND RTRIM(SF2.F2_ESPECIE) IN ('NF','NDC') "
				Else
					cWhereQry  += " AND RTRIM(SF2.F2_ESPECIE) IN ('NF','NDC','NDI','NCI') "
				EndIf
				cWhereQry  += " AND SF2.D_E_L_E_T_ = '' %"

				BeginSql Alias cAliTm2
					SELECT %exp:cSelectQry%
					FROM  %exp:cFromQry%
					WHERE %exp:cWhereQry%
					ORDER BY %Order:SF2,1%
				EndSql

				(cAliTm2)->( DbGoTop() )
				
				//// ADICIONA DADOS NO ARRAY A SER LIDO PELA FUNÇÃO 
				While( (cAliTm2)->( ! Eof() ) )

					DbSelectArea( "SF2" )		//// AJUSTE DO CAMPO F2_TPVENT A ROTINA AGNFE.PRX ESPERA RECEBER LETRAS[B|S|A] E 
					DbsetOrder( 1 )
					If( DbSeek( (cAliTm2)->F2_FILIAL + (cAliTm2)->F2_DOC + (cAliTm2)->F2_SERIE + (cAliTm2)->F2_CLIENTE + (cAliTm2)->F2_LOJA + (cAliTm2)->F2_FORMUL + (cAliTm2)->F2_TIPO ) )
						If( SF2->F2_TPVENT $ "1|2|3" .or. Empty( SF2->F2_TPVENT ) )
							RecLock( "SF2", .F. )
								If( (cAliTm2)->F2_TPVENT == "1" )
									SF2->F2_TPVENT  := "B"
								ElseIf( (cAliTm2)->F2_TPVENT == "2" )
									SF2->F2_TPVENT  := "S"
								ElseIf( (cAliTm2)->F2_TPVENT == "3" )
									SF2->F2_TPVENT  := "A"
								Else
									SF2->F2_TPVENT  := "U"  //// INDEFINIDO
								EndIf
							SF2->( MsUnLock() )
						EndIf
					EndIf

					DbSelectArea( "SFP" )			//// GRAVAÇÃO DA EXECUÇÃO DA ROTINA AUTOMÁTICA PARA CONTROLE
					DbsetOrder( 6 )
					If( DbSeek( (cAliTmp)->FP_FILIAL + (cAliTmp)->FP_FILUSO + (cAliTmp)->FP_ESPECIE + (cAliTmp)->FP_SERIE + (cAliTmp)->FP_NUMINI ) )
						RecLock( "SFP", .F. )
							SFP->FP_ULTDTHR  := DtoS( Date() ) + "|" + cHraAtu
							If( (cAliTmp)->FP_TOTTENT == 0 )
								SFP->FP_TOTTENT  := 5
							EndIf		
						SFP->( MsUnLock() )
					EndIf

					cAutSer		:= (cAliTm2)->F2_SERIE              
					cAutNtI		:= (cAliTm2)->F2_DOC
					cAutNtF		:= (cAliTm2)->F2_DOC

					// GRAVAR ÚLTIMA EXECUÇÃO NOS CAMPO DA SFP (FP_TOTTENT / FP_QTDTENT / FP_ENVDTHR )					
					If( (cAliTmp)->FP_QTDTENT > 0 )
						RecLock( "SFP", .F. )
							SFP->FP_ULTDTHR  := DtoS( Date() ) + "|" + cHraAtu
							SFP->FP_QTDTENT  := 0
						SFP->( MsUnLock() )
					EndIf	
				
					Conout( "-*-*----------------TRANSMISSAO AUTOMATICA DE NOTAS FISCAIS----------------*-*-" )
					Conout( "-SERIE:"+cAutSer+"  -- DOC:"+cAutNtI+"-----*-*-" )
					cAutRet := ARGNNFe2(nVezes==0, "SF2")

					aAdd( aLogEnv, { cAutRet, "**Linha-0575", DtoS( Date() ) + "|" + Time() } )

					If( At( "[.TSMOK.]", cAutRet ) == 0 )
					    Conout( "-*-*----------------TRANSMISSAO AUTOMATICA DE NOTAS FISCAIS----------------*-*-" )
					    Conout( "-*-*----------------ERROR----------------*-*-" )
						Exit
					Else
						/// RETORNO DA ROTINA DE TRANSMISSÃO AUTOMATICA DE FACTURA - SUCESSO
						Conout( "-*-*----------------TRANSMISSAO AUTOMATICA DE NOTAS FISCAIS----------------*-*-" )
						Conout( "- SUCESSO NA EXECUCAO DA ROTINA AUTOMATICA DE TRANSMISSAO. [FACTURA]" )
						Conout( "- Serie-[" + cAutSer + "] - Num_Ini-[" + cAutNtI + "] - Num_Fim-[" + cAutNtF + "]" )
						Conout( cAutRet )
						conout( "*=*=========================================================================*=*" )

						(cAliTm2)->( DbSkip() )

					EndIf					

				End

				(cAliTm2)->( DbCloseArea() )

				If( Empty(cAutRet) )
					cAutRet := "----------------TRANSMISSAO AUTOMATICA DE NOTAS FISCAIS - FACTURA-----------" + PRX_LIN
					cAutRet += "------------------- NENHUM REGISTRO LOCALIZADO -------------------" + PRX_LIN
					cAutRet += "- Serie-[" + cAutSer + "] - Num_Ini-[" + cAutNtI + "] - Num_Fim-[" + cAutNtF + "]" + PRX_LIN
					cAutRet += "-[.TSMOK.]" + PRX_LIN
				Else	
					cAutRet := FwCutOff(cAutRet) + PRX_LIN
					cAutRet += "- Serie-[" + cAutSer + "] - Num_Ini-[" + cAutNtI + "] - Num_Fim-[" + cAutNtF + "]" + PRX_LIN
				EndIf

				aAdd( aLogEnv, { cAutRet, "**Linha-0605", DtoS( Date() ) + "|" + Time() } )	

				If( At( "[.TSMOK.]", cAutRet ) == 0 )

					cMaiAss := "ERRO - Workflow de transmissão de Factura"
					cMsgPad := "Processamento cancelado! Verifique."					

					//////////////////////////////////////////////////////////////////////
					/// MONTAGEM DO WORFLOW
					WKFEnv( cMailPr, cMailCp, cMailBc, cHtml, cMaiAss, cMsgPad, cAutRet )				
					//////////////////////////////////////////////////////////////////////

					Exit	/// EM CASO DE ERRO FINALIZAR A EXECUÇÃO PARA SÉRIE DE NF ATUAL

				EndIf	

			EndIf
			cAutRet := ""		/// LIMPA VARIÁVEL CONTENDO RETORNO DE MENSAGENS
			(cAliTmp)->( DbSkip() )
	
		End

		(cAliTmp)->( DbGoTop() )

		//// EXECUTA A ROTINA DO MONITOR PARA TODAS AS NF VALIDAS ENVIADAS 
		While( (cAliTmp)->( ! Eof() ) )

			//#TB20190408 Thiago Berna - Ajuste para considerar corretamente o numero inicial e final da NF
			cSelectQry := "% COALESCE ((SELECT MIN(SF3.F3_NFISCAL) "
			cSelectQry += " FROM " + RetSqlName('SF3') + " SF3 "
			cSelectQry += " WHERE SF3.F3_FILIAL = SFP.FP_FILUSO "
			cSelectQry += " AND SF3.F3_CAE = '' "
			cSelectQry += " AND SF3.F3_SERIE = SFP.FP_SERIE "
			cSelectQry += " AND SF3.D_E_L_E_T_ = ''), SFP.FP_NUMINI) FP_NUMINI, "
			cSelectQry += " COALESCE ((SELECT MAX(SF3.F3_NFISCAL) "
			cSelectQry += " FROM " + RetSqlName('SF3') + " SF3 "
			cSelectQry += " WHERE SF3.F3_FILIAL = SFP.FP_FILUSO "
			cSelectQry += " AND SF3.F3_CAE = '' "
			cSelectQry += " AND SF3.F3_SERIE = SFP.FP_SERIE "
			cSelectQry += " AND SF3.D_E_L_E_T_ = '' ) ,SFP.FP_NUMFIM) FP_NUMFIM %"

			cFromQry   := "% " + RetSqlName('SFP') + " SFP %"

			cWhereQry  := "% SFP.R_E_C_N_O_ = '" + AllTrim(Str((cAliTmp)->RECNO)) + "' %"

			BeginSql Alias cAliSFP
				SELECT %exp:cSelectQry%
				FROM  %exp:cFromQry%
				WHERE %exp:cWhereQry%
			EndSql

			(cAliSFP)->( DbGoTop() )
	
			cAliTm2		:= GetNextAlias()
			cAutSer		:= (cAliTmp)->FP_SERIE              
			
			//#TB20190408 Thiago Berna - Ajuste para considerar corretamente o numero inicial e final da NF
			//cAutNtI		:= (cAliTmp)->FP_NUMINI
			cAutNtI		:= (cAliSFP)->FP_NUMINI
			
			//#TB20190408 Thiago Berna - Ajuste para considerar corretamente o numero inicial e final da NF
			//If( ! Empty( (cAliTmp)->FP_NUMFIM ) )    
			If( ! Empty( (cAliSFP)->FP_NUMFIM ) )    
				
				//#TB20190408 Thiago Berna - Ajuste para considerar corretamente o numero inicial e final da NF
				//cAutNtF	:= (cAliTmp)->FP_NUMFIM    
				cAutNtF	:= (cAliSFP)->FP_NUMFIM    

			Else
				
				//#TB20190408 Thiago Berna - Ajuste para considerar corretamente o numero inicial e final da NF
				//cAutNtF	:= SubStr( (cAliTmp)->FP_NUMINI, 1, 4 ) + "99999999"
				cAutNtF	:= SubStr( (cAliSFP)->FP_NUMINI, 1, 4 ) + "99999999"

			EndIf
			
			cAutRet := ARGNNFe6Mnt( cAutSer, cAutNtI, cAutNtF, .T., lAutoNf)
			cAutRet += "- Serie-[" + cAutSer + "] - Num_Ini-[" + cAutNtI + "] - Num_Fim-[" + cAutNtF + "]" + PRX_LIN

			aAdd( aLogEnv, { cAutRet, "**Linha-0645", DtoS( Date() ) + "|" + Time() } )

			Conout( "-*-*---------------- ATUALIZACAO AUTOMATICA DO MONITOR ----------------*-*-" )
			Conout( "[MONITOR] - SUCESSO NA  ATUALIZACAO AUTOMATICA DO MONITOR." )
			Conout( "- Serie-[" + cAutSer + "] - Num_Ini-[" + cAutNtI + "] - Num_Fim-[" + cAutNtF + "]" )
			Conout( cAutRet )
			Conout( "-*-*-----------------------------------------------------------------------*-*-" )

			cMaiAss := "MONITOR - Workflow de atualiza'cão Automática"
			cMsgPad := "Processado pelo monitor."

			//////////////////////////////////////////////////////////////////////
			/// MONTAGEM DO WORFLOW
			WKFEnv( cMailPr, cMailCp, cMailBc, cHtml, cMaiAss, cMsgPad, cAutRet )				
			//////////////////////////////////////////////////////////////////////

			cAutRet := ""
			(cAliTmp)->( DbSkip() )

			(cAliSFP)->(DbCloseArea())

		End

		(cAliTmp)->( DbCloseArea() )
		conout("=======================================================================" + CRLF)
		conout("======>>>>  Fim da transmissao:" + DtoS( Date() ) + "|" + Time() )
		conout("=======================================================================" + CRLF)
		
		/// GRAVAÇÃO DO ARQUIVO DE LOG
		If .f.//( lDirExi )
			
			cDirLog += "LOG_" + DtoS( Date() ) + "_" + StrTran( Time(), ":", "" ) + ".txt"
			nCriArq := FCREATE( cDirLog )
  
			If( nCriArq = -1 )
				Conout("Erro ao criar arquivo - ferror " + Str(Ferror()))
			Else
				cAutRet := ""
				For nI := 1 To Len( aLogEnv )
					cAutRet += aLogEnv[nI][1] + "||" + aLogEnv[nI][3] + CRLF
//					cAutRet += aLogEnv[nI][1] + aLogEnv[nI][3] + "||" + aLogEnv[nI][2] + CRLF
				Next
			
				FWrite( nCriArq, cAutRet + CRLF )
				FClose( nCriArq )
				conout("===========================================================================================================================")
				conout("======>>>>  Log gravado no caminho:" + cDirLog )
				conout("===========================================================================================================================" + CRLF)
			EndIf			
		Else
			conout("Envio de Email contendo log do envio.")
		EndIf

	Else
		Conout( "-*-*----------------TRANSMISSAO AUTOMATICA DE NOTAS FISCAIS----------------*-*-" )
		Conout( "- ULTIMA EXECUCAO EM " + DtoC( StoD( Substr( cAutTra, 1, 8 ) ) ) + " AS " + SubStr( cAutTra, 10, 18 ) + "." )
		Conout( "- AGUARDE A NOVA EXECUCAO DAQUI " + StrZero( nInterv - nMinuto, 3 ) + " Minutos." )
		Conout( "-*-*-----------------------------------------------------------------------*-*-" )
	EndIf

Return nil


Static Function WKFEnv( cMailPr, cMailCp, cMailBc, cHtml, cMaiAss, cMsgPad, cAutRet )

	//////////////////////////////////////////////////////////////////////
	/// MONTAGEM DO WORFLOW
	cHtml := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">   '
	cHtml += '<html>   '
	cHtml += '   <head>   '
	cHtml += '      <title>Transmissão Automática</title>   '
	cHtml += '      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />   '
	cHtml += '      <meta name="viewport" content="width=device-width, initial-scale=1.0"/>   '
	cHtml += '   </head>   '
	cHtml += '   '
	cHtml += '   <body style="margin: 0; padding: 0;">   '
	cHtml += '      <table align="center" border="1" cellpadding="0" cellspacing="0" width="600" style="border-collapse: collapse;">   '
	cHtml += '         <tr>   '
	cHtml += '            <td align="center" bgcolor="#70bbd9" style="padding: 30px 0 20px 0;">   '
	cHtml += '               <img src="https://totvsdigital.azureedge.net/prod/images/default-source/totvs/default-album/logo-totvs.png?sfvrsn=0" alt="Transmissão Automática" width="137" height="40" style="display: block;" />   '
	cHtml += '            </td>   '
	cHtml += '         </tr>   '
	cHtml += '         <tr>   '
	cHtml += '            <td bgcolor="#ffffff" style="padding: 30px 0 20px 0;">   '
	cHtml += '               <table align="center" border="1" cellpadding="0" cellspacing="0" width="80%">   '
	cHtml += '                  <tr>   '
	cHtml += '                     <td style="color:#FF0000">' + cMaiAss + '<br/><b>' + cMsgPad + '</b></td>   '
	cHtml += '                  </tr>   '
	cHtml += '                  <tr>   '
	cHtml += '                     <td style="padding: 20px 0 30px 0;">' + cAutRet + '</td>'
	cHtml += '                  </tr>   '
	cHtml += '               </table>   '
	cHtml += '            </td>   '
	cHtml += '         </tr>   '
	cHtml += '         <tr>   '
	cHtml += '            <td bgcolor="#70bbd9" style="padding: 30px 0 20px 0;">   '
	cHtml += '               <table align="center" border="0" cellpadding="0" cellspacing="0" width="80%">   '
	cHtml += '                  <tr>   '
	cHtml += '                     <td align="right">   '
	cHtml += '                        <table border="0" cellpadding="0" cellspacing="0">   '
	cHtml += '                           <tr>   '
	cHtml += '                              <td width="100%" style="color:#FFFFFF"><b>   '
	cHtml += '                                  &reg; TOTVS - Protheus<br/>   '
	cHtml += '                                  Software de Gestão   '
	cHtml += '                              </b></td>   '
	cHtml += '                           </tr>   '
	cHtml += '                        </table>   '
	cHtml += '                     </td>   '
	cHtml += '                  </tr>   '
	cHtml += '               </table>   '
	cHtml += '            </td>   '
	cHtml += '         </tr>   '
	cHtml += '      </table>   '
	cHtml += '   </body>   '
	cHtml += '</html>   '
	
	U_DispMail( cMailPr, cMailCp, cMailBc, cHtml, cMaiAss )

Return Nil

/*/{Protheus.doc} fQrPVDifBD
	Formar condiciones especificas por manejador de base de datos.
	@type  Function
	@author luis.samaniego
	@since 25/04/2023
	@param  cBancoDB - Banco de datos.
			cAlias - Alias de tabla.
			cPtoVnd - Punto de venta.
	@return cWhereQry - Caracter - Condición SQL.
	/*/
Static Function fQrPVDifBD(cBancoDB, cAlias, cPtoVnd)
Local cWhereQry  := ""

Default cBancoDB := ""
Default cAlias   := ""

	If cBancoDB $ "ORACLE"
		If cAlias == "SF1"
			cWhereQry := " AND SUBSTR(SF1.F1_DOC,1,4) = '" + cPtoVnd + "' "
		Else
			cWhereQry := " AND SUBSTR(SF2.F2_DOC,1,4) = '" + cPtoVnd + "' "
		EndIf
	Else
		If cAlias == "SF1"
			cWhereQry := " AND LEFT(SF1.F1_DOC,4) = '" + cPtoVnd + "' "
		Else
			cWhereQry := " AND LEFT(SF2.F2_DOC,4) = '" + cPtoVnd + "' "
		EndIf
	EndIf

Return cWhereQry
