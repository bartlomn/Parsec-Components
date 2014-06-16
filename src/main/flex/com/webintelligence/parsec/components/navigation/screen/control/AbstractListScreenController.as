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
import mx.events.CollectionEvent;

public class AbstractListScreenController extends AbstractModelDrivenScreenController
{


   /**
    *  @private
    */
   private var _requireUpdateAfterCollectionRefresh:Boolean;

   //----------------------------------
   //  autoSelectFromDataProvider
   //----------------------------------

   /**
    *  @private
    */
   protected var autoSelectFromDataProvider:Boolean;

   //----------------------------------
   //  selectedItem
   //----------------------------------

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

   //----------------------------------
   //  dataProvider
   //----------------------------------

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
         if( dataProvider )
            dataProvider.removeEventListener( CollectionEvent.COLLECTION_CHANGE, dataProvider_collectionChangedHandler );

         _log.debug( "Setting results." );
         _dataProvider = value;
         _dataProviderChanged = true;
         invalidateProperties();
      }
   }

   //----------------------------------
   //  model
   //----------------------------------


   /**
    *  @private
    */
   private var _model:AbstractDataProviderModel;

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
      if( _requireUpdateAfterCollectionRefresh )
      {
         collectionRefreshedHandler();
         _requireUpdateAfterCollectionRefresh = false;
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

      if( dataProvider )
         dataProvider.addEventListener( CollectionEvent.COLLECTION_CHANGE, dataProvider_collectionChangedHandler );

      if( _model )
      {
         _model.dataProvider = dataProvider;
         if( autoSelectFromDataProvider )
         {
            if( dataProvider.length > 0 )
               selectedItem = dataProvider.getItemAt( 0 );
            else
               selectedItem = null;
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

   /**
    *  @private
    */
   protected function collectionRefreshedHandler():void
   {
      // check if selected item have not been removed from the collection
      if( selectedItem && dataProvider && dataProvider.getItemIndex( selectedItem ) == -1 )
      {
         if( dataProvider.length > 0 )
            selectedItem = dataProvider.getItemAt( 0 );
         else
            selectedItem = null;
      }
      if( !selectedItem && autoSelectFromDataProvider && dataProvider && dataProvider.length > 0 )
         selectedItem = dataProvider.getItemAt( 0 );
   }

   /**
    *  @private
    */
   private function dataProvider_collectionChangedHandler( event:CollectionEvent )
   {
      _requireUpdateAfterCollectionRefresh = true;
      invalidateProperties();
   }


}
}
