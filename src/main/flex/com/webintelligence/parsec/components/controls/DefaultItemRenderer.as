/**
 * Fortrus Mobius v2.0
 * User: Bart
 * Date: 24/06/2014
 * Time: 03:34
 * Description:
 */

package com.webintelligence.parsec.components.controls
{
import com.bnowak.integration.ficon.UIIcon;

import spark.components.supportClasses.TextBase;

public class DefaultItemRenderer extends InteractiveSkinnableItemRenderer
{

   [SkinPart(required="false")]
   /**
    *  @private
    */
   public var labelDisplay:TextBase;

   [SkinPart(required="false")]
   /**
    *  @private
    */
   public var iconDisplay:UIIcon;

   /**
    *  Constructor
    */
   public function DefaultItemRenderer()
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
         labelDisplay.text = label;
      if( instance == iconDisplay )
         iconDisplay.visible = iconDisplay.includeInLayout = false;
   }

   /**
    *  @inheritDoc
    */
   override protected function labelChangedHandler() : void
   {
      super.labelChangedHandler();
      if( labelDisplay )
         labelDisplay.text = label;
   }

   /**
    *  @inheritDoc
    */
   override protected function dataChangedHandler() : void
   {
      super.dataChangedHandler();
      if( data && data.hasOwnProperty( "icon" ) && data.icon != null && data.icon is Function )
      {
         iconDisplay.visible = iconDisplay.includeInLayout = true;
         iconDisplay.iconMethod = data.icon;
      }
      else
      {
         iconDisplay.visible = iconDisplay.includeInLayout = false;
      }
   }
}
}
