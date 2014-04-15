/**
 * User: Bart
 * Date: 13/04/2014
 * Time: 15:04
 * Description:
 */

package com.webintelligence.parsec.components.controls.grid.factory
{
import com.webintelligence.parsec.components.controls.grid.domain.GridColumnDefinition;
import com.webintelligence.parsec.components.controls.grid.event.GridColumnFactoryEvent;
import com.webintelligence.parsec.core.invalidating.InvalidatingEventDispatcher;

import mx.collections.ArrayList;
import mx.core.ClassFactory;

import spark.components.gridClasses.GridColumn;

[DefaultProperty("columnDefinitions")]
[Event(name="gridColumnsChanged",
      type="com.webintelligence.parsec.components.controls.grid.event.GridColumnFactoryEvent")]

public class DataGridColumnFactory extends InvalidatingEventDispatcher
{

   /**
    *  @private
    */
   private var _columnDefinitions:Array;

   /**
    *  @private
    */
   private var _columnDefinitionsChanged:Boolean;

   [ArrayElementType(elementType="com.webintelligence.parsec.components.controls.grid.domain.GridColumnDefinition")]
   /**
    *  @private
    */
   public function get columnDefinitions() : Array
   {
      return _columnDefinitions;
   }
   /**
    *  @private
    */
   public function set columnDefinitions( value : Array ) : void
   {
      if( _columnDefinitions != value )
      {
         _columnDefinitions = value;
         _columnDefinitionsChanged = true;
         invalidateProperties();
      }
   }

   /**
    *  @private
    */
   private var _columns:ArrayList;

   [ArrayElementType(elementType="spark.components.gridClasses.GridColumn")]
   [Bindable(event="gridColumnsChanged")]
   /**
    *  @private
    */
   public function get columns() : ArrayList
   {
      return _columns;
   }


   /**
    *  Constructor
    */
   public function DataGridColumnFactory()
   {
      super();
   }


   [Init]
   /**
    *  @private
    */
   public function initHandler():void
   {
      if( !isInitialized )
         initialize();
   }

   /**
    *  @inheritDoc
    */
   override protected function commitProperties() : void
   {
      super.commitProperties();
      if( _columnDefinitionsChanged )
      {
         columnDefinitionsChangedHandler();
         _columnDefinitionsChanged = false;
      }
   }

   /**
    *  @private
    */
   protected function columnDefinitionsChangedHandler():void
   {
      _columns = new ArrayList();
      for each( var cd:GridColumnDefinition in columnDefinitions )
      {
         _columns.addItem( createColumnFromDefinition( cd ));
      }
      dispatchEvent( new GridColumnFactoryEvent( GridColumnFactoryEvent.COLUMNS_CHANGED ));
   }

   /**
    *  @private
    */
   protected function createColumnFromDefinition( cd:GridColumnDefinition ):GridColumn
   {
      var column:GridColumn = new GridColumn();
      if( cd.dataField )
         column.dataField = cd.dataField;
      if( cd.headerText )
         column.headerText = cd.headerText;
      if( cd.formatter )
         column.formatter = cd.formatter;
      if( cd.itemRendererFunction != null )
         column.itemRendererFunction = cd.itemRendererFunction;
      if( cd.headerRenderer )
         column.headerRenderer = new ClassFactory( cd.headerRenderer );
      if( cd.explicitWidth )
         column.width = cd.explicitWidth;

      return column;
   }
}
}
