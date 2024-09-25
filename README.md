<h1 align="center">Eda</h1>
<h3 align="center">Magic forward for LoCyanFrp minecraft proxy.</h3>

## How it's works?

Minecraft: Java Edition use a multicast address `224.0.2.60:4445` to discover intranet minecraft LAN games.
Just proxy the proxy to local host and every 1.5s send a UDP multicast message to this address to make a "magic" forward.

## License

This project is under [Apache License 2.0](LICENSE).
