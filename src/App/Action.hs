
module App.Action where

import Miso
import Miso.Router qualified as R -- TODO

import Domain.Hero (Hero)

data Action
    = ActionChangeUri R.URI
    | ActionHandleUri R.URI
    | ActionPopHeroes
    | ActionError MisoString
    | ActionFetchFail
    | ActionFetchHeroes
    | ActionSetHeroes [Hero]
    deriving (Eq)

