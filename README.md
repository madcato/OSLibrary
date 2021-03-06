OSLibrary
---------

[![Build Status](https://travis-ci.org/madcato/OSLibrary.svg?branch=master)](https://travis-ci.org/madcato/OSLibrary)
[![codecov.io](https://codecov.io/github/madcato/OSLibrary/coverage.svg?branch=master)](https://codecov.io/github/madcato/OSLibrary?branch=master)
[![License](https://img.shields.io/dub/l/vibe-d.svg)](https://github.com/madcato/OSLibrary/blob/master/MIT-LICENSE.txt)

iOS Utility library

### Adding to your project as an static library:


1. Get the latest source from GitHub executing this command line in the root of your project(where .xcodeproj file exits):
```git submodule add git@github.com:madcato/OSLibrary.git```
2. Right-click on the your project in the navigator, click "Add Files to 'Your Project'", and browse to and select "OSLibrary.xcodeproj"
3. In your project's target settings, go to "Build Phases" -> "Link Binary With Libraries" and add libOSLibrary.a.
4. Optional. In "Build Phases" add OSLibrary to "Target dependencies". (This is compulsory if you are going to change or add code to OSLibrary project)
5. In "Build Phases" add SystemConfiguration.framework, QuartzCore.framework, CoreLocation.framework CloudKit.framework, Security.framework and CoreData.framework to "Linked Binary Wit Libraries".
6. Include the following line in your precompiled file (.pch):  

```
#import <SystemConfiguration/SystemConfiguration.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "OSLibrary/OSLibrary.h"
```

