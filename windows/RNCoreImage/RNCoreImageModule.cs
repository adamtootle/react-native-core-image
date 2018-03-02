using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace Core.Image.RNCoreImage
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNCoreImageModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNCoreImageModule"/>.
        /// </summary>
        internal RNCoreImageModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNCoreImage";
            }
        }
    }
}
