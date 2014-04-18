OSLibrary
---------

iOS Utility library

### Adding to your project as an static library:


1. Get the latest source from GitHub executing this command line in the root of your project(where .xcodeproj file exits):
```git submodule add git@github.com:veladan/OSLibrary.git```
2. Right-click on the your project in the navigator, click "Add Files to 'Your Project'", and browse to and select "OSLibrary.xcodeproj"
3. In your project's target settings, go to "Build Phases" -> "Link Binary With Libraries" and add libOSLibrary.a.
4.
6. In "Build Phases" add SystemConfiguration.framework, QuartzCore.framework, CoreLocation.framework and CoreData.framework to "Linked Binary Wit Libraries".
7. Include the following line in your precompiled file (.pch):  

```
#import <SystemConfiguration/SystemConfiguration.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "OSLibrary/OSLibrary.h"
```

