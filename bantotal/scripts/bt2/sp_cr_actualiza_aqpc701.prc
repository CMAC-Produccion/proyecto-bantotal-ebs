CREATE OR REPLACE PROCEDURE SP_CR_ACTUALIZA_AQPC701(
XPgcod IN NUMBER,
XScsuc IN NUMBER,
XScmod IN NUMBER,
XScmda IN NUMBER,
XScpap IN NUMBER,
XSccta IN NUMBER,
XScoper IN NUMBER,
XScsbop IN NUMBER,
XSctope IN NUMBER,
XMora IN NUMBER,
XICV IN NUMBER,
XPenalidad IN NUMBER)
AS
BEGIN
  UPDATE AQPC701 SET aqpc701mor = XMora, aqpc701icv = XICV, aqpc701pen = XPenalidad WHERE
  aqpc701emp = XPgcod AND 
  aqpc701suc = XScsuc AND 
  aqpc701mod = XScmod AND
  aqpc701mda = XScmda AND 
  aqpc701pap = XScpap AND
  aqpc701cta = XSccta AND
  aqpc701ope = XScoper AND
  aqpc701sbo = XScsbop AND
  aqpc701top = XSctope;
  commit;
EXCEPTION
  WHEN OTHERS THEN NULL;
END SP_CR_ACTUALIZA_AQPC701;
/

