#INCLUDE "TOTVS.CH"
#INCLUDE 'PARMTYPE.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE "TBICONN.CH"
#INCLUDE "RESTFUL.CH"
//
#Define STR_CaneAdvisor 'CaneAdvisor'
#Define STR_ActiveYeld  'ActiveYeld'
#Define STR_CombineAdvi 'CombineAdvi'
#Define STR_ExactApply  'ExactApply'
#Define STR_IncPro      'IncPro'
#Define STR_RER         'R&R'
#Define STR_SeedStar    'SeedStar'
#Define STR_RowCommand  'RowCommand'
#Define STR_VRD         'VRD'
#Define STR_Clter       'Coulter'
#Define STR_EEmerge 'ExactEmerge'
#Define STR_MaxEmerg    'MaxEmerg'
#Define STR_APDF        'APDF'
//
#Define STR_ACANEAD     'ACANEAD'
#Define STR_AACTYEL     'AACTYEL'
#Define STR_ACOMBAD     'ACOMBAD'
#Define STR_AEXACAP     'AEXACAP'
#Define STR_AINCPRO     'AINCPRO'
#Define STR_ARER        'ARER'
#Define STR_ASEEDST     'ASEEDST'
#Define STR_AROWCOM     'AROWCOM'
#Define STR_AVRD        'AVRD'
#Define STR_ACLTER      'ACOULTE'
#Define STR_AEEMERG     'AEMERGE'
#Define STR_AMAXEME     'AMAXEME'
#Define STR_AAPDF       'AAPDF'
#Define STR_TITULO      'Atualiza Tecnologias DCSI'
//
wsrestful WSATUTEC description "Atualiza Tecnologia"
	WsMethod POST description STR_TITULO
end wsrestful
//
WSMETHOD POST WSRECEIVE WSSERVICE WSATUTEC
	Local cJson  := self:GetContent()
	Local oJbody := Nil
	Local  nInd           := 0
	Local  aTecnologia    := {STR_CaneAdvisor,STR_ActiveYeld,STR_CombineAdvi,STR_ExactApply,STR_IncPro,STR_RER,STR_SeedStar,;
		STR_RowCommand,STR_VRD,STR_Clter,STR_EEmerge,STR_MaxEmerg,STR_APDF}
//
	Private cQrCan := '' //CaneAdvisor
	Private cQrAcY := '' //ActiveYeld
	Private cQrCom := '' //CombineAdvi
	Private cQrExA := '' //ExactApply
	Private cQrInP := '' //IncPro
	Private cQrReR := '' //R&R
	Private cQrSee := '' //SeedStar
	Private cQrRoC := '' //RowCommand
	Private cQrVRD := '' //VRD
	Private cQrClt := '' //Coulter
	Private cQrEEm := '' //ExactEmerge
	Private cQrMaE := '' //MaxEmerg
	Private cQrAPD := '' //APDF
//	
	Private ctecnologia    := ''
	Private nRecno         := 0
	Private periodo		   := 0
	Private nRegistros     := 0
	Private nAtuais
	Private AZBL010        := {}
	Private chavef         := ''	
//
	oJbody := JSonObject():New()
	oJbody:fromJson(DecodeUTF8(cJson))
	RPCSetType(3)
//
	periodo := oJbody["PERIODO"]
//
	AADD(AZBL010,'VV1')
	AADD(AZBL010,'WSATUTEC')
	AADD(AZBL010,STR_TITULO+' - Inicio')
	AADD(AZBL010,'Período: '+AllTrim(STR(periodo))+' dias')
	GravaLog(AZBL010)
//
	For nInd := 1 To Len(aTecnologia)
		nAtuais 	   := 0
		Do Case
		Case aTecnologia[nInd] == STR_CaneAdvisor
			ctecnologia := ''
			B01CaneAdvisor()
			if ACANEAD->(!EOF())
				while ACANEAD->(!EOF())
					ctecnologia := STR_CaneAdvisor
					nRecno     := ACANEAD->RECNO
					AtualizaTec(nRecno,ctecnologia)
					nRegistros++
					nAtuais++
					ACANEAD->(DbSkip())
				enddo
				ACANEAD->(DBCloseArea())
				AZBL010 := {}
				AADD(AZBL010,'VV1')
				AADD(AZBL010,'WSATUTEC')
				AADD(AZBL010,STR_TITULO+' - '+STR_CaneAdvisor)
				AADD(AZBL010,'Total de Registros Atualizados: '+AllTrim(STR(nAtuais)))
				GravaLog(AZBL010)
			else
				AZBL010 := {}
				AADD(AZBL010,'VV1')
				AADD(AZBL010,'WSATUTEC')
				AADD(AZBL010,STR_TITULO+' - '+STR_CaneAdvisor)
				AADD(AZBL010,'Nenhum Registro Atualizado!')
				GravaLog(AZBL010)
			endif
		Case aTecnologia[nInd] == STR_ActiveYeld
			ctecnologia := ''
			B02ActiveYeld()
			if AACTYEL->(!EOF())
				while AACTYEL->(!EOF())
					ctecnologia := STR_ActiveYeld
					nRecno     := AACTYEL->RECNO
					AtualizaTec(nRecno,ctecnologia)
					nRegistros++
					nAtuais++
					AACTYEL->(DbSkip())
				enddo
				AACTYEL->(DBCloseArea())
				AZBL010 := {}
				AADD(AZBL010,'VV1')
				AADD(AZBL010,'WSATUTEC')
				AADD(AZBL010,STR_TITULO+' - '+STR_ActiveYeld)
				AADD(AZBL010,'Total de Registros Atualizados: '+AllTrim(STR(nAtuais)))
				GravaLog(AZBL010)
			else
				AZBL010 := {}
				AADD(AZBL010,'VV1')
				AADD(AZBL010,'WSATUTEC')
				AADD(AZBL010,STR_TITULO+' - '+STR_ActiveYeld)
				AADD(AZBL010,'Nenhum Registro Atualizado!')
				GravaLog(AZBL010)
			endif
		Case aTecnologia[nInd] == STR_CombineAdvi
			ctecnologia := ''
			B03CombineAdvi()
			if ACOMBAD->(!EOF())
				while ACOMBAD->(!EOF())
					ctecnologia := STR_CombineAdvi
					nRecno     := ACOMBAD->RECNO
					AtualizaTec(nRecno,ctecnologia)
					nRegistros++
					nAtuais++
					ACOMBAD->(DbSkip())
				enddo
				ACOMBAD->(DBCloseArea())
				AZBL010 := {}
				AADD(AZBL010,'VV1')
				AADD(AZBL010,'WSATUTEC')
				AADD(AZBL010,STR_TITULO+' - '+STR_CombineAdvi)
				AADD(AZBL010,'Total de Registros Atualizados: '+AllTrim(STR(nAtuais)))
				GravaLog(AZBL010)
			else
				AZBL010 := {}
				AADD(AZBL010,'VV1')
				AADD(AZBL010,'WSATUTEC')
				AADD(AZBL010,STR_TITULO+' - '+STR_CombineAdvi)
				AADD(AZBL010,'Nenhum Registro Atualizado!')
				GravaLog(AZBL010)
			endif
		Case aTecnologia[nInd] == STR_ExactApply
			ctecnologia := ''
			B04ExactApply()
			if AEXACAP->(!EOF())
				while AEXACAP->(!EOF())
					ctecnologia := STR_ExactApply
					nRecno     := AEXACAP->RECNO
					AtualizaTec(nRecno,ctecnologia)
					nRegistros++
					nAtuais++
					AEXACAP->(DbSkip())
				enddo
				AEXACAP->(DBCloseArea())
				AZBL010 := {}
				AADD(AZBL010,'VV1')
				AADD(AZBL010,'WSATUTEC')
				AADD(AZBL010,STR_TITULO+' - '+STR_ExactApply)
				AADD(AZBL010,'Total de Registros Atualizados: '+AllTrim(STR(nAtuais)))
				GravaLog(AZBL010)
			else
				AZBL010 := {}
				AADD(AZBL010,'VV1')
				AADD(AZBL010,'WSATUTEC')
				AADD(AZBL010,STR_TITULO+' - '+STR_ExactApply)
				AADD(AZBL010,'Nenhum Registro Atualizado!')
				GravaLog(AZBL010)
			endif
		Case aTecnologia[nInd] == STR_IncPro
			ctecnologia := ''
			B05IncPro()
			if AINCPRO->(!EOF())
				while AINCPRO->(!EOF())
					ctecnologia := STR_IncPro
					nRecno     := AINCPRO->RECNO
					AtualizaTec(nRecno,ctecnologia)
					nRegistros++
					nAtuais++
					AINCPRO->(DbSkip())
				enddo
				AINCPRO->(DBCloseArea())
				AZBL010 := {}
				AADD(AZBL010,'VV1')
				AADD(AZBL010,'WSATUTEC')
				AADD(AZBL010,STR_TITULO+' - '+STR_IncPro)
				AADD(AZBL010,'Total de Registros Atualizados: '+AllTrim(STR(nAtuais)))
				GravaLog(AZBL010)
			else
				AZBL010 := {}
				AADD(AZBL010,'VV1')
				AADD(AZBL010,'WSATUTEC')
				AADD(AZBL010,STR_TITULO+' - '+STR_IncPro)
				AADD(AZBL010,'Nenhum Registro Atualizado!')
				GravaLog(AZBL010)
			endif
		Case aTecnologia[nInd] == STR_RER
			ctecnologia := ''
			B06RER()
			if ARER->(!EOF())
				while ARER->(!EOF())
					ctecnologia := STR_RER
					nRecno     := ARER->RECNO
					AtualizaTec(nRecno,ctecnologia)
					nRegistros++
					nAtuais++
					ARER->(DbSkip())
				enddo
				ARER->(DBCloseArea())
				AZBL010 := {}
				AADD(AZBL010,'VV1')
				AADD(AZBL010,'WSATUTEC')
				AADD(AZBL010,STR_TITULO+' - '+STR_RER)
				AADD(AZBL010,'Total de Registros Atualizados: '+AllTrim(STR(nAtuais)))
				GravaLog(AZBL010)
			else
				AZBL010 := {}
				AADD(AZBL010,'VV1')
				AADD(AZBL010,'WSATUTEC')
				AADD(AZBL010,STR_TITULO+' - '+STR_RER)
				AADD(AZBL010,'Nenhum Registro Atualizado!')
				GravaLog(AZBL010)
			endif
		Case aTecnologia[nInd] == STR_SeedStar
			ctecnologia := ''
			B07SeedStar()
			if ASEEDST->(!EOF())
				while ASEEDST->(!EOF())
					ctecnologia := STR_SeedStar
					nRecno     := ASEEDST->RECNO
					AtualizaTec(nRecno,ctecnologia)
					nRegistros++
					nAtuais++
					ASEEDST->(DbSkip())
				enddo
				ASEEDST->(DBCloseArea())
				AZBL010 := {}
				AADD(AZBL010,'VV1')
				AADD(AZBL010,'WSATUTEC')
				AADD(AZBL010,STR_TITULO+' - '+STR_SeedStar)
				AADD(AZBL010,'Total de Registros Atualizados: '+AllTrim(STR(nAtuais)))
				GravaLog(AZBL010)
			else
				AZBL010 := {}
				AADD(AZBL010,'VV1')
				AADD(AZBL010,'WSATUTEC')
				AADD(AZBL010,STR_TITULO+' - '+STR_SeedStar)
				AADD(AZBL010,'Nenhum Registro Atualizado!')
				GravaLog(AZBL010)
			endif
		Case aTecnologia[nInd] == STR_RowCommand
			ctecnologia := ''
			B08RowCommand()
			if AROWCOM->(!EOF())
				while AROWCOM->(!EOF())
					ctecnologia := STR_RowCommand
					nRecno     := AROWCOM->RECNO
					AtualizaTec(nRecno,ctecnologia)
					nRegistros++
					nAtuais++
					AROWCOM->(DbSkip())
				enddo
				AROWCOM->(DBCloseArea())
				AZBL010 := {}
				AADD(AZBL010,'VV1')
				AADD(AZBL010,'WSATUTEC')
				AADD(AZBL010,STR_TITULO+' - '+STR_RowCommand)
				AADD(AZBL010,'Total de Registros Atualizados: '+AllTrim(STR(nAtuais)))
				GravaLog(AZBL010)
			else
				AZBL010 := {}
				AADD(AZBL010,'VV1')
				AADD(AZBL010,'WSATUTEC')
				AADD(AZBL010,STR_TITULO+' - '+STR_RowCommand)
				AADD(AZBL010,'Nenhum Registro Atualizado!')
				GravaLog(AZBL010)
			endif
		Case aTecnologia[nInd] == STR_VRD
			ctecnologia := ''
			B09VRD()
			if AVRD->(!EOF())
				while AVRD->(!EOF())
					ctecnologia := STR_VRD
					nRecno     := AVRD->RECNO
					AtualizaTec(nRecno,ctecnologia)
					nRegistros++
					nAtuais++
					AVRD->(DbSkip())
				enddo
				AVRD->(DBCloseArea())
				AZBL010 := {}
				AADD(AZBL010,'VV1')
				AADD(AZBL010,'WSATUTEC')
				AADD(AZBL010,STR_TITULO+' - '+STR_VRD)
				AADD(AZBL010,'Total de Registros Atualizados: '+AllTrim(STR(nAtuais)))
				GravaLog(AZBL010)
			else
				AZBL010 := {}
				AADD(AZBL010,'VV1')
				AADD(AZBL010,'WSATUTEC')
				AADD(AZBL010,STR_TITULO+' - '+STR_VRD)
				AADD(AZBL010,'Nenhum Registro Atualizado!')
				GravaLog(AZBL010)
			endif
		Case aTecnologia[nInd] == STR_Clter
			ctecnologia := ''
			B10Coulter()
			if ACOULTE->(!EOF())
				while ACOULTE->(!EOF())
					ctecnologia := STR_Clter
					nRecno     := ACOULTE->RECNO
					AtualizaTec(nRecno,ctecnologia)
					nRegistros++
					nAtuais++
					ACOULTE->(DbSkip())
				enddo
				ACOULTE->(DBCloseArea())
				AZBL010 := {}
				AADD(AZBL010,'VV1')
				AADD(AZBL010,'WSATUTEC')
				AADD(AZBL010,STR_TITULO+' - '+STR_Clter)
				AADD(AZBL010,'Total de Registros Atualizados: '+AllTrim(STR(nAtuais)))
				GravaLog(AZBL010)
			else
				AZBL010 := {}
				AADD(AZBL010,'VV1')
				AADD(AZBL010,'WSATUTEC')
				AADD(AZBL010,STR_TITULO+' - '+STR_Clter)
				AADD(AZBL010,'Nenhum Registro Atualizado!')
				GravaLog(AZBL010)
			endif
		Case aTecnologia[nInd] == STR_EEmerge
			ctecnologia := ''
			B11EEmerge()
			if AEMERGE->(!EOF())
				while AEMERGE->(!EOF())
					ctecnologia := STR_EEmerge
					nRecno     := AEMERGE->RECNO
					AtualizaTec(nRecno,ctecnologia)
					nRegistros++
					nAtuais++
					AEMERGE->(DbSkip())
				enddo
				AEMERGE->(DBCloseArea())
				AZBL010 := {}
				AADD(AZBL010,'VV1')
				AADD(AZBL010,'WSATUTEC')
				AADD(AZBL010,STR_TITULO+' - '+STR_EEmerge)
				AADD(AZBL010,'Total de Registros Atualizados: '+AllTrim(STR(nAtuais)))
				GravaLog(AZBL010)
			else
				AZBL010 := {}
				AADD(AZBL010,'VV1')
				AADD(AZBL010,'WSATUTEC')
				AADD(AZBL010,STR_TITULO+' - '+STR_EEmerge)
				AADD(AZBL010,'Nenhum Registro Atualizado!')
				GravaLog(AZBL010)
			endif
		Case aTecnologia[nInd] == STR_MaxEmerg
			ctecnologia := ''
			B12MaxEmerg()
			if AMAXEME->(!EOF())
				while AMAXEME->(!EOF())
					ctecnologia := STR_MaxEmerg
					nRecno     := AMAXEME->RECNO
					AtualizaTec(nRecno,ctecnologia)
					nRegistros++
					nAtuais++
					AMAXEME->(DbSkip())
				enddo
				AMAXEME->(DBCloseArea())

				AZBL010 := {}
				AADD(AZBL010,'VV1')
				AADD(AZBL010,'WSATUTEC')
				AADD(AZBL010,STR_TITULO+' - '+STR_MaxEmerg)
				AADD(AZBL010,'Total de Registros Atualizados: '+AllTrim(STR(nAtuais)))
				GravaLog(AZBL010)
			else
				AZBL010 := {}
				AADD(AZBL010,'VV1')
				AADD(AZBL010,'WSATUTEC')
				AADD(AZBL010,STR_TITULO+' - '+STR_MaxEmerg)
				AADD(AZBL010,'Nenhum Registro Atualizado!')
				GravaLog(AZBL010)
			endif
		Case aTecnologia[nInd] == STR_APDF
			ctecnologia := ''
			B13APDF()
			if AAPDF->(!EOF())
				while AAPDF->(!EOF())
					ctecnologia := STR_APDF
					nRecno     := AAPDF->RECNO
					AtualizaTec(nRecno,ctecnologia)
					nRegistros++
					nAtuais++
					AAPDF->(DbSkip())
				enddo
				AAPDF->(DBCloseArea())
				AZBL010 := {}
				AADD(AZBL010,'VV1')
				AADD(AZBL010,'WSATUTEC')
				AADD(AZBL010,STR_TITULO+' - '+STR_APDF)
				AADD(AZBL010,'Total de Registros Atualizados: '+AllTrim(STR(nAtuais)))
				GravaLog(AZBL010)
			else
				AZBL010 := {}
				AADD(AZBL010,'VV1')
				AADD(AZBL010,'WSATUTEC')
				AADD(AZBL010,STR_TITULO+' - '+STR_APDF)
				AADD(AZBL010,'Nenhum Registro Atualizado!')
				GravaLog(AZBL010)
			endif
		EndCase
	Next
//
	AZBL010 := {}
	AADD(AZBL010,'VV1')
	AADD(AZBL010,'WSATUTEC')
	AADD(AZBL010,STR_TITULO+' - Fim')
	AADD(AZBL010,'Total de Registros Atualizados: '+AllTrim(STR(nRegistros)))
	GravaLog(AZBL010)
//
	::setResponse('[{"Status":"Processamento Finalizado com sucesso!","TotalRegistros":"'+AllTrim(STR(nRegistros))+'"}]')
Return .T.
//
Static Function B01CaneAdvisor()
	cQrCan :=   " SELECT DISTINCT                                                                                        "
	cQrCan +=   " VV1_FILIAL FILIAL,VV1_CHAINT CHAINT,VV2_GRUMOD GRUPO,VV2_MODVEI COD_MODELO,VV2_DESMOD DESC_MODELO,     "
	cQrCan +=   " VV1_CHASSI CHASSI,VV1_FABMOD ANO,VV1_DATVEN DT_VENDA,VV1_FILENT FIL_ENTRADA,VV1_FILSAI FIL_SAIDA,      "
	cQrCan +=   " VV2_TIPVEI TIPO, VV1.R_E_C_N_O_ RECNO                                                                  "
	cQrCan +=   " FROM dbo.VV1010 VV1(NOLOCK)                                                                        "
	cQrCan +=   " JOIN dbo.VV2010 VV2(NOLOCK) ON                                                                     "
	cQrCan +=   " VV2.D_E_L_E_T_<> '*' AND VV1_FILIAL=VV2_FILIAL AND VV1_CODMAR = VV2_CODMAR AND VV1_MODVEI = VV2_MODVEI "
	cQrCan +=   " JOIN OPENQUERY(RPA, 'SELECT * FROM tb_EquipmentWarrantyReports') EQUIP ON                              "
	cQrCan +=   " PIN = VV1_CHASSI                                                                                       "
	cQrCan +=   " WHERE                                                                                                  "
	cQrCan +=   " VV1.D_E_L_E_T_<>'*'                                                                                    "
	cQrCan +=   " AND VV1_FILIAL='0104'                                                                                  "
	cQrCan +=   " AND VV1_MODVEI IN ('CH570','CH670','CH950')                                                            "
	cQrCan +=   " AND right(serialNumber,4) in ('2904','8810','8811')                                                    "
	cQrCan +=   " AND VV1_DATVEN BETWEEN DATEADD(DAY, "+str(periodo)+", GETDATE()) AND GETDATE()                         "
//
	ConsultaTec(cQrCan,STR_ACANEAD)
Return
//
Static Function B02ActiveYeld()
	cQrAcY :=   " SELECT DISTINCT                                                                                            "
	cQrAcY +=   " VV1_FILIAL FILIAL,VV1_CHAINT CHAINT,VV2_GRUMOD GRUPO,VV2_MODVEI COD_MODELO,VV2_DESMOD DESC_MODELO,         "
	cQrAcY +=   " VV1_CHASSI CHASSI,VV1_FABMOD ANO,VV1_DATVEN DT_VENDA,VV1_FILENT FIL_ENTRADA,VV1_FILSAI FIL_SAIDA,          "
	cQrAcY +=   " VV2_TIPVEI TIPO, VV1.R_E_C_N_O_ RECNO                                                                      "
	cQrAcY +=   " FROM dbo.VV1010 VV1(NOLOCK)                                                                            "
	cQrAcY +=   " JOIN dbo.VV2010 VV2(NOLOCK) ON                                                                         "
	cQrAcY +=   "     VV2.D_E_L_E_T_<> '*' AND VV1_FILIAL=VV2_FILIAL AND VV1_CODMAR = VV2_CODMAR AND VV1_MODVEI = VV2_MODVEI "
	cQrAcY +=   " JOIN OPENQUERY(RPA, 'SELECT * FROM tb_EquipmentWarrantyReports') EQUIP ON                                  "
	cQrAcY +=   " 	 PIN = VV1_CHASSI                                                                                        "
	cQrAcY +=   " WHERE VV1.D_E_L_E_T_ <> '*'                                                                                "
	cQrAcY +=   " AND VV1_FILIAL='0104'                                                                                      "
	cQrAcY +=   " AND (VV1_MODVEI LIKE '%S660%' OR VV1_MODVEI LIKE '%S670%' OR VV1_MODVEI LIKE '%S680%'                      "
	cQrAcY +=   " OR VV1_MODVEI LIKE '%S690%' OR VV1_MODVEI LIKE '%S760%' OR VV1_MODVEI LIKE '%S770%'                        "
	cQrAcY +=   " OR VV1_MODVEI LIKE '%S780%' OR VV1_MODVEI LIKE '%S790%' )                                                  "
	cQrAcY +=   " and	right(serialNumber,4) in ('1172', '1971')                                                            "
	cQrAcY +=   " AND VV1_DATVEN BETWEEN DATEADD(DAY, "+str(periodo)+", GETDATE()) AND GETDATE()                             "
//
	ConsultaTec(cQrAcY,STR_AACTYEL)
Return
//
Static Function B03CombineAdvi()
	cQrCom :=   " SELECT DISTINCT  		                                                                                 "
	cQrCom +=   " VV1_FILIAL FILIAL,VV1_CHAINT CHAINT,VV2_GRUMOD GRUPO,VV2_MODVEI COD_MODELO,VV2_DESMOD DESC_MODELO,     "
	cQrCom +=   " VV1_CHASSI CHASSI,VV1_FABMOD ANO,VV1_DATVEN DT_VENDA,VV1_FILENT FIL_ENTRADA,VV1_FILSAI FIL_SAIDA,      "
	cQrCom +=   " VV2_TIPVEI TIPO, VV1.R_E_C_N_O_ RECNO                                                                  "
	cQrCom +=   " FROM dbo.VV1010 VV1(NOLOCK)                                                                        "
	cQrCom +=   " JOIN dbo.VV2010 VV2(NOLOCK) ON                                                                     "
	cQrCom +=   " VV2.D_E_L_E_T_<> '*' AND VV1_FILIAL=VV2_FILIAL AND VV1_CODMAR = VV2_CODMAR AND VV1_MODVEI = VV2_MODVEI "
	cQrCom +=   " JOIN OPENQUERY(RPA, 'SELECT * FROM tb_EquipmentWarrantyReports') EQUIP ON                              "
	cQrCom +=   " PIN = VV1_CHASSI                                                                                       "
	cQrCom +=   " WHERE                                                                                                  "
	cQrCom +=   " VV1.D_E_L_E_T_<>'*'                                                                                    "
	cQrCom +=   " AND VV1_FILIAL='0104'                                                                                  "
	cQrCom +=   " AND VV1_MODVEI IN ('S760', 'S770', 'S780', 'S790') AND                                                 "
	cQrCom +=   " right(serialNumber,4) IN ('1743','1963')                                                               "
	cQrCom +=   "  AND VV1_DATVEN BETWEEN DATEADD(DAY, "+str(periodo)+", GETDATE()) AND GETDATE()                        "
//
	ConsultaTec(cQrCom,STR_ACOMBAD)
Return
//
Static Function B04ExactApply()
	cQrExA :=   " SELECT DISTINCT                                                                                                                      "
	cQrExA +=   " VV1_FILIAL FILIAL,VV1_CHAINT CHAINT,VV2_GRUMOD GRUPO,VV2_MODVEI COD_MODELO,VV2_DESMOD DESC_MODELO,                                   "
	cQrExA +=   " VV1_CHASSI CHASSI,VV1_FABMOD ANO,VV1_DATVEN DT_VENDA,VV1_FILENT FIL_ENTRADA,VV1_FILSAI FIL_SAIDA,                                    "
	cQrExA +=   " VV2_TIPVEI TIPO, VV1.R_E_C_N_O_ RECNO                                                                                                "
	cQrExA +=   " FROM dbo.VV1010 VV1(NOLOCK)                                                                                                      "
	cQrExA +=   " JOIN dbo.VV2010 VV2(NOLOCK) ON                                                                                                   "
	cQrExA +=   " VV2.D_E_L_E_T_<> '*' AND VV1_FILIAL=VV2_FILIAL AND VV1_CODMAR = VV2_CODMAR AND VV1_MODVEI = VV2_MODVEI                               "
	cQrExA +=   " JOIN OPENQUERY(RPA, 'SELECT * FROM tb_EquipmentWarrantyReports') EQUIP ON                                                            "
	cQrExA +=   " PIN = VV1_CHASSI                                                                                                                     "
	cQrExA +=   " WHERE                                                                                                                                "
	cQrExA +=   " VV1.D_E_L_E_T_<>'*'                                                                                                                  "
	cQrExA +=   " AND VV1_FILIAL='0104'                                                                                                                "
	cQrExA +=   " AND (VV1_MODVEI LIKE '%M4025%' OR VV1_MODVEI LIKE '%M4030%' OR VV1_MODVEI LIKE '%M4040%')                                            "
	cQrExA +=   " and right(serialNumber,4) IN ('4985','5103', '5108', '5105', '5109', '5122', '5127',  '5164', '5169', '5124', '5129', '5161', '5166')"
	cQrExA +=   "   AND VV1_DATVEN BETWEEN DATEADD(DAY, "+str(periodo)+", GETDATE()) AND GETDATE()                                                     "
//
	ConsultaTec(cQrExA,STR_AEXACAP)
Return
//
Static Function B05IncPro()
	cQrInP :=   " SELECT DISTINCT                                                                                                              "
	cQrInP +=   " VV1_FILIAL FILIAL,VV1_CHAINT CHAINT,VV2_GRUMOD GRUPO,VV2_MODVEI COD_MODELO,VV2_DESMOD DESC_MODELO,                           "
	cQrInP +=   " VV1_CHASSI CHASSI,VV1_FABMOD ANO,VV1_DATVEN DT_VENDA,VV1_FILENT FIL_ENTRADA,VV1_FILSAI FIL_SAIDA,                            "
	cQrInP +=   " VV2_TIPVEI TIPO, VV1.R_E_C_N_O_ RECNO                                                                                        "
	cQrInP +=   " FROM dbo.VV1010 VV1(NOLOCK)                                                                                              "
	cQrInP +=   " JOIN dbo.VV2010 VV2(NOLOCK) ON                                                                                           "
	cQrInP +=   " VV2.D_E_L_E_T_<> '*' AND VV1_FILIAL=VV2_FILIAL AND VV1_CODMAR = VV2_CODMAR AND VV1_MODVEI = VV2_MODVEI                       "
	cQrInP +=   " JOIN OPENQUERY(RPA, 'SELECT * FROM tb_EquipmentWarrantyReports') EQUIP ON                                                    "
	cQrInP +=   " PIN = VV1_CHASSI                                                                                                             "
	cQrInP +=   " WHERE                                                                                                                        "
	cQrInP +=   " VV1.D_E_L_E_T_ <> '*'                                                                                                        "
	cQrInP +=   " AND VV1_FILIAL='0104'                                                                                                        "
	cQrInP +=   " AND (VV1_MODVEI LIKE '%M4030%' OR VV1_MODVEI LIKE '%M4040%')                                                                 "
	cQrInP +=   " AND	right(serialNumber,4) IN ('4983', '5111','5132','5133','5134','5171','5172')                                           "
	cQrInP +=   " AND VV1_DATVEN BETWEEN DATEADD(DAY, "+str(periodo)+", GETDATE()) AND GETDATE()                                               "
//
	ConsultaTec(cQrInP,STR_AINCPRO)
Return
//
Static Function B06RER()
	cQrReR :=   " SELECT DISTINCT                                                                                                              "
	cQrReR +=   " VV1_FILIAL FILIAL,VV1_CHAINT CHAINT,VV2_GRUMOD GRUPO,VV2_MODVEI COD_MODELO,VV2_DESMOD DESC_MODELO,                           "
	cQrReR +=   " VV1_CHASSI CHASSI,VV1_FABMOD ANO,VV1_DATVEN DT_VENDA,VV1_FILENT FIL_ENTRADA,VV1_FILSAI FIL_SAIDA,                            "
	cQrReR +=   " VV2_TIPVEI TIPO, VV1.R_E_C_N_O_ RECNO                                                                                        "
	cQrReR +=   " FROM dbo.VV1010 VV1(NOLOCK)                                                                                              "
	cQrReR +=   " JOIN dbo.VV2010 VV2(NOLOCK) ON                                                                                           "
	cQrReR +=   " VV2.D_E_L_E_T_<> '*' AND VV1_FILIAL=VV2_FILIAL AND VV1_CODMAR = VV2_CODMAR AND VV1_MODVEI = VV2_MODVEI                       "
	cQrReR +=   " JOIN OPENQUERY(RPA, 'SELECT * FROM tb_EquipmentWarrantyReports') EQUIP ON                                                    "
	cQrReR +=   " PIN = VV1_CHASSI                                                                                                             "
	cQrReR +=   " WHERE                                                                                                                        "
	cQrReR +=   " VV1.D_E_L_E_T_ <> '*'                                                                                                        "
	cQrReR +=   " AND VV1_FILIAL='0104'                                                                                                        "
	cQrReR +=   " AND (VV1_MODVEI LIKE '%M4030%' OR VV1_MODVEI LIKE '%M4040%')                                                                 "
	cQrReR +=   " AND	(right(serialNumber,4) = '4215')                                                                                       "
	cQrReR +=   " AND VV1_DATVEN BETWEEN DATEADD(DAY, "+str(periodo)+", GETDATE()) AND GETDATE()                                               "
//
	ConsultaTec(cQrReR,STR_ARER)
Return
//
Static Function B07SeedStar()
	cQrSee :=   " SELECT DISTINCT                                                                                                                          "
	cQrSee +=   " VV1_FILIAL FILIAL,VV1_CHAINT CHAINT,VV2_GRUMOD GRUPO,VV2_MODVEI COD_MODELO,VV2_DESMOD DESC_MODELO,                                       "
	cQrSee +=   " VV1_CHASSI CHASSI,VV1_FABMOD ANO,VV1_DATVEN DT_VENDA,VV1_FILENT FIL_ENTRADA,VV1_FILSAI FIL_SAIDA,                                        "
	cQrSee +=   " VV2_TIPVEI TIPO, VV1.R_E_C_N_O_ RECNO                                                                                                    "
	cQrSee +=   " FROM dbo.VV1010 VV1(NOLOCK)                                                                                                          "
	cQrSee +=   " JOIN dbo.VV2010 VV2(NOLOCK) ON                                                                                                       "
	cQrSee +=   " VV2.D_E_L_E_T_<> '*' AND VV1_FILIAL=VV2_FILIAL AND VV1_CODMAR = VV2_CODMAR AND VV1_MODVEI = VV2_MODVEI                                   "
	cQrSee +=   " JOIN OPENQUERY(RPA, 'SELECT * FROM tb_EquipmentWarrantyReports') EQUIP ON                                                                "
	cQrSee +=   " PIN = VV1_CHASSI                                                                                                                         "
	cQrSee +=   " WHERE                                                                                                                                    "
	cQrSee +=   " VV1.D_E_L_E_T_ <> '*'                                                                                                                    "
	cQrSee +=   " AND VV1_FILIAL='0104'                                                                                                                    "
	cQrSee +=   " AND (VV1_MODVEI LIKE '%1107%' OR VV1_MODVEI LIKE '%1109%' OR VV1_MODVEI LIKE '%1111%'                                                    "
	cQrSee +=   " OR VV1_MODVEI LIKE '%1113%' OR VV1_MODVEI LIKE '%2113%' OR VV1_MODVEI LIKE '%2115%'                                                      "
	cQrSee +=   " OR VV1_MODVEI LIKE '%2117%' OR VV1_MODVEI LIKE '%2122%' OR VV1_MODVEI LIKE '%2126%'                                                      "
	cQrSee +=   " OR VV1_MODVEI LIKE '%2130%' OR VV1_MODVEI LIKE '%2134%')                                                                                 "
	cQrSee +=   " and	(right(serialNumber,4) in ('6030','6037','0513','0514','0515') or (right(serialNumber,4) in ('3270') and VV1_DATVEN < '20200101')) "
	cQrSee +=   " AND VV1_DATVEN BETWEEN DATEADD(DAY, "+str(periodo)+", GETDATE()) AND GETDATE()                                                           "
//
	ConsultaTec(cQrSee,STR_ASEEDST)
Return
//
Static Function B08RowCommand()
	cQrRoC :=   " SELECT DISTINCT                                                                                        "
	cQrRoC +=   " VV1_FILIAL FILIAL,VV1_CHAINT CHAINT,VV2_GRUMOD GRUPO,VV2_MODVEI COD_MODELO,VV2_DESMOD DESC_MODELO,     "
	cQrRoC +=   " VV1_CHASSI CHASSI,VV1_FABMOD ANO,VV1_DATVEN DT_VENDA,VV1_FILENT FIL_ENTRADA,VV1_FILSAI FIL_SAIDA,      "
	cQrRoC +=   " VV2_TIPVEI TIPO, VV1.R_E_C_N_O_ RECNO                                                                  "
	cQrRoC +=   " FROM dbo.VV1010 VV1(NOLOCK)                                                                        "
	cQrRoC +=   " JOIN dbo.VV2010 VV2(NOLOCK) ON                                                                     "
	cQrRoC +=   " VV2.D_E_L_E_T_<> '*' AND VV1_FILIAL=VV2_FILIAL AND VV1_CODMAR = VV2_CODMAR AND VV1_MODVEI = VV2_MODVEI "
	cQrRoC +=   " JOIN OPENQUERY(RPA, 'SELECT * FROM tb_EquipmentWarrantyReports') EQUIP ON                              "
	cQrRoC +=   " PIN = VV1_CHASSI                                                                                       "
	cQrRoC +=   " WHERE                                                                                                  "
	cQrRoC +=   " VV1.D_E_L_E_T_ <> '*'                                                                                  "
	cQrRoC +=   " AND VV1_FILIAL='0104'                                                                                  "
	cQrRoC +=   " AND (VV1_MODVEI LIKE '%1107%' OR VV1_MODVEI LIKE '%1109%' OR VV1_MODVEI LIKE '%1111%'                  "
	cQrRoC +=   " OR VV1_MODVEI LIKE '%1113%' OR VV1_MODVEI LIKE '%2113%' OR VV1_MODVEI LIKE '%2115%'                    "
	cQrRoC +=   " OR VV1_MODVEI LIKE '%2117%' OR VV1_MODVEI LIKE '%2122%' OR VV1_MODVEI LIKE '%2126%'                    "
	cQrRoC +=   " OR VV1_MODVEI LIKE '%2130%' OR VV1_MODVEI LIKE '%2134%')                                               "
	cQrRoC +=   " and	(right(serialNumber,4) in ('3212','3211','0514','0515') OR                                       "
	cQrRoC +=   " (right(serialNumber,4) = '3270' and VV1_DATVEN >= '20200101'))	                                     "
	cQrRoC +=   " AND VV1_DATVEN BETWEEN DATEADD(DAY, "+str(periodo)+", GETDATE()) AND GETDATE()                         "
//
	ConsultaTec(cQrRoC,STR_AROWCOM)
Return
//
Static Function B09VRD()
	cQrVRD :=   " SELECT DISTINCT                                                                                        "
	cQrVRD +=   " VV1_FILIAL FILIAL,VV1_CHAINT CHAINT,VV2_GRUMOD GRUPO,VV2_MODVEI COD_MODELO,VV2_DESMOD DESC_MODELO,     "
	cQrVRD +=   " VV1_CHASSI CHASSI,VV1_FABMOD ANO,VV1_DATVEN DT_VENDA,VV1_FILENT FIL_ENTRADA,VV1_FILSAI FIL_SAIDA,      "
	cQrVRD +=   " VV2_TIPVEI TIPO, VV1.R_E_C_N_O_ RECNO                                                                  "
	cQrVRD +=   " FROM dbo.VV1010 VV1(NOLOCK)                                                                        "
	cQrVRD +=   " JOIN dbo.VV2010 VV2(NOLOCK) ON                                                                     "
	cQrVRD +=   " VV2.D_E_L_E_T_<> '*' AND VV1_FILIAL=VV2_FILIAL AND VV1_CODMAR = VV2_CODMAR AND VV1_MODVEI = VV2_MODVEI "
	cQrVRD +=   " JOIN OPENQUERY(RPA, 'SELECT * FROM tb_EquipmentWarrantyReports') EQUIP ON                              "
	cQrVRD +=   " PIN = VV1_CHASSI                                                                                       "
	cQrVRD +=   " WHERE                                                                                                  "
	cQrVRD +=   " VV1.D_E_L_E_T_ <> '*'                                                                                  "
	cQrVRD +=   " AND VV1_FILIAL='0104'                                                                                  "
	cQrVRD +=   " AND (VV1_MODVEI LIKE '%2113%' OR VV1_MODVEI LIKE '%2115%' OR VV1_MODVEI LIKE '%2117%'                  "
	cQrVRD +=   " OR VV1_MODVEI LIKE '%2122%' OR VV1_MODVEI LIKE '%2126%' OR VV1_MODVEI LIKE '%2130%'                    "
	cQrVRD +=   " OR VV1_MODVEI LIKE '%2134%') and (                                                                     "
	cQrVRD +=   " (right(serialNumber,4) = '3205' and VV1_DATVEN >= '20200101') or                                       "
	cQrVRD +=   " (right(serialNumber,4) = '3270' and VV1_DATVEN <= '20200101') or                                       "
	cQrVRD +=   " right(serialNumber,4) = '0515')                                                                        "
	cQrVRD +=   " AND VV1_DATVEN BETWEEN DATEADD(DAY, "+str(periodo)+", GETDATE()) AND GETDATE()"
//
	ConsultaTec(cQrVRD,STR_AVRD)
Return
//
Static Function B10Coulter()
	cQrClt :=   " SELECT DISTINCT                                                                                        "
	cQrClt +=   " VV1_FILIAL FILIAL,VV1_CHAINT CHAINT,VV2_GRUMOD GRUPO,VV2_MODVEI COD_MODELO,VV2_DESMOD DESC_MODELO,     "
	cQrClt +=   " VV1_CHASSI CHASSI,VV1_FABMOD ANO,VV1_DATVEN DT_VENDA,VV1_FILENT FIL_ENTRADA,VV1_FILSAI FIL_SAIDA,      "
	cQrClt +=   " VV2_TIPVEI TIPO, VV1.R_E_C_N_O_ RECNO                                                                  "
	cQrClt +=   " FROM dbo.VV1010 VV1(NOLOCK)                                                                        "
	cQrClt +=   " JOIN dbo.VV2010 VV2(NOLOCK) ON                                                                     "
	cQrClt +=   " VV2.D_E_L_E_T_<> '*' AND VV1_FILIAL=VV2_FILIAL AND VV1_CODMAR = VV2_CODMAR AND VV1_MODVEI = VV2_MODVEI "
	cQrClt +=   " JOIN OPENQUERY(RPA, 'SELECT * FROM tb_EquipmentWarrantyReports') EQUIP ON                              "
	cQrClt +=   " PIN = VV1_CHASSI                                                                                       "
	cQrClt +=   " WHERE                                                                                                  "
	cQrClt +=   " VV1.D_E_L_E_T_ <> '*'                                                                                  "
	cQrClt +=   " AND VV1_FILIAL='0104'                                                                                  "
	cQrClt +=   " AND (VV1_MODVEI LIKE '%2113%' OR VV1_MODVEI LIKE '%2115%' OR VV1_MODVEI LIKE '%2117%'                  "
	cQrClt +=   " OR VV1_MODVEI LIKE '%2122%' OR VV1_MODVEI LIKE '%2126%' OR VV1_MODVEI LIKE '%2130%'                    "
	cQrClt +=   " OR VV1_MODVEI LIKE '%2134%' OR VV1_MODVEI LIKE '%DB40%' OR VV1_MODVEI LIKE '%DB50%'                    "
	cQrClt +=   " OR VV1_MODVEI LIKE '%DB74%' OR VV1_MODVEI LIKE '%DB90%')                                               "
	cQrClt +=   " and right(serialNumber,4) IN ('6441' ,'6442')                                                          "
	cQrClt +=   " AND VV1_DATVEN BETWEEN DATEADD(DAY, "+str(periodo)+", GETDATE()) AND GETDATE()                         "
//
	ConsultaTec(cQrClt,STR_ACLTER)
Return
//
Static Function B11EEmerge()
	cQrEEm :=   " SELECT DISTINCT	                                                                                        "
	cQrEEm +=   " VV1_FILIAL FILIAL,VV1_CHAINT CHAINT,VV2_GRUMOD GRUPO,VV2_MODVEI COD_MODELO,VV2_DESMOD DESC_MODELO,        "
	cQrEEm +=   " VV1_CHASSI CHASSI,VV1_FABMOD ANO,VV1_DATVEN DT_VENDA,VV1_FILENT FIL_ENTRADA,VV1_FILSAI FIL_SAIDA,         "
	cQrEEm +=   " VV2_TIPVEI TIPO,VV1_DATINC DATINC, VV1.R_E_C_N_O_ RECNO                                                   "
	cQrEEm +=   " FROM dbo.VV1010 VV1(NOLOCK)                                                                           "
	cQrEEm +=   " JOIN dbo.VV2010 VV2(NOLOCK) ON                                                                        "
	cQrEEm +=   " VV2.D_E_L_E_T_<> '*' AND VV1_FILIAL=VV2_FILIAL AND VV1_CODMAR = VV2_CODMAR AND VV1_MODVEI = VV2_MODVEI    "
	cQrEEm +=   " JOIN OPENQUERY(RPA, 'SELECT * FROM tb_EquipmentWarrantyReports') EQUIP ON                                 "
	cQrEEm +=   " PIN = VV1_CHASSI                                                                                          "
	cQrEEm +=   " WHERE                                                                                                     "
	cQrEEm +=   " VV1.D_E_L_E_T_<>'*'                                                                                       "
	cQrEEm +=   " AND VV1_FILIAL='0104'                                                                                     "
	cQrEEm +=   " AND (VV1_MODVEI LIKE '%DB40%' OR VV1_MODVEI LIKE '%DB50%' OR VV1_MODVEI LIKE '%DB74%'  )	                "
	cQrEEm +=   " AND RIGHT(serialNumber,4) IN ('4628')                                                                     "
	cQrEEm +=   " AND VV1_DATVEN BETWEEN DATEADD(DAY, "+str(periodo)+", GETDATE()) AND GETDATE()                            "
//
	ConsultaTec(cQrEEm,STR_AEEMERG)
Return
//
Static Function B12MaxEmerg()
	cQrMaE :=   " SELECT DISTINCT	                                                                                        "
	cQrMaE +=   " VV1_FILIAL FILIAL,VV1_CHAINT CHAINT,VV2_GRUMOD GRUPO,VV2_MODVEI COD_MODELO,VV2_DESMOD DESC_MODELO,        "
	cQrMaE +=   " VV1_CHASSI CHASSI,VV1_FABMOD ANO,VV1_DATVEN DT_VENDA,VV1_FILENT FIL_ENTRADA,VV1_FILSAI FIL_SAIDA,         "
	cQrMaE +=   " VV2_TIPVEI TIPO,VV1_DATINC DATINC, VV1.R_E_C_N_O_ RECNO                                                   "
	cQrMaE +=   " FROM dbo.VV1010 VV1(NOLOCK)                                                                           "
	cQrMaE +=   " JOIN dbo.VV2010 VV2(NOLOCK) ON                                                                        "
	cQrMaE +=   " VV2.D_E_L_E_T_<> '*' AND VV1_FILIAL=VV2_FILIAL AND VV1_CODMAR = VV2_CODMAR AND VV1_MODVEI = VV2_MODVEI    "
	cQrMaE +=   " JOIN OPENQUERY(RPA, 'SELECT * FROM tb_EquipmentWarrantyReports') EQUIP ON                                 "
	cQrMaE +=   " PIN = VV1_CHASSI                                                                                          "
	cQrMaE +=   " WHERE                                                                                                     "
	cQrMaE +=   " VV1.D_E_L_E_T_ <> '*'                                                                                     "
	cQrMaE +=   " AND VV1_FILIAL='0104'                                                                                     "
	cQrMaE +=   " AND (VV1_MODVEI LIKE '%DB40%' OR VV1_MODVEI LIKE '%DB50%'                                                 "
	cQrMaE +=   " OR VV1_MODVEI LIKE '%DB74%' OR VV1_MODVEI LIKE '%DB90%')                                                  "
	cQrMaE +=   " and right(serialNumber,4) IN ('4630')                                                                     "
	cQrMaE +=   " AND VV1_DATVEN BETWEEN DATEADD(DAY, "+str(periodo)+", GETDATE()) AND GETDATE()                            "
//
	ConsultaTec(cQrMaE,STR_AMAXEME)
Return
//
Static Function B13APDF()
	cQrAPD :=   " SELECT DISTINCT	                                                                                        "
	cQrAPD +=   " VV1_FILIAL FILIAL,VV1_CHAINT CHAINT,VV2_GRUMOD GRUPO,VV2_MODVEI COD_MODELO,VV2_DESMOD DESC_MODELO,        "
	cQrAPD +=   " VV1_CHASSI CHASSI,VV1_FABMOD ANO,VV1_DATVEN DT_VENDA,VV1_FILENT FIL_ENTRADA,VV1_FILSAI FIL_SAIDA,         "
	cQrAPD +=   " VV2_TIPVEI TIPO,VV1_DATINC DATINC, VV1.R_E_C_N_O_ RECNO                                                   "
	cQrAPD +=   " FROM dbo.VV1010 VV1(NOLOCK)                                                                           "
	cQrAPD +=   " JOIN dbo.VV2010 VV2(NOLOCK) ON                                                                        "
	cQrAPD +=   " VV2.D_E_L_E_T_<> '*' AND VV1_FILIAL=VV2_FILIAL AND VV1_CODMAR = VV2_CODMAR AND VV1_MODVEI = VV2_MODVEI    "
	cQrAPD +=   " JOIN OPENQUERY(RPA, 'SELECT * FROM tb_EquipmentWarrantyReports') EQUIP ON                                 "
	cQrAPD +=   " PIN = VV1_CHASSI                                                                                          "
	cQrAPD +=   " WHERE                                                                                                     "
	cQrAPD +=   " VV1.D_E_L_E_T_ <> '*'                                                                                     "
	cQrAPD +=   " AND VV1_FILIAL='0104'                                                                                     "
	cQrAPD +=   " AND (VV1_MODVEI LIKE '%DB40%' OR VV1_MODVEI LIKE '%DB50%'                                                 "
	cQrAPD +=   " OR VV1_MODVEI LIKE '%DB74%' OR VV1_MODVEI LIKE '%DB90%')                                                  "
	cQrAPD +=   " and right(serialNumber,4) IN ('5635', '5645')                                                             "
	cQrAPD +=   " AND VV1_DATVEN BETWEEN DATEADD(DAY, "+str(periodo)+", GETDATE()) AND GETDATE()                            "
//
	ConsultaTec(cQrAPD,STR_AAPDF)
Return
//
Static Function ConsultaTec(strquery,strTecnologia)
	//Preparando Query
	MPSysOpenQuery( strquery, strTecnologia)
	//Executando Query
	DbSelectArea(strTecnologia)
Return
//
Static Function AtualizaTec(nRecno,ctecnologia)
	BEGIN TRANSACTION
		DbSelectArea("VV1")
		DbGoTo(nRecno)
		RecLock("VV1",.F.)
		If RecLock("VV1",.F.)
			Do Case
			Case ctecnologia == STR_CaneAdvisor
				VV1->VV1_XCANAD := 'S'
			Case ctecnologia == STR_ActiveYeld
				VV1->VV1_XATYEL := 'S'
			Case ctecnologia == STR_CombineAdvi
				VV1->VV1_XCOADV := 'S'
			Case ctecnologia == STR_ExactApply
				VV1->VV1_XEXAAP := 'S'
			Case ctecnologia == STR_IncPro
				VV1->VV1_XINPRO := 'S'
			Case ctecnologia == STR_RER
				VV1->VV1_XRR := 'S'
			Case ctecnologia == STR_SeedStar
				VV1->VV1_XSEDST := 'S'
			Case ctecnologia == STR_RowCommand
				VV1->VV1_XROCOM := 'S'
			Case ctecnologia == STR_VRD
				VV1->VV1_XVRD := 'S'
			Case ctecnologia == STR_Clter
				VV1->VV1_XCOUHP := 'S'
			Case ctecnologia == STR_EEmerge
				VV1->VV1_XEXMER := 'S'
			Case ctecnologia == STR_MaxEmerg
				VV1->VV1_XMAXEM := 'S'
			Case ctecnologia == STR_APDF
				VV1->VV1_XAPDF := 'S'
			EndCase
			VV1->(MsUnlock())
			VV1->(DBCLOSEAREA())
		Else
			AZBL010 := {}
			AADD(AZBL010,'VV1')
			AADD(AZBL010,'WSATUTEC')
			AADD(AZBL010,STR_TITULO+' - Processa')
			AADD(AZBL010,'Registro nao atualizado: '+AllTrim(STR(nRecno)))
			GravaLog(AZBL010)
		EndIf
	END TRANSACTION
Return
//
Static Function GravaLog(_AZBL010)

	if chavef == ''
		cQuery := " SELECT CONVERT(INT, ZBL_KEY)+1 FROM dbo.ZBL010(NOLOCK) "
		cQuery += " WHERE R_E_C_N_O_ IN "
		cQuery += " (SELECT MAX(R_E_C_N_O_) FROM dbo.ZBL010(NOLOCK) "
		cQuery += " WHERE D_E_L_E_T_ <> '*' AND ZBL_TABELA = 'VV1' AND ZBL_USUSIS = 'WSATUTEC') "

		chave:= FM_SQL(cQuery)
		chavef = Alltrim(StrZero(chave,6))
	endif

	BEGIN TRANSACTION
		DbSelectArea("ZBL")
		RecLock("ZBL",.T.)
		ZBL->ZBL_FILIAL := ""
		ZBL->ZBL_TABELA := _AZBL010[1]
		ZBL->ZBL_KEY    := chavef
		ZBL->ZBL_USUSIS := _AZBL010[2]
		ZBL->ZBL_CONTEU := _AZBL010[3]
		ZBL->ZBL_DTREGI := Date()
		ZBL->ZBL_TIPO   :='ALT'
		ZBL->ZBL_IDKEY  := _AZBL010[4]
		ZBL->ZBL_CONTE2 := ''
		ZBL->ZBL_HORA   := Time()
		ZBL->(MsUnlock())
		ZBL->(DBCLOSEAREA())
	END TRANSACTION
Return
