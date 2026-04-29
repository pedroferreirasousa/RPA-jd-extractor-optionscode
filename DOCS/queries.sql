-- =============================================================
-- QUERIES - JD EXTRACTOR / tb_EquipmentOptions
-- Banco: db_Cor_Maqnelson_RPA (PROD) | db_Cor_Maqnelson_RPA_Dev (DEV)
-- =============================================================


-- -------------------------------------------------------------
-- ANÁLISE DE DUPLICATAS
-- -------------------------------------------------------------

-- Contar quantos registros serão deletados (duplicatas)
SELECT
    (SELECT COUNT(*) FROM db_Cor_Maqnelson_RPA.tb_EquipmentOptions)
    -
    (SELECT COUNT(*) FROM (
        SELECT MIN(id_EquipmentOptions)
        FROM db_Cor_Maqnelson_RPA.tb_EquipmentOptions
        GROUP BY pin, code
    ) x) AS serao_deletados;

-- Listar grupos com duplicatas (pin + code repetidos)
SELECT pin, code, COUNT(*) AS total
FROM db_Cor_Maqnelson_RPA.tb_EquipmentOptions
GROUP BY pin, code
HAVING COUNT(*) > 1;


-- -------------------------------------------------------------
-- BACKUP ANTES DE DELETAR DUPLICATAS
-- -------------------------------------------------------------

-- Criar tabela backup em DEV com os registros que serão deletados do PROD
CREATE TABLE db_Cor_Maqnelson_RPA_Dev.tb_EquipmentOptions_backup_duplicatas AS
SELECT t1.*
FROM db_Cor_Maqnelson_RPA.tb_EquipmentOptions t1
WHERE t1.id_EquipmentOptions NOT IN (
    SELECT MIN(id_EquipmentOptions)
    FROM db_Cor_Maqnelson_RPA.tb_EquipmentOptions
    GROUP BY pin, code
);

-- Validar contagem do backup
SELECT COUNT(*) AS total_backup
FROM db_Cor_Maqnelson_RPA_Dev.tb_EquipmentOptions_backup_duplicatas;


-- -------------------------------------------------------------
-- DELETE DE DUPLICATAS (manter o registro com menor id)
-- -------------------------------------------------------------

SET SQL_SAFE_UPDATES = 0;

DELETE FROM db_Cor_Maqnelson_RPA.tb_EquipmentOptions
WHERE id_EquipmentOptions NOT IN (
    SELECT min_id FROM (
        SELECT MIN(id_EquipmentOptions) AS min_id
        FROM db_Cor_Maqnelson_RPA.tb_EquipmentOptions
        GROUP BY pin, code
    ) AS keep
);

SET SQL_SAFE_UPDATES = 1;


-- -------------------------------------------------------------
-- VALIDAÇÃO PÓS-DELETE
-- -------------------------------------------------------------

-- Confirmar que não há mais duplicatas (deve retornar 0 linhas)
SELECT pin, code, COUNT(*) AS total
FROM db_Cor_Maqnelson_RPA.tb_EquipmentOptions
GROUP BY pin, code
HAVING COUNT(*) > 1;

-- Contagem total de registros após limpeza
SELECT COUNT(*) AS total_registros
FROM db_Cor_Maqnelson_RPA.tb_EquipmentOptions;
-- Resultado esperado: 408.279 - 108.816 = 299.463


-- -------------------------------------------------------------
-- MIGRAÇÃO DEV → PROD (inserir registros que não existem em PROD)
-- -------------------------------------------------------------

INSERT INTO db_Cor_Maqnelson_RPA.tb_EquipmentOptions
    (pin, code, description, created_at, created_by,
     deleted_at, deleted_by, created_at_db, updated_at)
SELECT
    pin, code, description, created_at, created_by,
    deleted_at, deleted_by, created_at_db, updated_at
FROM db_Cor_Maqnelson_RPA_Dev.tb_EquipmentOptions dev
WHERE NOT EXISTS (
    SELECT 1
    FROM db_Cor_Maqnelson_RPA.tb_EquipmentOptions prod
    WHERE prod.pin = dev.pin
      AND prod.code = dev.code
);
