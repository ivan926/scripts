#!/bin/bash


url=https://account.wolfram.com/dl/Mathematica\?version=13.2.1\&platform=Mac\&includesDocumentation=false\&signature=09d7f5942c445782756030c9300d6386f8265c6910537efd11672b0a2b38d638bf4b845786832252bbd5eca6ef9bb8241cef34ee399e17bc51ebb540

cd ~/Downloads && curl -L -o Mathmatica.dmg $url && hdiutil attach Mathmatica.dmg 




