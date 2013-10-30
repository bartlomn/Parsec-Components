package com.webintelligence.parsec.components.module
{
import com.adobe.cairngorm.module.ILoadPolicy;

import org.spicefactory.parsley.core.context.Context;

/***************************************************************************
 *
 *   @author nowabart
 *   @created 9 Nov 2011
 *   Handles creation and parsley configuration of load policies
 *
 ***************************************************************************/

public class LoadPolicyFactory
{

   //--------------------------------------------------------------------------
   //
   //  Methods
   //
   //--------------------------------------------------------------------------

   //--------------------------------------
   //  newInstance
   //--------------------------------------
   /**
    *  creates new instance of specified load policy
    */
   public static function newInstance( type:Class, context:Context = null ):ILoadPolicy
   {
      var instance:ILoadPolicy;
      switch ( type )
      {
         case ExplicitLoadPolicy:
            instance = createExplicit( context );
            break;
      }
      return instance;
   }

   //--------------------------------------
   //  createExplicit
   //--------------------------------------
   /**
    *  @private
    */
   private static function createExplicit( context:Context ):ILoadPolicy
   {
      return new ExplicitLoadPolicy( context );
   }
}
}
