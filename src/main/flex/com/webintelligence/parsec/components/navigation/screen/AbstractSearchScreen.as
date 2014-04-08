/**
 * Fortrus Mobius v2.0
 * User: Bart
 * Date: 31/03/2014
 * Time: 18:21
 * Description:
 */

package com.webintelligence.parsec.components.navigation.screen
{
import com.webintelligence.parsec.components.controls.domain.VirtualColumn;
import com.webintelligence.parsec.components.navigation.event.UINavigatorScreenEvent;
import com.webintelligence.parsec.components.navigation.screen.domain.LookupUiState;
import com.webintelligence.parsec.components.navigation.screen.factory.VirtualColumnRendererFactory;
import com.webintelligence.parsec.components.navigation.screen.model.AbstractSearchScreenModel;

import flash.events.Event;
import flash.events.KeyboardEvent;

import mx.core.UIComponent;
import mx.events.FlexEvent;

import spark.components.supportClasses.ListBase;

[Event(name="lookupValueChanged",
      type="com.webintelligence.parsec.components.navigation.event.UINavigatorScreenEvent")]

[SkinState("searchInProgress")]
[SkinState("noResults")]
[SkinState("noSearchCriteria")]
[SkinState("searchResults")]

public class AbstractSearchScreen extends AbstractListScreen
{

   [Bindable][SkinPart(required="true")]
   /**
    *  search input control
    */
   public var searchUIComponent : UIComponent;

   /**
    *  @private
    */
   private var _lookupItem:Object;

   /**
    *  @private
    */
   private var _lookupItemChanged:Boolean;

   [Bindable(event="lookupValueChanged")]
   /**
    *  @private
    */
   public function get lookupItem() : Object
   {
      return _lookupItem;
   }
   /**
    *  @private
    */
   public function set lookupItem( value : Object ) : void
   {
      if( _lookupItem != value )
      {
         log.debug( "Setting lookup item: {0}", value ? value.toString() : null );
         _lookupItem = value;
         _lookupItemChanged = true;
         invalidateProperties();
      }
   }

   /**
    *  Constructor
    */
   public function AbstractSearchScreen( logTarget:Class )
   {
      super( logTarget );
   }


   /**
    *  @inheritDoc
    */
   override protected function commitProperties() : void
   {
      super.commitProperties();
      if( _lookupItemChanged )
      {
         lookupItemChangedHandler();
         dispatchEvent( new UINavigatorScreenEvent( UINavigatorScreenEvent.LOOKUP_VALUE_CHANGED ));
         _lookupItemChanged = false;
      }
   }

   /**
    *  @inheritDoc
    */
   override protected function focusRequestHandler( ...triggers ) : void
   {
      super.focusRequestHandler( triggers );
      if( searchUIComponent )
         searchUIComponent.setFocus();
   }

   /**
    *  @inheritDoc
    */
   override protected function partAdded( partName : String, instance : Object ) : void
   {
      super.partAdded( partName, instance );
      if( instance == searchUIComponent )
      {
         var searchScreenModel:AbstractSearchScreenModel = model as AbstractSearchScreenModel;
         searchUIComponent.addEventListener( KeyboardEvent.KEY_UP, searchUIComponentKeyUpHandler );
         var listBase:ListBase = searchUIComponent as ListBase;
         if( searchScreenModel && listBase )
         {
            listBase.addEventListener( Event.CHANGE, searchComponentValueChangeHandler );
            bindToModelProperty( listBase, "dataProvider", [ "lookupItems" ]);
            bindToModelProperty( listBase, "selectedItem", [ "currentLookupItem" ]);
            if( searchScreenModel.lookupItemRendererFactory )
            {
               listBase.itemRendererFunction = searchScreenModel.lookupItemRendererFactory.itemRendererFunction;

               var columnProvider:VirtualColumnRendererFactory =
                     searchScreenModel.lookupItemRendererFactory as VirtualColumnRendererFactory;
               if( columnProvider  )
               {
                  for each( var vc:VirtualColumn in columnProvider.columns )
                  {
                     // todo: allow for compound labels ( obj.p1 + obj.p2 )
                     if( vc.includeInLabel )
                     {
                        listBase.labelFunction = vc.getLabelText;
                        break;
                     }
                  }
               }
            }
         }
      }
   }

   /**
    *  @inheritDoc
    */
   override protected function partRemoved( partName : String, instance : Object ) : void
   {
      super.partRemoved( partName, instance );
      if( instance == searchUIComponent )
      {
         searchUIComponent.removeEventListener( KeyboardEvent.KEY_UP, searchUIComponentKeyUpHandler );
         searchUIComponent.removeEventListener( Event.CHANGE, searchComponentValueChangeHandler );
      }
   }

   /**
    *  @inheritDoc
    */
   override protected function uiStateChangeHandler() : void
   {
      super.uiStateChangeHandler();
      if( searchUIComponent )
         searchUIComponent.enabled = uiStateName != LookupUiState.SEARCH_IN_PROGRESS;
   }


   /**
    *  @private
    */
   protected function searchUIComponentKeyUpHandler( event:KeyboardEvent ):void
   {
      //      abstract
   }

   /**
    *  @private
    */
   protected function searchComponentValueChangeHandler( event:Event ):void
   {
      //      abstract
   }

   /**
    *  @private
    */
   protected function lookupItemChangedHandler():void
   {
      log.debug( "Lookup item changed: {0}, passing to model.", lookupItem ? lookupItem.toString() : null );
      var m:AbstractSearchScreenModel = model as AbstractSearchScreenModel;
      if( m && m.currentLookupItem != lookupItem)
         m.currentLookupItem = lookupItem;
   }

}
}
