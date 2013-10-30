package com.webintelligence.parsec.components.containers
{
import mx.collections.IList;
import mx.events.CollectionEvent;

import spark.components.DataGroup;

/**
 *  Extension of the Spark DataGroup that resists scrolling when the
 *  dataProvider is refreshed, otherwise the user can scroll to the bottom
 *  of a List, select the last item, and (at least in our ListFilter/ListWithHeaders
 *  that might trigger a dataProvider.refresh() (in client code) which
 *  without this hack, causes the datagroup to scroll vertically to
 *  the top
 * 
 *  Shamelessly borrowed from http://stackoverflow.com/questions/6540915/how-to-keep-a-list-from-scrolling-on-dataprovider-refresh-update-change
 */
public class NoScrollOnDataProviderRefreshDataGroup
    extends DataGroup
{
    public function NoScrollOnDataProviderRefreshDataGroup()
    {
    }

    private var _dataProviderChanged:Boolean;
    private var _lastScrollPosition:Number = 0;
    
    override public function set dataProvider(value:IList):void
    {
        if (this.dataProvider != null && value != this.dataProvider)
        {
            dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onDataProviderChanged);
        }
        super.dataProvider = value;
        
        if (value != null)
        {
            value.addEventListener(CollectionEvent.COLLECTION_CHANGE, onDataProviderChanged);
        }
    }
    
    override protected function commitProperties():void
    {
        var lastScrollPosition:Number = _lastScrollPosition;
        
        super.commitProperties();
        
        if ( _dataProviderChanged )
        {
            verticalScrollPosition = lastScrollPosition;
        }
    }
    
    private function onDataProviderChanged(e:CollectionEvent):void
    {
        _dataProviderChanged = true;
        invalidateProperties();
    }
    
    override public function set verticalScrollPosition(value:Number):void
    {
        super.verticalScrollPosition = value;
        _lastScrollPosition = value;
    }
}
}