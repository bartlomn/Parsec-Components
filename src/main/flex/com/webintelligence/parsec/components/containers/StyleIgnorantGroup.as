package com.webintelligence.parsec.components.containers
{

import spark.components.Group;

public class StyleIgnorantGroup 
    extends Group
{
    public function StyleIgnorantGroup()
    {
        super();
    }
    
    private var regenerated:Boolean = false;
    
    override public function regenerateStyleCache(recursive:Boolean):void
    {
        if (regenerated)
            return;
        
        regenerated = true;
        super.regenerateStyleCache(recursive);
    }
    
    override public function notifyStyleChangeInChildren(styleProp:String, recursive:Boolean):void
    {
        if (regenerated)
            return;
        
        super.notifyStyleChangeInChildren(styleProp, recursive);
    }
}
}