/**
 * User: Bart
 * Date: 01/04/2014
 * Time: 13:50
 * Description:
 */

package com.webintelligence.parsec.components.navigation.screen.control
{
import com.webintelligence.parsec.components.navigation.screen.domain.LookupUiState;
import com.webintelligence.parsec.components.navigation.screen.model.AbstractAsyncLookupUiModel;
import com.webintelligence.parsec.components.navigation.screen.model.AbstractDataProviderModel;
import com.webintelligence.parsec.core.navigation.INavigationRequest;

import mx.collections.ArrayCollection;

public class AbstractListScreenController extends AbstractModelDrivenScreenController
{

   /**
    *  @private
    */
   private var _model:AbstractDataProviderModel;

   /**
    *  @private
    */
   protected var autoSelectFromDataProvider:Boolean;


   /**
    *  @private
    */
   private var _selectedItem:Object;

   /**
    *  @private
    */
   private var _selectedItemChanged:Boolean;

   /**
    *  @private
    */
   public function get selectedItem() : Object
   {
      return _selectedItem;
   }
   /**
    *  @private
    */
   public function set selectedItem( value : Object ) : void
   {
      if( value != _selectedItem )
      {
         _log.debug( "Setting selected item: {0}", value );
         _selectedItem = value;
         _selectedItemChanged = true;
         invalidateProperties();
      }
   }

   /**
    *  @private
    */
   private var _dataProvider:ArrayCollection;

   /**
    *  @private
    */
   private var _dataProviderChanged:Boolean;

   /**
    *  @private
    */
   public function get dataProvider() : ArrayCollection
   {
      return _dataProvider;
   }
   /**
    *  @private
    */
   public function set dataProvider( value : ArrayCollection ) : void
   {
      if( _dataProvider !=  value )
      {
         _log.debug( "Setting results." );
         _dataProvider = value;
         _dataProviderChanged = true;
         invalidateProperties();
      }
   }

   /**
    *  @inheritDoc
    */
   override public function set model( value : Object ) : void
   {
      super.model = value;
      _model = model as AbstractDataProviderModel;
   }

   /**
    *  Constructor
    */
   public function AbstractListScreenController( modelInstance:AbstractDataProviderModel = null )
   {
      super( modelInstance );
   }

   /**
    *  @inheritDoc
    */
   override protected function commitProperties() : void
   {
      super.commitProperties();
      if( _dataProviderChanged )
      {
         dataProviderChangedHandler();
         _dataProviderChanged = false;
      }
      if( _selectedItemChanged )
      {
         selectedItemChangedHandler();
         _selectedItemChanged = false;
      }
   }

   [MessageHandler]
   /**
    *  @inheritDoc
    */
   override public function navigationRequestHandler( msg:INavigationRequest ):void
   {
      super.navigationRequestHandler( msg );
      if( msg.destination == supportedDestination && !dataProvider )
      {
         _log.debug( "Destination {0} requested but no data present.", msg.destination.stringAddress );
         makeDataRequest();
      }
   }

   /**
    *  @private
    */
   protected function selectedItemChangedHandler():void
   {
      _log.debug( "Selected item changed: {0}", selectedItem );
      if( _model )
         _model.selectedItem = selectedItem;
   }

   /**
    *  @private
    */
   protected function dataProviderChangedHandler():void
   {
      _log.debug( "Data provider changed.");

      if( _model )
      {
         _model.dataProvider = dataProvider;
         if( autoSelectFromDataProvider )
         {
            if( dataProvider.length > 0 )
               _model.selectedItem = dataProvider.getItemAt( 0 );
            else
               _model.selectedItem = null;
         }
      }

      var m:AbstractAsyncLookupUiModel = model as AbstractAsyncLookupUiModel;
      if( m )
      {
         var reqState:String = dataProvider.length > 0 ? LookupUiState.SEARCH_RESULTS : LookupUiState.NO_RESULTS;
         _log.debug( "Setting view model to {0} state.", reqState );
         m.uiStateName = reqState;
      }
   }


}
}
