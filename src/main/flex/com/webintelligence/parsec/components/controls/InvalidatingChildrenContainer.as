/**
 * Fortrus Mobius v2.0
 * User: Bart
 * Date: 03/04/2014
 * Time: 12:18
 * Description:
 */

package com.webintelligence.parsec.components.controls
{
import spark.components.SkinnableContainer;

public class InvalidatingChildrenContainer extends SkinnableContainer
{

   /**
    *  @private
    */
   private var _childrenChanged:Boolean;

   /**
    *  Constructor
    */
   public function InvalidatingChildrenContainer()
   {
      super();
   }

   /**
    *  @inheritDoc
    */
   override protected function commitProperties() : void
   {
      super.commitProperties();
      if( _childrenChanged )
      {
         updateChildren();
         _childrenChanged = false;
      }
   }

   /**
    *  @private
    */
   protected function updateChildren():void
   {
      // abstract
   }

   /**
    *  @private
    */
   protected function invalidateChildren():void
   {
      _childrenChanged = true;
      invalidateProperties();
   }
}
}
