
module App.Action where

import Miso

data Action
    = ActionChangeUri URI
    | ActionHandleUri URI
    | ActionPop
    deriving (Eq)

