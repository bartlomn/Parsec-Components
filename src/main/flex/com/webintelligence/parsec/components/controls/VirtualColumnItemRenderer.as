/**
 * User: Bart
 * Date: 03/04/2014
 * Time: 12:07
 * Description:
 */

package com.webintelligence.parsec.components.controls
{
import com.webintelligence.parsec.components.controls.domain.VirtualColumn;

import flash.utils.Dictionary;

import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;

import spark.components.Label;

public class VirtualColumnItemRenderer extends InteractiveSkinnableItemRenderer
{

   /**
    *  @private
    */
   protected static var LOG:Logger = LogContext.getLogger( VirtualColumnItemRenderer );

   /**
    *  @private
    */
   private var _columnToChildMap:Dictionary;

   /**
    *  @private
    */
   private var _columns:Vector.<VirtualColumn>;

   /**
    *  @private
    */
   private var _columnsChanged:Boolean;

   /**
    *  @private
    */
   public function get columns() : Vector.<VirtualColumn>
   {
      return _columns;
   }
   /**
    *  @private
    */
   public function set columns( value : Vector.<VirtualColumn> ) : void
   {
      if( value != _columns )
      {
         _columns = value;
         _columnsChanged = true;
         invalidateProperties();
      }
   }


   /**
    *  Constructor
    */
   public function VirtualColumnItemRenderer()
   {
      super();
   }


   /**
    *  @inheritDoc
    */
   override protected function commitProperties() : void
   {
      super.commitProperties();
      if( _columnsChanged )
      {
         invalidateChildren();
         _columnsChanged = false;
      }
   }

   /**
    *  @inheritDoc
    */
   override protected function dataChangedHandler() : void
   {
      super.dataChangedHandler();
      _columnToChildMap ? updateColumnLabels() : updateChildren();
   }

   /**
    *  @inheritDoc
    */
   override protected function updateChildren() : void
   {
      super.updateChildren();
      removeAllElements();
      _columnToChildMap = new Dictionary();
      if( columns )
      {
         for each( var vc:VirtualColumn in columns )
         {
            var label:Label = new Label();
            label.percentWidth = 100 / columns.length;
            addElement( label );
            _columnToChildMap[ vc ] = label;
         }
         updateColumnLabels();
      }
   }

   /**
    *  @private
    */
   protected function updateColumnLabels():void
   {
      if( columns && _columnToChildMap )
      {
         for each( var vc:VirtualColumn in columns )
         {
            var columnLabel:Label = _columnToChildMap[ vc ] as Label;
            if( columnLabel )
            {
               columnLabel.text = vc.getLabelText( data );
               columnLabel.showTruncationTip = true;
               columnLabel.maxDisplayedLines = 1;
               if( vc.styleName )
                  columnLabel.styleName = vc.styleName;
            }
            else
               LOG.error( "Cannot find component for given column ({0}) definition", vc.bindToProperty );
         }
         validateNow();
      }
   }
}
}
