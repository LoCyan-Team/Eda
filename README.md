<h1 align="center">Eda</h1>
<h3 align="center">Magic forward for LoCyanFrp minecraft proxy.</h3>

## How it's works?

Minecraft: Java Edition use a multicast address `224.0.2.60:4445` to discover intranet minecraft LAN games.
Just proxy the proxy to local host and every 1.5s send a UDP multicast message to this address to make a "magic" forward.

### Note

Due to the design of the Dart SDK, the ServerSocket.close() method does not close the existing connection, and the disconnection operation does not affect the players who have joined.
For more information, please reference: dart-lang/sdk#54882

### About the name "Eda"

It's Chinese word "枝"'s pronounce in Japanese.

## License

This project is under [Apache License 2.0](LICENSE).
