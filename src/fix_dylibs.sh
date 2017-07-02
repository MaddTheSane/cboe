#!/bin/sh

#  fix_dylibs.sh
#  BoE
#
#  Created by Celtic Minstrel on 14-04-17.
#

echo Fixing boost dylib install names...

EXEPATH=@rpath/Frameworks
BOEPATH="$BUILT_PRODUCTS_DIR/$EXECUTABLE_PATH"
BSYPATH="$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/libboost_system.dylib"
BFSPATH="$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/libboost_filesystem.dylib"
BTHPATH="$BUILT_PRODUCTS_DIR/$FRAMEWORKS_FOLDER_PATH/libboost_thread.dylib"

# Update references in the executable file
install_name_tool -change /usr/local/lib/libboost_system.dylib "$EXEPATH/libboost_system.dylib" \
-change /usr/local/lib/libboost_filesystem.dylib "$EXEPATH/libboost_filesystem.dylib" \
-change /usr/local/lib/libboost_thread.dylib "$EXEPATH/libboost_thread.dylib" "$BOEPATH"

# Update references within Boost
install_name_tool -change /usr/local/lib/libboost_system.dylib "$EXEPATH/libboost_system.dylib" -id "$EXEPATH/libboost_filesystem.dylib" "$BFSPATH"
install_name_tool -change /usr/local/lib/libboost_system.dylib "$EXEPATH/libboost_system.dylib" -id "$EXEPATH/libboost_thread.dylib" "$BTHPATH"
install_name_tool -id "$EXEPATH/libboost_system.dylib" "$BSYPATH"
