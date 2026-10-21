# CarBridgePad

Keeps game controllers (DualSense, Xbox, MFi) working in games streamed to CarPlay with CarBridge (by leftyfl1p).

**Page:** https://adrielmendes28.github.io/CarBridgePad/ · **[Português](#português)**

## The problem

When CarBridge shows a game on the car screen, iOS considers the game to be in the background on the iPhone. The GameController framework only delivers controller input to the app in the foreground, so the controller works on the phone screen but stops working on CarPlay.

## What it does

The tweak loads into installed apps that use GameController and enables `GCController.shouldMonitorBackgroundEvents`, so games keep receiving controller input while CarBridge shows them on CarPlay. No settings.

## Notes

- **Keep the iPhone unlocked.** With the iPhone locked, iOS stops delivering controller input.
- Input lag comes mostly from the CarPlay video stream and Bluetooth, not from the tweak. Wired CarPlay helps, and so does keeping the iPhone cool.
- Tested on iPhone X, iOS 16.7.3, palera1n (rootless), CarBridge, GTA: San Andreas and a DualSense. Other setups should work, but have not been tested.

## Install

Download the `.deb` from [Releases](https://github.com/adrielmendes28/CarBridgePad/releases) and open it with Sileo, Zebra or Filza:

- `iphoneos-arm64`: rootless (palera1n, Dopamine)
- `iphoneos-arm`: rootful

Then force-quit the game and open it again.

## Build

Requires [Theos](https://theos.dev).

```sh
make package FINALPACKAGE=1                          # rootless
make package FINALPACKAGE=1 THEOS_PACKAGE_SCHEME=    # rootful
make package                                         # debug build with [CBPad] logs
```

## Português

Mantém o controle (DualSense, Xbox, MFi) funcionando nos jogos transmitidos para o CarPlay pelo CarBridge (de leftyfl1p).

Quando o CarBridge mostra o jogo na tela do carro, o iOS considera que o jogo está em segundo plano no iPhone e para de entregar os comandos do controle. O tweak ativa `GCController.shouldMonitorBackgroundEvents` nos apps instalados que usam controle, e o jogo continua recebendo os comandos no CarPlay.

- **O iPhone precisa ficar desbloqueado.** Bloqueado, o iOS para de entregar os comandos.
- O atraso vem principalmente da transmissão do CarPlay e do Bluetooth. CarPlay com cabo e o iPhone frio ajudam.
- Testado no iPhone X, iOS 16.7.3, palera1n (rootless), CarBridge, GTA: San Andreas e DualSense.

Instale o `.deb` da página [Releases](https://github.com/adrielmendes28/CarBridgePad/releases) (`arm64` = rootless, `arm` = rootful) e reabra o jogo.

## License

[MIT](LICENSE). Not affiliated with CarBridge, Apple, Sony or any game publisher.
