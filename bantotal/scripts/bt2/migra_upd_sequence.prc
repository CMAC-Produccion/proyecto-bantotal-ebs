CREATE OR REPLACE PROCEDURE MIGRA_UPD_SEQUENCE(
seqowner VARCHAR2,
seqname VARCHAR2,
newvalue NUMBER) AS
ln NUMBER;
ib NUMBER;
BEGIN
SELECT last_number, increment_by
INTO ln, ib
FROM dba_sequences
WHERE sequence_owner = upper(seqowner)
AND sequence_name = upper(seqname);
EXECUTE IMMEDIATE 'ALTER SEQUENCE ' || seqowner || '.' || seqname ||
' INCREMENT BY ' || (newvalue - ln);
EXECUTE IMMEDIATE 'SELECT ' || seqowner || '.' || seqname ||
'.NEXTVAL FROM DUAL' INTO ln;
EXECUTE IMMEDIATE 'ALTER SEQUENCE ' || seqowner || '.' || seqname
|| ' INCREMENT BY ' || ib;
END;
/

