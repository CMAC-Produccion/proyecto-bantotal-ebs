create or replace procedure SP_FACULTAD_CTA(vpgcod   number,
                                            vscsuc   number,
                                            vscmda   number,
                                            vscpap   number,
                                            vsccta   number,
                                            vscoper  number,
                                            vscsbop  number,
                                            vsctope  number,
                                            vscmod   number,
                                            facultad out varchar2) is
begin

  facultad := fn_facultad_cta(vpgcod  => vpgcod,
                              vscsuc  => vscsuc,
                              vscmda  => vscmda,
                              vscpap  => vscpap,
                              vsccta  => vsccta,
                              vscoper => vscoper,
                              vscsbop => vscsbop,
                              vsctope => vsctope,
                              vscmod  => vscmod);

end SP_FACULTAD_CTA;
/

