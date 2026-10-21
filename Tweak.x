#import <UIKit/UIKit.h>
#import <GameController/GameController.h>

#if DEBUG
#define CBLog(fmt, ...) NSLog(@"[CBPad] " fmt, ##__VA_ARGS__)
#else
#define CBLog(fmt, ...) do {} while (0)
#endif

// Build de debug (make package) inclui os logs de diagnóstico; o final (FINALPACKAGE=1) só o necessário.

static NSString *CBAppState(void) {
	if (!NSThread.isMainThread) return @"?";
	switch (UIApplication.sharedApplication.applicationState) {
		case UIApplicationStateActive: return @"active";
		case UIApplicationStateInactive: return @"inactive";
		default: return @"background";
	}
}

// 1) Pede ao GameController para continuar entregando eventos com o app fora de foco.
%hook GCController
+ (BOOL)shouldMonitorBackgroundEvents {
	return YES;
}
%end

// 2) Diagnóstico: registra (sem alterar) os eventos que chegam ao handler do jogo.
%group CBDebug
%hook GCExtendedGamepad
- (void)setValueChangedHandler:(GCExtendedGamepadValueChangedHandler)handler {
	if (!handler) {
		%orig;
		return;
	}
	GCExtendedGamepadValueChangedHandler wrapped = ^(GCExtendedGamepad *gamepad, GCControllerElement *element) {
		static NSUInteger count = 0;
		if (count++ < 100) CBLog(@"handler: %@ (app %@)", element.localizedName ?: element, CBAppState());
		handler(gamepad, element);
	};
	%orig(wrapped);
}
%end
%end

%ctor {
	// O filtro carrega em tudo que usa GameController; só interessa em apps instalados (jogos),
	// não em processos do sistema.
	if (![NSBundle.mainBundle.bundlePath containsString:@"/containers/Bundle/Application/"]) return;
	CBLog(@"carregado em %@", NSBundle.mainBundle.bundleIdentifier);
	if (@available(iOS 14.5, *)) GCController.shouldMonitorBackgroundEvents = YES;

	%init;
#if DEBUG
	%init(CBDebug);

	NSNotificationCenter *nc = NSNotificationCenter.defaultCenter;
	[nc addObserverForName:GCControllerDidConnectNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *n) {
		CBLog(@"controle conectado: %@", [n.object vendorName]);
	}];
	[nc addObserverForName:GCControllerDidDisconnectNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *n) {
		CBLog(@"controle desconectado");
	}];
	for (NSNotificationName name in @[UIApplicationDidBecomeActiveNotification, UIApplicationWillResignActiveNotification,
	                                  UIApplicationDidEnterBackgroundNotification, UIApplicationWillEnterForegroundNotification]) {
		[nc addObserverForName:name object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *n) {
			CBLog(@"%@ -> app %@", n.name, CBAppState());
		}];
	}

	// 3) Diagnóstico por polling (jogos que leem o estado em vez de usar handler):
	//    loga quando o botão A (X no DualSense) muda, só leitura.
	__block BOOL lastA = NO;
	[NSTimer scheduledTimerWithTimeInterval:0.25 repeats:YES block:^(NSTimer *t) {
		GCExtendedGamepad *pad = GCController.controllers.firstObject.extendedGamepad;
		BOOL a = pad.buttonA.isPressed;
		if (a != lastA) {
			lastA = a;
			CBLog(@"polling: botão A %@ (app %@)", a ? @"pressionado" : @"solto", CBAppState());
		}
	}];
#endif
}
