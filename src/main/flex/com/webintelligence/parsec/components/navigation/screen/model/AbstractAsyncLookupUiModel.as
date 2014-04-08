/**
 * User: Bart
 * Date: 02/04/2014
 * Time: 16:13
 * Description:
 */

package com.webintelligence.parsec.components.navigation.screen.model
{
import com.webintelligence.parsec.components.navigation.event.UIScreenModelEvent;
import com.webintelligence.parsec.components.navigation.screen.domain.LookupUiState;

[Event(name="lookupStateChanged",
      type="com.webintelligence.parsec.components.navigation.event.UIScreenModelEvent")]

public class AbstractAsyncLookupUiModel extends AbstractDataProviderModel
{

   /**
    *  @private, @see: LookupUiState
    */
   private var _uiStateName:String;

   [Bindable(event="lookupStateChanged")]
   /**
    *  @private
    */
   public function get uiStateName() : String
   {
      return _uiStateName;
   }
   /**
    *  @private
    */
   public function set uiStateName( value : String ) : void
   {
      if( value != _uiStateName )
      {
         _uiStateName = value;
         uiStateChangeHandler();
         dispatchEvent( new UIScreenModelEvent( UIScreenModelEvent.LOOKUP_STATE_CHANGED ));
      }
   }

   /**
    *  Constructor
    */
   public function AbstractAsyncLookupUiModel()
   {
      super();
      uiStateName = LookupUiState.NO_SEARCH_CRITERIA;
   }

   /**
    *  @private
    */
   protected function uiStateChangeHandler(...triggers):void
   {
      _log.debug( "UI State change to: {0}", uiStateName );
   }
}
}
