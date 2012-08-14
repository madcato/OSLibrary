OSLibrary
---------

iOS Utility library

### Adding to your project as an static library:


1. Get the latest source from GitHub. Right-click on the your project in the navigator, click "Add Files to 'Your Project'", and browse to and select "OSLibrary.xcodeproj"
2. In your project's target settings, go to "Build Phases" -> "Link Binary With Libraries" and add libOSLibrary.a.
3. In the target, select the "Build Settings" tab and ensure "Always Search User Paths" is set to YES, and "User Header Search Paths" is set to the recursive absolute or relative path that points to a directory under which the OSLibrary code is stored. In the file layout of the OSLibrary project, a simple ./<_PROJECT NAME_>/OSLibrary/** works.
4. Also in the target, select "Build Setting" and set in "Library Search Paths" the following text: $(SRCROOT)/<_PROJECT NAME_>/OSLibrary . This activates the code completion and coloring.
5. In "Build Phases" add SystemConfiguration.framework, QuartzCore.framework, CoreLocation.framework and CoreData.framework to "Linked Binary Wit Libraries".
6. Include the following line in your precompiled file (.pch):  

	```#import <OSLibrary.h>```

