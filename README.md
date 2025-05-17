# Bitcoin Core on Tails

This deprecated repository contains a script for installing Bitcoin Core to Tails.

Currently Recommend to use:
https://github.com/BenWestgate/bails


Bitcoin Core connects to the Bitcoin peer-to-peer network to download and fully validate blocks and transactions. It also includes a wallet and graphical user interface.

Tails is a portable operating system that protects against surveillance and censorship. It connects to the Internet exclusively through the anonymity network Tor.

See Also:

[Bitcoin Core :: About](https://bitcoincore.org/en/about/)

[Full Validation - Bitcoin Core Features](https://bitcoin.org/en/bitcoin-core/features/validation)

[Excellent Privacy - Bitcoin Core Features](https://bitcoin.org/en/bitcoin-core/features/privacy)

[Tails - How Tails works](https://tails.boum.org/about/index.en.html)

[Tails (operating system) - Wikipedia](https://en.wikipedia.org/wiki/Tails_(operating_system))


## How to use this script

If you know someone you trust who uses Bitcoin Core on Tails already, you can install by cloning their Bitcoin Core on Tails skipping the initial block download.

Open these instructions on another device

![image](https://user-images.githubusercontent.com/73506583/203773811-b157925d-404f-4b91-bd86-6d2e6b454a59.png)

In the next step, you will shut down the computer. To be able to follow the rest of the instructions afterwards, you can either:

* Scan this QR code on your smartphone or tablet:

![image](https://github.com/BenWestgate/bitcoin-core-on-tails/raw/master/mobile-qr.png)
* Print these instructions on paper.

* Take note of the URL of this page:
```
https://github.com/BenWestgate/bitcoin-core-on-tail/blob/master/README.md#how-to-use-this-script
```

1. [Install Tails](https://tails.boum.org/install/index.en.html) to a USB stick or Memory Card, minimum 16 GB capacity.
      * If you know someone you trust who uses Tails already, you can [install Tails by cloning](https://tails.boum.org/install/clone/index.en.html) their Tails.
1. Start Tails and [set up an Administration Password](https://tails.boum.org/doc/first_steps/welcome_screen/administration_password/index.en.html) when the Welcome Screen appears.
      * If you installed by cloning Bitcoin Core on Tails, enter your temporary [Persistent Storage](https://tails.boum.org/doc/first_steps/welcome_screen/index.en.html#index3h1) passphrase.
1. [Connect to a local network](https://tails.boum.org/doc/anonymous_internet/networkmanager/index.en.html#index1h1).
1. [Connect to Tor](https://tails.boum.org/doc/anonymous_internet/tor/index.en.html).
      * If you *cloned* Bitcoin Core on Tails, skip to step 7.
1. Open a terminal. Choose <b>Applications ▸ Utilities ▸ Terminal</b>.
1.  Type or Paste the following in Terminal, then press Enter:
``` bash
git clone https://github.com/benwestgate/bitcoin-core-on-tails; bash */init

```
7. Follow the Instructions on Screen.
1. You're Done!
To share this free software with family and friends: Choose <b>Applications ▸ Office ▸ ₿ails ▸ Clone</b>.

## Source Code Headers

Every file containing source code must include copyright and license
information. This includes any JS/CSS files that you might be serving out to
browsers. (This is to help well-intentioned people avoid accidental copying that
doesn't comply with the license.)

MIT header:

    Copyright (c) 2022 Ben Westgate
    
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
