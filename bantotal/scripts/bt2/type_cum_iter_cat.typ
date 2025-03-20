CREATE OR REPLACE TYPE "TYPE_CUM_ITER_CAT"                                          as object (

    str_agg varchar2(32000),

    static function odciaggregateinitialize(sctx  in out type_cum_iter_cat)
                    return number,

    member function odciaggregateiterate   (self  in out type_cum_iter_cat, value in varchar2 )
                    return number,

    member function odciaggregateterminate (self in type_cum_iter_cat, return_value out varchar2, flags in number )
                    return number,

    member function odciaggregatemerge(self in out type_cum_iter_cat, ctx2 in type_cum_iter_cat)
                    return number
)
/

CREATE OR REPLACE TYPE BODY "TYPE_CUM_ITER_CAT" is

    static function ODCIAggregateInitialize(sctx in out type_cum_iter_cat)
        return number is
    begin
        sctx := type_cum_iter_cat(null);
        sctx.str_agg := '';
        return ODCIConst.Success;
    end;

    member function ODCIAggregateIterate(self in out type_cum_iter_cat, value in varchar2)
        return number is
    begin

        str_agg := str_agg||value;
        return ODCIConst.Success;
    end;



    member function ODCIAggregateTerminate(self in type_cum_iter_cat, return_value out varchar2, flags in number) return number is
    begin
        return_value := str_agg;
        return ODCIConst.Success;
    end;

    member function ODCIAggregateMerge(self in out type_cum_iter_cat, ctx2 in type_cum_iter_cat) return number is
    begin

        str_agg := str_agg||ctx2.str_agg;

        return ODCIConst.Success;
    End;
end;
/

