//
//  FKKit.h
//  FKKit
//
//  Created by Eric Morand on 03/13/2006.
//  Copyright (c) 2006 Eric Morand. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

enum {
	FKNoBorder		= 0,
	FKTopBorder     = 1,
	FKBottomBorder  = 2,
	FKLeftBorder	= 4,
	FKRightBorder	= 8,
	FKEveryBorder	= 15
};

enum {
	FKNoAngle = 0,
	FKTopLeftAngle = 1,
	FKTopRightAngle = 2,
	FKBottomRightAngle = 4,
	FKBottomLeftAngle = 8,
	FKEveryAngle = 16
};

extern NSString * FKBarcodeScannerDidBeginScanningNotification;
extern NSString * FKBarcodeScannerDidEndScanningNotification;

// ...

#import "NKDBarcodeFramework.h"

// FKKit Additions

#import "NSAlert_FKAdditions.h"
#import "NSBezierPath_FKAdditions.h"
#import "NSColor_FKAdditions.h"
#import "NSComboBoxCell_FKAdditions.h"
#import "NSDate_FKAdditions.h"
#import "NSDecimalNumber_FKAdditions.h"
#import "NSImage_FKAdditions.h"
#import "NSMutableParagraphStyle_FKAdditions.h"
#import "NSObject_FKAdditions.h"
#import "NSPointFunctions_FKAdditions.h"
#import "NSRectFunctions_FKAdditions.h"
#import "NSString_FKAdditions.h"
#import "NSTableColumn_FKAdditions.h"
#import "NSView_FKAdditions.h"
#import "NSWindow_FKAdditions.h"

// Model

#import "FKGroup.h"
#import "FKSidebarObject.h"
#import "FKSmartGroup.h"

// FKKit

#import "FKAlert.h"
#import "FKAppDelegate.h"
#import "FKManagedArrayController.h"
#import "FKBarcodeScanner.h"
#import "FKBarcodeScannersManager.h"
#import "FKButton.h"
#import "FKButtonCell.h"
#import "FKComboBox.h"
#import "FKComboBoxCell.h"
#import "FKCurrencyFormatter.h"
#import "FKDecimalFormatter.h"
#import "FKFlatRoundedButton.h"
#import "FKFlatRoundedButtonCell.h"
#import "FKFlippedView.h"
#import "FKImageAndTextCell.h"
#import "FKIntegerFormatter.h"
#import "FKView.h"
#import "FKManagedObject.h"
#import "FKManagedObjectsManager.h"
#import "FKModule.h"
#import "FKModule_BrowserStyle.h"
#import "FKModule_FullStyle.h"
#import "FKModule_MiniStyle.h"
#import "FKModuleBottomBar.h"
#import "FKModuleFilterBar.h"
#import "FKModuleGradientTextField.h"
#import "FKModuleTheme.h"
#import "FKModuleToolbar.h"
#import "FKModuleToolbarItem.h"
#import "FKMultiplePanesController.h"
#import "FKMultipleValuesProxy.h"
#import "FKNavigationToolbarItem.h"
#import "FKNumberFormatter.h"
#import "FKOutlineView.h"
#import "FKPercentFormatter.h"
#import "FKPercentTextField.h"
#import "FKPercentTextFieldCell.h"
#import "FKPlatePopUpButton.h"
#import "FKPlatePopUpButtonCell.h"
#import "FKPlusMinusView.h"
#import "FKPrintManager.h"
#import "FKSplitView.h"
#import "FKSourceListItem.h"
#import "FKSourceListGroup.h"
#import "FKSourceListSmartGroup.h"
#import "FKStackView.h"
#import "FKSubviewTableViewCell.h"
#import "FKSubviewTableViewController.h"
#import "FKTableCornerView.h"
#import "FKTableView.h"
#import "FKTableHeaderCell.h"
#import "FKTableHeaderView.h"
#import "FKTabView.h"
#import "FKTabViewItem.h"
#import "FKToolbarItemButton.h"
#import "FKToolbarItemPopUpButton.h"
#import "FKToolbarItemView.h"
#import "FKView.h"
#import "FKViewAnimation.h"
#import "FKWindow.h"