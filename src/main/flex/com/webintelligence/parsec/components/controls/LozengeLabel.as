/**
 * Fortrus Mobius v2.0
 * User: Bart
 * Date: 10/05/2014
 * Time: 21:14
 * Description:
 */

package com.webintelligence.parsec.components.controls
{
import spark.components.Label;
import spark.components.supportClasses.SkinnableComponent;

public class LozengeLabel extends SkinnableComponent
{

   [SkinPart(required="true")]
   /**
    *  @private
    */
   public var labelDisplay:Label;


   /**
    *  @private
    */
   private var _text:String;

   /**
    *  @private
    */
   public function get text() : String
   {
      return labelDisplay ? labelDisplay.text : text;
   }
   /**
    *  @private
    */
   public function set text( value : String ) : void
   {
      _text = value;
      if( labelDisplay )
         labelDisplay.text = _text;
   }


   /**
    *  Constructor
    */
   public function LozengeLabel()
   {
      super();
   }


   /**
    *  @inheritDoc
    */
   override protected function partAdded( partName : String, instance : Object ) : void
   {
      super.partAdded( partName, instance );
      if( instance == labelDisplay )
         labelDisplay.text = text;
   }
}
}
