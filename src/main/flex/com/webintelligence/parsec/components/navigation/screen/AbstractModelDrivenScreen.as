/**
 * User: Bart
 * Date: 31/03/2014
 * Time: 17:58
 * Description:
 */

package com.webintelligence.parsec.components.navigation.screen
{
import com.adobe.errors.IllegalStateError;
import com.webintelligence.parsec.components.navigation.event.UINavigatorScreenEvent;

import flash.display.DisplayObject;

import flash.events.IEventDispatcher;

import flash.utils.Dictionary;

import mx.binding.utils.BindingUtils;

import mx.binding.utils.ChangeWatcher;

import org.spicefactory.parsley.view.FastInject;

/**
 *  Dispatched after model changes
 */
[Event( name = "uiModelChanged",
      type = "com.webintelligence.parsec.components.navigation.event.UINavigatorScreenEvent" )]

public class AbstractModelDrivenScreen extends AbstractUINavigatorScreen
{

   /**
    *  @private
    */
   private var _modelListeners:Dictionary;

   /**
    *  @private
    */
   private var _modelWatchers:Array;

   /**
    *  @private
    */
   protected var modelClass:Class;

   /**
    *  @private
    */
   private var _model:Object;

   /**
    *  @private
    */
   private var _modelChanged:Boolean;

   [Bindable(event="uiModelChanged")]
   /**
    *  @private
    */
   public function get model() : Object
   {
      return _model;
   }
   /**
    *  @private
    */
   public function set model( value : Object ) : void
   {
      if( _model != value )
      {
         updateModelListeners();
         _model = value;
         _modelChanged = true;
         invalidateProperties();
      }
   }


   /**
    *  Constructor
    */
   public function AbstractModelDrivenScreen( logTarget:Class )
   {
      super( logTarget );
   }


   /**
    *  @inheritDoc
    */
   override protected function commitProperties() : void
   {
      super.commitProperties();
      if( _modelChanged )
      {
         modelChangedHandler();
         _modelChanged = false;
      }
   }

   /**
    *  @inheritDoc
    */
   override protected function removedHandler( view : DisplayObject ) : void
   {
      super.removedHandler( view );
      updateModelListeners();
      model = null;
   }

   /**
    *  @inheritDoc
    */
   override protected function addedHandler( view:DisplayObject ):void
   {
      super.addedHandler( view );
      if( modelClass && !model )
      {
         FastInject
               .view( this )
               .property( "model" )
               .type( modelClass )
               .execute();
         _modelChanged = true;
         invalidateProperties();
      }
   }

   /**
    *  @private
    */
   protected function callFromModelProperty( target:Function, chain:Object ):ChangeWatcher
   {
      if( target != null )
      {
         if( chain is Array && chain[ 0 ] && chain[ 0 ] is String && model[ chain[ 0 ]])
            target.call( null, model[ chain[ 0 ]] );
         var cw:ChangeWatcher = BindingUtils.bindSetter( target, model, chain );
         _modelWatchers.push( cw );
         return cw;
      }
      return null;
   }

   /**
    *  @private
    */
   protected function bindToModelProperty( target:Object, property:String, chain:Object ):ChangeWatcher
   {
      if( target && target.hasOwnProperty( property ) )
      {
         var cw:ChangeWatcher = BindingUtils.bindProperty( target, property, model, chain );
         _modelWatchers.push( cw );
         return cw;
      }
      return null;
   }

   /**
    *  @private
    */
   protected function listenToModelEvent( type:String, handler:Function ):void
   {
      if( _model && _model is IEventDispatcher )
      {
         if( _modelListeners[ type ])
            throw new IllegalStateError( "Multiple listeners of single type not allowed" );
         _modelListeners[ type ] = handler;
         ( _model as IEventDispatcher ).addEventListener( type, handler );
      }
   }

   /**
    *  Executed after model is changed
    */
   protected function modelChangedHandler():void
   {
      dispatchEvent( new UINavigatorScreenEvent( UINavigatorScreenEvent.MODEL_CHANGED ));
   }

   /**
    *  @private todo: rename - clearModelListeners
    */
   private function updateModelListeners():void
   {
      if( _model )
      {
         for (var type:String in _modelListeners)
         {
            ( _model as IEventDispatcher ).removeEventListener( type, _modelListeners[ type ]);
         }
         for each( var cw:ChangeWatcher in _modelWatchers )
            cw.unwatch();
      }
      _modelListeners = new Dictionary();
      _modelWatchers = [];
   }

}
}
