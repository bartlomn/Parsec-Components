/**
 * User: Bart
 * Date: 02/04/2014
 * Time: 16:40
 * Description:
 */

package com.webintelligence.parsec.components.navigation.screen
{
import com.webintelligence.parsec.components.navigation.screen.model.AbstractAsyncLookupUiModel;

public class AbstractAsyncUIScreen extends AbstractFocusableScreen
{

   /**
    *  @private
    */
   private var _uiStateName:String;

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
      if( value != uiStateName )
      {
         _uiStateName = value;
         uiStateChangeHandler();
         invalidateSkinState();
      }
   }

   /**
    *  Constructor
    */
   public function AbstractAsyncUIScreen( logTarget : Class )
   {
      super( logTarget );
   }

   /**
    *  @inheritDoc
    */
   override protected function modelChangedHandler() : void
   {
      super.modelChangedHandler();
      if( model is AbstractAsyncLookupUiModel )
         bindToModelProperty( this, "uiStateName", [ "uiStateName" ]);
   }

   /**
    *  @inheritDoc
    */
   override protected function getCurrentSkinState() : String
   {
      return uiStateName || super.getCurrentSkinState();
   }

   /**
    *  @private
    */
   protected function uiStateChangeHandler():void
   {
      // abstract
   }
}
}
