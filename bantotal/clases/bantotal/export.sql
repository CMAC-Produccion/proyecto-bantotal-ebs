--------------------------------------------------------
-- Archivo creado  - miércoles-diciembre-28-2011   
--------------------------------------------------------
  DROP TABLE "SNGC70";
--------------------------------------------------------
--  DDL for Table SNGC70
--------------------------------------------------------

  CREATE TABLE "SNGC70" 
   (	"SNGC11PAIS" NUMBER(3,0), 
	"SNGC11TDOC" NUMBER(2,0), 
	"SNGC11NDOC" CHAR(12 BYTE), 
	"SNGC70ATR" CHAR(20 BYTE), 
	"SNGC70VAL" VARCHAR2(40 BYTE)
   ) ;
--------------------------------------------------------
--  DDL for Index SYS_C0069235
--------------------------------------------------------

  CREATE UNIQUE INDEX "SYS_C0069235" ON "SNGC70" ("SNGC11PAIS", "SNGC11TDOC", "SNGC11NDOC", "SNGC70ATR") 
  ;
--------------------------------------------------------
--  Constraints for Table SNGC70
--------------------------------------------------------

  ALTER TABLE "SNGC70" MODIFY ("SNGC11PAIS" NOT NULL ENABLE);
 
  ALTER TABLE "SNGC70" MODIFY ("SNGC11TDOC" NOT NULL ENABLE);
 
  ALTER TABLE "SNGC70" MODIFY ("SNGC11NDOC" NOT NULL ENABLE);
 
  ALTER TABLE "SNGC70" MODIFY ("SNGC70ATR" NOT NULL ENABLE);
 
  ALTER TABLE "SNGC70" ADD PRIMARY KEY ("SNGC11PAIS", "SNGC11TDOC", "SNGC11NDOC", "SNGC70ATR") ENABLE;
