# Bitcoin Core on Tails

This repository contains a Tails setup script for encrypted Persistent Storage, a full node, wallet and a simple, redundant yet theft resistant paper seed backup.

See Also:

https://tails.boum.org/about/index.en.html

https://bitcoincore.org/en/about/



## How to use this script

If you know someone you trust who uses Bitcoin Core on Tails already, you can install by cloning their Bitcoin Core on Tails skipping the initial block download.

1. [Install Tails](https://tails.boum.org/install/index.en.html) to a USB stick or Memory Card, minimum 16 GB capacity.
   * If you know someone you trust who uses Tails already, you can [install Tails by cloning](https://tails.boum.org/install/clone/index.en.html) their Tails.
1. Start Tails and [set up an Administration Password](https://tails.boum.org/doc/first_steps/welcome_screen/administration_password/index.en.html) when the Welcome Screen appears.
    * If you installed by cloning Bitcoin Core on Tails, enter your temporary [Persistent Storage](https://tails.boum.org/doc/first_steps/welcome_screen/index.en.html#index3h1) passphrase.
3. [Connect to Tor](https://tails.boum.org/doc/anonymous_internet/tor/index.en.html).
4. Open the terminal. Choose <b>Applications ▸ Utilities ▸ Terminal</b> and type ```git clone https://github.com/BenWestgate/Bitcoin-Core-on-Tails ; ./init```
    * Go to next step if you installed by cloning Bitcoin Core on Tails. 
5. Follow the Instructions on Screen.
6. You're Done!
To share this free software with family and friends: Choose <b>Applications ▸ Favorites ▸ Clone Bitcoin Core on Tails</b>.

``` shell
git clone https://github.com/google/new-project
mkdir my-new-thing
cd my-new-thing
git init
cp -r ../new-project/* ../new-project/.github .
git add *
git commit -a -m 'Boilerplate for new Google open source project'
```

## Source Code Headers

Every file containing source code must include copyright and license
information. This includes any JS/CSS files that you might be serving out to
browsers. (This is to help well-intentioned people avoid accidental copying that
doesn't comply with the license.)

Apache header:

    Copyright 2022 Google LLC

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
