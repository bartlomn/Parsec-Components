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
   private var _results:ArrayCollection;

   /**
    *  @private
    */
   private var _resultsChanged:Boolean;

   /**
    *  @private
    *  // todo: rename into dataProvider for consistency
    */
   public function get results() : ArrayCollection
   {
      return _results;
   }
   /**
    *  @private
    */
   public function set results( value : ArrayCollection ) : void
   {
      if( _results !=  value )
      {
         _log.debug( "Setting results." );
         _results = value;
         _resultsChanged = true;
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
      if( _resultsChanged )
      {
         dataProviderChangedHandler();
         _resultsChanged = false;
      }
   }

   [MessageHandler]
   /**
    *  @inheritDoc
    */
   override public function navigationRequestHandler( msg:INavigationRequest ):void
   {
      super.navigationRequestHandler( msg );
      if( msg.destination == supportedDestination && !results )
      {
         _log.debug( "Destination {0} requested but no data present.", msg.destination.stringAddress );
         makeDataRequest();
      }
   }

   /**
    *  @private
    */
   protected function dataProviderChangedHandler():void
   {
      _log.debug( "Data provider changed.");
      if( _model )
         _model.dataProvider = results;
      var m:AbstractAsyncLookupUiModel = model as AbstractAsyncLookupUiModel;
      if( m )
      {
         var reqState:String = results.length > 0 ? LookupUiState.SEARCH_RESULTS : LookupUiState.NO_RESULTS;
         _log.debug( "Setting view model to {0} state.", reqState );
         m.uiStateName = reqState;
      }
   }


}
}
