trigger SG_OverridePageEdit on Case (after update){
    List<CaseComment> lcc = new List<CaseComment>();
    for(Case c : trigger.new){
        CaseComment ComentNew = new CaseComment();
        ComentNew.ParentId=c.id;
        ComentNew.CommentBody=c.Internal_Comments__C;
        lcc.add(ComentNew);
    }
    insert lcc;
}