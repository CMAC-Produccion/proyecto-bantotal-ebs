create or replace procedure sp_ah_saldisp_fecha(P_N_PGCOD  IN NUMBER,
                                                P_N_SCSUC  IN NUMBER,
                                                P_N_SCMDA  IN NUMBER,
                                                P_N_SCPAP  IN NUMBER,
                                                P_N_SCCTA  IN NUMBER,
                                                P_N_SCOPER  IN NUMBER,
                                                P_N_SCSBOP IN NUMBER,
                                                P_N_SCTOPE IN NUMBER,
                                                P_D_FECPRO IN DATE,
                                                p_n_saldis out number
                                               ) is
  cursor c_fst198 is
   Select * from  fst198
    Where Tp1cod   = P_N_PGCOD
      and Tp1cod1  = 10822
      and Tp1corr1 = 2
      and Tp1corr2 = 3
      and Tp1nro3  = P_N_SCTOPE;
      
  cursor c_fst198_2 is
   Select * from  fst198
    Where Tp1cod   = P_N_PGCOD
      and Tp1cod1  = 10822
      and Tp1corr1 = 2
      and Tp1corr2 = 3
      and Tp1nro3  = 0;               
      
  Cursor c_fsh012(Tp1nro1 in number) is
    Select * from  FSH012
    Where BCEmp  = P_N_PGCOD
      and BCMod  = Tp1nro1        
      and BCMda  = P_N_SCMDA
      and BCPap  = P_N_SCPAP
      and BCCta  = P_N_SCCTA
      and BCSuc  = P_N_SCSUC
      and BCSbOp = P_N_SCSBOP   
      and BCFech = P_D_FECPRO;    
      
  cursor c_offline is
    Select * from jaql736
    Where JAQL736PGC = P_N_PGCOD
      and JAQL736SUC = P_N_SCSUC
      and JAQL736MDA = P_N_SCMDA
      and JAQL736PAP = P_N_SCPAP
      and JAQL736SCT = P_N_SCCTA
      and JAQL736SBO = P_N_SCSBOP
      and JAQL736OPE = P_N_SCOPER
      and JAQL736TOP = P_N_SCTOPE
      and JAQL736EST = 'ZZ';    
                                                       
    SdoDisp  number(18,2):= 0;
    AcumRes  number(18,2):= 0;
    AcumSum  number(18,2):= 0;
    AcumRes2 number(18,2):= 0;
    AcumSum2 number(18,2):= 0;
    Saldo_P  number(18,2):= 0;
    Scmod_SD number(18,2):= 0;  
    Saldo_M  number(18,2):= 0; 
    ImpmovD  number(18,2):= 0; 
    ImpmovR  number(18,2):= 0;   
    Cont     number(9):=0;                           
begin
    AcumRes := 0;
    AcumSum := 0;
    AcumRes2 := 0;
    AcumSum2 := 0;

    Saldo_P := 0;

    For i in c_fst198 loop
        Cont := cont  + 1;
        Scmod_SD := i.Tp1nro1;
        Saldo_M := 0;

          For j in c_fsh012(i.Tp1nro1) loop
            If j.BCSdMO < 0 then
                Saldo_P := (-1)*(j.BCSdMO);
            Else
                Saldo_P := j.BCSdMO;
            End If;

            If (i.Tp1imp1 = 0) Or (j.BCRubr  = i.Tp1imp1) then
                Saldo_M := Saldo_M + Saldo_P;
            End If;

          End loop;

        If i.Tp1imp3 <> 0 then
            If AcumRes < Saldo_M And i.Tp1nro2 = 1 then
                AcumSum := Saldo_M;
            Else
                If AcumRes < Saldo_M And i.Tp1nro2 = 2 then
                    AcumRes := Saldo_M;
                End If;
            End If;
        Else
            If i.Tp1nro2 = 1 then
                AcumSum2 := AcumSum2 + Saldo_M;
            Else
                AcumRes2 := AcumRes2 + Saldo_M;
            End If;
        End If;
    End loop;

    If Cont = 0 then

        For i in c_fst198_2 loop
            Scmod_SD := i.Tp1nro1;
            Saldo_M := 0;

            For j in c_fsh012(i.Tp1nro1) loop

                If j.BCSdMO < 0 then
                    Saldo_P := (-1)*(j.BCSdMO);
                Else
                    Saldo_P := j.BCSdMO;
                End If;
    
                If (i.Tp1imp1 = 0) Or (j.BCRubr  = i.Tp1imp1) then
                    Saldo_M := Saldo_M + Saldo_P;
                End If;
    
            End loop;
    
            If i.Tp1imp3 <> 0 then
                If AcumRes < Saldo_M And i.Tp1nro2 = 1 then
                    AcumSum := Saldo_M;
                Else
                    If AcumRes < Saldo_M And i.Tp1nro2 = 2 then
                        AcumRes := Saldo_M;
                    End If;
                End If;
            Else
                If i.Tp1nro2 = 1 then
                    AcumSum2 := AcumSum2 + Saldo_M;
                Else
                    AcumRes2 := AcumRes2 + Saldo_M;
                End If;
            End If;
        End loop;
    End if;

    SdoDisp := AcumSum + AcumSum2 - AcumRes - AcumRes2;

    For k in c_offline loop   
        If k.JAQL736RET = 0 then
            ImpmovD := k.JAQL736DEP;
            ImpmovR := 0;
        Else
            ImpmovD := 0;
            ImpmovR := k.JAQL736RET;
        End If;
        SdoDisp := SdoDisp + ImpmovD - ImpmovR;      
    End loop;

    If SdoDisp < 0 then
        SdoDisp := 0;
    End If;
  
  p_n_saldis :=  SdoDisp;
end sp_ah_saldisp_fecha;
/

